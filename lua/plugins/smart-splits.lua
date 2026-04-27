require("smart-splits").setup({
	ignored_buftypes = { "nofile", "quickfix", "prompt" },
	ignored_filetypes = { "NvimTree" },
	default_amount = 6,
	resize_mode = {
		quit_key = "<ESC>",
		resize_keys = { "h", "j", "k", "l" },
		silent = true,
	},
})
