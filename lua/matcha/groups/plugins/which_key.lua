local d = require("matcha.groups.plugins._detect")
local M = {}
M.detect = function() return d.any({ "which-key", "which-key.nvim" }) or d.glob("loaded_which_key") end
function M.get(p, opts, derived)
  return {
    WhichKey = { fg = p.accent_strong },
    WhichKeyGroup = { fg = p.text_secondary },
    WhichKeyDesc = { fg = p.text_primary },
    WhichKeySeparator = { fg = p.text_muted },
    WhichKeyFloat = { bg = p.surface_elevated },
    WhichKeyBorder = { link = "FloatBorder" },
  }
end
return M
