---
title: Zvuk Music Provider
description: Documentation for the Zvuk Music provider for Music Assistant
---

# Zvuk Music Provider

Music Assistant supports [Zvuk Music](https://zvuk.com) — a Russian music streaming service.
Contributed and maintained by [TrudenBoy](https://github.com/TrudenBoy).

Built on top of the [zvuk-music](https://github.com/sashkent3/zvuk-music) library (unofficial Zvuk Music API client).

:::note[Subscription]
Lossless FLAC quality requires a Zvuk Music subscription. Free accounts can stream at up to 320 kbps.
:::

## Features

|  |  |
|:------------------------|:---------------------:|
| Subscription FREE | Yes (with limitations) |
| Self-Hosted Local Media | No |
| Media Types Supported | Artists, Albums, Tracks, Playlists |
| [Recommendations](/ui/#view-home) Supported | Yes |
| Lyrics Supported | Yes |
| [Radio Mode](/ui/#track-menu) | Yes |
| Maximum Stream Quality | Lossless FLAC (with subscription) |
| Login Method | Token (X-Auth-Token) |

### Other

- Searching the Zvuk Music catalogue is possible
- Items in a user's Zvuk Music library will be synced to Music Assistant
- Adding/removing items in MA will sync back to Zvuk Music (bidirectional sync)
- Browse is available to explore the Zvuk Music catalogue
- Personalized recommendations are shown on the MA home screen
- Similar Tracks / Radio Mode supported
- Artist top tracks and discography supported

## Configuration

A Zvuk Music X-Auth-Token is required to connect the provider.

Token acquisition instructions and full settings reference: [Configuration](/ma-provider-zvuk-music/en/configuration/).

## Known Issues

- The OAuth token may expire and require re-authentication
- Multiple Zvuk Music accounts cannot be added simultaneously

Full list: [Known Issues](/ma-provider-zvuk-music/en/known-issues/).
