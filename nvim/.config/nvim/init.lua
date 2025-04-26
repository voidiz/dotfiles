------------------------------------------
-- Miscellaneous

-- Use system clipboard
vim.opt.clipboard:append({ "unnamed", "unnamedplus" })

-- Always copy to the system clipboard through OSC 52.
-- (Requires a terminal that supports it)
local function paste()
    return {
        vim.split(vim.fn.getreg(""), "\n"),
        vim.fn.getregtype(""),
    }
end
vim.g.clipboard = {
    name = "OSC 52",
    copy = {
        ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
        ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
        ["+"] = paste,
        ["*"] = paste,
    },
}

-- Leader key
vim.g.mapleader = " "
------------------------------------------
-- Formatting (see :help nvim-defaults)

vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.breakindent = true
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.scrolloff = 3
------------------------------------------
-- Style

if vim.fn.has("termguicolors") then
    vim.o.termguicolors = true
end

-- Fillchars (empty spaces get filled with these characters)
vim.opt.fillchars = {
    vert = "▕", -- alternatives │
    fold = " ",
    eob = " ", -- suppress ~ at EndOfBuffer
    diff = "╱", -- alternatives = ⣿ ░ ─ ╱
    msgsep = "‾",
    foldopen = "▾",
    foldsep = "│",
    foldclose = "▸",
}

-- Hide cmdline
vim.o.cmdheight = 0

-- Always use one signcolumn to prevent layout shifts
vim.o.signcolumn = "yes:1"

--- Tabline with only filename
function _G.MinimalTabline()
    local s = ""
    for i = 1, vim.fn.tabpagenr("$") do
        local winnr = vim.fn.tabpagewinnr(i)
        local buflist = vim.fn.tabpagebuflist(i)
        local bufnr = buflist[winnr]
        local fname = vim.fn.bufname(bufnr)
        local label = fname ~= "" and vim.fn.fnamemodify(fname, ":t") or "[No Name]"

        if i == vim.fn.tabpagenr() then
            s = s .. "%#TabLineSel#" .. " " .. i .. ": " .. label .. " "
        else
            s = s .. "%#TabLine#" .. " " .. i .. ": " .. label .. " "
        end
    end
    return s .. "%#TabLineFill#"
end
vim.opt.tabline = "%!v:lua.MinimalTabline()"
------------------------------------------
-- GO
require("config")
