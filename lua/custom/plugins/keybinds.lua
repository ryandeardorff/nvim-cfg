vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<CR>')
vim.keymap.set('n', '<leader>;', '<cmd>Alpha<CR>')
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>')
vim.keymap.set('n', '<leader>q', '<cmd>:q!<CR>')
vim.keymap.set('n', '<leader>vs', '<cmd>:vs<CR>')

vim.keymap.set('n', '<c-.>', '<cmd>vertical resize +10<CR>')
vim.keymap.set('n', '<c-,>', '<cmd>vertical resize -10<CR>')
vim.keymap.set('n', '<c-right>', '<cmd>vertical resize +10<CR>')
vim.keymap.set('n', '<c-left>', '<cmd>vertical resize -10<CR>')
vim.keymap.set('n', '<c-up>', '<cmd>resize +10<CR>')
vim.keymap.set('n', '<c-down>', '<cmd>resize -10<CR>')

vim.keymap.set('n', 'g<S-c>', 'gcc', { remap = true })

vim.keymap.set('i', 'jj', '<esc>', { remap = true })

vim.keymap.set('n', '<leader>ms', '<cmd>:Markview splitToggle<CR>')
vim.keymap.set('n', '<leader>mo', '<cmd>:Markview open<CR>')

return {}
