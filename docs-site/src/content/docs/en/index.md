---
title: Zvuk Music Provider
description: Documentation for the Zvuk Music provider for Music Assistant
---

<img src="/ma-provider-zvuk-music/zvuk-icon.svg" alt="Zvuk Music" style="width: 64px; float: right; margin: 0 0 1rem 1.5rem;" />

[Music Assistant](https://music-assistant.io) supports [Zvuk Music](https://zvuk.com) — a Russian music streaming service.
Contributed and maintained by [TrudenBoy](https://github.com/TrudenBoy).

Built on top of the [zvuk-music](https://github.com/sashkent3/zvuk-music) library (unofficial Zvuk Music API client).

:::caution[Disclaimer]
This is an **unofficial** implementation with no affiliation to [Zvuk](https://zvuk.com) or its owners.
:::

:::note[Subscription]
Lossless FLAC quality requires a Zvuk Music subscription. Free accounts can stream at up to 320 kbps.
:::

## Features

| Feature | Support |
|:--------|:-------:|
| Artists, Albums, Tracks, Playlists | ✅ |
| Catalogue search | ✅ |
| Library sync (bidirectional) | ✅ |
| [Recommendations](/ma-provider-zvuk-music/en/features/recommendations/) | ✅ |
| [Lyrics](/ma-provider-zvuk-music/en/features/lyrics/) | ✅ |
| [Similar Tracks / Radio Mode](/ma-provider-zvuk-music/en/features/similar-tracks/) | ✅ |
| Browse catalogue | ✅ |
| Playlist management (create, add, remove tracks) | ✅ |
| Maximum quality | Lossless FLAC (with subscription) |
| Login method | Token (X-Auth-Token) |

Detailed description of each feature — in the **Features** section in the sidebar.

## Configuration

A Zvuk Music X-Auth-Token is required to connect the provider.

Token acquisition instructions and full settings reference: [Configuration](/ma-provider-zvuk-music/en/configuration/).

## Known Issues

- The OAuth token may expire and require re-authentication
- Multiple Zvuk Music accounts cannot be added simultaneously

Full list: [Known Issues](/ma-provider-zvuk-music/en/known-issues/).
