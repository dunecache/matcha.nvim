-- tests/run.lua — run: nvim --headless -l tests/run.lua
local root = vim.fn.getcwd()
vim.opt.rtp:prepend(root)
package.path = root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path

local harness = require("tests.harness")

local specs = {
  "tests/config_spec",
  "tests.load_spec",
  "tests.derivations_spec",
  "tests.integrations_spec",
  "tests.options_spec",
  "tests.links_spec",
  "tests.provenance_spec",
}

for _, name in ipairs(specs) do
  local ok, err = pcall(require, name)
  if not ok then
    io.write("ERROR loading " .. name .. ": " .. tostring(err) .. "\n")
    os.exit(1)
  end
end

harness.run()
