const fs = require('fs');
let code = fs.readFileSync('pos-backend/src/main/java/com/company/pos/cash/infrastructure/rest/CashController.java', 'utf8');

code = code.replace(
    'public CashSession closeSession(@PathVariable UUID id, @RequestBody CloseSessionRequest request) {',
    'public CashSession closeSession(@PathVariable UUID id, @RequestBody CloseSessionRequest request) {'
); // no change to signature

code = code.replace(
    'return cashService.closeSession(id, request.actualBalance(), request.userId());',
    'return cashService.closeSession(id, request.actualBalance(), request.closingNotes());'
); // CashService needs updating too, userId is read from UserContext now

code = code.replace(
    'public record CloseSessionRequest(BigDecimal actualBalance, UUID userId) {}',
    'public record CloseSessionRequest(BigDecimal actualBalance, String closingNotes) {}'
);

fs.writeFileSync('pos-backend/src/main/java/com/company/pos/cash/infrastructure/rest/CashController.java', code);
