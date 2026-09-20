-- ui.lua — editor chrome and UI highlight groups for Turtle Glasses.
-- Every color is read verbatim from the generated palette variant.

local M = {}

--- Build the UI/chrome highlight groups for a palette variant.
--- @param palette table  a variant from lua/turtle-glasses/palette.lua
function M.groups(palette)
  local c = palette.colors
  -- A few pairs read "background-colored ink on a solid chip" in dark but must
  -- invert on light (where the background is the lightest color in the theme):
  -- dark ink on the same chip keeps these groups legible in BOTH variants.
  -- The dark side of each branch reads the exact same palette keys as before,
  -- so the dark variant stays byte-identical.
  local is_light = palette.type == "light"

  local groups = {
    -- Editor base
    Normal = { fg = c["editor.foreground"], bg = c["editor.background"] },
    NormalFloat = { fg = c["editorHoverWidget.foreground"], bg = c["editorHoverWidget.background"] },
    FloatBorder = { fg = c["editorHoverWidget.border"], bg = "NONE" },
    FloatTitle = { fg = c["editorHoverWidget.foreground"], bg = "NONE" },

    -- Inactive-window chrome (used when nvim.wo.dim_inactive is on): text
    -- falls back to the dim description tone, the gutter/signs follow suit
    NormalNC = { fg = c["descriptionForeground"], bg = c["editor.background"] },
    SignColumnNC = { fg = c["descriptionForeground"], bg = c["editorGutter.background"] },
    CursorLineNC = { bg = c["editor.lineHighlightBorder"] },

    -- Cursor
    Cursor = { fg = is_light and c["editor.foreground"] or c["editorCursor.background"], bg = c["editorCursor.foreground"] },
    CursorIM = { fg = is_light and c["editor.foreground"] or c["editorCursor.background"], bg = c["editorCursor.foreground"] },
    TermCursor = { fg = is_light and c["editor.foreground"] or c["editorCursor.background"], bg = c["editorCursor.foreground"] },
    TermCursorNC = { fg = c["editorCursor.background"], bg = c["descriptionForeground"] },

    -- Cursor / current line
    CursorLine = { bg = c["editor.lineHighlightBorder"] },
    CursorLineNr = { fg = c["editorLineNumber.activeForeground"], bg = c["editor.lineHighlightBorder"] },
    LineNr = { fg = c["editorLineNumber.foreground"] },
    CursorColumn = { bg = c["editor.lineHighlightBorder"] },
    ColorColumn = { bg = c["editorRuler.foreground"] },

    -- Selection
    Visual = { fg = c["editor.selectionForeground"], bg = c["editor.selectionBackground"] },
    VisualNOS = { bg = c["editor.inactiveSelectionBackground"] },

    -- Search / substitute (rendering decision: translucent bg from the VS Code
    -- find-match keys; CurSearch uses the solid find-match marker color as bg
    -- with the variant's readable ink as fg — editor background in dark, the
    -- dark editor foreground on light, where the background is cream)
    Search = { bg = c["editor.findMatchHighlightBackground"] },
    IncSearch = { bg = c["editor.findMatchBackground"] },
    CurSearch = { fg = is_light and c["editor.foreground"] or c["editor.background"], bg = c["editorOverviewRuler.findMatchForeground"] },
    Substitute = { bg = c["editor.findMatchBackground"] },

    -- Bracket match (VS Code fills a background behind matching brackets;
    -- nvim has no border attribute, so the border color becomes the bg)
    MatchParen = { bg = c["editorBracketMatch.border"] },

    -- Popup menu
    Pmenu = { fg = c["editorSuggestWidget.foreground"], bg = c["editorSuggestWidget.background"] },
    PmenuSel = { fg = c["editorSuggestWidget.selectedForeground"], bg = c["editorSuggestWidget.selectedBackground"] },
    PmenuSbar = { bg = c["scrollbarSlider.background"] },
    PmenuThumb = { bg = c["scrollbarSlider.activeBackground"] },
    PmenuMatch = { fg = c["editorSuggestWidget.highlightForeground"] },
    PmenuMatchSel = { fg = c["editorSuggestWidget.highlightForeground"] },

    -- Status line
    StatusLine = { fg = c["statusBar.foreground"], bg = c["statusBar.background"] },
    StatusLineNC = { fg = c["titleBar.inactiveForeground"], bg = c["tab.inactiveBackground"] },

    -- Tab line
    TabLine = { fg = c["tab.inactiveForeground"], bg = c["tab.inactiveBackground"] },
    TabLineFill = { bg = c["editorGroupHeader.tabsBackground"] },
    TabLineSel = { fg = c["tab.activeForeground"], bg = c["tab.activeBackground"] },

    -- Splits / gutter
    WinSeparator = { fg = c["editorGroup.border"] },
    SignColumn = { fg = c["editorGutter.commentRangeForeground"], bg = c["editorGutter.background"] },
    Folded = { fg = c["descriptionForeground"], bg = c["editorMarkerNavigation.background"] },
    FoldColumn = { fg = c["editorLineNumber.foreground"], bg = c["editorGutter.background"] },
    QuickFixLine = { fg = c["list.activeSelectionForeground"], bg = c["list.activeSelectionBackground"] },

    -- Spelling (no dedicated VS Code spell keys exist in the palette; reuse the
    -- LSP severity colors so underline colors stay semantically consistent)
    SpellBad = { sp = c["editorError.foreground"], undercurl = true },
    SpellCap = { sp = c["editorWarning.foreground"], undercurl = true },
    SpellLocal = { sp = c["editorInlayHint.parameterForeground"], undercurl = true },
    SpellRare = { sp = c["descriptionForeground"], undercurl = true },

    -- Diff (VS Code: line/title backgrounds are translucent; DiffText renders
    -- the changed text with the inserted border color as a solid bg. The light
    -- variant uses dark ink on pale tints — the same model VS Code light
    -- applies to diff regions — because the dark-marker colors read poorly on
    -- cream; changed lines get the palette's pale warning tint)
    DiffAdd = { fg = is_light and c["editor.foreground"] or c["diffEditor.insertedTextBorder"], bg = c["diffEditor.insertedTextBackground"] },
    DiffChange = {
      fg = is_light and c["editor.foreground"] or c["editorGutter.modifiedBackground"],
      bg = is_light and c["inputValidation.warningBackground"] or c["diffEditor.diagonalFill"],
    },
    DiffDelete = { fg = is_light and c["editor.foreground"] or c["diffEditor.removedTextBorder"], bg = c["diffEditor.removedTextBackground"] },
    DiffText = { fg = is_light and c["editor.foreground"] or c["editor.background"], bg = c["diffEditor.insertedTextBorder"] },

    -- Messaging / prompting
    ErrorMsg = { fg = c["editorError.foreground"] },
    WarningMsg = { fg = c["editorWarning.foreground"] },
    ModeMsg = { fg = c["editor.foreground"] },
    MoreMsg = { fg = c["problemsInfoIcon.foreground"] },
    Question = { fg = c["problemsInfoIcon.foreground"] },
    Title = { fg = c["editor.foreground"] },
    Directory = { fg = c["editorLink.activeForeground"] },
    WildMenu = { fg = c["editorSuggestWidget.selectedForeground"], bg = c["editorSuggestWidget.selectedBackground"] },

    -- Whitespace / invisibles / misc
    EndOfBuffer = { fg = c["editor.background"] },
    NonText = { fg = c["editorWhitespace.foreground"] },
    Whitespace = { fg = c["editorWhitespace.foreground"] },
    SpecialKey = { fg = c["editorWhitespace.foreground"] },
    Conceal = { fg = c["descriptionForeground"] },
  }

  return groups
end

return M