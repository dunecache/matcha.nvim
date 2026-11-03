-- scripts/gen-preview.lua
-- Run: nvim -l scripts/gen-preview.lua
-- Generates HTML swatches for both variants into previews/.
local root = vim.fn.getcwd()
package.path = root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path

local out_dir = root .. "/previews"
vim.fn.mkdir(out_dir, "p")

local function swatch(variant)
  local p = require("matcha.palette." .. variant)
  local semantic = {}
  for k, v in pairs(p) do
    if type(v) == "string" and v:match("^#%x%x%x%x%x%x$") then
      table.insert(semantic, { k, v })
    end
  end
  table.sort(semantic, function(a, b) return a[1] < b[1] end)

  local lines = {
    "<!doctype html><meta charset=utf-8><title>Kanso Matcha — " .. variant .. "</title>",
    "<style>body{background:" .. p.background .. ";color:" .. p.text_primary
      .. ";font-family:sans-serif;padding:24px}.w{display:inline-block;margin:6px}",
    ".c{width:120px;height:48px;border-radius:6px;border:1px solid " .. p.border_subtle .. "}small{display:block}</style>",
    "<h1>Kanso Matcha — " .. variant .. "</h1>",
  }
  for _, s in ipairs(semantic) do
    table.insert(lines, string.format(
      '<div class="w"><div class="c" style="background:%s"></div><small>%s %s</small></div>',
      s[2], s[1], s[2]))
  end
  -- syntax
  table.insert(lines, "<h2>Syntax</h2>")
  for k, v in pairs(p.syntax) do
    if type(v) == "string" then
      table.insert(lines, string.format(
        '<div class="w"><div class="c" style="background:%s"></div><small>syntax.%s %s</small></div>',
        v, k, v))
    end
  end

  local f = io.open(out_dir .. "/swatches-" .. variant .. ".html", "w")
  f:write(table.concat(lines, "\n"))
  f:close()
  print("wrote " .. out_dir .. "/swatches-" .. variant .. ".html")
end

swatch("morning")
swatch("evening")
