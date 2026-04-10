#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCAL_PLUGINS_DIR="$(dirname "$PLUGIN_DIR")"
DESIGNS_DIR="$PLUGIN_DIR/designs/awesome-design-md"
REPO_URL="https://github.com/VoltAgent/awesome-design-md.git"
CATALOG_FILE="$PLUGIN_DIR/skills/design-library/references/catalog.md"

echo "=== Design Library Sync: $(date) ==="

# ---------------------------------------------------------------------------
# 1. Clone or update awesome-design-md
# ---------------------------------------------------------------------------
if [ ! -d "$DESIGNS_DIR/.git" ]; then
  echo "Cloning awesome-design-md..."
  git clone --depth=1 "$REPO_URL" "$DESIGNS_DIR"
else
  echo "Pulling latest designs..."
  git -C "$DESIGNS_DIR" fetch --depth=1 origin
  git -C "$DESIGNS_DIR" reset --hard origin/HEAD
fi

# ---------------------------------------------------------------------------
# 2. Generate catalog from actual directory listing
# ---------------------------------------------------------------------------
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

# ---------------------------------------------------------------------------
# 3. Register local marketplace (idempotent)
# ---------------------------------------------------------------------------
MARKETPLACE_JSON="$LOCAL_PLUGINS_DIR/.claude-plugin/marketplace.json"

if [ ! -f "$MARKETPLACE_JSON" ]; then
  echo "Creating local marketplace manifest..."
  mkdir -p "$(dirname "$MARKETPLACE_JSON")"
  cat > "$MARKETPLACE_JSON" << 'JSON'
{
  "name": "local",
  "description": "Local plugins installed manually",
  "owner": {
    "name": "local"
  },
  "plugins": [
    {
      "name": "design-library",
      "description": "A full design suite: 58 brand design systems + UI/UX, accessibility, motion, guidelines, and design-process skills.",
      "source": "./design-library",
      "category": "design"
    }
  ]
}
JSON
fi

if command -v claude &>/dev/null; then
  if ! claude plugin marketplace list 2>/dev/null | grep -q "^local"; then
    echo "Registering local marketplace with Claude Code..."
    claude plugin marketplace add "$LOCAL_PLUGINS_DIR" --scope user
  else
    echo "Local marketplace already registered"
  fi

  if ! claude plugin list 2>/dev/null | grep -q "design-library@local"; then
    echo "Installing design-library plugin..."
    claude plugin install design-library@local
  else
    echo "design-library plugin already installed"
  fi
else
  echo "WARNING: 'claude' CLI not found in PATH. Run these manually after install:"
  echo "  claude plugin marketplace add \"$LOCAL_PLUGINS_DIR\" --scope user"
  echo "  claude plugin install design-library@local"
fi

# ---------------------------------------------------------------------------
# 4. Install daily cron (6am) if not already present
# ---------------------------------------------------------------------------
CRON_CMD="0 6 * * * $PLUGIN_DIR/scripts/sync.sh >> /tmp/design-library-sync.log 2>&1"
if ! crontab -l 2>/dev/null | grep -qF "$PLUGIN_DIR/scripts/sync.sh"; then
  (crontab -l 2>/dev/null; echo "$CRON_CMD") | crontab -
  echo "Cron job installed: daily sync at 6am"
else
  echo "Cron job already present, skipping"
fi

echo ""
echo "Sync complete. $BRAND_COUNT brands available."
echo "Run /reload-plugins in Claude Code to activate the plugin."
