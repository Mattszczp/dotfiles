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

    use("gruvbox-community/gruvbox")
    use("folke/tokyonight.nvim")

end)
