const fs = require('fs');
let code = fs.readFileSync('pos-backend/src/main/java/com/company/pos/cash/application/CashService.java', 'utf8');

code = code.replace(
    'public CashSession closeSession(UUID sessionId, BigDecimal actualBalance, UUID userId) {',
    'public CashSession closeSession(UUID sessionId, BigDecimal actualBalance, String closingNotes) {'
);

code = code.replace(
    'session.setClosedBy(userId);',
    'session.setClosedBy(com.company.pos.auth.application.UserContext.getUserId());\n        session.setClosingNotes(closingNotes);'
);

const forceNotesIfDiscrepancy = `
        if (expectedBalance.compareTo(actualBalance) != 0 && (closingNotes == null || closingNotes.trim().isEmpty())) {
            throw new IllegalArgumentException("DIFERENCIA: El sistema esperaba $" + expectedBalance + ". Debe proveer una observación para justificar la diferencia.");
        }
        
        session.setStatus("CLOSED");
`;
code = code.replace(
    'session.setStatus("CLOSED");',
    forceNotesIfDiscrepancy.trim()
);

fs.writeFileSync('pos-backend/src/main/java/com/company/pos/cash/application/CashService.java', code);
