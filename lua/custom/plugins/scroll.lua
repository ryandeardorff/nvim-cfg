if vim.g.neovide then
  return {}
else
  return {
    {
      'karb94/neoscroll.nvim',
      lazy = true,
      event = { 'BufNewFile', 'BufReadPre' },
      opts = {
        hide_cursor = true,
        easing = 'sine',
        duration_multiplier = 0.000001,
      },
    },
    {
      'sphamba/smear-cursor.nvim',
      opts = {
        stiffness = 0.8,
        trailing_stiffness = 0.5,
        distance_stop_animating = 0.5,
        legacy_computing_symbols_support = false,
        hide_target_hack = true,
      },
    },
  }
end
