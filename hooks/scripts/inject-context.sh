#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DESIGN_MD_DIR="$PLUGIN_DIR/designs/awesome-design-md/design-md"

# Read hook input from stdin
INPUT=$(cat)
USER_PROMPT=$(echo "$INPUT" | jq -r '.user_prompt // ""')

# Exit early if prompt is empty or designs not synced yet
if [ -z "$USER_PROMPT" ] || [ ! -d "$DESIGN_MD_DIR" ]; then
  exit 0
fi

# Design intent keywords (ES + EN)
DESIGN_KEYWORDS="diseña|diseñame|disenar|estilo|interfaz|componente|landing|design|style|interface|component|ui|frontend|como.*google|como.*stripe|like.*figma"

# Check for design intent first (fast path exit if not a design prompt)
if ! echo "$USER_PROMPT" | grep -qiE "$DESIGN_KEYWORDS"; then
  exit 0
fi

# Get list of available brands from directory listing
BRANDS=()
while IFS= read -r -d '' brand_dir; do
  brand=$(basename "$brand_dir")
  BRANDS+=("$brand")
done < <(find "$DESIGN_MD_DIR" -maxdepth 1 -mindepth 1 -type d -print0 | sort -z)

if [ ${#BRANDS[@]} -eq 0 ]; then
  exit 0
fi

# Detect which brands appear in the user prompt (case-insensitive)
MATCHED_BRANDS=()
for brand in "${BRANDS[@]}"; do
  if echo "$USER_PROMPT" | grep -qiF "$brand"; then
    MATCHED_BRANDS+=("$brand")
  fi
done

# No brand matched — inject availability note and exit
if [ ${#MATCHED_BRANDS[@]} -eq 0 ]; then
  printf '{"systemMessage": "Design library available: %d brands ready. Mention a brand name (e.g., Stripe, Linear, Vercel, Google, Anthropic) or use /design to load a design system."}\n' "${#BRANDS[@]}"
  exit 0
fi

# Build system message with DESIGN.md content for each matched brand
CONTEXT=""
for brand in "${MATCHED_BRANDS[@]}"; do
  DESIGN_FILE="$DESIGN_MD_DIR/$brand/DESIGN.md"
  if [ -f "$DESIGN_FILE" ]; then
    CONTEXT+="## ${brand^} Design System\n\n"
    CONTEXT+=$(cat "$DESIGN_FILE")
    CONTEXT+="\n\n---\n\n"
  fi
done

if [ -z "$CONTEXT" ]; then
  exit 0
fi

# Output JSON with design context as systemMessage
BRAND_LIST=$(IFS=', '; echo "${MATCHED_BRANDS[*]}")
HEADER="[DESIGN CONTEXT LOADED: $BRAND_LIST]\n\nApply the following design system(s) to all UI code you produce in this response:\n\n"

# Use jq to safely encode the message as valid JSON
printf '%s' "$HEADER$CONTEXT" | jq -Rs '{"systemMessage": .}'
