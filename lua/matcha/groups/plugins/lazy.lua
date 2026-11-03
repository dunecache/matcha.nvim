local d = require("matcha.groups.plugins._detect")
local M = {}
M.detect = function() return d.loaded("lazy") or d.cmd("Lazy") end
function M.get(p, opts, derived)
  return {
    LazyNormal = { link = "NormalFloat" },
    LazyH1 = { fg = p.accent_strong, bold = true },
    LazyH2 = { fg = p.accent_strong, bold = true },
    LazyProgressDone = { fg = p.success },
    LazyReasonStart = { fg = p.text_muted },
    LazyReasonSource = { fg = p.text_muted },
    LazyReasonEvent = { fg = p.text_muted },
    LazyButton = { bg = p.surface_elevated },
    LazyButtonActive = { bg = p.selection },
    LazyCommit = { fg = p.diff.changed },
    LazyDir = { fg = p.text_secondary },
  }
end
return M
