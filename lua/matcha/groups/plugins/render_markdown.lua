local d = require("matcha.groups.plugins._detect")
local M = {}
M.detect = function() return d.any({ "render-markdown", "render-markdown.nvim" }) end
function M.get(p, opts, derived)
  local code = p.markdown.code_bg and p[p.markdown.code_bg:gsub("-", "_")] or p.surface_sunken
  return {
    RenderMarkdownH1 = { fg = p.text_primary, bg = p.background, bold = true },
    RenderMarkdownH1Bg = { bg = p.background },
    RenderMarkdownH1Border = { fg = p.border_subtle, bg = p.background },
    RenderMarkdownCode = { bg = code },
    RenderMarkdownCodeInline = { bg = code },
    RenderMarkdownBullet = { fg = p.accent_secondary },
    RenderMarkdownQuote = { fg = p.text_secondary },
    RenderMarkdownLink = { fg = p[p.markdown.link:gsub("-", "_")], underline = true },
    RenderMarkdownTableHead = { fg = p.text_primary, bold = true },
    RenderMarkdownTableRow = { fg = p.text_secondary },
    RenderMarkdownChecked = { fg = p.success },
    RenderMarkdownUnchecked = { fg = p.text_muted },
  }
end
return M
