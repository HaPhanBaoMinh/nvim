-- bread's neovim config
-- keymaps are in lua/config/mappings.lua
-- install a patched font & ensure your terminal supports glyphs
-- enjoy :D

-- auto install vim-plug and plugins, if not found
local data_dir = vim.fn.stdpath('data')
if vim.fn.empty(vim.fn.glob(data_dir .. '/site/autoload/plug.vim')) == 1 then
	vim.cmd('silent !curl -fLo ' .. data_dir .. '/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
	vim.o.runtimepath = vim.o.runtimepath
	vim.cmd('autocmd VimEnter * PlugInstall --sync | source $MYVIMRC')
end

local vim = vim
local Plug = vim.fn['plug#']

vim.g.start_time = vim.fn.reltime()
vim.loader.enable() --  SPEEEEEEEEEEED 
vim.call('plug#begin')

Plug('catppuccin/nvim', { ['as'] = 'catppuccin' }) --colorscheme
Plug('ellisonleao/gruvbox.nvim', { ['as'] = 'gruvbox' }) --colorscheme 2
Plug('uZer/pywal16.nvim', { [ 'as' ] = 'pywal16' }) --or, pywal colorscheme
Plug('nvim-lualine/lualine.nvim') --statusline
Plug('nvim-tree/nvim-web-devicons') --pretty icons
Plug('folke/which-key.nvim') --mappings popup
Plug('romgrk/barbar.nvim') --bufferline
Plug('goolord/alpha-nvim') --pretty startup
Plug('nvim-treesitter/nvim-treesitter') --improved syntax
Plug('mfussenegger/nvim-lint') --async linter
Plug('nvim-tree/nvim-tree.lua') --file explorer
Plug('windwp/nvim-autopairs') --autopairs 
Plug('lewis6991/gitsigns.nvim', { ['tag'] = 'v0.9.0' }) --git (v0.9.0: last version supporting nvim 0.9)
Plug('numToStr/Comment.nvim') --easier comments
Plug('norcalli/nvim-colorizer.lua') --color highlight
Plug('ibhagwan/fzf-lua') --fuzzy finder and grep
Plug('numToStr/FTerm.nvim') --floating terminal
Plug('ron-rs/ron.vim') --ron syntax highlighting
Plug('MeanderingProgrammer/render-markdown.nvim') --render md inline
Plug('emmanueltouzery/decisive.nvim') --view csv files
Plug('folke/twilight.nvim') --surrounding dim

-- LSP / completion / format / DAP (Mason pinned v1.x for Neovim 0.9)
Plug('nvim-lua/plenary.nvim')
Plug('mason-org/mason.nvim', { ['tag'] = 'v1.9.0' })
Plug('mason-org/mason-lspconfig.nvim', { ['tag'] = 'v1.32.0' })
Plug('neovim/nvim-lspconfig', { ['tag'] = 'v1.8.0' }) -- v2+ uses vim.uv (Neovim 0.10+)
Plug('jay-babu/mason-nvim-dap.nvim', { ['tag'] = 'v1.2.2' })
Plug('mfussenegger/nvim-dap')
Plug('rcarriga/nvim-dap-ui', { ['tag'] = 'v3.9.3' }) -- v4+ needs nvim-nio / vim.uv
Plug('stevearc/conform.nvim', { ['branch'] = 'nvim-0.9' }) -- main requires 0.10+
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
Plug('L3MON4D3/LuaSnip')
Plug('saadparwaiz1/cmp_luasnip')
Plug('rafamadriz/friendly-snippets')
Plug('kylechui/nvim-surround')
Plug('lukas-reineke/indent-blankline.nvim')
Plug('folke/todo-comments.nvim', { ['tag'] = 'v1.4.0' }) -- v1.5+ uses vim.uv
Plug('vim-test/vim-test')

vim.call('plug#end')

-- move config and plugin config to alternate files
require("config.theme")
require("config.mappings")
require("config.options")
require("config.autocmd")

require("plugins.alpha")
-- require("plugins.autopairs")
require("plugins.barbar")
require("plugins.colorizer")
require("plugins.colorscheme")
require("plugins.comment")
-- require("plugins.fterm")
-- require("plugins.fzf-lua")
require("plugins.gitsigns")
require("plugins.lualine")
require("plugins.nvim-lint")
-- require("plugins.nvim-tree")
require("plugins.render-markdown")
-- require("plugins.treesitter")
-- require("plugins.twilight")
-- require("plugins.which-key")

-- defer heavy plugin setup so the first frame paints sooner (profile: nvim --startuptime /tmp/nvim.log +q)
vim.defer_fn(function()
	for _, mod in ipairs({
		"plugins.lsp",
		"plugins.conform",
		"plugins.vim-test",
		"plugins.surround",
		"plugins.indent-blankline",
		"plugins.autopairs",
		"plugins.fterm",
		"plugins.fzf-lua",
		"plugins.todo-comments",
		"plugins.dap",
		"plugins.nvim-tree",
		"plugins.treesitter",
		"plugins.twilight",
		"plugins.which-key",
	}) do
		local ok, err = pcall(require, mod)
		if not ok then
			vim.schedule(function()
				vim.notify(("[plugins] require " .. mod .. " failed:\n" .. tostring(err)), vim.log.levels.WARN)
			end)
		end
	end
end, 100)

load_theme()
