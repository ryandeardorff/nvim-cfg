vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.k',
  callback = function()
    vim.cmd 'set filetype=k'
  end,
})
return {}
