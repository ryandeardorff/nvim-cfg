local handle = nil
local testbuf = nil
local testip = '127.0.0.1'
local testport = 8080
local notif = {}

local mdfunc = function(win)
  local buf = vim.api.nvim_win_get_buf(win)
  vim.wo[win].conceallevel = 3
  vim.api.nvim_set_option_value('filetype', 'markdown', { buf = buf })
  -- vim.treesitter.start(buf, 'markdown')
end

-- Dispatch a series of commands to the same terminal in the background, within the pyproject.toml working folder, logging to vim notify
DispatchCmds = function(title, cmds, success, fail)
  local notify = require 'notify'
  local root_dir = vim.fs.dirname(vim.fs.find({ 'pyproject.toml' }, { upward = true })[1])
  if not root_dir then
    vim.notify("Couldn't find root directory for live lsp (expected dir with pyproject.toml + setuptools)!", vim.log.levels.ERROR)
    return
  end

  -- persistant build notification
  notif = notify.notify('Found root dir :`' .. root_dir .. '`', vim.log.levels.INFO, {
    title = title,
    timeout = false,
    on_open = mdfunc,
  })

  local stdin = vim.uv.new_pipe()
  local stdout = vim.uv.new_pipe()
  local stderr = vim.uv.new_pipe()
  -- NOTE: currently only uses pwsh, so limited to windows atm
  handle = vim.uv.spawn('pwsh', {
    stdio = { stdin, stdout, stderr },
  }, function(code, _) -- on exit
    vim.schedule(function()
      if not code == 0 then
        notif = notify.notify(fail, vim.log.levels.ERROR, { replace = notif, timeout = 3000 })
      else
        notif = notify.notify(success, vim.log.levels.INFO, { replace = notif, timeout = 3000 })
      end
    end)
  end)
  vim.uv.write(stdin, table.concat(cmds, '\r\n') .. '\r\n')
  -- vim.fn.chanclose(handle, 'stdin')

  local chunk = ''
  local echunk = ''
  vim.uv.read_start(stdout, function(err, data)
    assert(not err, err)
    if data then
      local res = data:gsub('[\r]', '')
      if chunk then
        chunk = chunk .. res
      end
      if chunk:len() > 1 and chunk:sub(-1) == '\n' then
        vim.schedule(function()
          notif = notify.notify(chunk, vim.log.levels.INFO, { replace = notif, on_open = mdfunc })
          chunk = ''
        end)
      end
    end
  end)
  vim.uv.read_start(stderr, function(err, data)
    assert(not err, err)
    if data then
      local res = data:gsub('[\r]', '')
      if echunk then
        echunk = echunk .. res
      end
      if echunk:len() > 1 and echunk:sub(-1) == '\n' then
        vim.schedule(function()
          notify.notify(echunk, vim.log.levels.ERROR, { on_open = mdfunc })
          echunk = ''
        end)
      end
    end
  end)
end

-- Build a editable lsp from a pyproject.toml that uses setuptools (configures as install --editable for a .env/ virtual environment)
LiveLspBuild = function()
  DispatchCmds('Building LiveLsp Python Project', {
    'python -m venv .env',
    './.env/Scripts/Activate.ps1',
    'pip install --editable .',
    'exit',
  }, 'Successfully built LiveLSP editable installation', 'Failed to build LiveLSP editable installation!')
end

-- Launching (or relaunching) a live development lsp --
local live_lsp = nil
LiveLaunchLSP = function()
  if live_lsp then
    vim.notify('Shuting down old LiveLSP instance to reload', vim.log.levels.INFO)
    LiveCloseLSP()
  end
  vim.notify('Starting up Live development LSP', vim.log.levels.INFO)
  live_lsp = vim.fn.jobstart('pwsh', {
    stdout_buffered = false,
    stderr_buffered = false,
    on_exit = function(_, code)
      vim.schedule(function()
        if code == 0 then
          vim.notify('LSP Server exited with code (0)', vim.log.levels.INFO)
        else
          vim.notify('LSP Server exited with code (' .. code .. ')!', vim.log.levels.ERROR)
        end
      end)
    end,
    on_stdout = function(_, data)
      vim.schedule(function()
        vim.notify(table.concat(data, '\n'):gsub('[\r]', ''), vim.log.levels.INFO)
      end)
    end,
    on_stderr = function(_, data)
      vim.schedule(function()
        vim.notify(table.concat(data, '\n'):gsub('[\r]', ''), vim.log.levels.ERROR)
      end)
    end,
  })
  vim.fn.chansend(live_lsp, {
    './.env/Scripts/Activate.ps1',
    'lizzr-ls ' .. '-tcp -a ' .. testip .. ' -p ' .. testport .. '',
  })
  -- vim.fn.chanclose(live_lsp, 'stdin')
end

LiveCloseLSP = function()
  if not live_lsp then
    vim.notify('There is no development LSP running to close!', vim.log.levels.ERROR)
    return
  end
  vim.fn.chanclose(live_lsp, 'stdin')
  vim.notify('Issued channel close to shutdown live development LSP', vim.log.levels.INFO)
end

local cp = require 'legendary'
cp.command {
  ':LiveLspBuild',
  LiveLspBuild,
  description = 'Build a editable lsp from a pyproject.toml using setuptools',
}
cp.command {
  ':LiveLaunchLSP',
  LiveLaunchLSP,
  description = 'Load or reload a built live LSP from the current pyproject.',
}
cp.command {
  ':LiveCloseLSP',
  LiveCloseLSP,
  description = 'Shut down the running development LSP',
}

local client = nil
AttachLive = function()
  KillClient()
  client = vim.lsp.start {
    name = 'live-lsp',
    cmd = function(...)
      return vim.lsp.rpc.connect(testip, testport)(...)
    end,
    root_dir = vim.fs.root(0, { 'pyproject.toml' }),
    trace = 'verbose',
    on_exit = function(code, _, _)
      if code == 0 then
        vim.notify('LSP client exited with code 0', vim.log.levels.INFO)
      else
        vim.notify('LSP client exited with code ' .. code, vim.log.levels.ERROR)
        KillClient()
      end
    end,
    on_error = function()
      vim.notify('Error in lsp client', vim.log.levels.ERROR)
      KillClient()
    end,
  }
  if not client then
    KillClient()
  end
  vim.notify('Successfully started LSP client', vim.log.levels.INFO)
end

AttachBuf = function()
  testbuf = vim.api.nvim_get_current_buf()
  AttachLive()
  assert(client)
  local res = vim.lsp.buf_attach_client(testbuf, client)
  if not res or not vim.lsp.buf_is_attached(testbuf, client) or vim.lsp.client_is_stopped(client) then
    vim.notify('Failed to create client or attach to buffer', vim.log.levels.ERROR)
    KillClient()
  end
  vim.notify('Successfully attached LSP client to buffer', vim.log.levels.INFO)
end

KillClient = function()
  if client then
    if testbuf then
      vim.lsp.buf_detach_client(testbuf, client)
    end
    vim.lsp.stop_client(client, true)
  end
  client = nil
  vim.notify('Successfully killed LSP client and detached from buffer', vim.log.levels.INFO)
end

vim.keymap.set('n', '<leader>la', AttachBuf)
vim.keymap.set('n', '<leader>lk', KillClient)
vim.keymap.set('n', '<leader>lr', function()
  KillClient()
  LiveCloseLSP()
  LiveLaunchLSP()
  AttachBuf()
end)

return {}
