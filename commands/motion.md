---
name: motion
description: Audit motion design and animations using perspectives from Emil Kowalski, Jakub Krehel, and Jhey Tompkins. Context-aware feedback with severity rankings.
---

# /motion Command

## Steps

1. Activate the `motion` skill (load `skills/motion/SKILL.md` from this plugin, then the source SKILL.md it points to)
2. Follow the skill's context reconnaissance — identify the project type and appropriate perspective weighting:
   - Productivity tool → weight Emil Kowalski (restraint, speed)
   - Consumer app → weight Jakub Krehel (polish)
   - Creative / portfolio → weight Jhey Tompkins (playful)
3. Audit the animation code in context
4. Output severity-ranked findings per perspective
5. Provide specific code-level improvements

If no animation code is in context, ask: "Which component or file should I audit for motion design?"
