-- Highlights overused words.
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'text', 'tex' },
  callback = function(opts)
    vim.cmd 'DittoOn'
  end,
})
return {
  { 'dbmrq/vim-ditto' },
}
