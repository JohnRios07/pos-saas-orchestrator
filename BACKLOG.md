# Backlog: V2 - Camino a Producción

Este backlog detalla los requerimientos necesarios para llevar el MVP (v1.0.0) a un estado de **APP Productiva**, enfocado en estabilidad operativa, seguridad y procesos de negocio reales.

---

## ✅ SPRINT 0 - MVP (v1.0.0) | **Completado**

*Base funcional entregada*

### Operaciones e Infraestructura
- [x] **Seguridad de Red (HTTPS/SSL):** Configurar y automatizar la renovación de certificados SSL (Let's Encrypt / Certbot) en el proxy Nginx.
- [x] **Backups Off-Site (S3 o similar):** Volcados de BD a almacenamiento en la nube externo.
- [x] **Observabilidad y Alertas:** Stack Promtail/Loki + Grafana + Prometheus.
- [x] **Protección y Tolerancia a Fallos:** Rate Limiting en Nginx + tuning HikariCP.

### Funcionalidad de Negocio
- [x] **Roles y Permisos Granulares (RBAC):** Roles `CASHIER`, `MANAGER`, `ADMIN` con accesos limitados.
- [x] **Devoluciones y Reingreso a Inventario:** Flujo para anular ventas y reingresar prendas a stock.
- [x] **Kardex y Alertas de Stock Mínimo:** Vista de movimientos históricos trazables por variante/talla/color, umbral de stock mínimo con alertas visuales. Backend con KardexQueryService, endpoint exportación CSV streaming, eventos de dominio; frontend con componentes atómicos (Filters, Table, Pagination, Export), alertLevel provisto por backend, catalogApi para consistencia.
- [x] **Resiliencia Frontend (Soporte Offline):** Service Workers + IndexedDB en el POS para operar ante micro-cortes de internet.

### Deuda Técnica (Testing & QA)
- [x] **Backend Testing Foundation:** Testcontainers (Postgres) + Jacoco, cobertura ≥60% en servicios core (Inventario, Caja).
- [x] **Frontend Testing Foundation:** Vitest + React Testing Library, tests para guards RBAC y mutaciones Zustand.

### Seguridad y Vulnerabilidades
- [x] **Configuración CORS Insegura:** Corregido `SecurityConfig.java` - ya no permite `*` con credenciales.
- [x] **Secretos Hardcodeados:** JWT secret eliminado de `SecurityConfig.java`, inyección obligatoria vía variables de entorno.
- [x] **Vulnerabilidades Dependencias Frontend (SCA):** 7 vulnerabilidades (5 altas, 2 moderadas) resueltas actualizando `tailwindcss` / overrides en `package.json`.

### Tirilla de Venta (Recibo POS) - 80mm térmica
- [x] **Consecutivo de Venta por Tenant:** `sale_number` secuencial por tenant, seguro ante concurrencia (DB-level `UPDATE ... RETURNING`), restricción única `(tenant_id, sale_number)`, migración numerando existentes por `created_at`. Formato `VENTA #00001258`.
- [x] **Configuración de Recibo por Tenant:** Entidad 1:1 con tenant (slogan, ciudad/departamento, WhatsApp, Instagram, web, URL política cambios, texto cambios/devoluciones, mensaje cierre). Campos opcionales. Endpoints `GET/PUT /api/settings/receipt` (solo `ADMIN`). Pantalla Configuración en frontend.
- [x] **Nombre del Cajero en la Venta:** Resuelto desde `Sale.createdBy` para impresión en tirilla.
- [x] **Rediseño de la Tirilla Térmica:** Formato 80mm (48 chars/línea), ancho fijo, alto dinámico. Encabezado negocio, consecutivo, fecha `dd/MM/yyyy - hh:mm a`, cajero, productos con SKU y `Talla | Color`, subtotal/descuentos/total, forma de pago, sección cambios/devoluciones, cierre con redes/web. Montos COP (`$89.900`). Todo en español. Sin bloque factura electrónica.
- [x] **Etiquetas Forma de Pago:** `CASH` → "Efectivo", `TRANSFER` → "Transferencia" (solo visual). BD mantiene valores originales.
- [x] **Tests:** Unitarios e integración (Testcontainers) para concurrencia consecutivo, CRUD config con restricción rol, contenido generado tirilla.

> **Decisión (2026-10-07):** Papel térmico **80 mm** (área imprimible ~72 mm, **48 caracteres por línea**). PDF con ancho 80mm y alto dinámico para corte exacto al final de la tirilla.

---

## ✅ SPRINT 1 - Quick Wins (v1.1.0) | **Completado**

*Críticos, bajo esfuerzo, alto impacto inmediato — Implementado y validado en PR pos-backend#15 y PR pos-frontend#18*

- [x] **Separar configs Docker por ambiente** (#11): Mover `ports`, `localhost:3000` en CORS y overrides de local a `docker-compose.override.yml` (gitignored) o variables de entorno. El `docker-compose.yml` base debe tener solo configs de prod/staging.
- [x] **Gestión de Sesión de Caja Resiliente** (`CashManagement.tsx`) (#22): Evitar que fallos de petición (ej. 400 por parámetros incompletos o 500) en `/cash/sessions/active` se capturen silenciosamente como `session = null` mostrando una falsa "Caja Cerrada". Distinguir entre un error de conexión/parámetros y una caja legítimamente cerrada, e hidratar `storeId`/`registerId` antes de consultar.
- [x] **Validación Proactiva de Caja Abierta en POS** (`Sales.tsx`) (#23): Validar al cargar el Punto de Venta si existe un turno de caja abierto. Si la caja está cerrada, bloquear la interacción con el catálogo/carrito o mostrar un aviso prominente con redirección a `/cash-management`, impidiendo que el cajero arme una venta a ciegas para solo enterarse del bloqueo al intentar cobrar.
- [x] **Bloqueo de Devoluciones sin Caja Abierta** (#26): En `SalesHistory.tsx`, al intentar devolver/anular, validar sesión de caja activa. Si no hay caja, mostrar alerta "No hay turno de caja abierto. Abra caja en Gestión de Caja antes de procesar devoluciones" y deshabilitar botón "Devolver".
- [x] **Redirección Inteligente Post-Login** (#28): Al autenticarse, consultar `/api/cash/sessions/active`. Si no hay sesión activa → redirigir a `/cash-management` (apertura de caja). Si ya hay sesión activa → redirigir a `/sales` (Punto de Venta). Aplicable para roles `CASHIER` y `MANAGER`.

### 📦 Resumen Técnico y Arquitectura Entregada (Sprint 1)
- **Backend (PR pos-backend#15 - Merged a develop ✅):**
  - **Jerarquía de Dominio Desacoplada:** Excepciones base `DomainException` y `ResourceNotFoundException` creadas en `shared.domain.exception`.
  - **Bounded Context `cash`:** `NoActiveCashSessionException` extiende `ResourceNotFoundException` con código `"NO_ACTIVE_SESSION"`.
  - **Shared Kernel Limpio:** `GlobalExceptionHandler` maneja las abstracciones base sin ninguna dependencia a contextos periféricos (Handbook §46, OCP).
  - **Respuesta Estructurada:** HTTP 404 con payload `{ status: 404, error: "Not Found", code: "NO_ACTIVE_SESSION", message: ... }` (Handbook §10.2).
  - **Testing Continuo:** Cobertura de tests unitarios e integración añadida en `GlobalExceptionHandlerTest` y `CashServiceTest`.
- **Frontend (PR pos-frontend#18 - Merged a develop ✅):**
  - **Bounded Context (`src/features/cash/`):** Estructura completa según Handbook §19.1 (`types`, `services`, `hooks`, `components`, `context`).
  - **Servicios Desacoplados:** Cliente HTTP centralizado `cashApi` y lógica de dominio pura en `cashSessionService` (Handbook §6.3, §19.3).
  - **Única Fuente de Verdad:** `CashSessionProvider` / `CashSessionContext` conectado en `App.tsx` con manejo de hidratación (`isHydrating`) para evitar parpadeos de "Caja Cerrada".
  - **Flujo de Redirección:** Hook `useCashSessionRedirect` desacoplado que utiliza la regla de negocio `getRedirectTarget`.
  - **Componente Reutilizable:** `CashSessionGuard` configurable por props (`showNoSessionBanner`) y navegación SPA nativa vía `useNavigate`.
  - **React Rules of Hooks:** Invocación incondicional de hooks al nivel superior en `useCashSession`.
  - **Testing & Calidad:** 71 tests pasando (100% verde), 0 linter errors, y `tsc -b && vite build` exitoso.

---

## ✅ SPRINT 2 - Notas de Crédito & UX (v1.2.0) | **Completado**

### Notas de Crédito y Mejoras UX
- [x] **Entidad y Secuencia de Notas de Crédito** (#59): Tabla `credit_notes` con consecutivo y estados.
- [x] **Invariante Financiero (Cero Egreso de Caja)** (#58): Eliminado egreso físico de caja.
- [x] **Bloqueo de Ventas sin Caja Abierta** (#25): Validación en frontend (checkout bloqueado) y backend.
- [x] **Flujo de Emisión desde Historial** (#60-64): Devoluciones parciales/totales implementadas, selección de items en modal, reingreso a inventario y emisión de comprobante PDF en formato 80mm con consecutivo.
- [x] **Flujo de Redención en el POS (Nueva Venta)** (#65-69): Método de pago "Nota de Crédito" integrado en el checkout, búsqueda y validación de saldos, deducciones automáticas y pagos mixtos (excedentes).
- [x] **Notas de Crédito y Cambios (Integración Completa)** (#17): Sin egreso de caja física (`OUT`); las devoluciones emiten Notas de Crédito, cerrando el ciclo comercial.
- [x] **Refinamiento Modal de Pagos (UX):** Formato de moneda para efectivo y transferencias (usando `Intl.NumberFormat`), cálculo dinámico de cambio a devolver, y validación estricta de límites (la transferencia no puede superar el total, y el efectivo solo envía a backend el monto aplicado).

---

## 📊 SPRINT 3 - Business Intelligence & UX (v1.3.0) | **~2-3 semanas (P2)**

*Reportes, mejoras de UX y calidad*

- [ ] **Reportes Gerenciales y Margen de Utilidad** (#19): Dashboard financiero inicial entregado (`/reporting/dashboard`: Ventas totales, ticket promedio y medios de pago con selector de rango de fechas). *Pendiente*: costo de mercancía vendida (COGS), margen de utilidad bruta (`Precio Venta - Costo Unitario`) y ranking de prendas más vendidas por categoría y talla.
- [x] **Expandir Detalle de Venta en Historial** (#27): En `SalesHistory.tsx`, cada fila de la tabla debe ser expandible (click en fila o icono chevron) para mostrar el detalle de productos de esa venta: lista de items con SKU, nombre, talla, color, cantidad, precio unitario, subtotal. Cargar bajo demanda (lazy) vía `GET /api/sales/{id}/items` o incluir en respuesta de `/api/sales` con flag `?includeItems=true`.
- [ ] **Tests Unitarios y de Integración: Concurrencia NC** (#70): Bloqueo pesimista (`@Lock(LockModeType.PESSIMISTIC_WRITE)`) implementado en `CreditNoteRepository` y pruebas de integración de devoluciones sin egreso en `SaleServiceIntegrationTest`. *Pendiente*: suite automatizada específica de concurrencia multihilo en redención simultánea.

---

## 🔔 SPRINT 4 - Engagement & Comms (v1.4.0) | **~2-3 semanas (P3)**

*Notificaciones y comunicaciones*

- [ ] **Notificaciones a Clientes** (#24): Implementar envío automático de comprobantes (Recibos PDF) y alertas mediante Email y/o WhatsApp.

---

## 📦 MÓDULO DE COMPRAS & COSTO PROMEDIO / PURCHASING (v1.4.0) | **Completado**

- [x] **Rediseño del Bounded Context Purchasing (Backend)**:
  - Separación de orden de compra (`Purchase`) y recepción de mercancía (`GoodsReceipt`) siguiendo el estándar DDD.
  - Migración Flyway `V22__redesign_purchasing_orders_and_receipts.sql` y generador secuencial atómico (`tenant_purchase_sequences`) para consecutivo `OC-XXXX`.
- [x] **Recepciones Parciales y Kardex**:
  - Procesamiento físico de mercancía con control de diferencias y transiciones de estado (`PENDING` -> `PARTIALLY_RECEIVED` -> `RECEIVED`).
  - Disparo de movimientos y eventos de inventario consistentes con trazabilidad a la orden de compra.
- [x] **Cálculo de Costo Promedio Ponderado (CPP)**:
  - Recálculo en `InventoryService` de CPP sobre compras recibidas y actualización automática del costo de reposición en variantes del catálogo (`product_variants`).
- [x] **UI/UX del Módulo de Compras (Frontend)**:
  - Tabla de órdenes de compra con filtros de estado y saldos pendientes (`PurchaseOrdersTable`).
  - Formulario de creación de órdenes con selectores numéricos y cálculo automático de IVA (19%) en `CreatePurchaseOrder`.
  - Modal de verificación física de mercancía (`GoodsReceiptModal`) con badges de diferencias y atajo rápido `F2` para confirmación.

---

## ⚙️ MÓDULO DE CONFIGURACIÓN & POLÍTICAS TENANT (v1.3.0) | **Completado**

- [x] **Arquitectura y Modelado de Ajustes por Bounded Context**:
  - Migración `V23__create_settings_tables.sql` con tablas tipadas por dominio: `tenant_sales_settings`, `tenant_inventory_settings`, `tenant_cash_settings`.
  - Endpoints REST desacoplados para configuración comercial, ventas, inventario y caja.
- [x] **Seguridad y Reglas Críticas en Backend**:
  - **Arqueo Ciego**: Ocultación de saldos esperados a cajeros en `CashController` a través de `CashSessionResponseDto`.
  - **Existencias Negativas**: Bloqueo o habilitación condicional en `InventoryService` gobernado por la política del tenant.
  - **Límites de Descuento**: Validación de umbrales máximos al rol cajero en `SaleService`.
- [x] **Panel de Configuración y Navegación Modular (Frontend)**:
  - Hub Central `/settings` con las 10 secciones operativas, estados y prioridades.
  - Formularios dedicados con tabs `SettingsNav`: Negocio (`/settings/business`), Ventas (`/settings/sales`), Caja (`/settings/cash`), Inventario (`/settings/inventory`) e integración con Tirilla (`/settings/receipt`).

---

## 🛍️ MÓDULO PLAN SEPARE / LAYAWAY (v1.4.0) | **Completado**

- [x] **Arquitectura y Modelo de Dominio (Bounded Context `layaway`)**:
  - Migración `V30__add_reserved_quantity_to_inventory.sql`: Columna `reserved_quantity NUMERIC(14,3)` con restricción check no negativa.
  - Migración `V31__create_layaway_module_tables.sql`: Tablas aisladas por tenant (`tenant_layaway_sequences`, `layaway_plans`, `layaway_plan_items`, `layaway_payments`).
  - Entidades `LayawayPlan`, `LayawayPlanItem`, `LayawayPayment`, y enum `LayawayStatus` (`ACTIVE`, `FULLY_PAID`, `PENDING_INVOICE`, `PENDING_DELIVERY`, `COMPLETED`, `EXPIRED`, `CANCELLED`).
  - Generador de secuencias atómico por tenant para planes (`#00000001`) y recibos (`#00000001`).
- [x] **Reglas de Negocio e Invariantes Críticas**:
  - **Abono inicial mínimo del 20%**: Validación estricta con aritmética exacta (`BigDecimal`).
  - **Reserva atómica de inventario**: `Stock Disponible = Físico - Reservado`. Bloqueo preventivo en ventas ordinarias ante stock comprometido.
  - **Congelación de precios históricos**: Precios congelados en `layaway_plan_items` sin afectación por fluctuaciones del catálogo.
  - **Gestión financiera y de caja**: Abonos en efectivo ingresan al turno de caja activo del cajero (`IN`). Liquidación final usa método `LAYAWAY` con cero movimiento en caja física para evitar doble contabilización.
  - **Control de vencimientos (45 días)**: Detección y bloqueo automático de abonos y entregas en planes vencidos, endpoint de expiración masiva `POST /api/layaway/expire-overdue`.
  - **Cancelaciones sin salida de dinero**: Liberación inmediata de stock reservado y emisión de Nota de Crédito comercial (`CreditNote`) al cliente.
  - **Entrega atómica y venta definitiva**: Descuento físico de inventario y generación del registro de venta oficial al liquidar el 100%.
- [x] **Experiencia de Usuario y Frontend**:
  - Vista principal `/layaway` con KPIs en tiempo real (Saldo por cobrar, planes por vencer en ≤ 7 días, completados), pestañas de filtrado y búsqueda.
  - Modales dedicados: creación de plan con selector de productos y validación del 20%, registro de abonos adicionales con validación de saldo, cancelación con generación de Nota de Crédito, y detalle exhaustivo con timeline.
  - Comprobante térmico de 80 mm imprimible para cada abono con disclaimer legal explícito ("ESTE DOCUMENTO ES UN COMPROBANTE DE ABONO - NO ES UNA FACTURA DE VENTA").
  - Tests unitarios en `LayawayPage.test.tsx` e integración con menú y rutas lazy.

---

## 🎨 SPRINT 5 - Design System & UX Refactor (v1.5.0) | **~3-4 semanas (P1)**

*Fundación visual y refactor del flujo crítico POS — base para escalar UI consistente*

### Design System Foundation
- [x] **Design Tokens en Tailwind** — Configurados en CSS vía directivas `@theme` de Tailwind v4 en `src/index.css` con paleta semántica (primary, secondary, background, success, error, warning) y tipografía sans.
- [ ] **Biblioteca de primitivas UI** — Primitivas atómicas creadas y estandarizadas en `src/components/ui/` (`Button`, `Input`, `Card`, `Badge`, `Skeleton`). *Pendientes*: `Select`, `Modal`, `Table`, `Toast`, `Spinner`, `EmptyState`.
- [ ] **Form Library Adoption** — `react-hook-form` + `zod` adoptados en `PaymentModal.tsx` con esquemas y `zodResolver`. *Pendiente*: migrar formulario de `CashManagement.tsx`.
- [x] **Hooks y utilidades de formato centralizados** — Centralizado en `src/lib/formatters.ts` (`formatCurrency`, `formatDate`, `formatDateTime`, `setFormatLocale`), eliminando duplicaciones de `Intl.NumberFormat`.

### POS Refactor (Flujo Crítico)
- [x] **Descomponer `Sales.tsx` (793 líneas)** — Descompuesto a ~340 líneas en componentes desacoplados del bounded context `features/sales`:
  - `ProductSelector` — búsqueda/selección producto + variantes (`VariantSelectionModal`)
  - `CartPanel` — carrito reactivo, descuentos globales, subtotales (`useCartStore`)
  - `CustomerSearchBar` / `CustomerQuickForm` / `CustomerSelector` — gestión y selección de clientes
  - `PaymentModal` — multi-pago (Efectivo/Transfer/NC) con validación y auto-balance
  - `CreditNoteSection` — validación y redención integrada en modal de pago
- [x] **Skeletons de carga** — Todas las tablas (Kardex, Inventario, Historial, Productos) con `Skeleton` component
- [x] **Atajos de teclado POS** — Implementados: `Cmd+K` / `Ctrl+K` (búsqueda de productos), `F2` (abrir pasarela de pago), `Escape` (cerrar modales).
- [ ] **Sistema unificado de errores** — Field-level (inline), Toast (global), Banner (page-level) con códigos backend

### Accesibilidad & Polish
- [ ] **Auditoría ARIA** — Modals (`aria-modal`, `aria-labelledby`), selects, focus management, keyboard nav
- [x] **Store ID como dropdown / contexto** — `Inventory.tsx` y `KardexTab.tsx` eliminaron inputs libres de texto y leen reactivamente la tienda del contexto de sesión (`useAuthStore`).
- [ ] **i18n structure** — Extraer strings hardcodeados a `src/i18n/` (preparar ES/EN)

---

## ⚖️ PARALELO - Facturación Electrónica (Legal/Blocker) | **Lead time: semanas**

*Requiere definición de proveedor - iniciar investigación YA*

- [ ] **Facturación Electrónica** (#20): Desarrollar la integración con la entidad fiscal correspondiente (DIAN, SAT, AFIP, etc.) vía Web Services reales, reemplazando la simulación actual de PDFs.
- [ ] **Bloque de Factura Electrónica en la Tirilla (BLOQUEADO)** (#49): Imprimir el número de factura electrónica y el QR fiscal (con CUFE). Bloqueado hasta definir el proveedor de **Facturación Electrónica**; no se debe mostrar ningún dato del Mock en la tirilla, porque un número o QR simulado en un comprobante entregado al cliente parecería un documento fiscal válido.