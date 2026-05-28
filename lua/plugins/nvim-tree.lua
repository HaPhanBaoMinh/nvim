local api = require("nvim-tree.api")

local function on_attach(bufnr)
	api.config.mappings.default_on_attach(bufnr)
	-- y = name, Y = relative path, gy = absolute path (needs use_system_clipboard)
end

require("nvim-tree").setup({
	renderer = {
		icons = {
			show = {
				file = false,
				folder = false,
				folder_arrow = true,
				git = true,
			},
		},
	},
	view = {
		width = 25,
		side = "left",
	},
	sync_root_with_cwd = true,
	respect_buf_cwd = true,
	update_cwd = true,
	update_focused_file = {
		enable = true,
		update_cwd = true,
		update_root = true,
	},
	actions = {
		use_system_clipboard = true,
	},
	on_attach = on_attach,
})

vim.g.nvim_tree_respect_buf_cwd = 1
