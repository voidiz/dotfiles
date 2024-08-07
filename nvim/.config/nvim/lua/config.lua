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

-- Automatically source all files in plugins/
require("lazy").setup("plugins", {
    -- defaults = { lazy = true },
    install = { colorscheme = { "rose-pine" } },
    -- Disable annoying change notification
    change_detection = { notify = false },
    -- debug = true,
})
---------------------------------------
-- Configurations

-- Autocmds
require("autocmds")
