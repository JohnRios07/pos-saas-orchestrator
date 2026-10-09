# Tasks: Sprint 1 - Cash Session Resilience & Validation

## Change ID
`sprint-1-cash-session`

## Task Breakdown

### Phase 1: Foundation (Shared Hook)

#### TASK-001: Create `useCashSession` hook
**File:** `src/hooks/useCashSession.ts` (NEW)
**Priority:** P0 - Blocks all other tasks
**Estimate:** 2h

**Subtasks:**
- [x] Create `src/hooks/` directory if not exists
- [x] Define `CashSession` interface matching backend
- [x] Define `UseCashSessionReturn` interface
- [x] Implement hook with:
  - [x] `useAuthStore` selectors for `storeId`, `registerId`
  - [x] `useEffect` with `[storeId, registerId]` dependency
  - [x] Wait for both IDs before fetch (guard clause)
  - [x] `apiFetch` to `/cash/sessions/active?storeId=...&registerId=...`
  - [x] Error classification logic (network, no-session, config, generic)
  - [x] Memoization via `useRef` for last fetch params
  - [x] `refetch` function to clear memo and re-trigger
- [x] Export hook and types

**Acceptance Criteria:**
- Returns `{ session, loading, error, isNetworkError, refetch }`
- Correctly classifies backend 500 "No active cash session" as `session=null`
- Handles missing storeId/registerId gracefully (loading until available)
- Memoizes - no duplicate fetches for same params

---

### Phase 2: Component Updates

#### TASK-002: Update CashManagement.tsx (#22)
**File:** `src/pages/CashManagement.tsx`
**Priority:** P0
**Estimate:** 1.5h
**Depends on:** TASK-001

**Subtasks:**
- [x] Import `useCashSession` hook
- [x] Replace existing `fetchActiveSession` + state with hook
- [x] Update state machine:
  - [x] `loading` → "Cargando estado de caja..."
  - [x] `session` → existing session UI
  - [x] `null + no error` → existing "Caja Cerrada" form
  - [x] `error || isNetworkError` → **NEW** error banner with retry
- [x] Add error banner component (inline):
  ```tsx
  {error && (
    <div className="bg-red-50 text-red-700 p-3 rounded flex items-center justify-between">
      <span>⚠️ {error}</span>
      <button onClick={refetch} className="text-sm underline">Reintentar</button>
    </div>
  )}
  ```
- [x] Remove old `fetchActiveSession`, `loading`, `error`, `session` local state
- [x] Keep all existing functionality (open/close session, transactions, arqueo)

**Acceptance Criteria:**
- Network error shows banner (not "Caja Cerrada" form)
- "Reintentar" button re-fetches and updates UI
- Legitimate "no session" still shows "Abrir Turno" form
- All existing features work unchanged

---

#### TASK-003: Update Sales.tsx - Proactive Validation (#23)
**File:** `src/pages/Sales.tsx`
**Priority:** P0
**Estimate:** 2h
**Depends on:** TASK-001

**Subtasks:**
- [x] Import `useCashSession` hook
- [x] Add hook call at component top: `const { session, loading, error, isNetworkError } = useCashSession();`
- [x] Add blocking banner component (conditional render):
  ```tsx
  {session === null && !loading && !error && !isNetworkError && (
    <div className="fixed top-0 left-0 right-0 z-50 bg-red-600 text-white p-4">
      <div className="max-w-7xl mx-auto flex items-center justify-between">
        <div className="flex items-center gap-3">
          <AlertCircle className="w-6 h-6" />
          <div>
            <p className="font-bold">CAJA CERRADA</p>
            <p className="text-sm opacity-90">No hay turno de caja abierto. Para operar en el Punto de Venta, primero abra un turno en Gestión de Caja.</p>
          </div>
        </div>
        <button onClick={() => navigate('/cash-management')} className="bg-white text-red-600 px-4 py-2 rounded font-medium hover:bg-red-50">
          Ir a Gestión de Caja
        </button>
      </div>
    </div>
  )}
  ```
- [x] Add error banner for network/config errors (top of page, below blocking banner):
  ```tsx
  {(error || isNetworkError) && (
    <div className="bg-yellow-50 text-yellow-700 p-3 rounded mb-4 flex items-center justify-between">
      <span>⚠️ {error || 'Error de conexión. Verifique su red.'}</span>
    </div>
  )}
  ```
- [x] Wrap product selection panel in disabled wrapper when no session:
  ```tsx
  <div className={session ? '' : 'opacity-50 pointer-events-none'}>
    {/* existing product selection */}
  </div>
  ```
- [x] Wrap cart panel similarly
- [x] Disable "Cobrar" button when `!session || loading`: `disabled={!session || loading || ...existing conditions}`
- [x] Keep existing reactive "Caja Cerrada" popup (lines 575-601) as fallback
- [x] Add `AlertCircle` import from `lucide-react`

**Acceptance Criteria:**
- On mount with no session: shows blocking banner, disables product/cart UI
- "Ir a Gestión de Caja" navigates correctly
- Network error shows warning banner but allows interaction
- Reactive popup still works if user somehow bypasses proactive check
- No regression in existing POS flow

---

#### TASK-004: Update SalesHistory.tsx - Block Returns (#26)
**File:** `src/pages/SalesHistory.tsx`
**Priority:** P0
**Estimate:** 1.5h
**Depends on:** TASK-001

**Subtasks:**
- [x] Import `useCashSession` hook
- [x] Add hook call: `const { session, loading, error, isNetworkError } = useCashSession();`
- [x] Add error banner at top of component (after search, before table):
  ```tsx
  {(error || isNetworkError) && (
    <div className="bg-red-50 text-red-700 p-3 rounded mb-4">
      ⚠️ {error || 'Error de conexión. Verifique su red.'}
    </div>
  )}
  ```
- [x] Update "Devolver" button render logic (lines 227-232):
  ```tsx
  const canRefund = session !== null && !loading;
  const showDisabled = !loading && session === null && !error && !isNetworkError;
  
  {showDisabled ? (
    <button
      disabled
      title="No hay turno de caja abierto. Abra caja en Gestión de Caja antes de procesar devoluciones"
      onClick={() => toast.error("No hay turno de caja abierto. Abra caja en Gestión de Caja antes de procesar devoluciones")}
      className="text-gray-400 cursor-not-allowed font-semibold"
    >
      Devolver
    </button>
  ) : (
    <button
      onClick={() => setSaleToRefund(sale)}
      disabled={loading || !canRefund}
      className="text-red-600 hover:text-red-900 font-semibold"
    >
      {loading ? 'Verificando...' : 'Devolver'}
    </button>
  )}
  ```
- [x] Ensure loading state shows "Verificando..." on button

**Acceptance Criteria:**
- Active session → "Devolver" works normally
- No session → button disabled, grayed, tooltip + toast on click
- Loading → button disabled with "Verificando..."
- Network error → button works (backend validates), error banner shown

---

#### TASK-005: Update Login.tsx - Smart Redirect (#28)
**File:** `src/pages/Login.tsx`
**Priority:** P0
**Estimate:** 1h
**Depends on:** TASK-001 (for types, but uses direct apiFetch)

**Subtasks:**
- [x] Add state: `const [checkingCashSession, setCheckingCashSession] = useState(false);`
- [x] In `handleLogin`, after config fetch (line 44), add cash session check for CASHIER/MANAGER:
  ```typescript
  const role = useAuthStore.getState().role;
  if (role === 'CASHIER' || role === 'MANAGER') {
    setCheckingCashSession(true);
    try {
      const storeId = useAuthStore.getState().storeId;
      const registerId = useAuthStore.getState().registerId;
      if (storeId && registerId) {
        const session = await apiFetch(`/cash/sessions/active?storeId=${storeId}&registerId=${registerId}`);
        navigate(session?.id ? '/sales' : '/cash-management');
      } else {
        navigate('/sales'); // fail-open
      }
    } catch (err) {
      // Fail-open: network error → let Sales.tsx handle it
      navigate('/sales');
    } finally {
      setCheckingCashSession(false);
    }
  } else {
    navigate('/dashboard');
  }
  ```
- [x] Add UI indicator during check:
  ```tsx
  {checkingCashSession && (
    <p className="text-sm text-gray-500 text-center mt-2">Verificando estado de caja...</p>
  )}
  ```
- [x] Place after error display, before form or after submit button

**Acceptance Criteria:**
- CASHIER/MANAGER with open session → `/sales`
- CASHIER/MANAGER without session → `/cash-management`
- ADMIN → `/dashboard` (unchanged)
- Network error → `/sales` (fail-open)
- "Verificando estado de caja..." shows during check

---

### Phase 3: Verification

#### TASK-006: Manual Verification Checklist
**Priority:** P0
**Estimate:** 1h

**Test Scenarios:**
- [x] **Scenario 1:** Fresh login, no cash session → lands in CashManagement
- [x] **Scenario 2:** Fresh login, cash session open → lands in Sales
- [x] **Scenario 3:** In Sales, no session → blocking banner shows, UI disabled
- [x] **Scenario 4:** In Sales, network error → warning banner, UI works, reactive popup on pay
- [x] **Scenario 5:** CashManagement, network error → error banner + retry works
- [x] **Scenario 6:** CashManagement, no session → "Abrir Turno" form
- [x] **Scenario 7:** SalesHistory, no session → "Devolver" disabled + tooltip/toast
- [x] **Scenario 8:** SalesHistory, session open → "Devolver" works
- [x] **Scenario 9:** Offline mode - cached session shown, mutations queued
- [x] **Scenario 10:** Role ADMIN → always `/dashboard`

**Regression Checks:**
- [x] Existing CashManagement open/close/transactions work
- [x] Existing Sales flow (add to cart, pay, print) works
- [x] Existing SalesHistory refund flow works
- [x] Offline queue still functions
- [x] No TypeScript errors
- [x] No console errors in normal flows

---

#### TASK-007: Run Test Suite
**Priority:** P1
**Estimate:** 0.5h

**Commands:**
- [x] `cd pos-frontend && npm test -- --run` - Unit tests pass
- [x] `cd pos-frontend && npm run build` - Production build succeeds
- [x] `cd pos-backend && ./mvnw test` - Backend tests pass (no changes expected)

---

## Task Dependencies

```
TASK-001 (hook)
    │
    ├──▶ TASK-002 (CashManagement)
    ├──▶ TASK-003 (Sales)
    ├──▶ TASK-004 (SalesHistory)
    │
TASK-005 (Login) ──────▶ (uses apiFetch directly, but needs types from hook)
    │
    └──▶ TASK-006 (Verification) ◀── All component tasks
    │
    └──▶ TASK-007 (Test Suite)
```

## Parallel Execution

**Can run in parallel after TASK-001:**
- TASK-002, TASK-003, TASK-004, TASK-005

**Must run sequentially:**
- TASK-006 after all component tasks
- TASK-007 after TASK-006

## Total Estimated Effort: ~9.5 hours

## Definition of Done
- [x] All tasks completed
- [x] Manual verification checklist passed
- [x] Test suite passes
- [x] Build succeeds
- [x] Code follows project conventions (TypeScript, React, existing patterns)
- [x] No new dependencies added
- [x] Spanish error messages consistent
- [x] Feature branch created with descriptive commits