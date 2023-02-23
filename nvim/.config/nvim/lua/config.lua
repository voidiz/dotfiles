---------------------------------------
-- lazy.nvim setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
    -- defaults = { lazy = true },
    install = { colorscheme = { "ayu" } },
    -- Automatically check of plugin updates
    checker = { enabled = true },
    -- Disable annoying change notification
    change_detection = { notify = false },
    -- debug = true,
})
---------------------------------------
-- Configurations

-- Autocmds
require("autocmds")

-- Treesitter (syntax, indent, ...)
require("plugins.treesitter")

-- Lsp + statusline
require("plugins.lsp")

-- Auto completion
require("plugins.cmp")

-- Autopairs
require("plugins.autopairs")

-- File explorer
require("plugins.tree")

-- Statusline
require("plugins.statusline")
