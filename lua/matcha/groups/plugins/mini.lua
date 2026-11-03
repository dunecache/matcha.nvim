local d = require("matcha.groups.plugins._detect")
local M = {}
M.detect = function() return d.any({ "mini.statusline", "mini.pick", "mini.files", "mini.diff" }) end
function M.get(p, opts, derived)
  return {
    MiniStatuslineModeNormal = { fg = p.text_primary, bg = p.surface },
    MiniStatuslineModeInsert = { fg = p.text_primary, bg = p.selection },
    MiniStatuslineModeVisual = { fg = p.text_primary, bg = p.selection },
    MiniStatuslineFilename = { fg = p.text_secondary, bg = p.surface },
    MiniStatuslineFileinfo = { fg = p.text_muted, bg = p.surface },
    MiniStatuslineInactive = { link = "StatusLineNC" },
    MiniPickNormal = { link = "NormalFloat" },
    MiniPickBorder = { link = "FloatBorder" },
    MiniPickMatchCurrent = { bg = p.selection },
    MiniPickHeader = { fg = p.accent_strong },
    MiniPickMatchMarked = { fg = p.accent_strong },
    MiniDiffSignAdd = { fg = p.diff.added },
    MiniDiffSignChange = { fg = p.diff.changed },
    MiniDiffSignDelete = { fg = p.diff.removed },
    MiniFilesNormal = { link = "NormalFloat" },
    MiniFilesBorder = { link = "FloatBorder" },
    MiniFilesTitle = { fg = p.accent_strong },
  }
end
return M
