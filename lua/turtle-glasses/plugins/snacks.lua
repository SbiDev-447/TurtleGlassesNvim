-- plugins/snacks.lua — snacks.nvim highlight groups (win, notifier, dashboard,
-- terminal, statuscolumn, indent, input, picker/lists).
-- Group names verified against folke/snacks.nvim source (lua/snacks/*.lua).
-- Colors come from the notification / titleBar / input / quickInput / list /
-- gitDecoration / indent guide palette families, verbatim from the palette.

local M = {}

--- Build the snacks.nvim highlight groups for a palette variant.
--- @param palette table  a variant from lua/turtle-glasses/palette.lua
--- @param options table  the resolved plugin options (unused here)
function M.groups(palette, options)
  local c = palette.colors

  -- Notifier severity tones (same mapping as the bufferline diagnostics).
  local severity = {
    Error = c["editorError.foreground"],
    Warn = c["editorWarning.foreground"],
    Info = c["problemsInfoIcon.foreground"],
    Debug = c["editorBracketHighlight.foreground2"],
    Trace = c["descriptionForeground"],
  }

  local groups = {
    -- Shared window surface (float borders, winbars, titles, footers)
    SnacksNormal = { fg = c["editor.foreground"], bg = c["editor.background"] },
    SnacksNormalNC = { fg = c["editor.foreground"], bg = c["editor.background"] },
    SnacksWinBar = { fg = c["titleBar.activeForeground"], bg = c["titleBar.activeBackground"] },
    SnacksWinBarNC = { fg = c["titleBar.inactiveForeground"], bg = c["titleBar.activeBackground"] },
    SnacksWinSeparator = { fg = c["titleBar.inactiveBackground"] },
    SnacksWinKey = { fg = c["editorBracketHighlight.foreground2"] },
    SnacksWinKeySep = { fg = c["descriptionForeground"] },
    SnacksWinKeyDesc = { fg = c["descriptionForeground"] },
    SnacksTitle = { fg = c["titleBar.activeForeground"] },
    SnacksFooter = { fg = c["descriptionForeground"] },
    SnacksFooterKey = { fg = c["editorBracketHighlight.foreground2"] },
    SnacksFooterDesc = { fg = c["descriptionForeground"] },

    -- Notifier: base surface, history and minimal-style message
    SnacksNotifier = { fg = c["notifications.foreground"], bg = c["notifications.background"] },
    SnacksNotifierHistory = { fg = c["notifications.foreground"], bg = c["notifications.background"] },
    SnacksNotifierMinimal = { fg = c["notifications.foreground"] },
    SnacksNotifierBorder = { fg = c["notificationCenter.border"] },
    SnacksNotifierTitle = { fg = c["notifications.foreground"] },
    SnacksNotifierIcon = { fg = c["icon.foreground"] },
    SnacksNotifierMsg = { fg = c["notifications.foreground"] },
    SnacksNotifierFooter = { fg = c["descriptionForeground"] },

    -- Dashboard: keys, icons, recent files and the normal/terminal surface
    SnacksDashboardNormal = { fg = c["editor.foreground"], bg = c["editor.background"] },
    SnacksDashboardTerminal = { fg = c["editor.foreground"], bg = c["editor.background"] },
    SnacksDashboardHeader = { fg = c["titleBar.activeForeground"] },
    SnacksDashboardFooter = { fg = c["descriptionForeground"] },
    SnacksDashboardTitle = { fg = c["titleBar.activeForeground"] },
    SnacksDashboardIcon = { fg = c["icon.foreground"] },
    SnacksDashboardKey = { fg = c["editorBracketHighlight.foreground2"] },
    SnacksDashboardDesc = { fg = c["editor.foreground"] },
    SnacksDashboardFile = { fg = c["editor.foreground"] },
    SnacksDashboardDir = { fg = c["descriptionForeground"] },
    SnacksDashboardSpecial = { fg = c["editorBracketHighlight.foreground2"] },

    -- Statuscolumn: mark glyphs (diagnostic hints), base numerals
    SnacksStatusColumn = { fg = c["editorLineNumber.foreground"] },
    SnacksStatusColumnMark = { fg = c["editorInlayHint.parameterForeground"] },

    -- Indent guides: uniform dim strokes; scope/chunk get the bracket accent
    SnacksIndent = { fg = c["editorIndentGuide.background"] },
    SnacksIndent1 = { fg = c["editorIndentGuide.background"] },
    SnacksIndent2 = { fg = c["editorIndentGuide.background"] },
    SnacksIndent3 = { fg = c["editorIndentGuide.background"] },
    SnacksIndent4 = { fg = c["editorIndentGuide.background"] },
    SnacksIndent5 = { fg = c["editorIndentGuide.background"] },
    SnacksIndent6 = { fg = c["editorIndentGuide.background"] },
    SnacksIndent7 = { fg = c["editorIndentGuide.background"] },
    SnacksIndent8 = { fg = c["editorIndentGuide.background"] },
    SnacksIndentChunk = { fg = c["editorIndentGuide.background"] },
    SnacksIndentScope = { fg = c["editorBracketHighlight.foreground2"] },
    SnacksIndentUnderline = { fg = c["editorBracketHighlight.foreground2"] },

    -- Input: prompt surface (border + title + icon)
    SnacksInput = { fg = c["input.foreground"], bg = c["input.background"] },
    SnacksInputNormal = { fg = c["input.foreground"], bg = c["input.background"] },
    SnacksInputBorder = { fg = c["input.border"] },
    SnacksInputTitle = { fg = c["input.foreground"] },
    SnacksInputIcon = { fg = c["icon.foreground"] },

    -- Picker: shared chrome and the common row content
    SnacksPicker = { fg = c["quickInput.foreground"], bg = c["quickInput.background"] },
    SnacksPickerFile = { fg = c["quickInput.foreground"] },
    SnacksPickerDir = { fg = c["descriptionForeground"] },
    SnacksPickerIcon = { fg = c["icon.foreground"] },
    SnacksPickerDesc = { fg = c["quickInput.foreground"] },
    SnacksPickerLabel = { fg = c["quickInput.foreground"] },
    SnacksPickerBold = { fg = c["quickInput.foreground"] },
    SnacksPickerComment = { fg = c["descriptionForeground"] },
    SnacksPickerSpecial = { fg = c["editorBracketHighlight.foreground2"] },
    SnacksPickerDelim = { fg = c["descriptionForeground"] },
    SnacksPickerRow = { fg = c["quickInput.foreground"] },
    SnacksPickerCol = { fg = c["quickInput.foreground"] },
    SnacksPickerIdx = { fg = c["quickInput.foreground"] },
    SnacksPickerTime = { fg = c["descriptionForeground"] },
    SnacksPickerCmd = { fg = c["variable.defaultLibrary"] },
    SnacksPickerRegister = { fg = c["editorBracketHighlight.foreground2"] },
    SnacksPickerTree = { fg = c["editorBracketHighlight.foreground2"] },
    SnacksPickerLink = { fg = c["textLink.foreground"] },
    SnacksPickerLinkBroken = { fg = c["editorError.foreground"] },
    SnacksPickerSelected = { fg = c["quickInput.list.focusForeground"], bg = c["quickInput.list.focusBackground"] },
    SnacksPickerUnselected = { fg = c["quickInput.foreground"] },
    SnacksPickerDimmed = { fg = c["descriptionForeground"] },
    SnacksPickerFileType = { fg = c["descriptionForeground"] },
    SnacksPickerBufType = { fg = c["descriptionForeground"] },
    SnacksPickerBufNr = { fg = c["descriptionForeground"] },
    SnacksPickerBufFlags = { fg = c["descriptionForeground"] },

    -- Picker keymaps
    SnacksPickerKeymapLhs = { fg = c["editorBracketHighlight.foreground2"] },
    SnacksPickerKeymapRhs = { fg = c["descriptionForeground"] },
    SnacksPickerKeymapMode = { fg = c["descriptionForeground"] },
    SnacksPickerKeymapNowait = { fg = c["descriptionForeground"] },
  }

  -- Notifier severity matrix: snacks renders each part with the severity
  -- suffix (SnacksNotifier{Part}{Severity}); define them from the severity map.
  for level, color in pairs(severity) do
    groups["SnacksNotifierBorder" .. level] = { fg = color }
    groups["SnacksNotifierTitle" .. level] = { fg = color }
    groups["SnacksNotifierIcon" .. level] = { fg = color }
    groups["SnacksNotifierMsg" .. level] = { fg = color }
  end

  -- Picker git rows: the commit/status surfaces use the gitDecoration family
  local git = {
    GitAuthor = "descriptionForeground",
    GitBranch = "descriptionForeground",
    GitBranchCurrent = "editorBracketHighlight.foreground2",
    GitBreaking = "editorError.foreground",
    GitCommit = "descriptionForeground",
    GitDate = "descriptionForeground",
    GitDetached = "descriptionForeground",
    GitIssue = "editorWarning.foreground",
    GitMsg = "descriptionForeground",
    GitScope = "descriptionForeground",
    GitStatus = "gitDecoration.addedResourceForeground",
    GitStatusAdded = "gitDecoration.addedResourceForeground",
    GitStatusCopied = "gitDecoration.modifiedResourceForeground",
    GitStatusDeleted = "gitDecoration.deletedResourceForeground",
    GitStatusModified = "gitDecoration.modifiedResourceForeground",
    GitStatusRenamed = "gitDecoration.modifiedResourceForeground",
    GitStatusStaged = "gitDecoration.addedResourceForeground",
    GitStatusUnmerged = "gitDecoration.conflictingResourceForeground",
    GitStatusUntracked = "gitDecoration.untrackedResourceForeground",
    GitType = "descriptionForeground",
  }
  for name, key in pairs(git) do
    groups["SnacksPicker" .. name] = { fg = c[key] }
  end

  -- Picker undo rows: added/removed mirror the diff gutter tones
  local undo = {
    UndoAdded = "gitDecoration.addedResourceForeground",
    UndoRemoved = "gitDecoration.deletedResourceForeground",
    UndoCurrent = "editorBracketHighlight.foreground2",
    UndoSaved = "descriptionForeground",
  }
  for name, key in pairs(undo) do
    groups["SnacksPicker" .. name] = { fg = c[key] }
  end

  -- Picker diagnostics: code (inlay-hint tone) and source (dim)
  groups.SnacksPickerDiagnosticCode = { fg = c["editorInlayHint.typeForeground"] }
  groups.SnacksPickerDiagnosticSource = { fg = c["descriptionForeground"] }

  return groups
end

return M