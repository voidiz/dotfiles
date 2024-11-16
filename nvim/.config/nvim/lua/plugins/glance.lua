return {
    "dnlhc/glance.nvim",
    cmd = "Glance",
    keys = {
        {
            "gd",
            "<cmd>Glance definitions<CR>",
            desc = "LSP Definitions (Glance)",
        },
        {
            "gr",
            "<cmd>Glance references<CR>",
            desc = "LSP References (Glance)",
        },
        {
            "gi",
            "<cmd>Glance implementations<CR>",
            desc = "LSP Implementations (Glance)",
        },
    },
}
