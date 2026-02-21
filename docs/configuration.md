[← Back to README](../README.md)

# Configuration

All settings are accessible via **Settings → Music Sources → Zvuk Music**.

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `token` | Secure string | — | Zvuk Music X-Auth-Token. Required for authentication. See below for how to obtain it. |
| `quality` | String (enum) | `high` | Preferred audio quality. See [Quality Options](#quality-options) below. |

### Quality Options

| Value | Label | Format | Bitrate |
|-------|-------|--------|---------|
| `high` | High | MP3 | 320 kbps |
| `lossless` | Lossless | FLAC | Lossless |

## Obtaining a Token

Zvuk Music requires an X-Auth-Token. The provider documentation at
<https://music-assistant.io/music-providers/zvuk/> explains how to obtain one.

## Actions

| Action | Description |
|--------|-------------|
| Reset authentication | Clears the stored token, allowing you to re-enter credentials. |
