-- scripts/check-contrast.lua
-- Run: nvim -l scripts/check-contrast.lua
-- Prints WCAG contrast ratios for every fg/bg pair actually used by matcha highlight groups.
local root = vim.fn.getcwd()
package.path = root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path

local matcha = require("matcha")

-- UI boundary / separator groups: target is essential-boundary visibility (3.0), not text.
local BOUNDARY_GROUPS = {
  WinSeparator = true, VertSplit = true, MsgSeparator = true, FloatBorder = true,
  FoldColumn = true, SignColumn = true, EndOfBuffer = true, PmenuSbar = true, PmenuThumb = true,
}

local function parse_hex(s)
  if type(s) ~= "string" or not s:match("^#%x%x%x%x%x%x$") then return nil end
  return s:upper()
end

local function ch(v)
  if v <= 0.03928 then return v / 12.92 end
  return ((v + 0.055) / 1.055) ^ 2.4
end

local function lum(h)
  local r = tonumber(h:sub(2, 3), 16) / 255
  local g = tonumber(h:sub(4, 5), 16) / 255
  local b = tonumber(h:sub(6, 7), 16) / 255
  return 0.2126 * ch(r) + 0.7152 * ch(g) + 0.0722 * ch(b)
end

local function ratio(fg, bg)
  local l1, l2 = lum(fg), lum(bg)
  if l1 < l2 then l1, l2 = l2, l1 end
  return (l1 + 0.05) / (l2 + 0.05)
end

local failures = 0
local checked = 0

local function resolve(p, key)
  -- palette tokens are hex strings; derived values may be hex strings too
  if type(p) ~= "table" then return nil end
  return p
end

local function check_variant(variant)
  matcha.setup({ variant = variant, terminal_colors = false, on_highlights = nil })
  local hl = matcha.load(variant)
  local palette = require("matcha.palette." .. variant)

  -- bg may be "NONE" for transparent; substitute background for measurement
  for name, val in pairs(hl) do
    if type(val) == "table" then
      local fg = parse_hex(val.fg)
      local bg = parse_hex(val.bg)
      if bg == nil and val.bg == "NONE" then bg = palette.background:upper() end
      if fg and bg then
        checked = checked + 1
        local target = BOUNDARY_GROUPS[name] and 3.0 or 4.5
        local r = ratio(fg, bg)
        if r < target then
          failures = failures + 1
          print(string.format("%-9s %-26s %s on %s = %.2f:1 (target %.1f)", variant, name, fg, bg, r, target))
        end
      end
    end
  end
end

check_variant("morning")
check_variant("evening")

print(string.format("contrast: %d pairs checked, %d failures", checked, failures))
if failures > 0 then vim.cmd("cq") end
