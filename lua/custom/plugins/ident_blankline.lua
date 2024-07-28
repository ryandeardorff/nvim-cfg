-- local highlight = {
--   'CursorColumn',
--   'Whitespace',
-- }

vim.cmd 'set lcs+=space:∙'
return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  opts = {
    indent = { char = '│' },
    -- whitespace = { remove_blankline_trail = false },
    -- scope = { enabled = false },
  },
}
