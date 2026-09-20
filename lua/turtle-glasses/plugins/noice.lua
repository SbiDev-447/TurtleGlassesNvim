-- plugins/noice.lua — noice.nvim highlight groups.
-- Colors come from the hover-widget / cursor / diagnostics palette families.
-- Every color is read verbatim from the generated palette variant.

local M = {}

--- Build the noice.nvim highlight groups for a palette variant.
--- @param palette table  a variant from lua/turtle-glasses/palette.lua
--- @param options table  the resolved plugin options (unused here)
function M.groups(palette, options)
  local c = palette.colors
  local is_light = palette.type == "light"

  local groups = {
    -- Command-line area: popup surface like any other hover widget
    NoiceCmdline = { fg = c["editor.foreground"], bg = c["editor.background"] },
    NoiceCmdlinePopup = { fg = c["editorHoverWidget.foreground"], bg = c["editorHoverWidget.background"] },
    NoiceCmdlinePopupBorder = { fg = c["editorHoverWidget.border"] },
    NoiceCmdlinePopupTitle = { fg = c["editorHoverWidget.foreground"], bold = true },

    -- Command-line icons (neutral + purpose-tinted like VS Code's icons)
    NoiceCmdlineIcon = { fg = c["icon.foreground"] },
    NoiceCmdlineIconSearch = { fg = c["editorWarning.foreground"] },
    NoiceCmdlineIconBuf = { fg = c["editorBracketHighlight.foreground2"] },
    NoiceCmdlineIconDir = { fg = c["descriptionForeground"] },

    -- Cursor inside the cmdline popup (same model as the editor Cursor)
    NoiceCursor = {
      fg = is_light and c["editor.foreground"] or c["editorCursor.background"],
      bg = c["editorCursor.foreground"],
    },

    -- Confirmation / notification popups
    NoicePopup = { fg = c["editorHoverWidget.foreground"], bg = c["editorHoverWidget.background"] },
    NoicePopupBorder = { fg = c["editorHoverWidget.border"] },
    NoicePopupTitle = { fg = c["editorHoverWidget.foreground"], bold = true },
    NoiceMini = { fg = c["editor.foreground"], bg = c["editor.background"] },
  }

  return groups
end

return M