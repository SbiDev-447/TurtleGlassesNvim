-- plugins/lualine.lua — lualine.nvim highlight groups.
-- Sections follow the VS Code status bar gradient: A uses the status bar
-- pair, B steps down to the secondary button pair, C to the dropdown pair.
-- Every color is read verbatim from the generated palette variant.

local M = {}

--- Build the lualine highlight groups for a palette variant.
--- @param palette table  a variant from lua/turtle-glasses/palette.lua
--- @param options table  the resolved plugin options (unused here)
function M.groups(palette, options)
  local c = palette.colors

  local a = { fg = c["statusBar.foreground"], bg = c["statusBar.background"] }
  local b = { fg = c["button.secondaryForeground"], bg = c["button.secondaryBackground"] }
  local csec = { fg = c["dropdown.foreground"], bg = c["dropdown.background"] }

  -- Separators are powerline triangles: fg takes the section's bg, bg takes
  -- the following section's bg. Fill mirrors the section it belongs to.
  local function section(spec)
    return vim.deepcopy(spec)
  end
  local function sep(fg_spec, bg_spec)
    return { fg = fg_spec.bg, bg = bg_spec.bg }
  end

  local groups = {
    -- Base sections
    LualineA = section(a),
    LualineB = section(b),
    LualineC = section(csec),
    LualineASep = sep(a, b),
    LualineBSep = sep(b, csec),
    LualineCSep = sep(csec, a),
    LualineAFill = section(a),
    LualineBFill = section(b),
    LualineCFill = section(csec),

    -- Mode variants (same palette pairs as the base sections)
    LualineAMode = section(a),
    LualineBMode = section(b),
    LualineCMode = section(csec),
    LualineAModeSep = sep(a, b),
    LualineBModeSep = sep(b, csec),
    LualineCModeSep = sep(csec, a),
    LualineAModeFill = section(a),
    LualineBModeFill = section(b),
    LualineCModeFill = section(csec),
  }

  return groups
end

return M