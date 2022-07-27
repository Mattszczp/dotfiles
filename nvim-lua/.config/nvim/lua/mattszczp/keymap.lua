local nnoremap = require("mattszczp.remap").nnoremap
local telescope = require("telescope.builtin")
--netrw
nnoremap("<leader>pv", "<cmd>Ex<CR>")

--Telescope
nnoremap("<leader>ff", telescope.find_files())
nnoremap("<leader>fg", telescope.live_grep())
nnoremap("<leader>fb", telescope.buffers())
nnoremap("<leader>fh", telescope.help_tags())
