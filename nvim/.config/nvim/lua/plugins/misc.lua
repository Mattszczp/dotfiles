-- Miscelaneous fun stuff
return {
	-- Comment with haste
	{
		"numToStr/Comment.nvim",
		opts = {},
	},
  -- Autoclose
  {
    'm4xshen/autoclose.nvim',
    config = function ()
      require("autoclose").setup()
    end
  }
}
