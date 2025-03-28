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

-- Hide cmdline
vim.o.cmdheight = 0

-- Always use one signcolumn to prevent layout shifts
vim.o.signcolumn = "yes:1"
------------------------------------------
-- GO
require("config")
