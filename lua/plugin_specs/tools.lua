return {
	{
		"lewis6991/gitsigns.nvim",
		version = "v0.9.0",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("plugins.gitsigns")
		end,
	},
	{
		"tpope/vim-fugitive",
		cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gblame" },
		keys = {
			{ "<leader>gs", "<Cmd>Git<CR>", desc = "Git status" },
			{ "<leader>gd", "<Cmd>Gvdiffsplit<CR>", desc = "Git diff split" },
			{ "<leader>gb", "<Cmd>Git blame<CR>", desc = "Git blame" },
		},
	},
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
		keys = {
			{ "<leader>gD", "<Cmd>DiffviewOpen<CR>", desc = "Git diffview open" },
			{ "<leader>gh", "<Cmd>DiffviewFileHistory %<CR>", desc = "Git file history" },
			{ "<leader>gq", "<Cmd>DiffviewClose<CR>", desc = "Git diffview close" },
		},
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		keys = {
			{ "<leader>xx", "<Cmd>Trouble diagnostics toggle<CR>", desc = "Trouble toggle diagnostics" },
			{ "<leader>xd", "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Trouble buffer diagnostics" },
			{ "<leader>xq", "<Cmd>Trouble qflist toggle<CR>", desc = "Trouble quickfix list" },
			{ "<leader>xl", "<Cmd>Trouble loclist toggle<CR>", desc = "Trouble location list" },
		},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("plugins.trouble")
		end,
	},
	{
		"folke/todo-comments.nvim",
		version = "v1.4.0",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TodoFzfLua", "TodoQuickFix", "TodoLocList" },
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("plugins.todo-comments")
		end,
	},
	{
		"vim-test/vim-test",
		cmd = { "TestNearest", "TestFile", "TestSuite", "TestLast", "TestVisit" },
		keys = {
			{ "<leader>tn", "<Cmd>TestNearest<CR>", desc = "Test nearest" },
			{ "<leader>tf", "<Cmd>TestFile<CR>", desc = "Test file" },
			{ "<leader>ts", "<Cmd>TestSuite<CR>", desc = "Test suite" },
			{ "<leader>tl", "<Cmd>TestLast<CR>", desc = "Test last" },
			{ "<leader>tv", "<Cmd>TestVisit<CR>", desc = "Test visit" },
		},
		init = function()
			require("plugins.vim-test")
		end,
	},
}
