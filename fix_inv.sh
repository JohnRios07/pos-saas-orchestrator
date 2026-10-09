#!/bin/bash
sed -i "1s|^|import { formatCurrency } from '../lib/formatters';\n|" pos-frontend/src/pages/Inventory.tsx
sed -i 's/\${item.averageCost}/{formatCurrency(item.averageCost)}/g' pos-frontend/src/pages/Inventory.tsx
