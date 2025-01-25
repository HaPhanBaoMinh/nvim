-- Navigate vim panes better
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

vim.keymap.set("n", "<C-s>", function()
	vim.cmd("w") -- Lưu file
	vim.lsp.buf.format({ async = true }) -- Format code
end, { noremap = true, silent = true })
vim.keymap.set(
	"i",
	"<C-s>",
	"<Esc>:w<CR>:lua vim.lsp.buf.format({ async = true })<CR>i",
	{ noremap = true, silent = true }
)
vim.keymap.set(
	"v",
	"<C-s>",
	"<Esc>:w<CR>:lua vim.lsp.buf.format({ async = true })<CR>gv",
	{ noremap = true, silent = true }
)

vim.keymap.set("n", "<C-a>", "ggVG", { noremap = true, silent = true })
vim.keymap.set("v", "<C-a>", "ggVG", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<C-c>", '"+yy', { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-c>", '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-v>", '"+p', { noremap = true, silent = true })

vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")

vim.keymap.set("n", "<F2>", function()
	if vim.wo.relativenumber then
		vim.wo.relativenumber = false
		vim.wo.number = true
	else
		vim.wo.relativenumber = true
	end
end, { desc = "Toggle relative line numbers" })
