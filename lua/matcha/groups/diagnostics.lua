-- lua/matcha/groups/diagnostics.lua
-- Semantic states; underline/undercurl so color is never the only cue.
-- D3: diagnostic virtual-text backgrounds.
local M = {}

function M.get(p, opts, derived)
  local ud = opts.styles.underline_diagnostics
  local undercurl = ud == "undercurl" or ud == nil
  local underline = ud == "underline"

  local h = {}

  h.DiagnosticError = { fg = p.danger, undercurl = undercurl, underline = underline, sp = p.danger }
  h.DiagnosticWarn = { fg = p.warning, undercurl = undercurl, underline = underline, sp = p.warning }
  h.DiagnosticInfo = { fg = p.info, undercurl = undercurl, underline = underline, sp = p.info }
  h.DiagnosticOk = { fg = p.success, undercurl = undercurl, underline = underline, sp = p.success }
  -- Spec has no hint role: text_secondary fg with an accent_secondary undercurl (decision).
  h.DiagnosticHint = { fg = p.text_secondary, undercurl = undercurl, underline = underline, sp = p.accent_secondary }

  h.DiagnosticSignError = { fg = p.danger }
  h.DiagnosticSignWarn = { fg = p.warning }
  h.DiagnosticSignInfo = { fg = p.info }
  h.DiagnosticSignOk = { fg = p.success }
  h.DiagnosticSignHint = { fg = p.text_secondary }

  h.DiagnosticVirtualTextError = { fg = p.danger, bg = derived.diag_error_vt_bg }
  h.DiagnosticVirtualTextWarn = { fg = p.warning, bg = derived.diag_warn_vt_bg }
  h.DiagnosticVirtualTextInfo = { fg = p.info, bg = derived.diag_info_vt_bg }
  h.DiagnosticVirtualTextOk = { fg = p.success, bg = derived.diag_ok_vt_bg }
  h.DiagnosticVirtualTextHint = { fg = p.text_secondary, bg = derived.diag_ok_vt_bg }

  h.DiagnosticFloatingError = { link = "DiagnosticError" }
  h.DiagnosticFloatingWarn = { link = "DiagnosticWarn" }
  h.DiagnosticFloatingInfo = { link = "DiagnosticInfo" }
  h.DiagnosticFloatingOk = { link = "DiagnosticOk" }
  h.DiagnosticFloatingHint = { link = "DiagnosticHint" }

  return h
end

return M
