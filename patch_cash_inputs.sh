#!/bin/bash
cd pos-frontend/src/pages

sed -i "s/setOpeningBalance(Number(e.target.value))/setOpeningBalance(e.target.value ? Number(e.target.value) : '')/g" CashManagement.tsx
sed -i "s/setTransactionAmount(Number(e.target.value))/setTransactionAmount(e.target.value ? Number(e.target.value) : '')/g" CashManagement.tsx
sed -i "s/setActualBalance(Number(e.target.value))/setActualBalance(e.target.value ? Number(e.target.value) : '')/g" CashManagement.tsx

