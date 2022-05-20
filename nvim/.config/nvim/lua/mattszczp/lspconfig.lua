require("nvim-lsp-installer").setup({
    automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗"
        }
    }
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.

require('lspconfig')['pyright'].setup {capabilities = capabilities}
require('lspconfig')['ansiblels'].setup {capabilities = capabilities}
require('lspconfig')['bashls'].setup {capabilities = capabilities}
require('lspconfig')['dockerls'].setup {capabilities = capabilities}
require('lspconfig')['eslint'].setup {capabilities = capabilities}
require('lspconfig')['golangci_lint_ls'].setup {capabilities = capabilities}
require('lspconfig')['gopls'].setup {capabilities = capabilities}
require('lspconfig')['html'].setup {capabilities = capabilities}
require('lspconfig')['sumneko_lua'].setup {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    },
    capabilities = capabilities
}
require('lspconfig')['tflint'].setup {capabilities = capabilities}
require('lspconfig')['tsserver'].setup {capabilities = capabilities}
require('lspconfig')['pyright'].setup {capabilities = capabilities}
