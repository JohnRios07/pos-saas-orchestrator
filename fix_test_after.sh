#!/bin/bash
sed -i 's/import org.springframework.transaction.annotation.Transactional;/import org.springframework.transaction.annotation.Transactional;\nimport org.junit.jupiter.api.AfterEach;/g' pos-backend/src/test/java/com/company/pos/tenant/TenantIsolationIntegrationTest.java

sed -i '/@Test/i \    @AfterEach\n    void tearDown() {\n        TenantContext.clear();\n    }\n' pos-backend/src/test/java/com/company/pos/tenant/TenantIsolationIntegrationTest.java

