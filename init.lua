vim.g.start_time = vim.fn.reltime()
vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Pinned plugins still call this deprecated helper on Neovim 0.12. Keep the
-- baseline compatibility behavior without paying for the warning prompt.
if vim.iter then
	vim.tbl_flatten = function(value)
		return vim.iter(value):flatten(math.huge):totable()
	end
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local result = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		error("Unable to bootstrap lazy.nvim:\n" .. result)
	end
end
vim.opt.rtp:prepend(lazypath)

require("core.theme")
require("core.options")
require("core.keymaps")
require("core.autocmds")

require("lazy").setup({
	spec = {
		{ import = "plugin_specs.ui" },
		{ import = "plugin_specs.editor" },
		{ import = "plugin_specs.tools" },
		{ import = "plugin_specs.lang" },
	},
	defaults = { lazy = true },
	install = { colorscheme = { "catppuccin", "gruvbox" } },
	checker = { enabled = false },
	change_detection = { notify = false },
	performance = {
		rtp = {
			disabled_plugins = { "gzip", "netrwPlugin", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
		},
	},
})

-- Preserve the old command and keymap workflow while lazy.nvim owns the backend.
vim.api.nvim_create_user_command("PlugInstall", function()
	require("lazy").sync()
end, { desc = "Install/update plugins with lazy.nvim" })

load_theme()
