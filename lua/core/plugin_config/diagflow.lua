require('diagflow').setup({
  -- The default configuration
  default = {
    -- The path to the diagflow binary
    bin = 'diagflow',
    -- The path to the diagflow config file
    config = vim.fn.stdpath('config') .. '/diagflow/config.json',
    -- The path to the diagflow cache directory
    cache_dir = vim.fn.stdpath('cache') .. '/diagflow',
    -- Whether to enable logging
    log = true,
  },
})
