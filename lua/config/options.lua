local options = {
	laststatus = 3,
	ruler = false, --disable extra numbering
	showmode = false, --not needed due to lualine
	showcmd = false,
	wrap = true, --toggle bound to leader W
	mouse = "a", --enable mouse
	timeout = true,
	timeoutlen = 400, --faster key sequence resolution (leader feels snappier)
	ttimeoutlen = 10,
	clipboard = "unnamedplus", --system clipboard integration
	history = 100, --command line history
	swapfile = false, --swap just gets in the way, usually
	backup = false,
	undofile = true, --undos are saved to file
	cursorline = true, --highlight line

	title = true, --automatic window titlebar

	-- new splits open in the direction you expect (right / below)
	splitright = true,
	splitbelow = true,

	number = true, --numbering lines
	relativenumber = true, --toggle bound to leader nn
	numberwidth = 4,

	smarttab = true, --indentation stuff
	cindent = true,
	autoindent = false,
	tabstop = 4, --visual width of tab

	foldmethod = "expr",
	foldlevel = 99, --disable folding, lower #s enable
	foldexpr = "v:lua.vim.treesitter.foldexpr()",
	
	termguicolors = true,

	ignorecase = true, --ignore case while searching
	smartcase = true, --but do not ignore if caps are used

	conceallevel = 2, --markdown conceal
	concealcursor = "nc",

	splitkeep = 'screen', --stablizie window open/close
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

-- System clipboard: wl-clipboard when Wayland env exists, else OSC52 (Neovim 0.10+ built-in).
local clipboard = require("config.clipboard")

local function clip_copy(lines, _)
	clipboard.copy_lines(lines)
end

local function clip_paste()
	return clipboard.paste_lines()
end

vim.g.clipboard = {
	name = "hybrid-wl-osc52",
	copy = { ["+"] = clip_copy, ["*"] = clip_copy },
	paste = { ["+"] = clip_paste, ["*"] = clip_paste },
	cache_enabled = 0,
}

vim.diagnostic.config({
	signs = true,
	virtual_text = true,
	underline = true,
	float = { border = "rounded" },
})
