const fs = require('fs');

function patchSales() {
  let content = fs.readFileSync('pos-frontend/src/pages/Sales.tsx', 'utf8');
  content = content.replace('const [quantity, setQuantity] = useState<number>(1);', "const [quantity, setQuantity] = useState<number | ''>('');");
  content = content.replace('if (!selectedVariantId || quantity <= 0) return;', "if (!selectedVariantId || quantity === '' || quantity <= 0) return;");
  content = content.replace('value={quantity}', 'value={quantity}');
  content = content.replace('onChange={e => setQuantity(Number(e.target.value))}', "onChange={e => setQuantity(e.target.value === '' ? '' : Number(e.target.value))}");
  content = content.replace('setQuantity(1);', "setQuantity('');");
  fs.writeFileSync('pos-frontend/src/pages/Sales.tsx', content);
}

function patchPurchases() {
  let content = fs.readFileSync('pos-frontend/src/pages/Purchases.tsx', 'utf8');
  content = content.replace('const [quantity, setQuantity] = useState<number>(1);', "const [quantity, setQuantity] = useState<number | ''>('');");
  content = content.replace('const [unitCost, setUnitCost] = useState<number>(0);', "const [unitCost, setUnitCost] = useState<number | ''>('');");
  content = content.replace('if (!selectedVariantId || quantity <= 0 || unitCost < 0) return;', "if (!selectedVariantId || quantity === '' || unitCost === '' || quantity <= 0 || unitCost < 0) return;");
  content = content.replace('onChange={e => setQuantity(Number(e.target.value))}', "onChange={e => setQuantity(e.target.value === '' ? '' : Number(e.target.value))}");
  content = content.replace('onChange={e => setUnitCost(Number(e.target.value))}', "onChange={e => setUnitCost(e.target.value === '' ? '' : Number(e.target.value))}");
  content = content.replace('setQuantity(1);', "setQuantity('');");
  content = content.replace('setUnitCost(0);', "setUnitCost('');");
  fs.writeFileSync('pos-frontend/src/pages/Purchases.tsx', content);
}

patchSales();
patchPurchases();
