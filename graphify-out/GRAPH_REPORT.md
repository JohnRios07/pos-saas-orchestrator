# Graph Report - pos  (2026-10-09)

## Corpus Check
- cluster-only mode — file stats not available

## Summary
- 2042 nodes · 5183 edges · 135 communities (37 shown, 98 thin omitted)
- Extraction: 84% EXTRACTED · 16% INFERRED · 0% AMBIGUOUS · INFERRED: 808 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- TenantReceiptSettings
- CashSessionContext.tsx
- VariantOption
- apiFetch
- ref_fs
- org.springframework.transaction.annotation.Transactional
- tenants
- useAuthStore.ts
- DashboardStatsDto
- Invoice
- list
- Customer
- KardexEntryDto
- package.json
- TenantContext
- react
- CashSession
- App.tsx
- User
- CashTransaction
- Sale
- org.junit.jupiter.api.Test
- CatalogService
- Brand
- InventoryResponseDto
- SaleItem
- local_dump.sql
- Product
- PurchasingServiceUnitTest.java
- JwtAuthenticationFilter.java
- .getTenantId
- CatalogController
- ProductVariant
- compilerOptions
- CashRegister
- .registerMovement
- PurchaseItem
- SaleItemResponseDto
- InventoryService.java
- Category
- Purchase
- PageResponse
- Inventory.tsx
- Supplier
- Inventory
- InventoryMovement
- ProductVariantsModal.tsx
- CreditNote
- dependencies
- devDependencies
- SaleController.java
- SecurityConfig.java
- KardexQueryRepositoryImpl.java
- VariantOptionController
- Store
- compilerOptions
- Override
- SalePayment
- .handleInventoryMovementEvent
- AuthService
- KardexEntryProjection
- SaleRepository
- CashController
- CustomerService
- MovementType
- .listSuppliers
- Tenant
- api.ts
- ResourceNotFoundException
- .updateMinStock
- org.springframework.http.ResponseEntity
- RefundItem
- CreditNoteController
- CashService
- CreditNoteStatus
- PosApplication.java
- PdfReceiptGenerator
- .oxlintrc.json
- DomainException
- bcryptpasswordencoder
- V6__create_cash_management_tables.sql
- V9__create_purchasing_tables.sql
- tsconfig.json
- backup.sh
- fix_cash.sh
- fix_dashboard.sh
- fix_endpoints.sh
- fix_inv.sh
- fix_login.sh
- fix_payment_dto.sh
- fix_products.sh
- fix_sales.sh
- fix_sales_tofixed.sh
- fix_test.sh
- fix_test_after.sh
- fix_uuids.sh
- patch_cash.sh
- patch_cash_inputs.sh
- patch_cash_payloads.sh
- patch_docs.sh
- patch_domain_userId.sh
- patch_inventory.sh
- patch_inventory_table.sh
- fix_sale.sh
- fix_script.sh
- fix_test.sh script
- RestClientCustomizer.java
- RestTemplateCustomizer.java
- update_components.sh

## God Nodes (most connected - your core abstractions)
1. `ProductVariant` - 72 edges
2. `Sale` - 67 edges
3. `Product` - 52 edges
4. `Store` - 52 edges
5. `CashSession` - 45 edges
6. `Purchase` - 41 edges
7. `KardexEntryDto` - 39 edges
8. `Customer` - 38 edges
9. `SaleItem` - 38 edges
10. `TenantReceiptSettings` - 37 edges

## Surprising Connections (you probably didn't know these)
- `TenantReceiptSettingsRepository` --references--> `TenantReceiptSettings`  [EXTRACTED]
  pos-backend/src/main/java/com/company/pos/tenant/domain/TenantReceiptSettingsRepository.java → pos-backend/src/main/java/com/company/pos/tenant/domain/TenantReceiptSettings.java
- `ReceiptSettingsController` --references--> `TenantReceiptSettingsRepository`  [EXTRACTED]
  pos-backend/src/main/java/com/company/pos/tenant/infrastructure/rest/ReceiptSettingsController.java → pos-backend/src/main/java/com/company/pos/tenant/domain/TenantReceiptSettingsRepository.java
- `ReceiptSettingsControllerIntegrationTest` --references--> `ReceiptSettingsController`  [EXTRACTED]
  pos-backend/src/test/java/com/company/pos/tenant/infrastructure/rest/ReceiptSettingsControllerIntegrationTest.java → pos-backend/src/main/java/com/company/pos/tenant/infrastructure/rest/ReceiptSettingsController.java
- `SaleController` --references--> `BillingService`  [EXTRACTED]
  pos-backend/src/main/java/com/company/pos/sales/infrastructure/rest/SaleController.java → pos-backend/src/main/java/com/company/pos/billing/application/BillingService.java
- `InventoryService` --references--> `InventoryMovementRepository`  [EXTRACTED]
  pos-backend/src/main/java/com/company/pos/inventory/application/InventoryService.java → pos-backend/src/main/java/com/company/pos/inventory/domain/InventoryMovementRepository.java

## Import Cycles
- None detected.

## Communities (135 total, 98 thin omitted)

### Community 0 - "TenantReceiptSettings"
Cohesion: 0.06
Nodes (3): TenantReceiptSettings, TenantReceiptSettingsDto, ReceiptSettingsController

### Community 1 - "CashSessionContext.tsx"
Cohesion: 0.08
Nodes (32): CashSessionGuard(), CashSessionGuardProps, DefaultError(), DefaultLoading(), DefaultNoSessionBlocking(), DefaultNoSessionInline(), CashSessionContext, CashSessionContextValue (+24 more)

### Community 2 - "VariantOption"
Cohesion: 0.09
Nodes (7): VariantOptionService, VariantOption, VariantOptionRepository, VariantOptionType, COLOR, SIZE, VariantOptionServiceUnitTest

### Community 3 - "apiFetch"
Cohesion: 0.09
Nodes (26): ConfirmModal(), ConfirmModalProps, EmptyState(), EmptyStateProps, Spinner(), apiFetch(), Customer, Customers() (+18 more)

### Community 4 - "ref_fs"
Cohesion: 0.05
Nodes (27): code, fs, code, fs, code, fs, code, fs (+19 more)

### Community 5 - "org.springframework.transaction.annotation.Transactional"
Cohesion: 0.18
Nodes (15): UserContext, ProductRepository, ProductVariantRepository, InventoryRepository, SaleService, StoreRepository, TenantRepository, BaseIntegrationTest (+7 more)

### Community 7 - "tenants"
Cohesion: 0.10
Nodes (29): invoices, tenant_receipt_settings, tenant_sale_sequences, uq_sales_tenant_sale_number, uq_variant_options_tenant_type_name, variant_options, idx_inv_mov_tenant_store_created, idx_inv_mov_tenant_store_variant_created (+21 more)

### Community 8 - "useAuthStore.ts"
Cohesion: 0.12
Nodes (12): RoleGuardProps, mockNavigate, mock_customers, mock_sales, AuthState, CustomJwtPayload, UserRole, jwt-decode (+4 more)

### Community 9 - "DashboardStatsDto"
Cohesion: 0.09
Nodes (6): DashboardStatsDto, PaymentMethodTotalDto, ReportingService, ReportingController, ConfigController, ReportingServiceUnitTest

### Community 10 - "Invoice"
Cohesion: 0.09
Nodes (6): BillingService, ElectronicBillingPort, Invoice, InvoiceEmitResult, InvoiceRepository, MockBillingAdapter

### Community 14 - "package.json"
Cohesion: 0.07
Nodes (22): name, private, type, version, autoprefixer, jsdom, oxlint, postcss (+14 more)

### Community 15 - "TenantContext"
Cohesion: 0.14
Nodes (5): CreditNoteSequenceGenerator, CreditNoteService, SaleSequenceGenerator, CreditNoteRepository, TenantContext

### Community 16 - "react"
Cohesion: 0.14
Nodes (23): KardexExport(), KardexExportProps, KardexFilters(), KardexFiltersProps, MOVEMENT_TYPE_LABELS, MOVEMENT_TYPE_OPTIONS, MovementTypeOption, KardexPagination() (+15 more)

### Community 18 - "App.tsx"
Cohesion: 0.17
Nodes (16): App(), RootRedirect(), DashboardLayout(), ProtectedRoute(), RoleGuard(), useCashSession(), CashManagement(), Categories() (+8 more)

### Community 23 - "CatalogService"
Cohesion: 0.15
Nodes (4): CatalogService, BrandRepository, CategoryRepository, CatalogServiceUnitTest

### Community 27 - "local_dump.sql"
Cohesion: 0.08
Nodes (23): public.audit_logs, public.brands, public.cash_registers, public.cash_sessions, public.cash_transactions, public.categories, public.customers, public.flyway_schema_history (+15 more)

### Community 29 - "PurchasingServiceUnitTest.java"
Cohesion: 0.24
Nodes (5): PurchasingService, PurchaseRepository, SupplierRepository, AuthServiceUnitTest, PurchasingServiceUnitTest

### Community 35 - "compilerOptions"
Cohesion: 0.09
Nodes (22): compilerOptions, allowArbitraryExtensions, allowImportingTsExtensions, baseUrl, erasableSyntaxOnly, ignoreDeprecations, jsx, lib (+14 more)

### Community 40 - "InventoryService.java"
Cohesion: 0.19
Nodes (5): InventoryMovementEventListener, InventoryService, KardexQueryService, KardexQueryRepository, InventoryController

### Community 44 - "Inventory.tsx"
Cohesion: 0.15
Nodes (12): catalogApi, Product, Variant, InventoryItem, formatCurrency(), formatDate(), Dashboard(), DashboardData (+4 more)

### Community 48 - "ProductVariantsModal.tsx"
Cohesion: 0.18
Nodes (12): Product, ProductVariantsModal(), ProductVariantsModalProps, VariantOptionSelect(), VariantOptionSelectProps, formatConsecutive(), generateSku(), Category (+4 more)

### Community 51 - "dependencies"
Cohesion: 0.10
Nodes (18): dependencies, idb-keyval, jwt-decode, lucide-react, react, react-dom, react-hot-toast, react-router-dom (+10 more)

### Community 52 - "devDependencies"
Cohesion: 0.11
Nodes (18): devDependencies, autoprefixer, jsdom, oxlint, postcss, tailwindcss, @tailwindcss/postcss, @testing-library/jest-dom (+10 more)

### Community 58 - "VariantOptionController"
Cohesion: 0.23
Nodes (4): CreateOptionRequest, SetActiveRequest, VariantOptionController, VariantOptionResponse

### Community 60 - "compilerOptions"
Cohesion: 0.12
Nodes (16): compilerOptions, allowImportingTsExtensions, erasableSyntaxOnly, lib, module, moduleDetection, noEmit, noFallthroughCasesInSwitch (+8 more)

### Community 65 - "AuthService"
Cohesion: 0.18
Nodes (4): AuthService, AuthResponse, LoginRequest, AuthController

### Community 69 - "CashController"
Cohesion: 0.21
Nodes (4): CashController, CloseSessionRequest, OpenSessionRequest, RegisterTransactionRequest

### Community 70 - "CustomerService"
Cohesion: 0.23
Nodes (3): CustomerService, CustomerRepository, CustomerController

### Community 71 - "MovementType"
Cohesion: 0.14
Nodes (10): MovementType, ADJUSTMENT, EXCHANGE_IN, EXCHANGE_OUT, IN, INITIALIZATION, OUT, PURCHASE (+2 more)

### Community 75 - "api.ts"
Cohesion: 0.29
Nodes (8): downloadBlob(), getAuthHeaders(), addToOfflineQueue(), getOfflineQueue(), OfflineRequest, removeFromQueue(), syncOfflineData(), idb-keyval

### Community 76 - "ResourceNotFoundException"
Cohesion: 0.23
Nodes (4): NoActiveCashSessionException, ResourceNotFoundException, GlobalExceptionHandlerTest, DomainException

### Community 82 - "CashService"
Cohesion: 0.50
Nodes (5): CashService, CashRegisterRepository, CashSessionRepository, CashTransactionRepository, CashServiceIntegrationTest

### Community 83 - "CreditNoteStatus"
Cohesion: 0.29
Nodes (5): CreditNoteStatus, ACTIVE, EXHAUSTED, EXPIRED, PARTIALLY_USED

### Community 85 - "PdfReceiptGenerator"
Cohesion: 0.53
Nodes (3): PdfReceiptGenerator, TenantReceiptSettingsRepository, PdfReceiptGeneratorTest

### Community 86 - ".oxlintrc.json"
Cohesion: 0.33
Nodes (5): plugins, rules, react/only-export-components, react/rules-of-hooks, $schema

### Community 93 - "V6__create_cash_management_tables.sql"
Cohesion: 0.83
Nodes (3): cash_registers, cash_sessions, cash_transactions

### Community 94 - "V9__create_purchasing_tables.sql"
Cohesion: 0.83
Nodes (3): purchase_items, purchases, suppliers

## Knowledge Gaps
- **28 isolated node(s):** `autoprefixer`, `jsdom`, `oxlint`, `postcss`, `tailwindcss` (+23 more)
  These have ≤1 connection - possible missing edges. (Counts symbols only; 767 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **98 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `ProductVariant` connect `ProductVariant` to `.refundSale_success_restoresInventory_and_removesCash`, `CatalogController`, `TenantReceiptSettings`, `org.springframework.transaction.annotation.Transactional`, `uuid`, `.registerMovement`, `InventoryService.java`, `Inventory`, `InventoryMovement`, `SaleController.java`, `org.junit.jupiter.api.Test`, `CatalogService`, `.setUp`, `SaleItem`, `Product`?**
  _High betweenness centrality (0.035) - this node is a cross-community bridge._
- **Are the 7 inferred relationships involving `ProductVariant` (e.g. with `.testGenerateThermalReceiptWithFullDetails()` and `.createAndGetProductsWithVariants()`) actually correct?**
  _`ProductVariant` has 7 INFERRED edges - model-reasoned connections that need verification._
- **What connects `autoprefixer`, `jsdom`, `oxlint` to the rest of the system?**
  _28 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `TenantReceiptSettings` be split into smaller, more focused modules?**
  _Cohesion score 0.062004662004662 - nodes in this community are weakly interconnected._
- **Why does `Sale` connect `Sale` to `TenantReceiptSettings`, `.refundSale_success_restoresInventory_and_removesCash`, `SaleRepository`, `org.springframework.transaction.annotation.Transactional`, `uuid`, `RefundItem`, `.generateReceipt`, `SaleController.java`, `PdfReceiptGenerator.java`, `SaleItem`, `SalePayment`?**
  _High betweenness centrality (0.029) - this node is a cross-community bridge._
- **Are the 7 inferred relationships involving `Sale` (e.g. with `.testGenerateThermalReceiptWithFullDetails()` and `.testGenerateThermalReceiptWithMinimalDetailsDoesNotThrow()`) actually correct?**
  _`Sale` has 7 INFERRED edges - model-reasoned connections that need verification._
- **Should `CashSessionContext.tsx` be split into smaller, more focused modules?**
  _Cohesion score 0.07909604519774012 - nodes in this community are weakly interconnected._