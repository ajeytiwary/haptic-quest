# Haptic Quest

Mobile-first haptic discovery and rewards for festivals.

The first MVP targets **GLOW Eindhoven 2026 — CONNECT**.

> Independent prototype. Not an official GLOW application.

## MVP
- configurable festival quests and checkpoints
- GPS proximity / hot-cold haptic feedback
- demo-walk simulator for remote pitches
- XP (“Light”) and completion rewards
- accessibility preferences
- installable PWA
- privacy-first: MVP location processing stays on device

## Run
```bash
python3 -m http.server 8080
```
Then open http://localhost:8080.

## Product direction
Organizer CMS → native haptics/background location → QR/NFC reward verification → privacy-preserving analytics.
