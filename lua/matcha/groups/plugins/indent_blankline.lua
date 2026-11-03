local d = require("matcha.groups.plugins._detect")
local M = {}
M.detect = function() return d.any({ "indent_blankline", "indent-blankline", "ibl", "indent-blankline.nvim" }) end
function M.get(p, opts, derived)
  return {
    IblIndent = { fg = p.border_subtle },
    IblWhitespace = { fg = p.border_subtle },
    IblScope = { fg = p.accent_secondary },
    IndentBlanklineChar = { fg = p.border_subtle },
    IndentBlanklineContextChar = { fg = p.accent_secondary },
    IndentBlanklineSpaceChar = { fg = p.border_subtle },
    IndentBlanklineSpaceCharBlankline = { fg = p.border_subtle },
  }
end
return M
