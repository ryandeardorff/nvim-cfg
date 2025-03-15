return {
  {
    'L3MON4D3/LuaSnip',
    build = (function()
      -- Build Step is needed for regex support in snippets.
      -- This step is not supported in many windows environments.
      -- Remove the below condition to re-enable on windows.
      if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
        return
      end
      return 'make install_jsregexp'
    end)(),
    dependencies = {
      -- `friendly-snippets` contains a variety of premade snippets.
      --    See the README about individual language/framework/plugin snippets:
      --    https://github.com/rafamadriz/friendly-snippets
    },
    config = function()
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      -- Luasnip snippets for c (and cpp)
      luasnip.filetype_extend('cpp', { 'c' })
      luasnip.add_snippets('c', {
        luasnip.snippet('#guard', {
          luasnip.function_node(function(_, parent)
            local rawfn = '' .. parent.snippet.env.TM_FILENAME
            local fn = string.gsub(string.gsub(string.upper(rawfn), '%.', '_'), ' ', '_')
            return { '#ifndef ' .. fn, '#define ' .. fn, '', '#endif //' .. fn }
          end, {}),
        }),
      }, { key = 'c' })
    end,
  },
}
