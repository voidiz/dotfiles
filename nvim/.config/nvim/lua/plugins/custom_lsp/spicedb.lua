local util = require("lspconfig/util")

return {
    default_config = {
        cmd = { "spicedb", "lsp" },
        filetypes = { "authzed" },
        root_dir = util.path.dirname,
    },
}
