local opts = {
	shiftwidth = 4,
	tabstop = 4,
	softtabstop = 4,
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
}

-- Set options from table
for opt, val in pairs(opts) do
	vim.o[opt] = val
end

-- Set other options
local colorscheme = "tokyonight"
vim.cmd.colorscheme(colorscheme)
