# matcha.nvim

A Neovim colorscheme, adapter for the **Kanso Matcha** design system (Morning Matcha / Evening Zen).
Zen × Wabi-Sabi × Matcha — one identity, one palette, many implementations.

- Variant follows `vim.o.background` (`light` → Morning Matcha, `dark` → Evening Zen).
- Native Lua: no runtime theme dependency, no plugin dependencies, no network, no JSON parsing at runtime.
- Every color traces back to a canonical token or a documented derivation.

## Install

lazy.nvim:

```lua
{
  "your-org/matcha.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("matcha")
  end,
}
```

## Configuration

```lua
require("matcha").setup({
  variant = "auto",            -- "auto" | "morning" | "evening"
  transparent = false,         -- background = NONE for Normal/NormalNC/SignColumn
  terminal_colors = true,      -- set vim.g.terminal_color_*
  dim_inactive = false,
  styles = {
    comments = { italic = true },
    keywords = {},
    functions = {},
    strings = {},
    underline_diagnostics = "undercurl",
  },
  integrations = "auto",       -- "auto" detects loaded plugins, or a table { telescope = true, ... }
  on_highlights = nil,         -- function(hl, p) end — user overrides, user's responsibility
})
vim.cmd.colorscheme("matcha")
```

## Checks and tests

```
nvim -l scripts/build-palette.lua       # regenerate palettes from vendored tokens (CI diff)
nvim -l scripts/check-contrast.lua      # WCAG ratios for every fg/bg pair used
nvim -l scripts/check-provenance.lua    # every color maps to a token or documented derivation
nvim -l scripts/dump-highlights.lua     # JSON snapshot of all groups
nvim -l scripts/gen-preview.lua         # HTML swatches for both variants
nvim --headless -l tests/run.lua        # test suite
```

## Layout

`tokens/` vendored canonical tokens · `lua/matcha/palette/` generated (do not edit) ·
`lua/matcha/groups/` hand-written token mappings · `docs/` mapping, derivations, decisions.
