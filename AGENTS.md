# AGENTS.md — matcha.nvim

Instructions for AI coding agents (and humans) working on **matcha.nvim**, the Neovim adapter for the **Kanso Matcha** design system (Zen × Wabi-Sabi × Matcha).

Read this file fully before changing anything. Then read `roadmap.md` for what to build next.

---

## 1. What this project is

matcha.nvim is a Neovim colorscheme with two variants:

| Variant | Colorscheme name | Atmosphere |
|---|---|---|
| Morning Matcha (light) | `matcha-morning` | Warm paper, stone text, muted botanical green |
| Evening Zen (dark) | `matcha-evening` | Charcoal-earth, warm text, soft green highlights |

`:colorscheme matcha` picks the variant from `vim.o.background` (`light` → morning, `dark` → evening).

It is an **adapter**, not a design system. The palette and semantic meaning live in the Kanso Matcha Canonical Token Specification (v1.0). This repo translates those tokens into Neovim highlight groups. Nothing more.

**Principle to protect: one identity, one palette, one semantic language, many implementations.** matcha.nvim must never become the source of truth for any color.

---

## 2. Prime directives (non-negotiable)

1. **No competing palette.** Every color that reaches a highlight group must trace back to a canonical token (semantic, domain, or primitive). Never write a raw hex value in `groups/` or `init.lua`.
2. **Adapters consume semantic and domain tokens, not primitives.** Use `background`, `surface`, `accent-strong`, `syntax.keyword`, … Reach for primitives only when generating palette files.
3. **Native implementation, no runtime theme dependency.** The plugin is plain Lua. No runtime JSON parsing, no dependency on another plugin, no network. Tokens are compiled to Lua tables at build time and committed.
4. **Contrast targets are not negotiable.** Text 4.5:1, large text 3:1, essential UI boundaries 3:1, visible focus, and color is never the only indicator of meaning. If a pair fails, fix the *semantic foreground/background upstream* — never lower the target and never quietly patch the hex locally.
5. **Restraint is the identity.** Not every syntax token needs a unique color. No glow, gradients, or neon. Prefer layered surfaces over many unrelated colors.
6. **Declare the supported design-system version** (`lua/matcha/palette/_meta.lua` → `design_system_version`). Never silently diverge from the canonical source.

If a task seems to require breaking one of these, stop and ask the maintainer instead of working around it.

---

## 3. Source of truth and token flow

```
canonical tokens (JSON, DTCG-style)        <- NOT owned by this repo
        │  vendored at a pinned version
        ▼
tokens/                                    <- read-only copy + TOKENS_VERSION
        │  scripts/build-palette.lua
        ▼
lua/matcha/palette/{morning,evening}.lua   <- GENERATED, committed, "DO NOT EDIT"
        │
        ▼
lua/matcha/groups/*.lua                    <- hand-written mappings (token names only)
        │
        ▼
vim.api.nvim_set_hl(...)
```

Rules:

- `tokens/` is a vendored snapshot. Do not hand-edit it. Update it only via `scripts/sync-tokens.lua` and bump `TOKENS_VERSION`.
- Generated palette files start with a `-- GENERATED FILE — DO NOT EDIT` header and include the token version. CI fails if regenerating produces a diff.
- If a token you need doesn't exist, **do not invent one in this repo.** Follow section 6 (missing roles).
- Token names are lowercase kebab-case in the spec (`surface-elevated`, `syntax.keyword`). In Lua they are exposed as nested tables with snake_case keys: `p.surface_elevated`, `p.syntax.keyword`, `p.diff.added_bg`. The mapping is mechanical and done by the generator.

> Open item: where the canonical token repo lives and how it is vendored (submodule vs. copy script) is not decided yet. See roadmap Phase 0. Until then, `tokens/` is a manual copy.

---

## 4. Repository layout

```
matcha.nvim/
├── colors/
│   ├── matcha.lua              # follows vim.o.background
│   ├── matcha-morning.lua
│   └── matcha-evening.lua
├── lua/matcha/
│   ├── init.lua                # setup(), load(), public API
│   ├── config.lua              # defaults + validation
│   ├── derive.lua              # the ONLY place colors are computed (see §6)
│   ├── palette/
│   │   ├── _meta.lua           # design_system_version, generated stamp
│   │   ├── morning.lua         # GENERATED
│   │   └── evening.lua         # GENERATED
│   ├── groups/
│   │   ├── editor.lua          # Normal, CursorLine, Pmenu, Visual, Search, …
│   │   ├── syntax.lua          # legacy Vim syntax groups
│   │   ├── treesitter.lua      # @capture groups
│   │   ├── lsp.lua             # @lsp.* semantic tokens, LspReference*
│   │   ├── diagnostics.lua
│   │   ├── diff.lua
│   │   ├── markdown.lua
│   │   ├── terminal.lua        # vim.g.terminal_color_0..15
│   │   └── plugins/            # one file per integration
│   └── extras/                 # lualine theme, etc.
├── tokens/                     # vendored canonical tokens (read-only)
├── scripts/                    # run with `nvim -l`
│   ├── sync-tokens.lua
│   ├── build-palette.lua
│   ├── check-contrast.lua
│   ├── check-provenance.lua
│   ├── dump-highlights.lua
│   └── gen-preview.lua
├── tests/
├── docs/
│   ├── mapping.md              # token → highlight group table (generated where possible)
│   ├── derivations.md          # every computed color and why
│   └── decisions.md            # short ADR-style log
├── AGENTS.md
└── roadmap.md
```

Scripts are Lua run through `nvim -l` so the project needs **no Node/Python toolchain** — only Neovim.

---

## 5. Mapping rules (token → highlight group)

Use the semantic roles as the spec defines them:

| Role | Use for |
|---|---|
| `background` | Canvas only (`Normal`, `SignColumn`, `EndOfBuffer`) — not a generic component fill |
| `surface` | Grouped content, panels, status line, folds |
| `surface-elevated` | Floating UI: popup menu, floats, hover docs, dialogs |
| `surface-sunken` | Inset/recessed areas: code blocks, `markdown.code-bg` |
| `surface-accent` / `selection` | Soft matcha emphasis, Visual selection |
| `text-primary` | Important readable content |
| `text-secondary` | Supporting content (line numbers, inactive status line) |
| `text-muted` | Non-essential only. Never hide essential info with it |
| `border-subtle` / `border-strong` | Separators / boundaries that must stay visible |
| `accent-primary` | Signature color, **not automatically text-safe** |
| `accent-strong` | Preferred accent for text and high-importance controls |
| `focus` | Must remain distinguishable from ordinary borders |
| `success` / `warning` / `danger` / `info` | Semantic states, used sparingly |

Core mapping (full list lives in `docs/mapping.md`):

| Highlight group | fg | bg | Notes |
|---|---|---|---|
| `Normal` | `text-primary` | `background` | |
| `NormalFloat` | `text-primary` | `surface-elevated` | |
| `FloatBorder` | `border-strong` | `surface-elevated` | |
| `Visual` | — | `selection` | Must not obscure text |
| `CursorLine` | — | derived (D1) | Subtle, never a loud bar |
| `CursorLineNr` | `accent-strong` | — | |
| `LineNr` | `text-muted` | — | |
| `WinSeparator` | `border-subtle` | — | |
| `Pmenu` / `PmenuSel` | `text-primary` | `surface-elevated` / `selection` | |
| `StatusLine` | `text-secondary` | `surface` | |
| `Folded` | `text-secondary` | `surface` | |
| `Search` / `CurSearch` | see §6 | see §6 | |
| `DiagnosticError/Warn/Info/Ok` | `danger/warning/info/success` | — | Underline/undercurl so color isn't the only cue |
| `DiffAdd/Delete/Change` | `diff.*` | `diff.*-bg` | |
| `Comment` | `syntax.comment` | — | Italic is a config option |
| `String` / `Number` / `Function` / `Keyword` / `Type` | `syntax.string/number/function/keyword/type` | — | |

Domain rules:

- **Syntax:** use the `syntax.*` tokens. Treesitter captures and `@lsp.*` groups should *link* to a small set of base groups so one decision changes everything consistently. Prefer `link` over duplicating attributes.
- **Markdown:** follow the `markdown.*` token table (e.g. `markdown.link` → `info`, `markdown.code-bg` → `surface-sunken`, `markdown.quote-border` → `accent-secondary`). Heading text is `text-primary`; heading markers use `accent-strong`.
- **Terminal:** set `vim.g.terminal_color_0` … `15` from the ANSI table. Verify actual rendering (see §8).
- **Diff:** use `diff.*` and `diff.*-bg` as given.
- **Charts:** not applicable to Neovim core, but any plugin that needs categorical colors uses the chart sequence in order.

---

## 6. Missing roles and derived colors

Neovim needs roles the spec doesn't define (search match, cursorline, diagnostic virtual-text background, …). The process:

1. **Check if an existing semantic token fits.** Prefer that.
2. **If not, derive** the value from existing semantic tokens in `derive.lua` — a deterministic blend (e.g. `blend(background, warning, 0.25)`). Derivations must:
   - only take canonical tokens as input,
   - live in `derive.lua` and nowhere else,
   - be listed in `docs/derivations.md` with the reason and the contrast result,
   - be named and numbered (D1, D2, …).
3. **Propose the missing role upstream** as an additive (minor) token — e.g. `highlight-match`, `cursorline`, `line-number`. Once it lands, replace the derivation and bump the supported design-system version.

Initial derivations (proposed, pending maintainer approval):

| ID | Role | Derivation |
|---|---|---|
| D1 | `CursorLine` background | `blend(background, surface, 0.5)` |
| D2 | `Search` background | `blend(background, warning, 0.25)` |
| D3 | `Diagnostic*` virtual-text background | `blend(background, <state>, 0.10)` |

Never add a derivation just to get a prettier result. If something looks wrong, that's a design question for upstream.

---

## 7. Configuration API

Keep it small. Sensible defaults, no option sprawl.

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

- Defaults and validation live in `config.lua`. Invalid options produce a single clear `vim.notify` warning, never a crash.
- `on_highlights` receives the highlight table and the active palette so users can customize. Overrides made there are the user's responsibility; the repo's own tests run with defaults only.
- Defaults for `styles` (comments italic, everything else plain) are a proposal. Keep them easy to change.

---

## 8. Validation and testing

Everything below must be runnable headlessly with Neovim only.

| Check | Command | What it enforces |
|---|---|---|
| Build palette | `nvim -l scripts/build-palette.lua` | Regenerates palette files; CI fails on any diff |
| Contrast | `nvim -l scripts/check-contrast.lua` | Every fg/bg pair actually used by highlight groups meets its target (4.5 text, 3.0 large text and UI boundaries) in **both** variants |
| Provenance | `nvim -l scripts/check-provenance.lua` | Every color in every highlight group equals a canonical token or a documented derivation. No stray hex |
| Highlight snapshot | `nvim -l scripts/dump-highlights.lua` | Dumps all groups to JSON for snapshot comparison |
| Unit tests | `nvim --headless -c "lua require('plenary.test_harness').test_directory(...)"` (plenary) | Config validation, variant switching, `transparent`, integration autoloading, link integrity |
| Preview | `nvim -l scripts/gen-preview.lua` | Generates swatches and sample-file renders |

Contrast rules:

- Check the pairs that actually occur in practice (`Comment` on `Normal`, `LineNr` on `Normal`, `Visual` text on `selection`, `PmenuSel`, diff fg on diff bg, diagnostics on their virtual-text bg), not just a hand-picked few.
- The spec itself warns that decorative tones (e.g. `#89977A` on `#F3F1E9`) are not text-safe. `accent-primary` as foreground text in light mode is a bug; use `accent-strong`.
- Failures are reported with the pair, the ratio, and the target. **Do not "fix" a failure by changing a hex in this repo** — report it and propose an upstream change.
- Known suspects to verify first (computed by hand, not yet by script): light-mode `syntax.comment`, `syntax.operator` and `syntax.punctuation` (`#77796D` on `#F3F1E9`) appear to fall below 4.5:1. Confirm programmatically before reacting.

Terminal palette: the spec says ANSI values are starting points and each adapter must verify real rendering. In particular, Evening Zen ANSI black (`#22251F`) equals the background, so black-on-background text in `:terminal` would be invisible. Flag this upstream; do not silently remap.

Plugin integrations: each integration file is covered by at least one test that loads it and asserts its groups resolve to tokens/derivations.

---

## 9. Performance

Startup cost matters; this is a theme, it runs on every launch.

- No `vim.json.decode` or file IO at runtime; palettes are pre-generated Lua tables.
- No work for plugins that aren't installed. Integration files are required lazily, only when the plugin is detected (or explicitly enabled).
- Batch `nvim_set_hl` calls; don't call `:highlight clear` more than once.
- Target (to be measured, not assumed): loading the colorscheme adds only a few milliseconds on a cold start. Track the number in `docs/decisions.md` and guard against regressions.

---

## 10. Plugin integration policy

- **Tier 1 (ship with v1.0):** built-in UI, Treesitter, LSP, diagnostics, gitsigns, telescope / fzf-lua / snacks picker, blink.cmp / nvim-cmp, neo-tree / nvim-tree / oil, which-key, indent-blankline, lazy.nvim, mini.*, render-markdown.nvim, trouble, flash.
- **Tier 2:** lualine theme, noice, dap-ui, others on request.
- One file per integration in `groups/plugins/`, using only tokens, derivations, and `link`s to base groups.
- Prefer linking to built-in groups (`link = "NormalFloat"`) over redefining colors. Plugins should inherit the look rather than add visual noise.
- Don't add an integration without a way to test that its groups resolve.

---

## 10a. Conventions

- Lua, Neovim 0.10+ (test against stable and nightly). Use `vim.api.nvim_set_hl`, `vim.g.terminal_color_*`, `@capture` groups.
- Format with StyLua; lint with luacheck/selene. Config files checked in.
- Annotate with LuaLS types (`---@class matcha.Palette`, etc.).
- Small modules, no globals, no side effects on `require`.
- Commit style: Conventional Commits (`feat(groups): …`, `fix(contrast): …`, `chore(tokens): sync to 1.0.1`).
- Document every non-obvious decision in `docs/decisions.md` as a 3–5 line entry.

---

## 11. Versioning

Two independent version numbers:

- **Design-system version** (from the token spec): recorded in `tokens/TOKENS_VERSION` and `_meta.lua`.
- **matcha.nvim version** (semver): patch = fixes, minor = new integrations/options, major = breaking config or highlight-group renames.

A primitive-color change in the tokens triggers: contrast validation → preview regeneration → adapter review → updated snapshots → release notes. Follow that order.

---

## 12. Definition of done (per change)

- [ ] No raw hex outside generated palette files
- [ ] `build-palette` produces no diff
- [ ] Contrast and provenance checks pass for **both** variants
- [ ] Tests pass; snapshot updated intentionally, with explanation
- [ ] `docs/mapping.md` / `docs/derivations.md` updated if mappings or derivations changed
- [ ] Looked at in a real Neovim session on a few filetypes (Lua, TS/TSX, Markdown, diff) in both variants

---

## 13. Do / Don't

**Do**
- Map to the semantic role the token *means*, not the one that happens to look right.
- Use `link` wherever possible.
- Keep one decision in one place.
- Ask when the spec is ambiguous or a pair fails contrast.

**Don't**
- Don't add colors, tweak hex values, or add "just one more shade".
- Don't use `accent-primary` for normal-size text.
- Don't use color as the only signal (add underline/undercurl/bold/icons for states).
- Don't add runtime dependencies or heavy compile steps.
- Don't hand-edit `palette/*.lua` or `tokens/`.
- Don't add gradients, glow, or transparency effects that aren't opt-in.

---

## 14. Open questions for the maintainer

1. **Token source:** resolved — canonical tokens live at `~/kanso_design_system` (see `docs/decisions.md`). Vendoring is manual (no submodule, no sync script).
2. **Contrast:** resolved — fix via upstream token adjustment (not a documented exemption). (see `docs/decisions.md`)
3. **Missing roles:** resolved — D1, D2, D3 approved; `DiagnosticHint` = `text-secondary` fg + `accent-secondary` undercurl. (see `docs/decisions.md`)
4. **ANSI black (Evening):** resolved — adjust upstream (not accept). (see `docs/decisions.md`)
5. **Default styles:** resolved — comments italic on by default (everything else plain). (see `docs/decisions.md`)
6. **Test runner:** resolved — plenary (not mini.test). (see `docs/decisions.md`)

