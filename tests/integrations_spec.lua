-- tests/integrations_spec.lua
local matcha = require("matcha")

describe("integrations", function()
  it("collects groups for a loaded plugin only", function()
    package.loaded["gitsigns"] = {}
    local opts = { integrations = "auto" }
    local p = require("matcha.palette.morning")
    local d = require("matcha.derive").compute(p)
    local h = require("matcha.groups.plugins").collect(p, opts, d)
    assert_true(h.GitSignsAdd ~= nil, "gitsigns groups should resolve when loaded")
    equals(p.diff.added, h.GitSignsAdd.fg)
  end)

  it("is disabled by integrations = false", function()
    local opts = { integrations = false }
    local p = require("matcha.palette.morning")
    local d = require("matcha.derive").compute(p)
    local h = require("matcha.groups.plugins").collect(p, opts, d)
    equals(0, vim.tbl_count(h))
  end)

  it("table form enables/disables individually", function()
    package.loaded["gitsigns"] = {}
    local p = require("matcha.palette.morning")
    local d = require("matcha.derive").compute(p)
    local on = require("matcha.groups.plugins").collect(p, { integrations = { gitsigns = true } }, d)
    assert_true(on.GitSignsAdd ~= nil, "explicit enable should work")
    local off = require("matcha.groups.plugins").collect(p, { integrations = { gitsigns = false } }, d)
    equals(nil, off.GitSignsAdd, "explicit disable should omit the group")
  end)
end)
