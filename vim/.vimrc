set nocompatible              " be iMproved, required
filetype off                  " required
set shell=/bin/bash
set encoding=utf-8

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" Fuzzy finder CtrlP
Plugin 'ctrlpvim/ctrlp.vim'

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" PyWal vim plugin
Plugin 'dylanaraps/wal.vim'

" Nord colorscheme
Plugin 'arcticicestudio/nord-vim'

" Auto close plugin
Plugin 'itmammoth/doorboy.vim'

" Auto close HTML tags
Plugin 'alvan/vim-closetag'
"
" YCM-Generator
Plugin 'rdnetto/YCM-Generator'

" YouCompleteMe
Plugin 'Valloric/YouCompleteMe'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" Colors
set t_Co=256
syntax on
" colorscheme molokai
" colorscheme wal
" colorscheme nord
colorscheme darkblue

"Formatting
set number
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

"Python settings
au BufNewFile,BufRead *.py:
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix 

"Web settings
au BufNewFile,BufRead *.js,*.html,*.css:
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix 

" ctrlp.vim settings
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'rwa'
