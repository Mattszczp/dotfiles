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
set noswapfile
set nobackup

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
call plug#begin(stdpath('data') . '/plugged')
Plug 'tpope/vim-fugitive'
Plug 'preservim/nerdtree'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'gruvbox-community/gruvbox'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"CMP & LSP
Plug 'onsails/lspkind.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'tzachar/cmp-tabnine', { 'do': './install.sh' }
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/cmp-vsnip'
" CMP & LSP END
call plug#end()

set completeopt=menu,menuone,noselect

colorscheme gruvbox
highlight Normal ctermbg=none
highlight NonText ctermbg=none
let g:deoplete#enable_at_startup = 1

let mapleader = " "
nnoremap <leader>vd :lua vim.diagnostic.open_float()<CR>
let NERDTreeShowHidden=1
nnoremap <C-N> :NERDTreeToggle<CR>

" GO
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1
au Filetype go nmap <leader>ga <Plug>(go-alternate-edit)
au Filetype go nmap <leader>gah <Plug>(go-alternate-split)
au Filetype go nmap <leader>gav <Plug>(go-alternate-vertical)
au FileType go nmap <leader>gt :GoTest -short<cr>
au FileType go nmap <leader>gct :GoCoverageToggle -short<cr>
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
