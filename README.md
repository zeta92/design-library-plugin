# The Design Library [![v2.1.0](https://img.shields.io/badge/version-v2.1.0-green.svg)](https://github.com/zeta92/design-library-plugin)

> Global Claude Code plugin — 58 brand design systems + 5 curated design skills, always available.

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

---

## Overview

`design-library-plugin` gives you instant access to a professional design suite directly inside your Claude Code sessions. It combines 58 industry-standard brand design systems with specialized AI agents for UI/UX, accessibility, motion, and design processes.

## Quick Start (30 seconds)

```bash
# 1. Clone the plugin
git clone https://github.com/zeta92/design-library-plugin.git ~/.claude/plugins/local/design-library

# 2. Run setup
bash ~/.claude/plugins/local/design-library/scripts/sync.sh

# 3. Reload Claude
/reload-plugins
```

## What can I do with this?

Transform your development workflow with natural language:

- **"Make this component look like Linear's design system"** — Instant visual alignment.
- **"Audit this form for accessibility issues"** — Deep WCAG 2.2 AA analysis.
- **"Create a color palette for my SaaS dashboard"** — Generate cohesive, brand-aligned themes.
- **"Review my animation code against motion design principles"** — Audit transitions and timing.
- **"Walk me through a UX design sprint"** — Leverage 63 specialized design lifecycle skills.

---

## Installation

### Step 1 — Clone the plugin
The plugin must live at `~/.claude/plugins/local/design-library`. Do not change this path.
```bash
git clone https://github.com/zeta92/design-library-plugin.git ~/.claude/plugins/local/design-library
```

### Step 2 — Run the setup script
This script downloads all 58 brand systems, installs the 5 external skill repos, registers the marketplace, and sets up a daily sync cron job.
```bash
bash ~/.claude/plugins/local/design-library/scripts/sync.sh
```

### Step 3 — Reload plugins
Run this slash command inside any Claude Code session:
```
/reload-plugins
```

---

## Usage

### Auto-activation
The plugin detects your project type at session start. You will see a confirmation message like:
```
[DESIGN SUITE ACTIVE] Project detected: web app
Skills loaded: design-library · ui-ux-pro-max · web-design-guidelines
```
This means the relevant design expertise is automatically loaded into your context.

### Slash commands

| Command | Description |
|---|---|
| `/design <brand>` | Load one brand's design system |
| `/design A + B` | Mix two brands |
| `/design A:colors + B:typography` | Granular mix by section |
| `/design ?` | Re-analyze project and suggest skills + brands |
| `/design list` | Show all 58 brands |
| `/design sync` | Update all design data and skills |
| `/ui-ux` | Generate a complete design system for your project |
| `/guidelines` | Audit UI code against 100+ web design rules |
| `/motion` | Audit animations via Emil Kowalski / Jakub Krehel / Jhey Tompkins |
| `/a11y` | Run a full WCAG 2.2 AA accessibility audit |
| `/design-process` | Access 63 design skills across the full lifecycle |

### Mixing Brands
Combine specific attributes from different design systems for unique results:
```
/design stripe:colors + linear:typography
```
> **Result:** Stripe's bold blue palette with Linear's Inter-based type system.

**Granular sections:** `colors` · `typography` · `components` · `layout` · `elevation`

### Natural language
The plugin detects brand names in your prompts automatically — no command needed:
- *"Build me a page like Stripe"*
- *"Diseñame esto como Google y Anthropic"*

---

## Projects powering this plugin

| Project | Used for | Stars |
|---|---|---|
| [VoltAgent/awesome-design-md](https://github.com/VoltAgent/awesome-design-md) | 58 brand design systems | — |
| [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) | `/ui-ux` — design system generator | 61k ⭐ |
| [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) | `/guidelines` — web interface rules | 24k ⭐ |
| [Owl-Listener/designer-skills](https://github.com/Owl-Listener/designer-skills) | `/design-process` — design lifecycle skills | 505 ⭐ |
| [kylezantos/design-motion-principles](https://github.com/kylezantos/design-motion-principles) | `/motion` — animation audits | 256 ⭐ |
| [Community-Access/accessibility-agents](https://github.com/Community-Access/accessibility-agents) | `/a11y` — WCAG 2.2 AA specialists | 214 ⭐ |

---

## Troubleshooting

- **Plugin not loading:** Run `claude plugin list` to verify the plugin is registered.
- **Brands not found:** Run `/design sync` to refresh the local design database.
- **Hook not triggering:** Verify that "Hooks" are enabled in your Claude Code settings.

---

## Updating

```bash
bash ~/.claude/plugins/local/design-library/scripts/sync.sh
```

Or use the slash command: `/design sync`

---

## License

Apache License 2.0. See [LICENSE](LICENSE).

Copyright 2026 zeta92
