local M = {}

local plugin_setup = require'insights.setup'
M.setup = function(opts) plugin_setup.setup(opts) end
M._config = plugin_setup.get_config()

M._write_result = function(result)
  local split = M._config.use_vsplit and 'vnew' or 'new'
  vim.cmd(split)

  vim.api.nvim_buf_set_option(0, 'buftype',   'nofile')
  vim.api.nvim_buf_set_option(0, 'bufhidden', 'hide')
  vim.api.nvim_buf_set_option(0, 'swapfile',  false)
  vim.cmd[[setfiletype cpp]]
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(result, "\n"))
end

M._run_local_async = function(file)
  local lib = M._config.use_libc and '--use-libc++' or ''
  local runner = require'plenary.job'

  local job = runner:new {
    command = M._config.insights_bin,
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

M._run_local_sync = function(file)
  local lib = M._config.use_libc and '--use-libc++' or ''
  local result = vim.fn.system({M._config.insights_bin, file, lib})
  M._write_result(result)
end

M._run_local_insights = function(file)
  if M._config.async then
    M._run_local_async(file)
  else
    M._run_local_sync(file)
  end
end

M._run_web_insights = function(file)
  local curl = require'insights.curl'

  -- get data from current buffer
  local f = io.open(file, 'r')
  if not f then
    vim.api.nvim_out_write('Could not open cpp file: ', file)
    return
  end
  local content = f:read('*all')
  f:close()

  if M._config.async then
    curl.async_http_request(content, M._write_result)
  else
    curl.http_request(content, M._write_result)
  end
end

-- determine whether to run against local cppinsights
-- or make http request to cppinsights.io
M._find_run_env = function(file)
  local bin_exists = true
  if vim.fn.executable(M._config.insights_bin) ~= 1 then
    bin_exists = false
  end

  if M._config.local_only and M._config.http_only then
    vim.api.nvim_out_write("I can't run anywhere, please disable one of either `local_only` or `http_only`")
    return
  end

  if M._config.http_only then
    M._run_web_insights(file)
    return
  end

  if bin_exists then
    M._run_local_insights(file)
  elseif M._config.run_local then
    vim.api.nvim_out_write('insights binary not found, please ensure it is installed and on your PATH, or allow HTTP')
  else
    M._run_web_insights(file)
  end
end


M.run_current_buf = function()
  M._config = plugin_setup.get_config()
  local current_buf = vim.fn.expand('%:p')
  M._find_run_env(current_buf)
end

M.run_telescope = function()
  M._config = plugin_setup.get_config()
  require('telescope.builtin').find_files({
    prompt_title = 'Run cppinsights on: ',
    attach_mappings = function(prompt_bufnr, map)
      local function on_selection()
        local selection = require('telescope.actions.state').get_selected_entry()
        require('telescope.actions').close(prompt_bufnr)
        M._find_run_env(selection.value)
      end

    map('i', '<CR>', on_selection)
    map('n', '<CR>', on_selection)
    return true
  end,
})
end

return M
