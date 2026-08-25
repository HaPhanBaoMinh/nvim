local function plugin_keys(keys)
	local result = {}
	for _, item in ipairs(keys) do
		result[#result + 1] = { item[1], item[2], mode = item.mode or "n", desc = item[3], silent = true }
	end
	return result
end

return {
	{
		"mrjones2014/smart-splits.nvim",
		keys = plugin_keys({
			{ "<C-h>", function() require("smart-splits.api").move_cursor_left() end, "Pane left" },
			{ "<C-j>", function() require("smart-splits.api").move_cursor_down() end, "Pane down" },
			{ "<C-k>", function() require("smart-splits.api").move_cursor_up() end, "Pane up" },
			{ "<C-l>", function() require("smart-splits.api").move_cursor_right() end, "Pane right" },
			{ "<leader>sH", function() require("plugins.smart-splits").resize("left") end, "Split resize left (count x 6)" },
			{ "<leader>sJ", function() require("plugins.smart-splits").resize("down") end, "Split resize down (count x 6)" },
			{ "<leader>sK", function() require("plugins.smart-splits").resize("up") end, "Split resize up (count x 6)" },
			{ "<leader>sL", function() require("plugins.smart-splits").resize("right") end, "Split resize right (count x 6)" },
			{ "<leader>sr", function() require("plugins.smart-splits").enter_resize_mode() end, "Split resize mode (arrows, Esc to quit)" },
		}),
		config = function()
			require("plugins.smart-splits").setup()
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFindFile" },
		keys = { { "<leader>e", "<Cmd>NvimTreeToggle<CR>", desc = "Explorer toggle" } },
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("plugins.nvim-tree")
		end,
	},
	{
		"ibhagwan/fzf-lua",
		cmd = "FzfLua",
		keys = plugin_keys({
			{ "<leader>ff", function() require("fzf-lua").files() end, "Find files" },
			{ "<leader>fr", function() require("fzf-lua").resume() end, "Find resume" },
			{ "<leader>fg", function() require("fzf-lua").grep() end, "Find grep" },
			{ "<leader>fw", function() require("fzf-lua").grep_cword() end, "Find word under cursor" },
			{ "<leader>fh", function() require("fzf-lua").files({ cwd = "~/" }) end, "Find home" },
			{ "<leader>fc", function() require("fzf-lua").files({ cwd = "~/.config" }) end, "Find config" },
			{ "<leader>fl", function() require("fzf-lua").files({ cwd = "~/.local/src" }) end, "Find local src" },
		}),
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("plugins.fzf-lua")
		end,
	},
	{
		"numToStr/FTerm.nvim",
		keys = {
			{ "<leader>tt", function() require("FTerm").open() end, desc = "Terminal toggle" },
			{ "<leader>th", function() _G.htop:toggle() end, desc = "Terminal htop" },
			{ "<Esc>", mode = "t", function() require("FTerm").close() end, desc = "Terminal close" },
		},
		config = function()
			require("plugins.fterm")
		end,
	},
	{
		"numToStr/Comment.nvim",
		keys = {
			{ "gc", mode = { "n", "x" } },
			{ "gb", mode = { "n", "x" } },
			"gcc",
			"gco",
			"gcO",
			"gcA",
		},
		config = function()
			require("plugins.comment")
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("plugins.autopairs")
		end,
	},
	{
		"kylechui/nvim-surround",
		keys = { "ys", "ds", "cs", { "S", mode = "x" } },
		config = function()
			require("plugins.surround")
		end,
	},
}
