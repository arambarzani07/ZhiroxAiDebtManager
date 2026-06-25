# Zhirox AI Debt — Implementation Quality Gate

## Rule

A frontend stage must not be treated as complete until it passes this gate.

## Gate checks

1. No visible placeholder buttons or half-features in the UI.
2. No TODO / placeholder / draft labels are allowed in visible screens.
3. Every visible button must open a real screen or perform a real wired action.
4. Every visible data screen must have loading, error, empty, and refresh handling where appropriate.
5. API response parsing must tolerate both wrapped objects and list responses.
6. Flutter must never send `market_id`; tenant scope comes from auth token only.
7. Money values must be submitted as string/Decimal-like text, not Dart double.
8. A service method should not be left in the code unless a screen uses it now or the method is part of a fully wired current flow.
9. If a backend endpoint is uncertain, the UI must not expose that action until the endpoint contract is confirmed.
10. Each stage must update the frontend plan only after the above checks are satisfied.

## Current audit fixes

- API client response decoding was hardened so list responses are wrapped safely under `data`.
- Visible receipt placeholder action was removed from the receipt screen.
- The unwired receipt draft service method was removed.
- Delivery logs are shown through a real status-card widget.
- Customer statement filters are wired into the statement API request.

## Future implementation rule

Before moving from one stage to the next, audit the stage using this file. Fix errors and remove or hide incomplete work before continuing.
