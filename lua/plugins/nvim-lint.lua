local lint = require("lint")

lint.linters_by_ft = { -- some of these need to be installed from a package manager
  lua = {'luac'},
  python = {'ruff'},
  go = {'golangcilint'},
  javascript = {'eslint_d'},
  javascriptreact = {'eslint_d'},
  typescript = {'eslint_d'},
  typescriptreact = {'eslint_d'},
  sh = {'bash'},
  c = {'cppcheck'},
  rust = {'clippy'},
  css = {'stylelint'},
  html = {'htmlhint'},
}

vim.api.nvim_create_autocmd("BufWritePost", {
	group = vim.api.nvim_create_augroup("user_lint", { clear = true }),
	callback = function()
		lint.try_lint()
	end,
})
