return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
		config = function()
			require("plugins.colorscheme").catppuccin()
		end,
	},
	{
		"ellisonleao/gruvbox.nvim",
		name = "gruvbox",
		lazy = true,
		config = function()
			require("plugins.colorscheme").gruvbox()
		end,
	},
	{ "uZer/pywal16.nvim", name = "pywal16", lazy = true },
	{
		"nvim-lualine/lualine.nvim",
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("plugins.lualine").setup(current_lualine_theme())
		end,
	},
	{
		"romgrk/barbar.nvim",
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("plugins.barbar")
		end,
	},
	{
		"goolord/alpha-nvim",
		cmd = "Alpha",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		init = function()
			if vim.fn.argc() == 0 and vim.g.read_from_stdin ~= 1 then
				vim.api.nvim_create_autocmd("VimEnter", {
					once = true,
					callback = function()
						require("lazy").load({ plugins = { "alpha-nvim" } })
						require("alpha").start(true)
					end,
				})
			end
		end,
		config = function()
			require("plugins.alpha")
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("plugins.which-key")
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("plugins.indent-blankline")
		end,
	},
}
