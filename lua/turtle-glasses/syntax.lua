-- syntax.lua — legacy vim highlight groups mapped from the palette's token
-- rules (semantic name -> group). Colors and font styles are read verbatim
-- from the generated palette variant.

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

--- Build the legacy syntax highlight groups for a palette variant.
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

  local comment = tok("Comment")
  local control_keyword = tok("Control Keyword")
  local exception = tok("Exception")

  local groups = {
    -- Comments
    Comment = with_style({ fg = tfg("Comment") }, comment),
    SpecialComment = with_style({ fg = tfg("Comment") }, comment),

    -- Literals
    Constant = { fg = tfg("Constant") },
    String = { fg = tfg("String") },
    Character = { fg = tfg("Character") },
    Number = { fg = tfg("Number") },
    Boolean = { fg = tfg("Boolean") },
    Float = { fg = tfg("Float") },

    -- Identifiers / names
    Identifier = { fg = tfg("Variable") },
    Function = { fg = tfg("Function") },
    Tag = { fg = tfg("Tag - HTML/JSX/XML") },
    Label = { fg = palette.semanticTokenColors and palette.semanticTokenColors.label or c["editorLink.activeForeground"] },

    -- Statements / keywords
    Statement = { fg = tfg("Control Keyword") },
    Conditional = with_style({ fg = tfg("Control Keyword") }, control_keyword),
    Repeat = with_style({ fg = tfg("Control Keyword") }, control_keyword),
    Keyword = { fg = tfg("Control Keyword") },
    Operator = { fg = tfg("Operator") },
    Exception = with_style({ fg = tfg("Exception") }, exception),

    -- Preprocessor
    PreProc = { fg = tfg("Macro") },
    Include = { fg = tfg("Import") },
    Define = { fg = tfg("Macro") },
    Macro = { fg = tfg("Macro") },
    PreCondit = { fg = tfg("Macro") },

    -- Types
    Type = { fg = tfg("Storage - Type") },
    StorageClass = { fg = tfg("Storage - Modifier") },
    Structure = { fg = tfg("Class, Support") },
    Typedef = { fg = tfg("Class, Support") },

    -- Special / punctuation
    Special = { fg = tfg("Escape Character") },
    SpecialChar = { fg = tfg("Special Character") },
    Delimiter = { fg = tfg("Punctuation, Brace") },
    Debug = { fg = tfg("Todo") },
    Underlined = with_style({ fg = tfg("Markup - Underline") }, tok("Markup - Underline")),
    Error = { fg = tfg("Invalid") },
    Todo = { fg = tfg("Todo") },

    -- Diff legacy groups
    diffAdded = { fg = tfg("Inserted") },
    diffRemoved = { fg = tfg("Deleted") },
    diffChanged = { fg = tfg("Changed") },
  }

  return groups
end

return M