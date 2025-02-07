-- Lua
return {
  'folke/twilight.nvim',
  lazy = true,
  keys = {
    { '<leader>tt', '<cmd>Twilight<cr>', desc = 'Toggle twilight (focus mode)' },
  },
  opts = {
    dimming = {
      alpha = 0.35,
    },
    context = 10,
    treesitter = false,
    expand = {
      'function',
      -- 'method',
      -- 'table',
      -- 'if_statement',
      -- 'function_declaration',
      -- 'method_declaration',
      -- 'pair',
    },
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
}
