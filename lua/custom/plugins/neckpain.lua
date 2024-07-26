return {
  'shortcuts/no-neck-pain.nvim',
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
