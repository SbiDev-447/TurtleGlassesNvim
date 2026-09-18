-- theme.lua — assembles the full highlight table from the submodules and
-- applies it to the current window namespace.
--
-- Fidelity rule: every color used by the highlight groups comes verbatim from
-- the generated palette (lua/turtle-glasses/palette.lua). No colors are
-- invented here; the palette is the single source of truth.
--
-- Alpha handling: palette keys may carry 8-digit hex (e.g. "#b7cc8522").
-- nvim_set_hl() does not accept 8-digit hex, so translucent colors are
-- alpha-composited over the editor background at load time — the same result
-- VS Code shows over a flat background.

local M = {}

--- Composite an 8-digit "#RRGGBBAA" color over a 6-digit "#RRGGBB" base.
local function composite_alpha(hex, base)
  local alpha = tonumber(hex:sub(8), 16) / 255
  local out = { "#" }
  for i = 2, 6, 2 do
    local fg = tonumber(hex:sub(i, i + 1), 16)
    local bg = tonumber(base:sub(i, i + 1), 16)
    out[#out + 1] = string.format("%02X", math.floor(fg * alpha + bg * (1 - alpha) + 0.5))
  end
  return table.concat(out)
end

--- Rewrite any 8-digit hex color in a spec to its composite over the base.
local function resolve_alpha(spec, base)
  for _, key in ipairs({ "fg", "bg", "sp" }) do
    local v = spec[key]
    if type(v) == "string" and v:match("^#[0-9a-fA-F]%x%x%x%x%x%x%x$") then
      spec[key] = composite_alpha(v, base)
    end
  end
end

-- Groups whose background is decorative "chrome" rather than semantic
-- content: when options.transparent is enabled these lose their bg entirely.
local TRANSPARENT_GROUPS = {
  "Normal",
  "NormalFloat",
  "FloatBorder",
  "FloatTitle",
  "LineNr",
  "CursorLineNr",
  "CursorLine",
  "CursorColumn",
  "ColorColumn",
  "SignColumn",
  "FoldColumn",
  "Folded",
  "WinSeparator",
  "QuickFixLine",
  "Pmenu",
  "PmenuSbar",
  "PmenuThumb",
  "LspInlayHint",
  "DiagnosticErrorSign",
  "DiagnosticWarnSign",
  "DiagnosticInfoSign",
  "DiagnosticHintSign",
  "DiagnosticOkSign",
  "DiagnosticErrorLine",
  "DiagnosticWarnLine",
  "DiagnosticInfoLine",
  "DiagnosticHintLine",
  "DiagnosticOkLine",
}

--- Build the full highlight group map for a palette variant.
--- @param palette table  a variant from lua/turtle-glasses/palette.lua (M.dark / M.light)
--- @param options table  the resolved plugin options (M.options from init.lua)
--- @return table         group name -> highlight spec (as accepted by nvim_set_hl)
function M.build(palette, options)
  local opts = options or {}
  local map = {}

  -- Order matters for collisions (later modules win).
  local modules = {
    require("turtle-glasses.ui"),
    require("turtle-glasses.syntax"),
    require("turtle-glasses.treesitter"),
    require("turtle-glasses.lsp"),
  }

  for _, mod in ipairs(modules) do
    if mod.groups then
      for name, spec in pairs(mod.groups(palette, opts)) do
        map[name] = spec
      end
    end
  end

  if opts.transparent then
    for _, name in ipairs(TRANSPARENT_GROUPS) do
      local spec = map[name]
      -- Only rewrite concrete specs; link specs resolve elsewhere and must
      -- stay untouched (nvim rejects link combined with other attributes).
      if spec and not spec.link then
        spec.bg = "NONE"
      end
    end
  end

  local base_hex = palette.colors["editor.background"] or "#000000"

  for name, spec in pairs(map) do
    -- Links must not carry color attributes alongside.
    if not spec.link then
      resolve_alpha(spec, base_hex)
    end
    vim.api.nvim_set_hl(0, name, spec)
  end

  return map
end

return M