-- terminal.lua — maps the palette's ANSI 16 colors onto Neovim's terminal
-- color variables (g:terminal_color_0..15 and g:terminal_ansi_colors).

local M = {}

local ANSI_KEYS = {
  "terminal.ansiBlack",
  "terminal.ansiRed",
  "terminal.ansiGreen",
  "terminal.ansiYellow",
  "terminal.ansiBlue",
  "terminal.ansiMagenta",
  "terminal.ansiCyan",
  "terminal.ansiWhite",
  "terminal.ansiBrightBlack",
  "terminal.ansiBrightRed",
  "terminal.ansiBrightGreen",
  "terminal.ansiBrightYellow",
  "terminal.ansiBrightBlue",
  "terminal.ansiBrightMagenta",
  "terminal.ansiBrightCyan",
  "terminal.ansiBrightWhite",
}

--- Set the 16 terminal colors from a palette variant.
--- @param palette table  a variant from lua/turtle-glasses/palette.lua
function M.set_term_colors(palette)
  local c = palette.colors
  local list = {}
  for i, key in ipairs(ANSI_KEYS) do
    list[i] = c[key] -- list[1] = ansi 0 ... list[16] = ansi 15
  end
  for i = 0, 15 do
    vim.g["terminal_color_" .. i] = list[i + 1]
  end
  vim.g.terminal_ansi_colors = list
end

return M