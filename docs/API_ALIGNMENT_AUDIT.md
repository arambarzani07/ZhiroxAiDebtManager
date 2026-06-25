# API Alignment Audit

## Purpose

Before the build step, frontend service calls were reviewed against the expected backend and database boundaries.

## Fixes applied

1. Tenant auth and platform auth now use separate service paths.
2. Tenant login requires `market_code` from the login form.
3. Platform login uses its own session kind.
4. Logout follows the current session kind before clearing local storage.
5. Smart Center service calls support common backend route variants.
6. Platform service calls support health, market list, and plan list route variants.
7. List parsing supports `data`, `items`, `records`, and module collection keys.
8. Test values were removed from visible login and config files.
9. Frontend code does not send `market_id`.
10. Money form values are submitted as text.

## Note

The primary known backend paths remain first. Extra route variants are tried only when the backend returns 404 or 405.

## Next step

Run Flutter analyze and build in a Flutter SDK environment, then fix any compiler finding before release.
