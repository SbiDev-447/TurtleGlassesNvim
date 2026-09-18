# Turtle Glasses — Neovim colorscheme

A Neovim colorscheme based on the Turtle Glasses VS Code theme (TurtleGlassesVSCode, v0.2.4, MIT), reproducing both variants with exact hex fidelity.

## Variants

| Variant | Command |
| --- | --- |
| Dark | `:colorscheme turtle-glasses-dark` |
| Light | `:colorscheme turtle-glasses-light` |

## Status

WIP — Phase 0 scaffold.

## Installation

With lazy.nvim:

```lua
{ "SbiDev-447/TurtleGlassesNvim", lazy = false, priority = 1000 }
```

The palette module (`lua/turtle-glasses/palette.lua`) is generated from the VS Code theme JSONs by `scripts/extract_palette.lua` — do not edit it by hand.