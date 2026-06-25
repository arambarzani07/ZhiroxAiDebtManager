# Backend / Frontend Alignment Audit

## Goal

Before the build step, the frontend services were reviewed against the approved backend behavior and database rules.

## Fixed now

1. API client now supports endpoint fallback for GET, POST, and PATCH when a backend route name differs but the data model is the same.
2. API errors now keep the HTTP status code, so validation/security errors are not hidden by fallback attempts.
3. Customer service now supports plural and table-style route variants for customers, contacts, guarantors, evidence, status history, and credit locks.
4. Debt service now supports customer-scoped and table-style route variants for debt accounts, debt cases, ledger, debt creation, and correction requests.
5. Payment service now supports customer-scoped and table-style route variants for payments, allocations, receipts, delivery logs, and statements.
6. Reports now use the approved business names first: debt summary, top debtors, paid/unpaid, cash report, and employee activity.
7. Cash service already supports route variants for sessions, handovers, discrepancies, and reconciliation.
8. Tenant login requires explicit market code from the UI and no longer uses seeded test values.
9. `market_id` is still not sent from Flutter for tenant routing.
10. Money fields are still submitted as string values.

## Build gate

The next build step must verify the remaining unknowns against the live backend:

- whether every fallback route resolves to the intended endpoint;
- whether response keys match the summary cards exactly;
- whether platform panel endpoints are exposed under the expected protected paths;
- whether AI and approval endpoints use the same approval identifiers shown by the frontend.

If any endpoint differs, fix the matching service file first, then run build again.
