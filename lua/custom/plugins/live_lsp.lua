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
  vim.uv.spawn('pwsh', {
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

GetRoot = function()
  local root_dir = vim.fs.dirname(vim.fs.find({ 'pyproject.toml' }, { upward = true })[1])
  if not root_dir then
    vim.notify("Couldn't find root directory for live lsp (expected dir with pyproject.toml + setuptools)!", vim.log.levels.ERROR)
    return nil
  end
  return root_dir
end

local attach_buf = 0

local server
StartServer = function()
  local root = GetRoot()
  server = vim.system({ 'pwsh', './StartTestLSP.ps1' }, {
    cwd = root,
    stdin = true,
  }, function(out)
    vim.notify('Server closed with code:' .. out.code, vim.log.levels.INFO)
  end)
end

StopServer = function()
  local tcp = vim.uv.new_tcp()
  -- use a tcp connect+close to try to get the server to stop (this was the only thing that seemed to kill it for me 💀)
  tcp:connect(testip, testport, function(err)
    tcp:close()
  end)
  -- now just try killing it a few times in case it's stuck in the pwsh script, venv or something else
  server:kill(9)
  server:kill(9)
  server:kill(9)
end

local client = nil
local pendingclient = nil
StartClient = function()
  if client then
    vim.notify('Client already started!', vim.log.levels.ERROR)
    return
  end
  pendingclient = vim.lsp.start({
    name = 'live-lsp',
    cmd = function(...)
      return vim.lsp.rpc.connect(testip, testport)(...)
    end,
    on_init = function(_, res)
      client = pendingclient
      vim.schedule(function()
        vim.notify('Live lsp client initialized:' .. vim.inspect(res), vim.log.levels.INFO)
      end)
    end,
    on_exit = function(code, sig, cid)
      vim.schedule(function()
        vim.notify('Live lsp client exited: Code=' .. code, ((code == 0) and { vim.log.levels.INFO } or { vim.log.levels.ERROR })[1])
        client = nil
      end)
    end,
    on_error = function(code, res)
      vim.schedule(function()
        require('notify').notify(code .. ':' .. vim.inspect(res), vim.log.levels.ERROR, { title = 'Live LSP Client Error' })
      end)
    end,
  }, { bufnr = attach_buf })
  -- detect client connection error:
  local timer = vim.uv.new_timer()
  timer:start(
    1000,
    0,
    vim.schedule_wrap(function()
      local cinfo = vim.lsp.get_clients { name = 'live-lsp' }
      if table.getn(cinfo) == 0 then
        vim.notify('Timeout: Live LSP could not connect a client!', vim.log.levels.ERROR)
        StopClient()
        return
      end
      vim.notify('Successfully connected client!', vim.log.levels.INFO)
      timer:close()
    end)
  )
end
StopClient = function()
  if not client then
    vim.notify('No existing client to close!', vim.log.levels.ERROR)
  end
  vim.lsp.stop_client(client, false)
  client = nil
end

--
BootLsp = function()
  if client then
    StopClient()
  end
  if server then
    StopServer()
  end
  StartServer()
  -- wait for startup (loops until client is created)
  local timer = vim.uv.new_timer()
  timer:start(
    700, -- fine tuning this value could improve reload performance, since it's meant to be a short as startup
    500, -- same with this one, this is just to prevent spamming, but it's for polling so shorter = more frequent = more responsive
    vim.schedule_wrap(function()
      if client then
        timer:stop()
        timer:close()
        return
      end
      StartClient()
    end)
  )
end

Attach = function()
  attach_buf = vim.api.nvim_get_current_buf()
  -- Autocommand to automatically boot lsp when applicable filetypes change (py, js, json, ts, toml)
  vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
    pattern = { '*.py', '*.js', '*.json', '*.ts', '*.toml' },
    callback = function(ev)
      BootLsp()
    end,
  })
  -- Autocommand to remove the attached buffer and shutdown lsp client when buffer is closed
  vim.api.nvim_create_autocmd({ 'BufDelete' }, {
    callback = function(ev)
      StopClient()
      attach_buf = 0
    end,
  })
  BootLsp()
end
Detach = function() end

local cp = require 'legendary'
cp.command {
  ':LLBuild',
  LiveLspBuild,
  description = 'Build a editable lsp from a pyproject.toml using setuptools',
}
cp.command {
  ':LLStartClient',
  StartClient,
  description = 'Start a LSP client for the current buffer!',
}
cp.command {
  ':LLStartServer',
  StartServer,
  description = 'Start a LSP server using the StartTestLSP.ps1 from a root dir with pyproject.toml',
}
cp.command {
  ':LLStopServer',
  StopServer,
  description = 'Stop the currently running test LSP server.',
}
cp.command {
  ':LLBoot',
  BootLsp,
  description = 'Start or reload both client and server for LSP.',
}
cp.command {
  ':LLAttach',
  Attach,
  description = 'Start or reload both client and server for LSP.',
}

return {}
