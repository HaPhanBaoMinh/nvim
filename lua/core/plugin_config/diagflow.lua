require('diagflow').setup({
  enable = true,
  max_width = 60,
  max_height = 10,
  severity_colors = {
    error = "DiagnosticFloatingError",
    warning = "DiagnosticFloatingWarn",
    info = "DiagnosticFloatingInfo",
    hint = "DiagnosticFloatingHint",
  },
  format = function(diagnostic)
    return diagnostic.message
  end,
  gap_size = 1,
  scope = 'cursor',   -- 'cursor' hoặc 'line'
  padding_top = 0,
  padding_right = 0,
  text_align = 'right',   -- 'left' hoặc 'right'
  placement = 'top',      -- 'top' hoặc 'inline'
  inline_padding_left = 0,
  update_event = { 'DiagnosticChanged', 'BufReadPost' },
  toggle_event = {},
  show_sign = false,
  render_event = { 'DiagnosticChanged', 'CursorMoved' },
  border_chars = {
    top_left = "┌",
    top_right = "┐",
    bottom_left = "└",
    bottom_right = "┘",
    horizontal = "─",
    vertical = "│"
  },
  show_borders = false,
})
