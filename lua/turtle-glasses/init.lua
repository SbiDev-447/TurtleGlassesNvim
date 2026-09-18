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
M.options = {
  transparent = false,
  italics = true,
  styles = {},
  overrides = {},
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

  if key == "dark" then
    -- Phase 1: full dark variant coverage.
    require("turtle-glasses.theme").build(palette, M.options)
  else
    -- Light variant: minimal apply so the scheme loads cleanly; full light
    -- coverage lands in T2.
    local colors = palette.colors
    vim.api.nvim_set_hl(0, "Normal", {
      fg = colors["editor.foreground"],
      bg = M.options.transparent and "NONE" or colors["editor.background"],
    })
  end
end

return M