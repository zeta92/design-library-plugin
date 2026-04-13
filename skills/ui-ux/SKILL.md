---
name: ui-ux
description: Generate or apply a complete design system using ui-ux-pro-max. Analyzes your project type and outputs matched styles, palettes, font pairings, and UX guidelines.
---

# UI/UX Skill

## Context
This skill leverages the `ui-ux-pro-max` engine — 67 distinct styles, 161 curated color palettes, 57 font pairings, and 99 UX guidelines (61k stars).

## Workflow

1. **Clarification Phase**:
   Before loading the engine, if the project type is not explicitly clear, ask exactly one clarifying question:
   *"What is the primary user intent for this product? (e.g., transactional/fintech, content/media, data management/dashboard, landing page, or other)"*

2. **Load Engine**:
   Read the source file:
   ```
   ~/.claude/plugins/local/design-library/skills/ui-ux-pro-max/SKILL.md
   ```
   Then load the source SKILL.md it points to.

3. **Reasoning & Selection**:
   Identify the product type from project context and select the matching style, color palette, font pairing, and top UX guidelines.

4. **Output Design System Summary**:
   ```
   Style: [selected style]
   Palette: [palette name + 3 key hex values]
   Typography: [font pairing — display + body]
   Top guidelines: [3 most relevant rules for this product type]
   ```

5. **Output Design Tokens (CSS)**:
   Immediately following the summary, provide CSS Custom Properties:
   ```css
   :root {
     --color-primary: #XXXXXX;
     --color-secondary: #XXXXXX;
     --color-accent: #XXXXXX;
     --font-display: 'FontName', sans-serif;
     --font-body: 'FontName', sans-serif;
     --spacing-unit: 4px;
   }
   ```

6. **Tailwind Integration**:
   If the project uses Tailwind, provide the `theme.extend` configuration to map these tokens to Tailwind utility classes.

7. **Application**:
   Apply these tokens to all UI code produced in this session.

If context is insufficient to determine product type, ask the clarifying question above before proceeding.
