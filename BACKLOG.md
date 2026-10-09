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

## 📋 SPRINT 3 - Próximo Sprint (v1.3.0) | **Planificación**

*Definir en próxima sesión de planning*

- [ ] *[Pendiente definición - añadir items aquí]*

---

## 📋 SPRINT 4 (v1.4.0) | **Icebox**

*Candidatos para futuros sprints*

- [ ] *[Pendiente definición]*

---

## 📊 SPRINT 7 - Business Intelligence & UX (v1.7.0) | **~2-3 semanas (P2)**

*Reportes, mejoras de UX y calidad*

- [ ] **Reportes Gerenciales y Margen de Utilidad** (#19): Dashboard financiero con cálculo de ventas netas, costo de mercancía vendida (COGS) y margen de utilidad bruta (`(Precio Venta - Costo Unitario)`), además del ranking de prendas más vendidas por categoría y talla.
- [ ] **Expandir Detalle de Venta en Historial** (#27): En `SalesHistory.tsx`, cada fila de la tabla debe ser expandible (click en fila o icono chevron) para mostrar el detalle de productos de esa venta: lista de items con SKU, nombre, talla, color, cantidad, precio unitario, subtotal. Cargar bajo demanda (lazy) vía `GET /api/sales/{id}/items` o incluir en respuesta de `/api/sales` con flag `?includeItems=true`.
- [ ] **Tests Unitarios y de Integración: Concurrencia NC** (#70): Pruebas de concurrencia en la redención de saldos, validación de estados de la NC, reingreso a inventario y comprobación de que la caja no sufra egresos monetarios.

---

## 🔔 SPRINT 8 - Engagement & Comms (v1.8.0) | **~2-3 semanas (P3)**

*Notificaciones y comunicaciones*

- [ ] **Notificaciones a Clientes** (#24): Implementar envío automático de comprobantes (Recibos PDF) y alertas mediante Email y/o WhatsApp.

---

## ⚖️ PARALELO - Facturación Electrónica (Legal/Blocker) | **Lead time: semanas**

*Requiere definición de proveedor - iniciar investigación YA*

- [ ] **Facturación Electrónica** (#20): Desarrollar la integración con la entidad fiscal correspondiente (DIAN, SAT, AFIP, etc.) vía Web Services reales, reemplazando la simulación actual de PDFs.
- [ ] **Bloque de Factura Electrónica en la Tirilla (BLOQUEADO)** (#49): Imprimir el número de factura electrónica y el QR fiscal (con CUFE). Bloqueado hasta definir el proveedor de **Facturación Electrónica**; no se debe mostrar ningún dato del Mock en la tirilla, porque un número o QR simulado en un comprobante entregado al cliente parecería un documento fiscal válido.