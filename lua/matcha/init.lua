-- lua/matcha/init.lua
local M = {}

local config = require("matcha.config")
local derive = require("matcha.derive")

M.config = config.defaults

function M.setup(opts)
  if not config.validate(opts) then
    vim.notify("matcha: invalid options; using defaults", vim.log.levels.WARN)
    opts = {}
  end
  M.config = config.merge(opts)
  return M.config
end

local function resolve_variant(variant)
  if variant == "auto" or variant == nil then
    return vim.o.background == "dark" and "evening" or "morning"
  end
  return variant
end

function M.load(variant_override)
  local opts = M.config
  local variant = resolve_variant(variant_override or opts.variant)
  vim.cmd("highlight clear")
  vim.g.colors_name = "matcha-" .. variant

  local p = require("matcha.palette." .. variant)
  local derived = derive.compute(p)

  local editor = require("matcha.groups.editor")
  local syntax = require("matcha.groups.syntax")

  local hl = {}
  hl = vim.tbl_extend("force", hl, editor.get(p, opts, derived))
  hl = vim.tbl_extend("force", hl, syntax.get(p, opts))
  hl = vim.tbl_extend("force", hl, require("matcha.groups.treesitter").get(p, opts))
  hl = vim.tbl_extend("force", hl, require("matcha.groups.lsp").get(p, opts))
  hl = vim.tbl_extend("force", hl, require("matcha.groups.diagnostics").get(p, opts, derived))
  hl = vim.tbl_extend("force", hl, require("matcha.groups.markdown").get(p, opts))
  hl = vim.tbl_extend("force", hl, require("matcha.groups.plugins").collect(p, opts, derived))

  if opts.on_highlights then
    local ok, overrides = pcall(opts.on_highlights, hl, p)
    if ok and type(overrides) == "table" then
      for k, v in pairs(overrides) do
        hl[k] = v
      end
    end
  end

  for name, val in pairs(hl) do
    if type(val) == "table" then
      vim.api.nvim_set_hl(0, name, val)
    end
  end

  if opts.terminal_colors then
    local terminal = require("matcha.groups.terminal")
    terminal.apply(p)
  end

  return hl
end

return M
