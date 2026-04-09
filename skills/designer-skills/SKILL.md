---
name: designer-skills
description: Use when guiding any phase of the design process — from research and strategy through UI design, interaction design, and handoff. Contains 63 specialized skills across the entire design lifecycle.
---

# Designer Skills

Powered by [Owl-Listener/designer-skills](https://github.com/Owl-Listener/designer-skills) (505 stars).

## Activating this skill

Read the specific skill file based on what the user needs. Base path:

```
~/.claude/plugins/local/design-library/designs/designer-skills/
```

## Available plugins and skills

### UI Design
Path: `ui-design/skills/<skill>/SKILL.md`
Skills: `color-system` · `dark-mode-design` · `data-visualization` · `illustration-style` · `layout-grid` · `responsive-design` · `spacing-system` · `typography-scale` · `visual-hierarchy`

### Design Systems
Path: `design-systems/skills/<skill>/SKILL.md`
Skills: `accessibility-audit` · `component-spec` · `design-token` · `documentation-template` · `icon-system` · `naming-convention` · `pattern-library` · `theming-system`

### Interaction Design
Path: `interaction-design/skills/<skill>/SKILL.md`
Skills: `animation-principles` · `error-handling-ux` · `feedback-patterns` · `gesture-patterns` · `loading-states` · `micro-interaction-spec` · `state-machine`

### UX Strategy
Path: `ux-strategy/skills/<skill>/SKILL.md`
Skills: `competitive-analysis` · `design-brief` · `design-principles` · `experience-map` · `north-star-vision` · `opportunity-framework` · `stakeholder-alignment` · `metrics-definition`

### Design Research
Path: `design-research/skills/<skill>/SKILL.md`
Skills: `affinity-diagram` · `card-sort-analysis` · `empathy-map` · `interview-script` · `jobs-to-be-done` · `journey-map` · `user-persona` · `usability-test-plan`

### Design Ops
Path: `design-ops/skills/<skill>/SKILL.md`
Skills: `design-critique` · `design-qa-checklist` · `design-review-process` · `design-sprint-plan` · `handoff-spec` · `team-workflow`

### Prototyping & Testing
Path: `prototyping-testing/skills/<skill>/SKILL.md`
Skills: `a-b-test-design` · `accessibility-test-plan` · `heuristic-evaluation` · `prototype-strategy` · `test-scenario` · `user-flow-diagram` · `wireframe-spec`

### Designer Toolkit
Path: `designer-toolkit/skills/<skill>/SKILL.md`
Skills: `case-study` · `design-rationale` · `design-token-audit` · `presentation-deck` · `ux-writing`

## How to use

When invoked via `/design-process`, ask the user what design phase or specific task they need, then load and follow the most relevant SKILL.md file(s) from above.

If skills are not found, tell the user: "Run `/design sync` to download the designer skills."
