local opts = {
	shiftwidth = 2,
	tabstop = 2,
	softtabstop = 2,
	smartindent = true,
	expandtab = true,
	wrap = false,
	termguicolors = true,
	number = true,
	relativenumber = true,

	swapfile = false,
	backup = false,
	undodir = os.getenv("HOME") .. "/.vim/undodir",
	undofile = true,

	colorcolumn = "80",

	hlsearch = false,
	incsearch = true,

	scrolloff = 8,
	signcolumn = "yes",

	updatetime = 50,
}

-- Set options from table
for opt, val in pairs(opts) do
	vim.o[opt] = val
end

-- Set other options
local colorscheme = "tokyonight"
vim.cmd.colorscheme(colorscheme)

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.opt.isfname:append("@-@")
