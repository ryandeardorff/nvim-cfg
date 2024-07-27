local lsp = nil
local handle = nil
local testbuf = nil
local testip = '127.0.0.1'
local testport = 8080

local bootlsp = function()
  local root_dir = vim.fs.dirname(vim.fs.find({ 'pyproject.toml' }, { upward = true })[1])
  print('found root dir for live lsp:', root_dir)
  local stdin = vim.uv.new_pipe()
  local stdout = vim.uv.new_pipe()
  local stderr = vim.uv.new_pipe()
  handle = vim.uv.spawn('pwsh', {
    stdio = { stdin, stdout, stderr },
  })
  vim.uv.write(stdin, 'python -m venv .env\r\n')
  vim.uv.write(stdin, './.env/Scripts/Activate.ps1\r\n')
  vim.uv.write(stdin, 'pip install --editable .\r\n')
  vim.uv.write(stdin, 'lizzr-ls ' .. '-tcp -a ' .. testip .. ' -p ' .. testport .. '\r\n')
  vim.uv.read_start(stdout, function(err, data)
    assert(not err, err)
    if data then
      print(data)
    end
  end)
  vim.uv.read_start(stderr, function(err, data)
    assert(not err, err)
    if data then
      print('E:', data)
    end
  end)
end

TryStart = function()
  lsp = vim.lsp.start {
    name = 'live-lsp',
    cmd = function(...)
      bootlsp()
      return vim.lsp.rpc.connect(testip, testport)(...)
    end,
    root_dir = vim.fs.root(0, { 'pyproject.toml' }),
  }
  assert(lsp, lsp)
  if testbuf then
    vim.lsp.buf_attach_client(testbuf, lsp)
  end
end

TryStop = function()
  assert(handle)
  assert(lsp)
  vim.lsp.stop_client(lsp)
  vim.uv.close(handle)
end

AttachLive = function()
  lsp = vim.lsp.start {
    name = 'live-lsp',
    cmd = function(...)
      return vim.lsp.rpc.connect(testip, testport)(...)
    end,
    root_dir = vim.fs.root(0, { 'pyproject.toml' }),
  }
end

AttachBuf = function()
  testbuf = vim.api.nvim_get_current_buf()
  if lsp then
    vim.lsp.buf_attach_client(testbuf, lsp)
  end
  vim.lsp.set_log_level 'DEBUG'
end

vim.keymap.set('n', '<leader>ls', TryStart)
vim.keymap.set('n', '<leader>lc', TryStop)
vim.keymap.set('n', '<leader>la', AttachBuf)
vim.keymap.set('n', '<leader>ll', AttachLive)

return {}
