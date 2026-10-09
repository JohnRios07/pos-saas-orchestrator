const fs = require('fs');
let code = fs.readFileSync('pos-backend/src/main/java/com/company/pos/sales/application/SaleService.java', 'utf8');

// Add import
code = code.replace("import com.company.pos.sales.domain.SaleItem;", "import com.company.pos.sales.domain.SaleItem;\nimport com.company.pos.sales.domain.SalePayment;");

const recordTransactionStr = `
        // Record Payments and Cash Transactions
        if (savedSale.getPayments() != null) {
            for (SalePayment payment : savedSale.getPayments()) {
                if ("CASH".equals(payment.getPaymentMethod())) {
                    cashService.registerTransaction(
                            activeSession.getId(),
                            "IN",
                            payment.getAmount(),
                            "Pago en Efectivo - Venta #" + savedSale.getId(),
                            "SALE",
                            savedSale.getId(),
                            savedSale.getCreatedBy()
                    );
                }
            }
        }
`;

// Replace the old transaction
code = code.replace(/        \/\/ Record Cash Transaction[\s\S]*?savedSale\.getCreatedBy\(\)\n        \);/g, recordTransactionStr.trim());

// Also iterate payments and link to sale before saving
code = code.replace("        sale.setTotal(subtotal.subtract(totalDiscount));", `        sale.setTotal(subtotal.subtract(totalDiscount));\n\n        if (sale.getPayments() != null) {\n            for (SalePayment p : sale.getPayments()) {\n                p.setSale(sale);\n                p.setTenantId(tenantId);\n            }\n        }`);

fs.writeFileSync('pos-backend/src/main/java/com/company/pos/sales/application/SaleService.java', code);
