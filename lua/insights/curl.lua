local M = {}

local request = {
  cmd = "curl",
  content = "Content-Type: application/json;charset=UTF-8",
  method = "POST",
  url = "https://cppinsights.io",
  endpoint = "/api/v1/transform"
}

local reqOptions = { "cpp20" }

M.http_request = function(data, output_cb)
  local body = {
    insightsOptions = reqOptions,
    code = data
  }
  local cmd = string.format(
    "%s -s -X %s -H '%s' -d '%s' %s%s",
    request.cmd,
    request.method,
    request.content,
    vim.json.encode(body),
    request.url,
    request.endpoint
  )
  local res = vim.json.decode(vim.fn.system(cmd))
  local code = res.stdout
  output_cb(code)
end

M.async_http_request = function(data, output_cb)
  local runner = require'plenary.job'
  local body = {
    insightsOptions = reqOptions,
    code = data
  }

  local job = runner:new {
    command = request.cmd,
    args = {
      '-v', '-X', request.method,
      '-H', request.content,
      '-d', vim.json.encode(body),
      request.url .. request.endpoint
    },
    on_exit = function(j, exit_code)
      vim.schedule(function()
        if exit_code == 0 then
          local res = vim.json.decode(table.concat(j:result(), '\n'))
          local code = res.stdout
          output_cb(code)
        else
          vim.api.nvim_out_write('curl: request failed: ' .. table.concat(j:stderr_result(), '\n'))
        end
      end)
    end
  }

  job:sync()
end

return M
