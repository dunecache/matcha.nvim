-- extras/lualine/theme.lua
-- lualine theme in keeping with Kanso Matcha. Uses tokens only.
local M = {}

local function make(p)
  return {
    normal = {
      a = { fg = p.text_primary, bg = p.surface },
      b = { fg = p.text_secondary, bg = p.surface },
      c = { fg = p.text_secondary, bg = p.surface },
    },
    insert = { a = { fg = p.text_primary, bg = p.selection } },
    visual = { a = { fg = p.text_primary, bg = p.selection } },
    replace = { a = { fg = p.text_primary, bg = p.selection } },
    command = { a = { fg = p.text_primary, bg = p.surface } },
    inactive = {
      a = { fg = p.text_muted, bg = p.surface },
      b = { fg = p.text_muted, bg = p.surface },
      c = { fg = p.text_muted, bg = p.surface },
    },
  }
end

function M.get(variant)
  return make(require("matcha.palette." .. variant))
end

return M
