return {
  {
    'ranjithshegde/ccls.nvim',
    config = {
      lsp = {
        codelens = { enable = true, events = { 'BufWritePost', 'InsertLeave' } },
        use_defaults = true,
      },
    },
  },
}
