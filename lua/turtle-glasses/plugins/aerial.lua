-- plugins/aerial.lua — aerial.nvim highlight groups (outline window).
-- Group names verified against stevearc/aerial.nvim source (lua/aerial/
-- highlight.lua, render.lua). Kind icons use the symbolIcon palette family;
-- every color is read verbatim from the generated palette variant.

local M = {}

--- Build the aerial highlight groups for a palette variant.
--- @param palette table  a variant from lua/turtle-glasses/palette.lua
--- @param options table  the resolved plugin options (unused here)
function M.groups(palette, options)
  local c = palette.colors

  -- Kind-icon colors: symbol kinds map onto the VS Code symbolIcon palette.
  local kind_colors = {
    Array = "icon.foreground",
    Class = "symbolIcon.classForeground",
    Constructor = "symbolIcon.constructorForeground",
    Enum = "symbolIcon.enumeratorForeground",
    EnumMember = "symbolIcon.enumeratorForeground",
    Field = "symbolIcon.fieldForeground",
    Function = "symbolIcon.functionForeground",
    Interface = "symbolIcon.interfaceForeground",
    Key = "symbolIcon.keywordForeground",
    Method = "symbolIcon.methodForeground",
    Module = "symbolIcon.moduleForeground",
    Namespace = "symbolIcon.namespaceForeground",
    Object = "icon.foreground",
    Property = "symbolIcon.propertyForeground",
    String = "symbolIcon.stringForeground",
    Struct = "symbolIcon.classForeground",
    TypeParameter = "symbolIcon.propertyForeground",
    Variable = "symbolIcon.variableForeground",
  }

  local groups = {
    -- Window surface
    AerialNormal = { fg = c["editor.foreground"], bg = c["editor.background"] },
    AerialNormalFloat = { fg = c["editor.foreground"], bg = c["editor.background"] },

    -- Selected / inactive line highlight (list selection family)
    AerialLine = { fg = c["list.activeSelectionForeground"], bg = c["list.activeSelectionBackground"] },
    AerialLineNC = { fg = c["list.inactiveSelectionForeground"], bg = c["list.inactiveSelectionBackground"] },

    -- Guide lines and access-modifier labels
    AerialGuide = { fg = c["editorIndentGuide.background"] },
    AerialPrivate = { fg = c["descriptionForeground"] },
    AerialProtected = { fg = c["descriptionForeground"] },
  }

  for kind, key in pairs(kind_colors) do
    groups["Aerial" .. kind .. "Icon"] = { fg = c[key] }
  end

  -- Remaining kinds keep the neutral icon tone
  for _, kind in ipairs({
    "Boolean", "Constant", "Event", "File", "Null", "Number", "Operator", "Package",
  }) do
    groups["Aerial" .. kind .. "Icon"] = { fg = c["icon.foreground"] }
  end

  return groups
end

return M