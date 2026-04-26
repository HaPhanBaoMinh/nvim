local ok, ts = pcall(require, "nvim-treesitter")
if not ok then
	vim.schedule(function()
		vim.notify("[treesitter] plugin missing, run :PlugInstall", vim.log.levels.WARN)
	end)
	return
end

ts.setup()

local langs = {
	"bash",
	"c",
	"css",
	"cpp",
	"go",
	"html",
	"java",
	"javascript",
	"json",
	"lua",
	"markdown",
	"markdown_inline",
	"python",
	"rust",
	"tsx",
	"typescript",
}

vim.api.nvim_create_autocmd("FileType", {
	pattern = langs,
	callback = function()
		vim.treesitter.start()
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})
