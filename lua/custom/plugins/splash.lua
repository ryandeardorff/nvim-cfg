return {
  'goolord/alpha-nvim',
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'
    dashboard.section.buttons.val = {
      dashboard.button('p', '🗃  Projects', '<cmd>Telescope projects<CR>'),
    }
    alpha.setup(dashboard.opts)
  end,
}
