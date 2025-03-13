return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup {
      options = {
        component_separators = { left = '', right = '' },
        --section_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = { { 'mode', separator = { left = ' ' }, right_padding = 2 } },
        lualine_y = {
          { 'datetime', style = '%m/%d %I:%M' },
        },
        lualine_z = {
          { 'location', separator = { right = ' ' }, left_padding = 2 },
        },
      },
    }
  end,
}
