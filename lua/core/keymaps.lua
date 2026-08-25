-- mappings, including plugins

local function map(m, k, v, desc)
	vim.keymap.set(m, k, v, { noremap = true, silent = true, desc = desc })
end

-- set leader
map("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- buffers
map("n", "<leader>bn", "<Cmd>BufferNext<CR>", "Buffer next")
map("n", "<leader>bp", "<Cmd>BufferPrevious<CR>", "Buffer previous")
map("n", "<leader>bd", "<Cmd>BufferClose<CR>", "Buffer close")
map("n", "<leader>bD", "<Cmd>BufferClose!<CR>", "Buffer close force")
map("n", "<leader>ba", "<Cmd>bufdo bd<CR>", "Buffer close all")
map("n", "<leader>bh", "<Cmd>BufferMovePrevious<CR>", "Buffer move left")
map("n", "<leader>bl", "<Cmd>BufferMoveNext<CR>", "Buffer move right")
map("n", "<leader>bP", "<Cmd>BufferPin<CR>", "Buffer pin")
map("n", "<leader>1", "<Cmd>BufferGoto 1<CR>", "Buffer 1")
map("n", "<leader>2", "<Cmd>BufferGoto 2<CR>", "Buffer 2")
map("n", "<leader>3", "<Cmd>BufferGoto 3<CR>", "Buffer 3")
map("n", "<leader>4", "<Cmd>BufferGoto 4<CR>", "Buffer 4")
map("n", "<leader>5", "<Cmd>BufferGoto 5<CR>", "Buffer 5")
map("n", "<leader>6", "<Cmd>BufferGoto 6<CR>", "Buffer 6")
map("n", "<leader>7", "<Cmd>BufferGoto 7<CR>", "Buffer 7")
map("n", "<leader>8", "<Cmd>BufferGoto 8<CR>", "Buffer 8")
map("n", "<leader>9", "<Cmd>BufferGoto 9<CR>", "Buffer 9")
map("n", "<leader>0", "<Cmd>BufferLast<CR>", "Buffer last")

-- smart-splits navigation/resize maps live in lua/plugins/smart-splits.lua so
-- lazy.nvim can use the exact keys as load triggers.
map("n", "<leader>sv", "<Cmd>vsplit<CR>", "Split vertical")
map("n", "<leader>sh", "<Cmd>split<CR>", "Split horizontal")
map("n", "<leader>sc", "<Cmd>close<CR>", "Split close")
map("n", "<leader>so", "<Cmd>only<CR>", "Split only")
map("n", "<leader>se", "<C-w>=", "Split equalize")

-- quick nav
map("n", "<leader><Space>", "<C-o>", "Jump back")
map("n", "<leader>km", "<Cmd>edit ~/.config/nvim/lua/core/keymaps.lua<CR>", "Help open nvim keymaps")
map("n", "<leader>kt", "<Cmd>edit ~/.config/nvim/tmux/keymaps.conf<CR>", "Help open tmux keymaps")

-- gui-style shortcuts (do not remap y/Y — nvim-tree uses them for copy path)
map("n", "<C-a>", "ggVG", "Select all")
map("n", "<C-c>", '"+yy', "Copy line to clipboard")
map("v", "<C-c>", '"+y', "Copy selection to clipboard")
map("n", "<C-v>", '"+p', "Paste from clipboard")
map("i", "<C-v>", '<Esc>"+pa', "Paste from clipboard")
map("c", "<C-v>", "<C-r>+", "Paste from clipboard (cmdline)")
map("n", "<C-s>", "<Cmd>w<CR>", "Save")
map("i", "<C-s>", "<Esc><Cmd>w<CR>", "Save")
map("v", "<C-s>", "<Esc><Cmd>w<CR>", "Save")
map("s", "<C-s>", "<Esc><Cmd>w<CR>", "Save")

-- files and tools
map("n", "<leader>as", "<Cmd>w<CR>", "Action save")
map("n", "<leader>aa", ":w ", "Action save as")
map("n", "<leader>ax", "<Cmd>!chmod +x %<CR>", "Action chmod +x")
map("n", "<leader>am", ":!mv % ", "Action move file")

-- misc
map("n", "<leader>rr", ":%s//g<Left><Left>", "Replace all")
map("n", "<leader>pi", "<Cmd>PlugInstall<CR>", "Plugins install")
map("n", "<leader>rc", "<Cmd>so %<CR>", "Reload current file")
map("n", "<leader>ou", ':silent !xdg-open "<cWORD>" &<CR>', "Open URL")
map("n", "<leader>of", "<Cmd>silent !xdg-open %:p:h &<CR>", "Open file folder")
map("v", "<leader>i", "=gv", "Indent selection")
map("n", "<leader>ut", switch_theme, "UI toggle theme")
map("n", "<leader>uw", "<Cmd>set wrap!<CR>", "UI toggle wrap")
map("n", "<leader>un", function()
	if vim.wo.relativenumber then
		vim.wo.relativenumber = false
		vim.wo.number = true
	else
		vim.wo.relativenumber = true
	end
end, "UI toggle relative numbers")

-- build helper
map("n", "<leader>ma", function()
	local bufdir = vim.fn.expand("%:p:h")
	vim.cmd("lcd " .. bufdir)
	vim.cmd("!sudo make uninstall && sudo make clean install %")
end, "Make all in buffer directory")

-- folds
map("n", "<leader>zc", "zc", "Fold close")
map("n", "<leader>zo", "zo", "Fold open")
map("n", "<leader>za", "za", "Fold toggle")
map("n", "<leader>zM", "zM", "Fold close all")
map("n", "<leader>zR", "zR", "Fold open all")
