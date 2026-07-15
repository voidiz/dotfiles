local function register_keymaps()
    local opts = { noremap = true, silent = true }

    -- This will make the keymaps work in most modes, but switching tabs will
    -- automatically put us in normal mode again.
    local modes = { "n", "i", "t", "v" }

    -- Tab navigation
    vim.keymap.set(modes, "<M-h>", "<cmd>tabprevious<CR>", opts)
    vim.keymap.set(modes, "<M-j>", "<cmd>tabnew<CR>", opts)
    vim.keymap.set(modes, "<M-l>", "<cmd>tabnext<CR>", opts)

    -- Reorder tabs
    vim.keymap.set(modes, "<M-H>", "<cmd>tabmove -1<CR>", opts)
    vim.keymap.set(modes, "<M-L>", "<cmd>tabmove +1<CR>", opts)

    -- Go to n-th tab
    for i = 1, 9 do
        vim.keymap.set(modes, string.format("<M-%d>", i), string.format("<cmd>tabnext %d<CR>", i), opts)
    end
end

-- register_keymaps()
