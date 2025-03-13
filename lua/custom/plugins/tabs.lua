vim.keymap.set('n', '<leader>c', '<cmd>BufferClose<CR>')
vim.keymap.set('n', '<leader><S-c>', '<cmd>BufferDelete!<CR>')
vim.keymap.set('n', '<leader>bn', '<cmd>BufferNext<CR>')
vim.keymap.set('n', '<leader>bb', '<cmd>BufferPrevious<CR>')
vim.keymap.set('n', '<leader>bj', '<cmd>BufferPick<CR>')
vim.keymap.set('n', '<leader>bp', '<cmd>BufferPin<CR>')
vim.keymap.set('n', '<leader>bl', '<cmd>BufferCloseBuffersLeft<CR>')
vim.keymap.set('n', '<leader>br', '<cmd>BufferCloseBuffersRight<CR>')
vim.keymap.set('n', '<leader>bi', '<cmd>BufferCloseAllButCurrentOrPinned<CR>')
vim.keymap.set('n', '<leader>bm', '<cmd>BufferMove<CR>')

local auto_hide_num = 1
if true then
  auto_hide_num = 500
end

return {
  'romgrk/barbar.nvim',
  lazy = true,
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = {
    'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
    'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
  },
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  opts = {
    -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
    -- animation = true,
    -- insert_at_start = true,
    -- …etc.
    -- sidebar_filetypes = { ['neo-tree'] = true },
    auto_hide = auto_hide_num,
    no_name_title = ' ',
    exclude_name = { ' ' },
  },
  version = '^1.0.0', -- optional: only update when a new 1.x version is released
}
