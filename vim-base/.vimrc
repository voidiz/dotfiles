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

" Various colorschemes
Plug 'flazz/vim-colorschemes'
Plug 'w0ng/vim-hybrid'
Plug 'NLKNguyen/papercolor-theme'
Plug 'rakr/vim-two-firewatch'
Plug 'fenetikm/falcon'

" Lightline
Plug 'itchyny/lightline.vim'

" NERDTree
Plug 'scrooloose/nerdtree'

" Auto close plugin
" Plug 'itmammoth/doorboy.vim'

" Auto close HTML tags
Plug 'alvan/vim-closetag'

" Emmet
Plug 'mattn/emmet-vim'

" Comment stuff plugin
Plug 'tpope/vim-commentary'

" Pairs (parens, brackets, quotes, etc.)
Plug 'jiangmiao/auto-pairs'

" Code completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

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
if (has("termguicolors"))
    set termguicolors
endif

set t_Co=256
syntax on
hi VertSplit ctermbg=0 ctermfg=0
colorscheme falcon

" Set background
runtime bg/bg.vim

" Dark theme
" let g:hybrid_use_Xresources = 1
" let g:hybrid_custom_term_colors = 1
" colorscheme hybrid
" colorscheme dracula
" set background=dark

" Restore cursor to bar on exit
:au VimLeave * set guicursor=a:ver100-blinkon0
"""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""
" Lightline
set laststatus=2
set noshowmode
let g:falcon_lightline = 1
let g:lightline = {
    \ 'colorscheme': 'falcon',
    \ }
"""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""
" Formatting
set number
set relativenumber
set nowrap
set softtabstop=4
set shiftwidth=4
set expandtab
set scrolloff=3
set autoindent
filetype plugin indent on
"""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""
" Python settings
" au BufNewFile,BufRead *.py:
au Filetype python
    \ setl textwidth=79 |
    \ setl colorcolumn=79 |
    \ setl fileformat=unix
highlight ColorColumn ctermbg=176
"""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""
" Web settings
" au BufNewFile,BufRead *.js,*.html,*.css,*.php:
au Filetype javascript,html,htmldjango,css,javascript.jsx
    \ setl tabstop=2 |
    \ setl softtabstop=2 |
    \ setl shiftwidth=2 |
    \ setl fileformat=unix
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
" coc settings (mostly defaults)

" extensions
let g:coc_global_extensions = [
    \ 'coc-json', 'coc-tsserver', 'coc-html',
    \ 'coc-css', 'coc-python', 'coc-highlight',
    \ 'coc-emmet', 'coc-go', 'coc-eslint',
    \ 'coc-prettier'
    \]

" configurations
let g:coc_user_config = {
    \ "languageserver": {
    \     "ccls": {
    \         "command": "ccls",
    \         "filetypes": ["c", "cpp", "objc", "objcpp"],
    \         "rootPatterns": [".ccls", "compile_commands.json", ".vim/", ".git/", ".hg/"],
    \         "initializationOptions": {
    \             "cache": {
    \                 "directory": "/tmp/ccls"
    \             }
    \         }
    \     }
    \ }
    \}

" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
" set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Navigate completion list with <Tab> and <S-Tab>
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
"""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""
" latex settings
let g:text_flavor = 'latex'
let g:vimtex_view_method = "zathura"
let g:vimtex_latexmk_continuous = 1
let g:vimtex_compiler_progname = 'nvr'
"""""""""""""""""""""""""""""""""""""""""""
