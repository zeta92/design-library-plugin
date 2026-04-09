# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Claude Code plugin (v2) that bundles a full design suite: 58 brand design systems + 5 external design skills. It auto-activates skills based on project type via a `SessionStart` hook, and exposes each skill via a slash command.

## Repository structure

```
.claude-plugin/plugin.json    — plugin manifest (name, version, description)
commands/                     — slash command definitions (Markdown files)
  design.md                   — /design: brand loading, mixing, ?-mode, sync
  ui-ux.md                    — /ui-ux: styles, palettes, fonts, UX guidelines
  guidelines.md               — /guidelines: web design guidelines audit
  design-process.md           — /design-process: full design workflow
  motion.md                   — /motion: motion & animation principles
  a11y.md                     — /a11y: WCAG 2.2 AA accessibility audit
hooks/
  hooks.json                  — SessionStart + UserPromptSubmit hooks
  scripts/
    inject-context.sh         — detects brand names in prompts → injects DESIGN.md context
    detect-project.sh         — detects project type at session start → activates skills
skills/
  design-library/             — existing skill (58 brands via awesome-design-md)
  ui-ux-pro-max/              — thin wrapper → designs/ui-ux-pro-max-skill/
  web-design-guidelines/      — thin wrapper → designs/agent-skills/
  designer-skills/            — thin wrapper → designs/designer-skills/
  motion/                     — thin wrapper → designs/design-motion-principles/
  a11y/                       — thin wrapper → designs/accessibility-agents/
scripts/
  sync.sh                     — clone/update all 6 upstream repos into designs/
designs/                      — gitignored; populated by sync.sh
```

## Key commands

- **`bash scripts/sync.sh`** — clone or update all upstream repos into `designs/`. Required after fresh clone.

## Hook behavior

- **`SessionStart` → `detect-project.sh`**: Scans `package.json`, CSS files, and directory structure. Outputs a `{"systemMessage": ...}` JSON listing active skills and their commands. Three fallback levels: source files → README-only → empty project (asks 3 questions).
- **`UserPromptSubmit` → `inject-context.sh`**: Detects brand names in the user's prompt and injects the matching DESIGN.md content as context.

## Skill wrappers

Each skill in `skills/<name>/SKILL.md` is a thin wrapper — it tells Claude where to find the source content in `designs/`. It does not duplicate skill content. All actual skill content lives in the cloned repos under `designs/`.

## External skill sources

| Skill dir | Source repo |
|-----------|-------------|
| `designs/awesome-design-md/` | VoltAgent/awesome-design-md |
| `designs/ui-ux-pro-max-skill/` | nextlevelbuilder/ui-ux-pro-max-skill |
| `designs/agent-skills/` | vercel-labs/agent-skills |
| `designs/designer-skills/` | Owl-Listener/designer-skills |
| `designs/design-motion-principles/` | kylezantos/design-motion-principles |
| `designs/accessibility-agents/` | Community-Access/accessibility-agents |
