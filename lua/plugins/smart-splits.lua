require("smart-splits").setup({
	ignored_buftypes = { "nofile", "quickfix", "prompt" },
	ignored_filetypes = { "NvimTree" },
	resize_mode = {
		quit_key = "<ESC>",
		resize_keys = { "h", "j", "k", "l" },
		silent = true,
	},
})
