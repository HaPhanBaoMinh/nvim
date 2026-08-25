# Neovim configuration audit

## Inventory and decisions

| Plugin/component | Load condition | Main use | Decision and reason |
|---|---|---|---|
| lazy.nvim | startup | Plugin manager | KEEP. Declarative event/cmd/ft/key loading and lockfile. |
| catppuccin, gruvbox, pywal16 | colorscheme/on demand | Theme cycle | KEEP. Existing workflow; state moved to stdpath state. |
| lualine, barbar | VimEnter | Statusline/bufferline | OPTIMIZE. Delayed from startup without changing sections or commands. |
| alpha-nvim | empty VimEnter or Alpha command | Dashboard | OPTIMIZE. Loaded only on empty startup; explicit alpha.start fixes event ordering. |
| which-key | VeryLazy | Mapping hints | OPTIMIZE. No startup load. |
| nvim-tree, fzf-lua, FTerm | command/key | Explorer, search, terminal | OPTIMIZE. Exact key triggers; no eager setup. |
| smart-splits | navigation/resize keys | Pane movement/resizing | OPTIMIZE. API wrapper preserves current six-step and arrow resize mode. |
| Comment.nvim | gc/gb keys | Comments | KEEP. Native mapping would not preserve all existing comment keys. |
| nvim-autopairs, nvim-surround | InsertEnter or exact keys | Editing helpers | OPTIMIZE. Loaded only when editing/used. |
| nvim-treesitter | BufReadPre/BufNewFile | Highlight, indent, folds | OPTIMIZE. Compatible master branch pinned; auto-install disabled. |
| render-markdown | markdown filetype | Markdown rendering | OPTIMIZE. Filetype-only. |
| vim-helm | eager | Helm filetype detection | KEEP. Must be present before detection; negligible measured cost. |
| Mason, LSP, cmp, LuaSnip | LSP buffer events/InsertEnter | LSP and completion | KEEP/OPTIMIZE. Existing stack retained and deferred. |
| conform.nvim | BufWritePre or cf key | Formatting | KEEP/OPTIMIZE. Save/key driven. |
| nvim-lint | BufWritePost | Linting | KEEP/OPTIMIZE. One write autocmd; no duplicate deferred setup. |
| nvim-dap, dap-ui, mason-nvim-dap | DAP keys | Debugging | KEEP/OPTIMIZE. Loads on first debugger action. |
| gitsigns | buffer read/new | Git signs | OPTIMIZE. Buffer-event load. |
| fugitive, diffview | command/key | Git status/review/history | KEEP/OPTIMIZE. Distinct workflows. |
| trouble, todo-comments, vim-test | command/key or buffer event | Diagnostics/TODO/tests | KEEP/OPTIMIZE. Existing workflows retained. |
| web-devicons, plenary | dependencies | Shared support | KEEP. Required by active plugins. |
| nvim-nio | no reference with dap-ui v3.9.3 | DAP async dependency | REMOVE. Unused with pinned dap-ui. |
| orphan dashboard.lua and image.lua | none | Old unreferenced configs | REMOVE. No declaration or runtime reference. |

## Replacement decisions

| Current | Replacement | Benefit | Compatibility impact |
|---|---|---|---|
| vim-plug | lazy.nvim | Real lazy triggers, lockfile, fewer eager runtime files | PlugInstall and leader pi call lazy sync; vim-plug-only commands are not emulated. |
| tracked saved_theme file | stdpath state theme file | Theme cycling no longer dirties Git | No keymap or visual workflow change. |
| 100ms deferred require batch | lazy.nvim triggers | First-use loading instead of sourcing all optional modules | Exact key triggers replay after setup. |

## Keymap compatibility

All mappings from the pre-refactor core mappings, LSP, Conform, and DAP files
were traced. Every family below is preserved (YES).

| Old family | Behavior | New implementation | Preserved |
|---|---|---|---|
| leader b*, leader 1..0 | Barbar buffer navigation/close/move/pin | core maps plus barbar commands | YES |
| C-h/j/k/l, leader sH/J/K/L/sr | Pane navigation and resize | lazy smart-splits triggers and wrapper | YES |
| leader sv/sh/sc/so/se | Split operations | native core commands | YES |
| leader ff/fr/fg/fw/fh/fc/fl | fzf-lua search | same function calls as lazy keys | YES |
| leader e | NvimTree toggle | lazy command mapping | YES |
| leader tt, leader th, terminal Esc | FTerm and htop | lazy key mappings | YES |
| gc, gb, gcc, gco, gcO, gcA | Comment operations | exact Comment lazy triggers and plugin config | YES |
| ys, ds, cs, visual S | Surround operations | exact lazy triggers | YES |
| leader gs/gd/gb/gD/gh/gq | Fugitive and Diffview | exact command mappings | YES |
| leader tn/tf/ts/tl/tv | vim-test | exact command mappings | YES |
| leader xx/xd/xq/xl | Trouble lists | exact command mappings | YES |
| gd/gD/gr/K, leader cr/ca/cd, [d, ]d | LSP navigation/actions/diagnostics | same LspAttach mappings | YES |
| leader cf | Conform formatting | lazy trigger plus conform mapping | YES |
| leader d* | DAP controls | lazy trigger plus dap mapping | YES |
| core C-a/c/v/s and custom leader maps | Core/custom workflow | lua/core/keymaps.lua | YES |

## Validation evidence

- All tracked Lua modules pass loadfile syntax checks.
- Empty startup loads 3/42 graph entries.
- Opening init.lua loads 18/42 entries; Treesitter, cmp, and LSP config are present.
- Markdown opens with Treesitter and render-markdown active.
- All plugin specs load successfully with Lazy load.
- gcc comments a temporary line after first-use lazy replay.
- leader db creates a DAP breakpoint after first-use lazy replay.
- Empty startup emits AlphaReady with filetype alpha.
- Lualine notices are empty with the catppuccin-frappe adapter.
