# Changelog

All notable changes to this project are documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] — 2026-09-18

Initial release of the Turtle Glasses colorscheme for Neovim.

### Added

- Both theme variants: `turtle-glasses-dark` and `turtle-glasses-light`.
- Palette extractor (`scripts/extract_palette.lua`) that regenerates `lua/turtle-glasses/palette.lua` from the Turtle Glasses VS Code theme JSONs, with validation (370 colors and 74 token rules per variant).
- Theme options: `transparent`, `italics`, `styles`, and `overrides`.
- Plugin integrations: telescope.nvim, lualine.nvim, gitsigns.nvim, which-key.nvim, nvim-cmp, and indent-blankline.nvim.
- Headless smoke test (`scripts/smoke_test.lua`) covering both variants and the options path.