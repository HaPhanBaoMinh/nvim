require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗"
		}
	}
})

-- -- mason-lsp
-- require("mason-lspconfig").setup({
-- 	ensure_installed = { "lua_ls", "ts_ls", "jsonls", "bashls", "gopls" },
-- 	automatic_installation = true
-- })
