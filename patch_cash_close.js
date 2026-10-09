const fs = require('fs');
let code = fs.readFileSync('pos-frontend/src/pages/CashManagement.tsx', 'utf8');

const closeLogic = `      const res = await apiFetch(\`/cash/sessions/\${session.id}/close\`, {
        method: 'POST',
        body: JSON.stringify({
          actualBalance: Number(actualBalance)
        })
      });
      
      const expected = res.closingBalanceExpected;
      const actual = res.closingBalanceActual;
      const diff = actual - expected;
      
      let msg = 'Turno cerrado con éxito.\\n\\nResumen:';
      msg += \`\\nEsperado en sistema: $\${expected}\`;
      msg += \`\\nDinero contado: $\${actual}\`;
      
      if (diff > 0) {
        msg += \`\\n\\n⚠️ ¡SOBRANTE de dinero!: $\${diff}\`;
      } else if (diff < 0) {
        msg += \`\\n\\n⚠️ ¡FALTANTE de dinero!: $\${Math.abs(diff)}\`;
      } else {
        msg += \`\\n\\n✅ Caja cuadrada perfectamente.\`;
      }
      
      alert(msg);
      
      await fetchActiveSession();`;

code = code.replace(/await apiFetch\(`\/cash\/sessions\/\$\{session.id\}\/close`, \{\n        method: 'POST',\n        body: JSON.stringify\(\{\n          actualBalance: Number\(actualBalance\)\n        \}\)\n      \}\);\n      await fetchActiveSession\(\);/g, closeLogic);

fs.writeFileSync('pos-frontend/src/pages/CashManagement.tsx', code);
