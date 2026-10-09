# Graph Report - pos  (2026-10-09)

## Corpus Check
- cluster-only mode — file stats not available

## Summary
- 1969 nodes · 5083 edges · 120 communities (34 shown, 86 thin omitted)
- Extraction: 84% EXTRACTED · 16% INFERRED · 0% AMBIGUOUS · INFERRED: 808 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- VariantOption
- Store
- TenantReceiptSettings
- CashSessionContext.tsx
- App.tsx
- Customer
- ref_fs
- .registerMovement
- list
- org.springframework.http.ResponseEntity
- SaleServiceIntegrationTest.java
- Sales.tsx
- org.junit.jupiter.api.Test
- Sale
- apiFetch
- ProductVariant
- KardexEntryDto
- CreditNote
- Product
- react
- Category
- User
- CashSession
- CashTransaction
- Brand
- InventoryResponseDto
- PurchasingService
- JwtAuthenticationFilter.java
- .generateReceipt
- PageResponse
- Purchase
- compilerOptions
- org.springframework.transaction.annotation.Transactional
- ProductVariantRepository
- Invoice
- SaleItemResponseDto
- Supplier
- .getTenantId
- Inventory
- PurchaseItem
- package.json
- Inventory.tsx
- CreditNoteRepository
- .handleInventoryMovementEvent
- devDependencies
- SecurityConfig.java
- ReportingController.java
- KardexEntryProjection
- MovementType
- compilerOptions
- PurchasingServiceUnitTest.java
- CatalogController
- Override
- SaleItem
- SalePayment
- AuthService
- DashboardStatsDto
- CashController
- KardexQueryService
- Tenant
- org.springframework.data.domain.Pageable
- dependencies
- ProductVariantsModal.tsx
- SalesHistory.tsx
- .updateMinStock
- RefundItem
- org.springframework.stereotype.Component
- main.tsx
- PosApplication.java
- .oxlintrc.json
- scripts
- bcryptpasswordencoder
- vite.config.ts
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
3. `Store` - 52 edges
4. `Product` - 52 edges
5. `CashSession` - 45 edges
6. `Purchase` - 41 edges
7. `KardexEntryDto` - 39 edges
8. `Customer` - 38 edges
9. `SaleItem` - 38 edges
10. `TenantReceiptSettings` - 37 edges

## Surprising Connections (you probably didn't know these)
- `CatalogService` --references--> `ProductRepository`  [EXTRACTED]
  pos-backend/src/main/java/com/company/pos/catalog/application/CatalogService.java → pos-backend/src/main/java/com/company/pos/catalog/domain/ProductRepository.java
- `CatalogService` --references--> `ProductVariantRepository`  [EXTRACTED]
  pos-backend/src/main/java/com/company/pos/catalog/application/CatalogService.java → pos-backend/src/main/java/com/company/pos/catalog/domain/ProductVariantRepository.java
- `CatalogController` --references--> `CatalogService`  [EXTRACTED]
  pos-backend/src/main/java/com/company/pos/catalog/infrastructure/rest/CatalogController.java → pos-backend/src/main/java/com/company/pos/catalog/application/CatalogService.java
- `CatalogServiceIntegrationTest` --references--> `CatalogService`  [EXTRACTED]
  pos-backend/src/test/java/com/company/pos/catalog/application/CatalogServiceIntegrationTest.java → pos-backend/src/main/java/com/company/pos/catalog/application/CatalogService.java
- `CatalogServiceUnitTest` --references--> `CatalogService`  [EXTRACTED]
  pos-backend/src/test/java/com/company/pos/catalog/application/CatalogServiceUnitTest.java → pos-backend/src/main/java/com/company/pos/catalog/application/CatalogService.java

## Import Cycles
- None detected.

## Communities (120 total, 86 thin omitted)

### Community 0 - "VariantOption"
Cohesion: 0.06
Nodes (15): CatalogService, VariantOptionService, BrandRepository, CategoryRepository, VariantOption, VariantOptionRepository, VariantOptionType, COLOR (+7 more)

### Community 2 - "TenantReceiptSettings"
Cohesion: 0.06
Nodes (3): TenantReceiptSettings, TenantReceiptSettingsDto, ReceiptSettingsController

### Community 3 - "CashSessionContext.tsx"
Cohesion: 0.08
Nodes (32): CashSessionGuard(), CashSessionGuardProps, DefaultError(), DefaultLoading(), DefaultNoSessionBlocking(), DefaultNoSessionInline(), CashSessionContext, CashSessionContextValue (+24 more)

### Community 4 - "App.tsx"
Cohesion: 0.12
Nodes (20): App(), RootRedirect(), DashboardLayout(), ProtectedRoute(), RoleGuard(), RoleGuardProps, CashManagement(), Categories() (+12 more)

### Community 5 - "Customer"
Cohesion: 0.06
Nodes (4): CustomerService, Customer, CustomerRepository, CustomerController

### Community 6 - "ref_fs"
Cohesion: 0.05
Nodes (27): code, fs, code, fs, code, fs, code, fs (+19 more)

### Community 8 - "list"
Cohesion: 0.12
Nodes (4): SaleItemRepository, TenantReceiptSettingsRepository, TenantRepository, ReceiptSettingsControllerIntegrationTest

### Community 10 - "org.springframework.http.ResponseEntity"
Cohesion: 0.12
Nodes (6): NoActiveCashSessionException, DomainException, ResourceNotFoundException, GlobalExceptionHandler, GlobalExceptionHandlerTest, DomainException

### Community 11 - "SaleServiceIntegrationTest.java"
Cohesion: 0.15
Nodes (11): UserContext, CashRegisterRepository, ProductRepository, StoreRepository, ConfigController, BaseIntegrationTest, CatalogServiceIntegrationTest, PurchasingServiceIntegrationTest (+3 more)

### Community 12 - "Sales.tsx"
Cohesion: 0.10
Nodes (21): ConfirmModal(), ConfirmModalProps, Spinner(), useCashSession(), formatCurrency(), formatDate(), Dashboard(), DashboardData (+13 more)

### Community 13 - "org.junit.jupiter.api.Test"
Cohesion: 0.17
Nodes (6): CashService, CashSessionRepository, CashTransactionRepository, CashServiceIntegrationTest, CashServiceTest, PosApplicationTests

### Community 15 - "apiFetch"
Cohesion: 0.11
Nodes (17): ProductVariantsModal(), apiFetch(), addToOfflineQueue(), getOfflineQueue(), OfflineRequest, removeFromQueue(), syncOfflineData(), Category (+9 more)

### Community 18 - "CreditNote"
Cohesion: 0.09
Nodes (6): CreditNote, CreditNoteStatus, ACTIVE, EXHAUSTED, EXPIRED, PARTIALLY_USED

### Community 20 - "react"
Cohesion: 0.15
Nodes (23): KardexExport(), KardexExportProps, KardexFilters(), KardexFiltersProps, MOVEMENT_TYPE_LABELS, MOVEMENT_TYPE_OPTIONS, MovementTypeOption, KardexPagination() (+15 more)

### Community 27 - "PurchasingService"
Cohesion: 0.13
Nodes (6): PurchasingService, PurchaseRepository, SupplierRepository, PurchaseController, SupplierController, PurchasingServiceUnitTest

### Community 32 - "compilerOptions"
Cohesion: 0.09
Nodes (22): compilerOptions, allowArbitraryExtensions, allowImportingTsExtensions, baseUrl, erasableSyntaxOnly, ignoreDeprecations, jsx, lib (+14 more)

### Community 33 - "org.springframework.transaction.annotation.Transactional"
Cohesion: 0.22
Nodes (3): BillingService, InvoiceRepository, TenantContext

### Community 35 - "ProductVariantRepository"
Cohesion: 0.20
Nodes (6): ProductVariantRepository, InventoryMovementEventListener, InventoryService, InventoryMovementRepository, InventoryRepository, InventoryServiceTest

### Community 39 - ".getTenantId"
Cohesion: 0.18
Nodes (3): SaleService, SaleRepository, SaleController

### Community 42 - "package.json"
Cohesion: 0.11
Nodes (18): name, private, type, version, autoprefixer, jsdom, oxlint, postcss (+10 more)

### Community 43 - "Inventory.tsx"
Cohesion: 0.18
Nodes (12): EmptyState(), EmptyStateProps, catalogApi, Product, Variant, InventoryItem, Customer, Customers() (+4 more)

### Community 44 - "CreditNoteRepository"
Cohesion: 0.16
Nodes (6): CreditNoteSequenceGenerator, CreditNoteService, SaleSequenceGenerator, CreditNoteRepository, CreditNotePdfGenerator, CreditNoteController

### Community 46 - "devDependencies"
Cohesion: 0.11
Nodes (18): devDependencies, autoprefixer, jsdom, oxlint, postcss, tailwindcss, @tailwindcss/postcss, @testing-library/jest-dom (+10 more)

### Community 49 - "ReportingController.java"
Cohesion: 0.19
Nodes (3): ReportingService, ReportingController, ReportingServiceUnitTest

### Community 51 - "MovementType"
Cohesion: 0.12
Nodes (10): MovementType, ADJUSTMENT, EXCHANGE_IN, EXCHANGE_OUT, IN, INITIALIZATION, OUT, PURCHASE (+2 more)

### Community 52 - "compilerOptions"
Cohesion: 0.12
Nodes (16): compilerOptions, allowImportingTsExtensions, erasableSyntaxOnly, lib, module, moduleDetection, noEmit, noFallthroughCasesInSwitch (+8 more)

### Community 59 - "AuthService"
Cohesion: 0.18
Nodes (4): AuthService, AuthResponse, LoginRequest, AuthController

### Community 61 - "CashController"
Cohesion: 0.21
Nodes (4): CashController, CloseSessionRequest, OpenSessionRequest, RegisterTransactionRequest

### Community 66 - "dependencies"
Cohesion: 0.17
Nodes (12): dependencies, idb-keyval, jwt-decode, lucide-react, react, react-dom, react-hot-toast, react-router-dom (+4 more)

### Community 67 - "ProductVariantsModal.tsx"
Cohesion: 0.32
Nodes (7): Product, ProductVariantsModalProps, VariantOptionSelect(), VariantOptionSelectProps, generateSku(), ProductVariant, VariantOption

### Community 68 - "SalesHistory.tsx"
Cohesion: 0.23
Nodes (9): downloadBlob(), getAuthHeaders(), formatConsecutive(), Sale, SaleItemDetail, SaleItemResponseDto, SalesHistory(), mock_customers (+1 more)

### Community 71 - "org.springframework.stereotype.Component"
Cohesion: 0.29
Nodes (3): ElectronicBillingPort, InvoiceEmitResult, MockBillingAdapter

### Community 76 - ".oxlintrc.json"
Cohesion: 0.33
Nodes (5): plugins, rules, react/only-export-components, react/rules-of-hooks, $schema

### Community 77 - "scripts"
Cohesion: 0.33
Nodes (6): scripts, build, dev, lint, preview, test

## Knowledge Gaps
- **28 isolated node(s):** `COLOR`, `SIZE`, `ACTIVE`, `EXHAUSTED`, `EXPIRED` (+23 more)
  These have ≤1 connection - possible missing edges. (Counts symbols only; 738 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **86 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `ProductVariant` connect `ProductVariant` to `SaleController.java`, `Store`, `.refundSale_success_restoresInventory_and_removesCash`, `ProductVariantRepository`, `TenantReceiptSettings`, `.registerMovement`, `Inventory`, `uuid`, `.findByIdAndTenantId`, `SaleServiceIntegrationTest.java`, `Product`, `CatalogController`, `SaleItem`?**
  _High betweenness centrality (0.040) - this node is a cross-community bridge._
- **Are the 7 inferred relationships involving `ProductVariant` (e.g. with `.testGenerateThermalReceiptWithFullDetails()` and `.createAndGetProductsWithVariants()`) actually correct?**
  _`ProductVariant` has 7 INFERRED edges - model-reasoned connections that need verification._
- **What connects `COLOR`, `SIZE`, `ACTIVE` to the rest of the system?**
  _28 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `VariantOption` be split into smaller, more focused modules?**
  _Cohesion score 0.05586722767648434 - nodes in this community are weakly interconnected._
- **Why does `KardexEntryDto` connect `KardexEntryDto` to `ProductVariantRepository`, `uuid`, `MovementType`, `PageResponse`, `KardexQueryService`?**
  _High betweenness centrality (0.035) - this node is a cross-community bridge._
- **Are the 7 inferred relationships involving `Sale` (e.g. with `.testGenerateThermalReceiptWithFullDetails()` and `.testGenerateThermalReceiptWithMinimalDetailsDoesNotThrow()`) actually correct?**
  _`Sale` has 7 INFERRED edges - model-reasoned connections that need verification._
- **Should `Store` be split into smaller, more focused modules?**
  _Cohesion score 0.06351236146632566 - nodes in this community are weakly interconnected._