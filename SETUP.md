# Contractor-OS Setup Guide

Complete setup in ~15 minutes. Keep this doc open during onboarding.

---

## Before You Start — What You'll Need

Gather these before the call with the client:

- [ ] Client's **GoHighLevel** sub-account ID and API key
- [ ] **Anthropic API key** (from console.anthropic.com)
- [ ] **Telnyx** account with a purchased phone number
- [ ] For Tier 2+: Switchboard API key and URL
- [ ] For Tier 3: Instantly API key, n8n URL + API key, Slack bot token

---

## Step 1 — Fork & Deploy to Railway

1. Go to **https://github.com/Joshua-now/contractor-os-starter**
2. Click **"Deploy on Railway"**
3. Railway will ask you to connect your GitHub — authorize it
4. It creates a new project from the template
5. Note the **public URL** Railway assigns (looks like `xxx.up.railway.app`)

**Or manually:**
```bash
# In Railway dashboard: New Project → Deploy from GitHub repo
# Select this repo → Deploy
```

---

## Step 2 — Add PostgreSQL

In Railway:
1. Click **"+ New"** in your project
2. Select **Database → Add PostgreSQL**
3. Railway automatically adds `DATABASE_URL` to your service variables

---

## Step 3 — Set Environment Variables

In Railway → your service → **Variables** tab, add:

### Required for All Tiers

```
ANTHROPIC_API_KEY          = (your Anthropic key)
TELNYX_API_KEY             = (from portal.telnyx.com)
TELNYX_PHONE_NUMBER        = +1XXXXXXXXXX
TELNYX_APP_ID              = (Call Control App ID from Telnyx)
GHL_API_KEY                = (GoHighLevel API key)
GHL_LOCATION_ID            = (GHL sub-account/location ID)
GHL_PIT_TOKEN              = (GHL Private Integration Token)
NODE_ENV                   = production
```

### Additional for Tier 2 (Speed to Lead)

```
SWITCHBOARD_URL            = https://your-switchboard.up.railway.app
SWITCHBOARD_API_KEY        = (from Switchboard settings)
TELNYX_ASSISTANT_ID_SPEED_TO_LEAD = (from Telnyx AI assistants)
```

### Additional for Tier 3 (Complete Package)

```
INSTANTLY_API_KEY          = (from app.instantly.ai)
N8N_API_KEY                = (from n8n settings)
N8N_BASE_URL               = https://your-n8n.up.railway.app
SLACK_BOT_TOKEN            = xoxb-...
SLACK_HAND_RAISES_CHANNEL  = hand-raises
SLACK_ALERTS_CHANNEL       = alerts
TELNYX_ASSISTANT_ID_AFTER_HOURS = (from Telnyx)
TELNYX_ASSISTANT_ID_COMPLETE_PACKAGE = (from Telnyx)
```

---

## Step 4 — Configure Telnyx Webhook

1. Go to **portal.telnyx.com** → Call Control → Applications
2. Open (or create) a Call Control App
3. Set the **Webhook URL** to:
   ```
   https://YOUR-RAILWAY-URL.up.railway.app/api/voice/telnyx
   ```
4. Set **Webhook API Version** to `API v2`
5. Assign your client's phone number to this app

---

## Step 5 — Seed the Database

Edit `backend/src/seed.js` with the client's info:

```js
const CONTRACTOR = {
  name: 'Mike Johnson',           // Client's name
  business_name: 'Johnson HVAC',  // Business name
  phone: '+15551234567',          // Their cell (FROM number — they call in from this)
  telnyx_phone: '+15559876543',   // Telnyx number (TO number — what they call)
  email: 'mike@johnsonhvac.com',
  ghl_location_id: 'abc123',      // Their GHL location ID
  tier: 3,                        // 1, 2, or 3
};
```

Then run:
```bash
cd backend && npm run seed
```

Or use the onboarding script:
```bash
./scripts/onboard.sh
```

---

## Step 6 — Test the Voice Line

Call the Telnyx number from the contractor's cell phone.

Say: *"Hey, what's on my schedule today?"*

Expected: AI greets you, checks appointments, responds naturally.

---

## Step 7 — Open the Desk UI

Visit: **`https://YOUR-RAILWAY-URL.up.railway.app/desk.html`**

Test by typing: *"Give me a full system status"*

---

## Step 8 — Handoff to Client

Send them:
1. The Telnyx phone number to call
2. The desk UI URL
3. A 5-minute demo video (optional but recommended)

**Total time from zero to live: ~15 minutes**

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Call connects but AI doesn't respond | Check `TELNYX_APP_ID` matches your Call Control app |
| "Contractor not found" error | Run `npm run seed` again — check the phone number matches exactly |
| GHL lookups returning empty | Verify `GHL_PIT_TOKEN` and `GHL_LOCATION_ID` |
| Desk UI can't connect | Check Railway service is deployed and `/health` returns OK |
| n8n/Instantly/Slack showing Down | Those API keys may not be set — only needed for Tier 3 |

---

## Support

Built and maintained by **Fluid Productions LLC**  
Joshua Brown — Orlando, FL
