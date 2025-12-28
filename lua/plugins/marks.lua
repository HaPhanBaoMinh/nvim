-- marks.nvim configuration
require("marks").setup({
	-- show letters in the sign column
	signs = true,
	-- only show useful built-ins
	builtin_marks = { ".", "<", ">", "^" },
	-- focus on lowercase marks a-z; set to true if you want A-Z, 0-9 too
	default_mappings = true,
	cyclic = true,
	force_write_shada = false,
	refresh_interval = 150,
	excluded_filetypes = { "NvimTree", "alpha" },
	mappings = {
		set = "m",  -- 'ma' sets mark a
		set_next = "m,", -- place next available alphabetical mark
		toggle = "m;", -- toggle mark at cursor
		next = "]m", -- jump to next mark
		prev = "[m", -- jump to previous mark
		delete = "dm", -- delete mark under cursor (e.g., 'dma')
		delete_line = "dm-", -- delete all marks on current line
		delete_buf = "dm<space>", -- delete all marks in buffer
	},
})
