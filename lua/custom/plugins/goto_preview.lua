vim.keymap.set('n', 'gpd', "<cmd>lua require('goto-preview').goto_preview_definition()<CR>")
vim.keymap.set('n', 'gpt', "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>")
vim.keymap.set('n', 'gpi', "<cmd>lua require('goto-preview').goto_preview_implementaiton()<CR>")
vim.keymap.set('n', 'gpD', "<cmd>lua require('goto-preview').goto_preview_declaration()<CR>")
vim.keymap.set('n', 'gpr', "<cmd>lua require('goto-preview').goto_preview_references()<CR>")
vim.keymap.set('n', 'gpc', "<cmd>lua require('goto-preview').close_all_win()<CR>")

return {
  'rmagatti/goto-preview',
  lazy = true,
  event = 'BufEnter',
  config = true, -- necessary as per https://github.com/rmagatti/goto-preview/issues/88
}
