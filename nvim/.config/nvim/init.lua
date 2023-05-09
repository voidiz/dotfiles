------------------------------------------
-- Miscellaneous

-- Use system clipboard
vim.opt.clipboard:append({ "unnamed", "unnamedplus" })

-- Disable netrw (built-in file explorer) since we use nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
------------------------------------------
-- Formatting (see :help nvim-defaults)

vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.scrolloff = 3
------------------------------------------
-- Style

if vim.fn.has("termguicolors") then
    vim.o.termguicolors = true
end

-- Hide tilde empty line
vim.o.fillchars = "eob: "
------------------------------------------
-- GO
require("config")
