---
name: taste
description: Give generated frontends good taste — stops generic, boring "AI slop" UI with tunable design variance, motion intensity, and visual density. Use when output looks bland, when polishing a UI, or when redesigning an existing project.
---

# Taste Skill

Powered by [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill) (~37k stars) — the most popular third-party design skill for frontend.

## Activating this skill

Load the full skill definition using the Read tool. The default skill is:

```
~/.claude/plugins/local/design-library/designs/taste-skill/skills/taste-skill/SKILL.md
```

If the file is not found, tell the user: "Run `/design sync` to download the Taste skill, then try again."

Follow all instructions in the loaded file.

## Variants

If the user passes an argument, load that variant instead (all under `designs/taste-skill/skills/`):

| Argument | Skill file | Skill name |
|----------|------------|------------|
| _(none)_ | `taste-skill/SKILL.md` | `design-taste-frontend` (default, v2) |
| `v1` | `taste-skill-v1/SKILL.md` | `design-taste-frontend-v1` |
| `minimalist` | `minimalist-skill/SKILL.md` | `minimalist-ui` |
| `brutalist` | `brutalist-skill/SKILL.md` | `industrial-brutalist-ui` |
| `high-end` | `soft-skill/SKILL.md` | `high-end-visual-design` |
| `redesign` | `redesign-skill/SKILL.md` | `redesign-existing-projects` |
| `image-to-code` | `image-to-code-skill/SKILL.md` | `image-to-code` |

If an argument doesn't match, list the directories under `designs/taste-skill/skills/` and pick the closest match.

## What this skill covers

- Three tunable dials: **design variance** (asymmetry), **motion intensity**, and **visual density** — default 8/6/4
- Anti-repetition rules that stop generic layouts, fonts, and palettes
- Works alongside `/design <brand>` (brand sets the identity; taste sets the execution quality)
