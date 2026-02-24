-- Reduced parsers: 16 -> 9. Each parser loads into RAM. Add more only if needed.
require'nvim-treesitter.configs'.setup {
	ensure_installed = { "bash", "c", "go", "html", "json", "lua", "markdown", "python", "typescript" },
	sync_install = false,
	highlight = {
		enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
		init_selection = "gnn", -- set to `false` to disable one of the mappings
		node_incremental = "grn",
		scope_incremental = "grc",
		node_decremental = "grm",
		},
	},
}
