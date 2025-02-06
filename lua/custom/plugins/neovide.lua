if vim.g.neovide then
  vim.g.neovide_scale_factor = 0.85
  vim.g.neovide_cursor_vfx_mode = 'pixiedust'
  -- vim.o.guifont = 'JetBrainsMono_Nerd_Font_Mono'
  vim.o.guifont = 'FiraCode_Nerd_Font_Mono'
  -- vim.o.guifont = 'Hack_Nerd_Font_Mono'
  -- vim.o.guifont = 'UbuntuMono_Nerd_Font_Mono:h16'
  -- vim.o.guifont = 'Lilex_Nerd_Font_Mono:h13.5'
  vim.g.neovide_transparency = 0.97
  vim.g.neovide_fullscreen = true
  vim.g.neovide_cursor_vfx_particle_lifetime = 2.5
  vim.g.neovide_cursor_vfx_particle_density = 20.0
  vim.g.neovide_floating_corner_radius = 10.0
  vim.g.neovide_scroll_animation_length = 0.2

  vim.keymap.set('n', '<F11>', function()
    vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
  end)
  vim.keymap.set('n', '<C-=>', function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.05
  end)
  vim.keymap.set('n', '<C-->', function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.05
  end)
end
return {}
