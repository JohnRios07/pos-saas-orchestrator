#!/bin/bash
sed -i "1s|^|import { formatCurrency } from '../lib/formatters';\n|" pos-frontend/src/pages/CashManagement.tsx

sed -i 's/\\${session.openingBalance}/{formatCurrency(session.openingBalance)}/g' pos-frontend/src/pages/CashManagement.tsx

sed -i 's/\${expected}/${formatCurrency(expected)}/g' pos-frontend/src/pages/CashManagement.tsx
sed -i 's/\${actual}/${formatCurrency(actual)}/g' pos-frontend/src/pages/CashManagement.tsx
sed -i 's/\${diff}/${formatCurrency(diff)}/g' pos-frontend/src/pages/CashManagement.tsx
sed -i 's/\${Math.abs(diff)}/${formatCurrency(Math.abs(diff))}/g' pos-frontend/src/pages/CashManagement.tsx

