---
title: Audio Quality
description: Streaming quality options for the Zvuk Music provider
---

The provider supports two quality levels with automatic fallback.

## Quality options

| Value | Format | Bitrate | Requirements |
|-------|--------|---------|--------------|
| `high` | MP3 | 320 kbps | Any account |
| `lossless` | FLAC | Lossless | Zvuk Music subscription |

## Stream selection logic

When a track is requested for playback, the provider tries quality options in descending order:

**With `lossless` setting:**
1. Try FLAC (`lossless`)
2. If unavailable → try MP3 320 (`high`)
3. If unavailable → try MP3 128 (`mid`)
4. Last resort → `stream.get_best_available()`

**With `high` setting:**
1. Try MP3 320 (`high`)
2. If unavailable → try MP3 128 (`mid`)
3. Last resort → `stream.get_best_available()`

## Notes

:::note[has_flac field]
The Zvuk API returns a `has_flac` field for tracks, but in practice it doesn't always reliably reflect real FLAC availability. Therefore the provider always tries FLAC first when `lossless` is selected — regardless of the field value. The field is used for diagnostic logging only.
:::

- The selected stream is logged with format and bitrate
- If no stream variant is available — MA receives a `MediaNotFoundError`
