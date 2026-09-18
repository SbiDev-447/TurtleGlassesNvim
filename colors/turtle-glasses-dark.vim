" Turtle Glasses Dark — Neovim colorscheme
highlight clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "turtle-glasses-dark"
lua require("turtle-glasses").load("dark")