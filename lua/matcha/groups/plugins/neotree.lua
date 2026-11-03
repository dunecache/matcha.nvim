local d = require("matcha.groups.plugins._detect")
local M = {}
M.detect = function() return d.loaded("neo-tree") or d.cmd("Neotree") end
function M.get(p, opts, derived)
  return {
    NeoTreeNormal = { fg = p.text_secondary, bg = p.surface },
    NeoTreeNormalNC = { link = "NeoTreeNormal" },
    NeoTreeDirectoryIcon = { fg = p.accent_strong },
    NeoTreeDirectoryName = { fg = p.text_primary },
    NeoTreeFileName = { fg = p.text_primary },
    NeoTreeRootName = { fg = p.accent_strong, bold = true },
    NeoTreeGitModified = { fg = p.diff.changed },
    NeoTreeGitAdded = { fg = p.diff.added },
    NeoTreeGitDeleted = { fg = p.diff.removed },
    NeoTreeBorder = { fg = p.border_subtle, bg = p.surface },
  }
end
return M
