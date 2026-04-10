# design-library-plugin

> Global Claude Code plugin — 58 brand design systems + 5 curated design skills, always available.

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

---

## Overview

`design-library-plugin` is a Claude Code plugin that gives you instant access to a full design suite directly inside your coding sessions:

- **58 brand design systems** (Stripe, Linear, Vercel, Figma, Google, Anthropic, and more)
- **UI/UX Pro Max** — 67 styles, 161 palettes, 57 font pairings, 99 UX guidelines (61k ⭐)
- **Web Design Guidelines** — 100+ rules for a11y, forms, dark mode, typography, i18n (24k ⭐)
- **Designer Skills** — 63 skills across the full design lifecycle (505 ⭐)
- **Motion Design Principles** — animation audits via 3 designer perspectives (256 ⭐)
- **Accessibility Agents** — 11 WCAG 2.2 AA specialists (214 ⭐)

The plugin auto-detects your project type at session start and activates the relevant skills automatically.

**Design data source:** [VoltAgent/awesome-design-md](https://github.com/VoltAgent/awesome-design-md)

---

## Installation

### Step 1 — Clone the plugin

```bash
git clone https://github.com/zeta92/design-library-plugin.git ~/.claude/plugins/local/design-library
```

> The plugin must live at `~/.claude/plugins/local/design-library`. Do not change this path.

### Step 2 — Run the setup script

```bash
bash ~/.claude/plugins/local/design-library/scripts/sync.sh
```

This script does everything in one shot:

- Downloads all 58 brand design systems and the 5 external skill repos
- Creates the local marketplace manifest needed by Claude Code
- Registers the marketplace: `claude plugin marketplace add`
- Installs the plugin: `claude plugin install design-library@local`
- Sets up a daily cron job (6am) to keep design data up to date

### Step 3 — Reload plugins in Claude Code

Run this slash command inside any Claude Code session:

```
/reload-plugins
```

You should see: `Reloaded: 1 plugin · 10 skills · ...`

---

## Usage

### Auto-activation

When you start a Claude session, the plugin automatically detects your project type and activates the relevant skills. You'll see a message like:

```
[DESIGN SUITE ACTIVO] Proyecto detectado: web app
Skills cargados: design-library · ui-ux-pro-max · web-design-guidelines
```

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

### Natural language

The plugin also detects brand names in your prompts automatically — no command needed:

- *"Diseñame esto como Google y Anthropic"*
- *"Build me a page like Stripe"*

---

## Sections for granular brand mixing

`colors` · `typography` · `components` · `layout` · `elevation`

---

## Updating

To pull the latest design data:

```bash
bash ~/.claude/plugins/local/design-library/scripts/sync.sh
```

Or use the slash command inside Claude:

```
/design sync
```

---

## License

Apache License 2.0. See [LICENSE](LICENSE).

Copyright 2026 zeta92
