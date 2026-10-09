const fs = require('fs');
let code = fs.readFileSync('pos-backend/src/main/java/com/company/pos/cash/domain/CashSession.java', 'utf8');

code = code.replace(
    'private BigDecimal closingBalanceActual;',
    'private BigDecimal closingBalanceActual;\n\n    @Column(name = "closing_notes")\n    private String closingNotes;'
);

code = code.replace(
    'public void setClosingBalanceActual(BigDecimal closingBalanceActual) { this.closingBalanceActual = closingBalanceActual; }',
    'public void setClosingBalanceActual(BigDecimal closingBalanceActual) { this.closingBalanceActual = closingBalanceActual; }\n    public String getClosingNotes() { return closingNotes; }\n    public void setClosingNotes(String closingNotes) { this.closingNotes = closingNotes; }'
);

fs.writeFileSync('pos-backend/src/main/java/com/company/pos/cash/domain/CashSession.java', code);
