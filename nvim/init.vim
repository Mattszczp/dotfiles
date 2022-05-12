syntax on
"Good Tabs
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

set exrc "Execute local .vimrc files inside the project after running 'vim .'
set guicursor= "block cursor
set relativenumber "relative line number
set nu "show selected line number
set nohlsearch "hide search selection
set hidden
set noerrorbells
set incsearch
set scrolloff=8
set colorcolumn=80
set signcolumn=yes
set cmdheight=2

" Nice menu when typing `:find *.py`
set wildmode=longest,list,full
set wildmenu
" Ignore files
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=**/coverage/*
set wildignore+=**/node_modules/*
set wildignore+=**/android/*
set wildignore+=**/ios/*
set wildignore+=**/.git/*

"PLUGINS
call plug#begin('~/.vim/plugged')
"Plug 'nvim-lua/popup.nvim'
"Plug 'nvim-lua/plenary.nvim'
"Plug 'nvim-telescope/telescope.nvim'
"Plug 'nvim-telescope/telescope-fzy-native.nvim'

Plug 'gruvbox-community/gruvbox'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
call plug#end()

colorscheme gruvbox
highlight Normal ctermbg=none
highlight NonText ctermbg=none

let mapleader = " "
"nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>:

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

augroup THE_KURTWOOD
    autocmd!
    autocmd BufWritePre * :call TrimWhitespace()
augroup END

