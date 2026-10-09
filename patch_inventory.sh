#!/bin/bash
cd pos-frontend/src/pages

cat << 'INNEREOF' > patch.cjs
const fs = require('fs');

let content = fs.readFileSync('Inventory.tsx', 'utf8');

const interfaceAdds = `
interface Product {
  id: string;
  name: string;
  basePrice: number;
}
interface Variant {
  id: string;
  sku: string;
  size: string;
  color: string;
  price: number;
}
`;

content = content.replace("interface InventoryItem {", interfaceAdds + "interface InventoryItem {");

const stateAdds = `
  const [products, setProducts] = useState<Product[]>([]);
  const [variants, setVariants] = useState<Variant[]>([]);
  const [initProductId, setInitProductId] = useState<string>('');
`;

content = content.replace("const [initVariantId, setInitVariantId] = useState('');", stateAdds + "  const [initVariantId, setInitVariantId] = useState('');");


const fetchLogic = `
  useEffect(() => {
    fetchProducts();
  }, []);

  const fetchProducts = async () => {
    try {
      const data = await apiFetch('/catalog/products');
      setProducts(data);
    } catch (err) {
      console.error(err);
    }
  };

  const handleProductChange = async (e: React.ChangeEvent<HTMLSelectElement>) => {
    const productId = e.target.value;
    setInitProductId(productId);
    setInitVariantId('');
    try {
      const data = await apiFetch(\`/catalog/products/\${productId}/variants\`);
      setVariants(data);
    } catch (err) {
      console.error(err);
    }
  };
`;

content = content.replace("const handleInitStock = async", fetchLogic + "\n  const handleInitStock = async");


const uiReplaceStart = `          <div>
            <label className="block text-sm font-medium text-gray-700">Variant ID</label>
            <input
              type="text"
              required
              value={initVariantId}
              onChange={(e) => setInitVariantId(e.target.value)}
              className="mt-1 block border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm border p-2 w-64"
            />
          </div>`;

const uiReplacement = `          <div>
            <label className="block text-sm font-medium text-gray-700">Producto</label>
            <select
              required
              value={initProductId}
              onChange={handleProductChange}
              className="mt-1 block border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm border p-2 w-48"
            >
              <option value="" disabled>Seleccione un producto</option>
              {products.map(p => (
                <option key={p.id} value={p.id}>{p.name}</option>
              ))}
            </select>
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700">Variante</label>
            <select
              required
              value={initVariantId}
              onChange={(e) => setInitVariantId(e.target.value)}
              disabled={!initProductId || variants.length === 0}
              className="mt-1 block border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm border p-2 w-48 disabled:bg-gray-100"
            >
              <option value="" disabled>{!initProductId ? 'Elija un producto' : 'Seleccione una variante'}</option>
              {variants.map(v => (
                <option key={v.id} value={v.id}>{v.sku} - {v.color} {v.size}</option>
              ))}
            </select>
          </div>`;

content = content.replace(uiReplaceStart, uiReplacement);

fs.writeFileSync('Inventory.tsx', content);

INNEREOF

node patch.cjs
rm patch.cjs
