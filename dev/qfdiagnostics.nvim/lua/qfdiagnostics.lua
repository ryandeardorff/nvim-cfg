local M = {}
local H = {}
local highlight = require 'highlight'

--- @param config table|nil Module config table. See |QF.config|
---
--- @usage > lua
---   reuiqre('qfdiagnostic').setup()
---   -- OR
---   require('qfdiagnostic').setup({})
--- <
function M.setup(config)
  -- Setup config
  config = H.setup_config(config)
  -- Apply config
  H.apply_config(config)
  M.setup_commands()
end

function M.setup_commands()
  vim.api.nvim_create_user_command('DiagnosticsPlace', M.highlight_place, {})
  vim.api.nvim_create_user_command('DiagnosticsClear', M.highlight_clear, {})
  vim.api.nvim_create_user_command('DiagnosticsToggle', M.highlight_toggle, {})
end

---
M.config = {
  test = 'test',
}

M.highlight_place = function()
  highlight.place(false)
  vim.notify('Adding highlights', vim.log.levels.INFO, { title = 'qfdiagnostics' })
end
M.highlight_clear = function()
  vim.notify('Clearing highlights', vim.log.levels.INFO, { title = 'qfdiagnostics' })
end
M.highlight_toggle = function()
  vim.notify('Toggling highlights', vim.log.levels.INFO, { title = 'qfdiagnostics' })
end

-- Helper data ========================================================================
-- Default config
H.default_config = vim.deepcopy(M.config)
H.setup_config = function(config)
  vim.validate { config = { config, 'table', true } }
  config = vim.tbl_deep_extend('force', vim.deepcopy(H.default_config), config or {})
end

H.apply_config = function(config)
  M.config = config
end

vim.api.nvim_create_user_command('DiagnosticsPlace', M.highlight_place, {})

return M
