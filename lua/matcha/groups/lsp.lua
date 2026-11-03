-- lua/matcha/groups/lsp.lua
-- @lsp.* semantic tokens link to Treesitter equivalents; reference + inlay highlights.
local M = {}

function M.get(p, opts)
  local h = {}

  local semantic = {
    { "@lsp.type.class", "@type" },
    { "@lsp.type.comment", "@comment" },
    { "@lsp.type.decorator", "@attribute" },
    { "@lsp.type.enum", "@type" },
    { "@lsp.type.enumMember", "@constant" },
    { "@lsp.type.event", "@variable" },
    { "@lsp.type.function", "@function" },
    { "@lsp.type.interface", "@type" },
    { "@lsp.type.keyword", "@keyword" },
    { "@lsp.type.macro", "@function.macro" },
    { "@lsp.type.method", "@method" },
    { "@lsp.type.modifier", "@keyword" },
    { "@lsp.type.namespace", "@namespace" },
    { "@lsp.type.number", "@number" },
    { "@lsp.type.operator", "@operator" },
    { "@lsp.type.parameter", "@parameter" },
    { "@lsp.type.property", "@property" },
    { "@lsp.type.regexp", "@string.regexp" },
    { "@lsp.type.string", "@string" },
    { "@lsp.type.struct", "@type" },
    { "@lsp.type.type", "@type" },
    { "@lsp.type.typeParameter", "@type" },
    { "@lsp.type.variable", "@variable" },
  }

  local modifiers = {
    { "@lsp.mod.abstract", "@type.definition" },
    { "@lsp.mod.async", "@function" },
    { "@lsp.mod.declaration", "@type.definition" },
    { "@lsp.mod.defaultLibrary", "@type.builtin" },
    { "@lsp.mod.definition", "@function" },
    { "@lsp.mod.deprecated", "DiagnosticDeprecated" },
    { "@lsp.mod.documentation", "@comment" },
    { "@lsp.mod.modification", "@variable.member" },
    { "@lsp.mod.readonly", "@constant" },
    { "@lsp.mod.static", "@variable.builtin" },
  }

  local all = {}
  vim.list_extend(all, semantic)
  vim.list_extend(all, modifiers)
  for _, pair in ipairs(all) do
    h[pair[1]] = { link = pair[2] }
  end

  h.DiagnosticDeprecated = { strikethrough = true }
  h.LspInlayHint = { fg = p.text_muted, italic = true }
  h.LspCodeLens = { fg = p.text_muted }
  h.LspReferenceRead = { bg = p.surface_accent }
  h.LspReferenceText = { bg = p.surface_accent }
  h.LspReferenceWrite = { bg = p.surface_accent, bold = true }
  h.LspSignatureActiveParameter = { fg = p.accent_strong, bold = true }

  return h
end

return M
