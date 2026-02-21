# Zvuk Music Provider for Music Assistant

English | [Русский](README.ru.md)

> Stream music from Zvuk Music with browse, search, and playback support.

## Features

| Feature | Details |
|---------|---------|
| Browse | Liked Tracks, Artists, Albums, Playlists |
| Search | Tracks, artists, albums, playlists |
| Playback | MP3 (320 kbps), FLAC (lossless) |
| Library sync | Liked Tracks → MA library |

## Compatibility

| Provider Version | Min MA Version | Tested With MA |
|-----------------|----------------|----------------|
| 1.x.x           | 2.7.0          | 2.7.0b1        |

## Installation

Installed automatically as part of Music Assistant.

### Configuration

1. Settings → Music Sources → Add Source → Zvuk Music
2. Enter your Zvuk Music X-Auth-Token
3. Select streaming quality
4. Save

## Documentation

| Guide | Description |
|-------|-------------|
| [Configuration](docs/configuration.md) | All settings and options |
| [Development](docs/development.md) | Dev setup, tests, linting |
| [Contributing](docs/contributing.md) | Bug reports, feature requests, PRs |
| [Testing](docs/testing.md) | Running tests locally, CI pipeline, coverage |
| [Incident Management](docs/incident-management.md) | Labels, automated issue tracking, Copilot triage |
| [Docker Dev Environment](docs/dev-docker.md) | Run MA + provider locally without dependencies |

## License

[Apache 2.0](LICENSE)
