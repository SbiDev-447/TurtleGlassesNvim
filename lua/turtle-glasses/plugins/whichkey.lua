-- plugins/whichkey.lua — which-key.nvim highlight groups.
-- Key and icon colors come from the keyword token rules; the float uses the
-- hover-widget chrome. Every color is read verbatim from the generated
-- palette variant.

local M = {}

--- Find a token rule by its semantic name.
local function find_token(tokens, name)
  for _, t in ipairs(tokens) do
    if t.name == name then
      return t
    end
  end
end

--- Apply a token's fontStyle (italic / bold / underline) to a base spec.
local function with_style(base, t)
  local spec = vim.deepcopy(base)
  local fs = t and t.settings.fontStyle
  if fs then
    for part in fs:gmatch("[^, ]+") do
      spec[part] = true
    end
  end
  return spec
end

--- Build the which-key highlight groups for a palette variant.
--- @param palette table  a variant from lua/turtle-glasses/palette.lua
--- @param options table  the resolved plugin options (unused here)
function M.groups(palette, options)
  local c = palette.colors
  local control_keyword = find_token(palette.tokens, "Control Keyword")
  local storage_type = find_token(palette.tokens, "Storage - Type")
  local operator = find_token(palette.tokens, "Operator")

  local fg = function(t)
    return t and t.settings.foreground or nil
  end

  local groups = {
    -- Key names: keyword family (Control Keyword carries bold in the palette)
    WhichKey = with_style({ fg = fg(control_keyword) }, control_keyword),
    WhichKeyGroup = { fg = fg(storage_type) },
    WhichKeyDesc = { fg = c["editor.foreground"] },
    WhichKeySeparator = { fg = c["descriptionForeground"] },
    WhichKeyValue = { fg = fg(operator) },
    WhichKeyIcon = { fg = fg(control_keyword) },

    -- Float chrome (same pairing as NormalFloat / FloatBorder)
    WhichKeyFloat = { fg = c["editorHoverWidget.foreground"], bg = c["editorHoverWidget.background"] },
    WhichKeyBorder = { fg = c["editorHoverWidget.border"] },
    WhichKeyTitle = { fg = c["editor.foreground"] },
  }

  return groups
end

return M