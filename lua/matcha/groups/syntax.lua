-- lua/matcha/groups/syntax.lua
-- Legacy Vim syntax groups mapped to syntax.* tokens
local M = {}

function M.get(p, opts)
  local s = p.syntax
  local h = {}

  local function styles(t)
    return vim.tbl_extend("force", t, opts.styles.functions or {})
  end

  h.Comment = vim.tbl_extend("force", { fg = s.comment }, opts.styles.comments)
  h.NonTextComment = { link = "Comment" }

  h.Constant = { fg = s.constant }
  h.Error = { fg = p.danger }
  h.Identifier = { fg = s.default }
  h.PreProc = { fg = s.keyword }
  h.Special = { fg = s.keyword }
  h.Statement = { link = "Keyword" }
  h.Title = { fg = p.accent_strong, bold = true }
  h.Type = { fg = s.type }
  h.Typedef = { link = "Type" }
  h.StorageClass = { link = "Keyword" }
  h.Structure = { link = "Type" }
  h.Debug = { fg = p.warning }
  h.Exception = { link = "Keyword" }
  h.Repeat = { link = "Keyword" }
  h.Conditional = { link = "Keyword" }
  h.Label = { link = "Keyword" }
  h.Keyword = styles({ fg = s.keyword })

  h.Character = { fg = s.string }
  h.String = vim.tbl_extend("force", { fg = s.string }, opts.styles.strings or {})
  h.SpecialChar = { fg = s.escape }
  h.SpecialComment = { link = "Comment" }

  h.Boolean = { fg = s.number }
  h.Float = { fg = s.number }
  h.Number = { fg = s.number }

  h.Function = { fg = s["function"] }
  h.Macro = { fg = s.keyword }

  h.Operator = { fg = s.operator }
  h.Delimiter = { fg = s.punctuation }
  h.Tag = { fg = s.tag }
  h.Attribute = { fg = s.attribute }
  h.SpecialKey = { fg = s.escape }
  h.Regexp = { fg = s.regexp }

  h.Underlined = { fg = p.accent_strong, underline = true }
  h.Bold = { bold = true }
  h.Italic = { italic = true }

  h.DiffAdd = { fg = p.diff.added, bg = p.diff.added_bg }
  h.DiffDelete = { fg = p.diff.removed, bg = p.diff.removed_bg }
  h.DiffChange = { fg = p.diff.changed, bg = p.diff.changed_bg }
  h.DiffText = { fg = p.diff.changed, bg = p.diff.changed_bg }

  h.healthError = { fg = p.danger }
  h.healthWarning = { fg = p.warning }
  h.healthSuccess = { fg = p.success }

  return h
end

return M
