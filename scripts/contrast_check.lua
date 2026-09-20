-- scripts/contrast_check.lua — durable WCAG contrast audit for Turtle Glasses.
--
-- Run from the repository root:
--   nvim --headless -l scripts/contrast_check.lua
--
-- Loads BOTH variants (turtle-glasses-dark, turtle-glasses-light), iterates
-- every defined highlight group returned by vim.api.nvim_get_hl(0, {}),
-- resolves link chains (hl.link, followed recursively) to a concrete fg/bg,
-- and computes the WCAG 2.x relative-luminance contrast ratio:
--
--   linearize(c) = c <= 0.04045 ? c/12.92 : ((c+0.055)/1.055)^2.4   (c = 0..1)
--   L = 0.2126*R + 0.7152*G + 0.0722*B
--   ratio = (Lmax + 0.05) / (Lmin + 0.05)
--
-- Tiers (WCAG AA guidance, applied to syntax/UI text):
--   CRITICAL < 3.0   WARN 3.0..4.49   OK >= 4.5
--
-- DESIGN-DIM ALLOWLIST (deliberately below AA; excluded from failures):
--   * Comment / SpecialComment / @comment / @comment.documentation
--       — comment text is intentionally dimmed (italic muted tone).
--   * LspInlayHint, LspCodeLens
--       — tertiary virtual text / code-lens labels are dim by design.
--   * NonText, Whitespace, SpecialKey, EndOfBuffer, Conceal
--       — invisibles and end-of-buffer filler exist to NOT be seen.
--   * LineNr, FoldColumn, CursorLineFold
--       — line-number and fold-gutter numerals are dim chrome (CursorLineFold
--         is nvim's default link onto FoldColumn for the cursor-line fold
--         column).
--   * Folded
--       — collapsed-region placeholder (description tone, like VS Code's
--         dimmed folded preview).
--   * IblIndent, IblWhitespace, IblIndentChar
--       — indent-guide rule lines are decorative strokes.
--   * CmpItemMenu, CmpGhostText, GitSignsCurrentLineBlame,
--     WhichKeySeparator, TelescopePromptCounter
--       — dimmed helper/ghost text (menu provenance, ghost preview, blame,
--         counters).
--   * StatusLineNC, StatusLineTermNC
--       — unfocused status lines are intentionally dimmed chrome
--         (StatusLineTermNC is nvim's default link onto StatusLineNC for the
--         terminal status line).
--   * BufferLineSeparator, BufferLineSeparatorVisible, BufferLineSeparatorSelected
--       — bufferline's powerline-style separators between neighbouring tabs:
--         the fg is the palette's tab-border tone sitting on the tab
--         background, so the triangle renders as a bisecting gradient, exactly
--         like the Lualine separators below.
--   * NeoTreeTabSeparatorActive, NeoTreeTabSeparatorInactive
--       — neo-tree's renderer separators between tabs: same powerline-style
--         gradient rationale as the Lualine/BufferLine separators above.
--   * LualineASep, LualineBSep, LualineCSep,
--     LualineAModeSep, LualineBModeSep, LualineCModeSep
--       — powerline separators: fg equals the neighbouring section's bg by
--         design, so the triangle renders as a bisecting gradient between two
--         adjacent section colors, not as text over a background.
--
-- NVIM-CORE DEFAULT GROUPS (fg == bg by nvim 0.12's own defaults; not
-- theme-owned, therefore excluded from failures rather than "fixed" into a
-- style divergence):
--   * @markup.heading.1.delimiter.vimdoc, @markup.heading.2.delimiter.vimdoc
--       — the `=====` underline below vimdoc headings renders in the editor
--         background color (invisible by design, in stock nvim too).
--   * NvimFigureBrace, NvimInternalError,
--     NvimInvalidSingleQuotedUnknownEscape, NvimSingleQuotedUnknownEscape
--       — red-on-red markers for pathological VimScript parser states.
--
-- The theme never sets these groups; they resolve identically (fg == bg)
-- under nvim's stock colorscheme, so Turtle Glasses introduces no regression
-- on them.
--
-- Groups with no resolved bg (or no resolved fg) depend on their surroundings
-- and are reported as "transparent" instead of being ratio-checked.
--
-- Exit status: 0 when no CRITICAL group remains OUTSIDE the allowlist in
-- either variant ("contrast: PASS"); 1 otherwise, listing the offenders.
-- The table per variant is sorted by ratio ascending.

-- Resolve the repository root from this script's own path: scripts/ sits one
-- level below the root, so the parent of this file's parent is the root.
local script = vim.fn.fnamemodify(arg[0], ":p")
local repo_root = vim.fn.fnamemodify(script, ":h:h")
vim.opt.rtp:prepend(repo_root)

local VVARIANTS = { "dark", "light" }

local ALLOWLIST = {
  -- Comments
  "Comment", "SpecialComment", "@comment", "@comment.documentation",
  -- Inlay hints / code lens
  "LspInlayHint", "LspCodeLens",
  -- Invisibles / filler
  "NonText", "Whitespace", "SpecialKey", "EndOfBuffer", "Conceal",
  -- Line numbers / fold gutter
  "LineNr", "FoldColumn", "CursorLineFold",
  -- Folded placeholder
  "Folded",
  -- Indent guides
  "IblIndent", "IblWhitespace", "IblIndentChar",
  -- Dimmed helpers / ghost text
  "CmpItemMenu", "CmpGhostText", "GitSignsCurrentLineBlame",
  "WhichKeySeparator", "TelescopePromptCounter",
  -- Inactive chrome
  "StatusLineNC", "StatusLineTermNC",
  -- Bufferline powerline separator gradients
  "BufferLineSeparator", "BufferLineSeparatorVisible", "BufferLineSeparatorSelected",
  -- Neo-tree renderer separator gradients
  "NeoTreeTabSeparatorActive", "NeoTreeTabSeparatorInactive",
  -- Powerline separator gradient triangles
  "LualineASep", "LualineBSep", "LualineCSep",
  "LualineAModeSep", "LualineBModeSep", "LualineCModeSep",
  -- NVIM-CORE DEFAULT GROUPS (not theme-owned; fg == bg by nvim design)
  "@markup.heading.1.delimiter.vimdoc", "@markup.heading.2.delimiter.vimdoc",
  "NvimFigureBrace", "NvimInternalError",
  "NvimInvalidSingleQuotedUnknownEscape", "NvimSingleQuotedUnknownEscape",
}

-- Set form of the allowlist for O(1) membership tests.
local ALLOWLIST_SET = {}
for _, name in ipairs(ALLOWLIST) do
  ALLOWLIST_SET[name] = true
end

local CRITICAL_MAX, WARN_MAX = 3.0, 4.5

--- Format a numeric color as #rrggbb; nil/NONE stays readable.
local function hex(v)
  if v == nil then
    return "NONE"
  end
  return string.format("#%06x", v)
end

--- Linearize one sRGB channel (0..1) per the WCAG 2.x formula.
local function linearize(c)
  if c <= 0.04045 then
    return c / 12.92
  end
  return ((c + 0.055) / 1.055) ^ 2.4
end

--- WCAG relative luminance of a numeric 0xRRGGBB color.
local function luminance(v)
  local r = linearize(bit.band(bit.rshift(v, 16), 0xFF) / 255)
  local g = linearize(bit.band(bit.rshift(v, 8), 0xFF) / 255)
  local b = linearize(bit.band(v, 0xFF) / 255)
  return 0.2126 * r + 0.7152 * g + 0.0722 * b
end

--- WCAG contrast ratio between two numeric colors.
local function contrast(fg, bg)
  local l1, l2 = luminance(fg), luminance(bg)
  if l1 < l2 then
    l1, l2 = l2, l1
  end
  return (l1 + 0.05) / (l2 + 0.05)
end

--- Resolve a link chain to the terminal concrete spec from the all-groups
--- table returned by nvim_get_hl(0, {}). Returns nil when the chain does not
--- terminate (cycle) or the terminal spec is missing.
local function resolve_link(name, all)
  local seen = {}
  local cur = name
  while true do
    if seen[cur] then
      return nil -- link cycle
    end
    seen[cur] = true
    local spec = all[cur]
    if not spec then
      return nil
    end
    if not spec.link then
      return spec
    end
    cur = spec.link
  end
end

local function tier(ratio)
  if ratio < CRITICAL_MAX then
    return "CRITICAL"
  elseif ratio < WARN_MAX then
    return "WARN"
  end
  return "OK"
end

--- Audit one variant: load it, walk every group, print the sorted table.
--- Returns the number of CRITICAL groups outside the allowlist.
local function audit_variant(variant)
  vim.cmd("colorscheme turtle-glasses-" .. variant)
  local all = vim.api.nvim_get_hl(0, {})

  local rows, transparent = {}, 0
  for name in pairs(all) do
    local spec = resolve_link(name, all)
    if spec then
      local fg, bg = spec.fg, spec.bg
      if fg ~= nil and bg ~= nil then
        local ratio = contrast(fg, bg)
        rows[#rows + 1] = {
          group = name,
          fg = fg,
          bg = bg,
          ratio = ratio,
          tier = tier(ratio),
          allowlisted = ALLOWLIST_SET[name] ~= nil,
        }
      else
        transparent = transparent + 1
      end
    end
  end

  -- Deterministic order: ratio ascending, then group name.
  table.sort(rows, function(a, b)
    if a.ratio ~= b.ratio then
      return a.ratio < b.ratio
    end
    return a.group < b.group
  end)

  io.write(string.format("\n== turtle-glasses-%s (%d groups with fg+bg, %d transparent) ==\n", variant, #rows, transparent))
  io.write(string.format("%-28s %-9s %-9s %-7s %-9s %s\n", "group", "fg", "bg", "ratio", "tier", "note"))
  for _, r in ipairs(rows) do
    io.write(string.format(
      "%-28s %-9s %-9s %-7.2f %-9s %s\n",
      r.group, hex(r.fg), hex(r.bg), r.ratio, r.tier,
      r.allowlisted and "(allowlist: design-dim)" or ""
    ))
  end

  local criticals, warns = 0, 0
  for _, r in ipairs(rows) do
    if r.tier == "CRITICAL" and not r.allowlisted then
      criticals = criticals + 1
      io.write(string.format("OFFENDER %s: %s on %s = %.2f\n", r.group, hex(r.fg), hex(r.bg), r.ratio))
    elseif r.tier == "WARN" and not r.allowlisted then
      warns = warns + 1
    end
  end
  io.write(string.format("turtle-glasses-%s: %d critical, %d warned (outside allowlist)\n", variant, criticals, warns))
  return criticals, warns
end

-- Audit both variants, then decide the exit status.
local total_critical, total_warn = 0, 0
for _, variant in ipairs(VVARIANTS) do
  local c, w = audit_variant(variant)
  total_critical = total_critical + c
  total_warn = total_warn + w
end

if total_critical > 0 then
  io.write(string.format("\ncontrast: FAIL (%d critical outside allowlist)\n", total_critical))
  os.exit(1)
end

io.write(string.format("\ncontrast: PASS (%d critical, %d warned)\n", total_critical, total_warn))
os.exit(0)