"""Tests for lazy Zvuk recommendation rows."""

from __future__ import annotations

from typing import Any
from unittest.mock import AsyncMock, Mock

import pytest
from music_assistant_models.enums import ProviderFeature
from music_assistant_models.media_items import Playlist, UniqueList

from provider.provider import ZvukMusicProvider


def _playlist(item_id: str) -> Playlist:
    """Return a minimal playlist with a stable item ID."""
    playlist = Mock(spec=Playlist)
    playlist.item_id = item_id
    return playlist


def _provider() -> Any:
    """Create a provider mock bound to the real recommendation methods."""
    provider = Mock(spec=ZvukMusicProvider)
    provider.instance_id = "zvuk_music"
    provider.supported_features = {ProviderFeature.RECOMMENDATIONS}
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
    """Row discovery returns descriptors without loading their playlists."""
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
    """Loading one row leaves the other row's backend idle."""
    provider = _provider()

    items = await provider.get_recommendation_items(item_id)

    getattr(provider, called_helper).assert_awaited_once()
    getattr(provider, idle_helper).assert_not_awaited()
    assert isinstance(items, UniqueList)
    assert [item.item_id for item in items] == [expected_id]


@pytest.mark.asyncio
async def test_unknown_recommendation_row_is_empty_without_backend_calls() -> None:
    """Unknown row IDs produce an empty result without backend traffic."""
    provider = _provider()

    items = await provider.get_recommendation_items("unknown")

    provider._get_for_you_playlists.assert_not_awaited()
    provider._get_editorial_playlists.assert_not_awaited()
    assert isinstance(items, UniqueList)
    assert not items
