-- theme choice is saved in a file for persistence on restart
-- lualine theme name can differ from colorscheme name

local theme_file = vim.fn.stdpath("config") .. "/lua/config/saved_theme"

_G.load_theme = function()
	local file = io.open(theme_file, "r")
	if not file then
		return
	end
	local colorscheme = file:read("*l")
	local lualine_theme = file:read("*l")
	file:close()
	if colorscheme and colorscheme ~= "" then
		pcall(vim.cmd, "colorscheme " .. colorscheme)
	end
	if lualine_theme and lualine_theme ~= "" then
		require("lualine").setup({ options = { theme = lualine_theme } })
	end
end

local themes = {
	{ "catppuccin", "catppuccin" },
	{ "gruvbox", "gruvbox" },
	{ "pywal16", "pywal16-nvim" },
}

local current_theme_index = 1

_G.switch_theme = function()
	current_theme_index = current_theme_index % #themes + 1
	local colorscheme, lualine_name = unpack(themes[current_theme_index])
	vim.cmd("colorscheme " .. colorscheme)
	require("lualine").setup({ options = { theme = lualine_name } })
	local file = io.open(theme_file, "w")
	if file then
		file:write(colorscheme .. "\n" .. lualine_name .. "\n")
		file:close()
	end
end
