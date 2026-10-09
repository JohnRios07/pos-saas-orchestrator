#!/bin/bash

# Fix 1.1: Add GET /api/credit-notes/{code}
sed -i '/@GetMapping("\/{id}\/receipt\/pdf")/i \
    @GetMapping("/{code}")\
    public ResponseEntity<CreditNote> getCreditNoteByCode(@PathVariable String code) {\
        UUID currentTenantId = TenantContext.getTenantId();\
        CreditNote creditNote = creditNoteRepository.findByCodeAndTenantId(code, currentTenantId)\
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Credit note not found"));\
        return ResponseEntity.ok(creditNote);\
    }\
' src/main/java/com/company/pos/sales/infrastructure/rest/CreditNoteController.java

# Fix 1.2: Add GET /api/sales/{id}
sed -i '/@PostMapping("\/{id}\/refund")/i \
    @GetMapping("/{id}")\
    public ResponseEntity<Sale> getSaleById(@PathVariable UUID id) {\
        UUID currentTenantId = TenantContext.getTenantId();\
        Sale sale = saleRepository.findByIdAndTenantId(id, currentTenantId)\
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Sale not found"));\
        return ResponseEntity.ok(sale);\
    }\
' src/main/java/com/company/pos/sales/infrastructure/rest/SaleController.java

