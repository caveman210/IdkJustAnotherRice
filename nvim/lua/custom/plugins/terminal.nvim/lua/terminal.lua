local M = {}
M.get_window_config = function()
  local editor_height = vim.api.nvim_get_option_value('lines', {})
  local editor_width = vim.api.nvim_get_option_value('columns', {})
  local win_height = math.floor(editor_height * 0.65)
  local win_width = math.floor(editor_width * 0.675)
  local row = math.floor((editor_height - win_height) / 2)
  local col = math.floor((editor_width - win_width) / 2)

  return {
    relative = 'editor',
    height = win_height,
    width = win_width,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  }
end

M.create_term = function()
  local win_config = M.get_window_config()
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = bufnr })
  local win_id = vim.api.nvim_open_win(bufnr, true, win_config)
  vim.api.nvim_set_option_value('number', false, { win = win_id })
  vim.api.nvim_set_option_value('relativenumber', false, { win = win_id })
  vim.api.nvim_set_option_value('cursorline', false, { win = win_id })
  vim.cmd 'terminal'
  local term_bufnr = vim.api.nvim_get_current_buf()
  vim.keymap.set('t', 'jk', '<C-\\><C-n>', {
    buffer = term_bufnr,
    noremap = true,
    silent = true,
    desc = 'Exit Terminal Mode',
  })
  vim.keymap.set('n', 'q', function()
    vim.api.nvim_buf_delete(0, { force = true })
  end, {
    buffer = term_bufnr,
    noremap = true,
    silent = true,
    desc = 'Close Terminal Window',
  })
  vim.cmd 'startinsert'
end

return M
