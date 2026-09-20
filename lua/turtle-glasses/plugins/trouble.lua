-- plugins/trouble.lua — trouble.nvim highlight groups.
-- Group names verified against folke/trouble.nvim source (lua/trouble/view,
-- lua/trouble/format.lua). Severity rows reuse the theme's Diagnostic* and
-- DiagnosticSign* groups. Colors come from the editor / badge / textLink /
-- indent guide palette families, verbatim from the palette.

local M = {}

--- Build the trouble highlight groups for a palette variant.
--- @param palette table  a variant from lua/turtle-glasses/palette.lua
--- @param options table  the resolved plugin options (unused here)
function M.groups(palette, options)
  local c = palette.colors

  return {
    -- Window surface
    TroubleNormal = { fg = c["editor.foreground"], bg = c["editor.background"] },
    TroubleNormalNC = { fg = c["editor.foreground"], bg = c["editor.background"] },
    TroublePreview = { fg = c["editorHoverWidget.foreground"], bg = c["editorHoverWidget.background"] },

    -- Row content
    TroubleText = { fg = c["editor.foreground"] },
    TroubleFilename = { fg = c["textLink.foreground"] },
    TroublePos = { fg = c["descriptionForeground"] },
    TroubleCode = { fg = c["editorInlayHint.parameterForeground"] },
    TroubleSource = { fg = c["descriptionForeground"] },

    -- Count badge (VS Code badge style)
    TroubleCount = { fg = c["badge.foreground"], bg = c["badge.background"] },

    -- Indent guides and directory/icon rows
    TroubleIndent = { fg = c["editorIndentGuide.background"] },
    TroubleDirectory = { fg = c["descriptionForeground"] },
    TroubleIcon = { fg = c["icon.foreground"] },
    TroubleIconDirectory = { fg = c["icon.foreground"] },

    -- Statusline accent while the list is open
    TroubleStatusline = { fg = c["statusBar.foreground"], bg = c["statusBar.background"] },
  }
end

return M