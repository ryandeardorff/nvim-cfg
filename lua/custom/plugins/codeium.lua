-- AI stuff, mostly for more useful plaintext autocomplete
return {
  {
    'Exafunction/codeium.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'hrsh7th/nvim-cmp',
    },
    config = function()
      require('codeium').setup {
        -- virtual_text = {
        --   enabled = true,
        -- },
      }
    end,
  },
}
