# Zvuk Music Provider for Music Assistant

English | [Русский](README.ru.md)

> Stream your [Zvuk Music](https://zvuk.com/) library through [Music Assistant](https://music-assistant.io/) with browse, search, playlist management, and lossless playback support.

## Quick Start (Docker)

```bash
# Clone the repo
git clone https://github.com/trudenboy/ma-provider-zvuk-music.git
cd ma-provider-zvuk-music

# Start Music Assistant with the provider pre-loaded
docker compose -f docker-compose.dev.yml up
```

Open the MA web UI at `http://localhost:8095`, then go to **Settings → Music Sources → Add Source → Zvuk Music** and enter your X-Auth-Token.

For the full Docker dev environment guide see [docs/dev-docker.md](docs/dev-docker.md).

## Features

- **Library sync** — Artists, Albums, Tracks (Liked), Playlists synced to MA library
- **Library editing** — Like / unlike Artists, Albums, Tracks, Playlists directly from MA
- **Search** — Tracks, Artists, Albums, Playlists
- **Playlist management** — Create playlists, add and remove tracks
- **Audio quality** — High (MP3 320 kbps) / Lossless (FLAC)

## Documentation

| Guide | Description |
|-------|-------------|
| [Configuration](docs/configuration.md) | Token, quality settings |
| [Development](docs/development.md) | Dev setup, tests, linting, commit format |
| [Contributing](docs/contributing.md) | Bug reports, feature requests, pull requests |
| [Testing](docs/testing.md) | Running tests locally, CI pipeline, coverage |
| [Incident Management](docs/incident-management.md) | Labels, automated issue tracking, Copilot triage |
| [Docker Dev Environment](docs/dev-docker.md) | Run MA + provider locally without dependencies |

## References

- [Music Assistant](https://music-assistant.io/) — open-source music server by Marcel van der Veldt
- [Zvuk Music](https://zvuk.com/) — streaming service by Sber
- [zvuk-music](https://github.com/trudenboy/zvuk-music) — unofficial Python client

## License

[Apache 2.0](LICENSE) — see [CHANGELOG.md](CHANGELOG.md) for version history.
