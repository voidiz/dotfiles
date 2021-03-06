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
Plug 'dylanaraps/wal.vim'
Plug 'deviantfero/wpgtk.vim'

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

" Change surrounding symbols
Plug 'tpope/vim-surround'

" Pairs (parens, brackets, quotes, etc.)
Plug 'jiangmiao/auto-pairs'

" Code completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Syntax coloring
if has('nvim')
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
endif

" Only used for indentation in nvim since treesitter's
" indentation doesn't work
Plug 'sheerun/vim-polyglot'

call plug#end()
"""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""
" Colors
 if (has("termguicolors"))
     set termguicolors
 endif

set t_Co=256
syntax on

" Colorscheme overrides
" Group names can be found with ':so $VIMRUNTIME/syntax/hitest.vim'
autocmd ColorScheme *
    \ hi Pmenu ctermbg=NONE guibg=NONE |
    " \ hi Normal ctermbg=NONE guibg=NONE |
    " \ hi LineNr ctermbg=NONE guibg=NONE |
    " \ hi VertSplit ctermbg=0 ctermfg=0 |
    " \ hi ColorColumn ctermbg=176 |
    " \ hi Error ctermbg=0 ctermfg=1 |
    " \ hi WarningMsg ctermbg=0 ctermfg=8 |
    " \ hi Search ctermbg=2 ctermfg=0 |
    " \ hi Comment cterm=italic |
    " \ hi NERDTreeFile guifg=1

" colorscheme wal
" colorscheme Tomorrow-Night
" let ayucolor="dark"
" colorscheme ayu
colorscheme jellybeans
set background=dark

" Dark theme
" let g:hybrid_use_Xresources = 1
" let g:hybrid_custom_term_colors = 1
" colorscheme hybrid
" colorscheme dracula

" Restore cursor to bar on exit
:au VimLeave * set guicursor=a:ver100-blinkon0
"""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""
" Lightline (with coc.nvim specific settings)
set laststatus=2
set noshowmode
let g:lightline = {
    \ 'colorscheme': 'jellybeans',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
    \ },
    \ 'component_function': {
    \   'cocstatus': 'coc#status'
    \ },
    \ }
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
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
"""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""
" asm/go settings
au Filetype asm,go
    \ setl noexpandtab |
    \ setl softtabstop=8 |
    \ setl tabstop=8 |
    \ setl shiftwidth=8
""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""
" Web settings
" au BufNewFile,BufRead *.js,*.html,*.css,*.php:
au Filetype javascript,html,htmldjango,css,javascript.jsx,
            \typescriptreact,typescript
    \ setl tabstop=2 |
    \ setl softtabstop=2 |
    \ setl shiftwidth=2 |
    \ setl fileformat=unix
"""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""
" c/c++ settings
au Filetype c,cpp
    \ setl tabstop=4 |
    \ setl softtabstop=4 |
    \ setl shiftwidth=4 |
    \ setl fileformat=unix

" compile and run with *.in as input
nnoremap <leader>ru :!g++ -std=c++17 -g -O2 -Wall -pedantic %:p && for file in *.in; do echo "Input $file:"; ./a.out < "$file"; echo -e; done<CR>
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
    \ 'coc-css', 'coc-pyright', 'coc-highlight',
    \ 'coc-emmet', 'coc-go', 'coc-eslint',
    \ 'coc-prettier', 'coc-vimtex', 'coc-tslint-plugin',
    \ 'coc-clangd'
    \]

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

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> in insert mode to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <c-space> in normal mode to trigger fix
nmap <silent> <c-space> <Plug>(coc-codeaction-selected)<CR>

" Navigate completion list with <Tab> and <S-Tab>
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
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
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Shift + Alt + F to format current buffer
nmap <M-S-F> <Plug>(coc-format)
"""""""""""""""""""""""""""""""""""""""""""
