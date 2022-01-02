" init.vim for neovim v0.5.0+

set shell=/bin/bash
set encoding=utf-8
set shortmess+=c " for nvim-compe

" Share system clipboard
set clipboard+=unnamedplus

" Mouse scrolling in tmux
set mouse=a

" Source .vimrc
" set runtimepath^=~/.vim runtimepath+=~/.vim/after
" let &packpath = &runtimepath
" source ~/.vimrc

"""""""""""""""""""""""""""""""""""""""""""
" Formatting (see :help nvim-defaults)
set number
set relativenumber
set nowrap
set softtabstop=4
set shiftwidth=4
set expandtab
set scrolloff=3
" set smartindent
filetype plugin indent on
"""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""
" Plugins
" Automatically install vim-plug
let plug_install = 0
let autoload_plug_path = stdpath('config') . '/autoload/plug.vim'
if !filereadable(autoload_plug_path)
    silent exe '!curl -fL --create-dirs -o ' . autoload_plug_path . 
        \ ' https://raw.github.com/junegunn/vim-plug/master/plug.vim'
    execute 'source ' . fnameescape(autoload_plug_path)
    let plug_install = 1
endif
unlet autoload_plug_path

call plug#begin('~/.config/nvim/plugins')

" Fuzzy finder
" Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Various colorschemes
Plug 'flazz/vim-colorschemes'
Plug 'w0ng/vim-hybrid'
Plug 'ayu-theme/ayu-vim'
Plug 'sainnhe/sonokai'

" Lightline
Plug 'itchyny/lightline.vim'

" NERDTree
Plug 'scrooloose/nerdtree'

" Auto close HTML tags
Plug 'alvan/vim-closetag'

" Emmet
Plug 'mattn/emmet-vim'

" Comment stuff plugin
Plug 'tpope/vim-commentary'

" Change surrounding symbols
Plug 'tpope/vim-surround'

" Pairs (parens, brackets, quotes, etc.)
" Plug 'jiangmiao/auto-pairs'
Plug 'windwp/nvim-autopairs'

" Language server
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'

" Syntax highlighting, indentation, etc.
" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" For indentation
Plug 'sheerun/vim-polyglot'

" Highlight colors
Plug 'norcalli/nvim-colorizer.lua'

" Auto completion
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'

" Git stuff
Plug 'tpope/vim-fugitive'

" Mainly for jsx/tsx indentation
" Plug 'leafgarland/typescript-vim'
" Plug 'peitalin/vim-jsx-typescript'
" Plug 'maxmellon/vim-jsx-pretty'

call plug#end()

if plug_install
    PlugInstall --sync
endif
unlet plug_install
"""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""
" Colors
 if (has("termguicolors"))
     set termguicolors
 endif

set t_Co=256

colorscheme sonokai
set background=dark

" Colorscheme overrides
" Group names can be found with ':so $VIMRUNTIME/syntax/hitest.vim'
hi Normal guibg=235 ctermbg=235
hi EndOfBuffer guibg=235 ctermbg=235

" Restore cursor to bar on exit
:au VimLeave * set guicursor=a:ver100-blinkon0
"""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""
" Lightline (with lspstatus-specific settings)
set laststatus=2
set noshowmode

function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif

  return ''
endfunction

let g:lightline = {
    \ 'colorscheme': 'ayu_mirage',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'lspstatus', 'readonly', 'filename', 'modified' ] ]
    \ },
    \ 'component_function': {
    \   'lspstatus': 'LspStatus'
    \ },
    \ }

autocmd User LspDiagnosticsChanged call lightline#update()
"""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""
" Python settings
" au BufNewFile,BufRead *.py:
au Filetype python
    \ setl textwidth=79 |
    \ setl colorcolumn=79 |
    \ setl fileformat=unix

" run with *.in as input
au Filetype python
    \ nnoremap <leader>ru :!for file in *.in; do echo "Input $file:"; python "%:p" < "$file"; echo -e; done<CR>
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
au Filetype javascript,html,htmldjango,css,javascript.jsx
    \ setl tabstop=2 |
    \ setl softtabstop=2 |
    \ setl shiftwidth=2 |
    \ setl fileformat=unix

au Filetype typescriptreact,typescript,json
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
au Filetype cpp
    \ nnoremap <leader>ru :!g++ -std=c++17 -g -O2 -Wall -pedantic %:p && for file in *.in; do echo "Input $file:"; ./a.out < "$file"; echo -e; done<CR>
"""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""
" fzf(.vim) settings
nnoremap <c-p> :GFiles<CR>
nnoremap <leader>fi :RG<CR>
nnoremap <leader>hi :Hist<CR>
nnoremap <leader>fb :BLines<CR>
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
"""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""
" nerdtree settings
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""
" lua config
lua require('config')
"""""""""""""""""""""""""""""""""""""""""""
