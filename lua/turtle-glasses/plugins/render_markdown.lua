-- plugins/render_markdown.lua — render-markdown.nvim highlight groups.
-- Group names verified against MeanderingProgrammer/render-markdown.nvim
-- source (lua/render-markdown/render/**). Headings use the bracket-guide
-- accent spectrum for depth; blocks use the textBlockQuote / textCodeBlock
-- palette families. Debug/Log/Preview groups are intentionally skipped.

local M = {}

--- Build the render-markdown highlight groups for a palette variant.
--- @param palette table  a variant from lua/turtle-glasses/palette.lua
--- @param options table  the resolved plugin options (unused here)
function M.groups(palette, options)
  local c = palette.colors
  local accent = {
    c["editorBracketHighlight.foreground1"],
    c["editorBracketHighlight.foreground2"],
    c["editorBracketHighlight.foreground3"],
    c["editorBracketHighlight.foreground4"],
    c["editorBracketHighlight.foreground5"],
    c["editorBracketHighlight.foreground6"],
  }

  local groups = {
    -- Code and inline code surfaces
    RenderMarkdownCode = { fg = c["editor.foreground"], bg = c["textCodeBlock.background"] },
    RenderMarkdownCodeInline = { fg = c["editor.foreground"], bg = c["textCodeBlock.background"] },
    RenderMarkdownCodeBorder = { fg = c["editor.foreground"], bg = c["textCodeBlock.background"] },
    RenderMarkdownCodeInfo = { fg = c["descriptionForeground"], bg = c["textCodeBlock.background"] },
    RenderMarkdownPadding = { bg = c["editor.background"] },

    -- Headings: accent spectrum for depth, flat line backgrounds
    RenderMarkdownH1 = { fg = accent[1], bold = true },
    RenderMarkdownH2 = { fg = accent[2], bold = true },
    RenderMarkdownH3 = { fg = accent[3], bold = true },
    RenderMarkdownH4 = { fg = accent[4], bold = true },
    RenderMarkdownH5 = { fg = accent[5], bold = true },
    RenderMarkdownH6 = { fg = accent[6], bold = true },
    RenderMarkdownH1Bg = { bg = c["editor.background"] },
    RenderMarkdownH2Bg = { bg = c["editor.background"] },
    RenderMarkdownH3Bg = { bg = c["editor.background"] },
    RenderMarkdownH4Bg = { bg = c["editor.background"] },
    RenderMarkdownH5Bg = { bg = c["editor.background"] },
    RenderMarkdownH6Bg = { bg = c["editor.background"] },

    -- Blockquote family (VS Code textBlockQuote palette)
    RenderMarkdownQuote = { fg = c["textBlockQuote.foreground"], bg = c["textBlockQuote.background"] },
    RenderMarkdownQuote1 = { fg = c["textBlockQuote.foreground"] },
    RenderMarkdownQuote2 = { fg = c["textBlockQuote.foreground"] },
    RenderMarkdownQuote3 = { fg = c["textBlockQuote.foreground"] },
    RenderMarkdownQuote4 = { fg = c["textBlockQuote.foreground"] },
    RenderMarkdownQuote5 = { fg = c["textBlockQuote.foreground"] },
    RenderMarkdownQuote6 = { fg = c["textBlockQuote.foreground"] },

    -- Tables: raised head, flat rows
    RenderMarkdownTableHead = { fg = c["editorWidget.foreground"], bg = c["editorWidget.background"] },
    RenderMarkdownTableRow = { fg = c["editor.foreground"], bg = c["editor.background"] },

    -- Lists, checkboxes and the sign column
    RenderMarkdownBullet = { fg = c["icon.foreground"] },
    RenderMarkdownChecked = { fg = c["gitDecoration.addedResourceForeground"] },
    RenderMarkdownUnchecked = { fg = c["icon.foreground"] },
    RenderMarkdownTodo = { fg = c["problemsInfoIcon.foreground"] },
    RenderMarkdownSign = { fg = c["editorLineNumber.dimmedForeground"] },

    -- Links and inline markup
    RenderMarkdownLink = { fg = c["textLink.foreground"] },
    RenderMarkdownLinkTitle = { fg = c["editor.foreground"] },
    RenderMarkdownWikiLink = { fg = c["textLink.activeForeground"] },
    RenderMarkdownInlineHighlight = { fg = c["editor.foreground"], bg = c["editor.findMatchHighlightBackground"] },
    RenderMarkdownHtmlComment = { fg = c["comment"] },

    -- Decorative rules and math
    RenderMarkdownDash = { fg = c["textSeparator.foreground"] },
    RenderMarkdownIndent = { fg = c["editorIndentGuide.background"] },
    RenderMarkdownMath = { fg = c["editorInlayHint.typeForeground"] },

    -- Callout severity tones
    RenderMarkdownHint = { fg = c["problemsInfoIcon.foreground"] },
    RenderMarkdownInfo = { fg = c["problemsInfoIcon.foreground"] },
    RenderMarkdownWarn = { fg = c["editorWarning.foreground"] },
    RenderMarkdownSuccess = { fg = c["gitDecoration.addedResourceForeground"] },
    RenderMarkdownError = { fg = c["editorError.foreground"] },
  }

  return groups
end

return M