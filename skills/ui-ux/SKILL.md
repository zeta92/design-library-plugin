---
name: ui-ux
description: Generate or apply a complete design system using ui-ux-pro-max. Analyzes your project type and outputs matched styles, palettes, font pairings, and UX guidelines.
---

# UI/UX Skill

## Steps

1. Load the `ui-ux-pro-max` skill by reading its source file:
   ```
   ~/.claude/plugins/local/design-library/skills/ui-ux-pro-max/SKILL.md
   ```
   Then load the source SKILL.md it points to.
2. Identify the product type from project context (SaaS, e-commerce, fintech, dashboard, landing page, etc.)
3. Run the design system reasoning engine: select the matching style, color palette, font pairing, and top UX guidelines
4. Output a Design System Summary:
   ```
   Style: [selected style]
   Palette: [palette name + 3 key hex values]
   Typography: [font pairing — display + body]
   Top guidelines: [3 most relevant rules for this product type]
   ```
5. Apply the design system to all UI code produced in this session

If context is insufficient to determine product type, ask: "What type of product are you building? (SaaS / e-commerce / fintech / dashboard / landing page / other)"
