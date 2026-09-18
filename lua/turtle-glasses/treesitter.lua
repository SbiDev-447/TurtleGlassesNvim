-- treesitter.lua — treesitter @groups built from the palette tokens, linking
-- to the legacy syntax groups wherever one already expresses the same intent.

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

--- Build the treesitter highlight groups for a palette variant.
--- @param palette table  a variant from lua/turtle-glasses/palette.lua
function M.groups(palette)
  local c = palette.colors
  local tok = function(name)
    return find_token(palette.tokens, name)
  end
  local tfg = function(name)
    local t = tok(name)
    return t and t.settings.foreground or nil
  end

  local st = palette.semanticTokenColors or {}
  local control_keyword = tok("Control Keyword")
  local exception = tok("Exception")

  local groups = {
    -- Comments
    ["@comment"] = { link = "Comment" },
    ["@comment.documentation"] = { link = "Comment" },

    -- Errors
    ["@error"] = { fg = tfg("Invalid") },
    ["@exception"] = { link = "@keyword.exception" },

    -- Constants
    ["@constant"] = { link = "Constant" },
    ["@constant.builtin"] = { link = "Constant" },
    ["@constant.macro"] = { fg = tfg("Macro") },

    -- Strings / chars
    ["@string"] = { link = "String" },
    ["@string.escape"] = { fg = tfg("Escape Character") },
    ["@string.special"] = { fg = tfg("Special Character") },
    ["@character"] = { link = "Character" },
    ["@number"] = { link = "Number" },
    ["@boolean"] = { link = "Boolean" },
    ["@float"] = { link = "Float" },

    -- Functions / methods / constructors
    ["@function"] = { link = "Function" },
    ["@function.builtin"] = { fg = tfg("Special Method") },
    ["@function.macro"] = { link = "Macro" },
    ["@function.call"] = { link = "Function" },
    ["@function.method"] = { link = "Function" },
    ["@function.method.call"] = { link = "Function" },
    ["@method"] = { link = "Function" },
    ["@method.call"] = { link = "Function" },
    ["@constructor"] = { link = "Type" },

    -- Variables / parameters / properties
    ["@variable"] = { link = "Identifier" },
    ["@variable.builtin"] = { fg = tfg("Language Method") },
    ["@variable.parameter"] = { fg = st["parameter.declaration"] or c["editor.foreground"] },
    ["@parameter"] = { fg = st.parameter or c["editor.foreground"] },
    ["@property"] = { fg = tfg("Property") },
    ["@field"] = { fg = tfg("Property") },

    -- Types / namespaces
    ["@type"] = { link = "Type" },
    ["@type.builtin"] = { link = "Type" },
    ["@type.definition"] = { link = "Type" },
    ["@namespace"] = { fg = tfg("Namespace, Module") },
    ["@module"] = { fg = tfg("Namespace, Module") },

    -- Keywords
    ["@keyword"] = { link = "Keyword" },
    -- Keyword that introduces a function declaration: function color family
    -- (no dedicated token rule exists for it in the palette).
    ["@keyword.function"] = { fg = tfg("Function") },
    ["@keyword.return"] = with_style({ fg = tfg("Control Keyword") }, control_keyword),
    ["@keyword.operator"] = { fg = tfg("Operator") },
    ["@keyword.conditional"] = with_style({ fg = tfg("Control Keyword") }, control_keyword),
    ["@keyword.repeat"] = with_style({ fg = tfg("Control Keyword") }, control_keyword),
    ["@keyword.exception"] = with_style({ fg = tfg("Exception") }, exception),
    ["@keyword.import"] = { fg = tfg("Import") },
    ["@keyword.type"] = { link = "Type" },

    -- Operators / punctuation
    ["@operator"] = { fg = tfg("Operator") },
    ["@punctuation.delimiter"] = { link = "Delimiter" },
    ["@punctuation.bracket"] = { link = "Delimiter" },
    ["@punctuation.special"] = { link = "Delimiter" },

    -- Labels / includes / attributes
    ["@label"] = { fg = st.label or c["editorLink.activeForeground"] },
    ["@include"] = { fg = tfg("Import") },
    ["@attribute"] = { fg = tfg("Attribute Name") },
    ["@macro"] = { link = "Macro" },
    ["@preproc"] = { fg = tfg("Macro") },

    -- Tags
    ["@tag"] = { fg = tfg("Tag - HTML/JSX/XML") },
    ["@tag.attribute"] = { fg = tfg("Attribute Name") },
    ["@tag.delimiter"] = { fg = tfg("Tag - Closing and punctuation") },
  }

  return groups
end

return M