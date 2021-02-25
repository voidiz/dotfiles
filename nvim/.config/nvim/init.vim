set runtimepath^=~/.vim runtimepath+=~/.vim/after
set clipboard+=unnamedplus
let &packpath = &runtimepath
source ~/.vimrc

" Treesitter (syntax, indent,..) config
lua <<EOF
require'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "cpp", "python", "go", "json", "javascript" },
    highlight = {
        enable = true,
    },
    indent = {
        enable = false
    },
}
EOF

