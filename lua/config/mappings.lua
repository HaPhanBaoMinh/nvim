-- mappings, including plugins

local function map(m, k, v, desc)
	vim.keymap.set(m, k, v, { noremap = true, silent = true, desc = desc })
end

-- set leader
map("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local ok_smart_splits, smart_splits = pcall(require, "smart-splits")

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

-- windows and splits
if ok_smart_splits then
	map("n", "<C-h>", smart_splits.move_cursor_left, "Pane left")
	map("n", "<C-j>", smart_splits.move_cursor_down, "Pane down")
	map("n", "<C-k>", smart_splits.move_cursor_up, "Pane up")
	map("n", "<C-l>", smart_splits.move_cursor_right, "Pane right")
	map("n", "<leader>sH", smart_splits.resize_left, "Split resize left")
	map("n", "<leader>sJ", smart_splits.resize_down, "Split resize down")
	map("n", "<leader>sK", smart_splits.resize_up, "Split resize up")
	map("n", "<leader>sL", smart_splits.resize_right, "Split resize right")
else
	map("n", "<C-h>", "<C-w>h", "Pane left")
	map("n", "<C-j>", "<C-w>j", "Pane down")
	map("n", "<C-k>", "<C-w>k", "Pane up")
	map("n", "<C-l>", "<C-w>l", "Pane right")
	map("n", "<leader>sH", "<Cmd>vertical resize -3<CR>", "Split resize left")
	map("n", "<leader>sJ", "<Cmd>resize +3<CR>", "Split resize down")
	map("n", "<leader>sK", "<Cmd>resize -3<CR>", "Split resize up")
	map("n", "<leader>sL", "<Cmd>vertical resize +3<CR>", "Split resize right")
end
map("n", "<leader>sv", "<Cmd>vsplit<CR>", "Split vertical")
map("n", "<leader>sh", "<Cmd>split<CR>", "Split horizontal")
map("n", "<leader>sc", "<Cmd>close<CR>", "Split close")
map("n", "<leader>so", "<Cmd>only<CR>", "Split only")
map("n", "<leader>se", "<C-w>=", "Split equalize")

-- find/search
map("n", "<leader>ff", "<Cmd>lua require('fzf-lua').files()<CR>", "Find files")
map("n", "<leader>fr", "<Cmd>lua require('fzf-lua').resume()<CR>", "Find resume")
map("n", "<leader>fg", "<Cmd>lua require('fzf-lua').grep()<CR>", "Find grep")
map("n", "<leader>fw", "<Cmd>lua require('fzf-lua').grep_cword()<CR>", "Find word under cursor")
map("n", "<leader>fh", "<Cmd>lua require('fzf-lua').files({ cwd = '~/' })<CR>", "Find home")
map("n", "<leader>fc", "<Cmd>lua require('fzf-lua').files({ cwd = '~/.config' })<CR>", "Find config")
map("n", "<leader>fl", "<Cmd>lua require('fzf-lua').files({ cwd = '~/.local/src' })<CR>", "Find local src")

-- quick nav
map("n", "<leader><Space>", "<C-o>", "Jump back")

-- gui-style shortcuts
map("n", "<C-a>", "ggVG", "Select all")
map("v", "<C-c>", '"+y', "Copy to system clipboard")
map("n", "<C-s>", "<Cmd>w<CR>", "Save")
map("i", "<C-s>", "<Esc><Cmd>w<CR>", "Save")
map("v", "<C-s>", "<Esc><Cmd>w<CR>", "Save")
map("s", "<C-s>", "<Esc><Cmd>w<CR>", "Save")

-- files and tools
map("n", "<leader>as", "<Cmd>w<CR>", "Action save")
map("n", "<leader>aa", ":w ", "Action save as")
map("n", "<leader>ax", "<Cmd>!chmod +x %<CR>", "Action chmod +x")
map("n", "<leader>am", ":!mv % ", "Action move file")
map("n", "<leader>e", "<Cmd>NvimTreeToggle<CR>", "Explorer toggle")
map("n", "<leader>tt", "<Cmd>lua require('FTerm').open()<CR>", "Terminal toggle")
map("t", "<Esc>", '<C-\\><C-n><CMD>lua require("FTerm").close()<CR>', "Terminal close")
map("n", "<leader>th", function()
	_G.htop:toggle()
end, "Terminal htop")

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

-- git (vim-fugitive)
map("n", "<leader>gs", "<Cmd>Git<CR>", "Git status")
map("n", "<leader>gd", "<Cmd>Gvdiffsplit<CR>", "Git diff split")
map("n", "<leader>gb", "<Cmd>Git blame<CR>", "Git blame")
map("n", "<leader>gD", "<Cmd>DiffviewOpen<CR>", "Git diffview open")
map("n", "<leader>gh", "<Cmd>DiffviewFileHistory %<CR>", "Git file history")
map("n", "<leader>gq", "<Cmd>DiffviewClose<CR>", "Git diffview close")

-- build helper
map("n", "<leader>ma", function()
	local bufdir = vim.fn.expand("%:p:h")
	vim.cmd("lcd " .. bufdir)
	vim.cmd("!sudo make uninstall && sudo make clean install %")
end, "Make all in buffer directory")

-- vim-test (requires runners in PATH, e.g. pytest)
map("n", "<leader>tn", "<Cmd>TestNearest<CR>", "Test nearest")
map("n", "<leader>tf", "<Cmd>TestFile<CR>", "Test file")
map("n", "<leader>ts", "<Cmd>TestSuite<CR>", "Test suite")
map("n", "<leader>tl", "<Cmd>TestLast<CR>", "Test last")
map("n", "<leader>tv", "<Cmd>TestVisit<CR>", "Test visit")

-- todo-comments (fzf-lua picker; loads after fzf-lua in defer)
map("n", "<leader>td", "<Cmd>TodoFzfLua<CR>", "Todo list")

-- trouble.nvim
map("n", "<leader>xx", "<Cmd>Trouble diagnostics toggle<CR>", "Trouble toggle diagnostics")
map("n", "<leader>xd", "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>", "Trouble buffer diagnostics")
map("n", "<leader>xq", "<Cmd>Trouble qflist toggle<CR>", "Trouble quickfix list")
map("n", "<leader>xl", "<Cmd>Trouble loclist toggle<CR>", "Trouble location list")

-- folds
map("n", "<leader>zc", "zc", "Fold close")
map("n", "<leader>zo", "zo", "Fold open")
map("n", "<leader>za", "za", "Fold toggle")
map("n", "<leader>zM", "zM", "Fold close all")
map("n", "<leader>zR", "zR", "Fold open all")
