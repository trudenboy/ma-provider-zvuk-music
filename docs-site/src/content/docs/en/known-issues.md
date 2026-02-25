---
title: Known Issues
description: Common problems with the Zvuk Music provider and their solutions
---

## OAuth token expiration

**Symptoms:** The provider stops working after a few days or weeks without any apparent configuration errors.

**Cause:** Zvuk Music OAuth tokens have a limited lifespan. Once expired, the provider loses access to the API.

**Fix:** Re-authenticate in the provider settings: remove the current configuration, re-add the provider, and complete authorisation.

---

## Connection drops during long sessions

**Symptoms:** Playback is interrupted or tracks fail to load after several hours of use.

**Cause:** The Zvuk Music API closes long-lived connections. This is service-side behaviour.

**Fix:** Restart Music Assistant or reconnect the provider. The error resolves itself on the next request.

---

## Geo-blocking of playlists and tracks

**Symptoms:** Some playlists or tracks are unavailable, even though they open in the Zvuk Music app.

**Cause:** Some content is restricted by geography or subscription type.

**Fix:** Content unavailable due to geo-blocking or subscription restrictions cannot be played through the provider. This is a Zvuk Music limitation.

---

## Multiple accounts not supported

**Symptoms:** Adding a second Zvuk Music account causes the first one to stop working.

**Cause:** The current version of the provider supports only one Zvuk Music account.

**Fix:** Use a single account. Multi-account support is planned for future versions.
