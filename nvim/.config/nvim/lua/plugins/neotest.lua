local map = require("helpers.keys").map

return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"fredrikaverpil/neotest-golang",
			"nvim-neotest/neotest-python",
		},
		config = function()
			local neotest = require("neotest")
			neotest.setup({
				adapters = {
					require("neotest-golang"),
					require("neotest-python")({
						runner = "pytest",
					}),
				},
			})
			map("n", "<leader>tr", function()
				neotest.run.run()
			end, "Run Tests")
			map("n", "<leader>ts", function()
				neotest.run.stop()
			end, "Stop Tests")
			map("n", "<leader>to", function()
				neotest.output.open()
			end, "Stop Tests")
			map("n", "<leader>ti", function()
				neotest.summary.toggle()
			end, "Toggle Tests Summary")
		end,
	},
}
