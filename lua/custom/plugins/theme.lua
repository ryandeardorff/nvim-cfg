require('telescope').setup {
  pickers = {
    colorscheme = {
      enable_preview = true,
    },
  },
}

return {
  {
    'Yazeed1s/oh-lucy.nvim',
    config = function()
      -- vim.cmd.colorscheme 'oh-lucy-evening'
    end,
  },
  {
    'HoNamDuong/hybrid.nvim',
    config = function()
      vim.cmd.colorscheme 'hybrid'
    end,
  },
  {
    'ramojus/mellifluous.nvim',
    config = function()
      -- vim.cmd.colorscheme 'mellifluous'
    end,
  },
  { 'AlexvZyl/nordic.nvim' },
  {
    'sho-87/kanagawa-paper.nvim',
    config = function()
      -- vim.cmd.colorscheme 'kanagawa-paper'
    end,
  },
  {
    'rebelot/kanagawa.nvim',
    config = function()
      -- vim.cmd.colorscheme 'kanagawa-wave'
    end,
  },
  {
    'rafamadriz/neon',
    config = function()
      -- vim.cmd.colorscheme 'neon'
    end,
  },
}
