const fs = require('fs');
let code = fs.readFileSync('pos-backend/src/main/java/com/company/pos/sales/domain/Sale.java', 'utf8');

code = code.replace(
    'private List<SaleItem> items = new ArrayList<>();', 
    'private List<SaleItem> items = new ArrayList<>();\n\n    @OneToMany(mappedBy = "sale", cascade = CascadeType.ALL, orphanRemoval = true)\n    private List<SalePayment> payments = new ArrayList<>();'
);

code = code.replace(
    'public void setItems(List<SaleItem> items) { this.items = items; }',
    'public void setItems(List<SaleItem> items) { this.items = items; }\n    public List<SalePayment> getPayments() { return payments; }\n    public void setPayments(List<SalePayment> payments) { this.payments = payments; }'
);

fs.writeFileSync('pos-backend/src/main/java/com/company/pos/sales/domain/Sale.java', code);
