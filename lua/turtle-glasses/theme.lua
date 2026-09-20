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
-- VS Code shows over a flat background. The base comes from the active
-- palette variant, so the same code serves dark and light transparently.
--
-- Options layer (applied in order, last wins):
--   0. variants[variant] — deep-merged over the global options so a variant
--      can override any option without repeating the rest
--   1. italics=false  — strips italic from every concrete group
--   2. styles[family] — overrides the font style of a family of groups
--   3. transparent    — chrome/editor line groups lose their bg
--   4. overrides      — per-group merges applied last

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

-- Group families reachable through the `styles` option. The documented arrows
-- map to explicit names plus wildcard patterns that expand against the groups
-- actually present in the assembled map:
--   comment  → Comment/@comment
--   keyword  → Keyword/@keyword/@keyword.*
--   function → Function/@function.*
--   type     → Type/@type.*
--   variable → @variable/Identifier
--   operator → Operator/@operator
--   string   → String/@string.*
--   number   → Number/@number
--   constant → Constant/@constant.*
--   label    → Label/@label
--   title    → Title/@markup.heading.*
local FAMILY_PATTERNS = {
  comment  = { "Comment", "@comment", "@comment.documentation" },
  keyword  = { "Keyword", "@keyword", "^@keyword%." },
  ["function"] = { "Function", "@function", "^@function%." },
  type     = { "Type", "@type", "^@type%." },
  variable = { "Identifier", "@variable" },
  operator = { "Operator", "@operator" },
  string   = { "String", "@string", "^@string%." },
  number   = { "Number", "@number" },
  constant = { "Constant", "@constant", "^@constant%." },
  label    = { "Label", "@label" },
  title    = { "Title", "@markup.heading", "^@markup%.heading%." },
}

--- Expand a family's explicit names + wildcard patterns to the groups in map.
--- @param map table   group name -> highlight spec
--- @param patterns table  list of literal names or Lua patterns (starting with ^)
--- @return string[]       list of group names present in map
local function family_groups(map, patterns)
  local groups, seen = {}, {}
  local function add(name)
    if map[name] and not seen[name] then
      seen[name] = true
      groups[#groups + 1] = name
    end
  end
  for _, entry in ipairs(patterns) do
    if entry:sub(1, 1) == "^" then
      for name in pairs(map) do
        if name:match(entry) then
          add(name)
        end
      end
    else
      add(entry)
    end
  end
  return groups
end

--- Replace a group's font style with the given one ("NONE" clears all).
local function apply_fontstyle(spec, fontstyle)
  spec.italic = false
  spec.bold = false
  spec.underline = false
  if fontstyle ~= "NONE" then
    for part in fontstyle:gmatch("[^, ]+") do
      spec[part] = true
    end
  end
end

-- Groups whose background is decorative "chrome" rather than semantic
-- content: when options.transparent is enabled these lose their bg entirely.
local TRANSPARENT_GROUPS = {
  "Normal",
  "NormalNC",
  "NormalFloat",
  "FloatBorder",
  "FloatTitle",
  "LineNr",
  "CursorLineNr",
  "CursorLine",
  "CursorLineNC",
  "CursorColumn",
  "ColorColumn",
  "SignColumn",
  "SignColumnNC",
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
--- @param palette table   a variant from lua/turtle-glasses/palette.lua (M.dark / M.light)
--- @param options table   the resolved plugin options (M.options from init.lua)
--- @return table          group name -> highlight spec (as accepted by nvim_set_hl)
function M.build(palette, options)
  local opts = options or {}

  -- 0. Per-variant options: deep-merge the variant's option table over the
  --    global options so variant styles/overrides win. The palette's `type`
  --    ("dark" / "light") selects the variant the same way load() does.
  local variant_opts = (opts.variants or {})[palette.type]
  if variant_opts then
    opts = vim.tbl_deep_extend("force", opts, variant_opts)
  end

  local map = {}

  -- Order matters for collisions (later modules win). Plugin integrations
  -- are merged last, unconditionally (standard colorscheme practice: the
  -- groups are harmless when the plugin is absent), so user overrides still
  -- apply on top of them in the options layer below.
  local modules = {
    require("turtle-glasses.ui"),
    require("turtle-glasses.syntax"),
    require("turtle-glasses.treesitter"),
    require("turtle-glasses.lsp"),
    require("turtle-glasses.plugins"),
  }

  for _, mod in ipairs(modules) do
    if mod.groups then
      for name, spec in pairs(mod.groups(palette, opts)) do
        map[name] = spec
      end
    end
  end

  -- Options layer --------------------------------------------------

  -- 1. italics master switch: strip EVERY italic font style.
  if opts.italics == false then
    for _, spec in pairs(map) do
      if not spec.link then
        spec.italic = false
      end
    end
  end

  -- 2. Per-family font style overrides. Linked groups are skipped here;
  --    their targets belong to the same family so the style reaches them
  --    through the link (nvim rejects link combined with other attributes).
  for family, fontstyle in pairs(opts.styles or {}) do
    local patterns = FAMILY_PATTERNS[family]
    if patterns and type(fontstyle) == "string" then
      for _, name in ipairs(family_groups(map, patterns)) do
        local spec = map[name]
        if not spec.link then
          apply_fontstyle(spec, fontstyle)
        end
      end
    end
  end

  -- 3. Transparent chrome: groups whose bg is decorative lose it.
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

  -- 4. User overrides, applied LAST: merge over the group spec; when the
  --    override (or the existing spec) is a link, apply it as a pure link
  --    — nvim rejects link combined with color/attribute fields.
  for name, ov in pairs(opts.overrides or {}) do
    local base = map[name]
    if ov.link then
      map[name] = { link = ov.link }
    elseif base and base.link then
      map[name] = vim.deepcopy(ov)
    else
      map[name] = vim.tbl_deep_extend("force", base or {}, ov)
    end
  end

  -- Resolve translucent hex and apply --------------------------------

  local base_hex = palette.colors["editor.background"]
  if not base_hex then
    error("Turtle Glasses: palette missing 'editor.background'", 0)
  end

  for name, spec in pairs(map) do
    if not spec.link then
      resolve_alpha(spec, base_hex)
    end
    vim.api.nvim_set_hl(0, name, spec)
  end

  -- Dim-inactive support: keep vim.wo.dim_inactive on for every window entered
  -- after the theme loads (re-runs of build() reuse the same augroup, so the
  -- autocmd stays idempotent). The window option only exists in nvim >= 0.11;
  -- on older versions (>= 0.9 per the plugin requirements) the dimmed *NC
  -- groups stay defined — harmless and unused — and the option is skipped.
  if opts.dim_inactive then
    local supported = pcall(function()
      vim.wo.dim_inactive = true
    end)
    if supported then
      local augroup = vim.api.nvim_create_augroup("TurtleGlassesDimInactive", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
        group = augroup,
        callback = function()
          vim.wo.dim_inactive = true
        end,
      })
    end
  end

  return map
end

return M
