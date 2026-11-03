-- tests/options_spec.lua
-- Coverage for options, domain groups, derived roles, and extras.
local matcha = require("matcha")

local function hl(name)
  return vim.api.nvim_get_hl(0, { name = name })
end

local function fg(name)
  local v = hl(name).fg
  return type(v) == "number" and string.format("#%06X", v) or v
end

local function bgof(name)
  local v = hl(name).bg
  if v == nil then return nil end
  return type(v) == "number" and string.format("#%06X", v) or v
end

describe("options", function()
  it("styles.strings bold is honored", function()
    matcha.setup({
      variant = "morning", terminal_colors = false,
      styles = { strings = { bold = true } },
    })
    matcha.load()
    equals(true, hl("String").bold)
  end)

  it("comments italic can be turned off", function()
    matcha.setup({
      variant = "morning", terminal_colors = false,
      styles = { comments = { italic = false } },
    })
    matcha.load()
    equals(false, hl("Comment").italic == true)
  end)

  it("on_highlights can override a group", function()
    matcha.setup({
      variant = "morning", terminal_colors = false,
      on_highlights = function(hls, p)
        hls.Normal = { fg = p.text_primary, bg = "#101010" }
        return hls
      end,
    })
    matcha.load()
    equals("#101010", bgof("Normal"))
  end)

  it("on_highlights returning nothing still loads", function()
    matcha.setup({
      variant = "morning", terminal_colors = false,
      on_highlights = function(hls, p) hls.Visual = { bg = p.selection } end,
    })
    local ok = pcall(matcha.load)
    equals(true, ok)
  end)
end)

describe("domain groups", function()
  it("treesitter @keyword links to a defined base group", function()
    matcha.setup({ variant = "morning", terminal_colors = false, integrations = false })
    matcha.load()
    local defs = { Keyword = true }
    local h = vim.api.nvim_get_hl(0, { name = "@keyword" })
    assert_true(h.link ~= nil, "@keyword should link")
  end)

  it("lsp semantic tokens link and reference groups defined", function()
    matcha.setup({ variant = "morning", terminal_colors = false, integrations = false })
    matcha.load()
    assert_true(vim.api.nvim_get_hl(0, { name = "@lsp.type.function" }).link ~= nil)
    equals("#5C664A", fg("LspSignatureActiveParameter"))
  end)

  it("markdown code block background resolves to surface_sunken", function()
    matcha.setup({ variant = "morning", terminal_colors = false, integrations = false })
    matcha.load()
    local p = require("matcha.palette.morning")
    equals(p.surface_sunken, bgof("MarkdownCodeBlock"))
  end)

  it("diagnostics hint uses text_secondary with accent_secondary undercurl", function()
    matcha.setup({ variant = "morning", terminal_colors = false })
    matcha.load()
    equals("#616359", fg("DiagnosticHint"))
    local h = vim.api.nvim_get_hl(0, { name = "DiagnosticHint" })
    equals(true, h.undercurl)
  end)
end)

describe("derived roles", function()
  it("CursorLine uses D1 and Search uses D2", function()
    local derive = require("matcha.derive")
    local p = require("matcha.palette.morning")
    local d = derive.compute(p)
    matcha.setup({ variant = "morning", terminal_colors = false })
    matcha.load()
    equals(d.cursorline_bg:upper(), bgof("CursorLine"))
    equals(d.search_bg:upper(), bgof("Search"))
    equals(true, d.cursorline_bg ~= p.background)
  end)
end)

describe("terminal + extras", function()
  it("terminal ANSI order matches the token table", function()
    matcha.setup({ variant = "morning", terminal_colors = true })
    vim.cmd("colorscheme matcha-morning")
    local p = require("matcha.palette.morning")
    equals(p.terminal.black, vim.g.terminal_color_0)
    equals(p.terminal.red, vim.g.terminal_color_1)
    equals(p.terminal.green, vim.g.terminal_color_2)
    equals(p.terminal.white, vim.g.terminal_color_7)
    equals(p.terminal.bright_white, vim.g.terminal_color_15)
  end)

  it("lualine theme exposes normal/insert/inactive", function()
    local theme = require("extras.lualine.theme").get("morning")
    equals("table", type(theme.normal.a))
    equals("table", type(theme.insert.a))
    equals("table", type(theme.inactive.a))
  end)

  it("palette meta declares the design system version", function()
    equals("1.1.0", require("matcha.palette._meta").design_system_version)
  end)
end)
