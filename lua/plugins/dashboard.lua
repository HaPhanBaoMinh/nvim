local ok, db = pcall(require, "dashboard")
if not ok then
	vim.schedule(function()
		vim.notify("[dashboard-nvim] Chạy :PlugInstall (chưa có plugin).", vim.log.levels.WARN)
	end)
	return
end

db.setup({
	theme = "doom",
	hide = {
		statusline = true,
		tabline = true,
		winbar = true,
	},
	config = {
		header = {
			[[  ^  ^  ^   ^☆ ★ ☆ ___I_☆ ★ ☆ ^  ^   ^  ^  ^   ^  ^ ]],
			[[ /|\/|\/|\ /|\ ★☆ /\-_--\ ☆ ★/|\/|\ /|\/|\/|\ /|\/|\ ]],
			[[ /|\/|\/|\ /|\ ★ /  \_-__\☆ ★/|\/|\ /|\/|\/|\ /|\/|\ ]],
			[[ /|\/|\/|\ /|\ 󰻀 |[]| [] | 󰻀 /|\/|\ /|\/|\/|\ /|\/|\ ]],
			"",
		},
		center = {
			{
				icon = " ",
				icon_hl = "Title",
				desc = "New file",
				desc_hl = "String",
				key = "e",
				key_hl = "Number",
				action = "ene | startinsert",
			},
			{
				icon = "󰍉 ",
				desc = "Find file",
				key = "f",
				action = "lua require('fzf-lua').files()",
			},
			{
				icon = " ",
				desc = "Browse cwd (tree)",
				key = "t",
				action = "NvimTreeOpen",
			},
			{
				icon = " ",
				desc = "Browse ~/.local/src",
				key = "r",
				action = "edit ~/.local/src/",
			},
			{
				icon = "󰯂 ",
				desc = "Browse ~/scripts",
				key = "s",
				action = "edit ~/scripts/",
			},
			{
				icon = " ",
				desc = "Neovim config",
				key = "c",
				action = "edit ~/.config/nvim/",
			},
			{
				icon = " ",
				desc = "Mappings",
				key = "m",
				action = "edit ~/.config/nvim/lua/config/mappings.lua",
			},
			{
				icon = " ",
				desc = "Run PlugInstall",
				key = "p",
				action = "PlugInstall",
			},
			{
				icon = "󰅙 ",
				desc = "Quit",
				key = "q",
				action = "quit",
			},
		},
		footer = function()
			return { "", vim.g.startup_time_ms or "" }
		end,
	},
})

-- Mặc định plugin chỉ gọi dashboard trên UIEnter; một số môi trường bỏ lỡ hoặc buffer
-- trống bị nomodifiable khiến :instance() thoát im lặng — thử lại sau VimEnter.
vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		if vim.fn.argc() > 0 or vim.g.read_from_stdin == 1 then
			return
		end
		vim.defer_fn(function()
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "dashboard" then
					return
				end
			end
			local buf = vim.api.nvim_get_current_buf()
			if vim.api.nvim_buf_get_name(buf) ~= "" then
				return
			end
			if not vim.bo[buf].modifiable then
				vim.bo[buf].modifiable = true
			end
			pcall(function()
				require("dashboard"):instance()
			end)
		end, 150)
	end,
})
