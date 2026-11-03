# Derivations — matcha.nvim

Computed colors (see `lua/matcha/derive.lua`). All inputs are canonical tokens.

| ID | Role | Derivation | Reason | Contrast |
|---|---|---|---|---|
| D1 | CursorLine background | blend(background, surface, 0.5) | Subtle, never a loud bar | TBD |
| D2 | Search background | blend(background, warning, 0.25) | Distinct match highlight | TBD |
| D3 | Diagnostic virtual-text background | blend(background, <state>, 0.10) | Soft state tint | TBD |
