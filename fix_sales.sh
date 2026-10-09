#!/bin/bash
sed -i "1s|^|import { formatCurrency } from '../lib/formatters';\n|" pos-frontend/src/pages/Sales.tsx

# Fix formatCurrency usages
sed -i 's/\\${item.unitPrice.toFixed(2)}/{formatCurrency(item.unitPrice)}/g' pos-frontend/src/pages/Sales.tsx
sed -i 's/\\${item.subtotal.toFixed(2)}/{formatCurrency(item.subtotal)}/g' pos-frontend/src/pages/Sales.tsx
sed -i 's/\\${cartSubtotal.toFixed(2)}/{formatCurrency(cartSubtotal)}/g' pos-frontend/src/pages/Sales.tsx
sed -i 's/\\${cartTotal.toFixed(2)}/{formatCurrency(cartTotal)}/g' pos-frontend/src/pages/Sales.tsx
sed -i 's/(\${v.price})/({formatCurrency(v.price)})/g' pos-frontend/src/pages/Sales.tsx

