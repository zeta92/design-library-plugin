---
name: design-library
description: Use when working on UI, frontend, or design tasks, or when a brand design system has been loaded via the /design command or the UserPromptSubmit hook. Guides Claude on how to read, apply, and merge DESIGN.md files from the awesome-design-md library.
---

# Design Library Skill

You have access to a local library of DESIGN.md files from 58 real-world companies.
See `/home/zeta/.claude/plugins/local/design-library/skills/design-library/references/catalog.md` for the full list, or run `/design list`.

## What is a DESIGN.md

Each DESIGN.md has 9 sections:
1. **Visual Theme & Atmosphere** — overall feel, personality
2. **Color Palette & Roles** — primary, secondary, accent, background, text colors with hex values
3. **Typography Rules** — font families, sizes, weights, line heights
4. **Component Stylings** — buttons, inputs, cards, badges, navigation
5. **Layout Principles** — grid, spacing, container widths
6. **Depth & Elevation** — shadows, z-index, blur
7. **Design Do's and Don'ts** — specific rules for this brand
8. **Responsive Behavior** — breakpoints, mobile adaptations
9. **Agent Prompt Guide** — how to instruct AI agents to produce this design

> Note: Section titles vary slightly across brands (e.g., section 7 may be "Interaction & Motion" or "Dark Mode" rather than "Do's and Don'ts"). Always read the actual section headers from the loaded DESIGN.md file rather than assuming fixed names.

## How to Apply a Single Brand

When a DESIGN.md has been loaded as context:
1. Read the Color Palette section — use exact hex values
2. Read Typography Rules — apply the font stack and scale
3. Read Component Stylings — reproduce button, input, and card styles faithfully
4. Read Layout Principles — use the grid and spacing system
5. Read the Depth & Elevation section — apply shadow tokens and z-index values
6. Read the Responsive Behavior section — respect breakpoints and mobile adaptations
7. Respect the Do's and Don'ts section
8. Apply the Agent Prompt Guide to your code generation approach

## How to Mix Multiple Brands

When mixing A + B:
1. **Each section comes from one brand only** — never blend within a section
2. Default assignment when not specified:
   - Colors → Brand A (dominant)
   - Typography → Brand B
   - Components → Brand A
   - Layout → Brand B
   - Elevation → Brand A
3. When the user specifies sections explicitly (e.g., `stripe:colors + linear:typography`), follow exactly
4. Generate a **Fusion Summary** before producing code:
   ```
   Fusion: [Brand A] colors + [Brand B] typography + ...
   Rationale: [brief explanation of why this combination works]
   ```
5. The first-named brand also wins for all unlisted sections (Visual Theme, Do's and Don'ts, Responsive Behavior, Agent Prompt Guide).
6. The first-named brand wins on any section not explicitly assigned

## Design File Location

All design files are at:
```
~/.claude/plugins/local/design-library/designs/awesome-design-md/design-md/<brand>/DESIGN.md
```

Use the `Read` tool to load them when needed.

## Sync Status

If a brand is not found, suggest running `/design sync` to update the local library.
