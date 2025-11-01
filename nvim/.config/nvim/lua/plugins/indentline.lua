return {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufRead",
    main = "ibl",

    ---@module "ibl"
    ---@type ibl.config
    opts = {
        debounce = 500,
        whitespace = {
            remove_blankline_trail = false,
        },
        scope = {
            enabled = false,
        },
    },
}
