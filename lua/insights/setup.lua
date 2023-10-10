local M = {}

M._config = {
  local_only = false,
  http_only = false,
  async = true,
  insights_bin = 'insights',
  use_default_keymaps = true,
  use_libc = true,
  use_vsplit = true,
}

M._set_default_keymaps = function()
  -- For running insights on the current buffer:
  vim.api.nvim_set_keymap('n', '<leader>ci', ':lua require("insights").run_current_buf()<CR>', { noremap = true, silent = true })
  -- For selecting a file via telescope
  vim.api.nvim_set_keymap('n', '<leader>ct', ':lua require("insights").run_telescope()<CR>', { noremap = true, silent = true })
end

M.setup = function(opts)
    -- Default options
  local config = vim.tbl_deep_extend('force', M._config, opts or {})
  if config.use_default_keymaps then
    M._set_default_keymaps()
  end
  M._config = config
end

M.get_config = function()
  return M._config
end

return M
