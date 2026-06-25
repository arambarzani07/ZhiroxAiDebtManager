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
11. Write calls retry alternate payload field names on 400 and 422 as well as route mismatch statuses.
12. Debt payloads support `amount`, `principal_amount`, and `total_amount` style fields.
13. Payment payloads support `amount` and `paid_amount` style fields.
14. Cash payloads support opening, closing, handover, and discrepancy field aliases.
15. Auth accepts both `token` and `access_token` response keys.
16. Customer create and edit payloads support multiple name and phone field names.
17. Customer action forms validate required fields before sending data.
18. Optional customer action notes do not send empty strings.
19. API helpers read wrapped object and list envelopes.
20. Customer and debt display helpers read wrapped database rows.
21. Debt case IDs support `id`, `debt_case_id`, `case_id`, `debt_id`, `uuid`, and `_id`.
22. Payment creation reads payment ID from direct, nested `data`, or nested `payment` response objects.

## Note

The primary known backend paths remain first. Extra route or payload variants are tried only when the backend returns a retry-safe status.

## Next step

Run Flutter analyze and build in a Flutter SDK environment, then fix any compiler finding before release.
