-- plugins/nvim_tree.lua — nvim-tree.lua highlight groups.
-- Colors come from the sideBar / gitDecoration / bracket palette families.
-- Every color is read verbatim from the generated palette variant.

local M = {}

--- Build the nvim-tree highlight groups for a palette variant.
--- @param palette table  a variant from lua/turtle-glasses/palette.lua
--- @param options table  the resolved plugin options (unused here)
function M.groups(palette, options)
  local c = palette.colors
  -- The window-picker chip renders dark ink on the amber chip in light (the
  -- amber glyph reads at 1.94:1 on the cream surface), like CurSearch.
  local is_light = palette.type == "light"

  local groups = {
    -- Explorer surface mirrors the VS Code side bar
    NvimTreeNormal = { fg = c["sideBar.foreground"], bg = c["sideBar.background"] },
    NvimTreeNormalNC = { fg = c["sideBar.foreground"], bg = c["sideBar.background"] },
    NvimTreeVertSplit = { fg = c["editorGroup.border"], bg = "NONE" },
    NvimTreeCursorLine = { bg = c["list.hoverBackground"] },

    -- Indentation guides
    NvimTreeIndentMarker = { fg = c["editorIndentGuide.activeBackground1"] },

    -- Folders / files
    NvimTreeRootFolder = { fg = c["editorBracketHighlight.foreground2"], bold = true },
    NvimTreeFolderIcon = { fg = c["editorBracketHighlight.foreground2"] },
    NvimTreeFolderName = { fg = c["sideBarTitle.foreground"] },
    NvimTreeOpenedFolderName = { fg = c["sideBarTitle.foreground"] },
    NvimTreeEmptyFolderName = { fg = c["descriptionForeground"] },
    NvimTreeFileIcon = { fg = c["icon.foreground"] },
    NvimTreeFileName = { fg = c["sideBar.foreground"] },
    NvimTreeSpecialFile = { fg = c["editorLink.activeForeground"] },
    NvimTreeImageFile = { fg = c["icon.foreground"] },
    NvimTreeExecFile = { fg = c["editorBracketHighlight.foreground3"] },
    NvimTreeSymlink = { fg = c["editorBracketHighlight.foreground2"] },

    -- Git status (same severity mapping as the LSP diagnostics)
    NvimTreeGitDirty = { fg = c["editorWarning.foreground"] },
    NvimTreeGitStaged = { fg = c["problemsInfoIcon.foreground"] },
    NvimTreeGitDeleted = { fg = c["editorError.foreground"] },
    NvimTreeGitMerged = { fg = c["editorBracketHighlight.foreground3"] },
    NvimTreeGitRenamed = { fg = c["editorBracketHighlight.foreground2"] },
    NvimTreeGitStash = { fg = c["editorInlayHint.parameterForeground"] },
    NvimTreeGitUntracked = { fg = c["editorGutter.addedBackground"] },

    -- Window picker overlay
    NvimTreeWindowPicker = is_light
        and { fg = c["editor.foreground"], bg = c["editorBracketHighlight.foreground4"] }
      or { fg = c["editorBracketHighlight.foreground4"], bg = c["editorBracketMatch.background"] },
  }

  return groups
end

return M