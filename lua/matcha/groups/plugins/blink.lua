local d = require("matcha.groups.plugins._detect")
local M = {}
M.detect = function() return d.loaded("blink.cmp") or d.glob("loaded_blink") end
function M.get(p, opts, derived)
  return {
    BlinkCmpMenu = { link = "Pmenu" },
    BlinkCmpMenuBorder = { link = "FloatBorder" },
    BlinkCmpDoc = { link = "NormalFloat" },
    BlinkCmpDocBorder = { link = "FloatBorder" },
    BlinkCmpLabel = { fg = p.text_primary },
    BlinkCmpLabelMatch = { fg = p.accent_strong },
    BlinkCmpLabelDetail = { fg = p.text_secondary },
    BlinkCmpLabelDescription = { fg = p.text_muted },
    BlinkCmpKind = { fg = p.text_secondary },
    BlinkCmpScrollBarThumb = { bg = p.border_subtle },
    BlinkCmpScrollBarGutter = { bg = p.surface },
  }
end
return M
