# Zhirox AI Debt — Flutter Frontend Plan

## Locked backend foundation

- API base URL: `https://database-builder-arambarzani152.replit.app/api`
- Production DB seed: complete
- RBAC: complete
- Market isolation: complete
- System-owner tenant block: complete
- Ledger source of truth: preserved
- Cash, receipts, statements, recovery, notifications, AI guardrails: backend-ready

## Frontend rules

1. Work directly on `main` only.
2. Do not create branches.
3. Never send `market_id` from Flutter except `market_code` during login.
4. Use `Authorization: Bearer <token>` for all authenticated routes.
5. Money must stay as string/Decimal-like values; do not use Dart double for financial writes.
6. Kurdish Sorani RTL is the default UI direction.
7. Production URL is centralized in `ApiConfig`.
8. Defer the full build phase until the end. During implementation, continue feature-by-feature coding on `main`; run final build/test only after the planned frontend modules are complete or when a blocking compile issue must be resolved.
9. Do not leave visible half-features in the app. Any feature that is not fully wired must stay hidden from the UI until it is completed.
10. Every stage must pass `docs/IMPLEMENTATION_QUALITY_GATE.md` before moving to the next stage.

## Frontend phases

### F1 — Foundation
- App shell
- Theme
- API client
- Login
- Token persistence
- Dashboard shell

Status: added on main.

### F2 — Customer Brain
- Customer API service
- Customer list
- Customer create screen
- Customer profile screen
- Search and refresh
- Customer contacts
- Guarantors
- Evidence records
- Status history
- Credit locks
- Reusable customer action forms
- Customer edit screen
- Contact health screen
- Credit limit review screen
- Duplicate review screen

Status: customer brain screens added on main.

### F3 — Debt and Ledger
- Debt API service
- Debt display helpers
- Customer debt timeline
- Debt accounts screen content
- Debt cases screen content
- Give debt flow
- Ledger read-only screen
- Debt case detail screen
- Receive payment entry
- Payment allocation view
- Correction request screen

Status: debt case and payment entry screens added on main.

### F4 — Payments and Receipts
- Receipt API methods
- Receipt screen
- Receipt delivery log screen
- Customer statement screen
- Statement date and currency filters
- Delivery status cards
- Receipt visual cleanup

Status: receipts, statements, filters, and delivery cards added on main. Visible incomplete buttons were removed.

### F5 — Cash Module
- Cash API service
- Cash display helpers
- Current cash session view
- Cash sessions list
- Open cash session screen
- Close cash session screen
- Cash handover screen
- Cash discrepancy screen
- Reconciliation action
- Dashboard link to cash module

Status: F5A cash module foundation added on main after quality gate audit.

### F6 — Reports and Manager Dashboard
- Reports API service
- Report display helpers
- Reports dashboard screen
- Debt summary report
- Top customers report
- Payment status report
- Cash report
- Employee activity report
- Dashboard link to reports module

Status: F6A reports foundation added on main after quality gate audit.

### F7 — Notifications and AI
- Intelligence API service
- Intelligence display helpers
- Smart Center dashboard screen
- Broadcast message screen
- AI suggestions screen
- Approval review screen
- Dashboard link to Smart Center

Status: F7A Smart Center foundation added on main after quality gate audit.

### F8 — System Owner Panel
- Separate auth flow
- Market/license management
- Platform health

### F9 — Final build and release hardening
- Flutter web/android/ios build
- Compile fixes
- Runtime API smoke test
- RTL visual check
- Auth/session check
- Customer/debt/payment/cash smoke test
- Security cleanup and test credential rotation reminder

## Current status

F1 foundation, F2 customer brain screens, F3 debt/payment screens, F4 receipt/statement screens, F5A cash module, F6A reports foundation, and F7A Smart Center foundation have been added on `main`. Build phase is intentionally deferred until the final release-hardening stage.
