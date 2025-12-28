-- =========================
-- Diagnostics UI
-- =========================
vim.diagnostic.config({
	virtual_text = true,
	signs = false,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = false, -- disable auto floats
})

vim.o.updatetime = 250

local diag_winid

local function toggle_diag_float()
	if diag_winid and not vim.api.nvim_win_is_valid(diag_winid) then
		diag_winid = nil
	end
	if diag_winid then
		vim.api.nvim_win_close(diag_winid, true)
		diag_winid = nil
		return
	end
	local _, win = vim.diagnostic.open_float(0, {
		scope = "cursor",
		focusable = false,
		border = "rounded",
		close_events = { "CursorMoved", "BufHidden", "InsertEnter" },
		reuse_win = true,
	})
	diag_winid = win
end

vim.keymap.set("n", "<leader>dd", toggle_diag_float, { desc = "Diagnostics: toggle popup" })

-- copy diagnostics
vim.keymap.set("n", "<leader>dc", function()
	local text
	if diag_winid and vim.api.nvim_win_is_valid(diag_winid) then
		local buf = vim.api.nvim_win_get_buf(diag_winid)
		text = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")
	else
		local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
		local diags = vim.diagnostic.get(0, { lnum = lnum })
		if vim.tbl_isempty(diags) then
			vim.notify("No diagnostics here", vim.log.levels.INFO)
			return
		end
		text = table.concat(vim.tbl_map(function(d) return d.message end, diags), "\n")
	end
	vim.fn.setreg("+", text)
	pcall(vim.fn.setreg, "*", text)
	vim.notify("Diagnostics copied", vim.log.levels.INFO)
end, { desc = "Diagnostics: copy" })

-- =========================
-- LSP setup
-- =========================
local lspconfig = require("lspconfig")
local capabilities = vim.lsp.protocol.make_client_capabilities()
pcall(function()
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
end)

local format_fts = { lua = true, go = true, typescript = true, typescriptreact = true, javascript = true }

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local bufnr = ev.buf
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if not client then return end

		-- buffer-local mappings
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "LSP: Go to definition" })
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "LSP: References" })

		-- format on save
		local ft = vim.bo[bufnr].filetype
		if format_fts[ft] and client.server_capabilities.documentFormattingProvider then
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = bufnr,
				once = true,
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr, id = client.id })
				end,
			})
		end

		-- hover (Shift+K)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP: Hover" })
	end,
})

-- =========================
-- Servers
-- =========================
local servers = {
	lua_ls = { settings = { Lua = { diagnostics = { globals = { "vim" } } } } },
	ts_ls = { settings = { implicitProjectConfiguration = { checkJs = true }, javascript = { suggest = { autoImports = true } }, typescript = { suggest = { autoImports = true } } } },
	pyright = {},
	jsonls = {},
	bashls = {},
	gopls = {},
}

for name, opts in pairs(servers) do
	opts.capabilities = capabilities
	lspconfig[name].setup(opts)
end
