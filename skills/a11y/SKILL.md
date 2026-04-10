---
name: a11y
description: Run a comprehensive accessibility audit using 11 WCAG 2.2 AA specialist agents. Covers ARIA, contrast, keyboard, cognitive accessibility, and more.
---

# Accessibility Agents Skill

Powered by [Community-Access/accessibility-agents](https://github.com/Community-Access/accessibility-agents) (214 stars).

## Agent definitions

```
~/.claude/plugins/local/design-library/designs/accessibility-agents/.claude/agents/
```

## Specialist agents available

- `accessibility-lead.md` — overall audit coordinator
- `aria-specialist.md` — ARIA roles and attributes
- `contrast-master.md` — color contrast analysis (WCAG AA/AAA)
- `cognitive-accessibility.md` — cognitive load, readability, plain language
- `ci-accessibility.md` — automated testing integration
- `alt-text-headings.md` — image alt text and heading hierarchy
- `accessibility-regression-detector.md` — catch regressions in existing code

If agents are not found, tell the user: "Run `/design sync` to download the accessibility agents."

## Argument handling

| Argument | Behavior |
|----------|----------|
| _(no argument)_ | Full audit via accessibility-lead coordinator |
| `aria` | Load aria-specialist directly |
| `contrast` | Load contrast-master directly |
| `cognitive` | Load cognitive-accessibility directly |
| `ci` | Load ci-accessibility directly |
| `alt-text` | Load alt-text-headings specialist directly |
| `regression` | Load accessibility-regression-detector directly |

## Steps (no argument — full audit)

1. Load the `accessibility-lead.md` agent:
   ```
   ~/.claude/plugins/local/design-library/designs/accessibility-agents/.claude/agents/accessibility-lead.md
   ```
2. Follow the lead agent's coordination instructions
3. Output findings by WCAG criterion with severity:
   - 🔴 Critical — blocks access entirely
   - 🟠 Serious — significantly impairs access
   - 🟡 Moderate — causes difficulty
   - 🔵 Minor — enhancement
4. Provide fix code for each finding

## Steps (with specialist argument)

1. Load the relevant specialist agent directly from:
   ```
   ~/.claude/plugins/local/design-library/designs/accessibility-agents/.claude/agents/<specialist>.md
   ```
2. Follow the specialist's instructions on the code in context
