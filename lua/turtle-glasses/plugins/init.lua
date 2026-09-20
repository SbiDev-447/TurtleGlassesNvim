-- plugins/init.lua — index of the Turtle Glasses plugin integrations.
-- Concatenates the per-plugin group maps in a stable order.

local M = {}

--- Build the merged plugin highlight map for a palette variant.
--- @param palette table  a variant from lua/turtle-glasses/palette.lua
--- @param options table  the resolved plugin options
--- @return table          group name -> highlight spec
function M.groups(palette, options)
  local opts = options or {}
  local modules = {
    require("turtle-glasses.plugins.telescope"),
    require("turtle-glasses.plugins.lualine"),
    require("turtle-glasses.plugins.gitsigns"),
    require("turtle-glasses.plugins.whichkey"),
    require("turtle-glasses.plugins.cmp"),
    require("turtle-glasses.plugins.indent_blankline"),
    require("turtle-glasses.plugins.bufferline"),
    require("turtle-glasses.plugins.noice"),
    require("turtle-glasses.plugins.notify"),
    require("turtle-glasses.plugins.nvim_tree"),
    require("turtle-glasses.plugins.neo_tree"),
    require("turtle-glasses.plugins.dap"),
    require("turtle-glasses.plugins.flash"),
    require("turtle-glasses.plugins.mini"),
  }

  local merged = {}
  for _, mod in ipairs(modules) do
    for name, spec in pairs(mod.groups(palette, opts)) do
      merged[name] = spec
    end
  end
  return merged
end

return M