# ⚡ Contractor-OS Starter

> **"Run your office from your truck."**
> 
> An AI office manager built specifically for contractors — HVAC, roofing, plumbing, electrical, pest control. Call in from the field, speak naturally, and it handles the rest.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/template/contractor-os)

---

## What It Does

A contractor finishes a job and calls a phone number from his truck:

> *"Just left the Joneses — sold them a new Trane unit. Invoice them, put them on the maintenance plan, and check if my Whitaker appointment is still on for Thursday."*

The AI handles all of it. No app. No typing. Just a phone call.

**From the office computer**, you get a full desk interface — chat with your AI manager, check system status, view the pipeline.

---

## The Three Tiers

| Tier | Product | Price | Setup | Minutes |
|------|---------|-------|-------|---------|
| 1 | **After Hours Receptionist** — AI answers calls after hours, never misses a lead | $397/mo | $297 | 300/mo |
| 2 | **Speed to Lead** — Form fill → AI calls back in 60 seconds | $997/mo | $697 | 1,200/mo |
| 3 | **Complete Package (AI Employee)** — Full office manager, pipeline, campaigns, desk UI | $1,497/mo | $997 | 2,000/mo |

All tiers include a 14-day free trial. Overage: $0.40/min.

---

## What's Included

```
contractor-os-starter/
├── backend/
│   ├── src/
│   │   ├── index.js          — Express server, all routes
│   │   ├── fieldOffice.js    — AI brain (Claude + all tools)
│   │   ├── routes/
│   │   │   ├── voice.js      — Telnyx phone call handler
│   │   │   ├── desk.js       — Desk UI chat API
│   │   │   ├── contractors.js
│   │   │   ├── conversations.js
│   │   │   └── webhooks.js
│   │   ├── db.js             — PostgreSQL setup
│   │   ├── ghl.js            — GoHighLevel CRM helpers
│   │   ├── heartbeat.js      — Health monitoring
│   │   └── seed.js           — Initial contractor setup
│   ├── public/
│   │   └── desk.html         — Office computer UI
│   └── package.json
├── railway.toml               — Railway deploy config
├── .env.example               — All required variables
├── SETUP.md                   — Step-by-step setup guide
└── scripts/
    └── onboard.sh             — New client setup script
```

---

## Quick Deploy (15 Minutes)

### 1. Deploy to Railway

Click the button above, or:

```bash
# Fork this repo, then connect to Railway
# Railway will auto-detect the Dockerfile and deploy
```

### 2. Add a PostgreSQL database

In Railway: **New Service → Database → PostgreSQL**. Copy the `DATABASE_URL` into your environment variables.

### 3. Fill in your `.env` variables

See [`.env.example`](.env.example) for the full list. The required ones to get started:

```env
ANTHROPIC_API_KEY=        # Get from console.anthropic.com
TELNYX_API_KEY=           # Get from portal.telnyx.com
TELNYX_PHONE_NUMBER=      # Your purchased Telnyx number
GHL_API_KEY=              # GoHighLevel API key
GHL_LOCATION_ID=          # GHL location/sub-account ID
GHL_PIT_TOKEN=            # GHL Private Integration Token
```

### 4. Point your Telnyx number

In Telnyx portal → Call Control → Your number → set the webhook to:
```
https://YOUR-RAILWAY-URL.up.railway.app/api/voice/telnyx
```

### 5. Seed the first contractor

```bash
# Set the contractor's details in seed.js, then:
npm run seed
```

### 6. Make a test call

Call your Telnyx number. Say: *"Hey, what's on my schedule today?"*

### 7. Open the desk UI

Visit: `https://YOUR-RAILWAY-URL.up.railway.app/desk.html`

---

## AI Tools Available

The AI office manager has these built-in tools:

| Tool | What It Does |
|------|-------------|
| `look_up_contact` | Search GHL CRM by name — returns stage, notes, open deals |
| `check_appointments` | Pull upcoming scheduled appointments |
| `log_activity` | Log a call, sale, demo — adds note to GHL record |
| `create_opportunity` | Add a new deal to the sales pipeline |
| `update_pipeline_stage` | Move a contact through the pipeline |
| `create_contact` | Add a new prospect to CRM |
| `schedule_followup` | Set a follow-up task |
| `send_follow_up_message` | Queue a follow-up text or email |
| `check_instantly` | Live Instantly campaign stats |
| `check_switchboard` | Switchboard AI call system status |
| `check_n8n` | n8n workflow health and execution history |
| `check_slack` | Recent Slack hand-raises and alerts |
| `get_system_status` | Full health check of all systems |

---

## Pipeline Stages

```
New Lead → Demo Scheduled → Proposal Sent → Trial Started → Closed Won → Closed Lost
```

---

## Tech Stack

| Layer | Service |
|-------|---------|
| AI | Anthropic Claude (claude-opus-4-5) |
| Voice | Telnyx (inbound call handling) |
| CRM | GoHighLevel (GHL) |
| Email Outreach | Instantly |
| AI Calling | Switchboard |
| Automation | n8n |
| Alerts | Slack |
| Database | PostgreSQL (Railway) |
| Hosting | Railway |

---

## Customizing for a New Client

1. Fork this repo (or clone to a new Railway project)
2. Run `scripts/onboard.sh` with the client's info
3. Fill in their API keys in Railway environment variables
4. Point their Telnyx number to the new webhook URL
5. Done — they're live in under 15 minutes

Each client gets their own isolated Railway deployment with their own DB, API keys, and phone number.

---

## Environment Variables Reference

See [`.env.example`](.env.example) for the complete list with descriptions.

**Minimum required:** `ANTHROPIC_API_KEY`, `TELNYX_API_KEY`, `TELNYX_PHONE_NUMBER`, `GHL_API_KEY`, `GHL_LOCATION_ID`, `GHL_PIT_TOKEN`, `DATABASE_URL`

**For full Tier 3:** All of the above plus `INSTANTLY_API_KEY`, `N8N_API_KEY`, `N8N_BASE_URL`, `SWITCHBOARD_URL`, `SWITCHBOARD_API_KEY`, `SLACK_BOT_TOKEN`

---

## Built By

**Fluid Productions LLC** — Orlando, FL  
Joshua Brown | [fluidproductions.ai](https://fluidproductions.ai)

> *We sell AI systems to contractors. This is what we run ourselves.*

---

## License

MIT — fork it, deploy it, sell it. Attribution appreciated but not required.
