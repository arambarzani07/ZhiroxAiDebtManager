# F9A — Compile and Release Audit

## Scope

This audit covers the Flutter frontend structure after F1 through F8A.

## Static checks completed

- No visible incomplete UI keyword was found by repository search.
- No direct `market_id` usage was found by repository search.
- Tenant login now requires an explicit market code from the user.
- Seeded tenant credentials were removed from the tenant login form.
- Seeded market code was removed from `ApiConfig`.
- Tenant and platform sessions are routed separately by `sessionKind`.
- API response decoding supports object and list payloads.
- API client now supports safe endpoint fallback for route-name alignment.
- Customer, debt, payment, report, and cash services were reviewed and aligned to backend route variants.
- Each visible module entry opens a real screen or performs a wired action.

## Build status

The full Flutter build is still assigned to the final release-hardening step. This connector session can update and inspect repository files, but it does not provide a local Flutter SDK runtime. The build must be run in the project development environment or CI runner.

## Remaining F9 work

- Run `flutter pub get`.
- Run `flutter analyze`.
- Run `flutter build web`.
- Fix any analyzer or compiler findings.
- Run a runtime smoke test against the production API.
- Rotate the shared test credentials before public release.
