-- scripts/smoke_test.lua — repeatable headless smoke test for Turtle Glasses Nvim.
--
-- Run from the repository root:
--   nvim --headless -l scripts/smoke_test.lua
--
-- Loads both variants plus the options path, asserts expected highlight
-- values, and exits 0 on success / 1 with a failure list on any mismatch.
-- Each `-l` run is one fresh process, so the script needs no cleanup.

-- Resolve the repository root from this script's own path: scripts/ sits one
-- level below the root, so the parent of this file's parent is the root.
local script = vim.fn.fnamemodify(arg[0], ":p")
local repo_root = vim.fn.fnamemodify(script, ":h:h")
vim.opt.rtp:prepend(repo_root)

local failures = {}
local checks = 0

--- Format a raw color value as 6-digit lowercase hex; NONE/nil stays readable.
local function hex(v)
  return v and string.format("#%06x", v) or "NONE"
end

local function fail(label, got)
  failures[#failures + 1] = string.format("%s — got %s", label, got)
end

--- Assert that a highlight group was actually set (non-empty spec).
local function expect_exists(group)
  checks = checks + 1
  local h = vim.api.nvim_get_hl(0, { name = group })
  if h == nil or next(h) == nil then
    fail(group .. " is not set", h == nil and "nil" or "empty spec")
  end
end

--- Assert a group's color field equals expected (6-digit hex, case-insensitive).
local function expect_color(group, field, expected)
  checks = checks + 1
  local h = vim.api.nvim_get_hl(0, { name = group })
  local got = h and h[field] or nil
  local got_hex = hex(got)
  if string.lower(got_hex) ~= string.lower(expected) then
    fail(string.format("%s %s == %s", group, field, expected), got_hex)
  end
end

--- Assert a boolean attribute on a group.
local function expect_attr(group, field, expected)
  checks = checks + 1
  local h = vim.api.nvim_get_hl(0, { name = group })
  local got = h and h[field] or nil
  if got ~= expected then
    fail(string.format("%s %s == %s", group, field, tostring(expected)), type(got) == "boolean" and tostring(got) or "nil")
  end
end

--- Assert that a group carries a solid (non-NONE) foreground color.
local function expect_solid_fg(group)
  checks = checks + 1
  local h = vim.api.nvim_get_hl(0, { name = group })
  local fg = h and h.fg or nil
  if type(fg) ~= "number" then
    fail(group .. " fg is a solid color", type(fg) == "number" and hex(fg) or "NONE/nil")
  end
end

local function load(variant)
  vim.cmd("colorscheme turtle-glasses-" .. variant)
end

-- Dark variant --------------------------------------------------------------
load("dark")

expect_color("Normal", "fg", "#f3f6f9")
expect_color("Normal", "bg", "#06080f")
expect_color("Comment", "fg", "#8394a3")
expect_attr("Comment", "italic", true)
expect_color("LineNr", "fg", "#3a4a75")
expect_color("GitSignsAdd", "fg", "#b7cc85")
expect_solid_fg("CmpItemKindFunction")
expect_exists("TelescopeBorder")
expect_color("IblScope", "fg", "#232a40")
expect_color("LualineAMode", "fg", "#f3f6f9")

-- Light variant -------------------------------------------------------------
load("light")

expect_color("Normal", "fg", "#2a2a2a")
expect_color("Normal", "bg", "#f5efe6")
expect_color("Comment", "fg", "#6a6a6a")
expect_attr("Comment", "italic", true)
expect_color("LineNr", "fg", "#b8b0a0")

checks = checks + 1
if string.lower(vim.g.terminal_color_1 or "") ~= "#b85a7a" then
  fail("terminal_color_1 == #b85a7a", tostring(vim.g.terminal_color_1))
end

-- Options path: user overrides applied last, on top of the base theme --------
require("turtle-glasses").setup({ overrides = { Comment = { fg = "#ff0000" } } })
load("dark")

expect_color("Comment", "fg", "#ff0000")

-- Per-variant options: the variant's option table deep-merges OVER the global
-- options, so a dark-only override wins on dark while light keeps the global.
require("turtle-glasses").setup({
  overrides = { Comment = { fg = "#ffffff" } },
  variants = { dark = { overrides = { Comment = { fg = "#123456" } } } },
})
load("dark")
expect_color("Comment", "fg", "#123456")
load("light")
expect_color("Comment", "fg", "#ffffff")

-- Summary --------------------------------------------------------------------
if #failures > 0 then
  for _, f in ipairs(failures) do
    io.stderr:write("smoke: FAIL  " .. f .. "\n")
  end
  io.stderr:write(string.format("smoke: FAIL (%d/%d checks passed)\n", checks - #failures, checks))
  os.exit(1)
end

print(string.format("smoke: PASS (%d checks)", checks))