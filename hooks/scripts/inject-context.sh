#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DESIGN_MD_DIR="$PLUGIN_DIR/designs/awesome-design-md/design-md"

INPUT=$(cat)
USER_PROMPT=$(echo "$INPUT" | jq -r '.user_prompt // ""')

if [ -z "$USER_PROMPT" ] || [ ! -d "$DESIGN_MD_DIR" ]; then
  exit 0
fi

# ── Keyword categories ────────────────────────────────────────────────────────
# Each category targets natural language for one specific skill.

# /motion — animation & motion design
KW_MOTION="animat|transition|motion|hover effect|loading spinner|skeleton loader|scroll effect|parallax|micro.?interaction|easing|spring animation|bounce|fade in|slide in|page transition|keyframe|framer.?motion|\bgsap\b|lottie|css animation|animated component|entrance animation|exit animation|stagger|choreograph"

# /a11y — accessibility
KW_A11Y="accessib|wcag|screen reader|\baria\b|color contrast|focus trap|keyboard nav|tab order|alt text|\ba11y\b|inclusive design|reduced motion|high contrast|semantic html|focus ring|focus.?visible|color.?blind|dyslexia|cognitive load|skip.?link|landmark|live region"

# /guidelines — UI audit & web best practices
KW_GUIDELINES="\baudit\b|review (my|this|the) (ui|design|code|component|page)|critique|check (my|this) (ui|design)|best practices|improve (this|my) (ui|design)|dark mode support|responsive design|mobile.?first|touch target|form validation|error state|empty state|loading state|\bi18n\b|internationali[sz]|right.?to.?left|\brtl\b|web vitals|performance budget|image optimi|lazy load|font loading"

# /ui-ux — generating a design system or visual identity from scratch
KW_UIUX="design system|color palette|font pairing|typography (scale|system|hierarchy|ramp)|spacing system|generate (a |the )?(ui|design|layout|theme)|create (a )?(design system|ui|interface) for|redesign|visual identity|brand identity|style guide|component (library|system)|design tokens?|build (ui|interface) from scratch|ui kit|theme generator|moodboard|look and feel"

# /design-process — UX strategy and design lifecycle
KW_PROCESS="wireframe|prototype|user research|user persona|user journey|information architecture|design sprint|design review|design handoff|user flow|site.?map|card sorting|usability test|design critique|ux strategy|service design|design thinking|jobs.?to.?be.?done|problem space|discovery phase|define phase|ideation|affinity map|design doc|design brief|stakeholder|design decision"

# /design — brand-triggered design loading (softer gate for brand detection)
KW_BRAND_TRIGGER="design|style|look|ui|interface|build|create|make|component|landing|like |inspired by|similar to|aesthetic|visual|theme"

# ── Gate: exit early if no design intent at all ───────────────────────────────
ALL_KEYWORDS="${KW_MOTION}|${KW_A11Y}|${KW_GUIDELINES}|${KW_UIUX}|${KW_PROCESS}|${KW_BRAND_TRIGGER}"
if ! echo "$USER_PROMPT" | grep -qiE "$ALL_KEYWORDS"; then
  exit 0
fi

# ── Detect which skill categories match ───────────────────────────────────────
match_motion=false
match_a11y=false
match_guidelines=false
match_uiux=false
match_process=false

if echo "$USER_PROMPT" | grep -qiE "$KW_MOTION";     then match_motion=true;     fi
if echo "$USER_PROMPT" | grep -qiE "$KW_A11Y";       then match_a11y=true;       fi
if echo "$USER_PROMPT" | grep -qiE "$KW_GUIDELINES";  then match_guidelines=true; fi
if echo "$USER_PROMPT" | grep -qiE "$KW_UIUX";        then match_uiux=true;       fi
if echo "$USER_PROMPT" | grep -qiE "$KW_PROCESS";     then match_process=true;    fi

# ── Brand detection (only if brand-trigger keywords present) ─────────────────
MATCHED_BRANDS=()
if echo "$USER_PROMPT" | grep -qiE "$KW_BRAND_TRIGGER"; then
  BRANDS=()
  while IFS= read -r -d '' brand_dir; do
    BRANDS+=("$(basename "$brand_dir")")
  done < <(find "$DESIGN_MD_DIR" -maxdepth 1 -mindepth 1 -type d -print0 | sort -z)

  for brand in "${BRANDS[@]}"; do
    if echo "$USER_PROMPT" | grep -qiF "$brand"; then
      MATCHED_BRANDS+=("$brand")
    fi
  done
fi

# ── Build cross-skill hint line ───────────────────────────────────────────────
build_skill_hints() {
  local hints=""
  $match_motion     && hints+=" /motion"
  $match_a11y       && hints+=" /a11y"
  $match_guidelines && hints+=" /guidelines"
  $match_uiux       && hints+=" /ui-ux"
  $match_process    && hints+=" /design-process"
  echo "$hints"
}

skill_count=0
$match_motion     && ((skill_count++)) || true
$match_a11y       && ((skill_count++)) || true
$match_guidelines && ((skill_count++)) || true
$match_uiux       && ((skill_count++)) || true
$match_process    && ((skill_count++)) || true

# ── Case 1: brand(s) matched → inject DESIGN.md + cross-skill hints ──────────
if [ ${#MATCHED_BRANDS[@]} -gt 0 ]; then
  CONTEXT=""
  for brand in "${MATCHED_BRANDS[@]}"; do
    DESIGN_FILE="$DESIGN_MD_DIR/$brand/DESIGN.md"
    if [ -f "$DESIGN_FILE" ]; then
      CONTEXT+="## ${brand^} Design System\n\n$(cat "$DESIGN_FILE")\n\n---\n\n"
    fi
  done

  if [ -z "$CONTEXT" ]; then exit 0; fi

  BRAND_LIST=$(IFS=', '; echo "${MATCHED_BRANDS[*]}")
  CROSS=""
  SKILL_HINTS="$(build_skill_hints)"

  if [ -n "$SKILL_HINTS" ]; then
    CROSS="\n\nAdditional skills detected for this prompt —${SKILL_HINTS}"
    if [ "$skill_count" -gt 1 ]; then
      CROSS+=" — these can be chained for best results."
    else
      CROSS+="."
    fi
  fi

  HEADER="[DESIGN CONTEXT LOADED: $BRAND_LIST]\n\nApply the following design system(s) to all UI code in this response.${CROSS}\n\n"
  printf '%s' "$(printf '%b' "$HEADER")$CONTEXT" | jq -Rs '{"systemMessage": .}'
  exit 0
fi

# ── Case 2: no brand, specific skill(s) detected → targeted suggestion ────────
if [ "$skill_count" -gt 0 ]; then
  SKILL_HINTS="$(build_skill_hints)"
  BRAND_COUNT=$(find "$DESIGN_MD_DIR" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')

  # Build a natural description of what was detected
  WHAT=""
  $match_uiux       && WHAT+="design system generation, "
  $match_motion     && WHAT+="animation/motion, "
  $match_a11y       && WHAT+="accessibility, "
  $match_guidelines && WHAT+="UI audit/best practices, "
  $match_process    && WHAT+="design process, "
  WHAT="${WHAT%, }"  # trim trailing comma

  CHAIN=""
  if [ "$skill_count" -gt 1 ]; then
    CHAIN=" These skills work well together — run them in sequence for comprehensive coverage."
  fi

  MSG="[DESIGN SUITE] ${WHAT^} detected.\n\nRelevant commands:${SKILL_HINTS}\n${CHAIN}\n\nAlso: ${BRAND_COUNT} brand design systems available — mention a brand name or use /design <brand> to load one."
  printf '%b' "$MSG" | jq -Rs '{"systemMessage": .}'
  exit 0
fi

# ── Case 3: general design intent, no specific skill or brand ─────────────────
BRAND_COUNT=$(find "$DESIGN_MD_DIR" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
printf '{"systemMessage": "Design library available: %s brand design systems ready. Mention a brand name (e.g., Stripe, Linear, Vercel, Google, Anthropic) or use /design <brand> to load one. Other commands: /ui-ux · /guidelines · /motion · /a11y · /design-process"}\n' "$BRAND_COUNT"
