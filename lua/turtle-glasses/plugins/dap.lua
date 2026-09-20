-- plugins/dap.lua — nvim-dap-ui highlight groups.
-- Colors come from the editorGutter / diagnostics / bracket palette families.
-- Every color is read verbatim from the generated palette variant.

local M = {}

--- Build the nvim-dap-ui highlight groups for a palette variant.
--- @param palette table  a variant from lua/turtle-glasses/palette.lua
--- @param options table  the resolved plugin options (unused here)
function M.groups(palette, options)
  local c = palette.colors

  local groups = {
    -- Gutter breakpoint markers
    DapBreakpoint = { fg = c["editorError.foreground"] },
    DapBreakpointCondition = { fg = c["editorWarning.foreground"] },
    DapBreakpointRejected = { fg = c["editorBracketHighlight.unexpectedBracket.foreground"] },
    DapLogPoint = { fg = c["problemsInfoIcon.foreground"] },
    DapStopped = { fg = c["editorGutter.addedBackground"] },

    -- DAP UI tree / values
    DapUIVariable = { fg = c["editor.foreground"] },
    DapUIValue = { fg = c["editorBracketHighlight.foreground3"] },
    DapUIScope = { fg = c["editorBracketHighlight.foreground2"] },
    DapUIType = { fg = c["editorBracketHighlight.foreground2"] },
    DapUIDecoration = { fg = c["descriptionForeground"] },
    DapUIThread = { fg = c["editorBracketHighlight.foreground2"] },
    DapUIStoppedThread = { fg = c["editorGutter.addedBackground"], bold = true },
    DapUISource = { fg = c["editorLink.activeForeground"] },
    DapUIModifiedValue = { fg = c["editorWarning.foreground"] },
    DapUIFloatBorder = { fg = c["editorHoverWidget.border"] },

    -- Watches / breakpoints panels
    DapUIWatchesEmpty = { fg = c["descriptionForeground"] },
    DapUIWatchesValue = { fg = c["editorBracketHighlight.foreground3"] },
    DapUIWatchesError = { fg = c["editorError.foreground"] },
    DapUIBreakpointsPath = { fg = c["editorLink.activeForeground"] },
    DapUIBreakpointsCurrentLine = { fg = c["editorBracketHighlight.foreground4"], bold = true },
    DapUIBreakpointsInfo = { fg = c["problemsInfoIcon.foreground"] },
    DapUIWinSelect = { fg = c["editorBracketHighlight.foreground4"] },
  }

  return groups
end

return M