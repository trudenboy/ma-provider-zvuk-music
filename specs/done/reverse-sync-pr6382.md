# Reverse-sync: upstream PR #6382

Ported from music-assistant/server#6382 into `zvuk_music`.

## Summary

The setup flow used to reduce a rejected-setup error to its translation key
(or plain message) before re-showing the token form. That dropped the
translation arguments and ownership metadata, so clients could not render the
localized message. The retry form now receives the original setup error, and
the frontend resolves it into the user's language.

## Test Plan

- `test_run_setup_retries_with_preserved_token_after_validation_error` asserts
  that the retry form keeps the rejected token and receives the original
  setup error object under `base`.
