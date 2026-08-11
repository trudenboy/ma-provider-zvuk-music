# Consolidated Upstream Migrations Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Port upstream Music Assistant PRs 4487, 5053, and 5058 into the standalone Zvuk Music provider as one tested, conflict-free change.

**Architecture:** A new `setup_flow.py` owns collection of the secret token, while the provider instance exposes only post-install options and reads authentication through `get_setup_value`. Recommendations are split into static row discovery and row-specific loading, reusing the existing private playlist helpers and browse behavior.

**Tech Stack:** Python 3.12+, Music Assistant provider APIs, `music-assistant-models`, pytest/pytest-asyncio, Ruff, mypy, pre-commit.

## Global Constraints

- Base all work on `origin/dev` in `codex/consolidated-upstream-migrations`.
- Preserve the original dirty `dev` checkout unchanged.
- Follow red-green-refactor TDD for every production behavior change.
- Keep private provider methods at the bottom of the class.
- Keep setup secrets out of provider options, logs, and exceptions.
- Preserve existing installations through `get_setup_value`, whose base implementation falls back to legacy config values.
- Do not edit generated policy/lint files or `VERSION`.
- Do not publish, merge, close, or comment on PRs.

---

### Task 1: Setup wizard, token storage, and authentication copy

**Files:**
- Create: `provider/setup_flow.py`
- Create: `tests/test_setup_flow.py`
- Modify: `provider/__init__.py`
- Modify: `provider/constants.py`
- Modify: `provider/provider.py:5-75,526-570`
- Modify: `provider/strings.json`

**Interfaces:**
- Consumes: `SetupSession.form`, `SetupSession.finish`, `SetupFlowError`, and `MusicProvider.get_setup_value(key, default=None)`.
- Produces: `run_setup(session: SetupSession) -> None`, `ZvukMusicProvider.get_config_entries() -> tuple[ConfigEntry, ...]`, and provider initialization backed by `CONF_TOKEN` setup data.

- [ ] **Step 1: Write failing setup-flow tests**

Create `tests/test_setup_flow.py` with tests that call the real setup coroutine and provider methods:

```python
from __future__ import annotations

import json
from pathlib import Path
from types import SimpleNamespace
from typing import Any
from unittest.mock import AsyncMock, Mock, patch

import pytest
from music_assistant_models.enums import ConfigEntryType

from music_assistant.models.setup_flow import SetupFlowError

from provider.constants import CONF_QUALITY, CONF_TOKEN
from provider.provider import ZvukMusicProvider
from provider.setup_flow import run_setup


def _make_session(*, setup_data: dict[str, Any] | None = None) -> Any:
    session = Mock()
    session.context = SimpleNamespace(setup_data=setup_data or {})
    session.form = AsyncMock()
    session.finish = AsyncMock()
    return session


class _ImageResponse:
    status = 200

    async def read(self) -> bytes:
        return b"image"

    async def __aenter__(self) -> _ImageResponse:
        return self

    async def __aexit__(self, *args: object) -> None:
        return None


@pytest.mark.asyncio
async def test_run_setup_finishes_with_submitted_token() -> None:
    session = _make_session()
    session.form.return_value = {CONF_TOKEN: "fresh-token"}

    await run_setup(session)

    entries = session.form.await_args.args[0]
    assert [entry.key for entry in entries][-1] == CONF_TOKEN
    assert entries[-1].type == ConfigEntryType.SECURE_STRING
    session.finish.assert_awaited_once_with({CONF_TOKEN: "fresh-token"})


@pytest.mark.asyncio
async def test_run_setup_retries_with_preserved_token_after_validation_error() -> None:
    session = _make_session()
    session.form.side_effect = [
        {CONF_TOKEN: "rejected-token"},
        {CONF_TOKEN: "replacement-token"},
    ]
    session.finish.side_effect = [
        SetupFlowError("Rejected", translation_key="login_failed"),
        None,
    ]

    await run_setup(session)

    second_entries = session.form.await_args_list[1].args[0]
    assert second_entries[-1].value == "rejected-token"
    assert session.form.await_args_list[1].kwargs["errors"] == {"base": "login_failed"}
    assert session.finish.await_args_list[-1].args[0] == {CONF_TOKEN: "replacement-token"}


@pytest.mark.asyncio
async def test_provider_options_expose_quality_but_not_token() -> None:
    provider = Mock(spec=ZvukMusicProvider)
    provider.get_config_entries = ZvukMusicProvider.get_config_entries.__get__(
        provider, ZvukMusicProvider
    )

    entries = await provider.get_config_entries()

    keys = {entry.key for entry in entries}
    assert CONF_QUALITY in keys
    assert CONF_TOKEN not in keys


@pytest.mark.asyncio
async def test_provider_initialization_uses_setup_token() -> None:
    provider = Mock(spec=ZvukMusicProvider)
    provider.get_setup_value = Mock(return_value="setup-token")
    provider.logger = Mock()
    provider.handle_async_init = ZvukMusicProvider.handle_async_init.__get__(
        provider, ZvukMusicProvider
    )
    client = Mock()
    client.connect = AsyncMock()

    with patch("provider.provider.ZvukMusicClient", return_value=client) as client_cls:
        await provider.handle_async_init()

    provider.get_setup_value.assert_called_once_with(CONF_TOKEN)
    client_cls.assert_called_once_with("setup-token")
    client.connect.assert_awaited_once()


@pytest.mark.asyncio
async def test_image_resolution_uses_setup_token() -> None:
    provider = Mock(spec=ZvukMusicProvider)
    provider.get_setup_value = Mock(return_value="setup-token")
    provider.mass = Mock()
    provider.mass.http_session.get = Mock(return_value=_ImageResponse())
    provider.logger = Mock()
    provider.resolve_image = ZvukMusicProvider.resolve_image.__get__(provider, ZvukMusicProvider)

    result = await provider.resolve_image("https://zvuk.com/cover.jpg")

    assert result == b"image"
    provider.get_setup_value.assert_called_once_with(CONF_TOKEN)
    headers = provider.mass.http_session.get.call_args.kwargs["headers"]
    assert headers["X-Auth-Token"] == "setup-token"


def test_strings_define_setup_flow_and_token_specific_login_error() -> None:
    strings = json.loads(Path("provider/strings.json").read_text())

    assert strings["setup_flow"]["user"]["title"] == "Connect to Zvuk"
    assert "X-Auth-Token" in strings["errors"]["login_failed"]
    assert "clear_auth" not in strings["config_entries"]
```

- [ ] **Step 2: Run the new tests and verify RED**

Run:

```bash
UV_CACHE_DIR=/tmp/ma-provider-zvuk-uv-cache uv run pytest tests/test_setup_flow.py -q
```

Expected: collection fails because `provider.setup_flow` and the instance-level `get_config_entries` method do not exist. If dependency setup is blocked, run `UV_CACHE_DIR=/tmp/ma-provider-zvuk-uv-cache uv sync --extra test --locked` with approved network access, then repeat.

- [ ] **Step 3: Implement the setup flow**

Create `provider/setup_flow.py`:

```python
"""Setup flow for the Zvuk Music provider."""

from __future__ import annotations

from dataclasses import replace
from typing import TYPE_CHECKING

from music_assistant_models.config_entries import ConfigEntry
from music_assistant_models.enums import ConfigEntryType

from music_assistant.constants import CONF_ENTRY_UNOFFICIAL_PROVIDER
from music_assistant.models.setup_flow import SetupFlowError

from .constants import CONF_TOKEN

if TYPE_CHECKING:
    from music_assistant.models.setup_flow import SetupSession

_ENTRIES = (
    CONF_ENTRY_UNOFFICIAL_PROVIDER,
    ConfigEntry(key=CONF_TOKEN, type=ConfigEntryType.SECURE_STRING, required=True),
)


async def run_setup(session: SetupSession) -> None:
    """Run the setup flow and persist the submitted Zvuk token."""
    errors: dict[str, str] | None = None
    setup_data = dict(session.context.setup_data)
    while True:
        entries = [
            replace(entry, value=setup_data.get(entry.key, entry.value)) for entry in _ENTRIES
        ]
        submitted = await session.form(entries, step_id="user", errors=errors, last_step=True)
        setup_data.update(submitted)
        try:
            await session.finish(setup_data)
            return
        except SetupFlowError as err:
            errors = {"base": err.translation_key or str(err)}
```

- [ ] **Step 4: Move configuration ownership to the provider instance**

In `provider/__init__.py`, remove the module-level `get_config_entries` function and its config-entry imports. In `provider/constants.py`, remove `CONF_ACTION_CLEAR_AUTH`.

Add these imports and method to `provider/provider.py` before `handle_async_init`:

```python
from music_assistant_models.config_entries import ConfigEntry, ConfigValueOption
from music_assistant_models.enums import ConfigEntryType
from music_assistant.constants import CONF_ENTRY_UNOFFICIAL_PROVIDER

async def get_config_entries(self) -> tuple[ConfigEntry, ...]:
    """Return config entries for provider options."""
    return (
        CONF_ENTRY_UNOFFICIAL_PROVIDER,
        ConfigEntry(
            key=CONF_QUALITY,
            type=ConfigEntryType.STRING,
            options=[ConfigValueOption(QUALITY_HIGH), ConfigValueOption(QUALITY_LOSSLESS)],
            default_value=QUALITY_HIGH,
        ),
    )
```

Import `QUALITY_HIGH`, then replace both authentication reads in `handle_async_init` and `resolve_image`:

```python
token = self.get_setup_value(CONF_TOKEN)
```

The base method's fallback to active config values is the compatibility path for existing installations.

- [ ] **Step 5: Add setup and error translations**

Update `provider/strings.json` by removing `config_entries.clear_auth` and adding:

```json
"setup_flow": {
  "user": {
    "title": "Connect to Zvuk",
    "description": "Music Assistant needs your personal Zvuk X-Auth-Token to reach your account and library."
  }
},
"errors": {
  "login_failed": "Could not sign in to Zvuk Music with this token. See the documentation for how to obtain a fresh X-Auth-Token."
}
```

- [ ] **Step 6: Run focused setup tests and verify GREEN**

Run:

```bash
UV_CACHE_DIR=/tmp/ma-provider-zvuk-uv-cache uv run pytest tests/test_setup_flow.py tests/test_api_client.py -q
```

Expected: all selected tests pass with no warnings.

- [ ] **Step 7: Commit the setup migration**

```bash
git add provider/__init__.py provider/constants.py provider/provider.py provider/setup_flow.py provider/strings.json tests/test_setup_flow.py
git commit -m "fix: add token setup flow"
```

---

### Task 2: Lazy recommendation rows

**Files:**
- Create: `tests/test_recommendations.py`
- Modify: `tests/test_provider_browse.py:1-175`
- Modify: `provider/provider.py:17-30,403-444`

**Interfaces:**
- Consumes: existing `_get_for_you_playlists()` and `_get_editorial_playlists()` helpers.
- Produces: `get_recommendations() -> list[RecommendationFolder]` and `get_recommendation_items(item_id: str) -> UniqueList[MediaItemType | ItemMapping | BrowseFolder]`.

- [ ] **Step 1: Write failing tests for the two-method contract**

Move recommendation coverage out of `tests/test_provider_browse.py` and create `tests/test_recommendations.py`:

```python
"""Tests for lazy Zvuk recommendation rows."""

from __future__ import annotations

from typing import Any
from unittest.mock import AsyncMock, Mock

import pytest
from music_assistant_models.media_items import Playlist, UniqueList

from provider.provider import ZvukMusicProvider


def _playlist(item_id: str) -> Playlist:
    playlist = Mock(spec=Playlist)
    playlist.item_id = item_id
    return playlist


def _provider() -> Any:
    provider = Mock(spec=ZvukMusicProvider)
    provider.instance_id = "zvuk_music"
    provider._get_for_you_playlists = AsyncMock(return_value=[_playlist("3")])
    provider._get_editorial_playlists = AsyncMock(return_value=[_playlist("99")])
    provider.get_recommendations = ZvukMusicProvider.get_recommendations.__get__(
        provider, ZvukMusicProvider
    )
    provider.get_recommendation_items = ZvukMusicProvider.get_recommendation_items.__get__(
        provider, ZvukMusicProvider
    )
    return provider


@pytest.mark.asyncio
async def test_recommendation_rows_are_static_and_do_not_fetch_items() -> None:
    provider = _provider()

    rows = await provider.get_recommendations()

    provider._get_for_you_playlists.assert_not_awaited()
    provider._get_editorial_playlists.assert_not_awaited()
    assert [row.item_id for row in rows] == ["for_you", "editorial"]
    assert all(len(row.items) == 0 for row in rows)


@pytest.mark.asyncio
@pytest.mark.parametrize(
    ("item_id", "expected_id", "called_helper", "idle_helper"),
    [
        ("for_you", "3", "_get_for_you_playlists", "_get_editorial_playlists"),
        ("editorial", "99", "_get_editorial_playlists", "_get_for_you_playlists"),
    ],
)
async def test_recommendation_items_fetch_only_requested_row(
    item_id: str, expected_id: str, called_helper: str, idle_helper: str
) -> None:
    provider = _provider()

    items = await provider.get_recommendation_items(item_id)

    getattr(provider, called_helper).assert_awaited_once()
    getattr(provider, idle_helper).assert_not_awaited()
    assert isinstance(items, UniqueList)
    assert [item.item_id for item in items] == [expected_id]


@pytest.mark.asyncio
async def test_unknown_recommendation_row_is_empty_without_backend_calls() -> None:
    provider = _provider()

    items = await provider.get_recommendation_items("unknown")

    provider._get_for_you_playlists.assert_not_awaited()
    provider._get_editorial_playlists.assert_not_awaited()
    assert isinstance(items, UniqueList)
    assert not items
```

Delete the obsolete `TestRecommendations` class and the `recommendations` binding/import from `tests/test_provider_browse.py`. Retain every browse and playlist-management test.

- [ ] **Step 2: Run recommendation tests and verify RED**

Run:

```bash
UV_CACHE_DIR=/tmp/ma-provider-zvuk-uv-cache uv run pytest tests/test_recommendations.py -q
```

Expected: collection or execution fails because `get_recommendations`, `get_recommendation_items`, and `UniqueList` integration do not yet exist.

- [ ] **Step 3: Implement static row discovery and item loading**

Import `UniqueList` from `music_assistant_models.media_items`, replace the old `recommendations()` method with:

```python
async def get_recommendations(self) -> list[RecommendationFolder]:
    """Return the available recommendation rows without loading their items."""
    return [
        RecommendationFolder(
            item_id="for_you",
            provider=self.instance_id,
            name="Made for you",
            translation_key="made_for_you",
            icon="mdi-playlist-music",
        ),
        RecommendationFolder(
            item_id="editorial",
            provider=self.instance_id,
            name="Collections",
            subtitle="Editorial playlists from Zvuk by genre",
            translation_key="editorial",
            icon="mdi-music-box-multiple",
        ),
    ]

async def get_recommendation_items(
    self, item_id: str
) -> UniqueList[MediaItemType | ItemMapping | BrowseFolder]:
    """Return items for one recommendation row."""
    if item_id == "for_you":
        return UniqueList(await self._get_for_you_playlists())
    if item_id == "editorial":
        return UniqueList(await self._get_editorial_playlists())
    return UniqueList()
```

Do not move or duplicate the private helpers; they already reside at the bottom of the class.

- [ ] **Step 4: Run recommendation and browse tests and verify GREEN**

Run:

```bash
UV_CACHE_DIR=/tmp/ma-provider-zvuk-uv-cache uv run pytest tests/test_recommendations.py tests/test_provider_browse.py -q
```

Expected: all selected tests pass; browse still returns the same paths and playlists.

- [ ] **Step 5: Commit lazy recommendations**

```bash
git add provider/provider.py tests/test_provider_browse.py tests/test_recommendations.py
git commit -m "feat: load recommendation rows on demand"
```

---

### Task 3: Feature specification and release notes

**Files:**
- Create: `specs/done/0001-lazy-recommendations-and-setup.md`
- Modify: `CHANGELOG.md`

**Interfaces:**
- Consumes: completed behavior from Tasks 1 and 2.
- Produces: reviewer-facing acceptance criteria, sequence diagram, test plan, and release notes for version `1.8.4` without changing `VERSION`.

- [ ] **Step 1: Write the completed feature specification**

Create a size-M spec with frontmatter:

```yaml
---
id: "0001"
title: "Setup wizard and lazy recommendations"
size: M
status: done
priority: P0
effort_minutes: 20
feature_id: RECOMMENDATIONS
---
```

The body must state the user-observable setup failure and eager Discover loading problem, list at least these five falsifiable acceptance criteria, include a Mermaid sequence diagram, and name the focused tests:

1. A new installation asks for a required X-Auth-Token before creation.
2. Invalid setup tokens re-render the form with the previous input and a localized error.
3. Existing configuration-backed tokens continue to load through the setup-value fallback.
4. Discover row discovery performs no Zvuk API requests.
5. Each recommendation row loads only its own playlists.
6. Browse paths and contents remain unchanged.

- [ ] **Step 2: Add canonical changelog entries**

Insert above `1.8.3`:

```markdown
## [1.8.4] - 2026-08-11

### Added

- Added a guided setup step that collects the required Zvuk X-Auth-Token before connecting the provider.

### Changed

- Recommendation rows now load their playlists only when Music Assistant requests that row.

### Fixed

- New provider instances can be configured through the current Music Assistant setup flow, and rejected tokens now show a Zvuk-specific sign-in message.
```

- [ ] **Step 3: Validate documentation structure**

Run:

```bash
python3 -c 'from pathlib import Path; text = Path("CHANGELOG.md").read_text(); assert "## [1.8.4] - 2026-08-11\n\n### Added\n" in text; assert text.index("### Added") < text.index("### Changed") < text.index("### Fixed")'
rg -n "TBD|TODO|_TODO|<<<<<<<|=======|>>>>>>>" specs/done CHANGELOG.md provider tests
git diff --check
```

Expected: changelog lint succeeds, the scan finds no placeholders/conflict markers, and diff check is clean.

- [ ] **Step 4: Commit documentation**

```bash
git add specs/done/0001-lazy-recommendations-and-setup.md CHANGELOG.md
git commit -m "docs: document consolidated upstream migrations"
```

---

### Task 4: Full verification and self-review

**Files:**
- Modify only if verification reveals a defect directly caused by Tasks 1-3.

**Interfaces:**
- Consumes: all implementation and documentation commits.
- Produces: evidence that the consolidated branch satisfies repository and upstream gates.

- [ ] **Step 1: Run the complete unit suite**

```bash
UV_CACHE_DIR=/tmp/ma-provider-zvuk-uv-cache uv run pytest -q
```

Expected: all tests pass with zero failures.

- [ ] **Step 2: Run formatter, lint, and typing checks**

```bash
UV_CACHE_DIR=/tmp/ma-provider-zvuk-uv-cache uv run ruff format --check provider tests
UV_CACHE_DIR=/tmp/ma-provider-zvuk-uv-cache uv run ruff check provider tests
UV_CACHE_DIR=/tmp/ma-provider-zvuk-uv-cache uv run mypy provider tests
```

Expected: every command exits 0.

- [ ] **Step 3: Run the repository gate**

```bash
UV_CACHE_DIR=/tmp/ma-provider-zvuk-uv-cache uv run pre-commit run --all-files
```

Expected: every hook passes.

- [ ] **Step 4: Review the complete branch diff**

```bash
git diff --check origin/dev...HEAD
git diff --stat origin/dev...HEAD
git diff origin/dev...HEAD -- provider tests specs CHANGELOG.md docs/superpowers
git status -sb
```

Confirm manually that:

- no token value can reach logs or errors;
- no conflict marker, reverse-sync stub, or legacy clear-auth path remains;
- recommendation row discovery makes no backend call;
- private methods remain at the bottom of `ZvukMusicProvider`;
- `VERSION`, generated policy files, and the original checkout are unchanged.

- [ ] **Step 5: Commit any verification-only corrections**

If and only if Steps 1-4 required corrections, stage only those explicit files and commit:

```bash
git add provider/__init__.py provider/constants.py provider/provider.py provider/setup_flow.py provider/strings.json tests/test_setup_flow.py tests/test_provider_browse.py tests/test_recommendations.py specs/done/0001-lazy-recommendations-and-setup.md CHANGELOG.md
git commit -m "fix: address consolidated migration verification"
```

If no corrections were required, do not create an empty commit.
