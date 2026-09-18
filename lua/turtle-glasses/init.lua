local M = {}

M.options = {
  transparent = false,
  italics = true,
  styles = {},
  overrides = {},
}

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