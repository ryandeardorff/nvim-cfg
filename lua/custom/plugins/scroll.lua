if vim.g.neovide then
  return {}
else
  return {
    'karb94/neoscroll.nvim',
    lazy = true,
    event = { 'BufNewFile', 'BufReadPre' },
    opts = {
      hide_cursor = false,
      easing = 'quadratic',
      duration_multiplier = 0.1,
    },
  }
end
