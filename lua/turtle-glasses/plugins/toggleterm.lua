-- plugins/toggleterm.lua — toggleterm.nvim highlight groups.
-- Naming verified against akinsho/toggleterm.nvim source: each terminal id
-- derives `ToggleTerm{id}{HighlightName}` from the highlights table keys
-- (prefix in lua/toggleterm/constants.lua, defaults in config.lua). We cover
-- the float trio plus the shading-family surfaces for terminal ids 1..4, an
-- honest bounded set since ids are dynamic; more ids would need cycling
-- logic that the plugin itself does not promise.

local M = {}

--- Build the toggleterm highlight groups for a palette variant.
--- @param palette table  a variant from lua/turtle-glasses/palette.lua
--- @param options table  the resolved plugin options (unused here)
function M.groups(palette, options)
  local c = palette.colors
  local ids = { 1, 2, 3, 4 }

  local groups = {}
  for _, id in ipairs(ids) do
    local p = "ToggleTerm" .. id
    groups[p .. "Normal"] = { fg = c["terminal.foreground"], bg = c["terminal.background"] }
    groups[p .. "NormalFloat"] = { fg = c["terminal.foreground"], bg = c["terminal.background"] }
    groups[p .. "FloatBorder"] = { fg = c["terminal.border"] }
    groups[p .. "FloatTitle"] = { fg = c["terminal.foreground"], bg = c["terminal.background"] }
    groups[p .. "SignColumn"] = { bg = c["terminal.background"] }
    groups[p .. "EndOfBuffer"] = { bg = c["terminal.background"] }
  end

  return groups
end

return M