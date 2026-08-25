# Neovim configuration

Personal Neovim configuration focused on fast startup, explicit lazy-loading,
and preserving the existing Space-leader workflow. The repository uses
[lazy.nvim](https://github.com/folke/lazy.nvim); the legacy `:PlugInstall`
command and `<leader>pi` mapping remain compatibility aliases to
`:Lazy sync`.

## Requirements

- Neovim **0.11+** (tested with `NVIM v0.12.0-dev`; LSP uses
  `vim.lsp.config`).
- Git and a terminal with true-color support.
- A Nerd Font is recommended for icons.
- `ripgrep` and `fzf` for fzf-lua search; `fd` is optional.
- `node`/`npm` for `ts_ls`, `pyright`, and `bashls`.
- A C compiler/build toolchain for Treesitter parser builds.
- `xclip` and/or `wl-clipboard` for local clipboard integration. OSC52 is
  the final fallback for compatible terminals and tmux.
- Optional workflow binaries: `htop`, `go`, `rustup`, `stylua`,
  `ruff`, `black`, `prettier`/`prettierd`, `shfmt`, `goimports`,
  `rustfmt`, `clang-format`, `luac`, `golangci-lint`, `eslint_d`,
  `cppcheck`, `clippy`, `stylelint`, `htmlhint`, and `pytest`.
- A `sudo`-capable environment is required only for the custom
  `<leader>ma` make/install workflow.

## Installation

Back up an existing configuration first:

```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

Clone this repository:

```bash
git clone https://github.com/HaPhanBaoMinh/nvim.git ~/.config/nvim
nvim
```

On first start lazy.nvim bootstraps itself under
`stdpath('data')/lazy/lazy.nvim` and synchronizes the lockfile. Use
`:Lazy`, `:Lazy sync`, or the preserved `:PlugInstall`/`<leader>pi`
compatibility path to update plugins.

## LSP, completion, formatting, linting, and debugging

Mason and mason-lspconfig manage the configured servers:
`lua_ls`, `clangd`, `rust_analyzer`; `pyright`, `ts_ls`, and
`bashls` when `npm` is available; and `gopls` when `go` is available.
Inspect/install tools with `:Mason` and `:MasonInstall`. Rust uses the
Mason shim when available, then the unpacked Mason binary, then `rustup`.

Completion is nvim-cmp + LuaSnip with LSP, buffer, path, and friendly-snippets
sources. Conform formats on save and with `<leader>cf`. nvim-lint runs on
`BufWritePost`; its filetype mapping is in
`lua/plugins/nvim-lint.lua`.

DAP uses nvim-dap, nvim-dap-ui, and mason-nvim-dap with `python`, `cppdbg`,
and `lua` adapters.

## Keymaps (leader = Space)

### General and editing

- `<C-a>` select all; `<C-c>` copy; `<C-v>` paste; `<C-s>` save.
- `<leader>as` save, `<leader>aa` save as, `<leader>rr` substitute,
  `<leader>rc` source current file.
- `<leader>ou` open URL, `<leader>of` open containing folder,
  `<leader>i` re-indent visual selection.
- `<leader>ut` cycle theme, `<leader>uw` toggle wrap,
  `<leader>un` toggle relative numbers.
- `<leader><Space>` jump back; `<leader>km` opens the keymap module;
  `<leader>kt` opens tmux keymaps.

### Buffers and windows

- `<leader>bn`/`bp` next/previous; `<leader>bd` close;
  `<leader>bD` force close; `<leader>ba` close all.
- `<leader>bh`/`bl` move buffer; `<leader>bP` pin.
- `<leader>1`...`<leader>9` go to buffer; `<leader>0` last buffer.
- `<C-h>`/`<C-j>`/`<C-k>`/`<C-l>` navigate panes.
- `<leader>sv` split vertical, `<leader>sh` split horizontal,
  `<leader>sc` close, `<leader>so` only, `<leader>se` equalize.
- `<leader>sH`/`sJ`/`sK`/`sL` resize by six; `<leader>sr` enters
  arrow-key resize mode and `<Esc>` exits it.

### Files and search

- `<leader>e` toggle nvim-tree.
- `<leader>ff` files, `<leader>fr` resume, `<leader>fg` grep,
  `<leader>fw` grep word, `<leader>fh` home, `<leader>fc` config,
  `<leader>fl` local source.

### LSP and diagnostics

- `gd` definition, `gD` declaration, `gr` references, `K` hover
  (or `keywordprg` without an attached hover-capable server).
- `<leader>cr` rename, `<leader>ca` code action,
  `<leader>cd` diagnostic float.
- `[d`/`]d` previous/next diagnostic.

### Completion and formatting

- Insert mode: `<C-Space>`/`<C-@>`/`<C-.>` open completion;
  `<C-n>`/`<C-p>` select; `<C-b>`/`<C-f>` scroll docs;
  `<C-e>` abort; `<CR>` confirm; `<Tab>`/`<S-Tab>` navigate snippets
  or completion.
- `<leader>cf` format in normal or visual mode.

### Git, tests, terminal, diagnostics

- `<leader>gs` Git status, `<leader>gd` Git diff split,
  `<leader>gb` blame.
- `<leader>gD` diffview, `<leader>gh` file history,
  `<leader>gq` close diffview.
- `<leader>tn`/`tf`/`ts`/`tl`/`tv` run vim-test
  nearest/file/suite/last/visit.
- `<leader>tt` toggle FTerm, `<leader>th` htop, terminal `<Esc>` closes
  FTerm.
- `<leader>xx` diagnostics, `<leader>xd` buffer diagnostics,
  `<leader>xq` quickfix, `<leader>xl` loclist.
- `<leader>zc`/`zo`/`za`/`zM`/`zR` fold close/open/toggle/close-all/open-all.
- Comment.nvim preserves `gc`, `gb`, `gcc`, `gco`, `gcO`, and `gcA`.

## Architecture

```
init.lua
lua/core/          options, keymaps, autocmds, clipboard, theme state
lua/plugin_specs/  lazy.nvim declarations grouped by UI/editor/tools/lang
lua/plugins/       focused setup modules loaded by those declarations
docs/              audit and keymap compatibility report
tmux/              tmux integration and keymaps
```

Theme state is machine-local at `stdpath('state')/bread-nvim/theme`, so
cycling themes no longer modifies a tracked file.

## Troubleshooting

- Run `:checkhealth`, `:Lazy`, and `:Mason`.
- Use `:LspInfo`/`:LspLog` when a server does not attach.
- Use `:ConformInfo` and verify the formatter binary is on `PATH`.
- Use `:ClipInfo` and `:ClipTest` for clipboard diagnostics.
- If a parser is missing, run `:TSInstallSync <language>` or
  `:TSUpdateSync`.
- `:PlugInstall` is a compatibility alias; plugin management is provided by
  lazy.nvim, not vim-plug.

## Performance

Five headless runs after the refactor:

```
Empty startup: 16.244–18.057 ms (median 16.348 ms)
Opening init.lua: 76.445–81.917 ms (median 79.303 ms)
```

The lazy graph contains 42 entries (including lazy.nvim and dependencies).
Empty startup loads 3 entries; opening `init.lua` loads 18 entries. The
previous vim-plug configuration declared 40 plugins and sourced their runtime
paths at startup; its five-run median was approximately 87.168 ms. Measurements
are machine- and cache-dependent, so compare trends rather than absolute values.

See `docs/audit.md` for the inventory, decisions, and complete keymap
compatibility report.
