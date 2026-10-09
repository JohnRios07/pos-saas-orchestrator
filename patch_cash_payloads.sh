#!/bin/bash
cd pos-frontend/src/pages

sed -i "s/openingBalance/openingBalance: Number(openingBalance)/g" CashManagement.tsx
sed -i "s/amount: transactionAmount/amount: Number(transactionAmount)/g" CashManagement.tsx
sed -i "s/actualBalance/actualBalance: Number(actualBalance)/g" CashManagement.tsx

