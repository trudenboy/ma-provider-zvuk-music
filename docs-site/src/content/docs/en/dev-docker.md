---
title: Docker Development
description: Local development via Docker — run Music Assistant with one command
---

Run a full Music Assistant instance with the Zvuk Music provider using a single command —
no Python, FFmpeg, or other dependencies required.

## Requirements

- [Docker](https://docs.docker.com/get-docker/)

## Quick start

```bash
docker compose -f docker-compose.dev.yml up
```

Open **http://localhost:8095** in your browser.

## First launch: creating a user

On first start, MA runs a setup wizard:

1. **Create a user** — set a login and password (stored locally in `.ma-data/`)
2. Skip the Home Assistant integration if prompted
3. Login credentials persist across container restarts via the `.ma-data/` volume

## Connecting the Zvuk Music provider

After logging in:

1. Go to **Settings** → **Providers**
2. Find **Zvuk Music** in the list — it is already available, the code is loaded automatically
3. Click **Add** and enter your credentials
4. Provider configuration is saved in `.ma-data/` and survives restarts

> 💡 If the provider does not appear — check the logs (`docker compose -f docker-compose.dev.yml logs`).
> Any startup errors will be visible there.

## Container management

| Action | Command |
|--------|---------|
| Start | `docker compose -f docker-compose.dev.yml up` |
| Start in background | `docker compose -f docker-compose.dev.yml up -d` |
| Stop | `docker compose -f docker-compose.dev.yml down` |
| Restart | `docker compose -f docker-compose.dev.yml restart` |
| Logs | `docker compose -f docker-compose.dev.yml logs -f` |
| Reset state | `rm -rf .ma-data/` → start again |

## Provider code changes

The code from `provider/` is mounted into the container via a symlink.
Changes are picked up after restarting the container — no image rebuild needed:

```bash
docker compose -f docker-compose.dev.yml restart
```

## State persistence

All MA config, provider credentials, and cache are stored in `.ma-data/` (add to `.gitignore`).
The folder is created automatically on first launch.
