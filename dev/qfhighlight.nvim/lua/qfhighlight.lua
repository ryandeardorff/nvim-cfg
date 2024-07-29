local M = {}
local H = {}

-- initial value for toggle
M.toggled = false

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
  M.mark_ns = vim.api.nvim_create_namespace 'qfhighlight'
  M.setup_commands()
  M.setup_autocmd()
end

function M.setup_commands()
  vim.api.nvim_create_user_command('QFHighlightAdd', M.highlight_add, {})
  vim.api.nvim_create_user_command('QFHighlightClear', M.highlight_clear, {})
  vim.api.nvim_create_user_command('QFHighlightToggle', M.highlight_toggle, {})
end

function M.setup_autocmd()
  vim.api.nvim_create_autocmd({ 'QuickFixCmdPost', 'BufEnter' }, {
    command = 'QFHighlightAdd',
  })
  -- vim.api.nvim_create_autocmd({ 'QuickFixCmdPost' }, {
  --   command = 'Trouble qflist',
  -- })
end

---
M.config = {}

M.highlight_add = function()
  -- clear existing
  M.highlight_clear()

  ---@type vim.Diagnostic[]
  local diagnostics = vim.diagnostic.fromqflist(vim.fn.getqflist())

  for _, el in ipairs(diagnostics) do
    vim.diagnostic.set(M.mark_ns, el.bufnr, { el }, { underline = true })
  end

  vim.notify('Added highlights', vim.log.levels.TRACE, { title = 'qfhighlight' })
  M.toggled = true
end
M.highlight_clear = function()
  vim.diagnostic.reset(M.mark_ns)
  vim.notify('Cleared highlights', vim.log.levels.TRACE, { title = 'qfhighlight' })
  M.toggled = false
end
M.highlight_toggle = function()
  if M.toggled then
    M.highlight_clear()
  else
    M.highlight_add()
  end
  vim.notify('Toggled highlights', vim.log.levels.TRACE, { title = 'qfhighlight' })
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

return M
