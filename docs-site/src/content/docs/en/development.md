---
title: Development Guide
description: Development environment setup, tooling, and workflow for the Zvuk Music provider
---

## Prerequisites

- Python 3.12+
- [uv](https://docs.astral.sh/uv/) — `curl -LsSf https://astral.sh/uv/install.sh | sh`
- ffmpeg 6.1+ (for MA integration tests)
  - macOS: `brew install ffmpeg`
  - Ubuntu: `sudo apt-get install ffmpeg`
- Fork of [trudenboy/ma-server](https://github.com/trudenboy/ma-server) (for dev server)

## Setup

```bash
./scripts/setup.sh
```

Re-run after `git pull` — MA models version may change.

## Running Tests

```bash
# Unit tests (fast, no MA server needed)
pytest tests/ -m "not integration"

# Full test suite
pytest tests/

# With coverage
pytest --cov=provider --cov-report=html tests/
```

## Day-to-Day Workflow

### Branch naming

```
feature/<description>     # new functionality
fix/<description>         # bugfixes
chore/<description>       # maintenance, dependency updates
```

`<description>` — kebab-case, 2–4 words. Examples:
```
feature/radio-mode-support
fix/seek-position-reset
chore/update-deps
```

### Feature branch lifecycle

```bash
# 1. Create branch from dev
git checkout dev && git pull
git checkout -b feature/radio-mode-support

# 2. Development + tests
pytest tests/
pre-commit run --all-files

# 3. PR: feature/* → dev
git push origin feature/radio-mode-support
gh pr create --base dev --title "feat: add radio mode support"

# 4. CI passes → merge → delete branch
git push origin --delete feature/radio-mode-support
```

## Running Dev Server

Starts Music Assistant with live provider code (no Docker, isolated from other work):

```bash
./scripts/dev-server.sh
# UI: http://localhost:8095
```

Requires fork of ma-server. Discovery order:
1. `MA_SERVER_REPO=/path/to/ma-server ./scripts/dev-server.sh`
2. `echo "/path/to/ma-server" > ma-server.repo` (gitignored)
3. Autodetect: `../ma-server`, `~/Projects/ma-server`, `~/src/ma-server`, `~/dev/ma-server`

:::note
Dev server binds port 8095 — don't run `pytest tests/` (with mass fixture) simultaneously.
:::

## Code Quality

```bash
pre-commit run --all-files
```

Runs: ruff (lint + format), mypy (type check), codespell.

## Conventional Commits

Used for automatic CHANGELOG generation:
```
feat: add radio mode support
fix: fix seek position reset
chore: update zvuk dependencies
test: add streaming test
```

## Release Process

1. PR: `dev` → `main`
2. Merge `main`
3. Trigger Release workflow: Actions → Release → Run workflow → enter version (e.g. `1.1.0`)
4. Workflow creates tag, GitHub Release (with auto-generated release notes)
5. Sync PR auto-created in [trudenboy/ma-server](https://github.com/trudenboy/ma-server)

## Troubleshooting

**`sync-to-fork.yml` fails — FORK_SYNC_PAT expired**

Renew the PAT (needs `contents:write` on `trudenboy/ma-server`) then update the secret:

```bash
gh secret set FORK_SYNC_PAT --body "$NEW_PAT" --repo trudenboy/ma-provider-zvuk-music
```

**Port 8095 already in use**

```bash
lsof -i :8095
kill <PID>
```

**`dev-server.sh` can't find the fork**

```bash
# Option 1: env var
MA_SERVER_REPO=~/work/ma-server ./scripts/dev-server.sh

# Option 2: local override file (gitignored)
echo "~/work/ma-server" > ma-server.repo
```

## E2E Checklist

Run before upstream PR or major release:

- [ ] Provider connects successfully
- [ ] Browse → Zvuk Music opens, library displayed
- [ ] Track/artist/album search returns results
- [ ] Track plays correctly, seek works
- [ ] Favourite tracks sync to library
