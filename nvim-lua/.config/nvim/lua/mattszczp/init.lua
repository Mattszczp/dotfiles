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
