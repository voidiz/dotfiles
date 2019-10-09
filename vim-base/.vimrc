" .vimrc
" Requires vim8/neovim and python3 with python module
" pynvim or neovim

set nocompatible
set shell=/bin/bash
set encoding=utf-8

" Automatically install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"""""""""""""""""""""""""""""""""""""""""""
" Plugins
call plug#begin('~/.vim/plugged')

" vim8 support for neovim plugins
Plug 'roxma/vim-hug-neovim-rpc'

" Fuzzy finder CtrlP
Plug 'ctrlpvim/ctrlp.vim'

" PyWal vim plugin
Plug 'dylanaraps/wal.vim'

" Various colorschemes
Plug 'flazz/vim-colorschemes'
Plug 'w0ng/vim-hybrid'
Plug 'NLKNguyen/papercolor-theme'

" Lightline
Plug 'itchyny/lightline.vim'

" NERDTree
Plug 'scrooloose/nerdtree'

" Auto close plugin
Plug 'itmammoth/doorboy.vim'

" Auto close HTML tags
Plug 'alvan/vim-closetag'

" Emmet
Plug 'mattn/emmet-vim'

" Comment stuff plugin
Plug 'tpope/vim-commentary'

" Code completion with lsp plugin
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-bufword'
Plug 'Shougo/neco-syntax'
Plug 'ncm2/ncm2-syntax'
Plug 'ncm2/ncm2-tern', {'do': 'npm install'}
Plug 'ncm2/ncm2-jedi'
Plug 'ncm2/ncm2-pyclang'
Plug 'ncm2/ncm2-go'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
" Plug 'ncm2/ncm2-ultisnips'
" Plug 'SirVer/ultisnips'
" Plug 'honza/vim-snippets'

" Go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" React/JS
" Indentation and syntax highlighting for JS
Plug 'pangloss/vim-javascript'

" JSON highlighting etc.
Plug 'elzr/vim-json'

" Indentation and syntax highlighting, React jsx
Plug 'mxw/vim-jsx'

" Live markdown preview
Plug 'shime/vim-livedown'

" LaTeX
Plug 'lervag/vimtex'

call plug#end()
"""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""
" Colors
set t_Co=256
syntax on
hi VertSplit ctermbg=0 ctermfg=0
colorscheme PaperColor

" Set background
runtime bg/bg.vim

" Dark theme
" let g:hybrid_use_Xresources = 1
" let g:hybrid_custom_term_colors = 1
" colorscheme hybrid
" colorscheme dracula
" set background=dark

" Set cursor to block when starting vim
:au VimEnter * set guicursor=a:block-Cursor

" Restore cursor to bar on exit
:au VimLeave * set guicursor=a:ver100-blinkon0

" Cursors
let &t_SI = "\<Esc>[6 q" " insert mode vertical bar
let &t_SR = "\<Esc>[4 q" " replace mode horizontal bar
let &t_EI = "\<Esc>[2 q" " normal mode block
"""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""
" Lightline
set laststatus=2
set noshowmode
" let g:lightline = {
"     \ 'colorscheme': 'pillow',
"     \ }
let g:lightline = {
    \ 'colorscheme': 'PaperColor',
    \ }
"""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""
" Formatting
set number
set relativenumber
set nowrap
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set scrolloff=3
set autoindent
set smartindent
set cindent
filetype plugin indent on
"""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""
" Python settings
" au BufNewFile,BufRead *.py:
au Filetype python
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set colorcolumn=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix
highlight ColorColumn ctermbg=Yellow
"""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""
" Web settings
" au BufNewFile,BufRead *.js,*.html,*.css,*.php:
au Filetype javascript,html,htmldjango,css
    \ setl tabstop=2 |
    \ setl softtabstop=2 |
    \ setl shiftwidth=2 |
    \ setl expandtab |
    \ setl autoindent |
    \ setl fileformat=unix

" Omni completion for css/scss/less/sass
au User Ncm2Plugin call ncm2#register_source({
    \ 'name' : 'css',
    \ 'priority': 9,
    \ 'subscope_enable': 1,
    \ 'scope': ['css','scss', 'less', 'sass'],
    \ 'mark': 'css',
    \ 'word_pattern': '[\w\-]+',
    \ 'complete_pattern': ':\s*',
    \ 'on_complete': ['ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
    \ })
"""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""
" ctrlp.vim settings
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'rwa'
let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist)|(\.(swp|ico|git|svn))$'
let g:ctrlp_follow_symlinks = 2
"""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""
" nerdtree settings
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""
" ncm2 settings
" enable ncm2 for all buffers
autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect

" suppress annoying messages
set shortmess+=c

" allow tabbing between results in the popup
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" ultisnips (snippets)
" expand snippets with enter
" inoremap <silent> <expr> <CR> ncm2_ultisnips#expand_or("\<CR>", 'n')

" c-j c-k for moving in snippet
" let g:UltiSnipsExpandTrigger		= "<Plug>(ultisnips_expand)"
" let g:UltiSnipsJumpForwardTrigger	= "<c-j>"
" let g:UltiSnipsJumpBackwardTrigger	= "<c-k>"
" let g:UltiSnipsRemoveSelectModeMappings = 0
"""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""
" languageclient-neovim settings
set hidden
nnoremap <F5> :call LanguageClient_contextMenu()<CR>
let g:LanguageClient_serverCommands= {
    \ 'javascript.jsx': ['$HOME/.npm-global/bin/typescript-language-server', '--stdio']}
    " \ 'javascript': ['$HOME/.npm-global/bin/typescript-language-server', '--stdio'],
    " \ 'python': ['pyls'],
    " \ 'go': ['gopls'],
    " \ 'c': ['clangd'],
    " \ 'cpp': ['clangd']}
"""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""
" latex settings
let g:text_flavor = 'latex'
let g:vimtex_view_method = "zathura"
let g:vimtex_latexmk_continuous = 1
let g:vimtex_compiler_progname = 'nvr'

" ncm2 omnicompletion for latex
autocmd Filetype tex call ncm2#register_source({
    \ 'name': 'vimtex',
    \ 'priority': 8,
    \ 'scope': ['tex'],
    \ 'mark': 'tex',
    \ 'word_pattern': '\w+',
    \ 'complete_pattern': g:vimtex#re#ncm2,
    \ 'on_complete': ['ncm2#on_complete#omni', 'vimtex#complete#omnifunc'],
    \ })
"""""""""""""""""""""""""""""""""""""""""""
