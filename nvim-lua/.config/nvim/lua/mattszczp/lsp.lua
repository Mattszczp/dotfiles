local nnoremap = require("mattszczp.remap").nnoremap

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

local opts = { noremap=true, silent=true }
nnoremap('<space>e', vim.diagnostic.open_float, opts)
nnoremap('[d', vim.diagnostic.goto_prev, opts)
nnoremap(']d', vim.diagnostic.goto_next, opts)
nnoremap('<space>q', vim.diagnostic.setloclist, opts)

-- Setup nvim-cmp.
local cmp = require("cmp")
local source_mapping = {
	buffer = "[Buffer]",
	nvim_lsp = "[LSP]",
	nvim_lua = "[Lua]",
	cmp_tabnine = "[TN]",
	path = "[Path]",
}

local lspkind = require("lspkind")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")

cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
)
cmp.setup({
	snippet = {
		expand = function(args)
            require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
	}),

	formatting = {
		format = function(entry, vim_item)
			vim_item.kind = lspkind.presets.default[vim_item.kind]
			local menu = source_mapping[entry.source.name]
			if entry.source.name == "cmp_tabnine" then
				if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
					menu = entry.completion_item.data.detail .. " " .. menu
				end
				vim_item.kind = ""
			end
			vim_item.menu = menu
			return vim_item
		end,
	},

	sources = {
		-- tabnine completion? yayaya

		{ name = "cmp_tabnine" },

		{ name = "nvim_lsp" },

		-- For luasnip user.
		{ name = "luasnip" },

		-- For ultisnips user.
		-- { name = 'ultisnips' },

		{ name = "buffer" },
	},
})

local tabnine = require("cmp_tabnine.config")
tabnine:setup({
	max_lines = 1000,
	max_num_results = 20,
	sort = true,
	run_on_every_keystroke = true,
	snippet_placeholder = "..",
})

local function config(_config)
    return vim.tbl_deep_extend("force", {
        capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
        on_attach = function(_, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        nnoremap('gD', vim.lsp.buf.declaration, bufopts)
        nnoremap('gd', vim.lsp.buf.definition, bufopts)
        nnoremap('K', vim.lsp.buf.hover, bufopts)
        nnoremap('gi', vim.lsp.buf.implementation, bufopts)
        nnoremap('<C-k>', vim.lsp.buf.signature_help, bufopts)
        nnoremap('<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
        nnoremap('<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
        nnoremap('<space>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        nnoremap('<space>D', vim.lsp.buf.type_definition, bufopts)
        nnoremap('<space>rn', vim.lsp.buf.rename, bufopts)
        nnoremap('<space>ca', vim.lsp.buf.code_action, bufopts)
        nnoremap('gr', vim.lsp.buf.references, bufopts)
        nnoremap('<space>f', vim.lsp.buf.formatting, bufopts)
        end,
    }, _config or {})
end

require('lspconfig')['pyright'].setup(config())
require('lspconfig')['ansiblels'].setup(config())
require('lspconfig')['bashls'].setup(config())
require('lspconfig')['dockerls'].setup(config())
require('lspconfig')['eslint'].setup(config())
require('lspconfig')['gopls'].setup(config())
require('lspconfig')['html'].setup(config())
require('lspconfig')['sumneko_lua'].setup(config({
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            diagnostics = {
                globals = { 'vim' }
            },
            workspace = {
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                }
            }
        }
    }
}))
require('lspconfig')['tflint'].setup(config())
require('lspconfig')['tsserver'].setup(config())
require('lspconfig').rust_analyzer.setup(config())
