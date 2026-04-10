---
name: motion
description: Audit motion design and animations using perspectives from Emil Kowalski, Jakub Krehel, and Jhey Tompkins. Context-aware feedback with severity rankings.
---

# Motion Design Principles Skill

Powered by [kylezantos/design-motion-principles](https://github.com/kylezantos/design-motion-principles) (256 stars).

## Source skill

Load the full skill definition using the Read tool:

```
~/.claude/plugins/local/design-library/designs/design-motion-principles/skills/design-motion-principles/SKILL.md
```

If not found, tell the user: "Run `/design sync` to download the motion design skill."

Follow all instructions in the loaded file.

## What this skill covers

- **Context reconnaissance**: identifies project type before auditing
- **Three designer perspectives**:
  - Emil Kowalski — restraint, speed, purposeful motion (productivity tools)
  - Jakub Krehel — subtle polish, professional refinement (shipped consumer apps)
  - Jhey Tompkins — playful experimentation, CSS creativity (portfolios, creative sites)
- **Severity-ranked feedback** on animation implementations
- **Reference docs**: accessibility, performance, common mistakes, philosophy, technical principles

## Steps

1. Load the source skill file above with the Read tool
2. Follow the skill's context reconnaissance — identify the project type and weight perspectives:
   - Productivity tool → weight Emil Kowalski (restraint, speed)
   - Consumer app → weight Jakub Krehel (polish)
   - Creative / portfolio → weight Jhey Tompkins (playful)
3. Audit the animation code in context
4. Output severity-ranked findings per perspective
5. Provide specific code-level improvements

If no animation code is in context, ask: "Which component or file should I audit for motion design?"
