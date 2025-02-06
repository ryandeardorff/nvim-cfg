local cp = require 'legendary'
cp.command {
  ':Dismiss',
  function()
    require('notify').dismiss {
      pending = true,
      silent = true,
    }
  end,
  description = 'Dismisses all notifications',
}

return {
  'rcarriga/nvim-notify',
  config = function()
    vim.notify = require 'notify'
    require('notify').setup {
      top_down = false,
    }
  end,
}
