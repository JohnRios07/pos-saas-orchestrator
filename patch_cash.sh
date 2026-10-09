#!/bin/bash
cd pos-frontend/src/pages

sed -i "s/useState<number>(0)/useState<number | ''>('')/g" CashManagement.tsx
sed -i "s/value={openingBalance}/value={openingBalance}/g" CashManagement.tsx

