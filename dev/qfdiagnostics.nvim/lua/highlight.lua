local M = {}

-- Look-up table used for sign names
local signname = {
  E = 'qf-error',
  W = 'qf-warning',
  I = 'qf-info',
  N = 'qf-note',
  [''] = 'qf-other',
}

-- Quickfix and location-lists grouped by buffer numbers
-- {
--   0: {
--     bufnr_1: [{…}, {…}, …],
--     bufnr_2: [{…}],
--   },
--   …
-- }
--- @type table<number, any> TODO: determine second type for this
local qf_items = {}

-- Boolean indicating whether signs have been placed for a quickfix and/or
-- location list
-- {
--   0: true,
--   1001: false,
-- }
local signs_added = {}

-- Boolean indicating whether text-highlighting has been added for a list
-- {
--   0: true,
--   1001: false,
-- }
--- @type table<number, boolean>
local texthl_added = {}

-- Boolean indicating whether virtual text has been added for a list
-- {
--   0: true,
--   1001: false,
-- }
--- @type table<number,boolean>
local virttext_added = {}

-- virtual-text 'align' option for each list, i.e. it is possible to have
-- different 'align' for quickfix and each location list
-- {
--   0: 'right',
--   1001: 'below',
-- }
--- @type table<number,string>
local virttext_align = {}

---Quickfix and location-list errors are placed under different sign groups so that
---signs can be toggle separately in the sign column. Quickfix errors are placed under the
---qf-0 group, and location-list errors under qf-WINID, where WINID is the window_ID of the window
---the location-list belongs to.
---@param group number
---@return string
local function sign_group(group)
  return 'qf-' .. group
end

---@param loclist boolean
---@return number
local function group_id(loclist)
  if loclist then
    if vim.fn.getwininfo(vim.fn.win_getid())[0].loclist then
      return vim.fn.getloclist(0, { filewinid = 0 }).filewinid
    else
      return vim.fn.win_getid()
    end
  end
  return 0
end

---@return table<string,number>
local function sign_priorities()
  local config = require('qfdiagnostics').config
  -- TODO: Ensure proper config defaults here
  return {
    ['E'] = config.sign_error.priority, -- default 14
    ['W'] = config.sign_warning.priority, -- default 13
    ['I'] = config.sign_info.priority, -- default 12
    ['N'] = config.sign_note.priority, -- default 11
    [''] = config.sign_other.priority, -- default 10
  }
end

---@param group number
local function signs_remove(group)
  if not signs_added[group] then
    return
  end

  vim.fn.sign_unplace(sign_group(group))
  signs_added[group] = nil
end

---@param group number
---@param type string
local function props_remove_list(group, type)
  for k, _ in qf_items[group] do
    if vim.fn.bufexists(k) then
      -- NOTE: This bit of the highlight functionality from qfdiagnostics.vim uses text props, which is not supported in neovim
      -- TODO: EXTMARK implementation
    end
  end
  -- TODO: EXTMARK implementation
end

---@param group number
local function props_remove(group)
  if not qf_items[group] then
    return
  end

  if virttext_added[group] then
    props_remove_list(group, 'virt')
    virttext_added[group] = nil
    virttext_align[group] = nil
  end

  if texthl_added[group] then
    props_remove_list(group, 'text')
    texthl_added[group] = nil
  end

  qf_items[group] = nil
  if #qf_items == 0 then
    vim.api.nvim_del_augroup_by_name 'qfdiagnostics'
  end
end

---@param xlist table<table<string,any>>
---@param group number
local function signs_add(xlist, group)
  local priorities = sign_priorities()
  local signgroup = sign_group(group)
end

---Places highlights
---@param loclist boolean
function M.place(loclist)
  local config = require('qfdiagnostics').config
  if not config.signs and not config.texthl and not config.virtttext then
    return
  end

  local group = group_id(loclist)
  ---@type table<string,any>
  local xlist = loclist and vim.fn.getloclist(0) or vim.fn.getqflist()

  -- Remove previously placed text-properties and signs
  signs_remove(group)
  props_remove(group)

  -- remove invalid quickfix items
  local tmp = {}
  for k, v in xlist do
    if not (v.lnum < 1 or not v.valid or v.bufnr < 1 or not vim.fn.bufexists(v.bufnr)) then
      tmp[k] = v
    end
  end
  xlist = tmp

  if #xlist == 0 then
    return
  end

  if config.signs then
    vim.fn.sign_define('qf-error', config.sign_error)
    vim.fn.sign_define('qf-warning', config.sign_warning)
    vim.fn.sign_define('qf-info', config.sign_info)
    vim.fn.sign_define('qf-note', config.sign_note)
    vim.fn.sign_define('qf-other', config.sign_other)
  end
end

return M
