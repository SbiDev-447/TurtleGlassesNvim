-- plugins/mini.lua — mini.nvim highlight groups (MiniIndentscope,
-- MiniStatusline). Colors come from the bracket / statusBar palette families.
-- Every color is read verbatim from the generated palette variant.

local M = {}

--- Build the mini.nvim highlight groups for a palette variant.
--- @param palette table  a variant from lua/turtle-glasses/palette.lua
--- @param options table  the resolved plugin options (unused here)
function M.groups(palette, options)
  local c = palette.colors

  local groups = {
    -- Indent scope: blue guide line matching the bracket-pair accent
    MiniIndentscopeSymbol = { fg = c["editorBracketHighlight.foreground2"] },
    MiniIndentscopePrefix = { fg = c["editorBracketHighlight.foreground2"], bg = "NONE" },
    MiniIndentscopeSymbolOff = { fg = c["editorWhitespace.foreground"] },

    -- Statusline mode chips: accent text (severity/bracket tone) on the
    -- status-bar chip, familiar from the VS Code status bar accents
    MiniStatuslineModeNormal = { fg = c["statusBar.foreground"], bg = c["statusBar.background"] },
    MiniStatuslineModeInsert = { fg = c["editorBracketHighlight.foreground2"], bg = c["statusBar.background"] },
    MiniStatuslineModeReplace = { fg = c["editorBracketHighlight.foreground4"], bg = c["statusBar.background"] },
    MiniStatuslineModeCommand = { fg = c["editorBracketHighlight.foreground3"], bg = c["statusBar.background"] },
    MiniStatuslineModeVisual = { fg = c["editorBracketHighlight.foreground5"], bg = c["statusBar.background"] },
    MiniStatuslineModeOther = { fg = c["icon.foreground"], bg = "NONE" },
    MiniStatuslineFilename = { fg = c["statusBar.foreground"] },
    MiniStatuslineFileinfo = { fg = c["descriptionForeground"] },
    MiniStatuslineDevinfo = { fg = c["descriptionForeground"] },
    MiniStatuslineInactive = { fg = c["titleBar.inactiveForeground"], bg = c["tab.inactiveBackground"] },

    -- Powerline-style separator gradients (same rationale as Lualine*Sep)
    MiniStatuslineSeparatorLeft = { fg = c["statusBar.background"], bg = "NONE" },
    MiniStatuslineSeparatorRight = { fg = c["statusBar.background"], bg = "NONE" },
  }

  return groups
end

return M