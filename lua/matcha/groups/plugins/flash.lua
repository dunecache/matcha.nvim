local d = require("matcha.groups.plugins._detect")
local M = {}
M.detect = function() return d.loaded("flash") or d.any({ "flash.nvim" }) or d.glob("loaded_flash") end
function M.get(p, opts, derived)
  return {
    FlashLabel = { fg = p.background, bg = p.accent_strong, bold = true },
    FlashMatch = { fg = p.accent_strong },
    FlashCurrent = { fg = p.text_primary, bg = p.selection },
    FlashBackdrop = { fg = p.text_muted },
    FlashCursor = { link = "Cursor" },
  }
end
return M
