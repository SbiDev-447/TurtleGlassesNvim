" Turtle Glasses Light — Neovim colorscheme
highlight clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "turtle-glasses-light"
lua require("turtle-glasses").load("light")