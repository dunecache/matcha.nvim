local M = {}
M.loaded = function(name) return package.loaded[name] ~= nil end
M.any = function(names)
  for _, n in ipairs(names) do if package.loaded[n] ~= nil then return true end end
  return false
end
M.cmd = function(name) return vim.fn.exists(":" .. name) ~= 0 end
M.glob = function(name) return vim.g[name] ~= nil end
return M
