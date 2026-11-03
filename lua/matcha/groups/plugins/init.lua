-- lua/matcha/groups/plugins/init.lua
-- Loads applicable integrations and returns a merged highlight table.
local M = {}

local NAMES = {
  "gitsigns", "telescope", "cmp", "blink", "neotree", "oil", "which_key",
  "indent_blankline", "lazy", "mini", "render_markdown", "trouble", "flash",
}

function M.collect(p, opts, derived)
  local result = {}

  local function enabled(name)
    local desired = opts.integrations
    if desired == nil then return false end -- setup() always provides a default; nil means unspecified here
    if desired == true or desired == "auto" then return true end
    if desired == false then return false end
    if type(desired) == "table" then
      local v = desired[name]
      if v == nil then return false end
      return v and true or false
    end
    return false
  end

  for _, name in ipairs(NAMES) do
    if enabled(name) then
      local module_path = "matcha.groups.plugins." .. name
      local ok, mod = pcall(require, module_path)
      if ok and type(mod) == "table" and type(mod.detect) == "function" then
        if mod.detect() then
          local ok2, tbl = pcall(mod.get, p, opts, derived)
          if ok2 and type(tbl) == "table" then
            result = vim.tbl_extend("force", result, tbl)
          end
        end
      end
    end
  end

  return result
end

return M
