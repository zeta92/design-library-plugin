#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
LOG_FILE="/tmp/design-library-sync.log"

# ── First-run: design data not yet downloaded ─────────────────────────────────
if [ ! -d "$PLUGIN_DIR/designs/awesome-design-md" ]; then
  # Only launch sync if it isn't already running
  if ! pgrep -f "design-library.*sync.sh" > /dev/null 2>&1; then
    nohup bash "$PLUGIN_DIR/scripts/sync.sh" > "$LOG_FILE" 2>&1 &
  fi

  MSG="[DESIGN SUITE] First run detected: design data is being downloaded in the background (~1-2 min). Let the user know briefly. The plugin will be fully active once the download completes. They can continue working normally in the meantime."
  printf '%s' "$MSG" | jq -Rs '{"systemMessage": .}'
  exit 0
fi

# Working directory: prefer CLAUDE_PROJECT_DIR, fall back to pwd
WORKING_DIR="${CLAUDE_PROJECT_DIR:-${CLAUDE_WORKING_DIR:-$(pwd)}}"

# ── Level 1: detect from source files ────────────────────────────────────────
project_type=""
active_skills=()

if [ -f "$WORKING_DIR/package.json" ]; then
  pkg=$(cat "$WORKING_DIR/package.json" 2>/dev/null || echo "{}")

  if echo "$pkg" | grep -qE '"storybook"|"chromatic"|"style-dictionary"|"design-tokens"'; then
    project_type="design system / component library"
    active_skills=("design-library" "web-design-guidelines" "designer-skills" "a11y")
  elif echo "$pkg" | grep -qE '"framer-motion"|"@gsap/react"|"motion"' && \
       echo "$pkg" | grep -qE '"next"|"gatsby"|"astro"|"react"'; then
    project_type="UI app with animations"
    active_skills=("design-library" "ui-ux-pro-max" "web-design-guidelines" "motion")
  elif echo "$pkg" | grep -qE '"next"|"gatsby"|"astro"'; then
    project_type="web app"
    active_skills=("design-library" "ui-ux-pro-max" "web-design-guidelines")
  elif echo "$pkg" | grep -qE '"react"|"vue"|"svelte"|"solid"'; then
    project_type="UI app"
    active_skills=("design-library" "ui-ux-pro-max" "web-design-guidelines")
  fi
fi

# ── Level 2: only a README, no source files ───────────────────────────────────
if [ -z "$project_type" ] && [ -f "$WORKING_DIR/README.md" ]; then
  other_files=$(find "$WORKING_DIR" -maxdepth 1 -mindepth 1 \
    -not -name "README.md" -not -name ".git" 2>/dev/null | wc -l)
  if [ "$other_files" -eq 0 ]; then
    readme_preview=$(head -10 "$WORKING_DIR/README.md" 2>/dev/null || echo "")
    MSG="[DESIGN SUITE] Found a README but no code yet. Read the full README to infer which design skills are needed.\n\n${readme_preview}\n\nAfter reading the README, activate the most relevant skills and let the user know with a line like: 'Skills activated: X · Y · Z. Sound right?'"
    printf '%b' "$MSG" | jq -Rs '{"systemMessage": .}'
    exit 0
  fi
fi

# ── Level 3: empty directory ──────────────────────────────────────────────────
if [ -z "$project_type" ]; then
  MSG="[DESIGN SUITE AVAILABLE] Empty directory. When the user asks to build a UI or interface, ask exactly these 3 questions (one at a time, not all at once):\n1. What are you building? (landing · app · design system · other)\n2. Do you have a brand or visual style in mind?\n3. Any special requirements? (accessibility, animations, i18n…)\n\nOnce answered, activate the relevant skills and let the user know which commands are available."
  printf '%b' "$MSG" | jq -Rs '{"systemMessage": .}'
  exit 0
fi

# ── Output Level 1 message ────────────────────────────────────────────────────
SKILL_LIST=$(printf '%s · ' "${active_skills[@]}")
SKILL_LIST="${SKILL_LIST% · }"
MSG="[DESIGN SUITE ACTIVE] Project detected: ${project_type}\nSkills loaded: ${SKILL_LIST}\n\nAvailable commands:\n  /design <brand>     — load a brand design system\n  /ui-ux              — generate a complete design system\n  /guidelines         — audit UI code (100+ rules)\n  /motion             — audit animations\n  /a11y               — accessibility audit (WCAG 2.2 AA)\n  /design-process     — access 63 design skills\n  /design ?           — re-analyze project"

printf '%b' "$MSG" | jq -Rs '{"systemMessage": .}'
