-- scripts/dump-highlights.lua
-- Run: nvim -l scripts/dump-highlights.lua [variant] [out.json]
-- Dumps all matcha highlight groups to JSON for snapshot comparison.
local root = vim.fn.getcwd()
package.path = root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path

local matcha = require("matcha")

local args = { ... }  -- trailing args after the script with `nvim -l script ...`
local variant = args[1] or "morning"
local out = args[2] or (root .. "/previews/highlights-" .. variant .. ".json")

vim.fn.mkdir(vim.fn.fnamemodify(out, ":h"), "p")

matcha.setup({ variant = variant, terminal_colors = false })
local hl = matcha.load(variant)

-- normalize link tables and drop empty
local normalized = {}
for name, val in pairs(hl) do
  if type(val) == "table" then
    local entry = {}
    if val.fg then entry.fg = type(val.fg) == "string" and val.fg or string.format("#%06X", val.fg) end
    if val.bg then entry.bg = type(val.bg) == "string" and val.bg or string.format("#%06X", val.bg) end
    if val.sp then entry.sp = type(val.sp) == "string" and val.sp or string.format("#%06X", val.sp) end
    if val.link then entry.link = val.link end
    if val.bold then entry.bold = true end
    if val.italic then entry.italic = true end
    if val.underline then entry.underline = true end
    if val.undercurl then entry.undercurl = true end
    if val.strikethrough then entry.strikethrough = true end
    if next(entry) then normalized[name] = entry end
  end
end

local f = io.open(out, "w")
f:write(vim.json.encode(normalized))
f:close()
io.write(out, "\n")
