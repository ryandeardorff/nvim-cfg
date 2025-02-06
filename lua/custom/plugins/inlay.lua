-- Workaround for truncating long TypeScript inlay hints.
local methods = vim.lsp.protocol.Methods
-- TODO: Remove this if https://github.com/neovim/neovim/issues/27240 gets addressed.
local inlay_hint_handler = vim.lsp.handlers[methods.textDocument_inlayHint]
vim.lsp.handlers[methods.textDocument_inlayHint] = function(err, result, ctx, config)
  local res = inlay_hint_handler(err, result, ctx, config)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if client and client.name == 'zls' then
    result = vim.iter(result):map(function(hint)
      local label = hint.label ---@type string
      if label:len() >= 30 then
        label = label:sub(1, 29) .. '…'
      end
      hint.label = label
      return hint
    end)
  end
  return res
end

return {
  {
    'MysticalDevil/inlay-hints.nvim',
    lazy = true,
    event = { 'BufNewFile', 'BufReadPre' },
    config = function()
      require('inlay-hints').setup()
      require('lspconfig').zls.setup {
        settings = {
          zls = {
            enable_inlay_hints = true,
            inlay_hints_show_builtin = true,
            inlay_hints_exclude_single_argument = true,
            inlay_hints_hide_redundant_param_names = false,
            inlay_hints_hide_redundant_param_names_last_token = false,
          },
        },
      }
    end,
  },
}
