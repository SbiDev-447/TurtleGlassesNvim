-- plugins/cmp.lua — nvim-cmp highlight groups.
-- Kind colors map onto the palette's semantic token families (function,
-- keyword, variable, type, constant, operator, string). Every color is read
-- verbatim from the generated palette variant.

local M = {}

--- Find a token rule by its semantic name.
local function find_token(tokens, name)
  for _, t in ipairs(tokens) do
    if t.name == name then
      return t
    end
  end
end

--- Build the nvim-cmp highlight groups for a palette variant.
--- @param palette table  a variant from lua/turtle-glasses/palette.lua
--- @param options table  the resolved plugin options (unused here)
function M.groups(palette, options)
  local c = palette.colors
  local tfg = function(name)
    local t = find_token(palette.tokens, name)
    return t and t.settings.foreground or nil
  end

  -- Semantic kind -> token family
  local function_kinds = { "CmpItemKindMethod", "CmpItemKindFunction", "CmpItemKindConstructor" }
  local keyword_kinds = { "CmpItemKindKeyword" }
  local variable_kinds = { "CmpItemKindVariable", "CmpItemKindField", "CmpItemKindProperty" }
  local type_kinds = { "CmpItemKindClass", "CmpItemKindInterface", "CmpItemKindStruct", "CmpItemKindTypeParameter", "CmpItemKindEnum" }
  local string_kinds = { "CmpItemKindString", "CmpItemKindSnippet" }
  local plain_kinds = { "CmpItemKindText", "CmpItemKindUnit", "CmpItemKindValue", "CmpItemKindFile", "CmpItemKindReference", "CmpItemKindFolder", "CmpItemKindEvent" }

  local groups = {
    -- Abbreviations
    CmpItemAbbr = { fg = c["editor.foreground"] },
    CmpItemAbbrMatch = { fg = c["editorSuggestWidget.highlightForeground"] },
    CmpItemAbbrMatchFuzzy = { fg = c["editorOverviewRuler.findMatchForeground"] },
    CmpItemMenu = { fg = c["descriptionForeground"] },
    CmpGhostText = { fg = c["descriptionForeground"] },

    -- Composite chrome
    CmpPmenu = { link = "Pmenu" },
    CmpPmenuBorder = { link = "FloatBorder" },
    CmpPmenuSel = { link = "PmenuSel" },
    CmpDoc = { link = "NormalFloat" },
    CmpDocBorder = { link = "FloatBorder" },
  }

  -- Kind colors by semantic family
  local kind_color = {}
  for _, name in ipairs(function_kinds) do
    kind_color[name] = tfg("Function")
  end
  for _, name in ipairs(keyword_kinds) do
    kind_color[name] = tfg("Control Keyword")
  end
  for _, name in ipairs(variable_kinds) do
    kind_color[name] = tfg("Variable")
  end
  for _, name in ipairs(type_kinds) do
    kind_color[name] = tfg("Class, Support")
  end
  for _, name in ipairs(string_kinds) do
    kind_color[name] = tfg("String")
  end

  -- Kinds with a dedicated token rule
  kind_color.CmpItemKindModule = tfg("Namespace, Module")
  kind_color.CmpItemKindConstant = tfg("Constant")
  kind_color.CmpItemKindOperator = tfg("Operator")
  kind_color.CmpItemKindEnumMember = tfg("Enum Member")
  kind_color.CmpItemKindColor = tfg("Color")

  -- Remaining kinds fall back to the default foreground
  for _, name in ipairs(plain_kinds) do
    kind_color[name] = c["editor.foreground"]
  end

  for name, color in pairs(kind_color) do
    groups[name] = { fg = color }
  end

  return groups
end

return M