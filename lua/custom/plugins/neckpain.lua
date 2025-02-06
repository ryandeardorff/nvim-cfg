return {
  'shortcuts/no-neck-pain.nvim',
  lazy = true,
  keys = { '<Leader>np' },
  config = function()
    require('no-neck-pain').setup {
      width = 160,
      mappings = {
        enabled = true,
        toggle = '<Leader>np',
      },
    }
  end,
}
