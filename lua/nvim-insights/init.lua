local M = {}

local config = {
  async = true,
  insights_bin = 'insights',
  use_default_keymaps = true,
  use_libc = true,
  use_vsplit = true,
}

M._set_default_keymaps = function()
    -- For running insights on the current buffer:
    vim.api.nvim_set_keymap('n', '<leader>ci', ':lua require("nvim-insights").run_current_buf()<CR>', { noremap = true, silent = true })
    -- For selecting a file via telescope
    vim.api.nvim_set_keymap('n', '<leader>ct', ':lua require("nvim-insights").run_telescope()<CR>', { noremap = true, silent = true })
end

M.setup = function(opts)
    -- Default options
  config = vim.tbl_extend('force', config, opts or {})
  if config.use_default_keymaps then
    M._set_default_keymaps()
  end
end

M._write_result = function(result)
  local split = config.use_vsplit and 'vnew' or 'new'
  print("split: ", split)
  vim.cmd(split)

  vim.api.nvim_buf_set_option(0, 'buftype',   'nofile')
  vim.api.nvim_buf_set_option(0, 'bufhidden', 'hide')
  vim.api.nvim_buf_set_option(0, 'swapfile',  false)
  vim.cmd[[setfiletype cpp]]
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(result, "\n"))
end

M._run_async = function(file)
  local runner = require'plenary.job'
  local lib = config.use_libc and '--use-libc++' or ''

  local job = runner:new {
    command = config.insights_bin,
    args = { file, lib },
    on_exit = function(j, exit_code)
      vim.schedule(function()
        if exit_code == 0 then
          local result = table.concat(j:result(), '\n')
          M._write_result(result)
        else
          vim.api.nvim_out_write('Insights Error: ' .. table.concat(j:stderr_result(), '\n'))
        end
      end)
    end
  }

  job:start()
end

M._run_sync = function(file)
  local lib = config.use_libc and '--use-libc++' or ''
  local result = vim.fn.system({config.insights_bin, file, lib})
  M._write_result(result)
end

M._run_insights = function(file)
  if not vim.fn.executable(config.insights_bin) then
    vim.api.nvim_out_write('insights binary not found, please ensure it is installed and on your PATH')
  end

  if config.async then
    M._run_async(file)
  else
    M._run_async(file)
  end

end

M.run_current_buf = function ()
  local file = vim.fn.expand('%:p')
  M._run_insights(file)
end

M.run_telescope = function()
  require('telescope.builtin').find_files({
    prompt_title = 'Run cppinsights on: ',
    attach_mappings = function(prompt_bufnr, map)
      local function on_selection()
        local selection = require('telescope.actions.state').get_selected_entry()
        require('telescope.actions').close(prompt_bufnr)
        M._run_insights(selection.value)
      end

    map('i', '<CR>', on_selection)
    map('n', '<CR>', on_selection)
    return true
  end,
})
end

return M
