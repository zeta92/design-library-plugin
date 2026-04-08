---
name: a11y
description: Use when auditing or fixing accessibility issues. Provides 11 specialist agents covering WCAG 2.2 AA compliance — ARIA, contrast, keyboard, cognitive, CI, and more.
---

# Accessibility Agents Skill

Powered by [Community-Access/accessibility-agents](https://github.com/Community-Access/accessibility-agents) (214 stars).

## Activating this skill

Agent definitions are at:

```
~/.claude/plugins/local/design-library/designs/accessibility-agents/.claude/agents/
```

Load the coordinator first:

```
~/.claude/plugins/local/design-library/designs/accessibility-agents/.claude/agents/accessibility-lead.md
```

It will direct which specialist agents to engage based on the audit scope.

## Specialist agents available

- `accessibility-lead.md` — overall audit coordinator
- `aria-specialist.md` — ARIA roles and attributes
- `contrast-master.md` — color contrast analysis (WCAG AA/AAA)
- `cognitive-accessibility.md` — cognitive load, readability, plain language
- `ci-accessibility.md` — automated testing integration
- `alt-text-headings.md` — image alt text and heading hierarchy
- `accessibility-regression-detector.md` — catch regressions in existing code

For a full audit, load `accessibility-lead.md` and follow its instructions. For a targeted audit, load the relevant specialist directly.

If agents are not found, tell the user: "Run `/design sync` to download the accessibility agents."
