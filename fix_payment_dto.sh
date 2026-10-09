#!/bin/bash
sed -i 's/method: string;/paymentMethod: string;/g' pos-frontend/src/pages/Dashboard.tsx
sed -i 's/amount: number;/total: number;/g' pos-frontend/src/pages/Dashboard.tsx

sed -i 's/item.method/item.paymentMethod/g' pos-frontend/src/pages/Dashboard.tsx
sed -i 's/item.amount/item.total/g' pos-frontend/src/pages/Dashboard.tsx

