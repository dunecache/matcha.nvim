-- lua/matcha/config.lua
local M = {}

M.defaults = {
  variant = "auto", -- "auto" | "morning" | "evening"
  transparent = false,
  terminal_colors = true,
  dim_inactive = false,
  styles = {
    comments = { italic = true },
    keywords = {},
    functions = {},
    strings = {},
    underline_diagnostics = "undercurl",
  },
  integrations = "auto",
  on_highlights = nil,
}

local function is_table(v)
  return type(v) == "table"
end

function M.validate(opts)
  opts = opts or {}
  local ok = true
  local function warn(msg)
    vim.notify("matcha: " .. msg, vim.log.levels.WARN)
    ok = false
  end
  if not is_table(opts) then
    warn("options must be a table")
    return false
  end
  if opts.variant ~= nil and not vim.tbl_contains({ "auto", "morning", "evening" }, opts.variant) then
    warn('variant must be "auto", "morning", or "evening"')
  end
  if opts.transparent ~= nil and type(opts.transparent) ~= "boolean" then
    warn("transparent must be a boolean")
  end
  if opts.terminal_colors ~= nil and type(opts.terminal_colors) ~= "boolean" then
    warn("terminal_colors must be a boolean")
  end
  if opts.dim_inactive ~= nil and type(opts.dim_inactive) ~= "boolean" then
    warn("dim_inactive must be a boolean")
  end
  if opts.styles ~= nil and not is_table(opts.styles) then
    warn("styles must be a table")
  end
  if opts.on_highlights ~= nil and type(opts.on_highlights) ~= "function" then
    warn("on_highlights must be a function")
  end
  return ok
end

function M.merge(opts)
  return vim.tbl_deep_extend("force", M.defaults, opts or {})
end

return M
