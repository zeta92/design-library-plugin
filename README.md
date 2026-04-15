# The Design Library

<img src="docs/cover.svg" alt="The Design Library — Claude Code plugin" width="100%"/>

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

---

## Projects powering this plugin

| Project | Used for | Stars |
|---|---|---|
| [VoltAgent/awesome-design-md](https://github.com/VoltAgent/awesome-design-md) | 58 brand design systems (DESIGN.md files) | — |
| [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) | `/ui-ux` — complete design system generator | 61k ⭐ |
| [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) | `/guidelines` — 100+ web interface rules | 24k ⭐ |
| [Owl-Listener/designer-skills](https://github.com/Owl-Listener/designer-skills) | `/design-process` — 63 design lifecycle skills | 505 ⭐ |
| [kylezantos/design-motion-principles](https://github.com/kylezantos/design-motion-principles) | `/motion` — animation audit via 3 designers | 256 ⭐ |
| [Community-Access/accessibility-agents](https://github.com/Community-Access/accessibility-agents) | `/a11y` — 11 WCAG 2.2 AA specialist agents | 214 ⭐ |

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

## Other AI coding agents

The 58 brand DESIGN.md files and skill content are plain Markdown — any AI coding agent can read them. Only the plugin hooks, SKILL.md wrappers, and `/reload-plugins` step are Claude Code–specific.

### Step 1 — Download design data (all agents)

Clone the repo and run the sync script:

```bash
git clone https://github.com/zeta92/design-library-plugin.git ~/design-library
bash ~/design-library/scripts/sync.sh
```

> If the `claude` CLI is not installed, the script prints a warning and skips the Claude registration steps — this is safe to ignore. The design data downloads correctly regardless.

After sync, brand files are at:

```
~/design-library/designs/awesome-design-md/design-md/<brand>/DESIGN.md
```

The full brand catalog is at:

```
~/design-library/skills/design-library/references/catalog.md
```

---

### Cursor

Create a global rule at `~/.cursor/rules/design-library.mdc`:

```markdown
---
description: Design Library — load brand design systems on request
alwaysApply: false
---

A local design library with 58 brand DESIGN.md files is available at:
~/design-library/designs/awesome-design-md/design-md/

Full brand list: ~/design-library/skills/design-library/references/catalog.md

When asked to design like a specific brand (e.g. "like Stripe", "como Google"):
1. Read ~/design-library/designs/awesome-design-md/design-md/<brand>/DESIGN.md
2. Apply its color palette, typography, component styles, and layout principles
3. Use the "Agent Prompt Guide" section of that DESIGN.md for targeted instruction

Available brands include: stripe, linear, vercel, figma, google, anthropic, notion,
spotify, apple, and 49 more — see the catalog for the full list.
```

To attach a brand file directly in a chat, use `@file`:

```
@~/design-library/designs/awesome-design-md/design-md/stripe/DESIGN.md
Apply the Stripe design system to this component.
```

---

### Windsurf

**Global rules** — add to `~/.codeium/windsurf/global_rules.md`:

```markdown
## Design Library

A local design library with 58 brand DESIGN.md files is available at:
~/design-library/designs/awesome-design-md/design-md/

Brand catalog: ~/design-library/skills/design-library/references/catalog.md

When working on UI tasks, read the matching DESIGN.md for brand-specific color palette,
typography, component styles, layout principles, and the Agent Prompt Guide section.
```

**Per-project override** — add to `.windsurfrules` in your project root:

```markdown
## Design Library
Brand DESIGN.md path: ~/design-library/designs/awesome-design-md/design-md/<brand>/DESIGN.md
Active brand for this project: stripe
```

---

### GitHub Copilot

Add to `.github/copilot-instructions.md` in your project:

```markdown
## Design Library

A local design library is available at ~/design-library/designs/.

Brand systems: ~/design-library/designs/awesome-design-md/design-md/<brand>/DESIGN.md
Catalog of available brands: ~/design-library/skills/design-library/references/catalog.md

When working on UI or design tasks:
- Check the catalog for available brands
- Read the matching DESIGN.md and apply its palette, typography, and component guidelines
- Use the "Agent Prompt Guide" section of each DESIGN.md for targeted instruction
```

---

### Cline (VS Code)

1. Open VS Code → Settings → search **Cline: Custom Instructions**
2. Add:

```
A local design library with 58 brand DESIGN.md files is at:
~/design-library/designs/awesome-design-md/design-md/

See ~/design-library/skills/design-library/references/catalog.md for all available brands.
When designing UI, read <brand>/DESIGN.md and apply its colors, typography, component
styles, and layout. Use the "Agent Prompt Guide" section for exact usage.
```

To attach a brand file in a task, use the file picker or paste the path:

```
~/design-library/designs/awesome-design-md/design-md/stripe/DESIGN.md
```

---

### Aider

Pass design files with `--read` at startup:

```bash
# Load one brand
aider --read ~/design-library/designs/awesome-design-md/design-md/stripe/DESIGN.md

# Load catalog + a specific brand
aider --read ~/design-library/skills/design-library/references/catalog.md \
      --read ~/design-library/designs/awesome-design-md/design-md/linear/DESIGN.md
```

For a permanent project convention, create `.aider.conventions.md` in your project root:

```markdown
## Design Library

Brand DESIGN.md files: ~/design-library/designs/awesome-design-md/design-md/<brand>/DESIGN.md
Available brands: ~/design-library/skills/design-library/references/catalog.md

When working on UI, load the relevant DESIGN.md and apply its design system.
```

---

### Keeping design data up to date

For all agents, re-run the sync script to pull the latest brand files:

```bash
bash ~/design-library/scripts/sync.sh
```

A daily cron job is installed automatically by `sync.sh` (runs at 6 am).

---

## License

Apache License 2.0. See [LICENSE](LICENSE).

Copyright 2026 zeta92
