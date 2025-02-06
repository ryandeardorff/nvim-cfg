vim.keymap.set('n', '<leader>cec', '<cmd>CECompile!<CR>')
vim.keymap.set('n', '<leader>cel', '<cmd>CECompileLive<CR>')
vim.keymap.set('n', '<leader>cet', '<cmd>CEShowTooltip<CR>')
return {
  'krady21/compiler-explorer.nvim',
  lazy = true,
  event = 'BufEnter',
}
