# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.8.1] - 2026-03-18

- fix: add zvuk-music[async]==0.6.1 to project dependencies for CI (`c2f6137`)
- feat: upgrade zvuk-music to 0.6.1, replace private _request access (`8560fae`)
- test: remove http_session from ZvukMusicClient instantiation in tests (`13a6b31`)
- fix: remove unused http_session parameter from ZvukMusicClient (`848cfc9`)
- fix: make create_playlist media_types optional for base class compatibility (`201fcc6`)
- fix: match create_playlist signature with updated MusicProvider base class (`a616d90`)
- test: update library playlist test to reflect new synthesis-always-yielded behavior (`2a121fb`)
- fix: address PR review comments on library playlists and lyrics error handling (`31ed17a`)
- chore: sync workflow wrappers from ma-provider-tools (#78) (`d689eb5`)
- chore: reformat CHANGELOG — use commit history instead of PR notes [skip ci] (`ad640cd`)
- chore: reformat CHANGELOG — marker to top, releases newest-first [skip ci] (`26fc3b8`)
- chore: reformat CHANGELOG — marker to top, releases newest-first [skip ci] (`c9c6250`)
- fix: let ResourceTemporarilyUnavailable propagate from quality chain in get_stream_details (`fa96f66`)
- chore: update changelog for v1.7.0 [skip ci] (`cee247b`)

---

<!-- changelog entries will be added here by release workflow -->

## [1.7.0] - 2026-02-26

- fix(tests): use cast to avoid type: ignore in test_lyrics (#61) (`4f53e76`)
- chore: sync workflow wrappers from ma-provider-tools (#62) (`556c584`)
- fix(tests): use music_assistant.providers.zvuk_music imports, add upstream CI script (#63) (`2ac367e`)
- fix: address PR #3242 Copilot review comments (#64) (`44c06ac`)
- fix(parsers): use isinstance check for playlist image src to avoid Mock iteration error (#65) (`b1dd1ae`)
- fix(security,api_client): decouple _request, validate resolve_image domain (#66) (`28cd6ff`)
- test(stream_details): update TestGetDirectStreamUrl mocks for _tiny_get (#67) (`1231fd0`)
- fix(api_client): use shared http_session instead of per-call aiohttp.ClientSession (#68) (`2a0f8d4`)
- fix: remove unused type: ignore[attr-defined] comments in test_stream_details (#69) (`95330c0`)
- fix(provider): clarify has_flac is diagnostic-only in get_stream_details (`1e55a19`)
- chore: migrate docs from MkDocs to Astro Starlight (#70) (`8c64ef5`)
- chore: migrate docs to Astro Starlight + align with Yandex Music format (#71) (`c90842e`)
- docs: add dedicated Features section (#72) (`eb01694`)
- fix: remove duplicate heading on index pages, add Zvuk Music icon (#73) (`32a67ee`)
- feat(browse): implement browse method and add docs pages (RU+EN) (`de9b66f`)
- chore: sync workflow wrappers from ma-provider-tools (`99f20bc`)
- docs: add Starlight title frontmatter to contributing.md (`f984cf5`)
- chore: sync workflow wrappers from ma-provider-tools (#76) (`c191607`)
- docs: add provider icon emblem to index page (`2f1731b`)
- docs: add user documentation link to README (`ef3d34c`)
- fix(docs): remove duplicate logo from homepage (`69adb92`)
- docs: add library link and unofficial disclaimer to homepage (RU+EN) (`0a20e7d`)
- docs: shorten disclaimer on homepage (`6763072`)
- docs(en): translate remaining stub pages to English (`3102634`)
- docs: make Music Assistant a link to music-assistant.io on homepage (`9c8e892`)
- Revise disclaimer and subscription details in index.md (`94d1f59`)
- Revise Zvuk Music provider details and disclaimer (`097754c`)
- fix: use zvuk_music library request for stream URLs to avoid bot detection (`b822d86`)
- fix: add cdn-image.zvuk.com to trusted image hosts (`1075497`)
- fix: fix editorial playlists (Подборки) not appearing on home screen (`31c9314`)
- fix: use library request in get_lyrics to avoid HTTP 418 bot detection (`0db74d8`)
- refactor: fix bugs found in code review (B1-B5) (`cbfad88`)
- refactor: architectural improvements from code review (A1-A4) (`54bf161`)
- test: add comprehensive test coverage (T1-T3) (`0932742`)
- chore: fix trailing whitespace in docs index (`d395fbd`)
- fix(tests): fix mypy errors caught by upstream MA server CI (`9c48f4a`)
- chore: sync mypy config with upstream and fix resulting warnings (`a8942ed`)
- fix: force square ?size= param for images without existing size query (`b62a35f`)
- chore: sync ruff/mypy config with upstream and fix upstream CI failures (`d7bf4c4`)
- test(parsers): expect ?size=WxH suffix in image URL assertions (`b1de5b7`)
- fix(provider): allow *.sbercloud.ru in resolve_image trusted hosts (`83e98aa`)
- test: fix mypy method-assign errors in test helpers (`afb4e08`)
- test: replace setattr with direct assignment (ruff B010) (`1414c94`)
- chore: remove obsolete B010 per-file-ignores from ruff.toml (`fe034bd`)
- fix(parsers): remap subtype=secondImage to cover_background in image URLs (`5d5591d`)
- fix: address Copilot review comments on PR #3242 (`8266559`)
- feat: add Throttler to ZvukMusicClient (5 req/s) (`541a24d`)
- feat: add _is_rate_limit_error() and _get_client() to ZvukMusicClient (`f781b48`)
- feat: raise ResourceTemporarilyUnavailable(backoff_time=60) on 429 in handle_zvuk_errors (`cce7621`)
- refactor: use await self._get_client() in all @handle_zvuk_errors methods (`27b253c`)

---

## [1.6.0] - 2026-02-25

- docs: extend DEVELOPMENT.md with day-to-day workflow, troubleshooting, E2E checklist (`29d3db6`)
- fix: use setuptools.build_meta backend (compatible with setuptools<77) (`5418fa9`)
- chore: sync workflow wrappers from ma-provider-tools (`5cd4a6f`)
- chore: sync workflow wrappers from ma-provider-tools (`e16ee1f`)
- chore: sync workflow wrappers from ma-provider-tools (#4) (`37aba81`)
- chore: sync workflow wrappers from ma-provider-tools (#5) (`4ac8ad5`)
- chore: sync workflow wrappers from ma-provider-tools (#6) (`7410678`)
- chore: sync workflow wrappers from ma-provider-tools (#7) (`d3eb698`)
- chore: sync workflow wrappers from ma-provider-tools (`d861c57`)
- docs: unify documentation structure (#9) (`5697588`)
- chore: sync workflow wrappers from ma-provider-tools (#10) (`9b7b785`)
- test: add minimal reusable workflow test (`412501e`)
- test: call minimal hello reusable workflow (`160ab29`)
- chore: sync workflow wrappers from ma-provider-tools (#11) (`d7c75dc`)
- chore: sync workflow wrappers from ma-provider-tools (#14) (`f4c91a5`)
- fix: remove music-assistant-models pin to resolve CI dependency conflict (`c18234c`)
- chore: sync workflow wrappers from ma-provider-tools (#19) (`f0af6c3`)
- chore: sync workflow wrappers from ma-provider-tools (#20) (`d145030`)
- chore: sync workflow wrappers from ma-provider-tools (`d24f5d1`)
- Initial plan (`03b8d14`)
- fix: replace if-exp with or-operator (FURB110) in parsers.py (`e28fc5d`)
- chore: sync workflow wrappers from ma-provider-tools (`32628ea`)
- chore: sync workflow wrappers from ma-provider-tools (`f030313`)
- chore: sync workflow wrappers from ma-provider-tools (`f16781a`)
- chore: sync workflow wrappers from ma-provider-tools (`9a3309c`)
- docs: add testing, incident-management, dev-docker links to README (`a32035d`)
- Initial plan (`6ee41a2`)
- fix: remove extra trailing newlines from docs files (`14a1e7b`)
- chore: sync workflow wrappers from ma-provider-tools (`1d033d1`)
- chore: sync workflow wrappers from ma-provider-tools (#32) (`64f67a5`)
- chore: sync workflow wrappers from ma-provider-tools (#33) (`488cda0`)
- chore: sync workflow wrappers from ma-provider-tools (#35) (`e92771d`)
- chore: sync workflow wrappers from ma-provider-tools (#36) (`06e5d4a`)
- chore: sync workflow wrappers from ma-provider-tools (#37) (`12e650b`)
- docs: rewrite README in MSX style with Docker Quick Start, full features, references (`b150c28`)
- docs: rewrite README.ru in MSX style with Docker Quick Start, full features, references (`6dcf8cc`)
- chore: sync workflow wrappers from ma-provider-tools (#38) (`ab038cd`)
- chore: sync workflow wrappers from ma-provider-tools (#39) (`f717ffe`)
- chore: sync workflow wrappers from ma-provider-tools (#40) (`c14f15b`)
- chore: sync workflow wrappers from ma-provider-tools (#41) (`f8a2175`)
- chore: sync workflow wrappers from ma-provider-tools (#42) (`b388d84`)
- chore: set Russian README as default (#43) (`eee515d`)
- chore: sync workflow wrappers from ma-provider-tools (#44) (`5cfcfd9`)
- chore: sync workflow wrappers from ma-provider-tools (#45) (`0d8444e`)
- chore: sync workflow wrappers from ma-provider-tools (#46) (`99280f3`)
- chore: sync workflow wrappers from ma-provider-tools (#47) (`d39a199`)
- chore: sync workflow wrappers from ma-provider-tools (#48) (`6f539f7`)
- chore: sync workflow wrappers from ma-provider-tools (#49) (`f31d091`)
- chore: sync workflow wrappers from ma-provider-tools (#50) (`9f48a77`)
- chore: generate historical changelog [skip ci] (`15cf409`)
- docs: add pre-separation upstream PR history to CHANGELOG (`0ed69df`)
- chore: sync workflow wrappers from ma-provider-tools (#51) (`c3bcaf2`)
- chore: remove trailing newlines in docs and add uv.lock (`ecc5e7e`)
- feat: implement FLAC streaming via /api/tiny/track/stream (`2499a55`)
- feat: map artist bio/fanart, album label, track genres/credits; fix library tracks; add similar tracks; optimize streaming (#53) (`968f1cd`)
- Feature/zvuk api improvements (#54) (`0d9f063`)
- feat: add BROWSE and RECOMMENDATIONS features with synthesis and editorial playlists (`a1252f2`)
- fix: type annotations in test_lyrics.py for mypy (`dc4c00b`)
- fix: resolve static playlist cover images via auth cookie (`785bec8`)
- fix: update get_editorial_playlist_ids() for changed API response shape (`78bca73`)
- fix: use browser headers in resolve_image() for static Zvuk URLs (`cabfd2b`)
- fix: always try FLAC first when lossless quality is requested (`ced54c5`)

---

## 2026-02-22

- chore: set Russian README as default (#43) (`eee515d`)
- docs: rewrite README.ru in MSX style with Docker Quick Start, full features, references (`6dcf8cc`)
- docs: rewrite README in MSX style with Docker Quick Start, full features, references (`b150c28`)

## 2026-02-21

- fix: remove music-assistant-models pin to resolve CI dependency conflict (`c18234c`)
- docs: unify documentation structure (#9) (`5697588`)

## 2026-02-19

- feat: initial provider setup (`d40be07`)


<!-- Pre-separation: development in trudenboy/ma-server monorepo -->
<!-- The following changes were developed in the `trudenboy/ma-server` monorepo before this provider was extracted into its own repository on 2026-02-19. -->

## 2026-02-10

- feat: provider accepted into upstream Music Assistant (music-assistant/server#3090)

## 2026-02-03

- chore: update Zvuk Music icons to official 2024 logo
- test: add Zvuk Music unit tests

## 2026-02-01

- feat: add Zvuk Music provider scaffold (manifest, constants, icons)
- feat: add Zvuk Music API client and model parsers
- feat: implement ZvukMusicProvider (browse, search, streaming)
