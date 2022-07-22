local augroup = vim.api.nvim_create_augroup
MattszczpGroup = augroup('Mattszczp', {})

require("mattszczp.set")
require("mattszczp.packer")
require("mattszczp.lsp")
require("mattszczp.neogit")

local autocmd = vim.api.nvim_create_autocmd

autocmd({"BufWritePre"}, {
    group = MattszczpGroup,
    pattern = "*",
    command = "%s/\\s\\+$//e",
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.cmd("colorscheme tokyonight")
vim.g.gruvbox_contrast_dark = "hard"
vim.g.tokyonight_transparent_sidebar = true
vim.g.tokyonight_transparent = true
vim.opt.background = "dark"
vim.api.nvim_set_hl(0, "SignColumn", {bg = "none",})
vim.api.nvim_set_hl(0, "ColorColumn", {ctermbg = 0, bg = "#555555",})
vim.api.nvim_set_hl(0, "CursorLineNR", {bg = "None",})
vim.api.nvim_set_hl(0, "Normal", {bg  = "None",})
vim.api.nvim_set_hl(0, "LineNr", {fg = "#5eacd3",})
vim.api.nvim_set_hl(0, "netrwDir", {fg = "#5eacd3",})
