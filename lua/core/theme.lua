-- Theme state is machine-local. Keeping it under stdpath("state") avoids a
-- dirty Git worktree whenever <leader>ut cycles the colorscheme.
local state_dir = vim.fn.stdpath("state") .. "/bread-nvim"
local theme_file = state_dir .. "/theme"

local themes = {
	{ "catppuccin", "catppuccin-frappe" },
	{ "gruvbox", "gruvbox" },
	{ "pywal16", "pywal" },
}

local current_theme_index = 1

local function read_theme()
	local file = io.open(theme_file, "r")
	if not file then
		return themes[1]
	end
	local colorscheme = file:read("*l")
	file:close()
	for index, theme in ipairs(themes) do
		if theme[1] == colorscheme then
			current_theme_index = index
			return theme
		end
	end
	return themes[1]
end

local function apply(theme)
	local colorscheme = theme[1]
	pcall(vim.cmd.colorscheme, colorscheme)
	if package.loaded.lualine then
		require("plugins.lualine").setup(theme[2])
	end
end

function _G.load_theme()
	apply(read_theme())
end

function _G.current_lualine_theme()
	return read_theme()[2]
end

_G.switch_theme = function()
	read_theme()
	current_theme_index = current_theme_index % #themes + 1
	local theme = themes[current_theme_index]
	apply(theme)
	vim.fn.mkdir(state_dir, "p")
	local file = io.open(theme_file, "w")
	if file then
		file:write(theme[1] .. "\n")
		file:close()
	end
end
