local d = require("matcha.groups.plugins._detect")
local M = {}
M.detect = function() return d.loaded("telescope") or d.cmd("Telescope") end
function M.get(p, opts, derived)
  local h = {}
  h.TelescopeBorder = { fg = p.border_strong, bg = p.surface_elevated }
  h.TelescopeNormal = { link = "NormalFloat" }
  h.TelescopePrompt = { fg = p.text_secondary, bg = p.surface }
  h.TelescopePromptNormal = { link = "TelescopePrompt" }
  h.TelescopeTitle = { link = "FloatTitle" }
  h.TelescopePreviewBorder = { link = "TelescopeBorder" }
  h.TelescopeResultsBorder = { link = "TelescopeBorder" }
  h.TelescopeSelection = { bg = p.selection }
  h.TelescopeSelectionCaret = { fg = p.accent_strong, bg = p.selection }
  h.TelescopeMatching = { fg = p.accent_strong, bold = true }
  return h
end
return M
