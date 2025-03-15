return {
  {
    'stevearc/overseer.nvim',
    opts = {},
    -- lazy = true,
    -- keys = { '<leader>om', '<leader>oo', '<leader>or' },
    config = function()
      local overseer = require 'overseer'
      overseer.setup()
      vim.api.nvim_create_user_command('Make', function(params)
        -- Insert args at the '$*' in the makeprg
        local cmd, num_subs = vim.o.makeprg:gsub('%$%*', params.args)
        if num_subs == 0 then
          cmd = cmd .. ' ' .. params.args
        end
        local task = require('overseer').new_task {
          cmd = vim.fn.expandcmd(cmd),
          components = {
            { 'on_output_quickfix', open = false, set_diagnostics = true },
            { 'qfnotify' },
            'default',
          },
        }
        task:start()
      end, {
        desc = 'Run your makeprg as an Overseer task',
        nargs = '*',
      })
      vim.keymap.set('n', '<leader>om', '<cmd>Make<CR>')
      vim.keymap.set('n', '<leader>oo', '<cmd>OverseerToggle<CR>')
      vim.keymap.set('n', '<leader>or', '<cmd>OverseerRun<CR>')
    end,
  },
}
