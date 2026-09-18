-- lsp.lua — LSP-related highlight groups (diagnostics, references, inlay hints).

local M = {}

--- Build the LSP highlight groups for a palette variant.
--- @param palette table  a variant from lua/turtle-glasses/palette.lua
function M.groups(palette)
  local c = palette.colors

  local error = c["editorError.foreground"]
  local warn = c["editorWarning.foreground"]
  local info = c["problemsInfoIcon.foreground"]
  local hint = c["editorInlayHint.parameterForeground"]
  local ok = c["editorGutter.addedBackground"]
  local gutter_bg = c["editorGutter.background"]

  local groups = {
    -- Diagnostics
    DiagnosticError = { fg = error },
    DiagnosticWarn = { fg = warn },
    DiagnosticInfo = { fg = info },
    DiagnosticHint = { fg = hint },
    DiagnosticOk = { fg = ok },

    -- Gutter signs
    DiagnosticErrorSign = { fg = error, bg = gutter_bg },
    DiagnosticWarnSign = { fg = warn, bg = gutter_bg },
    DiagnosticInfoSign = { fg = info, bg = gutter_bg },
    DiagnosticHintSign = { fg = hint, bg = gutter_bg },
    DiagnosticOkSign = { fg = ok, bg = gutter_bg },

    -- Full-line backgrounds (solid: from the input validation tints)
    DiagnosticErrorLine = { bg = c["inputValidation.errorBackground"] },
    DiagnosticWarnLine = { bg = c["inputValidation.warningBackground"] },
    DiagnosticInfoLine = { bg = c["inputValidation.infoBackground"] },
    DiagnosticHintLine = { bg = c["inputValidation.infoBackground"] },
    DiagnosticOkLine = { bg = c["diffEditor.insertedTextBackground"] },

    -- Underlines / undercurls
    DiagnosticUndercurlError = { sp = error, undercurl = true },
    DiagnosticUndercurlWarn = { sp = warn, undercurl = true },
    DiagnosticUndercurlInfo = { sp = info, undercurl = true },
    DiagnosticUndercurlHint = { sp = hint, undercurl = true },
    DiagnosticUnderlineError = { sp = error, underline = true },
    DiagnosticUnderlineWarn = { sp = warn, underline = true },
    DiagnosticUnderlineInfo = { sp = info, underline = true },
    DiagnosticUnderlineHint = { sp = hint, underline = true },

    -- Virtual text
    DiagnosticVirtualTextError = { fg = error },
    DiagnosticVirtualTextWarn = { fg = warn },
    DiagnosticVirtualTextInfo = { fg = info },
    DiagnosticVirtualTextHint = { fg = hint },
    DiagnosticVirtualTextOk = { fg = ok },

    -- Code references
    LspReferenceText = { bg = c["editor.wordHighlightBackground"] },
    LspReferenceRead = { bg = c["editor.wordHighlightBackground"] },
    LspReferenceWrite = { bg = c["editor.wordHighlightStrongBackground"] },

    -- Code lens / inlay hints / signatures
    LspCodeLens = { fg = c["editorCodeLens.foreground"] },
    LspInlayHint = { fg = c["editorInlayHint.foreground"], bg = c["editorInlayHint.background"] },
    LspSignatureActiveParameter = { fg = hint },

    -- Borders
    LspInfoBorder = { fg = c["editorHoverWidget.border"] },
  }

  return groups
end

return M