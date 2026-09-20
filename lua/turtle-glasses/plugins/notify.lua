-- plugins/notify.lua — nvim-notify highlight groups.
-- Per-severity icon/border/title colors map to the LSP severity palette
-- families; the body surface matches the hover-widget surface used by every
-- other floating window in the theme.

local M = {}

--- Build the nvim-notify highlight groups for a palette variant.
--- @param palette table  a variant from lua/turtle-glasses/palette.lua
--- @param options table  the resolved plugin options (unused here)
function M.groups(palette, options)
  local c = palette.colors

  local severity = {
    ERROR = c["editorError.foreground"],
    WARN = c["editorWarning.foreground"],
    INFO = c["problemsInfoIcon.foreground"],
    DEBUG = c["icon.foreground"],
    TRACE = c["editorBracketHighlight.foreground6"],
  }

  local groups = {
    NotifyBackground = { bg = c["editorHoverWidget.background"] },
  }

  for level, color in pairs(severity) do
    groups["Notify" .. level .. "Border"] = { fg = color }
    groups["Notify" .. level .. "Icon"] = { fg = color }
    groups["Notify" .. level .. "Title"] = { fg = color, bold = true }
    groups["Notify" .. level .. "Body"] = { fg = c["editorHoverWidget.foreground"], bg = "NONE" }
  end

  return groups
end

return M