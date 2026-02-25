---
title: Similar Tracks (Radio Mode)
description: How radio mode and similar track lookup works in the Zvuk Music provider
---

When starting radio mode from any track, the provider finds similar tracks using the `release.related` field in the Zvuk API.

## How it works

1. MA requests similar tracks for the selected track
2. The provider fetches the full release (album) object the track belongs to
3. The `release.related` field contains a list of related releases from Zvuk
4. The provider iterates related releases and takes up to 2 tracks from each
5. Accumulates up to 25 tracks (default limit), duplicates are not added

## Where radio mode is used

| Location | Action |
|----------|--------|
| Track context menu | **Radio mode** — starts a queue of similar tracks |
| Any track in MA | Available regardless of source |

## Implementation details

- Uses Zvuk's `release.related` field — a native "related releases" field
- Recommendation quality depends on how thoroughly Zvuk fills this field for a given release
- If a release has no related releases or they're unavailable — returns an empty list
- Parse errors for individual tracks are skipped (logged as debug)

## Comparison with Yandex Music

Unlike Yandex Music (which uses a Rotor ML API for personalization), Zvuk implements similar tracks via `release.related` — a static related-releases field. Results are based on Zvuk metadata rather than personalization.
