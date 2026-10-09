#!/bin/bash
cd pos-frontend/src/pages

cat << 'INNEREOF' > patch.cjs
const fs = require('fs');

let content = fs.readFileSync('Inventory.tsx', 'utf8');

const interfaceAdds = `
interface InventoryItem {
  id: string;
  storeId: string;
  variantId: string;
  productName: string;
  sku: string;
  color: string;
  size: string;
  quantity: number;
`;

content = content.replace(/interface InventoryItem \{\s+id: string;\s+storeId: string;\s+variantId: string;\s+quantity: number;/g, interfaceAdds);


const tableHead = `            <thead className="bg-gray-50">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Producto</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">SKU</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Variante</th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Stock</th>`;

content = content.replace(/<thead className="bg-gray-50">[\s\S]*?<th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Stock<\/th>/g, tableHead);

const tableRow = `                <tr key={item.id}>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900 font-medium">{item.productName || 'Desconocido'}</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{item.sku}</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{item.color} {item.size}</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm font-bold text-gray-900">{item.quantity}</td>`;

content = content.replace(/<tr key={item\.id}>\s*<td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{item\.id}<\/td>\s*<td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{item\.variantId}<\/td>\s*<td className="px-6 py-4 whitespace-nowrap text-sm font-bold text-gray-900">{item\.quantity}<\/td>/g, tableRow);

fs.writeFileSync('Inventory.tsx', content);

INNEREOF

node patch.cjs
rm patch.cjs
