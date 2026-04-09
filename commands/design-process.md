---
name: design-process
description: Access 63 specialized design skills across the full design lifecycle — research, systems, UI, interaction, strategy, and delivery. Use for any design process task.
---

# /design-process Command

## Argument parsing

| Argument | Behavior |
|----------|----------|
| `<plugin>/<skill>` (e.g., `ui-design/typography-scale`) | Load that specific skill directly |
| `<phase>` (e.g., `ui-design`, `design-systems`) | List skills in that phase, then load chosen one |
| _(no argument)_ | Show phase menu, guide user to the right skill |

## Steps (no argument)

1. Activate the `designer-skills` skill (load `skills/designer-skills/SKILL.md` from this plugin)
2. Present the phase menu:
   ```
   Which design phase do you need?
   1. UI Design — color, typography, grid, spacing, responsive, dark mode
   2. Design Systems — tokens, components, accessibility, patterns, theming
   3. Interaction Design — animations, loading states, error UX, micro-interactions
   4. UX Strategy — design brief, principles, competitive analysis
   5. Research — personas, journey maps, usability plans
   6. Design Ops — critique, handoff specs, QA checklist
   ```
3. Once the user selects a phase and skill, load:
   ```
   ~/.claude/plugins/local/design-library/designs/designer-skills/<plugin>/<skill>/SKILL.md
   ```
4. Follow all instructions in that skill file

## Steps (with direct skill argument)

1. Activate the `designer-skills` skill
2. Load the specified skill directly
3. Follow its instructions
