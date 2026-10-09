# Software Architecture Handbook 1.0

**Producto:** POS SaaS para retail de ropa urbana y gorras\
**Estado:** Architecture Baseline 1.0\
**Audiencia:** Ingeniería, producto, QA, DevOps y futuros colaboradores\
**Stack objetivo:** Java 21, Spring Boot, React, TypeScript, PostgreSQL,
Docker, VPS\
**Arquitectura:** Monolito modular multi-tenant, preparado para
evolución gradual a servicios independientes

------------------------------------------------------------------------

## Control del documento

  -----------------------------------------------------------------------
  Campo                               Valor
  ----------------------------------- -----------------------------------
  Versión                             1.0

  Estado                              Baseline para desarrollo

  Arquitectura                        Modular Monolith

  Tenancy                             Shared database + `tenant_id`

  API                                 REST/JSON

  Persistencia                        PostgreSQL

  Autenticación                       JWT + Refresh Token

  Autorización                        RBAC

  Facturación                         Proveedor tecnológico externo

  Offline                             Fase inicial: funciones limitadas;
                                      arquitectura preparada para
                                      sincronización

  Frontend                            React + TypeScript, responsive/PWA

  Despliegue                          Docker sobre VPS
  -----------------------------------------------------------------------

## Cómo usar este documento

Este handbook no pretende ser una colección decorativa de diagramas. Es
la referencia técnica que debe orientar decisiones durante el
desarrollo. Cuando una implementación contradiga una regla aquí
definida, el equipo debe decidir si:

1.  la implementación está equivocada;
2.  existe una excepción justificada; o
3.  la arquitectura debe cambiar y documentarse mediante un ADR.

La regla general es evitar complejidad prematura. El sistema debe ser
suficientemente sólido para operar una tienda real, pero no convertirse
desde el primer commit en una réplica de una plataforma empresarial con
veinte equipos que nadie tiene.

# 1. Visión del producto

## 1.1 Propósito

El producto es una plataforma de gestión comercial orientada
inicialmente a tiendas de ropa urbana y gorras. El primer cliente real
será una tienda física, pero el producto se diseñará como SaaS
multi-tenant para permitir incorporar posteriormente otras empresas y
múltiples sucursales.

La plataforma debe centralizar:

-   catálogo;
-   variantes de productos;
-   inventario;
-   compras;
-   ventas;
-   caja;
-   clientes;
-   CRM;
-   reportes;
-   facturación electrónica mediante integración externa;
-   auditoría.

## 1.2 Principios de producto

### Operación primero

Una venta debe poder completarse con el menor número razonable de pasos.

### Inventario como fuente de verdad

El stock no debe depender de modificaciones arbitrarias de una columna.
Los movimientos deben ser trazables.

### Datos históricos inmutables

Una venta, pago, recepción o movimiento de inventario confirmado no se
debe editar destructivamente. Las correcciones se realizan mediante
operaciones compensatorias.

### Multi-tenancy desde el inicio

Cada dato de negocio pertenece a un tenant.

### Integración desacoplada

DIAN, WhatsApp, pasarelas de pago y otros proveedores deben estar detrás
de interfaces de integración.

### Evolución gradual

La primera implementación es un monolito modular. Si un módulo necesita
separarse, debe poder hacerlo sin rediseñar todo el dominio.

## 1.3 Personas usuarias

### Administrador

Gestiona la operación completa de la tienda, configuración, usuarios,
catálogo, compras, inventario, ventas, caja y reportes.

### Cajero / encargado de inventario

Opera ventas, caja, entradas de mercancía, inventario físico y tareas
operativas de inventario.

## 1.4 Alcance del MVP

El MVP incluye:

-   autenticación;
-   usuarios y roles;
-   tenant y tienda;
-   catálogo;
-   variantes;
-   SKU;
-   códigos de barras;
-   proveedores;
-   órdenes de compra;
-   recepción de mercancía;
-   inventario;
-   kardex;
-   inventario físico;
-   ajustes;
-   POS;
-   pagos múltiples;
-   cambios;
-   caja;
-   clientes;
-   CRM básico;
-   reportes;
-   facturación mediante proveedor externo;
-   auditoría.

## 1.5 Fuera del MVP

-   aplicación móvil nativa;
-   e-commerce completo;
-   fidelización por puntos;
-   campañas automatizadas;
-   IA predictiva;
-   sincronización offline completa;
-   arquitectura de microservicios;
-   marketplace;
-   contabilidad general.

# 2. Requisitos funcionales

## 2.1 Catálogo

El sistema debe permitir crear productos, categorías, marcas y
variantes.

Una variante representa la unidad comercial concreta que puede venderse
y tener inventario independiente.

Ejemplo:

``` text
Producto: Camiseta básica

Variante:
  Color: Negro
  Talla: M
  SKU: CAM-BAS-NEG-M
  Código de barras: 770000000001
  Precio: 65000
```

## 2.2 Inventario

El sistema debe registrar entradas, salidas, ajustes, conteos físicos y
movimientos derivados de ventas y recepciones.

Cada movimiento debe tener:

-   tenant;
-   tienda;
-   variante;
-   tipo;
-   cantidad;
-   costo cuando corresponda;
-   referencia;
-   usuario;
-   fecha;
-   motivo.

## 2.3 Compras

El usuario puede crear una orden de compra, enviarla, recibir mercancía
parcialmente o completamente y registrar diferencias.

La orden no altera stock. La recepción sí.

## 2.4 Ventas

El POS debe permitir:

-   búsqueda por nombre;
-   búsqueda por SKU;
-   escaneo de código de barras;
-   carrito;
-   descuentos;
-   selección de cliente;
-   pagos múltiples;
-   confirmación;
-   impresión o visualización del comprobante;
-   facturación cuando corresponda.

## 2.5 Cambios

El sistema debe permitir cambiar una variante por otra, incluyendo
diferencias de precio.

## 2.6 Caja

Debe existir apertura, movimientos, ventas, retiros, gastos y cierre con
arqueo.

## 2.7 CRM

Debe almacenar clientes, historial de compras, tallas frecuentes,
categorías favoritas y consentimiento de marketing.

## 2.8 Reportes

Los reportes deben cubrir ventas, margen, utilidad, rotación, clientes,
ticket promedio, métodos de pago, caja y compras.

## 2.9 Auditoría

Las operaciones sensibles deben generar eventos de auditoría.

# 3. Requisitos no funcionales

## 3.1 Disponibilidad

Objetivo inicial: disponibilidad mensual \>= 99.5%, excluyendo
mantenimientos programados.

## 3.2 Rendimiento

Objetivos orientativos:

  Operación                                             Objetivo
  ----------------------------- --------------------------------
  Login                                                   \< 1 s
  Consulta de producto                                 \< 300 ms
  Agregar producto al carrito                          \< 300 ms
  Confirmar venta                 \< 1.5 s sin proveedor externo
  Dashboard                           \< 2 s para dataset normal
  Búsqueda de SKU                                      \< 300 ms

Los objetivos son de ingeniería, no promesas comerciales.

## 3.3 Escalabilidad

La primera versión debe soportar cómodamente decenas de tenants pequeños
en un VPS. El diseño debe permitir escalar horizontalmente el backend
sin cambiar el dominio.

## 3.4 Seguridad

-   contraseñas con BCrypt/Argon2 según decisión de implementación;
-   TLS obligatorio;
-   tokens de corta duración;
-   refresh tokens revocables;
-   RBAC;
-   aislamiento por tenant;
-   validación server-side;
-   auditoría;
-   secretos fuera del repositorio.

## 3.5 Trazabilidad

Las operaciones críticas deben poder responder:

-   quién;
-   cuándo;
-   qué entidad;
-   qué operación;
-   qué valores cambiaron;
-   desde qué tenant;
-   desde qué tienda.

## 3.6 Recuperación

Backups automáticos de PostgreSQL y procedimiento documentado de
restauración.

Objetivo inicial:

-   RPO \<= 24 h como mínimo;
-   RTO \<= 4 h como mínimo.

Posteriormente se pueden endurecer.

# 4. Contexto y arquitectura C4

## 4.1 Contexto

``` text
+------------------+
| Administrador    |
+--------+---------+
         |
         v
+-------------------------+
| POS SaaS                |
| Gestión comercial       |
+----+---------+----------+
     |         | 
     v         v
  Proveedor  WhatsApp
  facturación
     |
     v
    DIAN
```

## 4.2 Contenedores

``` text
Usuario
  |
  v
Navegador
  |
  v
React PWA
  |
  | HTTPS/REST
  v
Spring Boot
  |
  +--> PostgreSQL
  |
  +--> Billing Provider
  |
  +--> WhatsApp Provider (futuro)
```

## 4.3 Decisión

No se utiliza microservicios en la primera versión.

Los módulos se comunican mediante interfaces de aplicación y eventos
internos. No se permiten accesos arbitrarios desde cualquier módulo a
las tablas internas de otro módulo.

# 5. Arquitectura de dominios

## 5.1 Bounded Contexts

Se definen los siguientes contextos:

1.  Identity & Access
2.  Tenancy
3.  Catalog
4.  Inventory
5.  Purchasing
6.  Sales
7.  Cash Management
8.  Customer & CRM
9.  Billing
10. Reporting
11. Audit
12. Integrations

## 5.2 Reglas de dependencia

Dirección recomendada:

``` text
Shared Kernel
     ^
     |
Identity / Tenancy
     ^
Catalog
     ^
Inventory <---- Purchasing
     ^
Sales --------> Cash
  |
  +-----------> CRM
  |
  +-----------> Billing
  |
  +-----------> Reporting
```

Los módulos no deben compartir entidades JPA como mecanismo de
comunicación. Se comparten identificadores y contratos.

## 5.3 Agregados principales

### Product

Responsable de la definición comercial del producto.

### ProductVariant

Responsable de SKU, atributos comerciales y precio de la variante.

### PurchaseOrder

Responsable del ciclo de una orden de compra.

### GoodsReceipt

Responsable de la recepción efectiva.

### Sale

Agregado principal de una operación de venta.

### CashSession

Responsable del ciclo de una caja abierta.

### Customer

Responsable de la identidad comercial del cliente.

### Invoice

Responsable de la representación de facturación generada por el
proveedor.

## 5.4 Invariantes

Ejemplos:

-   una venta confirmada no puede modificarse arbitrariamente;
-   una orden de compra cancelada no puede recibirse;
-   una recepción confirmada genera movimientos de inventario;
-   un cierre de caja no puede reabrirse sin una operación
    administrativa explícita;
-   un movimiento de inventario confirmado es inmutable;
-   un usuario no puede operar sobre otro tenant.

# 6. Estructura del backend

## 6.1 Organización por módulo

``` text
backend/
└── src/main/java/com/company/pos/
    ├── auth/
    │   ├── application/
    │   ├── domain/
    │   └── infrastructure/
    ├── tenant/
    ├── catalog/
    ├── inventory/
    ├── purchasing/
    ├── sales/
    ├── cash/
    ├── crm/
    ├── billing/
    ├── reports/
    ├── audit/
    └── shared/
```

## 6.2 Capas

Cada módulo puede tener:

``` text
application/
domain/
infrastructure/
api/
```

### API

Controllers REST, DTOs y validación de entrada.

### Application

Casos de uso.

Ejemplo:

``` text
CompleteSaleUseCase
ReceivePurchaseUseCase
AdjustInventoryUseCase
CloseCashSessionUseCase
```

### Domain

Entidades, value objects, reglas e interfaces necesarias para el
dominio.

### Infrastructure

JPA, PostgreSQL, clientes HTTP, adaptadores y proveedores externos.

## 6.3 Regla

El dominio no debe depender de Spring, JPA ni clientes HTTP cuando sea
razonablemente evitable.

# 7. Modelo de datos PostgreSQL

## 7.1 Convenciones

-   nombres en `snake_case`;
-   PK UUID;
-   timestamps en UTC;
-   `created_at`, `updated_at`;
-   `tenant_id` en entidades de negocio;
-   foreign keys explícitas;
-   índices sobre columnas de búsqueda;
-   soft delete solo cuando exista una razón de negocio;
-   dinero almacenado como `numeric`, nunca `float`.

## 7.2 Tenant

``` sql
create table tenants (
    id uuid primary key,
    name varchar(150) not null,
    legal_name varchar(200),
    tax_id varchar(50),
    status varchar(30) not null,
    created_at timestamptz not null,
    updated_at timestamptz not null
);
```

## 7.3 Stores

``` sql
create table stores (
    id uuid primary key,
    tenant_id uuid not null references tenants(id),
    name varchar(150) not null,
    address varchar(300),
    phone varchar(50),
    active boolean not null default true,
    created_at timestamptz not null,
    updated_at timestamptz not null
);

create index idx_stores_tenant on stores(tenant_id);
```

## 7.4 Products

``` sql
create table products (
    id uuid primary key,
    tenant_id uuid not null references tenants(id),
    category_id uuid,
    brand_id uuid,
    name varchar(200) not null,
    description text,
    active boolean not null default true,
    created_at timestamptz not null,
    updated_at timestamptz not null
);
```

## 7.5 Product variants

``` sql
create table product_variants (
    id uuid primary key,
    tenant_id uuid not null references tenants(id),
    product_id uuid not null references products(id),
    sku varchar(80) not null,
    barcode varchar(80),
    sale_price numeric(14,2) not null,
    active boolean not null default true,
    created_at timestamptz not null,
    updated_at timestamptz not null,
    unique (tenant_id, sku)
);

create unique index uq_variant_barcode
on product_variants(tenant_id, barcode)
where barcode is not null;
```

## 7.6 Inventory

``` sql
create table inventory (
    id uuid primary key,
    tenant_id uuid not null references tenants(id),
    store_id uuid not null references stores(id),
    variant_id uuid not null references product_variants(id),
    quantity numeric(14,3) not null default 0,
    average_cost numeric(14,2) not null default 0,
    min_stock numeric(14,3) not null default 0,
    updated_at timestamptz not null,
    unique (store_id, variant_id)
);
```

## 7.7 Inventory movements

``` sql
create table inventory_movements (
    id uuid primary key,
    tenant_id uuid not null references tenants(id),
    store_id uuid not null references stores(id),
    variant_id uuid not null references product_variants(id),
    movement_type varchar(40) not null,
    quantity numeric(14,3) not null,
    unit_cost numeric(14,2),
    reference_type varchar(50),
    reference_id uuid,
    reason varchar(300),
    created_by uuid not null,
    created_at timestamptz not null
);
```

## 7.8 Sales

``` sql
create table sales (
    id uuid primary key,
    tenant_id uuid not null references tenants(id),
    store_id uuid not null references stores(id),
    customer_id uuid,
    status varchar(30) not null,
    subtotal numeric(14,2) not null,
    discount numeric(14,2) not null default 0,
    total numeric(14,2) not null,
    completed_at timestamptz,
    created_by uuid not null,
    created_at timestamptz not null
);

create table sale_items (
    id uuid primary key,
    sale_id uuid not null references sales(id),
    variant_id uuid not null references product_variants(id),
    quantity numeric(14,3) not null,
    unit_price numeric(14,2) not null,
    discount numeric(14,2) not null default 0,
    unit_cost numeric(14,2),
    total numeric(14,2) not null
);
```

## 7.9 Payments

``` sql
create table payments (
    id uuid primary key,
    sale_id uuid not null references sales(id),
    payment_method varchar(40) not null,
    amount numeric(14,2) not null,
    reference varchar(150),
    created_at timestamptz not null
);
```

## 7.10 Customers

``` sql
create table customers (
    id uuid primary key,
    tenant_id uuid not null references tenants(id),
    full_name varchar(200) not null,
    whatsapp varchar(50),
    email varchar(200),
    birthday date,
    marketing_consent boolean not null default false,
    created_at timestamptz not null,
    updated_at timestamptz not null
);
```

## 7.11 Audit

``` sql
create table audit_logs (
    id uuid primary key,
    tenant_id uuid not null references tenants(id),
    user_id uuid not null,
    action varchar(100) not null,
    entity_type varchar(100) not null,
    entity_id uuid,
    old_value jsonb,
    new_value jsonb,
    ip_address inet,
    created_at timestamptz not null
);
```

## 7.12 Índices

Los índices mínimos deben cubrir:

-   `(tenant_id, sku)`;
-   `(tenant_id, barcode)`;
-   `(tenant_id, created_at)` en operaciones;
-   `(store_id, variant_id)` en inventario;
-   `(tenant_id, customer_id)` en ventas;
-   `(tenant_id, status)` en órdenes y ventas;
-   timestamps de movimientos.

Los índices se revisarán con `EXPLAIN ANALYZE` sobre datos
representativos.

# 8. Multi-tenancy

## 8.1 Modelo

Se utiliza una base de datos compartida y tablas compartidas con
`tenant_id`.

## 8.2 Resolución del tenant

El tenant se obtiene del contexto autenticado, no de un valor enviado
libremente por el frontend.

``` text
JWT
 |
 +--> user_id
 +--> tenant_id
 +--> roles
 |
 v
TenantContext
```

## 8.3 TenantContext

El backend tendrá un contexto por request. Los repositorios deben
recibir o aplicar el tenant de manera segura.

## 8.4 Prohibición

Nunca aceptar:

``` http
GET /api/products?tenantId=otro-tenant
```

como mecanismo de autorización.

El `tenant_id` enviado por el cliente no concede acceso.

## 8.5 Aislamiento

Toda consulta de negocio debe incluir tenant. Se recomienda una
combinación de:

-   filtros de aplicación;
-   repositorios conscientes del tenant;
-   pruebas automatizadas de aislamiento;
-   PostgreSQL Row Level Security como opción futura para
    endurecimiento.

## 8.6 Prueba crítica

Crear Tenant A y Tenant B, insertar datos similares y demostrar
automáticamente que un usuario A nunca puede leer, modificar o eliminar
datos de B.

# 9. Seguridad

## 9.1 Autenticación

Flujo:

``` text
POST /auth/login
       |
       v
validar credenciales
       |
       v
access token + refresh token
```

Access token de corta duración. Refresh token persistido de forma segura
y revocable.

## 9.2 Passwords

Nunca almacenar contraseñas. Usar hashing adaptativo.

## 9.3 JWT

Claims mínimos:

``` json
{
  "sub": "user-id",
  "tenant_id": "tenant-id",
  "roles": ["ADMIN"],
  "iat": 0,
  "exp": 0
}
```

No incluir información sensible ni permisos excesivos si puede
resolverse mediante backend.

## 9.4 RBAC

Ejemplo:

``` text
PRODUCT_READ
PRODUCT_WRITE
INVENTORY_READ
INVENTORY_ADJUST
PURCHASE_CREATE
SALE_CREATE
SALE_RETURN
CASH_OPEN
CASH_CLOSE
REPORT_VIEW
USER_MANAGE
SETTINGS_MANAGE
```

## 9.5 Rate limiting

Especialmente en:

-   login;
-   refresh;
-   endpoints públicos;
-   búsquedas intensivas.

## 9.6 HTTP

-   HTTPS;
-   HSTS;
-   CORS restringido;
-   headers de seguridad;
-   payload limits;
-   validación de entrada;
-   protección contra inyección.

## 9.7 Auditoría

Los cambios de permisos, precios, inventario, caja y operaciones de
venta deben quedar auditados.

# 10. API REST

## 10.1 Convenciones

Base:

``` text
/api/v1
```

Recursos:

``` text
GET    /api/v1/products
POST   /api/v1/products
GET    /api/v1/products/{id}
PATCH  /api/v1/products/{id}
```

## 10.2 Respuesta de error

``` json
{
  "code": "INVENTORY_INSUFFICIENT",
  "message": "Insufficient inventory",
  "traceId": "01H...",
  "timestamp": "2026-10-04T20:00:00Z"
}
```

El frontend no debe depender de mensajes humanos para lógica.

## 10.3 Paginación

``` text
?page=0&size=20&sort=createdAt,desc
```

## 10.4 Idempotencia

Operaciones sensibles, especialmente ventas y recepción de compras,
deben soportar claves de idempotencia.

``` http
Idempotency-Key: 4f7...
```

Esto evita duplicar una venta si el usuario pulsa dos veces o si la red
reintenta.

## 10.5 API de ventas

``` text
POST /api/v1/sales
GET  /api/v1/sales/{id}
POST /api/v1/sales/{id}/complete
POST /api/v1/sales/{id}/exchange
```

## 10.6 API de inventario

``` text
GET  /api/v1/inventory
GET  /api/v1/inventory/{variantId}/movements
POST /api/v1/inventory/adjustments
POST /api/v1/inventory/physical-counts
```

## 10.7 API de clientes

``` text
GET  /api/v1/customers
POST /api/v1/customers
GET  /api/v1/customers/{id}
GET  /api/v1/customers/{id}/purchase-history
```

# 11. Flujo de venta de extremo a extremo

## 11.1 Flujo

``` text
Escanear producto
      |
      v
Validar variante
      |
      v
Agregar carrito
      |
      v
Aplicar descuento
      |
      v
Seleccionar cliente
      |
      v
Registrar pagos
      |
      v
Validar total
      |
      v
Transacción DB
      |
      +--> Venta
      +--> Items
      +--> Inventario
      +--> Caja
      +--> CRM
      |
      v
Commit
      |
      v
Evento SaleCompleted
      |
      +--> Facturación
      +--> reportes/analítica
```

## 11.2 Transacción

La confirmación de venta y los cambios críticos deben ocurrir dentro de
una transacción.

No se debe:

1.  descontar inventario;
2.  hacer HTTP a DIAN;
3.  registrar venta;
4.  descubrir que falló algo;
5.  dejar la base en un estado parcial.

La integración externa debe estar desacoplada mediante estado y eventos.

## 11.3 Estado de venta

``` text
DRAFT
  |
  v
CONFIRMED
  |
  +--> CANCELLED
```

Una venta confirmada no vuelve a DRAFT.

## 11.4 Concurrencia

Dos cajas no deben vender la última unidad simultáneamente.

Se debe aplicar control de concurrencia sobre el registro de inventario,
usando locking apropiado o actualización condicional.

Ejemplo conceptual:

``` sql
update inventory
set quantity = quantity - :quantity
where id = :id
  and quantity >= :quantity;
```

La aplicación verifica que se haya actualizado una fila.

# 12. Inventario y Kardex

## 12.1 Tipos de movimiento

``` text
PURCHASE_RECEIPT
SALE
SALE_RETURN
ADJUSTMENT_IN
ADJUSTMENT_OUT
PHYSICAL_COUNT
TRANSFER_IN
TRANSFER_OUT
```

## 12.2 Regla de inmutabilidad

Un movimiento confirmado no se edita.

Si se cometió un error:

``` text
Movimiento incorrecto
        |
        v
Movimiento compensatorio
```

## 12.3 Costo promedio

Cuando entra mercancía:

``` text
nuevo_costo =
(
 stock_actual * costo_actual
 +
 cantidad_entrada * costo_entrada
)
/
(
 stock_actual + cantidad_entrada
)
```

Debe calcularse con precisión monetaria y dentro de la misma transacción
que actualiza inventario.

## 12.4 Inventario físico

Flujo:

``` text
Crear conteo
   |
   v
Congelar o controlar operaciones según política
   |
   v
Registrar cantidades contadas
   |
   v
Comparar
   |
   v
Generar diferencias
   |
   v
Aprobar ajuste
   |
   v
Crear movimientos
```

## 12.5 Stock mínimo

Cada variante puede tener stock mínimo por tienda.

Cuando:

``` text
quantity <= min_stock
```

se genera una condición de alerta.

No se modifica inventario solo por generar la alerta.

# 13. Compras y proveedores

## 13.1 Estados de PurchaseOrder

``` text
DRAFT
SENT
PARTIALLY_RECEIVED
RECEIVED
CANCELLED
```

## 13.2 Recepción

Una orden puede recibirse parcialmente.

Ejemplo:

``` text
Pedido: 20 camisetas
Recibido: 12
Pendiente: 8
```

La recepción crea movimientos de inventario.

## 13.3 Precio de compra

El costo real debe guardar:

-   costo unitario;
-   cantidad;
-   descuentos;
-   impuestos si aplican;
-   otros costos atribuibles cuando se implementen.

## 13.4 Proveedores

Campos mínimos:

-   razón social/nombre;
-   identificación;
-   teléfono;
-   email;
-   dirección;
-   contacto;
-   estado.

# 14. POS y experiencia de usuario

## 14.1 Principios

La pantalla de venta debe priorizar velocidad.

Diseño recomendado:

``` text
+------------------------------------------------+
| Buscar producto / escanear código              |
+---------------------------+--------------------+
| Productos                 | Carrito            |
|                           |                    |
| [Camiseta] [Jean]        | Camiseta x2       |
| [Gorra]    [Jogger]      | Jean x1           |
|                           |                    |
|                           | TOTAL $250.000    |
+---------------------------+--------------------+
| Cliente | Descuento | Pagar                  |
+------------------------------------------------+
```

## 14.2 Atajos

Preparar atajos de teclado para:

-   enfocar búsqueda;
-   limpiar carrito;
-   cobrar;
-   cancelar operación.

## 14.3 Responsive

La misma aplicación debe funcionar en:

-   monitor de escritorio;
-   portátil;
-   tablet.

En tablet se priorizan controles grandes y lectura rápida.

## 14.4 Accesibilidad

-   contraste adecuado;
-   navegación por teclado;
-   labels;
-   estados de error visibles;
-   no depender únicamente del color.

# 15. Caja y conciliación

## 15.1 CashRegister

Representa la caja física o lógica.

## 15.2 CashSession

Representa una apertura/cierre.

Estados:

``` text
OPEN
CLOSED
```

## 15.3 Movimientos

Tipos:

``` text
OPENING
SALE
REFUND
WITHDRAWAL
EXPENSE
ADJUSTMENT
CLOSING
```

## 15.4 Arqueo

El sistema calcula efectivo esperado.

``` text
expected_cash =
opening_cash
+ cash_sales
+ cash_in
- cash_refunds
- withdrawals
- expenses
```

El valor contado se introduce manualmente.

Diferencia:

``` text
difference = counted_cash - expected_cash
```

## 15.5 No alterar historia

Un cierre no debe sobrescribirse. Correcciones posteriores deben ser
nuevos movimientos administrativos.

# 16. CRM

## 16.1 Datos

El CRM debe comenzar con información útil y no con un formulario de 43
campos que nadie completa.

Campos:

-   nombre;
-   WhatsApp;
-   email;
-   cumpleaños;
-   historial;
-   tallas habituales;
-   categorías favoritas;
-   productos favoritos;
-   consentimiento de marketing.

## 16.2 Métricas

Derivadas de las ventas:

``` text
purchase_count
total_spent
average_ticket
last_purchase_at
first_purchase_at
```

## 16.3 Segmentación

Segmentos iniciales:

-   nuevo;
-   frecuente;
-   alto valor;
-   inactivo;
-   comprador por categoría.

Los segmentos pueden calcularse, no necesariamente almacenarse como
verdad permanente.

## 16.4 Consentimiento

El consentimiento debe registrar al menos:

-   estado;
-   fecha;
-   origen;
-   versión del texto/política si aplica.

No se debe asumir que tener WhatsApp implica consentimiento comercial.

# 17. Facturación electrónica

## 17.1 Principio

El POS no implementará desde cero toda la complejidad de facturación
electrónica. Utilizará un proveedor tecnológico.

## 17.2 Puerto de dominio

``` java
public interface ElectronicInvoicingProvider {
    InvoiceSubmissionResult issue(InvoiceRequest request);
    CreditNoteResult issueCreditNote(CreditNoteRequest request);
    DocumentStatus getStatus(String externalId);
}
```

## 17.3 Estados

``` text
PENDING
SUBMITTED
ACCEPTED
REJECTED
ERROR
```

## 17.4 Asincronía

La venta no debe quedar inutilizable por una caída temporal del
proveedor si legalmente el flujo permite manejar el documento pendiente.

La aplicación debe conservar:

-   request;
-   response;
-   identificador externo;
-   estado;
-   timestamps;
-   error técnico;
-   error funcional.

## 17.5 Reintentos

Usar backoff exponencial con límite. Nunca generar facturas duplicadas
por reintentos ciegos.

# 18. Eventos de dominio y aplicaciones

## 18.1 Eventos

Eventos iniciales:

``` text
SaleCompleted
InventoryReceived
InventoryAdjusted
PurchaseOrderReceived
CustomerCreated
CashSessionClosed
InvoiceIssued
InvoiceRejected
```

## 18.2 Domain Event vs Integration Event

Un evento de dominio describe algo ocurrido dentro del dominio.

Un evento de integración es un contrato diseñado para sistemas externos.

Inicialmente se pueden implementar internamente, pero no deben mezclarse
conceptualmente.

## 18.3 Outbox futura

Si el sistema empieza a depender de eventos externos, implementar
Transactional Outbox:

``` text
Transaction
 ├── business change
 └── outbox event

Outbox worker
      |
      v
external broker / integration
```

Esto evita perder eventos después de hacer commit.

# 19. Frontend React

## 19.1 Estructura

``` text
src/
├── app/
│   ├── router/
│   ├── providers/
│   └── layouts/
├── features/
│   ├── auth/
│   ├── products/
│   ├── inventory/
│   ├── purchases/
│   ├── sales/
│   ├── cash/
│   ├── customers/
│   └── reports/
├── components/
├── hooks/
├── lib/
├── services/
├── types/
└── styles/
```

## 19.2 Estado

Separar:

-   estado de servidor;
-   estado de UI;
-   estado local del formulario;
-   estado temporal del carrito.

No convertir todo en un store global.

## 19.3 Cliente HTTP

Centralizar:

-   base URL;
-   autenticación;
-   refresh;
-   errores;
-   correlation/trace ID.

## 19.4 Formularios

Validación en frontend mejora UX, pero el backend siempre valida.

## 19.5 Manejo de errores

Errores funcionales deben mostrar mensajes útiles.

Ejemplo:

``` text
No hay suficiente stock.
Disponible: 2
Solicitado: 3
```

El código interno puede ser:

``` text
INVENTORY_INSUFFICIENT
```

# 20. Offline y sincronización futura

## 20.1 MVP

La aplicación detecta conectividad y puede deshabilitar operaciones
críticas si no hay backend.

## 20.2 Preparación

La PWA puede usar IndexedDB para:

-   catálogo cacheado;
-   configuración;
-   últimas búsquedas;
-   datos no sensibles necesarios para UX.

## 20.3 Futuro

Para ventas offline se requiere:

-   identificadores generados localmente;
-   cola de comandos;
-   idempotencia;
-   resolución de conflictos;
-   sincronización;
-   estado de operación.

No se implementa en MVP porque la complejidad es considerable.

# 21. Reportes y analítica

## 21.1 Reportes MVP

-   ventas del día;
-   ventas por período;
-   ventas por producto;
-   ventas por categoría;
-   utilidad;
-   margen;
-   productos más vendidos;
-   productos menos vendidos;
-   rotación;
-   clientes frecuentes;
-   ticket promedio;
-   métodos de pago;
-   flujo de caja;
-   compras;
-   rentabilidad.

## 21.2 Definiciones

### Ticket promedio

``` text
ventas netas / número de ventas
```

### Margen bruto

``` text
ventas netas - costo de mercancía
```

### Margen %

``` text
margen bruto / ventas netas * 100
```

Las definiciones deben estar centralizadas y documentadas.

## 21.3 Reportes costosos

Si una consulta se vuelve lenta:

1.  revisar índices;
2.  optimizar query;
3.  materializar agregados;
4.  usar tablas de hechos;
5.  solo después evaluar un warehouse.

# 22. Observabilidad

## 22.1 Logs

Logs estructurados en JSON en producción.
La recolección y centralización de logs se realiza a través de **Promtail** y se almacenan en **Loki**. La visualización se realiza a través de **Grafana** (con dashboards provisionados automáticamente). El rastreo de errores y excepciones en frontend y backend se centraliza en **Sentry**.

Campos:

-   timestamp;
-   level;
-   service;
-   module;
-   trace_id;
-   user_id cuando corresponda;
-   tenant_id;
-   message;
-   error.

Nunca registrar:

-   passwords;
-   tokens;
-   datos de tarjeta;
-   secretos.

## 22.2 Health checks

Endpoints:

``` text
/actuator/health
```

Separar:

-   liveness;
-   readiness.

## 22.3 Métricas

Iniciales:

-   request count;
-   latency;
-   error rate;
-   DB latency;
-   ventas completadas;
-   errores de facturación;
-   jobs fallidos.

## 22.4 Alertas

Alertar por:

-   backend caído;
-   DB inaccesible;
-   disco lleno;
-   backup fallido;
-   error rate elevado;
-   facturación externa fallando.

# 23. Docker y despliegue

## 23.1 Servicios

``` text
docker-compose.yml
├── nginx
├── frontend
├── backend
└── postgres
```

En producción, PostgreSQL puede migrarse a un servicio administrado si
el crecimiento lo justifica.

## 23.2 Variables

Nunca incluir secretos en Git.

Ejemplo:

``` text
DATABASE_URL
DATABASE_USERNAME
DATABASE_PASSWORD
JWT_SECRET
BILLING_API_KEY
```

## 23.3 Nginx

Responsabilidades:

-   TLS;
-   reverse proxy;
-   servir frontend;
-   compresión;
-   headers;
-   límites básicos.

## 23.4 Backups

Plan inicial:

-   backup diario;
-   retención de 7-30 días;
-   copia fuera del VPS;
-   prueba periódica de restauración.

Un backup que jamás se ha restaurado es una esperanza con formato
`.sql`.

# 24. CI/CD

## 24.1 Pipeline

``` text
git push
   |
   v
Lint
   |
   v
Unit tests
   |
   v
Integration tests
   |
   v
Build
   |
   v
Docker image
   |
   v
Security checks
   |
   v
Deploy staging
   |
   v
Smoke tests
   |
   v
Production
```

## 24.2 Branching

Recomendación:

``` text
main
develop (si realmente aporta)
feature/*
fix/*
```

Si el equipo sigue siendo pequeño, trunk-based development también es
válido.

## 24.3 Migraciones

Usar Flyway o Liquibase. Cada cambio de esquema debe versionarse.

Nunca editar silenciosamente una migración ya aplicada en producción.

# 25. Testing

## 25.1 Pirámide

``` text
          E2E
         /----\
       Integration
      /----------\
        Unit
```

## 25.2 Unit tests

Especialmente:

-   reglas de precios;
-   descuentos;
-   costo promedio;
-   disponibilidad;
-   cambios;
-   caja;
-   permisos.

## 25.3 Integration tests

-   PostgreSQL real mediante Testcontainers;
-   repositorios;
-   transacciones;
-   aislamiento tenant;
-   APIs críticas.

## 25.4 E2E

Flujos prioritarios:

1.  login;
2.  crear producto;
3.  recibir compra;
4.  vender producto;
5.  registrar pago;
6.  cerrar caja;
7.  realizar cambio.

## 25.5 Casos de concurrencia

Probar dos ventas simultáneas sobre la última unidad.

# 26. ADR - Decisiones arquitectónicas

## ADR-001 Monolito modular

**Estado:** Aceptado.

**Decisión:** iniciar como monolito modular.

**Motivo:** equipo pequeño, menor complejidad operativa, transacciones
simples y velocidad de desarrollo.

**Consecuencia:** los límites de módulo deben mantenerse estrictos.

## ADR-002 PostgreSQL

**Estado:** Aceptado.

**Motivo:** robustez transaccional, tipos ricos, JSONB, índices y buen
soporte en ecosistema Java.

## ADR-003 Multi-tenant por tenant_id

**Estado:** Aceptado.

**Motivo:** equilibrio entre aislamiento, costo y simplicidad.

## ADR-004 Facturación externa

**Estado:** Aceptado.

**Motivo:** reducir riesgo regulatorio y complejidad.

## ADR-005 React + TypeScript

**Estado:** Aceptado.

**Motivo:** experiencia de desarrollo, ecosistema y facilidad para PWA
responsive.

## ADR-006 Java 21 + Spring Boot

**Estado:** Aceptado.

**Motivo:** experiencia existente, estabilidad, ecosistema empresarial y
soporte para dominio transaccional.

## ADR-007 UUID

**Estado:** Aceptado.

**Motivo:** identificadores no predecibles y facilidad para futuras
sincronizaciones/distribución.

## ADR-008 Eventos internos

**Estado:** Aceptado.

**Motivo:** desacoplar módulos sin introducir un broker prematuramente.

# 27. Convenciones de código

## Java

-   clases en PascalCase;
-   métodos y variables en camelCase;
-   DTOs explícitos;
-   evitar entidades JPA como DTOs;
-   servicios de aplicación con nombres de casos de uso;
-   excepciones de dominio específicas;
-   evitar métodos gigantes.

Ejemplo:

``` java
@Service
@RequiredArgsConstructor
public class CompleteSaleService {

    private final SaleRepository saleRepository;
    private final InventoryService inventoryService;
    private final PaymentService paymentService;

    @Transactional
    public SaleResult execute(CompleteSaleCommand command) {
        // ...
    }
}
```

## TypeScript

-   tipos explícitos para contratos;
-   componentes pequeños;
-   hooks especializados;
-   lógica de dominio fuera de componentes visuales;
-   evitar `any`.

## SQL

-   migraciones versionadas;
-   nombres explícitos;
-   constraints en DB además de validaciones de aplicación.

# 28. Contratos de dominio

## Sale

``` text
Sale
 ├── id
 ├── tenantId
 ├── storeId
 ├── customerId
 ├── status
 ├── items[]
 ├── payments[]
 ├── subtotal
 ├── discount
 └── total
```

## SaleItem

``` text
SaleItem
 ├── variantId
 ├── quantity
 ├── unitPrice
 ├── discount
 ├── unitCost
 └── total
```

## ProductVariant

``` text
ProductVariant
 ├── productId
 ├── sku
 ├── barcode
 ├── attributes
 ├── salePrice
 └── active
```

## InventoryMovement

``` text
InventoryMovement
 ├── variantId
 ├── type
 ├── quantity
 ├── unitCost
 ├── reference
 ├── reason
 └── createdBy
```

# 29. Flujos operativos detallados

## 29.1 Alta de producto

``` text
Admin
 |
 +--> crear categoría
 |
 +--> crear producto
 |
 +--> definir variantes
 |
 +--> asignar atributos
 |
 +--> SKU
 |
 +--> código de barras
 |
 +--> precio
 |
 v
Producto activo
```

## 29.2 Compra

``` text
Crear proveedor
      |
Crear orden
      |
Enviar
      |
Recibir mercancía
      |
Comparar cantidades
      |
Confirmar recepción
      |
Inventario +
      |
Costo promedio actualizado
```

## 29.3 Venta

``` text
Escanear
   |
Carrito
   |
Cliente opcional
   |
Descuento
   |
Pagos
   |
Validación
   |
Venta confirmada
   |
Inventario -
   |
Caja +
   |
CRM actualizado
   |
Factura
```

## 29.4 Cambio

``` text
Venta original
    |
Seleccionar item
    |
Validar política
    |
Recibir producto
    |
Inventario +
    |
Entregar nuevo producto
    |
Inventario -
    |
Calcular diferencia
    |
Registrar pago/saldo
```

## 29.5 Cierre de caja

``` text
Abrir sesión
   |
Operar
   |
Registrar movimientos
   |
Cerrar
   |
Calcular esperado
   |
Contar efectivo
   |
Registrar diferencia
   |
Cerrar sesión
```

# 30. Políticas de integridad

## 30.1 Dinero

Usar `BigDecimal` en Java y `numeric` en PostgreSQL.

Nunca usar `double` para dinero.

## 30.2 Cantidades

Aunque actualmente la ropa normalmente se vende por unidad, mantener
soporte numérico razonable para cantidades.

## 30.3 Fechas

Persistir en UTC. Convertir a timezone de la tienda en
frontend/reportes.

## 30.4 Eliminaciones

Productos vendidos históricamente no deben eliminarse físicamente. Usar
`active=false`.

## 30.5 Referencias

Una venta debe conservar sus precios históricos aunque el precio del
producto cambie después.

## 30.6 Costos históricos

El costo usado para calcular una venta debe guardarse en
`sale_items.unit_cost`.

Esto evita que cambiar posteriormente el costo del producto altere
artificialmente la rentabilidad histórica.

# 31. Performance

## 31.1 Objetivo

Optimizar con evidencia.

Orden:

1.  medir;
2.  localizar cuello de botella;
3.  optimizar;
4.  medir nuevamente.

## 31.2 Database

Evitar:

-   N+1;
-   consultas sin índices;
-   traer tablas completas;
-   joins innecesarios;
-   paginación en memoria.

## 31.3 Frontend

-   lazy loading de módulos;
-   cache de consultas;
-   debounce en búsquedas;
-   virtualización para listas grandes;
-   evitar renders innecesarios.

## 31.4 POS

La búsqueda por SKU/código de barras debe ser una operación prioritaria
y extremadamente rápida.

# 32. Migración futura a microservicios

No se debe separar por anticipación. Si llega el momento, posibles
candidatos:

``` text
billing-service
notification-service
analytics-service
inventory-service
```

La extracción debe seguir:

``` text
Módulo estable
    |
Contrato explícito
    |
Eventos
    |
Repositorio independiente
    |
Servicio independiente
```

El primer candidato probable sería un módulo con fuerte carga externa o
escalamiento independiente, no necesariamente inventario.

La extracción de un módulo no debe requerir cambiar la lógica de todos
los demás.

# 33. Roadmap técnico

## Fase 0 - Foundation

-   repositorios;
-   CI;
-   Spring Boot;
-   React;
-   PostgreSQL;
-   Docker;
-   migraciones;
-   estructura modular;
-   autenticación.

## Fase 1 - MVP

-   catálogo;
-   variantes;
-   inventario;
-   compras;
-   POS;
-   caja;
-   CRM;
-   reportes;
-   auditoría.

## Fase 2 - Operación comercial

-   facturación;
-   cambios avanzados;
-   fidelización;
-   WhatsApp;
-   campañas;
-   multi-sucursal.

## Fase 3 - SaaS

-   onboarding de tenants;
-   billing del SaaS;
-   planes;
-   límites;
-   administración global;
-   métricas de plataforma.

## Fase 4 - Inteligencia

-   predicción;
-   recomendaciones;
-   segmentación automática;
-   reposición sugerida;
-   detección de anomalías.

## Fase 5 - Omnicanal

-   e-commerce;
-   pedidos online;
-   sincronización;
-   clientes omnicanal.

# 34. Definition of Done

Una funcionalidad se considera terminada cuando:

-   existe caso de uso;
-   existe endpoint si corresponde;
-   existen reglas de autorización;
-   existe validación;
-   existe migración;
-   existen pruebas unitarias;
-   existen pruebas de integración para operaciones críticas;
-   existe manejo de errores;
-   existe auditoría si aplica;
-   existe documentación;
-   el frontend maneja estados de loading/error/empty;
-   funciona con más de un tenant en pruebas;
-   no introduce acceso cruzado entre tenants;
-   CI pasa;
-   puede desplegarse reproduciblemente.

No se considera terminada porque "funciona en mi máquina".

# 35. Checklist de seguridad antes de producción

-   [ ] HTTPS activo
-   [ ] Secretos fuera de Git
-   [ ] JWT secret rotado y seguro
-   [ ] Refresh tokens revocables
-   [ ] CORS restringido
-   [ ] Rate limiting
-   [ ] Password hashing
-   [ ] Headers de seguridad
-   [ ] Validación de entrada
-   [ ] SQL injection cubierta mediante ORM/queries parametrizadas
-   [ ] Logs sin información sensible
-   [ ] Backups
-   [ ] Restauración probada
-   [ ] Usuario DB con mínimos privilegios
-   [ ] Puerto PostgreSQL no expuesto públicamente
-   [ ] Auditoría activa
-   [ ] Pruebas de aislamiento multi-tenant

# 36. Checklist de lanzamiento MVP

### Backend

-   [ ] Auth
-   [ ] Tenancy
-   [ ] RBAC
-   [ ] Catálogo
-   [ ] Inventario
-   [ ] Compras
-   [ ] Ventas
-   [ ] Caja
-   [ ] CRM
-   [ ] Reportes
-   [ ] Auditoría
-   [ ] Integración de facturación

### Frontend

-   [ ] Login
-   [ ] Dashboard
-   [ ] POS
-   [ ] Catálogo
-   [ ] Inventario
-   [ ] Compras
-   [ ] Clientes
-   [ ] Caja
-   [ ] Reportes
-   [ ] Configuración

### Infra

-   [ ] Docker
-   [ ] Nginx
-   [ ] TLS
-   [ ] Backup
-   [ ] Monitoring
-   [ ] CI/CD

### Calidad

-   [ ] Unit tests
-   [ ] Integration tests
-   [ ] E2E
-   [ ] Tenant isolation tests
-   [ ] Load smoke test

# 37. Riesgos técnicos

  Riesgo                          Probabilidad   Impacto   Mitigación
  ------------------------------- -------------- --------- ------------------------
  Error de stock                  Media          Alto      Kardex + transacciones
  Venta duplicada                 Media          Alto      Idempotency-Key
  Aislamiento tenant incorrecto   Baja           Crítico   filtros + tests
  Fallo proveedor factura         Media          Alto      estados + reintentos
  Corrupción DB                   Baja           Crítico   backups + restore
  Crecimiento de queries          Media          Medio     índices + profiling
  Complejidad offline             Alta           Alto      posponer
  Microservicios prematuros       Alta           Medio     monolito modular
  CRM sobredimensionado           Media          Medio     MVP mínimo
  IA prematura                    Alta           Bajo      fase posterior

# 38. Reglas de oro del proyecto

1.  El inventario se mueve mediante movimientos trazables.
2.  Las ventas confirmadas no se editan destructivamente.
3.  El histórico conserva el precio y costo de la operación.
4.  Ningún usuario cruza tenants.
5.  Las integraciones externas están detrás de adaptadores.
6.  Los módulos no acceden arbitrariamente al estado interno de otros
    módulos.
7.  Toda operación crítica debe ser transaccional.
8.  Las operaciones repetibles deben ser idempotentes.
9.  La base de datos es parte del dominio de integridad, no un simple
    almacén.
10. No se introducen microservicios porque el diagrama se vea más
    impresionante.
11. No se implementa offline completo hasta tener una necesidad real.
12. No se implementa IA antes de tener datos confiables.
13. Toda decisión arquitectónica importante queda documentada.
14. Se mide antes de optimizar.
15. El sistema debe ser útil para una tienda real antes de intentar
    servir a mil.

# 39. Apéndice - Ejemplo de estructura de repositorio

``` text
pos-platform/
├── backend/
│   ├── src/
│   ├── build.gradle
│   ├── Dockerfile
│   └── README.md
│
├── frontend/
│   ├── src/
│   ├── package.json
│   ├── Dockerfile
│   └── README.md
│
├── infrastructure/
│   ├── nginx/
│   ├── docker/
│   └── scripts/
│
├── docs/
│   ├── architecture/
│   ├── adr/
│   ├── api/
│   ├── domain/
│   └── runbooks/
│
├── docker-compose.yml
├── .env.example
├── README.md
└── CONTRIBUTING.md
```

## Documentación viva

A partir de esta versión, cualquier cambio relevante debe actualizar:

-   este handbook;
-   ADR correspondiente;
-   contrato API si cambia;
-   migraciones;
-   pruebas;
-   documentación operativa.

# 40. ADR template

# ADR-XXX - Título

## Estado

Propuesto / Aceptado / Rechazado / Deprecado

## Contexto

¿Qué problema estamos resolviendo?

## Decisión

¿Qué decidimos?

## Alternativas

¿Qué otras opciones se evaluaron?

## Consecuencias

¿Qué ganamos y qué sacrificamos?

## Seguridad

¿Tiene impacto de seguridad?

## Operación

¿Cómo se despliega y monitorea?

## Migración

¿Cómo se implementa si sustituye una decisión anterior?

# 41. Contrato inicial de casos de uso

### Authentication

-   Login
-   RefreshToken
-   Logout
-   ChangePassword

### Catalog

-   CreateProduct
-   UpdateProduct
-   CreateVariant
-   UpdateVariant
-   SearchProducts
-   GenerateSku

### Inventory

-   ReceiveInventory
-   AdjustInventory
-   PerformPhysicalCount
-   GetKardex
-   GetStockAlerts

### Purchasing

-   CreatePurchaseOrder
-   SendPurchaseOrder
-   ReceivePurchase
-   CancelPurchaseOrder

### Sales

-   CreateSale
-   CompleteSale
-   RegisterPayment
-   ExchangeSaleItem
-   GetSale

### Cash

-   OpenCashSession
-   RegisterCashMovement
-   CloseCashSession

### CRM

-   CreateCustomer
-   UpdateCustomer
-   GetCustomerHistory
-   SegmentCustomers

### Reporting

-   GetSalesSummary
-   GetProductProfitability
-   GetInventoryRotation
-   GetCustomerMetrics

# 42. Contrato inicial de eventos

``` text
SaleCompleted {
    saleId
    tenantId
    storeId
    customerId
    total
    occurredAt
}

InventoryReceived {
    receiptId
    tenantId
    storeId
    occurredAt
}

InventoryAdjusted {
    adjustmentId
    tenantId
    storeId
    reason
    occurredAt
}

CashSessionClosed {
    sessionId
    tenantId
    storeId
    expectedCash
    countedCash
    difference
    occurredAt
}

InvoiceIssued {
    invoiceId
    tenantId
    externalId
    occurredAt
}
```

Los contratos deben evolucionar con compatibilidad. Los eventos no deben
contener objetos JPA completos.

# 43. Runbook operativo inicial

## Backend caído

1.  Revisar health check.
2.  Revisar logs.
3.  Revisar CPU/RAM/disco.
4.  Revisar PostgreSQL.
5.  Reiniciar solo si se entiende el fallo.
6.  Validar smoke tests.

## PostgreSQL caído

1.  Confirmar proceso.
2.  Revisar disco.
3.  Revisar logs.
4.  No eliminar archivos de PostgreSQL manualmente.
5.  Restaurar backup solo después de evaluar integridad.

## Disco lleno

1.  Identificar consumo.
2.  Revisar logs.
3.  Rotar/comprimir logs.
4.  Revisar imágenes Docker antiguas.
5.  Confirmar espacio para DB.

## Proveedor de facturación caído

1.  Mantener venta en estado pendiente si el proceso legal/operativo lo
    permite.
2.  Registrar error.
3.  Reintentar mediante job controlado.
4.  Evitar duplicados con idempotencia.

# 44. Evolución del esquema de datos

Toda modificación de base de datos debe:

1.  tener migración;
2.  ser compatible con la versión actualmente desplegada cuando sea
    posible;
3.  desplegarse primero en entornos de prueba;
4.  verificarse con datos representativos;
5.  tener estrategia de rollback o compensación.

Para cambios grandes:

``` text
Expand
  |
Deploy compatible
  |
Migrate data
  |
Switch reads/writes
  |
Contract
```

Evitar cambios destructivos simultáneos con despliegues de aplicación.

# 45. Plan de implementación recomendado

## Sprint 0 - Foundation

-   repositorios;
-   Docker;
-   PostgreSQL;
-   Flyway;
-   estructura Spring Boot;
-   estructura React;
-   CI;
-   lint;
-   test framework;
-   tenant context.

## Sprint 1 - Identity

-   users;
-   roles;
-   permissions;
-   login;
-   refresh;
-   audit base.

## Sprint 2 - Catalog

-   categories;
-   brands;
-   products;
-   variants;
-   attributes;
-   SKU/barcode.

## Sprint 3 - Inventory

-   stock;
-   movements;
-   adjustments;
-   physical count;
-   alerts.

## Sprint 4 - Purchasing

-   suppliers;
-   purchase orders;
-   receipts.

## Sprint 5 - POS

-   cart;
-   sales;
-   payments;
-   payment mix;
-   stock deduction.

## Sprint 6 - Cash

-   opening;
-   movements;
-   closing;
-   reconciliation.

## Sprint 7 - CRM

-   customers;
-   history;
-   metrics;
-   segments.

## Sprint 8 - Reports

-   sales;
-   profitability;
-   inventory;
-   cash;
-   customers.

## Sprint 9 - Billing

-   provider adapter;
-   invoice state machine;
-   retries;
-   credit notes.

## Sprint 10 - Hardening

-   security;
-   E2E;
-   performance;
-   backup/restore;
-   monitoring;
-   production rollout.

# 46. Criterios para separar un módulo en servicio

Un módulo solo se separará cuando exista al menos una razón fuerte:

-   escala diferente;
-   necesidad de despliegue independiente;
-   límites de seguridad;
-   dependencia externa problemática;
-   ownership claramente independiente;
-   necesidad de tecnología diferente.

No se separará únicamente porque el módulo tenga muchas clases.

Señales de madurez:

``` text
módulo estable
+
contrato explícito
+
eventos
+
pruebas de contrato
+
observabilidad
+
necesidad real
```

Entonces:

``` text
Modular Monolith
      |
      v
Extract
      |
      v
Service
```

# 47. Visión SaaS

Cuando el producto pase de una tienda a múltiples clientes, se
incorporará un contexto de plataforma:

``` text
Platform
├── Tenants
├── Plans
├── Subscriptions
├── Billing
├── Usage
└── PlatformAdmin
```

Esto es diferente del dominio de facturación electrónica de las tiendas.

El SaaS podrá medir:

-   número de usuarios;
-   número de tiendas;
-   ventas;
-   productos;
-   almacenamiento;
-   uso de integraciones.

La plataforma no debe contaminar el dominio comercial de los tenants.

# 48. Privacidad y datos de clientes

Los datos de clientes deben tratarse como información comercial
sensible.

Principios:

-   recolectar solo lo necesario;
-   definir finalidad;
-   registrar consentimiento cuando corresponda;
-   permitir actualización;
-   evitar exposición en logs;
-   controlar acceso;
-   establecer políticas de retención;
-   documentar eliminación o anonimización cuando corresponda.

Las campañas comerciales deben depender de consentimiento y
configuración del tenant, no de una suposición del sistema.

# 49. Calidad de datos

La calidad de los reportes depende de la calidad de las operaciones.

Reglas:

-   una venta debe tener items;
-   el total debe cuadrar con items y descuentos;
-   los pagos deben sumar el total;
-   una recepción no puede superar cantidades salvo tolerancia
    explícita;
-   un movimiento debe tener tipo válido;
-   una variante debe pertenecer al tenant correcto;
-   un producto inactivo no debe venderse salvo política explícita.

Se recomienda implementar invariantes tanto en dominio como en
constraints de base de datos cuando sea posible.

# 50. Estado final de Arquitectura 1.0

## Decisión consolidada

La plataforma se implementará como un **SaaS multi-tenant de retail**,
inicialmente especializado en ropa urbana y gorras.

### Backend

**Java 21 + Spring Boot**, organizado como **monolito modular** con
límites de dominio claros.

### Frontend

**React + TypeScript**, responsive y con capacidades PWA.

### Persistencia

**PostgreSQL**, UUID, migraciones versionadas, integridad relacional y
aislamiento por `tenant_id`.

### Infraestructura

**Docker + Nginx + VPS**, con CI/CD, backups y observabilidad.

### Seguridad

**JWT + Refresh Token + RBAC + auditoría**, TLS y aislamiento estricto
de tenants.

### Inventario

Kardex basado en movimientos inmutables, costo promedio ponderado,
inventario físico y alertas.

### Ventas

POS con SKU/código de barras, descuentos, pagos múltiples, cambios y
caja.

### CRM

Clientes, historial, preferencias, métricas y segmentación básica.

### Facturación

Proveedor externo mediante puerto/adaptador.

### Evolución

Eventos internos y modularidad preparan una extracción gradual de
servicios si el negocio realmente lo necesita.

## Principio final

La arquitectura debe facilitar el negocio, no convertirse en el negocio.

El producto se validará primero en una tienda real. Las decisiones
posteriores deben basarse en volumen, problemas observados, métricas y
necesidades reales, no en la tentación de agregar tecnología porque el
diagrama queda más bonito.

------------------------------------------------------------------------

**Baseline 1.0 aprobada para iniciar diseño detallado y construcción del
MVP.**
