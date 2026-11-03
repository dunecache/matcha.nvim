-- tests/config_spec.lua
local config = require("matcha.config")

describe("config", function()
  it("defaults include styles and options", function()
    equals("auto", config.defaults.variant)
    equals(false, config.defaults.transparent)
    equals(true, config.defaults.styles.comments.italic)
    equals("undercurl", config.defaults.styles.underline_diagnostics)
  end)

  it("merges user options over defaults", function()
    local c = config.merge({ variant = "evening", transparent = true })
    equals("evening", c.variant)
    equals(true, c.transparent)
    equals(true, c.styles.comments.italic) -- untouched default kept
  end)

  it("rejects invalid variant", function()
    local captured = {}
    local orig = vim.notify
    vim.notify = function(msg) captured[#captured + 1] = msg end
    equals(false, config.validate({ variant = "banana" }))
    vim.notify = orig
    assert_true(#captured > 0, "expected a warning for invalid variant")
  end)

  it("rejects non-boolean transparent", function()
    local orig = vim.notify
    vim.notify = function() end
    equals(false, config.validate({ transparent = "yes" }))
    vim.notify = orig
  end)

  it("rejects non-function on_highlights", function()
    local orig = vim.notify
    vim.notify = function() end
    equals(false, config.validate({ on_highlights = 42 }))
    vim.notify = orig
  end)
end)
