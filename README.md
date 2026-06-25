# Zhirox AI Debt Manager

Kurdish Sorani RTL Flutter frontend for **Zhirox AI Debt**, connected to the production Replit backend.

## Backend

- Production API base URL: `https://database-builder-arambarzani152.replit.app/api`
- Health check: `https://database-builder-arambarzani152.replit.app/api/healthz`
- Auth: `Authorization: Bearer <token>`
- Login requires: `email`, `password`, `market_code`
- Market code for test environment: `ZHIROX_TEST`

## Branch policy

All work is done directly on `main` as requested. No feature branches are used.

## Current frontend status

This repository starts with the Flutter foundation:

- Kurdish Sorani RTL app shell
- Modern dark finance dashboard theme
- Replit API configuration
- Auth/login service
- Secure token storage using `shared_preferences`
- Dashboard placeholder wired for live backend connection

## Next steps

1. Run `flutter pub get`.
2. If platform folders are missing, run `flutter create . --platforms=web,android,ios`.
3. Run `flutter run -d chrome` for web preview.
4. Connect each module screen to the documented backend endpoints.

## Important security note

The current test credentials are for development/testing only. Rotate or disable test accounts before real launch.
