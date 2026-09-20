local M = {}

--- Default options. Schema:
---   transparent = false  -- boolean: chrome/editor line groups get bg = "NONE"
---   italics     = true   -- boolean master switch: when false, strip ALL italic
---                         --   fontStyle (e.g. Comment / @comment)
---   styles      = {}     -- map family -> fontstyle string:
---                         --   "italic" | "bold" | "underline" | "NONE"
---                         --   valid families: comment, keyword, function,
---                         --   type, variable, operator, string, number
---                         --   The family's fontstyle overrides the palette
---                         --   styles of its groups (comment -> Comment/@comment;
---                         --   keyword -> Keyword/@keyword/@keyword.*;
---                         --   function -> Function/@function*;
---                         --   type -> Type/@type*;
---                         --   variable -> @variable/Identifier;
---                         --   operator -> Operator/@operator;
---                         --   string -> String/@string*;
---                         --   number -> Number/@number).
---                         --   "NONE" clears bold/italic/underline on them.
---   overrides   = {}     -- map HL group name -> attr table {fg=, bg=, italic=,
---                         --   bold=, underline=, sp=, link=}; merged over the
---                         --   group spec and applied LAST; `link` is applied
---                         --   as a link-only override.
---   variants    = {}     -- map "dark"|"light" -> option table; the fields
---                         --   of the variant table are deep-merged OVER the
---                         --   global options when that variant loads, so a
---                         --   variant can override transparent/italics/
---                         --   styles/overrides without repeating the rest
--                         --   (e.g. { variants = { light = { transparent = true } } })
M.options = {
  transparent = false,
  italics = true,
  styles = {},
  overrides = {},
  variants = {},
}

--- Configure Turtle Glasses. Deep-merges the given options over the defaults.
--- @param opts table|nil
function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

function M.load(variant)
  local palette_mod = require("turtle-glasses.palette")
  local key = variant == "light" and "light" or "dark"
  if not palette_mod[key] then
    error("Turtle Glasses: unknown variant '" .. tostring(variant) .. "'", 0)
  end
  local palette = palette_mod[key]
  vim.o.background = key == "light" and "light" or "dark"

  require("turtle-glasses.terminal").set_term_colors(palette)

  -- Full coverage for both variants: every highlight group comes from the
  -- shared palette-driven modules (ui/syntax/treesitter/lsp); the active
  -- palette variant decides the colors, including the alpha-composite base.
  require("turtle-glasses.theme").build(palette, M.options)
end

return M