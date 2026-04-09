# design-library-plugin

> A full design suite for Claude Code — 58 brand design systems + UI/UX, accessibility, motion, design guidelines, and full design-process skills. Auto-activates based on your project type.

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

---

## Overview

`design-library-plugin` is a Claude Code plugin that gives you a complete design toolkit inside any Claude session.

**At session start**, it scans your project and activates the right skills automatically. You can also trigger any skill directly via its slash command.

---

## Skills

| Skill | Command | What it covers |
|-------|---------|----------------|
| **design-library** | `/design <brand>` | 58 brand design systems (Stripe, Linear, Vercel, Figma, Google, Anthropic, and more) |
| **ui-ux-pro-max** | `/ui-ux` | 67 styles, 161 palettes, 57 font pairings, 99 UX guidelines |
| **web-design-guidelines** | `/guidelines` | 100+ rules: a11y, typography, forms, dark mode, animation, i18n |
| **designer-skills** | `/design-process` | 63 skills, 27 commands — research → systems → UI → interaction → delivery |
| **design-motion-principles** | `/motion` | Motion audit via Emil Kowalski, Jakub Krehel, Jhey Tompkins lens |
| **accessibility-agents** | `/a11y` | 11 specialist agents enforcing WCAG 2.2 AA compliance |

---

## Auto-activation

On session start, the plugin scans your project and activates appropriate skills:

| Project type | Skills activated |
|---|---|
| Landing page / marketing | design-library, ui-ux-pro-max, motion |
| Design system / component library | design-library, web-design-guidelines, designer-skills, a11y |
| SaaS app / dashboard | design-library, ui-ux-pro-max, web-design-guidelines, a11y |
| UI project with animations | any of the above + motion |

Run `/design ?` at any time to re-analyze your project and see which skills are active.

---

## Installation

```bash
git clone https://github.com/zeta92/design-library-plugin.git ~/.claude/plugins/local/design-library
```

Then register it in your Claude Code settings and restart Claude Code.

---

## Setup

Run once after install to clone all external skill repos locally:

```bash
bash ~/.claude/plugins/local/design-library/scripts/sync.sh
```

This clones the 5 upstream skill repos into `designs/` (gitignored). Run again anytime to pull updates, or use `/design sync`.

---

## Commands

### `/design` — Brand design systems

| Syntax | Description |
|---|---|
| `/design stripe` | Load one brand's full design system |
| `/design stripe + linear` | Mix two brands |
| `/design stripe:colors + linear:typography` | Granular mix by section |
| `/design ?` | Re-analyze project and suggest skills |
| `/design list` | Show all 58 brands by category |
| `/design sync` | Pull latest designs from GitHub |

### Natural language (no command needed)

The hook detects brand names in your prompts automatically:

- *"Design this like Stripe"*
- *"Make it look like Linear"*
- *"Diseñame esto como Google y Anthropic"*

### Other commands

- `/ui-ux` — Generate or apply a complete design system
- `/guidelines` — Audit UI code against 100+ web design guidelines
- `/design-process` — Full design workflow with 63 skills
- `/motion` — Motion and animation principles audit
- `/a11y` — Accessibility audit with 11 WCAG 2.2 AA specialists

---

## Design data sources

| Source | Content |
|---|---|
| [VoltAgent/awesome-design-md](https://github.com/VoltAgent/awesome-design-md) | 58 brand design systems |
| [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) | UI/UX pro skill |
| [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) | Web design guidelines |
| [Owl-Listener/designer-skills](https://github.com/Owl-Listener/designer-skills) | Designer skills |
| [kylezantos/design-motion-principles](https://github.com/kylezantos/design-motion-principles) | Motion principles |
| [Community-Access/accessibility-agents](https://github.com/Community-Access/accessibility-agents) | Accessibility agents |

---

## License

This project is licensed under the **Apache License 2.0**. See the [LICENSE](LICENSE) file for details.

Copyright 2026 zeta92
