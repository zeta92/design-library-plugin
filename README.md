# design-library-plugin

> Global Claude Code plugin — 58 brand design systems always available via `/design` command or natural language.

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

---

## Overview

`design-library-plugin` is a Claude Code plugin that gives you instant access to 58 brand design systems (Stripe, Linear, Vercel, Figma, Google, Anthropic, and more) directly inside your coding sessions.

Use it via a slash command or just speak naturally — the plugin detects brand names and injects the right design context automatically.

**Design data source:** [VoltAgent/awesome-design-md](https://github.com/VoltAgent/awesome-design-md)

---

## Installation

Clone or copy this plugin to the Claude Code plugins directory:

```bash
git clone https://github.com/zeta92/design-library-plugin.git ~/.claude/plugins/local/design-library
```

Then register it in your Claude Code settings and restart Claude Code for the plugin to take effect.

---

## Setup

Run once after install to clone the design library locally and set up a daily auto-sync cron job:

```bash
bash ~/.claude/plugins/local/design-library/scripts/sync.sh
```

---

## Usage

### Slash commands

| Command | Description |
|---|---|
| `/design stripe` | Load one brand's full design system |
| `/design stripe + linear` | Mix two brands |
| `/design stripe:colors + linear:typography` | Granular mix by section |
| `/design ?` | Auto-suggest based on your project |
| `/design list` | Show all 58 brands by category |
| `/design sync` | Pull latest designs from GitHub |

### Natural language (no command needed)

Just describe what you want — the hook detects brand names automatically:

- *"Diseñame esto como Google y Anthropic"*
- *"Hazlo con el estilo de Stripe"*
- *"Build me a page like Figma"*

---

## Sections available for granular mix

`colors` · `typography` · `components` · `layout` · `elevation`

---

## Design data

All design system data is sourced from **[VoltAgent/awesome-design-md](https://github.com/VoltAgent/awesome-design-md)** — a community-maintained collection of brand design systems in Markdown format.

The `sync.sh` script keeps your local copy up to date automatically.

---

## License

This project is licensed under the **Apache License 2.0**. See the [LICENSE](LICENSE) file for details.

Copyright 2026 zeta92