# Neovim configuration

Personal Neovim setup using **[vim-plug](https://github.com/junegunn/vim-plug)** and Lua. A small set of plugins loads immediately (theme, buffers, status line); heavier modules are `require`’d after a short defer in `init.lua` so the first screen paints quickly.

---

## Requirements

- **Neovim 0.11+** — the LSP stack uses **`vim.lsp.config`** and **mason-lspconfig v2** (see `lua/plugins/lsp.lua`). Older Neovim needs an older mason-lspconfig / different LSP wiring.
- A **[Nerd Font](https://www.nerdfonts.com/)** (or similar) and a terminal that renders Unicode / icons cleanly.
- **Git** (for vim-plug and plugins).
- **curl** — only used if vim-plug is missing; `init.lua` can bootstrap `plug.vim`.

Optional but recommended for search:

- **[ripgrep](https://github.com/BurntSushi/ripgrep)** (`rg`) — **fzf-lua** live grep.
- **[fd](https://github.com/sharkdp/fd)** — faster file finding if you configure fzf-lua to use it (see fzf-lua docs).

---

## Install and first run

1. Clone into your config directory (or symlink this repo to `~/.config/nvim`):

   ```bash
   git clone https://github.com/YOUR_USER/nvim.git ~/.config/nvim
   ```

2. Start Neovim and install plugins:

   ```vim
   :PlugInstall
   ```

   If a clone fails mid-install, quit Neovim, start again, and run `:PlugInstall` once more.

3. Install language tools with **Mason**:

   ```vim
   :Mason
   ```

   Useful packages (match what you edit):

   - **LSP:** `lua-language-server`, `pyright`, `bash-language-server`, `clangd`, `rust-analyzer` (see [Rust note](#rust-analyzer-and-mason))
   - **Formatters** (Conform): e.g. `stylua`, `ruff`, `black`, `prettier`, `shfmt`, `clang-format`
   - **DAP:** e.g. `debugpy` (Python); see `lua/plugins/dap.lua` for Mason DAP names

4. Install **external linters** that **nvim-lint** expects (system or Mason), e.g. `ruff`, `cppcheck`, `stylelint`, `htmlhint`, or edit `lua/plugins/nvim-lint.lua`.

---

## Config layout

| Path | Role |
|------|------|
| `init.lua` | vim-plug list, deferred `require()` loop, vim-plug bootstrap |
| `lua/config/mappings.lua` | Keymaps (leader is **Space**) |
| `lua/config/options.lua` | `vim.opt`, diagnostics UI, split defaults (`splitright` / `splitbelow`) |
| `lua/config/autocmd.lua` | Autocommands (lint on write, markdown spell, yank highlight, …) |
| `lua/config/theme.lua` | Theme cycle + `lua/config/saved_theme` persistence |
| `lua/plugins/*.lua` | Per-plugin setup |

To **add or remove** a plugin: edit `Plug(...)` in `init.lua`, add or remove the matching `require("plugins....")` (immediate block or `defer_fn` list), then `:PlugInstall` / `:PlugClean`.

---

## Tools overview

### UI and editing

| Plugin | Config file | Notes |
|--------|-------------|--------|
| **catppuccin**, **gruvbox**, **pywal16** | `lua/plugins/colorscheme.lua` | Cycle with `<leader>p` (choice saved under `lua/config/saved_theme`) |
| **lualine** | `lua/plugins/lualine.lua` | Status line |
| **nvim-web-devicons** | — | Icons |
| **barbar** | `lua/plugins/barbar.lua` | Buffer tabs; `Alt`+number, pin, move |
| **alpha-nvim** | `lua/plugins/alpha.lua` | Startup dashboard when no file |
| **nvim-tree** | `lua/plugins/nvim-tree.lua` | File tree; `<leader>t` (loaded in defer) |
| **which-key** | `lua/plugins/which-key.lua` | Leader hints (deferred) |
| **Comment.nvim** | `lua/plugins/comment.lua` | Comment toggles |
| **nvim-autopairs** | `lua/plugins/autopairs.lua` | Auto-close pairs (deferred) |
| **nvim-surround** | `lua/plugins/surround.lua` | `ys` / `ds` / `cs` (see `:help nvim-surround`) |
| **indent-blankline** | `lua/plugins/indent-blankline.lua` | Indent guides (deferred) |
| **twilight** | `lua/plugins/twilight.lua` | Dim inactive code; `<leader>l` (deferred) |
| **nvim-colorizer** | `lua/plugins/colorizer.lua` | Highlight `#hex` colors |

### Navigation and search

| Plugin | Notes |
|--------|--------|
| **fzf-lua** | Files and grep (`<leader>f`, `<leader>g`, …); deferred |
| **FTerm** | Floating terminal `<leader>z` (deferred) |

### Syntax and docs

| Plugin | Notes |
|--------|--------|
| **nvim-treesitter** | Highlighting / folds (`foldexpr` in `options.lua`); deferred |
| **render-markdown** | Markdown rendering |
| **decisive.nvim** | CSV: `<leader>csa` / `<leader>csA`, `[c` / `]c` |
| **ron.vim** | RON syntax |

### Git

| Plugin | Notes |
|--------|--------|
| **gitsigns** | `lua/plugins/gitsigns.lua` (tag pinned for older Neovim compatibility) |

### Language intelligence (LSP, completion, format)

| Piece | Config | Notes |
|-------|--------|--------|
| **Mason** | `lua/plugins/lsp.lua` | Binaries under `stdpath("data")/mason` |
| **mason-lspconfig** | same | v2: `ensure_installed`, **`automatic_enable`** → `vim.lsp.enable()` for installed servers |
| **nvim-lspconfig** | on `runtimepath` | Supplies `lsp/*.lua` defaults merged with `vim.lsp.config()` |
| **nvim-cmp** | same | LSP, LuaSnip, buffer, path |
| **LuaSnip** + **friendly-snippets** | same | Snippets |
| **conform.nvim** | `lua/plugins/conform.lua` | Format on save + `<leader>cf` |

LSP is configured with **`vim.lsp.config()`** (not `lspconfig.x.setup` + `setup_handlers`). Global **cmp** capabilities are applied via `vim.lsp.config("*", { capabilities = … })`; **lua_ls** and **rust_analyzer** (Mason `cmd`) get extra blocks in the same file.

**Completion (insert mode):**

- `<C-Space>` — open completion (also `<C-@>` and `<C-.>` as fallbacks for awkward terminals / IME)
- `<CR>` — confirm
- `<C-e>` — abort
- `<C-b>` / `<C-f>` — scroll docs
- `<Tab>` / `<S-Tab>` — LuaSnip forward / back when applicable

**LSP (after attach, normal / visual):**

| Key | Action |
|-----|--------|
| `gd` | Definition |
| `gD` | Declaration |
| `K` | Hover |
| `gr` | References |
| `<leader>cr` | Rename |
| `<leader>ca` | Code action |
| `<leader>cd` | Diagnostic float |
| `[d` / `]d` | Previous / next diagnostic |

### Lint

| Plugin | Config |
|--------|--------|
| **nvim-lint** | `lua/plugins/nvim-lint.lua` — triggered on **`:w`** (see `lua/config/autocmd.lua`) |

### Tests

| Plugin | Config |
|--------|--------|
| **vim-test** | `lua/plugins/vim-test.lua` — strategy `neovim`, Python runner `pytest` |

Install the runner you need (`pytest`, `npm test`, etc.).

### Debug

| Plugin | Config |
|--------|--------|
| **nvim-dap** | `lua/plugins/dap.lua` |
| **nvim-dap-ui** | same |
| **mason-nvim-dap** | same — e.g. `python`, `cppdbg`, `lua` |

### TODO highlights

| Plugin | Notes |
|--------|--------|
| **todo-comments** | `lua/plugins/todo-comments.lua` |
| `<leader>xt` | `:TodoFzfLua` (needs fzf-lua) |

---

## Keymap reference (leader = Space)

### Buffers (Barbar / built-in)

- `<S-h>` / `<S-l>` — previous / next buffer
- `<leader>q` / `<leader>Q` — close buffer (force)
- `<leader>U` — close all buffers
- `<leader>vs` — vertical split + next buffer
- `<A-1>` … `<A-9>`, `<A-0>` — go to buffer 1–9 / last
- `<A-p>` — pin
- `<A-S-h>` / `<A-S-l>` — move buffer in tab line

### Windows and splits

`options.lua` sets **`splitright`** and **`splitbelow`** so `:vsplit` / `:split` open in a predictable direction.

- `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` — focus window left / down / up / right
- `<F5>`–`<F8>` — resize height / width
- `<leader>wv` — vertical split (same buffer), `:vsplit`
- `<leader>wh` — horizontal split (same buffer), `:split`
- `<leader>wc` — close **this** window (`:close`); buffer may stay listed — use `<leader>q` to close the buffer in Barbar
- `<leader>wo` — only this window (`:only`)
- `<leader>w=` — equalize split sizes (`Ctrl-w =`)
- `<leader>w` — **`:w`** save (not a “window menu”)

### fzf-lua

- `<leader>f` — files (cwd)
- `<leader>Fh` / `Fc` / `Fl` / `Ff` — files in home, `~/.config`, `~/.local/src`, parent
- `<leader>Fr` — resume
- `<leader>g` — live grep
- `<leader>G` — grep word under cursor

### Misc

- `<leader><Space>` — `<C-o>` (jump back)
- `<leader>s` — `:%s/` substitute
- `<leader>t` — NvimTree toggle
- `<leader>p` — cycle theme
- `<leader>P` — `:PlugInstall`
- `<leader>z` — floating terminal (FTerm)
- Terminal mode `<Esc>` — normal mode + close FTerm (see `mappings.lua`)
- `<leader>R` — `:so %` (reload current file — handy when editing config)
- `<leader>u` — open URL under cursor (`xdg-open`)
- `<leader>W` — toggle wrap
- `<leader>nn` — toggle relative line numbers
- `<leader>H` — htop in FTerm (`htop` on PATH)
- `<leader>ma` — make workflow in buffer directory (uses `sudo`; change mapping if you do not want that)

**Tests:** `<leader>tn` nearest, `tf` file, `ts` suite, `tl` last, `tv` visit.

**Format:** `<leader>cf` (Conform).

**DAP:** `<leader>db` breakpoint, `<leader>dB` conditional, `<leader>dc` continue, `<leader>di` step into, `<leader>do` step over, `<leader>dO` step out, `<leader>dr` REPL, `<leader>du` toggle UI.

---

## Rust analyzer and Mason

**rust-analyzer** is pointed at Mason’s binary when it exists:

`~/.local/share/nvim/mason/bin/rust-analyzer`

The `~/.cargo/bin/rust-analyzer` **rustup proxy** often exits with code 1 until you run `rustup component add rust-analyzer`. Installing **rust-analyzer** via `:Mason` avoids that. Restart Neovim (or re-open the buffer) after install.

---

## Troubleshooting

- **`setup_handlers` / nil errors on startup** — You have **mason-lspconfig v2**; it does not expose `setup_handlers`. This config uses **`vim.lsp.config`** instead. If you see old API errors, run `:PlugUpdate` so tags in `init.lua` match (or align `lua/plugins/lsp.lua` with your installed mason-lspconfig version).
- **“Client quit with exit code 1”** — `:LspLog` or `~/.local/state/nvim/lsp.log`; usually a missing binary or PATH issue. Fix with `:Mason` or system packages.
- **No completion** — LSP installed and attached (`:checkhealth vim.lsp` / client list in recent Neovim).
- **Format does nothing** — Install the formatter Conform expects for that filetype (`lua/plugins/conform.lua`).
- **Plugin require failed (notify on startup)** — `:PlugInstall`, fully quit Neovim, start again (first install can race with deferred `require`).
- **Which-key empty** — Loads after defer; press `<Space>` and wait a moment on first open.

---

## Further reading

- `:help`, `:help lsp`, `:help diagnostic`, `:help vim.lsp.config`
- [fzf-lua](https://github.com/ibhagwan/fzf-lua)
- [Mason](https://github.com/mason-org/mason.nvim)
- [mason-lspconfig](https://github.com/mason-org/mason-lspconfig.nvim) (v2 changelog for migration notes)

Enjoy.
