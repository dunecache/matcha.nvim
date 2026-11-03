-- scripts/check-provenance.lua
-- Run: nvim -l scripts/check-provenance.lua
-- Verifies every color applied to a highlight group is a canonical token value
-- or a documented derivation (blend of canonical tokens).
local root = vim.fn.getcwd()
package.path = root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path

local matcha = require("matcha")
local derive = require("matcha.derive")
local meta = require("matcha.palette._meta")

local function collect(p)
  local vals = {}
  for _, sub in ipairs({ "primitive", "syntax", "terminal", "markdown", "diff" }) do
    for _, v in pairs(p[sub] or {}) do
      if type(v) == "string" and v:match("^#") then vals[v:upper()] = true end
    end
  end
  for _, v in pairs(p) do
    if type(v) == "string" and v:match("^#") then vals[v:upper()] = true end
  end
  for _, v in ipairs(p.charts or {}) do
    if type(v) == "string" and v:match("^#") then vals[v:upper()] = true end
  end
  return vals
end

local failures = 0
local checked = 0

local function check_variant(variant)
  matcha.setup({ variant = variant, terminal_colors = false })
  local hl = matcha.load(variant)
  local palette = require("matcha.palette." .. variant)
  local allowed = collect(palette)

  local tokens = {}
  for k in pairs(allowed) do table.insert(tokens, k) end

  local function traceable(hex)
    hex = hex:upper()
    if allowed[hex] then return true end
    -- documented derivations are blends of two canonical tokens at 0.10 / 0.25 / 0.5
    for _, a in ipairs(tokens) do
      for _, b in ipairs(tokens) do
        for _, f in ipairs({ 0.10, 0.25, 0.5 }) do
          if derive.blend(a, b, f):upper() == hex then return true end
        end
      end
    end
    return false
  end

  for name, val in pairs(hl) do
    if type(val) == "table" then
      for _, field in ipairs({ "fg", "bg", "sp" }) do
        local v = val[field]
        if type(v) == "string" and v:match("^#%x%x%x%x%x%x$") then
          checked = checked + 1
          if not traceable(v) then
            failures = failures + 1
            print(string.format("%-9s %s.%s = %s not traceable to token/derivation", variant, name, field, v))
          end
        end
      end
    end
  end
end

check_variant("morning")
check_variant("evening")
print(string.format("provenance: design_system_version=%s, %d colors checked, %d failures", meta.design_system_version, checked, failures))
if failures > 0 then vim.cmd("cq") end
