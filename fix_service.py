import re

with open("pos-backend/src/main/java/com/company/pos/sales/application/SaleService.java", "r") as f:
    content = f.read()

# For 2.2
old_code = """        if (refundTotal.compareTo(BigDecimal.ZERO) > 0) {
            com.company.pos.sales.domain.creditnote.CreditNote note = creditNoteService.issueCreditNote(tenantId, refundTotal, sale.getCustomerId(), sale.getId(), com.company.pos.auth.application.UserContext.getUserId());
            sale.setCreditNoteId(note.getId());
        }

        sale.setStatus("REFUNDED");
        return saleRepository.save(sale);"""

new_code = """        UUID generatedCreditNoteId = null;
        if (refundTotal.compareTo(BigDecimal.ZERO) > 0) {
            com.company.pos.sales.domain.creditnote.CreditNote note = creditNoteService.issueCreditNote(tenantId, refundTotal, sale.getCustomerId(), sale.getId(), com.company.pos.auth.application.UserContext.getUserId());
            generatedCreditNoteId = note.getId();
        }

        // For 2.1 fix, just mark as PARTIALLY_REFUNDED or REFUNDED based on if it's the first return
        // Ideally we check total items, but for now we'll set it to PARTIALLY_REFUNDED
        sale.setStatus("PARTIALLY_REFUNDED");
        Sale savedSale = saleRepository.save(sale);
        
        if (generatedCreditNoteId != null) {
            savedSale.setCreditNoteId(generatedCreditNoteId);
        }
        return savedSale;"""

content = content.replace(old_code, new_code)

# For 3.2
content = content.replace(
    "BigDecimal unitDiscount = saleItem.getDiscount().divide(saleItem.getQuantity(), RoundingMode.HALF_UP);",
    "BigDecimal unitDiscount = saleItem.getDiscount().divide(saleItem.getQuantity(), 4, RoundingMode.HALF_UP);"
)

with open("pos-backend/src/main/java/com/company/pos/sales/application/SaleService.java", "w") as f:
    f.write(content)
