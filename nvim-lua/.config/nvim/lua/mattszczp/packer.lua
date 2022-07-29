return require("packer").startup(function(use)
    use("wbthomason/packer.nvim")
    use("TimUntersberger/neogit")
    -- Telescope
    use("nvim-lua/plenary.nvim")
    use("nvim-lua/popup.nvim")
    use("nvim-telescope/telescope.nvim")
    use("nvim-treesitter/nvim-treesitter", {
        run = ":TSUpdate"
    })
    use("folke/which-key.nvim")
    --LSP and auto completion
    use("neovim/nvim-lspconfig")
    use("williamboman/nvim-lsp-installer")
    use("folke/lua-dev.nvim")
    use("hrsh7th/nvim-cmp")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-buffer")
    use("tzachar/cmp-tabnine", {run = "./install.sh"})
    use("onsails/lspkind.nvim")
    use("L3MON4D3/LuaSnip")
    use("saadparwaiz1/cmp_luasnip")
    use {	"windwp/nvim-autopairs",config = function() require("nvim-autopairs").setup {} end }
    --Debugging
    use("mfussenegger/nvim-dap")
    use("leoluz/nvim-dap-go")
    use("rcarriga/nvim-dap-ui")
    use("theHamsta/nvim-dap-virtual-text")
    use("nvim-telescope/telescope-dap.nvim")

    use("gruvbox-community/gruvbox")
    use("folke/tokyonight.nvim")
    use('mustache/vim-mustache-handlebars')

end)
