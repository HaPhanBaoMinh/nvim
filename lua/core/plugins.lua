require("lazy").setup({
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  "tpope/vim-commentary",
  "luckasRanarison/tailwind-tools.nvim",
  "mattn/emmet-vim",
  "nvim-tree/nvim-tree.lua",
  "windwp/nvim-autopairs",
  "nvim-tree/nvim-web-devicons",
  "ellisonleao/gruvbox.nvim",
  "dracula/vim",
  "nvim-lualine/lualine.nvim",
  "nvim-treesitter/nvim-treesitter",
  "dgagn/diagflow.nvim",
  "vim-test/vim-test",
  "lewis6991/gitsigns.nvim",
  "preservim/vimux",
  "christoomey/vim-tmux-navigator",
  "tpope/vim-fugitive",
  "tpope/vim-surround",
  "stevearc/oil.nvim",
  "folke/flash.nvim",
  -- completion
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  "rafamadriz/friendly-snippets",
  "github/copilot.vim",
  "williamboman/mason.nvim",
  "chentoast/marks.nvim",
  "numToStr/Comment.nvim",
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
    requires = "nvim-treesitter/nvim-treesitter",
  },
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
  "nvimtools/none-ls.nvim",
  {
    "vinnymeller/swagger-preview.nvim",
    run = "npm install -g swagger-ui-watcher",
  },
  {
    "ojroques/nvim-osc52",
    config = function()
      require("osc52").setup({
        max_length = 0, -- Không giới hạn độ dài text copy
        silent = false, -- Hiện thông báo khi copy thành công
        trim = false, -- Giữ nguyên khoảng trắng
      })

      -- Tự động copy vào clipboard hệ thống khi yank
      local function copy()
        -- Chỉ copy khi là thao tác yank (không phải delete hoặc change)
        if vim.v.event.operator == "y" then
          -- Copy cả unnamed register và các register khác
          require("osc52").copy_register(vim.v.event.regname or "")
        end
      end

      vim.api.nvim_create_autocmd("TextYankPost", {
        callback = copy,
        pattern = "*",
        desc = "Auto copy to system clipboard with OSC52",
      })

      -- Tuỳ chọn: Tạo mapping để copy cả file
      vim.keymap.set("n", "<leader>y", function()
        require("osc52").copy(vim.fn.getreg("*"))
        vim.notify("Copied entire file to clipboard!", vim.log.levels.INFO)
      end, { desc = "Copy entire file to clipboard" })
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.4",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
})
