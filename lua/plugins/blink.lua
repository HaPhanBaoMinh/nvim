-- lua/plugins/blink.lua
local ok, blink = pcall(require, "blink.cmp")
if not ok then return end

blink.setup({
	-- keys
	keymap = {
		preset = "enter",
		["<Tab>"] = { "select_next", "fallback" },
		["<S-Tab>"] = { "select_prev", "fallback" },
	},
	fuzzy = {
		implementation = "lua", -- use pure-Lua, no warning
	},

	-- completion UI/behavior
	completion = {
		menu = {
			-- show menu automatically (set to false if you want manual <C-Space>)
			auto_show = true,
			-- nvim-cmp-style columns
			draw = {
				columns = {
					{ "label",     "label_description", gap = 1 },
					{ "kind_icon", "kind" },
				},
			},
		},
		documentation = { auto_show = true, auto_show_delay_ms = 300 },
		ghost_text = { enabled = true },
	},

	-- sources
	sources = {
		-- built-ins: 'lsp', 'path', 'snippets', 'luasnip', 'buffer', 'omni'
		default = { 'lsp', 'path', 'snippets', 'buffer' },
		-- only define `providers = {}` if you add external/community sources
	},

	-- choose snippet engine preset: 'default' (vim.snippet), 'luasnip', or 'mini_snippets'
	snippets = { preset = 'luasnip' },
})

-- better completion UX
vim.o.completeopt = "menu,menuone,noselect"
