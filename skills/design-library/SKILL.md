---
name: design-library
description: Use when working on UI, frontend, or design tasks, or when a brand design system has been loaded via the /design command or the UserPromptSubmit hook. Guides Claude on how to read, apply, and merge DESIGN.md files from the awesome-design-md library.
---

# Design Library Skill

## Quick Decision Guide
- Use **`/design [brand]`** when you want to implement a specific, existing brand identity (e.g., "Make this look like Stripe").
- Use **`/ui-ux`** when starting a new project from scratch and you need a professional, cohesive design system generated for you.
- Use **`/guidelines`** when you have existing code and want to audit it for professional web standards, accessibility, and best practices.

## Brand Catalog & Examples
You have access to a local library of DESIGN.md files from 58 real-world companies.
See `/home/zeta/.claude/plugins/local/design-library/skills/design-library/references/catalog.md` for the full list, or run `/design list`.

**Examples of Brand Personas** (if available in catalog):
- **Stripe** → Clean, minimal, developer-friendly, high-precision.
- **Linear** → Fast, keyboard-driven, dark-first, opinionated spacing.
- **Vercel** → High contrast, monospace accents, deployment-focused feel.
- **Spotify** → Bold, high-energy, dark-mode centric, rhythmic.

> Always verify a brand is in the catalog before referencing it. Run `/design list` to see all available brands.

## How to Apply a Single Brand
When a DESIGN.md has been loaded as context:
1. **Read the Agent Prompt Guide first** — This section contains specific instructions on how an AI should approach code generation for this specific brand. Follow these instructions strictly.
2. **Color Palette & Roles** — Use exact hex values for primary, secondary, accent, and semantic colors.
3. **Typography Rules** — Apply the specific font stack, scale, and line heights.
4. **Component Stylings** — Reproduce button, input, and card styles faithfully.
5. **Layout & Depth** — Use the grid, spacing, and shadow/elevation tokens provided.
6. **Responsive Behavior** — Respect the defined breakpoints and mobile adaptations.
7. **Do's and Don'ts** — Ensure no prohibited patterns are introduced.

## Mixing Strategy (Brand A + Brand B)
When merging two identities, follow these rules to prevent "design soup":
1. **Section Isolation** — Never blend values within a single section. A section must belong entirely to one brand.
2. **Default Assignment (The "Dominant" Rule)**:
   - Colors → Brand A (Dominant)
   - Typography → Brand B
   - Components → Brand A
   - Layout → Brand B
   - Elevation → Brand A
3. **Explicit Overrides** — If the user says "Use Brand A's colors but Brand B's typography," follow that exactly.
4. **Fusion Summary** — Before writing code, output a "Fusion Summary" explaining which brand is providing which design tokens.
5. **Pairing Tips**:
   - *Safe Pairings*: Minimalist + High Contrast (e.g., Stripe + Linear).
   - *Risky Pairings*: Playful/Organic + Brutalist — use caution with spacing.

## Fallback Logic
If a requested brand is not found in the library:
1. Inform the user the brand is missing.
2. Suggest the **3 closest alternatives** based on the requested brand's vibe (e.g., if they ask for a brand not in catalog, suggest similar brands from the catalog).
3. Offer to run `/design sync` to update the library.

## Design File Location
All design files are at:
```
~/.claude/plugins/local/design-library/designs/awesome-design-md/design-md/<brand>/DESIGN.md
```

Use the `Read` tool to load them when needed.

## Sync Status
If a brand is not found, suggest running `/design sync` to update the local library.
