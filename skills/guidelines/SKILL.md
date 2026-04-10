---
name: guidelines
description: Audit UI code against 100+ web interface guidelines from Vercel — covering accessibility, forms, dark mode, typography, animation, images, performance, navigation, touch, and internationalization.
---

# Web Design Guidelines Skill

## Steps

1. Load the `web-design-guidelines` skill by reading its source file:
   ```
   ~/.claude/plugins/local/design-library/skills/web-design-guidelines/SKILL.md
   ```
   Then load the source SKILL.md it points to.
2. Identify the code to audit — use the file or component currently in context
3. Review the code against all 11 rule categories
4. Output findings grouped by category:
   ```
   ❌ Error (blocks compliance): [issue] — [fix]
   ⚠️  Warning (best practice): [issue] — [fix]
   💡 Suggestion (enhancement): [issue] — [fix]
   ```
5. Prioritize errors first, then warnings, then suggestions

If no code is in context, ask: "Which file or component should I audit?"
