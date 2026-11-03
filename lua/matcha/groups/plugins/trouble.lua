local d = require("matcha.groups.plugins._detect")
local M = {}
M.detect = function() return d.loaded("trouble") or d.cmd("Trouble") end
function M.get(p, opts, derived)
  return {
    TroubleNormal = { link = "NormalFloat" },
    TroubleCount = { fg = p.accent_strong, bg = p.selection },
    TroubleError = { fg = p.danger },
    TroubleWarn = { fg = p.warning },
    TroubleInfo = { fg = p.info },
    TroubleHint = { fg = p.text_secondary },
    TroubleIndent = { fg = p.border_subtle },
    TroubleTextInformation = { fg = p.text_secondary },
  }
end
return M
