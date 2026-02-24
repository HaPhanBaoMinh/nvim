-- lspconfig.lua (clean + practical for Go / JS / TS)
local lspconfig = require("lspconfig")
local blink = require("blink.cmp")

-- Diagnostics: readable by default, not noisy. update_in_insert=false saves RAM.
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
})

-- Hover/signature UI
local float_opts = { border = "rounded" }
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, float_opts)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, float_opts)

-- Capabilities for completion
local capabilities = blink.get_lsp_capabilities()

-- One on_attach to rule them all
local function on_attach(_, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end

  map("n", "gd", vim.lsp.buf.definition, "LSP: Go to definition")
  map("n", "gD", vim.lsp.buf.declaration, "LSP: Go to declaration")
  map("n", "gr", vim.lsp.buf.references, "LSP: References")
  map("n", "gi", vim.lsp.buf.implementation, "LSP: Implementation")
  map("n", "K", vim.lsp.buf.hover, "LSP: Hover")
  map("n", "<leader>rn", vim.lsp.buf.rename, "LSP: Rename")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP: Code action")
  map("n", "[d", vim.diagnostic.goto_prev, "Diag: Prev")
  map("n", "]d", vim.diagnostic.goto_next, "Diag: Next")
  map("n", "<leader>e", vim.diagnostic.open_float, "Diag: Float")
end

-- Format on save for the filetypes you care about
-- Note: For JS/TS, many teams prefer prettier/eslint instead of tsserver formatting.
local format_on_save = {
  go = true,
  -- javascript = true,
  -- typescript = true,
  -- typescriptreact = true,
}

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local bufnr = ev.buf

    -- Attach keymaps
    on_attach(client, bufnr)

    -- Optional: auto-format on save (only if server supports it)
    local ft = vim.bo[bufnr].filetype
    if format_on_save[ft] and client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            bufnr = bufnr,
            timeout_ms = 3000,
            filter = function(c)
              -- Prefer gopls for Go formatting
              if ft == "go" then return c.name == "gopls" end
              return true
            end,
          })
        end,
      })
    end
  end,
})

-- Servers: keep the set tight (Go + TS/JS + JSON; Lua optional)
local servers = {
  gopls = {
    settings = {
      gopls = {
        gofumpt = true,
        usePlaceholders = true,
        analyses = { unusedparams = true, nilness = true, unusedwrite = true },
        staticcheck = true,
      },
    },
  },

  -- TypeScript/JavaScript (nvim-lspconfig name: tsserver)
  ts_ls = {
    settings = {
      typescript = { format = { indentSize = 2, convertTabsToSpaces = true } },
      javascript = { format = { indentSize = 2, convertTabsToSpaces = true } },
    },
  },

  jsonls = {},

  -- Optional (remove if you don't edit Lua configs)
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  },
}

-- Setup (idempotent, no global flags needed if you only source once)
for name, opts in pairs(servers) do
  opts.capabilities = capabilities
  opts.on_attach = function(client, bufnr) on_attach(client, bufnr) end
  lspconfig[name].setup(opts)
end
