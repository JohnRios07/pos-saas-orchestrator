#!/bin/bash
sed -i 's/import org.junit.jupiter.api.AfterEach;/import org.springframework.transaction.annotation.Transactional;/g' pos-backend/src/test/java/com/company/pos/tenant/TenantIsolationIntegrationTest.java

sed -i '/@AfterEach/,/}/d' pos-backend/src/test/java/com/company/pos/tenant/TenantIsolationIntegrationTest.java

sed -i '/void shouldIsolateDataBetweenTenants() {/i \    @Transactional' pos-backend/src/test/java/com/company/pos/tenant/TenantIsolationIntegrationTest.java

