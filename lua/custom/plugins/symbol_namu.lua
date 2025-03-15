return {
  'bassamsdata/namu.nvim',
  dependencies = {
    'raddari/last-color.nvim',
  },
  priority = 900,
  lazy = false,
  init = function()
    -- === Suggested Keymaps: ===
    vim.keymap.set('n', '<leader>sa', ':Namu symbols<cr>', {
      desc = 'Jump to LSP symbol',
      silent = true,
    })
    vim.keymap.set('n', '<leader>th', ':Namu colorscheme<cr>', {
      desc = 'Colorscheme Picker',
      silent = true,
    })
  end,
  config = function()
    require('namu').setup {
      -- Enable the modules you want
      namu_symbols = {
        enable = true,
        options = {}, -- here you can configure namu
      },
      -- Optional: Enable other modules if needed
      ui_select = { enable = false }, -- vim.ui.select() wrapper
      colorscheme = {
        enable = true,
        options = {
          -- NOTE: if you activate persist, then please remove any vim.cmd("colorscheme ...") in your config, no needed anymore
          persist = false, -- very efficient mechanism to Remember selected colorscheme
          write_shada = false, -- If you open multiple nvim instances, then probably you need to enable this
        },
      },
    }
    local theme = require('last-color').recall() or 'default'
    vim.cmd('noa colorscheme ' .. theme)
    vim.cmd('colorscheme ' .. theme)
    vim.api.nvim_create_autocmd('VimEnter', {
      callback = function()
        local theme = require('last-color').recall() or 'default'
        vim.cmd('noa colorscheme ' .. theme)
        vim.cmd('colorscheme ' .. theme)
        require('lualine').setup()
      end,
    })
    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = function()
        vim.cmd 'colorscheme'
        require('lualine').setup()
      end,
    })
  end,
}
