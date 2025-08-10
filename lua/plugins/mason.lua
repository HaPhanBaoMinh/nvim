-- mason
require("mason").setup()

-- mason-lspconfig
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"pyright",
		"ts_ls",
		"jsonls",
		"bashls",
		"gopls",
	},
	automatic_installation = true,
})
