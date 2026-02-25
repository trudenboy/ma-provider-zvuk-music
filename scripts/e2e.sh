#!/usr/bin/env bash
# e2e.sh — run Zvuk Music e2e tests against a local MA Docker instance
#
# Usage:
#   ./scripts/e2e.sh                    # run all e2e tests
#   ./scripts/e2e.sh -k test_search     # run specific test(s)
#   ./scripts/e2e.sh --headed           # show browser window
#
# Requirements:
#   - Docker running
#   - ZVUK_TOKEN set in .env (or as env var)
#   - pip install ".[e2e]" + playwright install chromium
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
COMPOSE_FILE="$REPO_ROOT/docker-compose.e2e.yml"

# Load .env if present
if [[ -f "$REPO_ROOT/.env" ]]; then
  # shellcheck disable=SC1091
  set -a
  source "$REPO_ROOT/.env"
  set +a
fi

if [[ -z "${ZVUK_TOKEN:-}" ]]; then
  echo "ERROR: ZVUK_TOKEN is not set. Add it to .env or export it."
  exit 1
fi

cleanup() {
  echo ""
  echo "==> Stopping MA container..."
  docker compose -f "$COMPOSE_FILE" down --remove-orphans 2>/dev/null || true
}
trap cleanup EXIT INT TERM

echo "==> Starting Music Assistant (Docker)..."
docker compose -f "$COMPOSE_FILE" up -d

echo "==> Waiting for MA to be ready at http://localhost:8095 ..."
TIMEOUT=120
ELAPSED=0
until curl -sf -o /dev/null -w "%{http_code}" http://localhost:8095 2>/dev/null | grep -qE "^(200|302)"; do
  if [[ $ELAPSED -ge $TIMEOUT ]]; then
    echo "ERROR: MA did not start within ${TIMEOUT}s."
    docker compose -f "$COMPOSE_FILE" logs --tail=50
    exit 1
  fi
  sleep 3
  ELAPSED=$((ELAPSED + 3))
done
echo "==> MA is ready."

echo "==> Running e2e tests..."
cd "$REPO_ROOT"
python -m pytest tests/e2e/ -m e2e -v "$@"
