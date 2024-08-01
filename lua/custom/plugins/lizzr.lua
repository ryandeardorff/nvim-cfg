vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.lzz',
  callback = function()
    vim.cmd 'set filetype=lizzr'
    vim.cmd 'setlocal commentstring=#\\ %s'
  end,
})
return {}
