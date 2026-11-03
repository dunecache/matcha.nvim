local d = require("matcha.groups.plugins._detect")
local M = {}
M.detect = function() return d.loaded("gitsigns") or d.glob("loaded_gitsigns") end
function M.get(p, opts, derived)
  return {
    GitSignsAdd = { fg = p.diff.added },
    GitSignsChange = { fg = p.diff.changed },
    GitSignsDelete = { fg = p.diff.removed },
    GitSignsAddNr = { fg = p.diff.added },
    GitSignsChangeNr = { fg = p.diff.changed },
    GitSignsDeleteNr = { fg = p.diff.removed },
    GitSignsAddLn = { bg = p.diff.added_bg },
    GitSignsChangeLn = { bg = p.diff.changed_bg },
    GitSignsDeleteLn = { bg = p.diff.removed_bg },
    GitSignsCurrentLineBlame = { fg = p.text_muted, italic = true },
  }
end
return M
