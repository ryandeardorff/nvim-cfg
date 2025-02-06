vim.keymap.set('n', '<leader>hx', function()
  require('hex').toggle()
end)
return {
  'RaafatTurki/hex.nvim',
  lazy = true,
  keys = { '<leader>hx' },
}
