---
title: Configuration
description: How to connect Zvuk Music to Music Assistant — step-by-step guide
---

import { Steps } from '@astrojs/starlight/components';

The Zvuk Music provider requires an **authorization token** — a unique key tied to your account. This takes about 2 minutes and requires no additional software.

## Step 1 — Get your token

The token is stored in your browser after you log in to zvuk.com. You don't need to register it anywhere or create it manually.

<Steps>
1. Sign in to your account at [zvuk.com](https://zvuk.com) in any browser.

2. Without closing the site, open this link in the same browser:
   **[zvuk.com/api/tiny/profile](https://zvuk.com/api/tiny/profile)**

3. The page will show text in JSON format. Find the `"token"` field and copy its value — a long string of letters and numbers.

   Example (your token will be different):
   ```json
   {
     "token": "abc123def456ghi789..."
   }
   ```
   Copy the value only — without quotes.
</Steps>

:::tip[Don't see JSON?]
If the page looks like a normal website rather than plain text — make sure you're signed in at [zvuk.com](https://zvuk.com). Then open the link above again.
:::

:::note[Your token is like a password]
Keep your token private. Don't share it publicly — anyone with your token can access your Zvuk Music account.
:::

---

## Step 2 — Add the provider in Music Assistant

<Steps>
1. Open **Music Assistant → Settings → Music Sources**.

2. Click **«+ Add»** and select **Zvuk Music**.

3. Paste the copied token into the **«Zvuk Music Token»** field.

4. Choose your preferred **audio quality** (see below).

5. Click **«Save»**.

6. MA will connect to Zvuk Music and start syncing your library.
</Steps>

---

## Audio Quality

| Option | Format | Bitrate | Who it's for |
|--------|--------|---------|--------------|
| **High (default)** | MP3 | 320 kbps | Any account |
| **Lossless** | FLAC | Lossless | Requires Zvuk Music subscription |

:::note
If you don't have a Zvuk Music subscription, choose **«High»**. If you select «Lossless» without a subscription, the provider will automatically fall back to MP3 320 kbps.
:::

---

## If your token stops working

Tokens can expire after some time. Symptoms: the provider stops playing tracks or shows an authentication error.

**Fix:**
1. Get a new token following Step 1 above
2. In MA, open the Zvuk Music provider settings
3. Click **«Reset authentication»**
4. Enter the new token
