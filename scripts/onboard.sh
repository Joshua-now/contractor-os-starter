#!/bin/bash
# ============================================================
# Contractor-OS Onboarding Script
# Usage: ./scripts/onboard.sh
# Run this once per new client after deploying to Railway.
# ============================================================

set -e

echo ""
echo "⚡ Contractor-OS — New Client Setup"
echo "===================================="
echo ""

read -p "Client name (e.g. Mike Johnson): " CLIENT_NAME
read -p "Business name (e.g. Johnson HVAC): " BUSINESS_NAME
read -p "Client cell phone (+1XXXXXXXXXX — they call IN from this): " CLIENT_PHONE
read -p "Telnyx phone number (+1XXXXXXXXXX — the AI number they call): " TELNYX_PHONE
read -p "Client email: " CLIENT_EMAIL
read -p "GHL Location ID: " GHL_LOCATION_ID
read -p "Tier (1=After Hours, 2=Speed to Lead, 3=Complete Package): " TIER
read -p "Business type (HVAC/roofing/plumbing/electrical/pest): " BUSINESS_TYPE

echo ""
echo "Setting up $CLIENT_NAME ($BUSINESS_NAME) on Tier $TIER..."
echo ""

# Write seed.js dynamically
cat > backend/src/seed.js << SEEDEOF
require('dotenv').config();
const pool = require('./db');
const CONTRACTOR = {
  name: "$CLIENT_NAME",
  business_name: "$BUSINESS_NAME",
  phone: "$CLIENT_PHONE",
  telnyx_phone: "$TELNYX_PHONE",
  email: "$CLIENT_EMAIL",
  ghl_location_id: "$GHL_LOCATION_ID",
  tier: $TIER,
  business_type: "$BUSINESS_TYPE",
};
async function seed() {
  await pool.query('CREATE TABLE IF NOT EXISTS contractors (id SERIAL PRIMARY KEY, name VARCHAR(255), business_name VARCHAR(255), phone VARCHAR(50), telnyx_phone VARCHAR(50), email VARCHAR(255), ghl_location_id VARCHAR(255), tier INTEGER DEFAULT 1, business_type VARCHAR(100), created_at TIMESTAMP DEFAULT NOW())');
  await pool.query('CREATE TABLE IF NOT EXISTS contacts (id SERIAL PRIMARY KEY, contractor_id INTEGER REFERENCES contractors(id), name VARCHAR(255), phone VARCHAR(50), email VARCHAR(255), ghl_contact_id VARCHAR(255), created_at TIMESTAMP DEFAULT NOW())');
  await pool.query('CREATE TABLE IF NOT EXISTS appointments (id SERIAL PRIMARY KEY, contractor_id INTEGER REFERENCES contractors(id), contact_id INTEGER REFERENCES contacts(id), scheduled_at TIMESTAMP, notes TEXT, created_at TIMESTAMP DEFAULT NOW())');
  await pool.query("DELETE FROM contractors WHERE email = '$CLIENT_EMAIL'");
  const result = await pool.query('INSERT INTO contractors (name, business_name, phone, telnyx_phone, email, ghl_location_id, tier, business_type) VALUES ($1,$2,$3,$4,$5,$6,$7,$8) RETURNING id', [CONTRACTOR.name, CONTRACTOR.business_name, CONTRACTOR.phone, CONTRACTOR.telnyx_phone, CONTRACTOR.email, CONTRACTOR.ghl_location_id, CONTRACTOR.tier, CONTRACTOR.business_type]);
  console.log('✅ Contractor created:', result.rows[0]);
  await pool.end();
}
seed().catch(console.error);
SEEDEOF

echo "✅ seed.js updated"
cd backend && npm run seed && cd ..

echo ""
echo "✅ $CLIENT_NAME is live on Tier $TIER!"
echo "📞 AI Phone Number: $TELNYX_PHONE"
echo "🖥  Desk UI: https://YOUR-RAILWAY-URL.up.railway.app/desk.html"
echo ""
