local M = {}
local resize_step = 6
local resize_mode_active = false
local resize_mode_maps = {}

function M.setup()
	require("smart-splits").setup({
		ignored_buftypes = { "nofile", "quickfix", "prompt" },
		ignored_filetypes = { "NvimTree" },
		default_amount = resize_step,
		resize_mode = {
			quit_key = "<ESC>",
			resize_keys = { "h", "j", "k", "l" },
			silent = true,
		},
	})
end

function M.resize(direction)
	require("smart-splits.api")["resize_" .. direction](vim.v.count1 * resize_step)
end

local function exit_resize_mode()
	if not resize_mode_active then
		return
	end
	for _, lhs in ipairs(resize_mode_maps) do
		pcall(vim.keymap.del, "n", lhs)
	end
	resize_mode_maps = {}
	resize_mode_active = false
	vim.notify("Resize mode off", vim.log.levels.INFO)
end

function M.enter_resize_mode()
	if resize_mode_active then
		return
	end
	resize_mode_active = true
	local directions = {
		["<Left>"] = "left",
		["<Down>"] = "down",
		["<Up>"] = "up",
		["<Right>"] = "right",
	}
	for lhs, direction in pairs(directions) do
		vim.keymap.set("n", lhs, function()
			M.resize(direction)
		end, { noremap = true, silent = true })
		resize_mode_maps[#resize_mode_maps + 1] = lhs
	end
	vim.keymap.set("n", "<Esc>", exit_resize_mode, { noremap = true, silent = true })
	resize_mode_maps[#resize_mode_maps + 1] = "<Esc>"
	vim.notify("Resize mode on: use arrow keys, <Esc> to exit", vim.log.levels.INFO)
end

return M
