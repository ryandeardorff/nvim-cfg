-- require('telescope').setup {
--   pickers = {
--     colorscheme = {
--       enable_preview = true,
--     },
--   },
-- }

return {
  {
    'Yazeed1s/oh-lucy.nvim',
    priority = 1000,
    config = function()
      -- vim.cmd.colorscheme 'oh-lucy-evening'
    end,
  },
  {
    'HoNamDuong/hybrid.nvim',
    priority = 1000,
    config = function()
      -- NOTE: My usual default!
      -- vim.cmd.colorscheme 'hybrid'
    end,
  },
  {
    'ramojus/mellifluous.nvim',
    priority = 1000,
    config = function()
      -- vim.cmd.colorscheme 'mellifluous'
    end,
  },
  { 'AlexvZyl/nordic.nvim', priority = 1000 },
  {
    'sho-87/kanagawa-paper.nvim',
    priority = 1000,
    config = function()
      -- vim.cmd.colorscheme 'kanagawa-paper'
    end,
  },
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    config = function()
      -- vim.cmd.colorscheme 'kanagawa-wave'
    end,
  },
  {
    'rafamadriz/neon',
    priority = 1000,
    config = function()
      -- vim.cmd.colorscheme 'neon'
    end,
  },
  {
    'catppuccin/nvim',
    priority = 1000,
    name = 'catppuccin',
    config = function()
      -- vim.cmd.colorscheme 'catppuccin'
    end,
  },
  {
    'slugbyte/lackluster.nvim',
    priority = 1000,
    config = function()
      --vim.cmd.colorscheme 'lackluster'
      -- vim.cmd.colorscheme("lackluster-hack") -- my favorite
      -- vim.cmd.colorscheme("lackluster-mint")
    end,
  },
  {
    'dgox16/oldworld.nvim',
    priority = 1000,
    config = function()
      --vim.cmd.colorscheme 'oldworld'
    end,
  },
  {
    'killitar/obscure.nvim',
    priority = 1000,
    opts = {},
    config = function()
      --vim.cmd.colorscheme 'obscure'
    end,
  },
  {
    'mellow-theme/mellow.nvim',
    priority = 1000,
    opts = {},
    config = function()
      --vim.cmd.colorscheme 'mellow'
    end,
  },
  {
    'nickkadutskyi/jb.nvim',
    priority = 1000,
    opts = {},
    config = function()
      --vim.cmd.colorscheme 'jb'
    end,
  },
  {
    'armannikoyan/rusty',
    priority = 1000,
    opts = {},
    config = function()
      --vim.cmd.colorscheme 'rusty'
    end,
  },
}
