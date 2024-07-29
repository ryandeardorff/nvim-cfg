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
        mydiags = {
          mode = 'diagnostics', -- inherit from diagnostics mode
          filter = {
            any = {
              buf = 0, -- current buffer
              {
                severity = vim.diagnostic.severity.ERROR, -- errors only
                -- limit to files in the current project
                function(item)
                  return item.filename:find((vim.loop or vim.uv).cwd(), 1, true)
                end,
              },
            },
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
