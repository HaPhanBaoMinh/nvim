require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "tailwindcss", "gopls", "terraformls" },
})
local lspconfig = require("lspconfig")
local lsp_defaults = lspconfig.util.default_config
lsp_defaults.capabilities =
    vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())
-- Cấu hình diagnostics
vim.diagnostic.config({
  virtual_text = {
    prefix = "●", -- Thay đổi ký hiệu lỗi
    spacing = 4,
  },
  signs = true,         -- Hiện icon lỗi bên lề
  float = {
    border = "rounded", -- Hiển thị lỗi chi tiết trong popup
    source = "always",
  },
  severity_sort = true, -- Sắp xếp lỗi theo độ nghiêm trọng
})
-- Tự động hiển thị lỗi khi di chuột
vim.o.updatetime = 250
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
require("lspconfig").lua_ls.setup({
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },
      },
    },
  },
})
require("lspconfig").gopls.setup({
  on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    -- "gd" để chuyển đến định nghĩa của symbol dưới con trỏ
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    -- "K" để xem thông tin chi tiết của symbol (hover)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    -- Thêm các keymap khác nếu cần...
  end,
  flags = {
    debounce_text_changes = 150,
  },
})
require("lspconfig").tailwindcss.setup({})
require("lspconfig").terraformls.setup({})
require("lspconfig").yamlls.setup({})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    -- Buffer local mappings.
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<space>f", function()
      vim.lsp.buf.format({ async = true })
    end, opts)
  end,
})
