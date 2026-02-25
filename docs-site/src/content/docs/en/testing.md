---
title: Testing
description: Guide to running tests and linters for the Zvuk Music provider
---

## Quick start

```bash
uv run pytest provider/tests/ -v
```

With coverage report:

```bash
uv run pytest provider/tests/ -v --cov=provider/ --cov-report=term-missing
```

## CI pipeline

Every push and PR triggers two parallel jobs via `test.yml`:

| Job | What it does |
|-----|-------------|
| `test-*` | Runs pytest with coverage check, uploads report to Codecov |
| `lint-*` | Runs ruff, mypy, codespell, pre-commit |

Tests run against `music-assistant/server@dev` (no fork — lightweight CI).

## Tools

| Tool | Purpose |
|------|---------|
| `uv` | Virtual environment and dependency management |
| `Python 3.12` | Target language version |
| `pytest` | Test framework |
| `pytest-cov` | Coverage data collection |
| `Codecov` | Coverage report upload (automatic in CI) |
| `ruff` | Python linter and formatter |
| `mypy` | Static type analysis |
| `codespell` | Spell checking in source code |
| `pre-commit` | Pre-commit hooks |

## Running linters locally

Run all pre-commit hooks (recommended before a PR):

```bash
uv run pre-commit run --all-files
```

Type checking only:

```bash
uv run mypy provider/
```

Linting only:

```bash
uv run ruff check provider/
uv run ruff format --check provider/
```

## Coverage

Coverage reports are automatically uploaded to Codecov on every CI push.
To view coverage locally:

```bash
uv run pytest provider/tests/ --cov=provider/ --cov-report=html
open htmlcov/index.html
```

## If CI fails

If tests or linters fail in CI, a GitHub issue is automatically created with the `incident:ci` label.
See [Incident Management](incident-management.md) for details on the incident workflow.
