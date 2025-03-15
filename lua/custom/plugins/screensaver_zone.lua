return {
  'tamton-aquib/zone.nvim',
  opts = {
    style = 'treadmill',
    after = 10000000000000, -- Idle timeout
    exclude_filetypes = { 'TelescopePrompt', 'NvimTree', 'neo-tree', 'dashboard', 'lazy' },
    -- More options to come later

    treadmill = {
      direction = 'left',
      headache = true,
      tick_time = 20, -- Lower, the faster
      -- Opts for Treadmill style
    },
    epilepsy = {
      stage = 'aura', -- "aura" or "ictal"
      tick_time = 100,
    },
    dvd = {
      -- text = {"line1", "line2", "line3", "etc"}
      tick_time = 100,
      -- Opts for Dvd style
    },
    -- etc
  },
  lazy = true,
  keys = {
    { '<leader>dz', '<cmd>Zone<cr>', desc = 'zone screensaver' },
  },
}
