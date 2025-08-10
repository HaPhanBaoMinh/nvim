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
    focusable = false,             -- <- không cho focus vào popup
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
pcall(function()
	capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
end)

local lspconfig = require("lspconfig")

-- auto-attach and optional format-on-save
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then return end

		-- format on save for these filetypes
		local ft = vim.bo[args.buf].filetype
		if ft == "lua" or ft == "go" then
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
