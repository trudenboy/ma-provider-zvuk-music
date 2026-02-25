#!/usr/bin/env bash
# Reproduce upstream CI environment locally.
#
# What it does:
#   1. Uses the local ma-server clone (~/Projects/ma-server, upstream/zvuk_music branch)
#   2. Copies provider files into ma-server's zvuk_music provider directory
#   3. Creates an isolated venv in ma-server, installs .[test] + requirements_all.txt
#   4. Runs pre-commit (like CI lint job) and pytest (like CI test job)
#
# Usage:
#   ./scripts/test-upstream.sh              # lint + test
#   ./scripts/test-upstream.sh --lint-only  # pre-commit only
#   ./scripts/test-upstream.sh --test-only  # pytest only
set -euo pipefail

MA_SERVER="${MA_SERVER_DIR:-$HOME/Projects/ma-server}"
PROVIDER_SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/provider"
VENV="$MA_SERVER/.venv-ci"

MODE="${1:-}"

# ── Verify prerequisites ────────────────────────────────────────────────────
if [[ ! -d "$MA_SERVER" ]]; then
  echo "ERROR: ma-server not found at $MA_SERVER"
  echo "       Set MA_SERVER_DIR env var to override."
  exit 1
fi

BRANCH=$(git -C "$MA_SERVER" branch --show-current)
echo "▶ ma-server branch: $BRANCH"
echo "▶ provider source:  $PROVIDER_SRC"

# ── Sync provider files into ma-server ─────────────────────────────────────
DEST="$MA_SERVER/music_assistant/providers/zvuk_music"
echo "▶ Syncing provider → $DEST"
rsync -a --delete \
  --include="*.py" --include="manifest.json" \
  --exclude="__pycache__/" --exclude="*.pyc" \
  "$PROVIDER_SRC/" "$DEST/"

# ── Sync test files ─────────────────────────────────────────────────────────
TEST_SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/tests"
TEST_DEST="$MA_SERVER/tests/providers/zvuk_music"
mkdir -p "$TEST_DEST"
echo "▶ Syncing tests → $TEST_DEST"
rsync -a --delete \
  --include="*.py" --exclude="e2e/" --exclude="__pycache__/" --exclude="*.pyc" \
  "$TEST_SRC/" "$TEST_DEST/"

# ── Create / update venv ────────────────────────────────────────────────────
if [[ ! -d "$VENV" ]]; then
  echo "▶ Creating venv at $VENV"
  uv venv --python 3.12 "$VENV"
fi

echo "▶ Installing dependencies (uv pip install . .[test] -r requirements_all.txt)"
uv pip install --python "$VENV/bin/python" \
  "$MA_SERVER/.[test]" \
  -r "$MA_SERVER/requirements_all.txt" \
  --quiet

# ── Run pre-commit ───────────────────────────────────────────────────────────
if [[ "$MODE" != "--test-only" ]]; then
  echo ""
  echo "══════════════════════════════════════════"
  echo "  pre-commit (lint)"
  echo "══════════════════════════════════════════"
  cd "$MA_SERVER"
  SKIP=no-commit-to-branch \
    "$VENV/bin/python" -m pre_commit run --all-files || true
fi

# ── Run pytest ───────────────────────────────────────────────────────────────
if [[ "$MODE" != "--lint-only" ]]; then
  echo ""
  echo "══════════════════════════════════════════"
  echo "  pytest"
  echo "══════════════════════════════════════════"
  cd "$MA_SERVER"
  "$VENV/bin/python" -m pytest \
    --durations 10 \
    --cov=music_assistant \
    --cov-report=term-missing \
    tests/providers/zvuk_music/ \
    -v
fi
