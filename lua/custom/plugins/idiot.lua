return {
  'GitMarkedDan/you-are-an-idiot.nvim',
  lazy = true,
  -- Add your own custom configuration here:
  -- opts = { }
  keys = {
    {
      '<leader>dir',
      function()
        require('you-are-an-idiot').run { flash_interval = 0.5, text = { '', '👻' } }
      end,
      desc = 'Launch idiots',
    },
    {
      '<leader>dik',
      function()
        require('you-are-an-idiot').abort()
      end,
      desc = 'Kill idiots',
    },
  },
}
