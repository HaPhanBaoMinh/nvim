# Neovim configuration — tutorial

This config uses **[vim-plug](https://github.com/junegunn/vim-plug)** and Lua. Plugins load in two stages: some run immediately, heavier ones after a short defer (see `init.lua`) so the first screen appears quickly.

---

## Requirements

- **Neovim 0.9.x** (the repo pins several plugins for 0.9; Neovim 0.10+ would allow newer Mason, `nvim-lspconfig`, Conform, etc.)
- A **[Nerd Font](https://www.nerdfonts.com/)** (or similar) and a terminal that draws Unicode / icons cleanly
- **Git** (for vim-plug and plugins)
- **curl** (only if vim-plug is missing; `init.lua` can bootstrap it)

Optional but recommended for search:

- **[ripgrep](https://github.com/BurntSushi/ripgrep)** (`rg`) — used by **fzf-lua** for fast grep
- **[fd](https://github.com/sharkdp/fd)** — nicer file finding if you point fzf-lua at it (see fzf-lua docs)

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

   If a plugin failed to clone mid-install, quit and run Neovim again, then `:PlugInstall` once more.

3. Install language tools with **Mason**:

   ```vim
   :Mason
   ```

   Install at least what you use, for example:

   - **LSP:** `lua-language-server`, `pyright`, `bash-language-server`, `clangd`, `rust-analyzer` (see [Rust note](#rust-analyzer-and-mason) below)
   - **Formatters** (for Conform): e.g. `stylua`, `ruff`, `black`, `prettier`, `shfmt`, `clang-format` — match the filetypes you edit
   - **DAP** (debug): e.g. `debugpy` (Python), adapters Mason lists for C++/Lua as configured in `lua/plugins/dap.lua`

4. Install **external linters** that `nvim-lint` expects (system or Mason where available), e.g. `ruff`, `cppcheck`, `stylelint`, `htmlhint`, or adjust `lua/plugins/nvim-lint.lua`.

---

## Config layout

| Path | Role |
|------|------|
| `init.lua` | vim-plug plugin list, deferred `require()` loop, bootstrap |
| `lua/config/mappings.lua` | All keymaps (leader is **Space**) |
| `lua/config/options.lua` | `vim.opt`, diagnostic UI |
| `lua/config/autocmd.lua` | Autocommands (lint on write, markdown spell, yank highlight, …) |
| `lua/config/theme.lua` | Theme cycle + `lua/config/saved_theme` persistence |
| `lua/plugins/*.lua` | Per-plugin setup |

To **add or remove** a plugin: edit the `Plug(...)` lines in `init.lua`, add or remove the matching `require("plugins....")` (immediate or inside the `defer_fn` list), then `:PlugInstall` / `:PlugClean` as needed.

---

## Tools overview

### UI and editing

| Plugin | Config file | What it does |
|--------|-------------|--------------|
| **catppuccin**, **gruvbox**, **pywal16** | `lua/plugins/colorscheme.lua` | Color schemes; cycle with `<leader>p` (saves choice in `lua/config/saved_theme`) |
| **lualine** | `lua/plugins/lualine.lua` | Status line |
| **nvim-web-devicons** | — | File-type icons |
| **barbar** | `lua/plugins/barbar.lua` | Buffer tabs; Alt+number, pin, move |
| **alpha-nvim** | `lua/plugins/alpha.lua` | Startup dashboard when no file |
| **nvim-tree** | `lua/plugins/nvim-tree.lua` | File tree; `<leader>t` |
| **which-key** | `lua/plugins/which-key.lua` | Popup hints after leader (loads deferred) |
| **Comment.nvim** | `lua/plugins/comment.lua` | Comment toggles (plugin defaults) |
| **nvim-autopairs** | `lua/plugins/autopairs.lua` | Auto-close pairs |
| **nvim-surround** | `lua/plugins/surround.lua` | Change/add/delete surroundings (`ys`, `ds`, `cs` — see plugin help) |
| **indent-blankline** | `lua/plugins/indent-blankline.lua` | Indent guides |
| **twilight** | `lua/plugins/twilight.lua` | Dim inactive code; `<leader>l` |
| **nvim-colorizer** | `lua/plugins/colorizer.lua` | Highlight `#hex` colors in buffer |

### Navigation and search

| Plugin | What it does |
|--------|--------------|
| **fzf-lua** | Fuzzy files and grep (`<leader>f`, `<leader>g`, …) |
| **FTerm** | Floating terminal; `<leader>z` (see mappings for close from terminal mode) |

### Syntax and docs

| Plugin | What it does |
|--------|--------------|
| **nvim-treesitter** | Tree-sitter highlighting and folds (`foldexpr` in `options.lua`) |
| **render-markdown** | Nicer Markdown display |
| **decisive.nvim** | CSV alignment; `<leader>csa` / `<leader>csA`, `[c` / `]`c |
| **ron.vim** | RON file syntax |

### Git

| Plugin | Config | What it does |
|--------|--------|--------------|
| **gitsigns** | `lua/plugins/gitsigns.lua` (pinned for nvim 0.9) | Signs, hunks, blame-style features per plugin defaults |

### Language intelligence (LSP, completion, format)

| Piece | Config | What it does |
|-------|--------|--------------|
| **Mason** | `lua/plugins/lsp.lua` | Installs LSP binaries under `stdpath("data")/mason` |
| **mason-lspconfig** | same | Maps Mason packages → `lspconfig` servers |
| **nvim-lspconfig** | same | Starts LSP; buffer maps on attach (below) |
| **nvim-cmp** | same | Completion in insert mode (LSP, LuaSnip, buffer, path) |
| **LuaSnip** + **friendly-snippets** | same | Snippet expansion |
| **conform.nvim** | `lua/plugins/conform.lua` | Format on save + `<leader>cf` |

**Completion (insert mode):**

- `<C-Space>` — trigger completion  
- `<CR>` — confirm  
- `<C-e>` — abort  
- `<C-b>` / `<C-f>` — scroll docs  
- `<Tab>` / `<S-Tab>` — LuaSnip jump forward/back when applicable  

**LSP (after attach, normal / visual):**

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `K` | Hover documentation |
| `gr` | References |
| `<leader>cr` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>cd` | Diagnostic float |
| `[d` / `]`d | Previous / next diagnostic |

### Lint

| Plugin | Config |
|--------|--------|
| **nvim-lint** | `lua/plugins/nvim-lint.lua` — runs on **`:w`** (see `lua/config/autocmd.lua`) |

### Tests

| Plugin | Config |
|--------|--------|
| **vim-test** | `lua/plugins/vim-test.lua` — strategy `neovim`, Python runner `pytest` |

You need the test runner installed (e.g. `pytest`, `npm test`, etc.) and filetype detection correct.

### Debug

| Plugin | Config |
|--------|--------|
| **nvim-dap** | `lua/plugins/dap.lua` |
| **nvim-dap-ui** | same — opens/closes with sessions |
| **mason-nvim-dap** | same — can install adapters (`python`, `cppdbg`, `lua` in config) |

### TODO highlights

| Plugin | Config |
|--------|--------|
| **todo-comments** | `lua/plugins/todo-comments.lua` — highlights FIX/TODO/etc. |
| `:TodoFzfLua` | Mapped to `<leader>xt` (needs fzf-lua loaded) |

---

## Keymap reference (leader = Space)

Buffers (barbar / built-in):

- `<S-h>` / `<S-l>` — previous / next buffer  
- `<leader>q` / `<leader>Q` — close buffer (force)  
- `<leader>U` — close all buffers  
- `<leader>vs` — vertical split + next buffer  
- `<A-1>` … `<A-9>`, `<A-0>` — go to buffer 1–9 / last  
- `<A-p>` — pin  
- `<Alt-Shift-h>` / `<Alt-Shift-l>` — move buffer  

Windows:

- `<C-hjkl>` — focus splits  
- `<F5>`–`<F8>` — resize splits  

fzf-lua:

- `<leader>f` — files (cwd)  
- `<leader>Fh` / `Fc` / `Fl` / `Ff` — files in home, `~/.config`, `~/.local/src`, parent  
- `<leader>Fr` — resume  
- `<leader>g` — live grep  
- `<leader>G` — grep word under cursor  

Misc:

- `<leader><Space>` — `<C-o>` (jump back)  
- `<leader>s` — `:%s/` substitute  
- `<leader>t` — NvimTree toggle  
- `<leader>p` — cycle theme  
- `<leader>P` — `:PlugInstall`  
- `<leader>z` — floating terminal (FTerm)  
- Terminal mode `<Esc>` — leave terminal and close FTerm (see `mappings.lua`)  
- `<leader>w` — write  
- `<leader>R` — `:so %` (reload current file as config — useful when editing nvim config)  
- `<leader>u` — open URL under cursor (`xdg-open`)  
- `<leader>W` — toggle wrap  
- `<leader>nn` — toggle relative line numbers  
- `<leader>H` — htop in FTerm (requires `htop` on PATH)  
- `<leader>ma` — `make` workflow in buffer directory (uses `sudo`; edit if you do not want that)  

Tests: `<leader>tn` nearest, `tf` file, `ts` suite, `tl` last, `tv` visit.

Format: `<leader>cf` (Conform, visual or normal).

DAP: `<leader>db` breakpoint, `<leader>dB` conditional, `<leader>dc` continue, `<leader>di` step into, `<leader>do` step over, `<leader>dO` step out, `<leader>dr` REPL, `<leader>du` toggle UI.

---

## Rust analyzer and Mason

Rust LSP is only started if **Mason’s** `rust-analyzer` binary exists:

`~/.local/share/nvim/mason/bin/rust-analyzer`

The `~/.cargo/bin/rust-analyzer` **rustup proxy** often exits with code 1 if you never ran `rustup component add rust-analyzer`. Installing **`rust-analyzer` inside `:Mason`** avoids that. After install, restart Neovim (or reopen the Rust file).

---

## Troubleshooting

- **“Client quit with exit code 1”** — open `:LspLog` or `~/.local/state/nvim/lsp.log` and read the stderr line; often a missing binary or wrong PATH. Fix with `:Mason` or system packages.  
- **No completion** — ensure the LSP for that filetype is installed and attached (`:LspInfo`).  
- **Format does nothing** — install the formatter (Mason or OS) that Conform lists for that filetype in `lua/plugins/conform.lua`.  
- **Plugin require failed (notify on startup)** — run `:PlugInstall`, quit Neovim completely, start again (first install can race with the deferred `require`).  
- **Which-key empty** — it loads after defer; press `<Space>` and wait a moment on first open.

---

## Further reading

- Neovim help: `:help`, `:help lsp`, `:help diagnostic`  
- [fzf-lua](https://github.com/ibhagwan/fzf-lua) — commands and preview setup  
- [Mason](https://github.com/mason-org/mason.nvim) — registry of packages  

Enjoy.
