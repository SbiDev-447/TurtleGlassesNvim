-- Turtle Glasses Neovim — Phase 0 palette extractor.
--
-- Parses the Turtle Glasses VS Code theme JSONs and generates
-- lua/turtle-glasses/palette.lua with exact hex fidelity.
--
-- Usage:
--   nvim --headless -l scripts/extract_palette.lua [dark-path] [light-path]

local DARK_PATH = "/home/sbi/turtleShell/TurtleGlassesTheme/TurtleGlassesVSCode/themes/turtle-glasses-dark.json"
local LIGHT_PATH = "/home/sbi/turtleShell/TurtleGlassesTheme/TurtleGlassesVSCode/themes/turtle-glasses-light.json"

-- Expected counts; must match the source theme JSONs.
local EXPECTED_COLORS = 370
local EXPECTED_TOKENS = 74

local LUA_KEYWORDS = {}
for _, kw in ipairs({
  "and", "break", "do", "else", "elseif", "end",
  "false", "for", "function", "if", "in", "local",
  "nil", "not", "or", "repeat", "return", "then",
  "true", "until", "while",
}) do
  LUA_KEYWORDS[kw] = true
end

local function is_identifier(s)
  if LUA_KEYWORDS[s] then
    return false
  end
  return s:match("^[%a_][%w_]*$") ~= nil
end

local function tcount(t)
  local n = 0
  for _ in pairs(t) do
    n = n + 1
  end
  return n
end

local function quote(s)
  s = tostring(s)
  return '"' .. s:gsub('[%c\\"]', function(c)
    if c == '"' then
      return '\\"'
    elseif c == "\\" then
      return "\\\\"
    elseif c == "\n" then
      return "\\n"
    elseif c == "\r" then
      return "\\r"
    elseif c == "\t" then
      return "\\t"
    end
    return string.format("\\%03d", c:byte())
  end) .. '"'
end

local function format_number(n)
  if n == math.floor(n) and math.abs(n) < 2 ^ 53 then
    return string.format("%d", n)
  end
  return tostring(n)
end

local function is_array(t)
  local n = #t
  if n == 0 then
    for _ in pairs(t) do
      return false
    end
    return false
  end
  for i = 1, n do
    if t[i] == nil then
      return false
    end
  end
  for k in pairs(t) do
    if type(k) ~= "number" or k < 1 or k > n or k % 1 ~= 0 then
      return false
    end
  end
  return true
end

local function ordered_keys(t, prefer)
  local seen, ordered, rest = {}, {}, {}
  if prefer then
    for _, k in ipairs(prefer) do
      if t[k] ~= nil then
        ordered[#ordered + 1] = k
        seen[k] = true
      end
    end
  end
  for k in pairs(t) do
    if not seen[k] then
      rest[#rest + 1] = k
    end
  end
  table.sort(rest)
  for _, k in ipairs(rest) do
    ordered[#ordered + 1] = k
  end
  return ordered
end

local serialize_compact

-- Preferred key order for nested value objects, matching the source JSON
-- (settings and semantic token entries always list "foreground" first).
local VALUE_KEY_PREFER = { "foreground", "fontStyle" }

local function serialize_value_compact(v, prefer)
  local tv = type(v)
  if tv == "nil" then
    return "nil"
  elseif tv == "boolean" then
    return v and "true" or "false"
  elseif tv == "number" then
    return format_number(v)
  elseif tv == "string" then
    return quote(v)
  elseif tv == "table" then
    return serialize_compact(v, prefer)
  end
  error("Turtle Glasses: cannot serialize value of type " .. tv, 0)
end

serialize_compact = function(t, prefer)
  if is_array(t) then
    local parts = {}
    for i = 1, #t do
      parts[#parts + 1] = serialize_value_compact(t[i], VALUE_KEY_PREFER)
    end
    return "{ " .. table.concat(parts, ", ") .. " }"
  end
  local parts = {}
  for _, k in ipairs(ordered_keys(t, prefer)) do
    local kp = is_identifier(k) and k or ("[" .. quote(k) .. "]")
    parts[#parts + 1] = kp .. " = " .. serialize_value_compact(t[k], VALUE_KEY_PREFER)
  end
  if #parts == 0 then
    return "{}"
  end
  return "{ " .. table.concat(parts, ", ") .. " }"
end

-- One line per sorted key: '    ["key"] = value,' (or '    key = value,' for
-- identifier keys). Values are serialized compactly. With force_bracket the
-- key is always written as ["key"] — used for the colors map.
local function serialize_map_entries(t, indent, force_bracket)
  local keys = {}
  for k in pairs(t) do
    keys[#keys + 1] = k
  end
  table.sort(keys)
  local lines = {}
  for _, k in ipairs(keys) do
    local kp
    if force_bracket or not is_identifier(k) then
      kp = "[" .. quote(k) .. "]"
    else
      kp = k
    end
    lines[#lines + 1] = indent .. kp .. " = " .. serialize_value_compact(t[k]) .. ","
  end
  return lines
end

local function emit_variant(entry)
  local lines = {}
  lines[#lines + 1] = "M." .. entry.type .. " = {"
  lines[#lines + 1] = "  name = " .. quote(entry.name or "") .. ","
  lines[#lines + 1] = "  type = " .. quote(entry.type) .. ","
  lines[#lines + 1] = "  colors = {"
  for _, l in ipairs(serialize_map_entries(entry.colors, "    ", true)) do
    lines[#lines + 1] = l
  end
  lines[#lines + 1] = "  },"
  lines[#lines + 1] = "  tokens = {"
  for _, rule in ipairs(entry.tokens) do
    lines[#lines + 1] = "    " .. serialize_compact(rule, { "name", "scope", "settings" }) .. ","
  end
  lines[#lines + 1] = "  },"
  if entry.semantic_token_colors ~= nil then
    lines[#lines + 1] = "  semanticTokenColors = {"
    for _, l in ipairs(serialize_map_entries(entry.semantic_token_colors, "    ")) do
      lines[#lines + 1] = l
    end
    lines[#lines + 1] = "  },"
  else
    lines[#lines + 1] = "  semanticTokenColors = nil,"
  end
  lines[#lines + 1] = "}"
  return lines
end

local args = { ... }
if #args == 0 then
  -- nvim -l passes the script arguments via the Lua `arg` global.
  for i = 1, #arg do
    if arg[i] ~= nil then
      args[#args + 1] = tostring(arg[i])
    end
  end
end
if args[1] == "--" then
  table.remove(args, 1)
end

local dark_path = args[1] or DARK_PATH
local light_path = args[2] or LIGHT_PATH

local function read_theme(path)
  if vim.fn.filereadable(path) ~= 1 then
    error("Turtle Glasses: theme file not readable: " .. path, 0)
  end
  local lines = vim.fn.readfile(path)
  if lines == nil or #lines == 0 then
    error("Turtle Glasses: theme file is empty: " .. path, 0)
  end
  local ok, decoded = pcall(vim.json.decode, table.concat(lines, "\n"))
  if not ok then
    error("Turtle Glasses: invalid JSON in " .. path .. ": " .. tostring(decoded), 0)
  end
  return decoded
end

local function extract_variant(expected_type, path)
  local data = read_theme(path)
  local t = data.type
  if t ~= expected_type then
    error(
      "Turtle Glasses: " .. path .. " has type '" .. tostring(t) .. "', expected '" .. expected_type .. "'",
      0
    )
  end
  local colors = data.colors or {}
  local tokens = data.tokenColors or {}
  local got_colors, got_tokens = tcount(colors), tcount(tokens)
  if got_colors ~= EXPECTED_COLORS or got_tokens ~= EXPECTED_TOKENS then
    error(string.format(
      "Turtle Glasses: %s: expected %d colors and %d token rules, got %d colors and %d token rules",
      expected_type, EXPECTED_COLORS, EXPECTED_TOKENS, got_colors, got_tokens
    ), 0)
  end
  return {
    type = t,
    name = data.name,
    colors = colors,
    tokens = tokens,
    semantic_token_colors = data.semanticTokenColors,
  }
end

local dark = extract_variant("dark", dark_path)
local light = extract_variant("light", light_path)

local out_lines = {
  "-- AUTO-GENERATED by scripts/extract_palette.lua — DO NOT EDIT",
  "local M = {}",
  "",
}
for _, entry in ipairs({ dark, light }) do
  for _, l in ipairs(emit_variant(entry)) do
    out_lines[#out_lines + 1] = l
  end
  out_lines[#out_lines + 1] = ""
end
out_lines[#out_lines + 1] = "return M"

local function palette_output_path()
  local src = debug.getinfo(1, "S").source or ""
  local script_dir
  if src:sub(1, 1) == "@" then
    script_dir = vim.fn.fnamemodify(src:sub(2), ":p:h")
  else
    script_dir = vim.fn.getcwd()
  end
  local repo_root = vim.fn.fnamemodify(script_dir, ":h")
  return repo_root .. "/lua/turtle-glasses/palette.lua"
end

local out_path = palette_output_path()
vim.fn.mkdir(vim.fn.fnamemodify(out_path, ":h"), "p")
local write_ok, write_err = pcall(vim.fn.writefile, out_lines, out_path)
if not write_ok then
  error("Turtle Glasses: failed to write " .. out_path .. ": " .. tostring(write_err), 0)
end

print(string.format("dark: %d colors, %d token rules", tcount(dark.colors), tcount(dark.tokens)))
print(string.format("light: %d colors, %d token rules", tcount(light.colors), tcount(light.tokens)))