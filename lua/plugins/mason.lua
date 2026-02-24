require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗"
		}
	}
})

-- mason-lsp: ONLY install what we explicitly use. automatic_installation = false
-- prevents heavy servers (tailwindcss ~145MB, spectral ~90MB, yaml ~75MB) from
-- auto-installing when opening random file types.
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "ts_ls", "jsonls", "gopls" },
	automatic_installation = false,
})
