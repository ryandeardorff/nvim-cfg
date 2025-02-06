vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<CR>')
vim.keymap.set('n', '<leader>;', '<cmd>Alpha<CR>')
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>')
vim.keymap.set('n', '<leader>u', '<cmd>e!<CR>')
vim.keymap.set('n', '<leader>q', '<cmd>:q!<CR>')
vim.keymap.set('n', '<leader>vs', '<cmd>:vs<CR>')
vim.keymap.set('n', '<leader>hs', '<cmd>:split<CR>')

vim.keymap.set('n', '<c-.>', '<cmd>vertical resize +10<CR>')
vim.keymap.set('n', '<c-,>', '<cmd>vertical resize -10<CR>')
vim.keymap.set('n', '<c-<>', '<cmd>resize +5<CR>')
vim.keymap.set('n', '<c->>', '<cmd>resize -5<CR>')
vim.keymap.set('n', '<c-right>', '<cmd>vertical resize +10<CR>')
vim.keymap.set('n', '<c-left>', '<cmd>vertical resize -10<CR>')
vim.keymap.set('n', '<c-up>', '<cmd>resize +10<CR>')
vim.keymap.set('n', '<c-down>', '<cmd>resize -10<CR>')

vim.keymap.set('n', 'g<S-c>', 'gcc', { remap = true })

vim.keymap.set('i', 'jj', '<esc>', { remap = true })

vim.keymap.set('n', '<leader>ms', '<cmd>:Markview splitToggle<CR>')
vim.keymap.set('n', '<leader>mo', '<cmd>:Markview open<CR>')

vim.keymap.set('n', '<leader>gb', '<cmd>:GitBlameToggle<CR>')

return {}
