-- diagnostics UI
vim.diagnostic.config({
	virtual_text = true, -- inline errors
	signs = false, -- no gutter signs
	underline = true, -- underline text
	update_in_insert = false,
	severity_sort = true,
})

vim.o.updatetime = 250

local diag_winid

vim.keymap.set("n", "<leader>d", function()
	if diag_winid and vim.api.nvim_win_is_valid(diag_winid) then
		pcall(vim.api.nvim_win_close, diag_winid, true)
		diag_winid = nil
		return
	end

	local _, win = vim.diagnostic.open_float(nil, {
		focusable = false, -- <- không cho focus vào popup
		border = "rounded",
		scope = "cursor",
		close_events = { "CursorMoved", "BufHidden", "InsertEnter" },
	})
	diag_winid = win

	-- Nếu popup tự đóng bởi close_events, dọn state
	vim.api.nvim_create_autocmd("WinClosed", {
		once = true,
		callback = function(args)
			if tonumber(args.match) == diag_winid then
				diag_winid = nil
			end
		end,
	})
end, { desc = "Toggle diagnostic popup" })

-- capabilities (compatible with blink.cmp or fallback)
local capabilities = vim.lsp.protocol.make_client_capabilities()


local lspconfig = require("lspconfig")


-- auto-attach and optional format-on-save
local format_fts = { lua = true, go = true, typescript = true, typescriptreact = true, javascript = true }
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then return end

		-- format on save for these filetypes
		local ft = vim.bo[args.buf].filetype
		if format_fts[ft] then
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = args.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
				end,
			})
		end
	end,
})

-- setup servers
local servers = {
	lua_ls = {
		settings = { Lua = { diagnostics = { globals = { "vim" } } } },
	},
	ts_ls = {
		settings = {
			implicitProjectConfiguration = { checkJs = true },
			javascript = { suggest = { autoImports = true } },
			typescript = { suggest = { autoImports = true } },
		},
	},
	pyright = {},
	jsonls = {},
	bashls = {},
	gopls = {},
}

for name, opts in pairs(servers) do
	opts.capabilities = capabilities
	lspconfig[name].setup(opts)
end

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local bufnr = ev.buf
		local map = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
		end

		map("n", "gd", vim.lsp.buf.definition, "LSP: Go to Definition")
		map("n", "gr", vim.lsp.buf.references, "LSP: References")
	end,
})

vim.keymap.set("n", "<leader>dc", function()
	local text = nil

	-- 1) If the floating window is open, copy its contents
	if diag_winid and vim.api.nvim_win_is_valid(diag_winid) then
		local buf = vim.api.nvim_win_get_buf(diag_winid)
		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
		text = table.concat(lines, "\n")
	else
		-- 2) Fallback: copy diagnostics at current line
		local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
		local diags = vim.diagnostic.get(0, { lnum = lnum })
		if #diags == 0 then
			vim.notify("No diagnostics here", vim.log.levels.INFO)
			return
		end
		local msgs = {}
		for _, d in ipairs(diags) do
			table.insert(msgs, d.message)
		end
		text = table.concat(msgs, "\n")
	end

	-- Copy to system clipboard (+) and selection (*)
	vim.fn.setreg("+", text)
	pcall(vim.fn.setreg, "*", text)
	vim.notify("Diagnostics copied", vim.log.levels.INFO)
end, { desc = "Copy diagnostics (popup or line)" })
