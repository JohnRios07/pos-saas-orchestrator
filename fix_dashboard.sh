#!/bin/bash
sed -i 's/totalSales: number;/totalSalesToday: number;/g' pos-frontend/src/pages/Dashboard.tsx
sed -i 's/averageTicket: number;/averageTicketToday: number;/g' pos-frontend/src/pages/Dashboard.tsx
sed -i 's/salesByPaymentMethod: PaymentMethodBreakdown\[\];/paymentMethodTotals: PaymentMethodBreakdown\[\];/g' pos-frontend/src/pages/Dashboard.tsx

sed -i 's/data.totalSales/data.totalSalesToday/g' pos-frontend/src/pages/Dashboard.tsx
sed -i 's/data.averageTicket/data.averageTicketToday/g' pos-frontend/src/pages/Dashboard.tsx
sed -i 's/data.salesByPaymentMethod/data.paymentMethodTotals/g' pos-frontend/src/pages/Dashboard.tsx

