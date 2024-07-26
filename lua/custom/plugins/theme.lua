require('telescope').setup {
  pickers = {
    colorscheme = {
      enable_preview = true,
    },
  },
}

vim.cmd.colorscheme 'habamax'

return {
  {
    'sho-87/kanagawa-paper.nvim',
    enabled = false,
    config = function()
      require('kanagawa-paper').setup()
      vim.cmd.colorscheme 'kanagawa-paper'
    end,
  },
  {
    'rebelot/kanagawa.nvim',
    enabled = false,
    config = function()
      require('kanagawa').setup()
      vim.cmd.colorscheme 'kanagawa-wave'
    end,
  },
}
