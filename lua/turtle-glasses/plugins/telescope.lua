-- plugins/telescope.lua — telescope.nvim highlight groups.
-- Every color is read verbatim from the generated palette variant.

local M = {}

--- Build the telescope highlight groups for a palette variant.
--- @param palette table  a variant from lua/turtle-glasses/palette.lua
--- @param options table  the resolved plugin options (unused here)
function M.groups(palette, options)
  local c = palette.colors

  -- Title chips use the same fg/bg swap as the built-in CurSearch / DiffText:
  -- editor.foreground as a solid chip background with the editor background as
  -- the label color, so the title stays legible in both variants.
  local title = { fg = c["editor.background"], bg = c["editor.foreground"] }
  local normal = { fg = c["editor.foreground"], bg = c["editorHoverWidget.background"] }
  local border = { fg = c["editorHoverWidget.border"] }

  local groups = {
    -- Borders
    TelescopeBorder = vim.deepcopy(border),
    TelescopePromptBorder = vim.deepcopy(border),
    TelescopeResultsBorder = vim.deepcopy(border),
    TelescopePreviewBorder = vim.deepcopy(border),

    -- Titles
    TelescopePromptTitle = vim.deepcopy(title),
    TelescopeResultsTitle = vim.deepcopy(title),
    TelescopePreviewTitle = vim.deepcopy(title),

    -- Panes
    TelescopePromptNormal = vim.deepcopy(normal),
    TelescopeResultsNormal = vim.deepcopy(normal),
    TelescopePreviewNormal = vim.deepcopy(normal),

    -- Prompt / selection
    -- Prefix chevron follows the PmenuMatch family (suggest-widget highlight).
    TelescopePromptPrefix = { fg = c["editorSuggestWidget.highlightForeground"] },
    TelescopeSelection = { fg = c["editorSuggestWidget.selectedForeground"], bg = c["editorSuggestWidget.selectedBackground"] },
    TelescopeSelectionCaret = { fg = c["editorOverviewRuler.findMatchForeground"] },
    TelescopeMultiSelection = { fg = c["editor.foreground"], bg = c["editorSuggestWidget.selectedBackground"] },

    -- Matching / counters / diffs (git status in results)
    TelescopeMatching = { fg = c["editorOverviewRuler.findMatchForeground"] },
    TelescopePromptCounter = { fg = c["descriptionForeground"] },
    TelescopeResultsDiffAdd = { fg = c["diffEditor.insertedTextBorder"] },
    TelescopeResultsDiffChange = { fg = c["editorGutter.modifiedBackground"] },
    TelescopeResultsDiffDelete = { fg = c["diffEditor.removedTextBorder"] },
    TelescopeResultsDiffUntracked = { fg = c["gitDecoration.untrackedResourceForeground"] },
  }

  return groups
end

return M