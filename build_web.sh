#!/bin/bash
#
# GameCon Web Build Script
#
# Builds the Flutter PWA with --base-href /app/, then assembles
# the final public directory with the static landing page at root
# and the Flutter app nested under /app/.
#
# Usage:
#   ./build_web.sh saas       # builds for tkd-saas target  (build/web/saas)
#   ./build_web.sh wasm       # builds for gamecon target    (build/web/wasm)
#   ./build_web.sh            # defaults to "saas"
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LANDING_DIR="${SCRIPT_DIR}/landing"

TARGET="${1:-saas}"
OUTPUT_DIR="${SCRIPT_DIR}/build/web/${TARGET}"
FLUTTER_TEMP="${OUTPUT_DIR}/_flutter_build"
APP_DIR="${OUTPUT_DIR}/app"

echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║           GameCon Web — Build Script                ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""
echo "  Target:  ${TARGET}"
echo "  Output:  ${OUTPUT_DIR}"
echo ""

# ── Step 1: Flutter build ──────────────────────────────────
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔨 Building Flutter web with --base-href /app/"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Build to a temp directory first so we can restructure
rm -rf "${FLUTTER_TEMP}"

if [ "${TARGET}" = "wasm" ]; then
  flutter build web --wasm --base-href /app/ --output "${FLUTTER_TEMP}"
else
  flutter build web --base-href /app/ --output "${FLUTTER_TEMP}"
fi

echo ""
echo "  ✅ Flutter build complete"
echo ""

# ── Step 2: Restructure ───────────────────────────────────
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📁 Assembling final directory structure"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Clear previous output (except the temp build we just made)
find "${OUTPUT_DIR}" -mindepth 1 -maxdepth 1 ! -name '_flutter_build' -exec rm -rf {} +

# Move Flutter build into /app/ subfolder
mkdir -p "${APP_DIR}"
mv "${FLUTTER_TEMP}"/* "${APP_DIR}/"
rm -rf "${FLUTTER_TEMP}"

echo "  ✅ Flutter files moved to ${APP_DIR}"

# ── Step 3: Copy landing page ─────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📄 Copying landing page to root"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

cp "${LANDING_DIR}"/* "${OUTPUT_DIR}/"

echo "  ✅ Landing page copied"

# ── Summary ───────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Done! 🎉"
echo ""
echo "  ${OUTPUT_DIR}/"
echo "  ├── index.html        ← Landing page"
echo "  ├── style.css         ← Landing styles"
echo "  └── app/"
echo "      ├── index.html    ← Flutter PWA"
echo "      ├── flutter.js"
echo "      ├── main.dart.js"
echo "      └── ..."
echo ""
echo "  Deploy:  firebase deploy --only hosting:${TARGET}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
