# Mapping — token → highlight group

Core UI (see `lua/matcha/groups/editor.lua`):

| Group | fg | bg |
|---|---|---|
| `Normal` | `text-primary` | `background` (NONE when transparent) |
| `NormalNC` | `text-primary` (`text-secondary` when `dim_inactive`) | `background` |
| `NormalFloat` | `text-primary` | `surface-elevated` |
| `FloatBorder` | `border-strong` | `surface-elevated` |
| `Cursor` | `background` | `text-primary` |
| `CursorLine` | — | D1 `blend(background, surface, 0.5)` |
| `CursorLineNr` | `accent-strong` | — |
| `LineNr` | `text-muted` | — |
| `Visual` | — | `selection` |
| `Search` | `text-primary` | D2 `blend(background, warning, 0.25)` |
| `IncSearch` / `CurSearch` | `background` | `warning` |
| `Pmenu` / `PmenuSel` | `text-primary` | `surface-elevated` / `selection` |
| `StatusLine` | `text-secondary` | `surface` |
| `Folded` | `text-secondary` | `surface` |
| `WinSeparator` | `border-subtle` | — |

Syntax (`groups/syntax.lua`): legacy Vim groups → `syntax.*` tokens. `String`/`Number`/`Function`/`Keyword`/`Type` map to `syntax.string`/`number`/`function`/`keyword`/`type`.

Treesitter (`groups/treesitter.lua`): `@capture` groups link to legacy base groups so one decision governs all.

LSP (`groups/lsp.lua`): `@lsp.type.*`/`@lsp.mod.*` link to Treesitter equivalents; `LspReference*` use `surface-accent`; `@lsp.mod.deprecated` → `DiagnosticDeprecated` (strikethrough).

Diagnostics (`groups/diagnostics.lua`): `Diagnostic*` use `danger`/`warning`/`info`/`success` with undercurl (never color alone); `DiagnosticHint` uses `text-secondary` + `accent-secondary` undercurl. Virtual text uses D3.

Diff: `DiffAdd/Delete/Change` → `diff.*` fg on `diff.*-bg`.

Markdown (`groups/markdown.lua`): `markdown.*` tokens; e.g. `code` on `surface-sunken`, `link` → `info`, `heading` → `text-primary`, heading markers → `accent-strong`.

Terminal (`groups/terminal.lua`): `vim.g.terminal_color_0..15` from the ANSI token table, in order black…bright-white.

## Upstream token proposals

Derivations that should become canonical tokens (file upstream):

- `cursorline` (replaces D1)
- `highlight-match` (replaces D2)
- `line-number`, `dim-inactive`
- `diagnostic-hint` and `<state>` virtual-text backgrounds (replaces D3)
- corrected Evening ANSI black so it differs from the background
