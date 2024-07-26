if vim.g.neovide then
  vim.g.neovide_scale_factor = 0.85
  vim.g.neovide_cursor_vfx_mode = 'pixiedust'
  vim.o.guifont = 'Fira_Code'
  vim.g.neovide_transparency = 0.97
  vim.g.neovide_fullscreen = true
  vim.g.neovide_cursor_vfx_particle_lifetime = 2.5

  vim.keymap.set('n', '<F11>', function()
    vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
  end)
end
return {}
