-- tests/harness.lua
-- Minimal dependency-free test harness for matcha.nvim.
local M = {}

M.passed = 0
M.failed = 0
M.failures = {}
M.queue = {}

local level = 0
local prefix = "  "

local function push(name, fn)
  M.queue[#M.queue + 1] = { name = name, fn = fn }
end

_G.describe = function(name, fn)
  level = level + 1
  fn()
  level = level - 1
end

_G.it = function(name, fn)
  local full = string.rep(prefix, level) .. name
  push(full, fn)
end

function M.dump(msg) io.write("  " .. (msg or "") .. "\n") end

-- assertions ---------------------------------------------------------------
function M.equals(expected, actual, msg)
  if expected ~= actual then
    error(string.format("%s: expected %s, got %s", msg or "values differ", vim.inspect(expected), vim.inspect(actual)), 2)
  end
end

function M.equals_deep(a, b, msg)
  local function eq(x, y)
    if type(x) ~= type(y) then return false end
    if type(x) ~= "table" then return x == y end
    for k, v in pairs(x) do if not eq(v, y[k]) then return false end end
    for k, v in pairs(y) do if x[k] == nil then return false end end
    return true
  end
  if not eq(a, b) then
    error((msg or "tables differ") .. ": " .. vim.inspect(a) .. " <> " .. vim.inspect(b), 2)
  end
end

function M.assert_true(v, msg)
  if not v then error(msg or "expected truthy", 2) end
end

function M.hex(v, msg)
  local s = type(v) == "number" and string.format("#%06X", v) or v
  if not tostring(s):match("^#%x%x%x%x%x%x$") then
    error(msg or ("expected hex string, got " .. tostring(s)), 2)
  end
end

_G.equals = M.equals
_G.equals_deep = M.equals_deep
_G.assert_true = M.assert_true
_G.hex = M.hex

-- runner -------------------------------------------------------------------
function M.run()
  M.passed, M.failed, M.failures = 0, 0, {}
  for _, t in ipairs(M.queue) do
    local ok, err = pcall(t.fn)
    if ok then
      M.passed = M.passed + 1
      io.write("ok   " .. t.name .. "\n")
    else
      M.failed = M.failed + 1
      M.failures[#M.failures + 1] = t.name .. "\n  " .. tostring(err)
      io.write("FAIL " .. t.name .. "\n  " .. tostring(err) .. "\n")
    end
  end
  io.write(string.format("\n%d passed, %d failed\n", M.passed, M.failed))
  if M.failed > 0 then os.exit(1) end
  return true
end

return M
