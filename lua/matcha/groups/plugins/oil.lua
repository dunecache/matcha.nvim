local d = require("matcha.groups.plugins._detect")
local M = {}
M.detect = function() return d.loaded("oil") end
function M.get(p, opts, derived)
  return {
    OilDir = { fg = p.accent_strong, bold = true },
    OilChange = { fg = p.diff.changed },
    OilCreate = { fg = p.diff.added },
    OilDelete = { fg = p.diff.removed },
    OilPermission = { fg = p.text_muted },
    OilSize = { fg = p.text_muted },
  }
end
return M
