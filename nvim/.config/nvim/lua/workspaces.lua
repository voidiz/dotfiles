-- List of workspaces, potentially loaded from session files.
local workspaces = {}

-- List of buffers per workspace. Used to keep track of which buffers to hide
-- and show when switching workspaces to avoid killing them (to keep buffers
-- like :term alive).
local workspace_bufs = {}

-- Current buffer
local current = "default"

-- Directory for session files
local session_dir = vim.fn.stdpath("data") .. "/workspaces/"

local function session_file(name)
    return session_dir .. name .. ".vim"
end

local function load_existing_sessions()
    local files = vim.fn.glob(session_dir .. "*.vim", false, true)
    for _, f in ipairs(files) do
        -- Filename (no directory path) without extension
        local name = vim.fn.fnamemodify(f, ":t:r")

        if name ~= "default" and not workspaces[name] then
            for line in io.lines(f) do
                -- Extract the cwd of the workspace
                local dir = line:match("^cd%s+(.+)")
                if dir then
                    workspaces[name] = dir
                    break
                end
            end
        end
    end
end

local function save_current()
    if current then
        vim.cmd("mksession! " .. vim.fn.fnameescape(session_file(current)))
    end
end

local function switch(name)
    save_current()

    -- Track default's cwd when leaving it and create a temporary workspace for
    -- it.
    if current and not workspaces[current] then
        workspaces[current] = vim.fn.getcwd()
    end

    if current then
        workspace_bufs[current] = vim.api.nvim_list_bufs()
    end

    -- Kill all tabs and windows, and mark all buffers as unlisted without
    -- killing them so we can list them again later.
    vim.cmd("silent! tabonly | only")
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
            vim.bo[buf].buflisted = false
        end
    end

    local f = session_file(name)
    if vim.fn.filereadable(f) == 1 then
        vim.cmd("source " .. vim.fn.fnameescape(f))
    elseif workspaces[name] then
        vim.cmd("cd " .. vim.fn.fnameescape(workspaces[name]))
        vim.cmd("enew")
    end

    if workspace_bufs[name] then
        for _, buf in ipairs(workspace_bufs[name]) do
            if vim.api.nvim_buf_is_valid(buf) then
                vim.bo[buf].buflisted = true
            end
        end
    end

    -- TODO: Remove this workaround when on nvim 0.13 and update nvim-tree
    -- config
    local ok, nvimtree_session = pcall(require, "nvim-tree.session")
    if ok then
        nvimtree_session.restore()
    end

    current = name
end

local function create(name, dir)
    workspaces[name] = vim.fn.expand(dir)
    switch(name)
end

local function delete(name)
    if name == current then
        vim.notify("Can't delete active workspace", vim.log.levels.WARN)
        return
    end

    local f = session_file(name)
    if vim.fn.filereadable(f) == 1 then
        vim.fn.delete(f)
    end

    workspace_bufs[name] = nil
    workspaces[name] = nil
end

local function pick()
    local items = {}

    for name, dir in pairs(workspaces) do
        table.insert(items, {
            text = name,
            file = dir,
        })
    end

    Snacks.picker({
        title = "Workspaces",
        items = items,
        -- Show the session name as the picker item but show the directory
        -- structure of each session's cwd as the preview
        format = "text",
        preview = "directory",
        confirm = function(picker, item)
            picker:close()
            if item then
                switch(item.text)
            end
        end,
        actions = {
            delete_workspace = function(picker, item)
                if item then
                    delete(item.text)

                    for i, v in ipairs(items) do
                        if v.text == item.text then
                            table.remove(items, i)
                            break
                        end
                    end

                    picker:find()
                end
            end,
        },
        win = {
            input = {
                keys = {
                    ["<C-d>"] = { "delete_workspace", mode = { "n", "i" }, desc = "Delete Workspace" },
                },
            },
        },
    })
end

-- Keybindings
local function register_keybindings()
    vim.keymap.set("n", "<leader>ws", pick, { desc = "Switch Workspace" })
    vim.keymap.set("n", "<leader>wn", function()
        vim.ui.input({ prompt = "Name: " }, function(name)
            if not name then
                return
            end
            vim.ui.input({ prompt = "Dir: ", completion = "dir" }, function(dir)
                if not dir then
                    return
                end
                create(name, dir)
            end)
        end)
    end, { desc = "New Workspace" })
end

local function register_autocmds()
    -- Save workspace/session when exiting vim
    vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = save_current,
    })
end

local function main()
    vim.fn.mkdir(session_dir, "p")

    load_existing_sessions()
    register_keybindings()
    register_autocmds()
end

main()
