vim.keymap.set('n', '<leader>\\', '<cmd>:BufTermEnter<CR>')
vim.opt.shell = 'nu'
vim.opt.shellcmdflag = '-c'
vim.opt.shellquote = ''
vim.opt.shellxquote = ''
return {
  { 'boltlessengineer/bufterm.nvim', opts = {} },
}
