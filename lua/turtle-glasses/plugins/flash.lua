-- plugins/flash.lua — flash.nvim highlight groups.
-- Match/label accents come from the find-match / warning palette families.
-- Every color is read verbatim from the generated palette variant.

local M = {}

--- Build the flash.nvim highlight groups for a palette variant.
--- @param palette table  a variant from lua/turtle-glasses/palette.lua
--- @param options table  the resolved plugin options (unused here)
function M.groups(palette, options)
  local c = palette.colors
  -- Labels and the current match render as solid chips: dark ink on the
  -- amber/blue accent in light (same pattern as CurSearch / window picker).
  local is_light = palette.type == "light"

  local groups = {
    FlashLabel = {
      fg = is_light and c["editor.foreground"] or c["editor.background"],
      bg = c["editorWarning.foreground"],
    },
    FlashMatch = { fg = c["editorWarning.foreground"] },
    FlashCurrent = {
      fg = is_light and c["editor.foreground"] or c["editor.background"],
      bg = c["editorOverviewRuler.findMatchForeground"],
    },
    FlashBackdrop = { fg = c["descriptionForeground"] },
    FlashInductive = { fg = c["editorBracketHighlight.foreground2"] },
  }

  return groups
end

return M