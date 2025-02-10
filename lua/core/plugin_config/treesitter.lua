require("nvim-treesitter.configs").setup({
  -- A list of parser names, or "all"
  ensure_installed = { "c", "lua", "python", "javascript", "vim", "html", "markdown" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  textobjects = {
    lsp_interop = { enable = true },
    select = {
      enable = true,
      keymaps = {
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ap"] = "@parameter.outer",
        ["ip"] = "@parameter.inner",
        ["ak"] = "@comment.outer",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<Leader>cs"] = "@parameter.inner",
      },
      swap_previous = {
        ["<Leader>cs"] = "@parameter.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = { ["]]"] = "@function.outer" },
      goto_next_end = { ["]}"] = "@function.outer" },
      goto_previous_start = { ["[["] = "@function.outer" },
      goto_previous_end = { ["[{"] = "@function.outer" },
    },
  },
})
