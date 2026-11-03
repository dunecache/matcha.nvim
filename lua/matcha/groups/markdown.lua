-- lua/matcha/groups/markdown.lua
-- markdown.* domain tokens. Some entries reference other token names (e.g. "text-primary",
-- "accent-strong", "info", "surface-sunken", "border-subtle", "accent-secondary");
-- resolve them against the semantic palette.
local M = {}

local function resolve(p, name)
  local key = name:gsub("-", "_")
  local v = p[key]
  if type(v) == "string" then
    return v
  end
  return nil
end

function M.get(p, opts)
  local m = p.markdown
  local h = {}

  local fg = function(name)
    return resolve(p, m[name] or "text_primary")
  end

  h.MarkdownHeading = { fg = fg("heading"), bold = true }
  h.MarkdownHeadingRule = { fg = fg("heading_accent") }
  for i = 1, 6 do
    h["@markup.heading." .. i .. ".markdown"] = { link = "MarkdownHeading" }
    h["@markup.heading." .. i .. ".marker.markdown"] = { fg = fg("heading_accent") }
  end

  h.MarkdownLink = { fg = fg("link") }
  h["@markup.link.markdown"] = { link = "MarkdownLink" }
  h["@markup.link.label.markdown"] = { link = "MarkdownLink" }
  h["@markup.link.url.markdown"] = { fg = fg("link"), underline = true }

  h.MarkdownBold = { fg = fg("bold"), bold = true }
  h.MarkdownItalic = { fg = fg("italic"), italic = true }

  h.MarkdownQuote = { fg = fg("quote") }
  h["@markup.quote.markdown"] = { link = "MarkdownQuote" }

  local code_bg = resolve(p, m.code_bg or "surface_sunken")
  h.MarkdownCode = { fg = fg("code"), bg = code_bg }
  h.MarkdownCodeBlock = { fg = fg("code"), bg = code_bg }
  h["@markup.raw.markdown"] = { link = "MarkdownCode" }
  h["@markup.raw.block.markdown"] = { link = "MarkdownCodeBlock" }

  h.MarkdownRule = { fg = fg("hr") }
  h["@markup.hr.markdown"] = { link = "MarkdownRule" }

  h.MarkdownListMarker = { fg = fg("list_marker") }
  h["@markup.list.markdown"] = { link = "MarkdownListMarker" }
  h["@markup.list.checked.markdown"] = { link = "MarkdownListMarker" }
  h["@markup.list.unchecked.markdown"] = { link = "MarkdownListMarker" }

  h.MarkdownTag = { fg = fg("tag") }
  h["@markup.tag.markdown"] = { link = "MarkdownTag" }

  return h
end

return M
