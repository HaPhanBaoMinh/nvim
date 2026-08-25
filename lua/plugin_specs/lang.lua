local lsp_event = { "BufReadPre", "BufNewFile", "InsertEnter" }

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdateSync",
		config = function()
			require("plugins.treesitter")
		end,
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = "markdown",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		config = function()
			require("plugins.render-markdown")
		end,
	},
	{
		"towolf/vim-helm",
		lazy = false,
	},
	{
		"mason-org/mason.nvim",
		version = "^2.0.0",
		cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall", "MasonLog" },
		config = true,
	},
	{
		"neovim/nvim-lspconfig",
		version = "v1.8.0",
		event = lsp_event,
		dependencies = {
			{ "mason-org/mason.nvim", version = "^2.0.0" },
			{ "mason-org/mason-lspconfig.nvim", version = "^2.0.0" },
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
		config = function()
			require("plugins.lsp")
		end,
	},
	{
		"stevearc/conform.nvim",
		branch = "nvim-0.9",
		event = "BufWritePre",
		keys = { { "<leader>cf", mode = { "n", "v" }, desc = "Format buffer (conform)" } },
		config = function()
			require("plugins.conform")
		end,
	},
	{
		"mfussenegger/nvim-lint",
		event = "BufWritePost",
		config = function()
			require("plugins.nvim-lint")
		end,
	},
	{
		"mfussenegger/nvim-dap",
		keys = {
			{ "<leader>db", desc = "DAP toggle breakpoint" },
			{ "<leader>dB", desc = "DAP conditional breakpoint" },
			{ "<leader>dc", desc = "DAP continue" },
			{ "<leader>di", desc = "DAP step into" },
			{ "<leader>do", desc = "DAP step over" },
			{ "<leader>dO", desc = "DAP step out" },
			{ "<leader>dr", desc = "DAP REPL" },
			{ "<leader>du", desc = "DAP UI toggle" },
		},
		dependencies = {
			{ "rcarriga/nvim-dap-ui", version = "v3.9.3" },
			{ "jay-babu/mason-nvim-dap.nvim", version = "v1.2.2" },
			{ "mason-org/mason.nvim", version = "^2.0.0" },
		},
		config = function()
			require("plugins.dap")
		end,
	},
}
