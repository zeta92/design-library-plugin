---
name: design
description: Load and apply brand design systems from the awesome-design-md library. Supports single brand, multi-brand mixing, auto-suggest, list, and sync.
---

# /design Command

Load one or more brand design systems and apply them to your UI work.

## Argument Parsing

Parse the argument string passed to this command:

| Argument pattern | Mode |
|-----------------|------|
| `<brand>` | Single brand |
| `<brand> + <brand>` | Simple mix |
| `<brand>:<section> + <brand>:<section>` | Granular mix |
| `?` | Auto-suggest |
| `list` | Show catalog |
| `sync` | Update local library |
| _(no argument)_ | Show usage help |

Valid sections for granular mix: `colors`, `typography`, `components`, `layout`, `elevation`

## Mode: Single Brand

1. Resolve the brand name to a directory:
   ```
   ~/.claude/plugins/local/design-library/designs/awesome-design-md/design-md/<brand>/DESIGN.md
   ```
   Match case-insensitively (e.g., `Stripe` → `stripe`).

2. If the file exists: read it with the Read tool and load it as active design context.

3. If not found: list similar brands from the catalog and suggest `/design sync` if the brand should exist.

4. Confirm to the user: "✓ Loaded [Brand] design system. I'll apply it to all UI work in this session."

## Mode: Simple Mix (`A + B` or `A + B + C`)

1. Load each brand's DESIGN.md with the Read tool.
2. Apply the default section assignment from the design-library skill:
   - Colors, Components, Elevation → first brand
   - Typography, Layout → second brand
3. Output a **Fusion Summary**:
   ```
   Fusion: [Brand A] colors + [Brand B] typography + ...
   Rationale: [why this combination is coherent]
   ```
4. Confirm: "✓ Fusion ready. Applying [A] + [B] design system to this session."

## Mode: Granular Mix (`A:section + B:section`)

1. Parse each `brand:section` pair.
2. Load each brand's DESIGN.md with the Read tool.
3. Extract only the specified section from each brand's DESIGN.md.
4. Output a Fusion Summary showing exact section mapping.
5. Apply the merged result to the session.

## Mode: Auto-Suggest (`?`)

1. Read the current project context:
   - Look for existing `package.json`, color variables, CSS files, README
   - Identify the project's purpose (SaaS, fintech, dev tool, consumer app, etc.)
2. Read `/home/zeta/.claude/plugins/local/design-library/skills/design-library/references/catalog.md`
3. Select 2-3 best matching brands with reasoning.
4. Ask the user to confirm: "Based on your project, I'd suggest: [Brand A] (reason) or [Brand B] (reason). Which should I load?"
5. Load the chosen brand.

## Mode: List

Read `/home/zeta/.claude/plugins/local/design-library/skills/design-library/references/catalog.md` and display it formatted as a list grouped by category.

## Mode: Sync

Run:
```bash
bash ~/.claude/plugins/local/design-library/scripts/sync.sh
```

Report the output to the user (number of brands updated, any errors).

## Mode: No Argument (Help)

Show this usage summary:
```
/design <brand>                    — load one brand
/design stripe + linear            — mix two brands
/design stripe:colors + linear:typography  — granular mix
/design ?                          — auto-suggest based on your project
/design list                       — show all 58 brands
/design sync                       — update local library
```
