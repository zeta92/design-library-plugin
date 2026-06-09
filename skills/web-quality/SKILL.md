---
name: web-quality
description: Audit and optimize web quality based on Google Lighthouse and Core Web Vitals — performance (LCP, INP, CLS), SEO, and best practices. Use when improving page speed, Lighthouse scores, or search ranking.
---

# Web Quality Skill

Powered by [addyosmani/web-quality-skills](https://github.com/addyosmani/web-quality-skills) — Agent Skills for web quality based on Lighthouse and Core Web Vitals.

## Activating this skill

Load the skill definition using the Read tool. Without an argument, run the full audit:

```
~/.claude/plugins/local/design-library/designs/web-quality-skills/skills/web-quality-audit/SKILL.md
```

If the file is not found, tell the user: "Run `/design sync` to download the Web Quality skills, then try again."

Follow all instructions in the loaded file.

## Focused modes

If the user passes an argument, load that sub-skill instead (all under `designs/web-quality-skills/skills/`):

| Argument | Skill file | Focus |
|----------|------------|-------|
| _(none)_ | `web-quality-audit/SKILL.md` | Full audit across all categories |
| `performance` | `performance/SKILL.md` | Loading, rendering, and runtime performance |
| `cwv` | `core-web-vitals/SKILL.md` | LCP, INP, CLS optimization |
| `seo` | `seo/SKILL.md` | Search engine optimization |
| `best-practices` | `best-practices/SKILL.md` | General web best practices |

For accessibility audits, use `/a11y` instead — it runs 11 WCAG 2.2 AA specialist agents and is more thorough than this repo's accessibility sub-skill.

## Tip

If the Playwright MCP server is available, use it to load the page in a real browser and verify findings (screenshots, console errors, network waterfall) before and after applying fixes.
