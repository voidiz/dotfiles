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

local M = {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
        { "<C-p>", git_files_fallback, desc = "Git Files" },
        { "<leader>fi", "<cmd>Telescope live_grep<CR>", desc = "Live Grep" },
        { "<leader>fb", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Buffer Fuzzy Find" },
        { "<leader>ff", "<cmd>Telescope resume<CR>", desc = "Resume" },
    },
    tag = "0.1.4",
    dependencies = { "nvim-lua/plenary.nvim" },
}

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
end

return M
