-- scripts/build-palette.lua
-- Run: nvim -l scripts/build-palette.lua
local root = vim.fn.getcwd()
local tokens_dir = root .. "/tokens"
local out_dir = root .. "/lua/matcha/palette"

local function read_json(path)
  local f = io.open(path, "r")
  local content = f:read("*a")
  f:close()
  return vim.json.decode(content)
end

local function to_snake(s)
  return s:gsub("-", "_")
end

-- Lua reserved words that cannot be bare table keys
local KEYWORDS = {}
for _, kw in ipairs({
  "and", "break", "do", "else", "elseif", "end", "false", "for", "function",
  "goto", "if", "in", "local", "nil", "not", "or", "repeat", "return", "then",
  "true", "until", "while",
}) do
  KEYWORDS[kw] = true
end

local function dump_lua(t, indent)
  indent = indent or ""
  if type(t) == "table" then
    if #t > 0 and type(t[1]) == "string" then
      -- array of strings
      local parts = {}
      for _, v in ipairs(t) do table.insert(parts, string.format("%q", v)) end
      return "{ " .. table.concat(parts, ", ") .. " }"
    end
    local lines = { "{" }
    local keys = {}
    for k in pairs(t) do table.insert(keys, k) end
    table.sort(keys, function(a, b)
      if type(a) == type(b) then
        if type(a) == "number" then return a < b end
        return tostring(a) < tostring(b)
      end
      return tostring(a) < tostring(b)
    end)
    for _, k in ipairs(keys) do
      local v = t[k]
      local key
      if type(k) == "number" then
        key = "[" .. k .. "]"
      else
        local snake = to_snake(k)
        if snake:match("^[%a_][%w_]*$") and not KEYWORDS[snake] then
          key = snake
        else
          key = "[" .. string.format("%q", snake) .. "]"
        end
      end
      table.insert(lines, indent .. "  " .. key .. " = " .. dump_lua(v, indent .. "  ") .. ",")
    end
    table.insert(lines, indent .. "}")
    return table.concat(lines, "\n")
  elseif type(t) == "string" then
    return string.format("%q", t)
  else
    return tostring(t)
  end
end

local variants = {
  { name = "morning", token_key = "morning-matcha", file = "morning.lua" },
  { name = "evening", token_key = "evening-zen", file = "evening.lua" },
}

for _, v in ipairs(variants) do
  local semantic = read_json(tokens_dir .. "/semantic/" .. v.token_key .. ".json")
  local primitives = read_json(tokens_dir .. "/primitives/" .. v.token_key .. ".json")
  local syntax = read_json(tokens_dir .. "/syntax.json")
  local terminal = read_json(tokens_dir .. "/terminal.json")
  local markdown = read_json(tokens_dir .. "/markdown.json")
  local diff = read_json(tokens_dir .. "/diff.json")
  local charts = read_json(tokens_dir .. "/charts.json")

  local p = {}
  -- semantic color
  p.color = {}
  for k, val in pairs(semantic.color) do
    p.color[to_snake(k)] = val["$value"]
  end
  -- flatten semantic to top-level too (p.background etc.)
  for k, val in pairs(semantic.color) do
    p[to_snake(k)] = val["$value"]
  end
  -- primitives
  p.primitive = {}
  for k, val in pairs(primitives.color) do
    p.primitive[to_snake(k)] = val["$value"]
  end
  -- syntax
  p.syntax = {}
  for k, val in pairs(syntax.syntax[v.token_key]) do
    p.syntax[to_snake(k)] = val
  end
  -- terminal
  p.terminal = {}
  for k, val in pairs(terminal.terminal[v.token_key]) do
    p.terminal[to_snake(k)] = val
  end
  -- markdown
  p.markdown = {}
  for k, val in pairs(markdown.markdown[v.token_key]) do
    p.markdown[to_snake(k)] = val
  end
  -- diff
  p.diff = {}
  for k, val in pairs(diff.diff[v.token_key]) do
    p.diff[to_snake(k)] = val
  end
  -- charts
  p.charts = charts.charts[v.token_key]

  local version = vim.fn.readfile(tokens_dir .. "/TOKENS_VERSION")[1]
  local header = "-- GENERATED FILE — DO NOT EDIT\n-- design_system_version: " .. version .. "\n\n"
  local body = "return " .. dump_lua(p) .. "\n"
  local out_path = out_dir .. "/" .. v.file
  local f = io.open(out_path, "w")
  f:write(header .. body)
  f:close()
  print("wrote " .. out_path)
end

-- _meta.lua
local version = vim.fn.readfile(tokens_dir .. "/TOKENS_VERSION")[1]
local meta = io.open(out_dir .. "/_meta.lua", "w")
meta:write("return {\n  design_system_version = " .. string.format("%q", version) .. ",\n}\n")
meta:close()
print("wrote " .. out_dir .. "/_meta.lua")
