# Consolidated Upstream Migrations Design

## Goal

Port the user-visible behavior from upstream Music Assistant PRs 4487, 5053,
and 5058 into the standalone Zvuk Music provider as one coherent change on top
of the current `origin/dev` branch.

The result must let new users configure the provider through the current setup
wizard, explain token authentication failures precisely, and load Discover
recommendation rows lazily without changing the existing browse experience.

## Scope

The change includes:

- a setup flow that collects the Zvuk X-Auth-Token before provider creation;
- migration from configuration-backed token reads to setup-value reads while
  preserving existing installed instances;
- reconfiguration through the setup flow instead of the legacy clear-auth
  action;
- a Zvuk-specific login failure message that names the X-Auth-Token;
- the two-method recommendations contract introduced upstream;
- focused unit tests, provider strings, one completed feature specification,
  and a Keep a Changelog entry.

The change does not modify `VERSION`, replace the `zvuk-music` dependency,
redesign browse, or introduce new recommendation sources.

## Implementation Strategy

The reverse-sync branches will not be merged or cherry-picked. They contain
committed conflict markers, incomplete specifications, and patches generated
against an older provider layout. The upstream behavior will instead be
implemented directly against the current standalone repository.

This keeps the provider's source-of-truth history clean while retaining credit
through the changelog and commit message references to the three upstream PRs.

## Configuration and Setup Flow

`provider/setup_flow.py` will own the interactive collection of setup-only
values. The initial user step presents the unofficial-provider disclosure and
a required secure X-Auth-Token field. Submitted data is passed to
`SetupSession.finish`, and `SetupFlowError` is rendered back onto the same form
so an invalid token can be corrected without leaving a half-created provider.

The provider instance will expose only post-installation options, currently
audio quality. Authentication data is read through Music Assistant's setup
value API so secrets remain separate from ordinary provider configuration.

Existing installations must remain usable. The implementation will follow the
current Music Assistant compatibility mechanism for reading or migrating a
previously stored `token` configuration value. The legacy `clear_auth` action
will be removed only when no import or runtime path still depends on it.

Reconfiguration uses the same token form and replaces the stored setup token.
No token is written to logs or included in exceptions.

## Authentication Errors

`provider/strings.json` will define a provider-specific `login_failed` message:
the user is told that Zvuk rejected the X-Auth-Token and is directed to obtain
a fresh token using the documentation.

The existing API client continues mapping `UnauthorizedError` to `LoginFailed`.
The setup framework supplies the localized provider message, avoiding duplicated
user-facing prose in lower-level API methods.

## Lazy Recommendations Contract

The old bulk `recommendations()` method will be replaced by:

```python
async def get_recommendations(self) -> list[RecommendationFolder]

async def get_recommendation_items(
    self, item_id: str
) -> UniqueList[MediaItemType | ItemMapping | BrowseFolder]
```

`get_recommendations()` returns two static, empty row descriptors (`for_you`
and `editorial`) and performs no Zvuk API calls. This makes the Discover shell
cheap and allows Music Assistant to decide which rows should be loaded.

`get_recommendation_items()` performs exactly the backend work for the selected
row. `for_you` loads synthesis playlists; `editorial` loads curated playlists;
an unknown ID returns an empty `UniqueList` without backend I/O.

The existing `_get_for_you_playlists` and `_get_editorial_playlists` helpers are
reused by both recommendations and browse. In accordance with current repository
rules, private helpers remain at the bottom of the provider class.

## Browse Compatibility

Browse paths and visible folders remain unchanged:

- `<instance>://for_you` returns personalized synthesis playlists;
- `<instance>://editorial` returns editorial playlists;
- the root returns the same two `BrowseFolder` entries.

This deliberately keeps browse independent of the recommendation row API while
sharing the two data-fetching helpers.

## Error Handling

- Setup validation errors keep the user on the setup form.
- Missing or rejected authentication becomes `LoginFailed` and uses the
  provider-specific localized message.
- Recommendation row discovery never calls the network and therefore cannot be
  blocked by a temporary Zvuk outage.
- A failure while fetching a selected recommendation row follows the provider's
  existing API exception mapping.
- Unknown recommendation IDs return an empty list rather than raising.

## Tests

Implementation follows red-green-refactor TDD. Tests will cover:

1. setup form fields and retention of submitted values after validation errors;
2. successful completion with the submitted token;
3. provider initialization reading setup values and compatibility with an
   existing configuration-backed token;
4. provider options containing audio quality but not the authentication token;
5. presence of the Zvuk-specific login error translation;
6. recommendation descriptors being returned without backend calls;
7. isolated fetching for each recommendation row;
8. empty behavior for unknown row IDs;
9. unchanged browse behavior.

After focused tests pass, verification runs the complete test suite, Ruff
format/check, mypy, and the repository pre-commit gate.

## Repository Documentation

A single completed feature specification will describe the consolidated user
behavior and test plan. `CHANGELOG.md` will receive one user-facing entry under
canonical headings. Generated policy/configuration files and `VERSION` will not
be edited.

## Delivery

All implementation commits live on
`codex/consolidated-upstream-migrations`, based on the latest `origin/dev`.
The original dirty `dev` checkout and its uncommitted changes remain untouched.
Publishing, closing the three reverse-sync PRs, or merging the consolidated PR
requires a separate explicit user instruction.
