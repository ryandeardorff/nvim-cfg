vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  callback = function()
    local diags = vim.diagnostic.fromqflist(vim.fn.getqflist())
    if #diags == 0 then
      vim.cmd [[Trouble qflist close]]
    else
      vim.cmd [[Trouble qflist open]]
    end
  end,
})
return {
  'folke/trouble.nvim',
  cmd = 'Trouble',
  opts = {
    auto_open = false,
    {
      modes = {
        diag = {
          mode = 'diagnostics',
          preview = {
            type = 'split',
            relative = 'win',
            position = 'right',
            size = 0.3,
          },
        },
      },
    },
  },
  -- config = function()
  --   require('trouble').setup {
  --     -- Configure options here (e.g., focus, follow, etc.)
  --   }
  -- end,
}
