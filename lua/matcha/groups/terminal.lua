-- lua/matcha/groups/terminal.lua
local M = {}

-- ANSI order 0..15
local ORDER = {
  "black", "red", "green", "yellow", "blue", "magenta", "cyan", "white",
  "bright_black", "bright_red", "bright_green", "bright_yellow",
  "bright_blue", "bright_magenta", "bright_cyan", "bright_white",
}

function M.apply(p)
  for i, key in ipairs(ORDER) do
    vim.g["terminal_color_" .. (i - 1)] = p.terminal[key]
  end
end

return M
