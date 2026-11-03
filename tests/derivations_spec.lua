-- tests/derivations_spec.lua
local derive = require("matcha.derive")

describe("derivations", function()
  it("blend of red into white scales linearly", function()
    -- 50% of red into white rounds to (255,128,128)
    equals("#FF8080", derive.blend("#FFFFFF", "#FF0000", 0.5))
    equals("#000000", derive.blend("#000000", "#000000", 0.3))
  end)

  it("compute produces D1/D2/D3 from tokens", function()
    local p = require("matcha.palette.morning")
    local d = derive.compute(p)
    equals(derive.blend(p.background, p.surface, 0.5), d.cursorline_bg)
    equals(derive.blend(p.background, p.warning, 0.25), d.search_bg)
    equals(derive.blend(p.background, p.danger, 0.10), d.diag_error_vt_bg)
  end)
end)
