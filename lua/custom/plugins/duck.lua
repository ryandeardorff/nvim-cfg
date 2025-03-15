return {
  'tamton-aquib/duck.nvim',
  lazy = true,
  keys = {
    {
      '<leader>ddh',
      function()
        require('duck').hatch '🐈'
      end,
      desc = 'launch ducks* (*ducks have been patched to cats.)',
    },
    {
      '<leader>ddk',
      function()
        require('duck').cook()
      end,
      desc = 'cook last duck* (*ducks have been patched to cats.)',
    },
    {
      '<leader>dda',
      function()
        require('duck').cook_all()
      end,
      desc = 'cook all ducks* (*ducks have been patched to cats.)',
    },
  },
}
