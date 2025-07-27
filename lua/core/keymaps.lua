-- Navigate vim panes better
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

vim.api.nvim_set_keymap("v", "<Tab>", ">gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<S-Tab>", "<gv", { noremap = true, silent = true })

-- Move lines up and down
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { noremap = true, silent = true })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { noremap = true, silent = true })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { noremap = true, silent = true })
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { noremap = true, silent = true })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })

vim.keymap.set("n", "<C-S-Left>", "<cmd>vertical resize -5<CR>")
vim.keymap.set("n", "<C-S-Right>", "<cmd>vertical resize +5<CR>")
vim.keymap.set("n", "<C-S-Up>", "<cmd>resize +2<CR>")
vim.keymap.set("n", "<C-S-Down>", "<cmd>resize -2<CR>")

vim.keymap.set("n", "<C-s>", function()
  vim.cmd("w")
  vim.lsp.buf.format({ async = true })
end, { noremap = true, silent = true })

vim.keymap.set("i", "<C-s>", "<Esc>:w!<CR>:lua vim.lsp.buf.format({ async = true })<CR>",
  { noremap = true, silent = true })
vim.keymap.set("v", "<C-s>", "<Esc>:w!<CR>:lua vim.lsp.buf.format({ async = true })<CR>",
  { noremap = true, silent = true })
vim.keymap.set("n", "<C-a>", "ggVG", { noremap = true, silent = true })
vim.keymap.set("v", "<C-a>", "ggVG", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")

vim.keymap.set("n", "<F2>", function()
  if vim.wo.relativenumber then
    vim.wo.relativenumber = false
    vim.wo.number = true
  else
    vim.wo.relativenumber = true
  end
end, { desc = "Toggle relative line numbers" })

vim.keymap.set("n", "s", function()
  require("flash").jump()
end, { desc = "Flash Jump" })

vim.keymap.set("n", "S", function()
  require("flash").treesitter()
end, { desc = "Flash Treesitter Jump" })

vim.keymap.set("o", "r", function()
  require("flash").remote()
end, { desc = "Remote Flash Jump" })

vim.keymap.set({ "x", "o" }, "R", function()
  require("flash").treesitter_search()
end, { desc = "Remote Flash Jump" })

vim.keymap.set("v", "<C-c>", '"+y', { noremap = true, silent = true })
vim.keymap.set("n", "<C-c>", '"+yy', { noremap = true, silent = true })
vim.keymap.set("n", "<C-v>", '"+p', { noremap = true, silent = true })
vim.keymap.set("i", "<C-v>", '<C-r>+', { noremap = true, silent = true })

vim.keymap.set("n", "<C-w>%", ":vsplit<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-w>'", ":split<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-w>q", ":close<CR>", { noremap = true, silent = true })
