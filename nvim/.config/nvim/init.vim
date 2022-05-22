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
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'preservim/nerdtree'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'tzachar/cmp-tabnine', { 'do': './install.sh' }
Plug 'onsails/lspkind-nvim'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'hrsh7th/vim-vsnip'
Plug 'gruvbox-community/gruvbox'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
call plug#end()

set completeopt=menu,menuone,noselect

colorscheme gruvbox
highlight Normal ctermbg=none
highlight NonText ctermbg=none
let g:deoplete#enable_at_startup = 1

let mapleader = " "
nnoremap <C-P> :FZF<CR>
let NERDTreeShowHidden=1
nnoremap <C-N> :NERDTreeToggle<CR>

" GO
let g:go_auto_sameids = 1
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1
au Filetype go nmap <leader>ga <Plug>(go-alternate-edit)
au Filetype go nmap <leader>gah <Plug>(go-alternate-split)
au Filetype go nmap <leader>gav <Plug>(go-alternate-vertical)
au FileType go nmap <F10> :GoTest -short<cr>
au FileType go nmap <F9> :GoCoverageToggle -short<cr>
au FileType go nmap <F12> <Plug>(go-def)


" AUTO COMMANDS
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

augroup THE_KURTWOOD
    autocmd!
    autocmd BufWritePre * :call TrimWhitespace()
augroup END

lua require("mattszczp")
