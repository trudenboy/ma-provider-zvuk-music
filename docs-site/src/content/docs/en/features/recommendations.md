---
title: Recommendations
description: Personalized and editorial playlist recommendations from Zvuk Music
---

Zvuk Music provides two types of recommended playlists on the Music Assistant home screen.

## How it works

Recommendations appear on the **MA home screen** (Discover). The provider returns two groups:

### For You (Плейлисты для вас)

**API:** Zvuk synthesis playlists (fixed set of IDs)

- Generated algorithmically based on your listening history
- Updated automatically by Zvuk — MA reflects the current state
- Only shown when playlists are available

### Editorial Picks (Подборки)

**API:** editorial playlists (`/api3/playlist/?ids=...`)

- Curated by the Zvuk Music editorial team by genre and theme
- Up to 50 editorial playlists
- Only shown when playlists are available

## Where recommendations appear

| Location | Description |
|----------|-------------|
| Home (Discover) | Two groups of playlists on the MA home screen |

## Notes

- Recommendations depend on your Zvuk Music listening history
- Editorial picks are the same for all users
- If both groups are empty, the recommendations section is not shown
