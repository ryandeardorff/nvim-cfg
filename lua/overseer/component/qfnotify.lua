---@type overseer.ComponentFileDefinition
return {
  desc = 'Performs the autocmd notifying of a quickfix change',
  constructor = function(params)
    return {
      on_exit = function(self, task, code)
        vim.api.nvim_exec_autocmds('QuickfixCmdPost', {})
      end,
    }
  end,
}
