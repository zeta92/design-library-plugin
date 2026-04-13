---
name: guidelines
description: Audit UI code against 100+ web interface guidelines from Vercel — covering accessibility, forms, dark mode, typography, animation, images, performance, navigation, touch, and internationalization.
---

# Web Design Guidelines Skill

## Workflow

1. **Load Engine**:
   Read the `web-design-guidelines` skill source:
   ```
   ~/.claude/plugins/local/design-library/skills/web-design-guidelines/SKILL.md
   ```
   Then load the source SKILL.md it points to.

2. **Identify Target**:
   Identify the code to audit. If no code is in context, ask: *"Which file or component should I audit?"*

3. **Execution Strategy**:
   - **Large File Handling**: If the file exceeds 200 lines, audit in logical sections (by component or function block) and report findings per section.
   - **Critical Scan First**: Before the full audit, scan for the 5 most critical issues:
     - A11y blockers: missing `aria-labels`, broken semantic HTML, screen reader failures
     - Missing or suppressed `:focus-visible` styles
     - Text/background contrast failures (WCAG AA)
     - Missing alt text on images
     - Keyboard traps or inaccessible interactive elements

4. **Detailed Audit**:
   Review the code against all 11 rule categories (Accessibility, Forms, Dark Mode, Typography, Animation, Images, Performance, Navigation, Touch, Internationalization, Layout).

5. **Output Format**:
   Group findings by category:
   ```
   [Category Name]
   ❌ Error (blocks compliance): [issue] — [fix]
   ⚠️  Warning (best practice): [issue] — [fix]
   💡 Suggestion (enhancement): [issue] — [fix]
   ```

6. **Severity Summary**:
   End every audit with:
   ```
   Audit complete — Found: X errors · Y warnings · Z suggestions
   ```
   Prioritize errors first, then warnings, then suggestions.
