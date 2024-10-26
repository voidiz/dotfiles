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
