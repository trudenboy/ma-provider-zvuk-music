---
title: Lyrics
description: Synced and plain text lyrics from Zvuk Music
---

Lyrics are fetched directly from Zvuk Music when viewing track details.

## Lyrics types

| Type | Description |
|------|-------------|
| **Synced (LRC)** | With timestamps for subtitle-style display, when available |
| **Plain text** | Used as fallback when synced lyrics are not available |

## How it works

1. MA requests track metadata via `ProviderFeature.TRACK_METADATA`
2. The provider calls the Zvuk lyrics API (`/api3/lyrics/`)
3. If the API returns type `subtitle` — stored as LRC (synced)
4. Otherwise — stored as plain text
5. If the API returns an error or empty text — metadata is returned without lyrics (no error)

## Caching

Lyrics are cached together with track data:
- Repeated requests for the same track don't hit the API again
- Cache is invalidated on MA library refresh

## Notes

:::note
Lyrics availability depends on the track and may vary by region due to licensing restrictions. If lyrics are unavailable, the provider handles this silently — without errors.
:::
