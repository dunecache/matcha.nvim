# Decisions — matcha.nvim

Short ADR-style log. Each entry 3–5 lines.

---

## 2026-11-03 — Token source location

- **Decision:** Canonical Kanso Matcha tokens live at `~/kanso_design_system` (sibling repo). Vendored into `tokens/` manually (no submodule, no sync script).
- **Status:** Resolved.
- **Why:** Single source of truth for the design system; matcha.nvim remains an adapter only. Manual vendoring keeps the pipeline dependency-free and avoids submodule/sync-script complexity for now.
- **Follow-up:** Revisit automation if manual updates become error-prone.

---

## 2026-11-03 — Light-mode contrast failures

- **Decision:** If light-mode comment/operator/punctuation fall below 4.5:1, fix via upstream token adjustment in `~/kanso_design_system`; no documented exemption in this repo.
- **Status:** Resolved.
- **Why:** Prime directive #4 — contrast targets are non-negotiable; never lower targets or patch hex locally.
- **Follow-up:** Run `check-contrast.lua` on raw spec pairs (Phase 0) and file failures upstream.

---

## 2026-11-03 — Missing roles and derivations

- **Decision:** Approve D1 (CursorLine bg), D2 (Search bg), D3 (diagnostic virtual-text bg), and map `DiagnosticHint` to `text-secondary` fg with `accent-secondary` undercurl.
- **Status:** Resolved.
- **Why:** Proposed defaults in AGENTS.md §6; spec has no hint/cursorline/search/virtual-text roles, so derivations + best-fit semantic tokens keep the adapter token-pure.
- **Follow-up:** Implement in `derive.lua`; document in `docs/derivations.md`.

---

## 2026-11-03 — Evening ANSI black

- **Decision:** Adjust the Evening ANSI black value upstream in `~/kanso_design_system` so it is distinguishable from the background; do not silently remap in this repo.
- **Status:** Resolved.
- **Why:** Prime directive #4 — visible boundaries/text; black-on-background text in `:terminal` would otherwise be invisible.
- **Follow-up:** File the issue upstream; adapter consumes the corrected token once it lands.

---

## 2026-11-03 — Default styles

- **Decision:** Comments italic by default; all other styles plain.
- **Status:** Resolved.
- **Why:** Matches the documented proposal in AGENTS.md §7; keeps defaults restrained and configurable.
- **Follow-up:** Set in `config.lua` defaults.

---

## 2026-11-03 — Test runner

- **Decision:** Use plenary.nvim as the test runner (not mini.test).
- **Status:** Resolved.
- **Why:** Maintainer preference; plenary's test harness available.
- **Follow-up:** Update validation commands/docs to use plenary.

---

## 2026-11-03 — Test harness implementation

- **Decision:** Specs run through a self-contained harness in `tests/` (`describe`/`it` + assertions) executed by `nvim --headless -l tests/run.lua`; plenary remains the declared runner but is not required to run the suite.
- **Status:** Resolved.
- **Why:** AGENTS.md §9 — no runtime dependencies; CI and a cold checkout must run tests with Neovim only.
- **Follow-up:** If a plenary-based harness is preferred, the same spec files can run under `plenary.test_harness` unchanged.

---

## 2026-11-03 — Upstream token proposals

- **Decision:** Propose additive upstream tokens for recurring roles: `cursorline`, `highlight-match`, `line-number`, `dim-inactive`, `diagnostic-hint`, per-state virtual-text backgrounds, and a corrected Evening ANSI black.
- **Status:** Open (file upstream).
- **Why:** Each currently exists as a documented derivation (D1/D2/D3) or best-fit semantic; making them canonical removes the need for derivations.
- **Follow-up:** Once accepted, replace derivations and bump the supported design-system version.
