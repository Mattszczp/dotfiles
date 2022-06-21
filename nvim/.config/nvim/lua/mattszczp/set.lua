vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.exrc = true --Execute local .vimrc files inside the project after running 'vim .'
vim.opt.guicursor = ""
vim.opt.relativenumber = true --relative line number
vim.opt.nu = true --show selected line number
vim.opt.hlsearch = false --hide search selection
vim.opt.hidden = true
vim.opt.errorbells = false
vim.opt.incsearch = true
vim.opt.scrolloff = 8
vim.opt.colorcolumn = "80"
vim.opt.signcolumn = "yes"
vim.opt.cmdheight = 2
vim.opt.swapfile = false
vim.opt.backup = false

-- Nice menu when typing `:find *.py`
vim.opt.wildmode = "longest,list,full"
vim.opt.wildmenu = true
--[[
-- Ignore files
vim.opt.wildignore += "*.pyc"
vim.opt.wildignore += "*_build/*"
vim.opt.wildignore += "**/coverage/*"
vim.opt.wildignore += "**/node_modules/*"
vim.opt.wildignore += "**/android/*"
vim.opt.wildignore += "**/ios/*"
vim.opt.wildignore += "**/.git/*
]]--
