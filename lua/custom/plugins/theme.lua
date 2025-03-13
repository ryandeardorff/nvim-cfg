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
      -- NOTE: My usual default!
      -- vim.cmd.colorscheme 'hybrid'
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
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    config = function()
      -- vim.cmd.colorscheme 'catppuccin'
    end,
  },
  {
    'slugbyte/lackluster.nvim',
    config = function()
      --vim.cmd.colorscheme 'lackluster'
      -- vim.cmd.colorscheme("lackluster-hack") -- my favorite
      -- vim.cmd.colorscheme("lackluster-mint")
    end,
  },
  {
    'dgox16/oldworld.nvim',
    lazy = false,
    config = function()
      --vim.cmd.colorscheme 'oldworld'
    end,
  },
  {
    'killitar/obscure.nvim',
    lazy = false,
    opts = {},
    config = function()
      --vim.cmd.colorscheme 'obscure'
    end,
  },
  {
    'mellow-theme/mellow.nvim',
    opts = {},
    config = function()
      --vim.cmd.colorscheme 'mellow'
    end,
  },
  {
    'nickkadutskyi/jb.nvim',
    opts = {},
    config = function()
      --vim.cmd.colorscheme 'jb'
    end,
  },
  {
    'armannikoyan/rusty',
    opts = {},
    config = function()
      vim.cmd.colorscheme 'rusty'
    end,
  },
}
