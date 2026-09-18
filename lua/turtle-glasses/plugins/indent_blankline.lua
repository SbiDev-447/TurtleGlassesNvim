-- plugins/indent_blankline.lua — indent-blankline.nvim (v3) highlight groups.
-- Colors come from the editorIndentGuide palette families: the idle guide
-- color for indents, the active guide color for scope highlights.
-- Every color is read verbatim from the generated palette variant.

local M = {}

--- Build the indent-blankline highlight groups for a palette variant.
--- @param palette table  a variant from lua/turtle-glasses/palette.lua
--- @param options table  the resolved plugin options (unused here)
function M.groups(palette, options)
  local c = palette.colors

  local indent = c["editorIndentGuide.background1"]
  local scope = c["editorIndentGuide.activeBackground1"]

  local groups = {
    IblIndent = { fg = indent },
    IblScope = { fg = scope },
    IblWhitespace = { fg = c["editorWhitespace.foreground"] },
    IblScopeChar = { fg = scope },
    IblIndentChar = { fg = indent },
  }

  return groups
end

return M