-- tests/provenance_spec.lua
-- No raw hex in highlight groups: every color is a canonical token or documented derivation.
local matcha = require("matcha")
local derive = require("matcha.derive")

local function token_set(p)
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
    if type(v) == "string" then vals[v:upper()] = true end
  end
  return vals
end

local function traceable(hex, allowed, tokens)
  hex = hex:upper()
  if allowed[hex] then return true end
  for _, a in ipairs(tokens) do
    for _, b in ipairs(tokens) do
      for _, f in ipairs({ 0.10, 0.25, 0.5 }) do
        if derive.blend(a, b, f):upper() == hex then return true end
      end
    end
  end
  return false
end

local function check(variant)
  matcha.setup({ variant = variant, terminal_colors = false, integrations = false })
  local hl = matcha.load()
  local p = require("matcha.palette." .. variant)
  local allowed = token_set(p)
  local tokens = {}
  for k in pairs(allowed) do tokens[#tokens + 1] = k end

  for name, val in pairs(hl) do
    if type(val) == "table" then
      for _, field in ipairs({ "fg", "bg", "sp" }) do
        local v = val[field]
        if type(v) == "string" and v:match("^#%x%x%x%x%x%x$") then
          assert_true(
            traceable(v, allowed, tokens),
            string.format("%s.%s = %s is not a token/derivation", name, field, v)
          )
        end
      end
    end
  end
end

describe("provenance", function()
  it("morning: every color traces to a token or derivation", function() check("morning") end)
  it("evening: every color traces to a token or derivation", function() check("evening") end)
end)
