#!/bin/bash
# Sales.tsx
sed -i 's/storeId: '\''22222222-2222-2222-2222-222222222222'\''/storeId: useAuthStore.getState().storeId/g' pos-frontend/src/pages/Sales.tsx
sed -i "1s|^|import { useAuthStore } from '../store/useAuthStore';\n|" pos-frontend/src/pages/Sales.tsx

# CashManagement.tsx
sed -i '/const STORE_ID = /d' pos-frontend/src/pages/CashManagement.tsx
sed -i '/const REGISTER_ID = /d' pos-frontend/src/pages/CashManagement.tsx
sed -i 's/STORE_ID/useAuthStore.getState().storeId/g' pos-frontend/src/pages/CashManagement.tsx
sed -i 's/REGISTER_ID/useAuthStore.getState().registerId/g' pos-frontend/src/pages/CashManagement.tsx
sed -i "1s|^|import { useAuthStore } from '../store/useAuthStore';\n|" pos-frontend/src/pages/CashManagement.tsx

# Inventory.tsx
sed -i 's/useState('\''22222222-2222-2222-2222-222222222222'\'')/useState(useAuthStore.getState().storeId)/g' pos-frontend/src/pages/Inventory.tsx
sed -i "1s|^|import { useAuthStore } from '../store/useAuthStore';\n|" pos-frontend/src/pages/Inventory.tsx
