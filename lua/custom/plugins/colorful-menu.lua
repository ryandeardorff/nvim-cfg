if false then
  return {}
else
  return {
    'xzbdmw/colorful-menu.nvim',
    lazy = true,
    event = 'InsertEnter',
    config = function()
      -- You don't need to set these options.
      require('colorful-menu').setup {
        ls = {
          lua_ls = {
            -- Maybe you want to dim arguments a bit.
            arguments_hl = '@comment',
          },
          gopls = {
            -- By default, we render variable/function's type in the right most side,
            -- to make them not to crowd together with the original label.

            -- when true:
            -- foo             *Foo
            -- ast         "go/ast"

            -- when false:
            -- foo *Foo
            -- ast "go/ast"
            align_type_to_right = true,
            -- When true, label for field and variable will format like "foo: Foo"
            -- instead of go's original syntax "foo Foo". If align_type_to_right is
            -- true, this option has no effect.
            add_colon_before_type = false,
          },
          -- for lsp_config or typescript-tools
          ts_ls = {
            extra_info_hl = '@comment',
          },
          vtsls = {
            extra_info_hl = '@comment',
          },
          ['rust-analyzer'] = {
            -- Such as (as Iterator), (use std::io).
            extra_info_hl = '@comment',
            -- Similar to the same setting of gopls.
            align_type_to_right = true,
          },
          clangd = {
            -- Such as "From <stdio.h>".
            extra_info_hl = '@comment',
            -- Similar to the same setting of gopls.
            align_type_to_right = true,
            -- the hl group of leading dot of "•std::filesystem::permissions(..)"
            import_dot_hl = '@comment',
          },
          zls = {
            -- Similar to the same setting of gopls.
            align_type_to_right = true,
          },
          roslyn = {
            extra_info_hl = '@comment',
          },
          -- The same applies to pyright/pylance
          basedpyright = {
            -- It is usually import path such as "os"
            extra_info_hl = '@comment',
          },

          -- If true, try to highlight "not supported" languages.
          fallback = true,
        },
        -- If the built-in logic fails to find a suitable highlight group,
        -- this highlight is applied to the label.
        fallback_highlight = '@variable',
        -- If provided, the plugin truncates the final displayed text to
        -- this width (measured in display cells). Any highlights that extend
        -- beyond the truncation point are ignored. When set to a float
        -- between 0 and 1, it'll be treated as percentage of the width of
        -- the window: math.floor(max_width * vim.api.nvim_win_get_width(0))
        -- Default 60.
        max_width = 60,
      }
      -- require('cmp').setup {
      --   formatting = {
      --     -- kind is icon, abbr is completion name, menu is [Function]
      --     fields = { 'abbr', 'kind', 'menu' },
      --     format = function(entry, vim_item)
      --       local kind = require('lspkind').cmp_format {
      --         mode = 'symbol_text',
      --         symbol_map = { codium = '' },
      --       }(entry, vim.deepcopy(vim_item))
      --
      --       local highlights_info = require('colorful-menu').cmp_highlights(entry)
      --
      --       -- highlight_info is nil means we are missing the ts parser, it's
      --       -- better to fallback to use default `vim_item.abbr`. What this plugin
      --       -- offers is two fields: `vim_item.abbr_hl_group` and `vim_item.abbr`.
      --       if highlights_info ~= nil then
      --         vim_item.abbr_hl_group = highlights_info.highlights
      --         vim_item.abbr = highlights_info.text
      --       end
      --
      --       -- This is optional, you can omit if you don't use lspkind.
      --       local strings = vim.split(kind.kind, '%s', { trimempty = true })
      --       vim_item.kind = ' ' .. (strings[1] or '') .. ' '
      --       vim_item.menu = ''
      --
      --       return vim_item
      --     end,
      --   },
      -- }
    end,
  }
end
