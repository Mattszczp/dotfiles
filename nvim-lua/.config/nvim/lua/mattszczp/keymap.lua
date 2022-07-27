local nnoremap = require("mattszczp.remap").nnoremap
local telescope = require("telescope.builtin")
--netrw
nnoremap("<leader>pv", "<cmd>Ex<CR>")

--Telescope
nnoremap("<C-p>", ":Telescope")
nnoremap("<leader>ff", function ()
    telescope.find_files()
end)
nnoremap("<leader>fg", function ()
    telescope.live_grep()
end)
nnoremap("<leader>fb", function ()
    telescope.buffers()
end)
nnoremap("<leader>fh", function ()
    telescope.help_tags()
end)
