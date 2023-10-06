local M = {}

if vim.fn.has("nvim-0.7") ~= 1 then
  vim.api.nvim_err_writeln("nvim-insights requires nvim version >= 0.7")
end

require('nvim-insights')

return M
