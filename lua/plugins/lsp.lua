require("luasnip.loaders.from_vscode").lazy_load()

local cmp = require("cmp")
local luasnip = require("luasnip")
local cmp_types = require("cmp.types.cmp")

cmp.setup({
	completion = {
		keyword_length = 1,
		autocomplete = {
			cmp_types.TriggerEvent.InsertEnter,
			cmp_types.TriggerEvent.TextChanged,
		},
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
		-- GNOME Terminal (VTE) often maps Ctrl+Space to NUL (^@), not <C-Space>
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-@>"] = cmp.mapping.complete(),
		["<C-.>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	}, {
		{ name = "buffer" },
		{ name = "path" },
	}),
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Hover: one handler, dimensions from current &columns/&lines (not frozen at startup)
local lsp_hover_fn = vim.lsp.handlers.hover
local function hover_popup(err, result, ctx, config)
	local merged = vim.tbl_deep_extend("force", config or {}, {
		border = "rounded",
		max_width = math.min(88, vim.o.columns - 8),
		max_height = math.min(28, vim.o.lines - 8),
		focusable = true,
		focus = false,
	})
	return lsp_hover_fn(err, result, ctx, merged)
end

vim.lsp.handlers["textDocument/hover"] = hover_popup

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	border = "rounded",
	max_height = 14,
})

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"pyright",
		"bashls",
		"rust_analyzer",
		"clangd",
	},
	automatic_installation = true,
})

--- Rust: Mason `bin/` shim, else unpacked binary (shim sometimes missing mid-install), else rustup.
local function rust_analyzer_cmd()
	local data = vim.fn.stdpath("data")
	local mason_ra = data .. "/mason/bin/rust-analyzer"
	if vim.fn.executable(mason_ra) == 1 then
		return { mason_ra }
	end
	local pkg = data .. "/mason/packages/rust-analyzer"
	if vim.fn.isdirectory(pkg) == 1 then
		for _, p in ipairs(vim.fn.glob(pkg .. "/rust-analyzer*", false, true)) do
			if vim.fn.executable(p) == 1 and vim.fn.isdirectory(p) == 0 then
				return { p }
			end
		end
	end
	local out = vim.fn.system("rustup which rust-analyzer 2>/dev/null")
	if vim.v.shell_error == 0 and out and vim.trim(out) ~= "" then
		local p = vim.trim(out)
		if vim.fn.executable(p) == 1 then
			return { p }
		end
	end
	return nil
end

require("mason-lspconfig").setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			capabilities = capabilities,
		})
	end,
	["lua_ls"] = function()
		require("lspconfig").lua_ls.setup({
			capabilities = capabilities,
			single_file_support = true,
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					workspace = {
						checkThirdParty = false,
						library = vim.api.nvim_get_runtime_file("", true),
					},
				},
			},
		})
	end,
	["pyright"] = function()
		require("lspconfig").pyright.setup({
			capabilities = capabilities,
			single_file_support = true,
		})
	end,
	["rust_analyzer"] = function()
		local cmd = rust_analyzer_cmd()
		if not cmd then
			vim.notify_once(
				"Rust LSP: chạy :MasonInstall rust-analyzer HOẶC: rustup component add rust-analyzer",
				vim.log.levels.WARN
			)
			return
		end
		require("lspconfig").rust_analyzer.setup({
			capabilities = capabilities,
			cmd = cmd,
			settings = {
				["rust-analyzer"] = {
					cargo = { allFeatures = true },
				},
			},
		})
	end,
})

-- K (Shift+K): LSP float hover when a server supports it; otherwise built-in K
-- (keywordprg). Plain vim.lsp.buf.hover() does nothing with no LSP — looked like a dead key.
local function k_hover_or_doc()
	for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
		if client.supports_method("textDocument/hover") then
			vim.lsp.buf.hover()
			return
		end
	end
	vim.cmd("normal! K")
end

vim.keymap.set("n", "K", k_hover_or_doc, { desc = "LSP hover or keywordprg" })

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client then
			client.handlers["textDocument/hover"] = hover_popup
		end
		local map = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, silent = true, desc = desc })
		end
		map("n", "gd", vim.lsp.buf.definition, "LSP definition")
		map("n", "gD", vim.lsp.buf.declaration, "LSP declaration")
		map("n", "gr", vim.lsp.buf.references, "LSP references")
		map("n", "<leader>cr", vim.lsp.buf.rename, "LSP rename")
		map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "LSP code action")
		map("n", "<leader>cd", vim.diagnostic.open_float, "Diagnostic float")
		map("n", "[d", function()
			vim.diagnostic.goto_prev({ float = false })
		end, "Prev diagnostic")
		map("n", "]d", function()
			vim.diagnostic.goto_next({ float = false })
		end, "Next diagnostic")
	end,
})
