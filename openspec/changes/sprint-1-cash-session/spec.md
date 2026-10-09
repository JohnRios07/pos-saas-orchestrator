# Specification: Sprint 1 - Cash Session Resilience & Validation

## Change ID
`sprint-1-cash-session`

## Functional Requirements

### FR-01: useCashSession Hook
**FR-01.1** The hook SHALL fetch `/api/cash/sessions/active?storeId={storeId}&registerId={registerId}` when both `storeId` and `registerId` are available in auth store.

**FR-01.2** The hook SHALL return `{ session, loading, error, isNetworkError }` where:
- `session: CashSession | null` - null means legitimately no active session
- `loading: boolean` - true during fetch or waiting for storeId/registerId
- `error: string | null` - user-friendly error message for network/param failures
- `isNetworkError: boolean` - true for network failures, false for "no session"

**FR-01.3** The hook SHALL treat backend 500 with message containing "No active cash session" as `session = null` (not error).

**FR-01.4** The hook SHALL treat network errors (TypeError, offline) as `isNetworkError = true`, `error = "Error de conexión. Verifique su red."`

**FR-01.5** The hook SHALL treat 400/422 (missing params) as `isNetworkError = false`, `error = "Configuración incompleta. Recargue la página."`

**FR-01.6** The hook SHALL memoize result and not re-fetch unless storeId/registerId change.

**FR-01.7** The hook SHALL integrate with offline queue: if offline and mutation pending, return cached session.

### FR-02: CashManagement.tsx - Resilient Session Display (#22)
**FR-02.1** Component SHALL use `useCashSession()` hook.

**FR-02.2** WHEN `loading = true` → SHOW "Cargando estado de caja..."

**FR-02.3** WHEN `isNetworkError = true` OR `error ≠ null` → SHOW error banner: "⚠️ {error}" with "Reintentar" button that re-triggers fetch.

**FR-02.4** WHEN `session === null` AND `!loading` AND `!error` → SHOW "Caja Cerrada" empty state with "Abrir Turno" form (current behavior).

**FR-02.5** WHEN `session !== null` → SHOW open session UI (current behavior).

**FR-02.6** "Reintentar" button SHALL call hook's refetch function.

### FR-03: Sales.tsx - Proactive Validation on Mount (#23)
**FR-03.1** Component SHALL use `useCashSession()` in a `useEffect` on mount.

**FR-03.2** WHEN `loading = true` → SHOW full-page loading spinner, DISABLE all interactions.

**FR-03.3** WHEN `session === null` AND `!loading` AND `!error` → SHOW blocking banner at top:
```
┌─────────────────────────────────────────────────────┐
│ 🔴 CAJA CERRADA - No hay turno de caja abierto      │
│ Para operar en el Punto de Venta, primero abra un   │
│ turno en Gestión de Caja.                           │
│ [ Ir a Gestión de Caja ]                            │
└─────────────────────────────────────────────────────┘
```
- Banner SHALL be prominent (red background, fixed top, full width)
- Button SHALL navigate to `/cash-management`
- Product selection, variant, quantity, cart SHALL be DISABLED (opacity-50, pointer-events-none)
- "Cobrar" button SHALL be DISABLED

**FR-03.4** WHEN `session !== null` → SHOW normal POS UI (current behavior).

**FR-03.5** WHEN `isNetworkError = true` OR `error ≠ null` → SHOW error banner (same as FR-02.3), allow UI interaction but keep reactive payment validation as safety net.

**FR-03.6** Existing reactive "Caja Cerrada" popup on payment attempt SHALL REMAIN as fallback.

### FR-04: SalesHistory.tsx - Block Returns Without Session (#26)
**FR-04.1** Component SHALL use `useCashSession()` hook.

**FR-04.2** WHEN `session !== null` → RENDER "Devolver" button normally (current behavior).

**FR-04.3** WHEN `session === null` AND `!loading` AND `!error` → RENDER "Devolver" button as DISABLED with:
- `disabled={true}`
- `title="No hay turno de caja abierto. Abra caja en Gestión de Caja antes de procesar devoluciones"`
- Visual: grayed out, tooltip on hover
- Click SHALL show toast: "No hay turno de caja abierto. Abra caja en Gestión de Caja antes de procesar devoluciones"

**FR-04.4** WHEN `loading = true` → RENDER "Devolver" as disabled with loading spinner.

**FR-04.5** WHEN `isNetworkError = true` OR `error ≠ null` → RENDER "Devolver" normally (allow click, let backend validate), show error banner at top of page.

### FR-05: Login.tsx - Smart Post-Login Redirect (#28)
**FR-05.1** After successful authentication AND config fetch (`/api/config/initial`), component SHALL fetch cash session via direct `apiFetch('/cash/sessions/active?storeId=...')` (not hook - one-time check).

**FR-05.2** During cash session check → SHOW "Verificando estado de caja..." below login button.

**FR-05.3** Redirect logic for roles `CASHIER` and `MANAGER`:
- IF cash session exists (response has `id`) → `navigate('/sales')`
- IF no cash session (404/500 with "no active session" OR null) → `navigate('/cash-management')`
- IF network error → `navigate('/sales')` (fail-open, let proactive validation catch it)

**FR-05.4** For role `ADMIN` → always `navigate('/dashboard')` (unchanged).

**FR-05.5** Errors during cash session check SHALL NOT block login; default to `/sales` for CASHIER/MANAGER.

## Non-Functional Requirements

**NFR-01** All new code SHALL follow existing TypeScript/React patterns in codebase (hooks, zustand, apiFetch).

**NFR-02** No new dependencies SHALL be added.

**NFR-03** Components SHALL maintain backward compatibility with offline mode (IndexedDB cache).

**NFR-04** Error messages SHALL be in Spanish (consistent with codebase).

**NFR-05** No breaking changes to existing API contracts.

## Scenarios

### Scenario 1: Cashier logs in, no open cash session
1. Cashier enters credentials → submits login
2. Auth succeeds → config fetched (storeId, registerId stored)
3. Cash session check → no active session
4. Redirect to `/cash-management`
5. CashManagement shows "Caja Cerrada" with "Abrir Turno" form
6. Cashier opens session → redirected to `/sales` (via existing logic or manual nav)
7. Sales shows normal POS UI

### Scenario 2: Cashier logs in, cash session already open
1. Cashier logs in → config fetched
2. Cash session check → active session found
3. Redirect to `/sales`
4. Sales mounts → `useCashSession` returns session → normal UI

### Scenario 3: Cashier in Sales, session closed by another user
1. Cashier has Sales open with active session
2. Manager closes session from CashManagement
3. Cashier tries to add item → proactive validation doesn't catch (session was valid on mount)
4. Cashier clicks "Cobrar" → reactive popup "Caja Cerrada" appears → navigates to CashManagement
5. **Acceptable**: reactive fallback handles this edge case

### Scenario 4: Network error in CashManagement
1. Cashier opens CashManagement
2. Network fails → `isNetworkError = true`
3. Shows "⚠️ Error de conexión. Verifique su red. [Reintentar]"
4. Cashier clicks "Reintentar" → fetch retries
5. On success → shows correct state

### Scenario 5: Manager attempts return in SalesHistory with closed cash
1. Manager opens SalesHistory
2. `useCashSession` returns `session = null`
3. "Devolver" buttons show disabled with tooltip
4. Manager hovers → sees "No hay turno de caja abierto. Abra caja en Gestión de Caja antes de procesar devoluciones"
5. Manager clicks → toast shows same message, no navigation

### Scenario 6: Missing storeId/registerId (fresh login, config not loaded)
1. Component mounts before auth store hydrated
2. `useCashSession` waits for both IDs → `loading = true`
3. Shows loading state
4. Once IDs available → fetches session

## Edge Cases Handled
- Backend returns 500 for "not found" → treated as `session = null`
- Offline mode → hook returns cached session if available
- storeId/registerId null → loading until available
- Race conditions → hook memoization prevents duplicate fetches

## Out of Scope
- Backend changes to return 404 instead of 500 for no session
- WebSocket/push notifications for session changes
- Auto-refresh of session state (manual refresh via "Reintentar" or page navigation)