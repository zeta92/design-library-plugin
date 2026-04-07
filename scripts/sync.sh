#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DESIGNS_DIR="$PLUGIN_DIR/designs/awesome-design-md"
REPO_URL="https://github.com/VoltAgent/awesome-design-md.git"
CATALOG_FILE="$PLUGIN_DIR/skills/design-library/references/catalog.md"

# Clone or pull
if [ ! -d "$DESIGNS_DIR/.git" ]; then
  echo "Cloning awesome-design-md..."
  git clone --depth=1 "$REPO_URL" "$DESIGNS_DIR"
else
  echo "Pulling latest designs..."
  git -C "$DESIGNS_DIR" pull --ff-only
fi

# Generate catalog from actual directory listing
DESIGN_MD_DIR="$DESIGNS_DIR/design-md"
if [ ! -d "$DESIGN_MD_DIR" ]; then
  echo "ERROR: design-md directory not found in cloned repo" >&2
  exit 1
fi

echo "Generating catalog..."
cat > "$CATALOG_FILE" << 'HEADER'
# Design Library Catalog

Available brands (auto-generated from local clone).
Use brand name in any prompt or with `/design <brand>`.

## All Brands

HEADER

# List all brand directories alphabetically
for brand_dir in "$DESIGN_MD_DIR"/*/; do
  brand=$(basename "$brand_dir")
  if [ -f "$brand_dir/DESIGN.md" ]; then
    echo "- \`$brand\`" >> "$CATALOG_FILE"
  fi
done

BRAND_COUNT=$(ls -d "$DESIGN_MD_DIR"/*/ 2>/dev/null | wc -l | tr -d ' ')
echo "" >> "$CATALOG_FILE"
echo "_Total: $BRAND_COUNT brands_" >> "$CATALOG_FILE"

# Install daily cron (6am) if not already present
CRON_CMD="0 6 * * * bash $PLUGIN_DIR/scripts/sync.sh >> /tmp/design-library-sync.log 2>&1"
if ! crontab -l 2>/dev/null | grep -q "design-library.*sync.sh"; then
  (crontab -l 2>/dev/null; echo "$CRON_CMD") | crontab -
  echo "Cron job installed: daily sync at 6am"
else
  echo "Cron job already present, skipping"
fi

echo "Sync complete. $BRAND_COUNT brands available."
