vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<CR>')
vim.keymap.set('n', '<leader>;', '<cmd>Alpha<CR>')
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>')
vim.keymap.set('n', '<leader>q', '<cmd>:q!<CR>')
vim.keymap.set('n', '<leader>vs', '<cmd>:vs<CR>')

vim.keymap.set('n', 'g<S-c>', 'gcc', { remap = true })

vim.keymap.set('i', 'jj', '<esc>', { remap = true })

return {}
