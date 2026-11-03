# roadmap.md — matcha.nvim

Neovim adapter for **Kanso Matcha** (Morning Matcha / Evening Zen). Spec target: **Canonical Token Specification v1.0**.

Each phase ends with a usable, shippable state. Check items off as they land. Rules and constraints are in `AGENTS.md`.

**Goal of v1.0:** a native-Lua colorscheme where every color traces to a canonical token, both variants pass the contrast targets, and the core Neovim UI plus the most common plugins look like one coherent family.

---

## Phase 0 — Foundation (no visible theme yet)

Goal: the pipeline exists, so nothing later can drift from the tokens.

- [ ] Create repo, license, README stub, StyLua + luacheck/selene config
- [ ] Decide token vendoring (submodule vs. `sync-tokens.lua`) and record it in `docs/decisions.md`
- [ ] Vendor the v1.0 tokens into `tokens/` with `TOKENS_VERSION`
- [ ] `scripts/build-palette.lua`: tokens → `palette/morning.lua`, `palette/evening.lua`, `_meta.lua` (GENERATED headers)
- [ ] `scripts/check-contrast.lua`: WCAG ratio calculator, reports pair / ratio / target
- [ ] `scripts/check-provenance.lua`: every hex in a highlight group maps to a token or derivation
- [ ] CI (GitHub Actions): build-diff check, contrast, provenance, tests on Neovim stable + nightly
- [ ] `derive.lua` skeleton + `docs/derivations.md`
- [ ] Run the contrast script on the raw spec pairs and file any failures upstream (light-mode comment/operator/punctuation first)

**Exit:** CI is green on an empty-but-wired project; regenerating palettes is a no-op.

---

## Phase 1 — Core UI and legacy syntax → `v0.1.0`

Goal: usable for daily editing in both variants.

- [ ] `colors/matcha.lua`, `matcha-morning.lua`, `matcha-evening.lua`; `auto` follows `vim.o.background`
- [ ] `config.lua` with defaults + validation; `setup()` and `load()`
- [ ] `groups/editor.lua`: Normal, NormalFloat, FloatBorder, Cursor, CursorLine(+Nr), LineNr, SignColumn, WinSeparator, Visual, Search/CurSearch/IncSearch, MatchParen, Pmenu*, StatusLine, TabLine, Folded, ColorColumn, messages, NonText/Whitespace
- [ ] `groups/syntax.lua`: legacy Vim syntax groups mapped to `syntax.*`
- [ ] Derivations D1 (cursorline) and D2 (search) implemented and documented
- [ ] Options: `transparent`, `dim_inactive`, `styles`, `on_highlights`
- [ ] Contrast + provenance pass for core UI in both variants
- [ ] First screenshots / swatches (`gen-preview.lua`)

**Exit:** `:colorscheme matcha` is pleasant and token-pure for plain Vim use, no Treesitter required.

---

## Phase 2 — Treesitter, LSP, diagnostics, diff, terminal → `v0.2.0`

Goal: modern language support looks right and consistent.

- [ ] `groups/treesitter.lua`: `@` captures linked to a small base set (variable, constant, string, number, function, method, keyword, type, property, operator, punctuation, tag, attribute, regexp, escape)
- [ ] Languages checked by eye: Lua, TypeScript/TSX, JSON, HTML/CSS, Markdown, Python, Rust, shell
- [ ] `groups/lsp.lua`: `@lsp.type.*` / `@lsp.mod.*` link to Treesitter equivalents; reference highlights; deprecated strikethrough
- [ ] `groups/diagnostics.lua`: error/warn/info/ok/hint, underline style, virtual text with derivation D3; decide Hint mapping
- [ ] `groups/diff.lua`: DiffAdd/Delete/Change/Text, Added/Removed/Changed
- [ ] `groups/markdown.lua`: `markdown.*` token mapping incl. heading markers, quotes, code bg, list markers, links
- [ ] `groups/terminal.lua`: ANSI 0–15 for both variants; verify real rendering and raise the Evening black-on-background issue upstream
- [ ] State cues: diagnostics, diffs, git signs never rely on color alone
- [ ] Snapshot test (`dump-highlights`) established

**Exit:** a full TSX + Markdown editing session in both variants feels coherent; all checks green.

---

## Phase 3 — Tier-1 plugin integrations → `v0.5.0`

Goal: the plugins people actually use look native.

- [ ] Lazy integration loader (`integrations = "auto"` detects loaded plugins; zero cost for absent ones)
- [ ] gitsigns
- [ ] telescope / fzf-lua / snacks picker
- [ ] blink.cmp / nvim-cmp
- [ ] neo-tree / nvim-tree / oil
- [ ] which-key
- [ ] indent-blankline (subtle: `border-subtle`; active scope `accent-secondary`)
- [ ] lazy.nvim
- [ ] mini.* (statusline, pick, files, diff, icons)
- [ ] render-markdown.nvim
- [ ] trouble, flash
- [ ] One test per integration: groups resolve to tokens or derivations
- [ ] Measure and record startup cost (`docs/decisions.md`)

**Exit:** typical plugin setups look consistent with zero manual overrides.

---

## Phase 4 — Polish, extras, and docs → `v0.9.0`

Goal: feature-complete, release candidate quality.

- [ ] lualine theme in `extras/`
- [ ] Tier-2 integrations as time allows: noice, dap-ui, others on request
- [ ] Full `docs/mapping.md` (generate from code where possible) and `docs/derivations.md`
- [ ] Propose upstream additive tokens for any recurring derivation (`highlight-match`, `cursorline`, `line-number`, …) and, if accepted, replace derivations and bump supported design-system version
- [ ] Review pass against spec section 7: restrained hierarchy, subtle borders, no glow/gradients, clear hover/active/focus/disabled states
- [ ] Accessibility review: focus visibility, color-not-sole-indicator, disabled vs. enabled distinguishable
- [ ] README with screenshots for both variants, install snippets (lazy.nvim, vim.pack), config reference
- [ ] Gather feedback from real daily use; fix paper cuts

**Exit:** nothing known to be wrong; docs complete.

---

## Phase 5 — Release → `v1.0.0`

Definition of done, adapted from the spec:

- [ ] Both variants complete for every required semantic and domain token consumed by Neovim
- [ ] Text and UI contrast checks pass for both variants (or each exception is documented and approved upstream)
- [ ] Token names and references validated; no raw hex outside generated palettes
- [ ] Preview swatches generated automatically in CI
- [ ] Declares the supported design-system version; changelog and release notes written
- [ ] Neovim stable and nightly tests green
- [ ] Tagged release; listed in awesome-neovim

---

## Post-1.0 (ideas, not commitments)

- Additional integrations on request
- Optional high-contrast or transparent presets (only if the design system defines them)
- Compile-to-cache loader if startup measurements justify it
- Keep in lockstep with the other Kanso Matcha adapters (Obsidian, Gboard/KOKE, etc.) via design-system minor/major releases

---

## Risks and open decisions

| Item | Why it matters | Needed by |
|---|---|---|
| Token source/vendoring | Everything else depends on a single source of truth | Phase 0 |
| Light-mode contrast of comments, operators, punctuation (`#77796D` on `#F3F1E9` looks ~3.9:1 by hand) | Spec demands 4.5:1; fix belongs upstream | Phase 0 |
| Missing roles (search, cursorline, virtual-text bg, hint) | Drives derivations vs. upstream tokens | Phase 1–2 |
| Evening ANSI black equals background | Invisible text in `:terminal` | Phase 2 |
| Default italics for comments | Taste; keep configurable | Phase 1 |
| Test runner (mini.test vs. plenary) | Tooling choice | Phase 0 |
| Neovim minimum version (proposed 0.10+) | Affects API usage | Phase 0 |

