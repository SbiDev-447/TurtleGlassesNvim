-- plugins/neo_tree.lua — neo-tree.nvim highlight groups.
-- Colors come from the sideBar / tab / gitDecoration palette families.
-- Every color is read verbatim from the generated palette variant.

local M = {}

--- Build the neo-tree highlight groups for a palette variant.
--- @param palette table  a variant from lua/turtle-glasses/palette.lua
--- @param options table  the resolved plugin options (unused here)
function M.groups(palette, options)
  local c = palette.colors

  local groups = {
    -- Explorer surface mirrors the VS Code side bar
    NeoTreeNormal = { fg = c["sideBar.foreground"], bg = c["sideBar.background"] },
    NeoTreeNormalNC = { fg = c["sideBar.foreground"], bg = c["sideBar.background"] },
    NeoTreeCursorLine = { bg = c["list.focusBackground"] },
    NeoTreeWinSeparator = { fg = c["editorGroup.border"], bg = "NONE" },

    -- Indentation guides / expanders
    NeoTreeIndentMarker = { fg = c["editorIndentGuide.activeBackground1"] },
    NeoTreeExpander = { fg = c["editorIndentGuide.activeBackground1"] },

    -- Folders / files
    NeoTreeRootName = { fg = c["editorBracketHighlight.foreground2"], bold = true },
    NeoTreeFolderName = { fg = c["sideBarTitle.foreground"] },
    NeoTreeFolderIcon = { fg = c["editorBracketHighlight.foreground2"] },
    NeoTreeFileIcon = { fg = c["icon.foreground"] },
    NeoTreeFileName = { fg = c["sideBar.foreground"] },
    NeoTreeFileNameOpened = { fg = c["editorBracketHighlight.foreground2"] },
    NeoTreeFileNameModified = { fg = c["editorWarning.foreground"] },
    NeoTreeDotfile = { fg = c["descriptionForeground"] },
    NeoTreeDimText = { fg = c["descriptionForeground"] },
    NeoTreeSymbolicLinkTarget = { fg = c["editorBracketHighlight.foreground2"] },

    -- Git status (same severity mapping as the LSP diagnostics)
    NeoTreeGitAdded = { fg = c["editorGutter.addedBackground"] },
    NeoTreeGitDeleted = { fg = c["editorError.foreground"] },
    NeoTreeGitModified = { fg = c["editorWarning.foreground"] },
    NeoTreeGitConflict = { fg = c["editorBracketHighlight.unexpectedBracket.foreground"] },
    NeoTreeGitUnstaged = { fg = c["editorOverviewRuler.modifiedForeground"] },
    NeoTreeGitStaged = { fg = c["problemsInfoIcon.foreground"] },

    -- Tabs (neo-tree renderer)
    NeoTreeTabActive = { fg = c["tab.activeForeground"], bg = c["tab.activeBackground"] },
    NeoTreeTabInactive = { fg = c["tab.inactiveForeground"], bg = c["tab.inactiveBackground"] },
    NeoTreeTabSeparatorActive = { fg = c["tab.activeBorder"], bg = c["tab.activeBackground"] },
    NeoTreeTabSeparatorInactive = { fg = c["tab.border"], bg = c["tab.inactiveBackground"] },

    -- Float windows
    NeoTreeFloatBorder = { fg = c["editorHoverWidget.border"] },
    NeoTreeFloatTitle = { fg = c["editorHoverWidget.foreground"] },
    NeoTreeTitleBar = { fg = c["tab.activeForeground"], bg = c["tab.activeBackground"] },
  }

  return groups
end

return M