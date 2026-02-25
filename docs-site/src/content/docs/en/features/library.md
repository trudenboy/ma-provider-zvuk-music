---
title: Library & Sync
description: Bidirectional library synchronization between Zvuk Music and Music Assistant
---

The provider syncs the user's library between Zvuk Music and Music Assistant in both directions.

## What's synced

| Type | Zvuk → MA | MA → Zvuk |
|------|:---------:|:---------:|
| Tracks | ✅ | ✅ |
| Albums | ✅ | ✅ |
| Artists | ✅ | ✅ |
| Playlists | ✅ | ✅ |

## How sync works

### Zvuk → MA (library load)

On first connect and on every MA library refresh:

1. The provider fetches the user's collection: lists of track, album, artist, playlist IDs
2. IDs are split into batches of 50 (API limit)
3. Full data is fetched for each batch
4. Objects are parsed and added to the MA library

### MA → Zvuk (add/remove)

| Action in MA | What happens in Zvuk |
|--------------|----------------------|
| Add track to library | `like_track()` |
| Remove track | `unlike_track()` |
| Add album | `like_release()` |
| Remove album | `unlike_release()` |
| Add artist | `like_artist()` |
| Remove artist | `unlike_artist()` |
| Add playlist | `like_playlist()` |
| Remove playlist | `unlike_playlist()` |

## Playlist management

Beyond sync, full playlist management is supported:

| Operation | Support |
|-----------|:-------:|
| Create playlist | ✅ |
| Add tracks to playlist | ✅ |
| Remove tracks from playlist | ✅ |

:::note[Track removal from playlists]
The Zvuk API does not support removing tracks by ID. The provider works around this: fetches all playlist tracks, excludes the target positions, then updates the full playlist with the remaining IDs.
:::

## Notes

- Errors on library add/remove return `False` instead of raising (don't interrupt MA)
- Library sync is not cached — each MA request returns fresh data from Zvuk
