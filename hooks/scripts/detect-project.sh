#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
LOG_FILE="/tmp/design-library-sync.log"

# ── First-run: design data not yet downloaded ─────────────────────────────────
if [ ! -d "$PLUGIN_DIR/designs/awesome-design-md" ]; then
  if ! pgrep -f "design-library.*sync.sh" > /dev/null 2>&1; then
    nohup bash "$PLUGIN_DIR/scripts/sync.sh" > "$LOG_FILE" 2>&1 &
  fi
  MSG="[DESIGN SUITE] First run detected: design data is being downloaded in the background (~1-2 min). Let the user know briefly. The plugin will be fully active once the download completes. They can continue working normally in the meantime."
  printf '%s' "$MSG" | jq -Rs '{"systemMessage": .}'
  exit 0
fi

WORKING_DIR="${CLAUDE_PROJECT_DIR:-${CLAUDE_WORKING_DIR:-$(pwd)}}"

project_type=""
active_skills=()
tailwind_detected=false
design_brief_found=false

# ── Helper: safely check for a package.json dependency ───────────────────────
has_dep() {
  local dep="$1"
  local pkg_file="$2"
  if [ ! -f "$pkg_file" ]; then return 1; fi
  timeout 2s jq -e \
    "((.dependencies // {}) | has(\"$dep\")) or ((.devDependencies // {}) | has(\"$dep\"))" \
    "$pkg_file" > /dev/null 2>&1
}

# ── Level 0: global design signals (independent of framework) ─────────────────
if [ -f "$WORKING_DIR/tailwind.config.js" ] || \
   [ -f "$WORKING_DIR/tailwind.config.ts" ] || \
   [ -f "$WORKING_DIR/tailwind.config.mjs" ]; then
  tailwind_detected=true
fi

if [ -f "$WORKING_DIR/tokens.json" ] || [ -f "$WORKING_DIR/design-tokens.json" ]; then
  active_skills+=("design-library")
fi

if [ -d "$WORKING_DIR/.storybook" ]; then
  active_skills+=("design-library")
fi

if [ -f "$WORKING_DIR/figma.json" ] || \
   [ -f "$WORKING_DIR/figma-tokens.json" ] || \
   [ -f "$WORKING_DIR/design-brief.md" ]; then
  design_brief_found=true
fi

# ── Level 1: detect from package.json ────────────────────────────────────────
if [ -f "$WORKING_DIR/package.json" ]; then
  PKG="$WORKING_DIR/package.json"

  if has_dep "storybook" "$PKG" || \
     has_dep "chromatic" "$PKG" || \
     has_dep "style-dictionary" "$PKG" || \
     has_dep "design-tokens" "$PKG"; then
    project_type="design system / component library"
    active_skills+=("design-library" "web-design-guidelines" "designer-skills" "a11y")

  elif has_dep "expo" "$PKG" || has_dep "react-native" "$PKG"; then
    project_type="mobile app"
    active_skills+=("design-library" "a11y")

  elif has_dep "electron" "$PKG"; then
    project_type="desktop app"
    active_skills+=("ui-ux-pro-max" "web-design-guidelines")

  elif has_dep "next" "$PKG" || \
       has_dep "remix" "$PKG" || \
       has_dep "@remix-run/react" "$PKG" || \
       has_dep "@sveltejs/kit" "$PKG" || \
       has_dep "nuxt" "$PKG" || \
       has_dep "astro" "$PKG" || \
       has_dep "gatsby" "$PKG" || \
       has_dep "qwik" "$PKG"; then
    project_type="web app"
    active_skills+=("design-library" "ui-ux-pro-max" "web-design-guidelines")

  elif has_dep "react" "$PKG" || \
       has_dep "vue" "$PKG" || \
       has_dep "svelte" "$PKG" || \
       has_dep "solid-js" "$PKG" || \
       has_dep "@angular/core" "$PKG" || \
       has_dep "lit" "$PKG" || \
       has_dep "preact" "$PKG" || \
       has_dep "alpinejs" "$PKG"; then
    project_type="UI app"
    active_skills+=("design-library" "ui-ux-pro-max" "web-design-guidelines")
    if has_dep "@angular/core" "$PKG"; then active_skills+=("guidelines"); fi
  fi

  # Detect animation libraries (applies to any project type above)
  if [ -n "$project_type" ]; then
    if has_dep "framer-motion" "$PKG" || \
       has_dep "@gsap/react" "$PKG" || \
       has_dep "motion" "$PKG"; then
      project_type="${project_type} with animations"
      active_skills+=("motion")
    fi
  fi
fi

# ── Level 1b: non-JS project detection ───────────────────────────────────────
if [ -z "$project_type" ]; then
  # Python web app with templates
  if find "$WORKING_DIR" -maxdepth 2 -name "*.py" 2>/dev/null | grep -q . && \
     [ -d "$WORKING_DIR/templates" ]; then
    project_type="python web app"
    active_skills+=("web-design-guidelines")

  # Hugo / Jekyll static site
  elif [ -f "$WORKING_DIR/config.toml" ] || \
       [ -f "$WORKING_DIR/config.yml" ] || \
       [ -f "$WORKING_DIR/_config.yml" ]; then
    project_type="static site"
    active_skills+=("web-design-guidelines")

  # Pure CSS / SCSS project
  elif find "$WORKING_DIR" -maxdepth 2 \( -name "*.scss" -o -name "*.sass" \) 2>/dev/null | grep -q .; then
    project_type="CSS/SCSS project"
    active_skills+=("web-design-guidelines")
  fi
fi

# Add Tailwind suffix when detected
if [ "$tailwind_detected" = true ] && [ -n "$project_type" ]; then
  project_type="${project_type} (Tailwind)"
fi

# ── Level 2: only a README, no source files ───────────────────────────────────
if [ -z "$project_type" ] && [ -f "$WORKING_DIR/README.md" ]; then
  other_files=$(find "$WORKING_DIR" -maxdepth 1 -mindepth 1 \
    -not -name "README.md" -not -name ".git" 2>/dev/null | wc -l)
  if [ "$other_files" -eq 0 ]; then
    TITLE=$(head -n 1 "$WORKING_DIR/README.md" | sed 's/^#* *//')
    PREVIEW=$(sed -n '2,8p' "$WORKING_DIR/README.md" | grep -v '^#' | head -3 | tr '\n' ' ')
    MSG="[DESIGN SUITE] Found a README but no code yet.\n\nProject: ${TITLE}\nContext: ${PREVIEW}\n\nI'll read the full README to infer which design skills are needed. After reading, I'll activate the most relevant skills and let you know with: 'Skills activated: X · Y · Z. Sound right?'"
    printf '%b' "$MSG" | jq -Rs '{"systemMessage": .}'
    exit 0
  fi
fi

# ── Level 3: empty directory ──────────────────────────────────────────────────
if [ -z "$project_type" ]; then
  EXTRA=""
  if [ "$design_brief_found" = true ]; then
    EXTRA="\n\n(Design brief or Figma file detected — I'll use that as additional context.)"
  fi
  MSG="[DESIGN SUITE AVAILABLE] Empty directory. When the user asks to build a UI or interface, ask exactly these 3 questions (one at a time, not all at once):\n1. What are you building? (landing · app · design system · other)\n2. Do you have a brand or visual style in mind?\n3. Any special requirements? (accessibility, animations, i18n…)\n\nOnce answered, activate the relevant skills and let the user know which commands are available.${EXTRA}"
  printf '%b' "$MSG" | jq -Rs '{"systemMessage": .}'
  exit 0
fi

# ── Output: project detected ──────────────────────────────────────────────────
# Deduplicate skills array
UNIQUE_SKILLS=()
declare -A seen
for skill in "${active_skills[@]}"; do
  if [ -z "${seen[$skill]+x}" ]; then
    UNIQUE_SKILLS+=("$skill")
    seen[$skill]=1
  fi
done

SKILL_LIST=$(printf '%s · ' "${UNIQUE_SKILLS[@]}")
SKILL_LIST="${SKILL_LIST% · }"

MSG="[DESIGN SUITE ACTIVE] Project detected: ${project_type}\nSkills loaded: ${SKILL_LIST}\n\nAvailable commands:\n  /design <brand>     — load a brand design system\n  /ui-ux              — generate a complete design system\n  /guidelines         — audit UI code (100+ rules)\n  /motion             — audit animations\n  /a11y               — accessibility audit (WCAG 2.2 AA)\n  /design-process     — access 63 design skills\n  /design ?           — re-analyze project"

printf '%b' "$MSG" | jq -Rs '{"systemMessage": .}'
