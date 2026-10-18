# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.3.0] - 2026-10-18 (pos-backend v2.6.0 / pos-frontend v2.7.0)

### Added
- **Managerial Financial Dashboard & Profitability (Sprint 3 / #19)**:
  - **Backend (`pos-backend` v2.6.0)**:
    - Server-authoritative `unitCost` snapshot on `SaleItem` during sale creation, resolving store inventory weighted average cost (`Inventory.averageCost`) or catalog base cost (`ProductVariant.cost`), preventing client spoofing and historical report distortions.
    - Financial KPI calculations in `ReportingService.getDashboardStats` (`cogs`, `grossProfit`, `grossMarginPercentage`, `salesCount`) isolated with `@Transactional(readOnly = true)`.
    - Top selling products endpoint `GET /api/reporting/top-products` grouping sold garments by variant, product, category, size, and color with revenue, volume, and profitability metrics.
    - Multi-tenant reporting isolation tests and negative size filter test suite.
  - **Frontend (`pos-frontend` v2.7.0)**:
    - KPI cards in `Dashboard.tsx` displaying Ventas Totales, Ticket Promedio, Costo Mercancía (COGS), and Utilidad Bruta con badge de Margen %.
    - Interactive Top Selling Garments table with category dropdown filter, debounced size search, and date range filters ("Hoy", "Mes Actual").
    - Local calendar date formatting (`formatLocalDate`) eliminating UTC date shifts in UTC-5 timezones.
    - Full decoupling of dashboard metrics and table filter effects to prevent unmounting and focus loss.

## [2.2.0] - 2026-10-17

### Added
- **Dynamic Product Variant Options**:
  - **Backend**:
    - `CatalogService.addVariantToProduct` dynamically expands `Product.options` when variants contain new attribute values (e.g. new colors, new sizes) or new custom attribute keys.
    - Canonicalized variant attribute keys against `ProductOptionDefinition.name()` and trimmed values to prevent case mismatches across client selectors.
    - Exposed `GET /api/catalog/products/{productId}` to retrieve current product definitions including dynamically updated options.
  - **Frontend**:
    - `ProductVariantsModal` enables adding new sizes, colors, and option values on the fly (via `+ Agregar nuevo...` or toggle button) as well as arbitrary extra characteristics (`+ Otra característica`) with collision detection.
    - Ref-based form lifecycle using `useRef` to eliminate redundant network queries and preserve variant form drafts during parent state updates.
    - WCAG accessibility: Escape key listener, sanitized HTML IDs, and contextual ARIA labels for dynamic attribute removal buttons.
    - Real-time catalog synchronization with parent `Products.tsx`.

### Fixed
- **Semantic Domain Exception Handling (Backend)**: Entity lookups for missing products now throw `ResourceNotFoundException` mapped to HTTP 404 (instead of generic `RuntimeException` returning HTTP 500).

- **Plan Separe (Layaway Module)**:
  - **Backend**:
    - Introduced Flyway migration `V30__add_reserved_quantity_to_inventory.sql` adding `reserved_quantity NUMERIC(14,3)` with non-negative check constraint.
    - Added Flyway migration `V31__create_layaway_module_tables.sql` creating `tenant_layaway_sequences`, `layaway_plans`, `layaway_plan_items`, and `layaway_payments`.
    - Implemented `LayawayPlan`, `LayawayPlanItem`, `LayawayPayment`, and `LayawayStatus` domain entities.
    - Atomic inventory reservation engine: enforces `Stock Disponible = Físico - Reservado` preventing regular sales from overselling reserved inventory.
    - Deposit validations: enforced minimum 20% down payment with exact `BigDecimal` arithmetic.
    - Financial isolation: cash deposits registered in active cashier cash drawer (`IN`), but final delivery settlement registers a `LAYAWAY` payment method with zero physical cash movement to prevent double accounting.
    - Cancellation policy: stock released back to available inventory and automatic issuance of commercial `CreditNote` (strict no-cash-refund policy).
    - Expiration & delivery controls: 45-day validity window with automated batch expiration endpoint `POST /api/layaway/expire-overdue` and blocking of payments/deliveries on expired plans.
    - Added comprehensive integration tests in `LayawayServiceIntegrationTest`.
  - **Frontend**:
    - Created Layaway Dashboard (`/layaway`) with real-time KPI metrics (receivable balance, plans expiring in <= 7 days, completed deliveries), status tabs, and customer/plan search.
    - Implemented atomic workflow modals: `CreateLayawayModal` (with 20% deposit auto-calculation and product picker), `LayawayPaymentModal` (additional deposits), `LayawayCancelModal` (Credit Note generation option), and `LayawayDetailModal` (detailed timeline and delivery trigger).
    - Built thermal 80 mm printable receipt (`LayawayReceiptModal`) with mandatory legal disclaimer stating it is a deposit receipt and not an official sale invoice.
    - Integrated with sidebar navigation and lazy-loaded routing.
    - Added unit tests in `LayawayPage.test.tsx`.
- **Tenant Configuration & Settings Module**:
  - **Backend**:
    - Added Flyway migration `V23__create_settings_tables.sql` with isolated typed tables (`tenant_sales_settings`, `tenant_inventory_settings`, `tenant_cash_settings`) and default tenant seeding.
    - Implemented domain entities, repositories, DTOs, and REST endpoints for `BusinessSettingsController`, `SalesSettingsController`, `InventorySettingsController`, and `CashSettingsController`.
    - Enforced backend domain rules: cashier discount threshold validation, customer requirement enforcement (`allowSalesWithoutCustomer`), return policy and expiration window checks (`allowReturns`, `returnWindowDays`) in `SaleService`, configurable negative stock prevention in `InventoryService`, and blind cash count balance masking in `CashController` via `CashSessionResponseDto`.
    - Added comprehensive integration tests in `SettingsControllersIntegrationTest` and `SaleServiceUnitTest`.
  - **Frontend**:
    - Created Settings Hub (`/settings`) displaying the 10 business and operational categories with priority badges, status indicators, and direct navigation.
    - Implemented modular forms with unified tab navigation (`SettingsNav`): `BusinessSettingsForm` (`/settings/business`), `SalesSettingsForm` (`/settings/sales`), `CashSettingsForm` (`/settings/cash`), and `InventorySettingsForm` (`/settings/inventory`), connecting seamlessly with thermal receipt settings (`/settings/receipt`).
    - Reactively bound tenant sales settings across the POS:
      - Enforced cashier discount limit (`maxCashierDiscountRate`) in `ItemDiscountModal` with visual warnings and submit blocking.
      - Enforced customer requirement (`allowSalesWithoutCustomer`) in `Sales.tsx` and `PaymentModal.tsx` with blocking warnings.
      - Enforced return policy and return window expiration (`allowReturns`, `returnWindowDays`) in `SalesHistory.tsx` and `SaleRow.tsx`.
    - Added unit test coverage in `SettingsHub.test.tsx`, `PaymentModal.test.tsx`, and `ItemDiscountModal.test.tsx`.
- **Purchasing Bounded Context Redesign**:
  - **Backend**: Separated purchase order planning (`Purchase`) from stock receipt (`GoodsReceipt`) following DDD baseline. Added sequence generator (`tenant_purchase_sequences`) for consecutive `OC-XXXX` numbering and Flyway migration `V22__redesign_purchasing_orders_and_receipts.sql`.
  - **Partial Goods Receipts**: Introduced physical receipt processing with difference tracking, status transition (`PENDING` -> `PARTIALLY_RECEIVED` -> `RECEIVED`), and event-driven inventory updates.
  - **Weighted Average Cost (CPP)**: Implemented weighted average cost recalculation in `InventoryService` on incoming purchase goods receipts and auto-updated catalog replacement cost on `product_variants`.
  - **Frontend UI/UX**: Redesigned purchasing module into cohesive components: `PurchaseOrdersTable` with status filters and pending balance, `CreatePurchaseOrder` with line-item steppers and 19% tax calculation, and `GoodsReceiptModal` for physical product verification with difference badges and `F2` confirmation shortcuts.

## [1.3.0] - 2026-10-09

### Added
- **Design System (Frontend)**: Implemented atomic design primitives (`Button`, `Input`, `Card`, `Badge`, `Skeleton`) and applied new Tailwind v4 theme tokens.
- **Cart State Management (Frontend)**: Migrated cart state to a global, persistent Zustand store, resolving severe prop-drilling in the POS.
- **Keyboard Shortcuts (Frontend)**: Added global shortcuts for fast operations: `Cmd+K` (Search), `F2` (Charge), `ESC` (Close Modals).

### Changed
- **POS Refactor (Frontend)**: Decomposed the monolithic 800-line `Sales.tsx` into cohesive bounded context components (`ProductSelector`, `CartPanel`, `PaymentModal`, `CustomerSelector`).
- **Store ID UX (Frontend)**: Removed the manual Store ID text input from `Inventory.tsx` in favor of reading directly from the auth token context.


## [1.2.0] - 2026-10-09

### Added
- **Credit Notes**: Implemented partial/full sales returns with zero cash-out. Emits physical credit notes (80mm thermal PDF) with a secure consecutive sequence (e.g. NC-00000001). Credit notes can be used as a payment method for new sales.

## [1.1.0] - 2026-10-07

### Added
- **Observability Stack**: Deployed complete observability pipeline (Prometheus, Loki, Promtail, Grafana) via Docker Compose and GitHub Actions.
- **Sentry Integration**: Differentiated environments (staging/prod) for Sentry in both frontend and backend.
- **Role-Based Access Control (RBAC)**: Added `ADMIN`, `MANAGER`, and `CASHIER` roles. Cashiers are now restricted from viewing administrative pages.
- **Backend Testing**: Configured Jacoco and Testcontainers. Added tests for core services.
- **Frontend Testing**: Configured Vitest and React Testing Library. Added tests for authentication store and RBAC guards.
- **Infrastructure**: Added Traefik configuration in frontend GitHub Actions workflows for production and staging deployments.

### Fixed
- **Observability**: Fixed Docker nested read-only mount issues causing Grafana dashboard provisioning to fail.
- **Backend Sentry**: Fixed AutoConfiguration crash with Spring Boot 4.1.1.
### Security
- **CORS Config**: Removed kamikaze '*' origin policy and restricted to specific allowed origins.
- **JWT Secrets**: Removed hardcoded fallback secrets and forced environment variables.

### Changed
- **Backend Coverage**: Reached 84% test coverage using real integration tests with PostgreSQL Testcontainers.
- **Frontend Coverage**: Reached 86% test coverage with accessibility-compliant DOM queries.
