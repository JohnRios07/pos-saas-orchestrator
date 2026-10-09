const fs = require('fs');
let code = fs.readFileSync('pos-frontend/src/pages/CashManagement.tsx', 'utf8');

// 1. Change useState
code = code.replace(/useState<number>\(0\)/g, "useState<number | ''>('')");

// 2. Change onChange inputs
code = code.replace(/setOpeningBalance\(Number\(e.target.value\)\)/g, "setOpeningBalance(e.target.value ? Number(e.target.value) : '')");
code = code.replace(/setTransactionAmount\(Number\(e.target.value\)\)/g, "setTransactionAmount(e.target.value ? Number(e.target.value) : '')");
code = code.replace(/setActualBalance\(Number\(e.target.value\)\)/g, "setActualBalance(e.target.value ? Number(e.target.value) : '')");

// 3. Change payloads to ensure Numbers
code = code.replace(/openingBalance\n/g, "openingBalance: Number(openingBalance)\n");
code = code.replace(/amount: transactionAmount/g, "amount: Number(transactionAmount)");
code = code.replace(/actualBalance\n/g, "actualBalance: Number(actualBalance)\n");

fs.writeFileSync('pos-frontend/src/pages/CashManagement.tsx', code);
