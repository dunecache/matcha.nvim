local d = require("matcha.groups.plugins._detect")
local M = {}
M.detect = function() return d.loaded("cmp") end
function M.get(p, opts, derived)
  return {
    CmpItemAbbr = { fg = p.text_primary },
    CmpItemAbbrDeprecated = { fg = p.text_muted, strikethrough = true },
    CmpItemAbbrMatch = { fg = p.accent_strong },
    CmpItemAbbrMatchFuzzy = { fg = p.accent_strong },
    CmpItemKindDefault = { fg = p.text_secondary },
    CmpItemMenu = { fg = p.text_muted },
    CmpBorder = { link = "FloatBorder" },
    CmpDocBorder = { link = "FloatBorder" },
  }
end
return M
