# Copilot Instructions

This is a **Music Assistant (MA) music provider** for the [Zvuk Music](https://zvuk.com/) streaming service (Russian). It bridges the unofficial `zvuk-music` Python client to the MA plugin interface.

## Build & Test

```bash
# Install dependencies (requires uv, Python 3.12+)
./scripts/setup.sh

# Run unit tests (fast, no MA server)
pytest tests/ -m "not integration"

# Run a single test file or test
pytest tests/test_parsers.py
pytest tests/test_parsers.py::TestParseArtist::test_parse_artist_basic

# Full suite with coverage
pytest --cov=provider --cov-report=html tests/

# Lint + type check + format (all-in-one)
pre-commit run --all-files
```

## Architecture

The provider follows the MA plugin pattern with three layers:

| File | Role |
|------|------|
| `provider/__init__.py` | Entry point: `setup()`, `get_config_entries()`, declares `SUPPORTED_FEATURES` |
| `provider/provider.py` | `ZvukMusicProvider(MusicProvider)` — implements the MA interface (get_library_*, search, streaming) |
| `provider/api_client.py` | `ZvukMusicClient` — wraps `zvuk_music.ClientAsync`, maps Zvuk exceptions to MA errors |
| `provider/parsers.py` | Pure functions: convert Zvuk API objects → MA model objects |
| `provider/manifest.json` | Plugin metadata consumed by MA (`domain: zvuk_music`) |

**Data flow**: MA calls `ZvukMusicProvider` → `ZvukMusicClient` → `zvuk_music.ClientAsync` → Zvuk API → responses parsed by `parsers.py` into MA models.

**Zvuk API terminology**: Zvuk uses "release" for albums — always call `client.get_release()` / `client.get_releases()`, never "album". The `parse_album()` parser handles the translation.

## Key Conventions

**Error handling**: All `ZvukMusicClient` methods are decorated with `@handle_zvuk_errors(not_found_return=...)`. This maps Zvuk exceptions to MA exceptions (`LoginFailed`, `ResourceTemporarilyUnavailable`, etc.). Library mutation methods (like/unlike) catch errors and return `False` instead of raising.

**Caching**: Use `@use_cache(seconds)` decorator from `music_assistant.controllers.cache` on provider methods that fetch remote data. Library generators (`get_library_*`) are intentionally not cached — they're called during sync.

**Batch fetching**: The Zvuk API returns only IDs from collection/library endpoints. The provider pattern is: fetch IDs → chunk into `DEFAULT_LIMIT` (50) batches → fetch full objects. See `get_library_artists()` for the canonical example.

**Playlist track removal**: The Zvuk API has no "remove by ID" operation. `remove_playlist_tracks()` fetches all tracks, filters out the positions to remove, and calls `update_playlist()` with the remaining IDs.

**Simple vs Full objects**: Zvuk has `SimpleTrack`/`SimpleArtist`/`SimpleRelease`/`SimplePlaylist` types with fewer fields. Parsers accept both via union types (`ZvukTrack | ZvukSimpleTrack`). Use `hasattr()` to check for fields only on full objects (e.g. `position`, `genres`, `user_id`).

**Streaming quality fallback**: `get_stream_details()` tries FLAC → HIGH (320kbps) → MID (128kbps) when lossless is requested; HIGH → MID when high quality is requested. Falls back to `stream.get_best_available()` as a last resort.

**Test mocking**: Tests use `Mock()` objects with explicit attribute deletion (`del mock.attr`) to simulate fields absent on Simple* types. See `_create_mock_release()` with `del release.genres` in `tests/test_parsers.py`.

**Commit format**: Conventional Commits (`feat:`, `fix:`, `chore:`, `test:`) — used for auto-generating CHANGELOG.

**Branch naming**: `feature/<kebab-case>`, `fix/<kebab-case>`, `chore/<kebab-case>`. PRs target `dev` branch; `dev` → `main` for releases.

**Line length**: 100 characters (ruff). All public functions require PEP 257 docstrings.
