# design-library

Global Claude Code plugin — 58 brand design systems always available.

## Usage

### Slash command
- `/design stripe` — load one brand
- `/design stripe + linear` — mix two brands
- `/design stripe:colors + linear:typography` — granular mix by section
- `/design ?` — auto-suggest based on your project
- `/design list` — show all 58 brands by category
- `/design sync` — pull latest designs from GitHub

### Natural language (no command needed)
- "Diseñame esto como Google y Anthropic"
- "Hazlo con el estilo de Stripe"
- "build me a page like Figma"

The hook detects brand names automatically and injects the design context.

## Installation

Clone or copy this plugin to `~/.claude/plugins/local/design-library/`, then register it in your Claude Code settings. Restart Claude Code for the plugin to take effect.

**Source:** https://github.com/zeta92/design-library-plugin

## Setup

Run once after install:

```bash
bash ~/.claude/plugins/local/design-library/scripts/sync.sh
```

This clones the design library locally and installs a daily sync cron job.

## Sections available for granular mix

`colors` · `typography` · `components` · `layout` · `elevation`
