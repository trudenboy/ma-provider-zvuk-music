---
title: Search
description: Searching the Zvuk Music catalogue through Music Assistant
---

The provider supports full-text search across the Zvuk Music catalogue.

## What's searchable

| Type | Support |
|------|:-------:|
| Tracks | ✅ |
| Albums | ✅ |
| Artists | ✅ |
| Playlists | ✅ |

## How it works

1. MA passes the search query and media types to the provider
2. A separate API request is made for each requested media type
3. Results are parsed and returned to MA
4. Up to 5 results per type (default limit)

## Notes

- Search covers the entire Zvuk catalogue — not just your personal library
- Requests are executed in parallel for each media type
- If MA doesn't specify a type — all supported types are searched
