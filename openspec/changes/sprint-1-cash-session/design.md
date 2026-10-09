# Design: Sprint 1 - Cash Session Resilience & Validation

## Change ID
`sprint-1-cash-session`

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        useCashSession Hook                      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐  │
│  │ Auth Store   │──▶│ Hydration    │──▶│ apiFetch             │  │
│  │ (storeId,    │   │ Wait for     │   │ /cash/sessions/active│  │
│  │  registerId) │   │ both IDs     │   │                      │  │
│  └──────────────┘   └──────────────┘   └──────────┬───────────┘  │
│                                                  │              │
│                          ┌───────────────────────┘              │
│                          ▼                                      │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ Response Classification                                  │  │
│  │ • 200 + data.id → session = data                        │  │
│  │ • 500 + "No active cash session" → session = null       │  │
│  │ • Network Error (TypeError) → isNetworkError = true     │  │
│  │ • 400/422 → error = "Configuración incompleta"          │  │
│  │ • Other → error = backend message                       │  │
│  └──────────────────────────────────────────────────────────┘  │
│                          │                                      │
│                          ▼                                      │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ Return: { session, loading, error, isNetworkError,       │  │
│  │          refetch }                                       │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
         │                    │                    │
         ▼                    ▼                    ▼
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
│ CashManagement  │ │ Sales           │ │ SalesHistory    │
│ (FR-02)         │ │ (FR-03)         │ │ (FR-04)         │
└─────────────────┘ └─────────────────┘ └─────────────────┘
         │                                        
         ▼                                        
┌─────────────────┐                             
│ Login           │                             
│ (FR-05)         │  Uses direct apiFetch      
│                 │  (one-time, no hook)       
└─────────────────┘                             
```

## Component Design

### 1. New Hook: `src/hooks/useCashSession.ts`

```typescript
interface CashSession {
  id: string;
  storeId: string;
  registerId: string;
  openedAt: string;
  openingBalance: number;
  status: string;
}

interface UseCashSessionReturn {
  session: CashSession | null;
  loading: boolean;
  error: string | null;
  isNetworkError: boolean;
  refetch: () => Promise<void>;
}

function useCashSession(): UseCashSessionReturn
```

**Implementation Details:**
- Uses `useAuthStore` selector for `storeId`, `registerId`
- `useEffect` with `[storeId, registerId]` dependency
- Waits for both IDs (not null/undefined) before fetching
- `apiFetch` with `GET /cash/sessions/active?storeId=...&registerId=...`
- Response classifier:
  ```typescript
  if (err instanceof TypeError) → network error
  else if (err.message?.includes('No active cash session')) → no session (null)
  else if (err.message?.includes('400') || err.message?.includes('422')) → config error
  else → generic error
  ```
- Memoization via `useRef` for last fetch params
- `refetch` function clears memo and re-triggers effect

### 2. CashManagement.tsx Modifications

**Current State Machine:**
```
loading → (success + data) → session UI
loading → (success + null) → "Caja Cerrada" form
loading → (error) → "Caja Cerrada" form  ← BUG: silent error
```

**New State Machine:**
```
loading → (session) → session UI
loading → (null, no error) → "Caja Cerrada" form
loading → (null, error) → Error Banner + "Reintentar"
loading → (network error) → Error Banner + "Reintentar"
```

**UI Changes:**
- Add error banner component (reusable inline)
- "Reintentar" button calls `refetch()`
- Keep existing session UI and form unchanged

### 3. Sales.tsx Modifications

**New Mount Validation Flow:**
```
Mount → useCashSession()
  → loading: show full-page spinner, disable all
  → session: normal POS UI
  → null + no error: Blocking Banner + disabled UI
  → error/network: Error Banner + normal UI (reactive fallback active)
```

**Blocking Banner Component:**
```tsx
<div className="fixed top-0 left-0 right-0 z-50 bg-red-600 text-white p-4">
  <div className="max-w-7xl mx-auto flex items-center justify-between">
    <div className="flex items-center gap-3">
      <AlertCircle className="w-6 h-6" />
      <div>
        <p className="font-bold">CAJA CERRADA</p>
        <p className="text-sm opacity-90">No hay turno de caja abierto. Para operar en el Punto de Venta, primero abra un turno en Gestión de Caja.</p>
      </div>
    </div>
    <Button onClick={() => navigate('/cash-management')} variant="outline" className="bg-white text-red-600">
      Ir a Gestión de Caja
    </Button>
  </div>
</div>
```

**UI Disabling Strategy:**
- Wrap product selection, variant, quantity, cart in `<div className={session ? '' : 'opacity-50 pointer-events-none'}>`
- "Cobrar" button: `disabled={!session || loading}`

### 4. SalesHistory.tsx Modifications

**Devolver Button Logic:**
```tsx
const { session, loading, error, isNetworkError } = useCashSession();
const canRefund = session !== null && !loading;
const showRefundDisabled = !loading && session === null && !error;

{showRefundDisabled ? (
  <button
    disabled
    title="No hay turno de caja abierto. Abra caja en Gestión de Caja antes de procesar devoluciones"
    onClick={() => toast.error("No hay turno de caja abierto. Abra caja en Gestión de Caja antes de procesar devoluciones")}
    className="text-gray-400 cursor-not-allowed"
  >
    Devolver
  </button>
) : (
  <button
    onClick={() => setSaleToRefund(sale)}
    disabled={loading || !canRefund}
    className="text-red-600 hover:text-red-900 font-semibold"
  >
    Devolver
  </button>
)}
```

**Error Banner** (top of page, same pattern as CashManagement).

### 5. Login.tsx Modifications

**Post-Auth Flow:**
```typescript
const handleLogin = async (e) => {
  // ... existing auth + config fetch ...
  
  // NEW: Cash session check for CASHIER/MANAGER
  if (role === 'CASHIER' || role === 'MANAGER') {
    setCheckingCashSession(true);
    try {
      const session = await apiFetch(`/cash/sessions/active?storeId=${storeId}&registerId=${registerId}`);
      navigate(session?.id ? '/sales' : '/cash-management');
    } catch (err) {
      // Fail-open: network error → let Sales.tsx proactive validation handle it
      navigate('/sales');
    } finally {
      setCheckingCashSession(false);
    }
  } else {
    navigate('/dashboard');
  }
};
```

**UI Addition:**
```tsx
{checkingCashSession && (
  <p className="text-sm text-gray-500 text-center mt-2">Verificando estado de caja...</p>
)}
```

## Data Structures

### CashSession (from backend)
```typescript
interface CashSession {
  id: string;              // UUID
  storeId: string;         // UUID
  registerId: string;      // UUID
  openedAt: string;        // ISO datetime
  openingBalance: number;  // BigDecimal → number
  status: string;          // "OPEN" | "CLOSED"
  // ... other fields from backend
}
```

### Hook Internal State
```typescript
interface HookState {
  session: CashSession | null;
  loading: boolean;
  error: string | null;
  isNetworkError: boolean;
  lastFetchParams: { storeId: string; registerId: string } | null;
}
```

## Error Classification Logic

```typescript
function classifyError(err: unknown): { session: CashSession | null; error: string | null; isNetworkError: boolean } {
  // Network error (offline, DNS, etc.)
  if (err instanceof TypeError && err.message.includes('fetch')) {
    return { session: null, error: 'Error de conexión. Verifique su red.', isNetworkError: true };
  }
  
  // Backend error with message
  const msg = err instanceof Error ? err.message : String(err);
  
  // Backend quirk: throws 500 with "No active cash session found"
  if (msg.includes('No active cash session')) {
    return { session: null, error: null, isNetworkError: false };
  }
  
  // 400/422 - missing params
  if (msg.includes('400') || msg.includes('422')) {
    return { session: null, error: 'Configuración incompleta. Recargue la página.', isNetworkError: false };
  }
  
  // Generic backend error
  return { session: null, error: msg || 'Error desconocido', isNetworkError: false };
}
```

## Integration Points

| Component | Hook Usage | Direct apiFetch |
|-----------|------------|-----------------|
| CashManagement | ✅ Primary | ❌ |
| Sales | ✅ Primary | ❌ |
| SalesHistory | ✅ Primary | ❌ |
| Login | ❌ | ✅ One-time post-auth |

## Offline Mode Considerations

- `useCashSession` respects `apiFetch` offline queue
- If offline and GET queued → returns cached session from IndexedDB (via `apiFetch` logic)
- Mutations (open/close session) queued normally
- No special offline handling needed beyond existing `apiFetch` behavior

## Testing Strategy

### Unit Tests (Vitest + RTL)
1. `useCashSession` - mock `apiFetch`, test all classification branches
2. `CashManagement` - render with each hook state
3. `Sales` - mount with each hook state, verify UI disabled/enabled
4. `SalesHistory` - render "Devolver" button states
5. `Login` - mock post-auth redirect logic

### Integration Scenarios
1. Full login → cash check → redirect flow
2. Sales mount → no session → banner → navigate → open session → return → POS works
3. Network error in CashManagement → retry → success

## File Changes Summary

| File | Change Type | Description |
|------|-------------|-------------|
| `src/hooks/useCashSession.ts` | NEW | Reusable hook for cash session state |
| `src/pages/CashManagement.tsx` | MODIFY | Use hook, add error banner + retry |
| `src/pages/Sales.tsx` | MODIFY | Add proactive validation banner, disable UI |
| `src/pages/SalesHistory.tsx` | MODIFY | Conditional "Devolver" button, error banner |
| `src/pages/Login.tsx` | MODIFY | Post-auth cash session check + redirect |

## Backward Compatibility

- No API changes
- No breaking changes to existing components
- Reactive validations in Sales/SalesHistory remain as safety nets
- Offline mode unchanged

## Performance

- Hook memoizes by `storeId+registerId` - single fetch per session
- Components re-render only when hook state changes
- No polling - fetch on mount and on `refetch()` only