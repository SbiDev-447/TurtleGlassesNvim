# Turtle Glasses — Neovim colorscheme

A Neovim colorscheme faithfully ported from the [Turtle Glasses VS Code theme](https://github.com/SbiDev-447/TurtleGlassesVSCode), with dark and light variants at exact hex fidelity to the source.

![CI](https://github.com/SbiDev-447/TurtleGlassesNvim/actions/workflows/ci.yml/badge.svg)

## Features

- Two variants: `turtle-glasses-dark` and `turtle-glasses-light`.
- Exact palette fidelity: every color comes verbatim from the Turtle Glasses VS Code theme JSONs.
- Lua-only implementation, no external dependencies.
- Options: transparent background, italics master switch, per-family font styles, per-group overrides.
- Built-in integrations: telescope.nvim, lualine.nvim, gitsigns.nvim, which-key.nvim, nvim-cmp, and indent-blankline.nvim are supported out of the box.
- Zero hardcoded colors: `lua/turtle-glasses/palette.lua` is generated from the source theme and can be regenerated at any time.

## Requirements

- Neovim >= 0.9
- A truecolor terminal (`termguicolors` enabled)

## Installation

With lazy.nvim:

```lua
{
  "SbiDev-447/TurtleGlassesNvim",
  lazy = false,
  priority = 1000,
}
```

## Usage

```vim
:colorscheme turtle-glasses-dark
:colorscheme turtle-glasses-light
```

The light variant follows the standard `set background=light` pattern and sets `background` itself, so both variants play well with `background`-aware plugins.

Call `require("turtle-glasses").setup(...)` **before** the `:colorscheme` command — options are consumed when the theme loads. With lazy.nvim, keep `setup` in the plugin spec above and issue `:colorscheme` afterwards (for example in your config after `lazy.setup`).

## Options

```lua
require("turtle-glasses").setup({
  transparent = false, -- boolean: chrome/editor line groups get bg = "NONE"
  italics     = true,  -- boolean master switch: false strips italic everywhere
  styles      = {},    -- map family -> "italic" | "bold" | "underline" | "NONE"
  overrides   = {},    -- map HL group -> attr table, applied last
})
```

### transparent

Makes the editor chrome transparent: `Normal`, `NormalFloat`, `LineNr`, `CursorLine`, `Pmenu`, and other decorative groups lose their background while syntax colors stay intact.

```lua
require("turtle-glasses").setup({ transparent = true })
```

### italics

Master switch for italic text. `true` keeps the palette's italic styles (for example `Comment`); `false` strips italic from every group, including treesitter and plugin groups.

```lua
require("turtle-glasses").setup({ italics = false })
```

### styles

Overrides the font style of a whole family of groups. Each family maps to the groups its palette style applies to:

| Family | Groups |
| --- | --- |
| `comment` | `Comment`, `@comment`, `@comment.documentation` |
| `keyword` | `Keyword`, `@keyword`, `@keyword.*` |
| `function` | `Function`, `@function`, `@function.*` |
| `type` | `Type`, `@type`, `@type.*` |
| `variable` | `Identifier`, `@variable` |
| `operator` | `Operator`, `@operator` |
| `string` | `String`, `@string`, `@string.*` |
| `number` | `Number`, `@number` |

```lua
require("turtle-glasses").setup({
  styles = {
    comment = "italic",
    keyword = "bold",
    string  = "NONE", -- clears bold/italic/underline on strings
  },
})
```

### overrides

Per-group attribute table, merged over the group spec and applied last — the highest-priority option:

```lua
require("turtle-glasses").setup({
  overrides = {
    Comment = { fg = "#ff0000", italic = true }, -- tune a single group
  },
})
```

Supported attributes: `fg`, `bg`, `italic`, `bold`, `underline`, `sp`, and `link` (a pure link override).

## Plugin support

| Plugin | Covered groups |
| --- | --- |
| telescope.nvim | `TelescopeBorder`, `TelescopeTitle`, `TelescopeSelection`, `TelescopeMatching`, and more |
| lualine.nvim | `LualineA/B/C` sections, separators, fills, and mode variants |
| gitsigns.nvim | `GitSignsAdd/Change/Delete`, line and number-column variants, blame |
| which-key.nvim | `WhichKey*` family |
| nvim-cmp | `CmpItemKind*` by semantic family, `CmpPmenu*`, `CmpDoc*` |
| indent-blankline.nvim | `IblIndent`, `IblScope`, `IblWhitespace` (v3) |

All integrations are applied unconditionally at load time — the groups are harmless when the plugin is absent, so nothing extra is required.

## Regenerating the palette

`lua/turtle-glasses/palette.lua` is generated from the Turtle Glasses VS Code theme JSONs. After updating the source theme, regenerate it:

```sh
nvim --headless -l scripts/extract_palette.lua
```

The extractor validates the source before writing — it expects exactly 370 colors and 74 token rules per variant and fails without writing if the counts don't match. It also accepts explicit theme paths as arguments (`scripts/extract_palette.lua <dark-path> <light-path>`). Do not edit `palette.lua` by hand.

## Development

Run the repeatable headless smoke test from the repository root:

```sh
nvim --headless -l scripts/smoke_test.lua
```

It loads both variants plus the options path, asserts 17 expected highlight values, and exits 0 on success or 1 with a failure list.

## License

MIT — same as [TurtleGlassesVSCode](https://github.com/SbiDev-447/TurtleGlassesVSCode).