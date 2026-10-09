#!/bin/bash
sed -i "1s|^|import { formatCurrency } from '../lib/formatters';\n|" pos-frontend/src/pages/Products.tsx
sed -i 's/\${product.basePrice}/{formatCurrency(product.basePrice)}/g' pos-frontend/src/pages/Products.tsx

