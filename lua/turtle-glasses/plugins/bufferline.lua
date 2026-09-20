-- plugins/bufferline.lua — bufferline.nvim highlight groups.
-- Colors come from the tab / editorGroupHeader / diagnostics palette families.
-- Every color is read verbatim from the generated palette variant.

local M = {}

--- Build the bufferline highlight groups for a palette variant.
--- @param palette table  a variant from lua/turtle-glasses/palette.lua
--- @param options table  the resolved plugin options (unused here)
function M.groups(palette, options)
  local c = palette.colors

  local severity_colors = {
    Error = c["editorError.foreground"],
    Warning = c["editorWarning.foreground"],
    Info = c["problemsInfoIcon.foreground"],
    Hint = c["editorInlayHint.parameterForeground"],
  }

  local groups = {
    -- Fill / tab strip surface
    BufferLineFill = { bg = c["editorGroupHeader.tabsBackground"] },
    BufferLineBackground = { fg = c["tab.inactiveForeground"], bg = c["tab.inactiveBackground"] },
    BufferLineBuffer = { fg = c["tab.inactiveForeground"], bg = c["tab.inactiveBackground"] },
    BufferLineBufferVisible = { fg = c["tab.hoverForeground"], bg = c["tab.hoverBackground"] },
    BufferLineBufferSelected = { fg = c["tab.activeForeground"], bg = c["tab.activeBackground"] },

    -- Modified dot / marker
    BufferLineModified = { fg = c["editorGutter.modifiedBackground"] },
    BufferLineModifiedVisible = { fg = c["editorGutter.modifiedBackground"] },
    BufferLineModifiedSelected = { fg = c["editorOverviewRuler.modifiedForeground"] },

    -- Duplicate buffers
    BufferLineDuplicate = { fg = c["descriptionForeground"], bg = c["tab.inactiveBackground"] },
    BufferLineDuplicateVisible = { fg = c["descriptionForeground"], bg = c["tab.hoverBackground"] },
    BufferLineDuplicateSelected = { fg = c["descriptionForeground"], bg = c["tab.activeBackground"] },

    -- Separators (gradient between neighbouring tab surfaces)
    BufferLineSeparator = { fg = c["tab.border"], bg = c["tab.inactiveBackground"] },
    BufferLineSeparatorVisible = { fg = c["tab.border"], bg = c["tab.hoverBackground"] },
    BufferLineSeparatorSelected = { fg = c["tab.activeBorder"], bg = c["tab.activeBackground"] },

    -- Active indicator (top accent)
    BufferLineIndicatorSelected = { fg = c["tab.activeBorderTop"] },
    BufferLineIndicatorVisible = { fg = c["tab.unfocusedActiveBorderTop"] },
    BufferLineIndicator = { fg = c["tab.unfocusedActiveBorderTop"] },
  }

  -- Per-severity diagnostics: plain, visible and selected variants share the
  -- severity color; bufferline renders the glyph itself. The unqualified
  -- BufferLineDiagnostic family is bufferline's default hint-tinted marker.
  for severity, color in pairs(severity_colors) do
    for _, state in ipairs({ "", "Visible", "Selected" }) do
      groups["BufferLine" .. severity .. state] = { fg = color }
      groups["BufferLine" .. severity .. "Diagnostic" .. state] = { fg = color }
      groups["BufferLineDiagnostic" .. state] = { fg = severity_colors.Hint }
    end
  end

  return groups
end

return M