#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DESIGNS_DIR="$PLUGIN_DIR/designs/awesome-design-md"
REPO_URL="https://github.com/VoltAgent/awesome-design-md.git"
CATALOG_FILE="$PLUGIN_DIR/skills/design-library/references/catalog.md"

echo "=== Design Library Sync: $(date) ==="

# Clone or pull
if [ ! -d "$DESIGNS_DIR/.git" ]; then
  echo "Cloning awesome-design-md..."
  git clone --depth=1 "$REPO_URL" "$DESIGNS_DIR"
else
  echo "Pulling latest designs..."
  git -C "$DESIGNS_DIR" fetch --depth=1 origin
  git -C "$DESIGNS_DIR" reset --hard origin/HEAD
fi

# ── ui-ux-pro-max-skill ──────────────────────────────────────────────────────
UI_UX_DIR="$PLUGIN_DIR/designs/ui-ux-pro-max-skill"
if [ ! -d "$UI_UX_DIR/.git" ]; then
  echo "Cloning ui-ux-pro-max-skill..."
  git clone --depth=1 https://github.com/nextlevelbuilder/ui-ux-pro-max-skill.git "$UI_UX_DIR"
else
  echo "Pulling ui-ux-pro-max-skill..."
  git -C "$UI_UX_DIR" fetch --depth=1 origin
  git -C "$UI_UX_DIR" reset --hard origin/HEAD
fi

# ── vercel agent-skills ──────────────────────────────────────────────────────
VERCEL_DIR="$PLUGIN_DIR/designs/agent-skills"
if [ ! -d "$VERCEL_DIR/.git" ]; then
  echo "Cloning vercel agent-skills..."
  git clone --depth=1 https://github.com/vercel-labs/agent-skills.git "$VERCEL_DIR"
else
  echo "Pulling vercel agent-skills..."
  git -C "$VERCEL_DIR" fetch --depth=1 origin
  git -C "$VERCEL_DIR" reset --hard origin/HEAD
fi

# ── Owl-Listener/designer-skills ─────────────────────────────────────────────
DESIGNER_DIR="$PLUGIN_DIR/designs/designer-skills"
if [ ! -d "$DESIGNER_DIR/.git" ]; then
  echo "Cloning designer-skills..."
  git clone --depth=1 https://github.com/Owl-Listener/designer-skills.git "$DESIGNER_DIR"
else
  echo "Pulling designer-skills..."
  git -C "$DESIGNER_DIR" fetch --depth=1 origin
  git -C "$DESIGNER_DIR" reset --hard origin/HEAD
fi

# ── kylezantos/design-motion-principles ──────────────────────────────────────
MOTION_DIR="$PLUGIN_DIR/designs/design-motion-principles"
if [ ! -d "$MOTION_DIR/.git" ]; then
  echo "Cloning design-motion-principles..."
  git clone --depth=1 https://github.com/kylezantos/design-motion-principles.git "$MOTION_DIR"
else
  echo "Pulling design-motion-principles..."
  git -C "$MOTION_DIR" fetch --depth=1 origin
  git -C "$MOTION_DIR" reset --hard origin/HEAD
fi

# ── Community-Access/accessibility-agents ────────────────────────────────────
A11Y_DIR="$PLUGIN_DIR/designs/accessibility-agents"
if [ ! -d "$A11Y_DIR/.git" ]; then
  echo "Cloning accessibility-agents..."
  git clone --depth=1 https://github.com/Community-Access/accessibility-agents.git "$A11Y_DIR"
else
  echo "Pulling accessibility-agents..."
  git -C "$A11Y_DIR" fetch --depth=1 origin
  git -C "$A11Y_DIR" reset --hard origin/HEAD
fi

# Generate catalog from actual directory listing
DESIGN_MD_DIR="$DESIGNS_DIR/design-md"
if [ ! -d "$DESIGN_MD_DIR" ]; then
  echo "ERROR: design-md directory not found in cloned repo" >&2
  exit 1
fi

echo "Generating catalog..."
mkdir -p "$(dirname "$CATALOG_FILE")"
cat > "$CATALOG_FILE" << 'HEADER'
# Design Library Catalog

Available brands (auto-generated from local clone).
Use brand name in any prompt or with `/design <brand>`.

## All Brands

HEADER

# List all brand directories alphabetically
shopt -s nullglob
BRAND_COUNT=0
for brand_dir in "$DESIGN_MD_DIR"/*/; do
  brand=$(basename "$brand_dir")
  if [ -f "$brand_dir/DESIGN.md" ]; then
    echo "- \`$brand\`" >> "$CATALOG_FILE"
    ((BRAND_COUNT++)) || true
  fi
done
shopt -u nullglob
echo "" >> "$CATALOG_FILE"
echo "_Total: $BRAND_COUNT brands_" >> "$CATALOG_FILE"

# Install daily cron (6am) if not already present
CRON_CMD="0 6 * * * $PLUGIN_DIR/scripts/sync.sh >> /tmp/design-library-sync.log 2>&1"
if ! crontab -l 2>/dev/null | grep -qF "$PLUGIN_DIR/scripts/sync.sh"; then
  (crontab -l 2>/dev/null; echo "$CRON_CMD") | crontab -
  echo "Cron job installed: daily sync at 6am"
else
  echo "Cron job already present, skipping"
fi

echo "Sync complete. $BRAND_COUNT brands + 5 design skills available."
