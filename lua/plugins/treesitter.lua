local languages = {
	"bash",
	"c",
	"cpp",
	"css",
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

require("nvim-treesitter.configs").setup({
	ensure_installed = languages,
	auto_install = false,
	highlight = { enable = true },
	indent = { enable = true },
})
