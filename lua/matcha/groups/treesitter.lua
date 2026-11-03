-- lua/matcha/groups/treesitter.lua
-- @capture groups link to a small set of base groups so one decision changes everything.
local M = {}

function M.get(p, opts)
  local h = {}

  local links = {
    { "@variable", "Identifier" },
    { "@variable.builtin", "Identifier" },
    { "@variable.member", "Identifier" },
    { "@variable.parameter", "Identifier" },
    { "@constant", "Constant" },
    { "@constant.builtin", "Constant" },
    { "@constant.macro", "Constant" },
    { "@keyword", "Keyword" },
    { "@keyword.function", "Keyword" },
    { "@keyword.operator", "Keyword" },
    { "@keyword.import", "Keyword" },
    { "@keyword.return", "Keyword" },
    { "@keyword.conditional", "Conditional" },
    { "@keyword.repeat", "Repeat" },
    { "@keyword.exception", "Exception" },
    { "@keyword.directive", "PreProc" },
    { "@operator", "Operator" },
    { "@punctuation.delimiter", "Delimiter" },
    { "@punctuation.bracket", "Delimiter" },
    { "@punctuation.special", "SpecialChar" },
    { "@string", "String" },
    { "@string.escape", "SpecialChar" },
    { "@string.regexp", "Regexp" },
    { "@string.special", "SpecialChar" },
    { "@character", "Character" },
    { "@number", "Number" },
    { "@number.float", "Float" },
    { "@boolean", "Boolean" },
    { "@function", "Function" },
    { "@function.builtin", "Function" },
    { "@function.call", "Function" },
    { "@function.macro", "Macro" },
    { "@method", "Function" },
    { "@method.call", "Function" },
    { "@constructor", "Function" },
    { "@type", "Type" },
    { "@type.builtin", "Type" },
    { "@type.definition", "Typedef" },
    { "@attribute", "Attribute" },
    { "@property", "Identifier" },
    { "@field", "Identifier" },
    { "@parameter", "Identifier" },
    { "@module", "Identifier" },
    { "@label", "Label" },
    { "@namespace", "Type" },
    { "@comment", "Comment" },
    { "@comment.todo", "Comment" },
    { "@tag", "Tag" },
    { "@tag.attribute", "Attribute" },
    { "@tag.delimiter", "Tag" },
    { "@markup.strong", "Bold" },
    { "@markup.italic", "Italic" },
    { "@markup.underline", "Underlined" },
    { "@markup.heading", "Title" },
    { "@markup.link", "MarkdownLink" },
    { "@markup.link.label", "MarkdownLink" },
    { "@markup.raw", "String" },
    { "@markup.list", "Identifier" },
  }

  for _, pair in ipairs(links) do
    h[pair[1]] = { link = pair[2] }
  end

  return h
end

return M
