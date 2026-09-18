-- plugins/gitsigns.lua — gitsigns.nvim highlight groups.
-- Colors come from the editorGutter / gitDecoration palette families.
-- Every color is read verbatim from the generated palette variant.

local M = {}

--- Build the gitsigns highlight groups for a palette variant.
--- @param palette table  a variant from lua/turtle-glasses/palette.lua
--- @param options table  the resolved plugin options (unused here)
function M.groups(palette, options)
  local c = palette.colors

  local add = c["editorGutter.addedBackground"]
  local change = c["editorGutter.modifiedBackground"]
  local delete = c["editorGutter.deletedBackground"]

  local groups = {
    GitSignsAdd = { fg = add },
    GitSignsChange = { fg = change },
    GitSignsDelete = { fg = delete },
    GitSignsTopDelete = { fg = delete },

    -- Line-level signs share their column-level color
    GitSignsAddLn = { fg = add },
    GitSignsChangeLn = { fg = change },
    GitSignsDeleteLn = { fg = delete },

    GitSignsUntracked = { fg = c["gitDecoration.untrackedResourceForeground"] },

    -- Blame text: dimmed like VS Code's code-lens foreground
    GitSignsCurrentLineBlame = { fg = c["descriptionForeground"] },

    -- Number-column variants (bright — same color by default)
    GitSignsAddNr = { fg = add },
    GitSignsChangeNr = { fg = change },
    GitSignsDeleteNr = { fg = delete },
  }

  return groups
end

return M