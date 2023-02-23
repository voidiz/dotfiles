local M = {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.1",
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

    local builtin = require("telescope.builtin")

    vim.keymap.set("n", "<C-p>", builtin.git_files, {})
    vim.keymap.set("n", "<leader>fi", builtin.live_grep, {})
    vim.keymap.set("n", "<leader>fb", builtin.current_buffer_fuzzy_find, {})
    vim.keymap.set("n", "<leader>ff", builtin.resume, {})
end

return M
