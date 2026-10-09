const fs = require('fs');
let code = fs.readFileSync('pos-frontend/src/pages/Sales.tsx', 'utf8');

code = code.replace(/    \} catch \(err\) \{\n      console\.error\(err\);\n      setError\('Error al procesar la venta'\);\n    \} finally \{/g, `    } catch (err: any) {\n      console.error(err);\n      setError(err.message || 'Error al procesar la venta');\n    } finally {`);

fs.writeFileSync('pos-frontend/src/pages/Sales.tsx', code);
