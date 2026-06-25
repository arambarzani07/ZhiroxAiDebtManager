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

## Frontend phases

### F1 — Foundation
- App shell
- Theme
- API client
- Login
- Token persistence
- Dashboard shell

Status: started on main.

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

Status: F2 customer brain screens started on main.

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
- Next: receipt screen, payment receipt delivery log, statement export placeholder

Status: F3B debt case and payment entry screens started on main.

### F4 — Payments and Receipts
- Receive payment flow
- Payment allocations
- Receipt screen
- Receipt delivery logs

### F5 — Cash Module
- Open/close/lock cash session
- Handovers
- Discrepancies
- Reconciliation

### F6 — Reports and Manager Dashboard
- Debt summary
- Top debtors
- Paid/unpaid
- Cash reports
- Employee activity

### F7 — Notifications and AI
- WhatsApp draft screens
- Broadcasts
- AI suggestions and approval review

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

F1 foundation, F2 customer brain screens, F3A debt and ledger foundation, and F3B payment/debt case screens have been added on `main`. Build phase is intentionally deferred until the final release-hardening stage.
