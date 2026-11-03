-- tests/load_spec.lua
local matcha = require("matcha")

local function fg(name)
  local hl = vim.api.nvim_get_hl(0, { name = name })
  if type(hl.fg) == "number" then return string.format("#%06X", hl.fg) end
  return hl.fg
end

local function bg(name)
  local hl = vim.api.nvim_get_hl(0, { name = name })
  if hl.bg == nil then return nil end
  if type(hl.bg) == "number" then return string.format("#%06X", hl.bg) end
  return hl.bg
end

describe("load", function()
  it("loads morning and reports its name", function()
    matcha.setup({ variant = "morning", terminal_colors = false })
    matcha.load()
    equals("matcha-morning", vim.g.colors_name)
    equals("#34382F", fg("Normal"))
    equals("#F3F1E9", bg("Normal"))
  end)

  it("loads evening", function()
    matcha.setup({ variant = "evening", terminal_colors = false })
    matcha.load()
    equals("matcha-evening", vim.g.colors_name)
    equals("#E8E5D9", fg("Normal"))
    equals("#22251F", bg("Normal"))
  end)

  it("auto variant follows background", function()
    matcha.setup({ variant = "auto", terminal_colors = false })
    vim.o.background = "light"
    matcha.load()
    equals("matcha-morning", vim.g.colors_name)
    vim.o.background = "dark"
    matcha.load()
    equals("matcha-evening", vim.g.colors_name)
  end)

  it("transparent removes Normal background", function()
    matcha.setup({ variant = "morning", transparent = true, terminal_colors = false })
    vim.cmd("colorscheme matcha-morning")
    equals(nil, bg("Normal"))
  end)

  it("terminal_colors sets terminal_color_0..15", function()
    matcha.setup({ variant = "morning", terminal_colors = true })
    vim.cmd("colorscheme matcha-morning")
    local p = require("matcha.palette.morning")
    for i = 0, 15 do assert_true(vim.g["terminal_color_" .. i] ~= nil, "missing terminal_color_" .. i) end
    equals(p.terminal.black, vim.g.terminal_color_0)
  end)

  it("syntax comment is italic by default", function()
    matcha.setup({ variant = "morning", terminal_colors = false })
    matcha.load()
    local hl = vim.api.nvim_get_hl(0, { name = "Comment" })
    equals(true, hl.italic)
    equals("#77796D", string.format("#%06X", hl.fg))
  end)

  it("dim_inactive dims NormalNC foreground", function()
    matcha.setup({ variant = "morning", dim_inactive = true, terminal_colors = false })
    vim.cmd("colorscheme matcha-morning")
    equals("#616359", fg("NormalNC"))
  end)
end)
