# Haptic Quest

Mobile-first haptic discovery and rewards for festivals. The first MVP targets **GLOW Eindhoven 2026 — CONNECT**.

> Independent prototype. Not an official GLOW application. Prototype checkpoint coordinates/placeholders require organizer validation before public use.

## Pilot MVP
- configurable festival/checkpoint data in `festival.js`
- live GPS proximity and hot/cold haptic feedback
- automatic discovery inside ~35 m
- checkpoint-code fallback for GPS-poor locations and staffed installations
- real OpenStreetMap context via Leaflet
- Demo Walk for remote sales demos
- Light/XP wallet, completion reward and redemption code
- safety/privacy onboarding
- multimodal accessibility settings
- organizer pilot dashboard
- local anonymous event counters
- installable/offline PWA

## Run
```bash
python3 -m http.server 8080
```
Open `http://localhost:8080`. Geolocation requires localhost or HTTPS.

## Privacy model
The MVP processes GPS on-device. It stores quest state and coarse interaction events in browser localStorage, not raw location history. A production pilot should use consented, aggregate analytics and short retention rather than collecting continuous attendee traces.

## Festival configuration
Each checkpoint has an ID, display metadata, latitude/longitude, XP value, physical verification code and clue. This keeps the quest engine reusable across GLOW, Dutch Design Week, Cinekid and other festivals.

## Production next
1. Supabase/PostGIS organizer CMS and signed quest publishing.
2. One-time/rotating QR or NFC verification rather than static demo codes.
3. Expo/React Native shell for reliable native haptics and background behavior.
4. Aggregate event ingestion and organizer funnel/crowd-distribution analytics.
5. Sponsor reward inventory/redemption and anti-abuse controls.
6. Organizer-validated route, accessibility and safety data.
