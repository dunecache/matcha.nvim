-- lua/matcha/groups/editor.lua
local M = {}

-- p       : palette table (semantic tokens at top level)
-- opts    : resolved config
-- derived : derived colors from derive.lua
function M.get(p, opts, derived)
  local h = {}

  local bg = opts.transparent and "NONE" or p.background
  local ncbg = opts.transparent and "NONE" or p.background

  h.Normal = { fg = p.text_primary, bg = bg }
  h.NormalNC = opts.dim_inactive
      and { fg = p.text_secondary, bg = ncbg }
      or { fg = p.text_primary, bg = ncbg }
  h.SignColumn = { bg = opts.transparent and "NONE" or p.background }
  h.EndOfBuffer = { fg = p.text_muted, bg = bg }

  -- Floats
  h.NormalFloat = { fg = p.text_primary, bg = p.surface_elevated }
  h.FloatBorder = { fg = p.border_strong, bg = p.surface_elevated }
  h.FloatTitle = { fg = p.text_primary, bg = p.surface_elevated }
  h.FloatFooter = { fg = p.text_secondary, bg = p.surface_elevated }

  -- Cursor
  h.Cursor = { fg = p.background, bg = p.text_primary }
  h.lCursor = { link = "Cursor" }
  h.CursorIM = { link = "Cursor" }
  h.TermCursor = { link = "Cursor" }
  h.TermCursorNC = { link = "Cursor" }

  -- Cursor line / numbers
  h.CursorLine = { bg = derived.cursorline_bg }
  h.CursorColumn = { bg = derived.cursorline_bg }
  h.CursorLineNr = { fg = p.accent_strong }
  h.LineNr = { fg = p.text_muted }
  h.LineNrAbove = { fg = p.text_muted }
  h.LineNrBelow = { fg = p.text_muted }
  h.CursorLineFold = { link = "Folded" }
  h.CursorLineSign = { link = "SignColumn" }

  -- Selection / search
  h.Visual = { bg = p.selection }
  h.VisualNOS = { bg = p.selection }
  h.Search = { fg = p.text_primary, bg = derived.search_bg }
  h.IncSearch = { fg = p.background, bg = p.warning }
  h.CurSearch = { fg = p.background, bg = p.warning }
  h.MatchParen = { fg = p.accent_strong, bold = true }
  h.Substitute = { link = "Search" }
  h.ComplMatchIns = { fg = p.accent_strong }

  -- Popup menu
  h.Pmenu = { fg = p.text_primary, bg = p.surface_elevated }
  h.PmenuSel = { fg = p.text_primary, bg = p.selection }
  h.PmenuKind = { fg = p.text_secondary, bg = p.surface_elevated }
  h.PmenuKindSel = { fg = p.text_secondary, bg = p.selection }
  h.PmenuExtra = { fg = p.text_secondary, bg = p.surface_elevated }
  h.PmenuExtraSel = { fg = p.text_secondary, bg = p.selection }
  h.PmenuMatch = { fg = p.accent_strong, bg = p.surface_elevated }
  h.PmenuMatchSel = { fg = p.accent_strong, bg = p.selection }
  h.PmenuSbar = { bg = p.surface }
  h.PmenuThumb = { bg = p.border_subtle }

  -- Status / tab lines
  h.StatusLine = { fg = p.text_secondary, bg = p.surface }
  h.StatusLineNC = { fg = p.text_muted, bg = p.surface }
  h.StatusLineTerm = { link = "StatusLine" }
  h.StatusLineTermNC = { link = "StatusLineNC" }
  h.TabLine = { fg = p.text_secondary, bg = p.surface }
  h.TabLineSel = { fg = p.text_primary, bg = p.surface_elevated }
  h.TabLineFill = { bg = p.surface }

  -- Folds / columns
  h.Folded = { fg = p.text_secondary, bg = p.surface }
  h.FoldColumn = { fg = p.text_muted, bg = bg }
  h.ColorColumn = { bg = p.surface }
  h.WinSeparator = { fg = p.border_subtle }
  h.VertSplit = { fg = p.border_subtle }

  -- Non-text / whitespace
  h.NonText = { fg = p.text_muted }
  h.Whitespace = { fg = p.text_muted }
  h.SpecialKey = { fg = p.text_muted }
  h.Conceal = { fg = p.text_muted }

  -- Messages / prompts
  h.ModeMsg = { fg = p.text_primary }
  h.ModeMsgMore = { fg = p.text_primary, bold = true }
  h.MsgArea = { fg = p.text_primary, bg = bg }
  h.MsgSeparator = { fg = p.border_subtle, bg = bg }
  h.MoreMsg = { fg = p.accent_strong }
  h.Question = { fg = p.accent_strong }
  h.ErrorMsg = { fg = p.danger }
  h.WarningMsg = { fg = p.warning }
  h.Title = { fg = p.accent_strong, bold = true }
  h.Directory = { fg = p.accent_strong }

  return h
end

return M
