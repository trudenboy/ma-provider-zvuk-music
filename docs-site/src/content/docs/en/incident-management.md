---
title: Incident Management
description: Process for creating and handling incidents for the Zvuk Music provider
---

## Where to file incidents

> **File issues here:** [github.com/trudenboy/ma-provider-zvuk-music/issues](https://github.com/trudenboy/ma-provider-zvuk-music/issues)

Use the **New Issue** button and pick the appropriate template. Do not file issues in `trudenboy/ma-server` or `trudenboy/ma-provider-tools` — those repositories serve a different purpose.

## Labels

All issues use a standardised label system:

### Incident labels

| Label | Colour | Description |
|-------|--------|-------------|
| `incident:ci` | 🔴 | CI/CD failure |
| `incident:release` | 🔴 | Release pipeline failure |
| `incident:sync` | 🟠 | Fork sync failure |
| `incident:bug` | 🔴 | User-reported bug |
| `incident:security` | 🟣 | Security vulnerability |
| `incident:upstream` | 🔵 | Upstream API change |
| `incident:proposal` | 🟢 | Improvement proposal or new feature |

### Priority labels

| Label | Description |
|-------|-------------|
| `priority:critical` | Blocking, requires immediate action |
| `priority:high` | Important, resolve soon |
| `priority:medium` | Normal queue |
| `priority:low` | Nice to have, not urgent |

### Special labels

| Label | Description |
|-------|-------------|
| `copilot` | Assign the issue to the GitHub Copilot agent |

## Automated incident pipeline

Many incidents are created automatically without manual intervention:

### CI failures

1. Tests or linters fail in `test.yml`
2. `reusable-report-incident.yml` creates an issue with labels `incident:ci` + `priority:high`
3. If an open issue for this failure type already exists — a comment is added (no duplicates)
4. The issue is automatically added to the MA Ecosystem project board

### Other automated incidents

| Event | Label |
|-------|-------|
| Fork sync failure | `incident:sync` |
| Security audit failure | `incident:security` |
| Release pipeline failure | `incident:release` |

## GitHub Projects board (MA Ecosystem)

All issues with `incident:*` labels are automatically added to the project board:

- **Adding**: `issue-project.yml` triggers on issue creation or label change
- **Provider field**: set automatically for Zvuk Music
- **Release tracking**: `reusable-release.yml` creates a draft project item for each release

## Copilot triage

Any issue can be handed to the GitHub Copilot agent for automated analysis:

1. Add the `copilot` label to the issue
2. `copilot-triage.yml` automatically assigns `@copilot`
3. Copilot analyses the issue and may open a PR with a fix

This is useful for routine bugs, documentation typos, and small improvements.

## Manual incident creation

Use issue templates to create incidents manually:

| Template | When to use |
|----------|-------------|
| **Bug report** | Reproducible bug — attach label `incident:bug` |
| **Upstream API change** | Upstream API changed — label `incident:upstream` |
| **Improvement proposal** | New feature request — label `incident:proposal` |

After creating the issue, add a priority label if needed.
