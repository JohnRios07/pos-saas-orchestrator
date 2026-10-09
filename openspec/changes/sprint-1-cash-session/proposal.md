# Proposal: Sprint 1 - Cash Session Resilience & Validation

## Change ID
`sprint-1-cash-session`

## Intent
Implement robust cash session validation across the frontend to prevent operational errors where cashiers operate without an open cash drawer. Four tightly-coupled tasks addressing silent failures, reactive-only validation, missing return blocks, and naive post-login routing.

## Scope
**In Scope (Frontend only - pos-frontend):**
- New reusable hook: `src/hooks/useCashSession.ts`
- `src/pages/CashManagement.tsx` - Fix error handling (#22)
- `src/pages/Sales.tsx` - Add proactive validation on mount (#23)
- `src/pages/SalesHistory.tsx` - Block returns without active session (#26)
- `src/pages/Login.tsx` - Smart redirect after authentication (#28)

**Out of Scope:**
- Backend changes (endpoint `GET /api/cash/sessions/active` exists and works)
- Database migrations
- New API endpoints

## Problem Statement

### Current State Analysis

| Task | Current Behavior | Gap |
|------|-----------------|-----|
| **#22 CashManagement** | `catch (err) { setSession(null) }` - treats ALL errors (network, 400, 500) as "no session" | Silent failure, no user feedback, doesn't hydrate storeId/registerId before query |
| **#23 Sales** | Only validates at payment time (reactive) - shows popup after user builds cart | Cashier wastes time building sale only to discover no open session at checkout |
| **#26 SalesHistory** | "Devolver" button always visible, validates only on click | No preventive blocking, confusing UX |
| **#28 Login** | Redirects by role only (CASHIER→/sales, others→/dashboard) | Doesn't check cash session state; cashier lands in POS with closed drawer |

### Shared Root Cause
All four tasks depend on `GET /api/cash/sessions/active?storeId=&registerId=` but handle its responses inconsistently:
- Backend throws `RuntimeException("No active cash session found")` → HTTP 500 (not 404!)
- Network errors, missing storeId/registerId, and legitimate "no session" all conflated

## Proposed Solution

### 1. Reusable Hook: `useCashSession()`
Single source of truth for cash session state:
- Hydrates `storeId`/`registerId` from auth store before fetch
- Distinguishes: `loading`, `session` (null = legitimately closed), `error` (network/param), `isNetworkError`
- Handles backend's 500-for-not-found quirk
- Memoized, shared across components

### 2. Component-Level Changes

**CashManagement.tsx (#22):**
- Use `useCashSession()` 
- Show error banner if `isNetworkError` or `error` (not "no session")
- Only show "Caja Cerrada" empty state when `session === null && !error`

**Sales.tsx (#23):**
- Use `useCashSession()` in `useEffect` on mount
- If `session === null && !loading && !error` → show blocking banner: "Caja cerrada. Abra turno en Gestión de Caja" + button to `/cash-management`
- Disable product selection/cart while no session
- Keep existing reactive popup as safety net

**SalesHistory.tsx (#26):**
- Use `useCashSession()` 
- Conditionally render "Devolver" button: only if `session !== null`
- If no session: show disabled button with tooltip/alert "No hay turno de caja abierto. Abra caja en Gestión de Caja antes de procesar devoluciones"

**Login.tsx (#28):**
- After successful auth + config fetch, call `/api/cash/sessions/active`
- If `session` exists → navigate to `/sales` (CASHIER/MANAGER) or `/dashboard` (ADMIN)
- If no session → navigate to `/cash-management` (CASHIER/MANAGER) or `/dashboard` (ADMIN)
- Show brief "Verificando estado de caja..." during check

## Approach
- **Single hook** eliminates duplication and ensures consistent error handling
- **Defensive hydration** of storeId/registerId prevents 400 errors from missing params
- **Backend quirk handling**: treat 500 with "No active cash session" message as "no session" (null), not error
- **Progressive enhancement**: existing reactive validations remain as safety nets

## Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Backend 500-for-not-found changes | Low | Medium | Hook isolates this logic; easy to update |
| storeId/registerId null in auth store | Medium | High | Hook waits for both before fetching; shows loading |
| Race condition on login redirect | Low | Low | Sequential: auth → config → cash session check |
| Offline mode interference | Low | Medium | Hook respects offline queue; shows cached session if available |

## Acceptance Criteria
1. CashManagement shows error banner (not empty state) on network/param failures
2. Sales blocks UI proactively on mount when no cash session
3. SalesHistory hides/disables "Devolver" when no active session
4. Login redirects CASHIER/MANAGER to cash-management if no session, sales if session exists
5. All components share consistent session state via `useCashSession()`
6. No regressions in existing functionality (offline, offline queue, existing reactive validations)

## Dependencies
- None (backend endpoint stable)
- Requires `useAuthStore` to have `storeId`/`registerId` populated (already done in Login)

## Rollback Plan
- Feature branch `feature/sprint-1-cash-session`
- Revert commits if issues; no DB migrations to roll back