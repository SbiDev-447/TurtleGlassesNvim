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
  local palette = require("turtle-glasses.palette")
  local key = variant == "light" and "light" or "dark"
  if not palette[key] then
    error("Turtle Glasses: unknown variant '" .. tostring(variant) .. "'", 0)
  end
  vim.o.background = key == "light" and "light" or "dark"
  -- Highlight application lands in later phases.
end

return M