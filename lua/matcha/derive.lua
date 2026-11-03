-- lua/matcha/derive.lua
-- The ONLY place colors are computed. All derivations take canonical tokens as input.
local M = {}

local function hex_to_rgb(hex)
  hex = hex:gsub("#", "")
  return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

local function rgb_to_hex(r, g, b)
  local function clamp(x)
    return math.max(0, math.min(255, math.floor(x + 0.5)))
  end
  return string.format("#%02X%02X%02X", clamp(r), clamp(g), clamp(b))
end

-- Blend two hex colors. factor = weight of the second color (0..1)
function M.blend(hex1, hex2, factor)
  local r1, g1, b1 = hex_to_rgb(hex1)
  local r2, g2, b2 = hex_to_rgb(hex2)
  local r = r1 + (r2 - r1) * factor
  local g = g1 + (g2 - g1) * factor
  local b = b1 + (b2 - b1) * factor
  return rgb_to_hex(r, g, b)
end

function M.compute(p)
  return {
    -- D1 CursorLine background
    cursorline_bg = M.blend(p.background, p.surface, 0.5),
    -- D2 Search background
    search_bg = M.blend(p.background, p.warning, 0.25),
    -- D3 Diagnostic virtual-text backgrounds
    diag_error_vt_bg = M.blend(p.background, p.danger, 0.10),
    diag_warn_vt_bg = M.blend(p.background, p.warning, 0.10),
    diag_info_vt_bg = M.blend(p.background, p.info, 0.10),
    diag_ok_vt_bg = M.blend(p.background, p.success, 0.10),
  }
end

return M
