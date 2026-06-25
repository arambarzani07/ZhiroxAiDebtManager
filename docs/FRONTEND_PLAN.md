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

## Frontend phases

### F1 — Foundation
- App shell
- Theme
- API client
- Login
- Token persistence
- Dashboard shell

### F2 — Customer Brain
- Customer list
- Customer create/edit
- Customer profile timeline
- Contacts, guarantors, evidence, status, credit locks

### F3 — Debt and Ledger
- Debt accounts
- Debt cases
- Give debt flow
- Ledger read-only history
- Reversal/correction request screens

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

## Current status

F1 foundation has started on `main`.
