-- tests/links_spec.lua
-- Every { link = ... } target must be a group we actually define (no dangling links).
local matcha = require("matcha")

local color_groups = {
  "Normal", "Title", "Bold", "Italic", "Underlined",
}

-- groups whose links are allowed to resolve to builtins Neovim provides
local builtin = {
  Normal = true, NormalNC = true, SignColumn = true, EndOfBuffer = true,
  NormalFloat = true, FloatBorder = true, FloatTitle = true, FloatFooter = true,
  Cursor = true, lCursor = true, CursorIM = true, TermCursor = true, TermCursorNC = true,
  CursorLine = true, CursorColumn = true, CursorLineNr = true, LineNr = true,
  Visual = true, VisualNOS = true, Search = true, IncSearch = true, CurSearch = true,
  MatchParen = true, Substitute = true, ComplMatchIns = true,
  Pmenu = true, PmenuSel = true, PmenuKind = true, PmenuKindSel = true, PmenuExtra = true,
  PmenuExtraSel = true, PmenuMatch = true, PmenuMatchSel = true, PmenuSbar = true, PmenuThumb = true,
  StatusLine = true, StatusLineNC = true, StatusLineTerm = true, StatusLineTermNC = true,
  TabLine = true, TabLineSel = true, TabLineFill = true,
  Folded = true, FoldColumn = true, ColorColumn = true, WinSeparator = true, VertSplit = true,
  NonText = true, Whitespace = true, SpecialKey = true, Conceal = true,
  ModeMsg = true, ModeMsgMore = true, MsgArea = true, MsgSeparator = true, MoreMsg = true,
  Question = true, ErrorMsg = true, WarningMsg = true, Directory = true,
  DiagnosticError = true, DiagnosticWarn = true, DiagnosticInfo = true, DiagnosticOk = true,
  DiagnosticHint = true, DiagnosticDeprecated = true,
  LspInlayHint = true, LspCodeLens = true, LspReferenceRead = true, LspReferenceText = true,
  LspReferenceWrite = true, LspSignatureActiveParameter = true,
  DiffAdd = true, DiffDelete = true, DiffChange = true, DiffText = true,
  healthError = true, healthWarning = true, healthSuccess = true,
  Comment = true, Constant = true, Identifier = true, PreProc = true, Special = true,
  Statement = true, Type = true, Typedef = true, StorageClass = true, Structure = true,
  Keyword = true, Conditional = true, Repeat = true, Exception = true, Label = true,
  Character = true, String = true, Number = true, Float = true, Boolean = true,
  Function = true, Macro = true, Operator = true, Delimiter = true, Tag = true,
  Attribute = true, Regexp = true, Underlined = true, Bold = true, Italic = true,
  CursorLineFold = true, CursorLineSign = true, StatusLineTerm = true,
  SpecialComment = true, Debug = true, SpecialChar = true, SpecialKey = true,
}

describe("links", function()
  it("morning: all link targets resolve", function()
    matcha.setup({ variant = "morning", terminal_colors = false })
    local hl = matcha.load()
    for name, val in pairs(hl) do
      if type(val) == "table" and val.link then
        local target = val.link
        assert_true(
          hl[target] ~= nil or builtin[target] or color_groups[target],
          string.format("%s links to undefined group %s", name, target)
        )
      end
    end
  end)

  it("evening: all link targets resolve", function()
    matcha.setup({ variant = "evening", terminal_colors = false })
    local hl = matcha.load()
    for name, val in pairs(hl) do
      if type(val) == "table" and val.link then
        local target = val.link
        assert_true(
          hl[target] ~= nil or builtin[target] or color_groups[target],
          string.format("%s links to undefined group %s", name, target)
        )
      end
    end
  end)
end)
