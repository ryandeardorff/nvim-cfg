return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    lazy = true,
    keys = { '<C-\\>' },
    config = function()
      require('toggleterm').setup {
        open_mapping = [[<c-\>]],
        direction = 'float',
        --shell = 'nu',
      }
    end,
  },
}
