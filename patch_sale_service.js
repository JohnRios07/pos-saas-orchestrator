const fs = require('fs');
let code = fs.readFileSync('pos-backend/src/main/java/com/company/pos/sales/application/SaleService.java', 'utf8');

// Add CashService to imports
code = code.replace("import com.company.pos.sales.domain.Sale;", "import com.company.pos.cash.application.CashService;\nimport com.company.pos.cash.domain.CashSession;\nimport com.company.pos.sales.domain.Sale;");

// Add CashService to constructor
code = code.replace("private final ProductVariantRepository variantRepository;", "private final ProductVariantRepository variantRepository;\n    private final CashService cashService;");
code = code.replace("public SaleService(SaleRepository saleRepository, InventoryService inventoryService, ProductVariantRepository variantRepository) {", "public SaleService(SaleRepository saleRepository, InventoryService inventoryService, ProductVariantRepository variantRepository, CashService cashService) {");
code = code.replace("this.variantRepository = variantRepository;\n    }", "this.variantRepository = variantRepository;\n        this.cashService = cashService;\n    }");

// In createSale, check cash session and record transaction
const verifySessionStr = `
        // Verify Cash Register is Open
        CashSession activeSession = cashService.getActiveSessionByStore(sale.getStoreId());
`;
code = code.replace("        sale.setTenantId(tenantId);", "        sale.setTenantId(tenantId);\n" + verifySessionStr);

const recordTransactionStr = `
        // Record Cash Transaction
        cashService.registerTransaction(
                activeSession.getId(),
                "IN",
                savedSale.getTotal(),
                "Venta #" + savedSale.getId(),
                "SALE",
                savedSale.getId(),
                savedSale.getCreatedBy()
        );
`;
code = code.replace("        return savedSale;", recordTransactionStr + "\n        return savedSale;");

fs.writeFileSync('pos-backend/src/main/java/com/company/pos/sales/application/SaleService.java', code);
