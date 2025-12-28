-- mappings, including plugins

local function map(m, k, v)
	vim.keymap.set(m, k, v, { noremap = true, silent = true })
end

-- set leader
map("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- =========================
-- Buffers
-- =========================
map("n", "<S-l>", ":bnext<CR>")
map("n", "<S-h>", ":bprevious<CR>")
map("n", "<leader>q", ":BufferClose<CR>")
map("n", "<leader>Q", ":BufferClose!<CR>")
map("n", "<leader>U", ":bufdo bd<CR>")          -- close all
map("n", "<leader>vs", ":vsplit<CR>:bnext<CR>") -- vertical split + next buffer
map("n", "<leader>cv", "<C-w>c")                -- close vertical split

-- buffer position nav + reorder
map("n", "<AS-h>", "<Cmd>BufferMovePrevious<CR>")
map("n", "<AS-l>", "<Cmd>BufferMoveNext<CR>")
for i = 1, 9 do
	map("n", "<A-" .. i .. ">", "<Cmd>BufferGoto " .. i .. "<CR>")
end
map("n", "<A-0>", "<Cmd>BufferLast<CR>")
map("n", "<A-p>", "<Cmd>BufferPin<CR>")

-- =========================
-- Windows navigation + resize
-- =========================
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("n", "<F5>", ":resize +2<CR>")
map("n", "<F6>", ":resize -2<CR>")
map("n", "<F7>", ":vertical resize +2<CR>")
map("n", "<F8>", ":vertical resize -2<CR>")

-- =========================
-- FZF and grep
-- =========================
map("n", "<leader>f", ":lua require('fzf-lua').files()<CR>")
map("n", "<leader>Fh", ":lua require('fzf-lua').files({ cwd = '~/' })<CR>")
map("n", "<leader>Fc", ":lua require('fzf-lua').files({ cwd = '~/.config' })<CR>")
map("n", "<leader>Fl", ":lua require('fzf-lua').files({ cwd = '~/.local/src' })<CR>")
map("n", "<leader>Ff", ":lua require('fzf-lua').files({ cwd = '..' })<CR>")
map("n", "<leader>Fr", ":lua require('fzf-lua').resume()<CR>")
map("n", "<leader>g", ":lua require('fzf-lua').grep()<CR>")
map("n", "<leader>G", ":lua require('fzf-lua').grep_cword()<CR>")

-- =========================
-- Misc
-- =========================
map("n", "<leader>s", ":%s//g<Left><Left>")
map("n", "<leader>t", ":NvimTreeToggle<CR>")
map("n", "<leader>p", switch_theme)
map("n", "<leader>P", ":PlugInstall<CR>")
map("n", "<leader>z", ":lua require('FTerm').open()<CR>")
map("t", "<Esc>", '<C-\\><C-n><CMD>lua require("FTerm").close()<CR>')
map("n", "<leader>w", ":w<CR>")
map("n", "<leader>x", "<cmd>!chmod +x %<CR>")
map("n", "<leader>mv", ":!mv % ")
map("n", "<leader>R", ":so %<CR>")
map("n", "<leader>u", ':silent !xdg-open "<cWORD>" &<CR>')
map("v", "<leader>i", "=gv")
map("n", "<leader>W", ":set wrap!<CR>")
map("n", "<leader>l", ":Twilight<CR>")

-- decisive csv
map("n", "<leader>csa", ":lua require('decisive').align_csv({})<CR>")
map("n", "<leader>csA", ":lua require('decisive').align_csv_clear({})<CR>")
map("n", "[c", ":lua require('decisive').align_csv_prev_col()<CR>")
map("n", "]c", ":lua require('decisive').align_csv_next_col()<CR>")

-- Lazy config
map("n", "<C-a>", "ggVG")
map("v", "<C-c>", '"+y')
map("n", "<C-c>", '"+yy')
map("i", "<C-s>", "<Esc>:w!<CR>")
map("v", "<C-s>", "<Esc>:w!<CR>")
map("n", "<C-s>", ":w!<CR>")
map("n", "<leader>b", "<C-^>") -- toggle last buffer

-- Flash.nvim
map("n", "s", function() require("flash").jump() end, { desc = "Flash Jump" })

-- custom
map("n", "<leader>H", function() _G.htop:toggle() end)
map("n", "<leader>ma", function()
	local bufdir = vim.fn.expand("%:p:h")
	vim.cmd("lcd " .. bufdir)
	vim.cmd("!sudo make uninstall && sudo make clean install %")
end)
map("n", "<leader>nn", function()
	vim.wo.relativenumber = not vim.wo.relativenumber
end)
