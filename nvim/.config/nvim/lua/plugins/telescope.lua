local M = {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.4",
    dependencies = { "nvim-lua/plenary.nvim" },
}

-- Open git files, or fallback to find files if not in a git directory
local function git_files_fallback()
    local builtin = require("telescope.builtin")
    vim.fn.system("git rev-parse --is-inside-work-tree")
    if vim.v.shell_error == 0 then
        builtin.git_files()
    else
        builtin.find_files()
    end
end

function M.config()
    local actions = require("telescope.actions")
    require("telescope").setup({
        defaults = {
            mappings = {
                i = {
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-k>"] = actions.move_selection_previous,
                },
            },
        },
    })

    local builtin = require("telescope.builtin")

    vim.keymap.set("n", "<C-p>", git_files_fallback, {})
    vim.keymap.set("n", "<leader>fi", builtin.live_grep, {})
    vim.keymap.set("n", "<leader>fb", builtin.current_buffer_fuzzy_find, {})
    vim.keymap.set("n", "<leader>ff", builtin.resume, {})
end

return M
