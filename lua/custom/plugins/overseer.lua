return {
  {
    'stevearc/overseer.nvim',
    opts = {},
    -- lazy = true,
    keys = {
      { '<leader>om', '<cmd>Make<cr>', desc = 'Run makeptr as an overseer task' },
      { '<leader>oo', '<cmd>OverseerToggle<cr>', desc = 'Toggle overseer' },
      { '<leader>or', '<cmd>OverseerRun<cr>', desc = 'Run overseer' },
    },
    init = function()
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
    end,
  },
}
