#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Exit if not yet synced (no design data available)
if [ ! -d "$PLUGIN_DIR/designs/awesome-design-md" ]; then
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
  other_files=$(find "$WORKING_DIR" -maxdepth 1 -not -name "README.md" \
    -not -name ".git" -not -name "." 2>/dev/null | wc -l)
  if [ "$other_files" -eq 0 ]; then
    readme_preview=$(head -10 "$WORKING_DIR/README.md" 2>/dev/null || echo "")
    MSG="[DESIGN SUITE] Encontré un README pero sin código todavía. Voy a leer el README para inferir qué design skills necesitas.\n\n${readme_preview}\n\nDespués de leer el README completo, activa los skills más relevantes e indica cuáles son con una línea como: 'Skills activados: X · Y · Z. ¿Correcto?'"
    printf '%s' "$MSG" | jq -Rs '{"systemMessage": .}'
    exit 0
  fi
fi

# ── Level 3: empty directory ──────────────────────────────────────────────────
if [ -z "$project_type" ]; then
  MSG="[DESIGN SUITE DISPONIBLE] El directorio está vacío. Cuando el usuario pida construir UI o una interfaz, hazle exactamente estas 3 preguntas (una a la vez, no todas juntas):\n1. ¿Qué estás construyendo? (landing · app · design system · otro)\n2. ¿Tienes alguna marca o estilo visual en mente?\n3. ¿Hay algún requisito especial? (accesibilidad, animaciones, i18n…)\n\nUna vez respondidas, activa los skills correspondientes e informa al usuario qué comandos tiene disponibles."
  printf '%s' "$MSG" | jq -Rs '{"systemMessage": .}'
  exit 0
fi

# ── Output Level 1 message ────────────────────────────────────────────────────
SKILL_LIST=$(IFS=' · '; echo "${active_skills[*]}")
MSG="[DESIGN SUITE ACTIVO] Proyecto detectado: ${project_type}\nSkills cargados: ${SKILL_LIST}\n\nComandos disponibles:\n  /design <marca>     — cargar sistema de diseño de marca\n  /ui-ux              — generar design system completo\n  /guidelines         — auditar código UI (100+ reglas)\n  /motion             — auditar animaciones\n  /a11y               — auditar accesibilidad (WCAG 2.2 AA)\n  /design-process     — acceder a 63 skills de diseño\n  /design ?           — re-analizar proyecto"

printf '%s' "$MSG" | jq -Rs '{"systemMessage": .}'
