# Changelog

All notable changes to this project are documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.0] — 2026-09-20

Integrations 2026 round: snacks.nvim on the full surface plus four more plugins.

### Added

- snacks.nvim: normal/winbar chrome, notifier with the full severity matrix, dashboard, statuscolumn, indent guides (1–8), input dialogs, and picker kinds (file/git/undo/lsp).
- trouble.nvim: window, list, count, directory, and icon rows (severities reuse the `Diagnostic*` family).
- aerial.nvim: `AerialLine`/`AerialGuide` plus kind icons mapped to the `symbolIcon.*` palette family.
- render-markdown.nvim: `RenderMarkdownH1`–`H6` + background, code/inline surfaces, tables, quote depth, checkboxes, and callout severities.
- toggleterm.nvim: `ToggleTerm1`–`4` float trios and `Normal`/`SignColumn`/`EndOfBuffer` from the `terminal.*` family.
- README plugin-support table covering the new integrations.

## [0.2.0] — 2026-09-19

Integrations and options round: eight more plugins, per-variant options, `dim_inactive`, and three new style families.

### Added

- Plugin integrations: bufferline.nvim, nvim-noice, nvim-notify (per-severity titles), nvim-tree.lua, neo-tree.nvim, nvim-dap-ui, flash.nvim, and mini.nvim (indentscope incl. light syntax, statusline mode chips).
- Per-variant options layer: `variants.<variant>` can override any base option for `dark` or `light`.
- `dim_inactive` option: dims inactive-window chrome (`NormalNC`, `SignColumnNC`, `CursorLineNC`) and enables `vim.wo.dim_inactive` (Neovim >= 0.11, skipped safely on older versions).
- New style families: `constant`, `label`, and `title`.
- CI via GitHub Actions: luacheck lint job plus headless smoke/contrast test job (paths-filtered).
- `scripts/contrast_check.lua` audit tool (WCAG contrast, optional allowlist and custom thresholds).

### Fixed

- Low-contrast light-variant fixes surfaced by the contrast audit (`CurSearch`, warning-diagnostics sign chip legibility).

### Changed

- README: documented `variants`, `dim_inactive`, the new style families, and the plugin support table.

## [0.1.0] — 2026-09-18

Initial release of the Turtle Glasses colorscheme for Neovim.

### Added

- Both theme variants: `turtle-glasses-dark` and `turtle-glasses-light`.
- Palette extractor (`scripts/extract_palette.lua`) that regenerates `lua/turtle-glasses/palette.lua` from the Turtle Glasses VS Code theme JSONs, with validation (370 colors and 74 token rules per variant).
- Theme options: `transparent`, `italics`, `styles`, and `overrides`.
- Plugin integrations: telescope.nvim, lualine.nvim, gitsigns.nvim, which-key.nvim, nvim-cmp, and indent-blankline.nvim.
- Headless smoke test (`scripts/smoke_test.lua`) covering both variants and the options path.