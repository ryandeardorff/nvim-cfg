local norm_icons = { '', '', '', '󰄛' }
math.randomseed(os.time())
local mode_map = {
  ['NORMAL'] = norm_icons[math.random(#norm_icons)], --'▲⩗⩘Ν▼►▶◡◯◉',
  ['O-PENDING'] = 'N?',
  ['INSERT'] = 'I', --◌◍◠◐Ⅽⅽↄ∩⊘⊙⊝⨀⨁⨂⨭⨵⨴⨷Θοϲ
  ['VISUAL'] = 'V',
  ['V-BLOCK'] = 'VB',
  ['V-LINE'] = 'VL',
  ['V-REPLACE'] = 'VR',
  ['REPLACE'] = 'R',
  ['COMMAND'] = '!',
  ['SHELL'] = 'SH',
  ['TERMINAL'] = 'T',
  ['EX'] = 'X',
  ['S-BLOCK'] = 'SB',
  ['S-LINE'] = 'SL',
  ['SELECT'] = 'S',
  ['CONFIRM'] = 'Y?',
  ['MORE'] = 'M',
}

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup {
      options = {
        component_separators = { left = '', right = '' },
        --section_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = {
          {
            'mode',
            fmt = function(s)
              return mode_map[s] or s
            end,
            separator = { left = ' ' },
            right_padding = 2,
          },
        },
        lualine_y = {
          { 'datetime', style = '%m/%d %I:%M' },
        },
        lualine_z = {
          { 'location', separator = { right = ' ' }, left_padding = 2 },
        },
      },
    }
  end,
}
