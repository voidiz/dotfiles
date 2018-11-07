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

" Various colorschemes
Plugin 'arcticicestudio/nord-vim'
Plugin 'flazz/vim-colorschemes'
Plugin 'pixelmuerto/vim-pixelmuerto'

" Airline
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" Auto close plugin
Plugin 'itmammoth/doorboy.vim'

" Auto close HTML tags
Plugin 'alvan/vim-closetag'

" Emmet
Plugin 'mattn/emmet-vim'

" PHP
"Plugin 'shawncplus/phpcomplete.vim'
Plugin 'stephpy/vim-php-cs-fixer'
" Debugging PHP, requires xdebug
Plugin 'vim-vdebug/vdebug'

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
set t_Co=255
syntax on
" colorscheme molokai
" colorscheme wal
" colorscheme ron
" colorscheme darkblue
colorscheme default
hi VertSplit ctermbg=0 ctermfg=0
let g:airline_theme = 'hybridline'

" Formatting
set number
set relativenumber
set nowrap
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" Python settings
" au BufNewFile,BufRead *.py:
au Filetype python
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

" Web settings
" au BufNewFile,BufRead *.js,*.html,*.css,*.php:
au Filetype javascript,html,htmldjango,css,php
    \ setl tabstop=2 |
    \ setl softtabstop=2 |
    \ setl shiftwidth=2 |
    \ setl expandtab |
    \ setl autoindent |
    \ setl fileformat=unix

" Macro to insert php echo
let @e = 'a<?php echo ?>hi$'

" ctrlp.vim settings
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'rwa'

" php_cs_fixer settings
"let g:php_cs_fixer_path = "~/php-cs-fixer.phar" " define the path to the php-cs-fixer.phar
let g:php_cs_fixer_level = "symfony"
let g:php_cs_fixer_config = "default"
let g:php_cs_fixer_rules = "@PSR2"
let g:php_cs_fixer_php_path = "php"
let g:php_cs_fixer_enable_default_mapping = 1
let g:php_cs_fixer_dry_run = 0
let g:php_cs_fixer_verbose = 0
