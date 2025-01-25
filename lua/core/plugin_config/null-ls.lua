local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		null_ls.builtins.formatting.stylua, -- Formatter cho Lua
		null_ls.builtins.completion.spell, -- Gợi ý chính tả
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.black,
	},
	debug = true, -- Bật debug để kiểm tra lỗi
})

-- Đặt keymap để format thủ công
vim.keymap.set("n", "<leader>gf", function()
	vim.lsp.buf.format({ async = true })
end, { noremap = true, silent = true })
