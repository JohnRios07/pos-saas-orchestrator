# Graph Report - pos  (2026-10-14)

## Corpus Check
- 32 files · ~23,306 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 5 file(s) not represented in the graph (top: (none) 2, .example 1, .gz 1)

## Summary
- 485 nodes · 469 edges · 55 communities (50 shown, 5 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `4d51391e`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- Design: Sprint 1 - Cash Session Resilience & Validation
- Scenarios
- Tasks: Sprint 1 - Cash Session Resilience & Validation
- Backlog: V2 - Camino a Producción
- ref_fs
- Proposal: Sprint 1 - Cash Session Resilience & Validation
- POS_SaaS_Software_Architecture_Handbook_1.0.md
- 1.2 Principios de producto
- Decisión consolidada
- 5.3 Agregados principales
- 7. Modelo de datos PostgreSQL
- 45. Plan de implementación recomendado
- 2. Requisitos funcionales
- [1.1.0] - 2026-10-07
- 26. ADR - Decisiones arquitectónicas
- 41. Contrato inicial de casos de uso
- ADR-XXX - Título
- 10. API REST
- 6.2 Capas
- 9. Seguridad
- 21.2 Definiciones
- 30. Políticas de integridad
- 33. Roadmap técnico
- 3. Requisitos no funcionales
- 8. Multi-tenancy
- Skill Registry — pos
- 12. Inventario y Kardex
- local_dump.sql
- 15. Caja y conciliación
- 17. Facturación electrónica
- 19. Frontend React
- 25. Testing
- 29. Flujos operativos detallados
- POS SaaS - Orchestrator / Arquitecto
- 11. Flujo de venta de extremo a extremo
- 13. Compras y proveedores
- 14. POS y experiencia de usuario
- 16. CRM
- 22. Observabilidad
- 23. Docker y despliegue
- 28. Contratos de dominio
- 31. Performance
- 36. Checklist de lanzamiento MVP
- 43. Runbook operativo inicial
- 18. Eventos de dominio y aplicaciones
- 20. Offline y sincronización futura
- 24. CI/CD
- 27. Convenciones de código
- 4. Contexto y arquitectura C4
- opencode.json
- Software Architecture Handbook 1.0
- backup.sh

## God Nodes (most connected - your core abstractions)
1. `7. Modelo de datos PostgreSQL` - 13 edges
2. `45. Plan de implementación recomendado` - 12 edges
3. `Design: Sprint 1 - Cash Session Resilience & Validation` - 12 edges
4. `Decisión consolidada` - 11 edges
5. `Proposal: Sprint 1 - Cash Session Resilience & Validation` - 11 edges
6. `Backlog: V2 - Camino a Producción` - 10 edges
7. `2. Requisitos funcionales` - 10 edges
8. `5.3 Agregados principales` - 9 edges
9. `26. ADR - Decisiones arquitectónicas` - 9 edges
10. `ADR-XXX - Título` - 9 edges

## Surprising Connections (you probably didn't know these)
- None detected - all connections are within the same source files.

## Import Cycles
- None detected.

## Communities (55 total, 5 thin omitted)

### Community 0 - "Design: Sprint 1 - Cash Session Resilience & Validation"
Cohesion: 0.09
Nodes (21): 1. New Hook: `src/hooks/useCashSession.ts`, 2. CashManagement.tsx Modifications, 3. Sales.tsx Modifications, 4. SalesHistory.tsx Modifications, 5. Login.tsx Modifications, Architecture Overview, Backward Compatibility, CashSession (from backend) (+13 more)

### Community 1 - "Scenarios"
Cohesion: 0.11
Nodes (18): Change ID, Edge Cases Handled, FR-01: useCashSession Hook, FR-02: CashManagement.tsx - Resilient Session Display (#22), FR-03: Sales.tsx - Proactive Validation on Mount (#23), FR-04: SalesHistory.tsx - Block Returns Without Session (#26), FR-05: Login.tsx - Smart Post-Login Redirect (#28), Functional Requirements (+10 more)

### Community 2 - "Tasks: Sprint 1 - Cash Session Resilience & Validation"
Cohesion: 0.11
Nodes (17): Change ID, Definition of Done, Parallel Execution, Phase 1: Foundation (Shared Hook), Phase 2: Component Updates, Phase 3: Verification, TASK-001: Create `useCashSession` hook, TASK-002: Update CashManagement.tsx (#22) (+9 more)

### Community 3 - "Backlog: V2 - Camino a Producción"
Cohesion: 0.10
Nodes (20): Accesibilidad & Polish, Backlog: V2 - Camino a Producción, Design System Foundation, Deuda Técnica (Testing & QA), Funcionalidad de Negocio, ⚙️ MÓDULO DE CONFIGURACIÓN & POLÍTICAS TENANT (v1.3.0) | **Completado**, 🛍️ MÓDULO PLAN SEPARE / LAYAWAY (v1.4.0) | **Completado**, Notas de Crédito y Mejoras UX (+12 more)

### Community 4 - "ref_fs"
Cohesion: 0.05
Nodes (27): code, fs, code, fs, code, fs, code, fs (+19 more)

### Community 5 - "Proposal: Sprint 1 - Cash Session Resilience & Validation"
Cohesion: 0.12
Nodes (15): 1. Reusable Hook: `useCashSession()`, 2. Component-Level Changes, Acceptance Criteria, Approach, Change ID, Current State Analysis, Dependencies, Intent (+7 more)

### Community 6 - "POS_SaaS_Software_Architecture_Handbook_1.0.md"
Cohesion: 0.13
Nodes (14): 32. Migración futura a microservicios, 34. Definition of Done, 35. Checklist de seguridad antes de producción, 37. Riesgos técnicos, 38. Reglas de oro del proyecto, 39. Apéndice - Ejemplo de estructura de repositorio, 40. ADR template, 42. Contrato inicial de eventos (+6 more)

### Community 7 - "1.2 Principios de producto"
Cohesion: 0.14
Nodes (14): 1.1 Propósito, 1.2 Principios de producto, 1.3 Personas usuarias, 1.4 Alcance del MVP, 1.5 Fuera del MVP, 1. Visión del producto, Administrador, Cajero / encargado de inventario (+6 more)

### Community 8 - "Decisión consolidada"
Cohesion: 0.15
Nodes (13): 50. Estado final de Arquitectura 1.0, Backend, CRM, Decisión consolidada, Evolución, Facturación, Frontend, Infraestructura (+5 more)

### Community 9 - "5.3 Agregados principales"
Cohesion: 0.15
Nodes (13): 5.1 Bounded Contexts, 5.2 Reglas de dependencia, 5.3 Agregados principales, 5.4 Invariantes, 5. Arquitectura de dominios, CashSession, Customer, GoodsReceipt (+5 more)

### Community 10 - "7. Modelo de datos PostgreSQL"
Cohesion: 0.15
Nodes (13): 7.10 Customers, 7.11 Audit, 7.12 Índices, 7.1 Convenciones, 7.2 Tenant, 7.3 Stores, 7.4 Products, 7.5 Product variants (+5 more)

### Community 11 - "45. Plan de implementación recomendado"
Cohesion: 0.17
Nodes (12): 45. Plan de implementación recomendado, Sprint 0 - Foundation, Sprint 10 - Hardening, Sprint 1 - Identity, Sprint 2 - Catalog, Sprint 3 - Inventory, Sprint 4 - Purchasing, Sprint 5 - POS (+4 more)

### Community 12 - "2. Requisitos funcionales"
Cohesion: 0.20
Nodes (10): 2.1 Catálogo, 2.2 Inventario, 2.3 Compras, 2.4 Ventas, 2.5 Cambios, 2.6 Caja, 2.7 CRM, 2.8 Reportes (+2 more)

### Community 13 - "[1.1.0] - 2026-10-07"
Cohesion: 0.14
Nodes (13): [1.1.0] - 2026-10-07, [1.2.0] - 2026-10-09, [1.3.0] - 2026-10-09, Added, Added, Added, Added, Changed (+5 more)

### Community 14 - "26. ADR - Decisiones arquitectónicas"
Cohesion: 0.22
Nodes (9): 26. ADR - Decisiones arquitectónicas, ADR-001 Monolito modular, ADR-002 PostgreSQL, ADR-003 Multi-tenant por tenant_id, ADR-004 Facturación externa, ADR-005 React + TypeScript, ADR-006 Java 21 + Spring Boot, ADR-007 UUID (+1 more)

### Community 15 - "41. Contrato inicial de casos de uso"
Cohesion: 0.22
Nodes (9): 41. Contrato inicial de casos de uso, Authentication, Cash, Catalog, CRM, Inventory, Purchasing, Reporting (+1 more)

### Community 16 - "ADR-XXX - Título"
Cohesion: 0.22
Nodes (9): ADR-XXX - Título, Alternativas, Consecuencias, Contexto, Decisión, Estado, Migración, Operación (+1 more)

### Community 17 - "10. API REST"
Cohesion: 0.25
Nodes (8): 10.1 Convenciones, 10.2 Respuesta de error, 10.3 Paginación, 10.4 Idempotencia, 10.5 API de ventas, 10.6 API de inventario, 10.7 API de clientes, 10. API REST

### Community 18 - "6.2 Capas"
Cohesion: 0.25
Nodes (8): 6.1 Organización por módulo, 6.2 Capas, 6.3 Regla, 6. Estructura del backend, API, Application, Domain, Infrastructure

### Community 19 - "9. Seguridad"
Cohesion: 0.25
Nodes (8): 9.1 Autenticación, 9.2 Passwords, 9.3 JWT, 9.4 RBAC, 9.5 Rate limiting, 9.6 HTTP, 9.7 Auditoría, 9. Seguridad

### Community 20 - "21.2 Definiciones"
Cohesion: 0.29
Nodes (7): 21.1 Reportes MVP, 21.2 Definiciones, 21.3 Reportes costosos, 21. Reportes y analítica, Margen %, Margen bruto, Ticket promedio

### Community 21 - "30. Políticas de integridad"
Cohesion: 0.29
Nodes (7): 30.1 Dinero, 30.2 Cantidades, 30.3 Fechas, 30.4 Eliminaciones, 30.5 Referencias, 30.6 Costos históricos, 30. Políticas de integridad

### Community 22 - "33. Roadmap técnico"
Cohesion: 0.29
Nodes (7): 33. Roadmap técnico, Fase 0 - Foundation, Fase 1 - MVP, Fase 2 - Operación comercial, Fase 3 - SaaS, Fase 4 - Inteligencia, Fase 5 - Omnicanal

### Community 23 - "3. Requisitos no funcionales"
Cohesion: 0.29
Nodes (7): 3.1 Disponibilidad, 3.2 Rendimiento, 3.3 Escalabilidad, 3.4 Seguridad, 3.5 Trazabilidad, 3.6 Recuperación, 3. Requisitos no funcionales

### Community 24 - "8. Multi-tenancy"
Cohesion: 0.29
Nodes (7): 8.1 Modelo, 8.2 Resolución del tenant, 8.3 TenantContext, 8.4 Prohibición, 8.5 Aislamiento, 8.6 Prueba crítica, 8. Multi-tenancy

### Community 25 - "Skill Registry — pos"
Cohesion: 0.33
Nodes (5): Contract, Loading protocol, Skill Registry — pos, Skills, Sources scanned

### Community 26 - "12. Inventario y Kardex"
Cohesion: 0.33
Nodes (6): 12.1 Tipos de movimiento, 12.2 Regla de inmutabilidad, 12.3 Costo promedio, 12.4 Inventario físico, 12.5 Stock mínimo, 12. Inventario y Kardex

### Community 27 - "local_dump.sql"
Cohesion: 0.08
Nodes (23): public.audit_logs, public.brands, public.cash_registers, public.cash_sessions, public.cash_transactions, public.categories, public.customers, public.flyway_schema_history (+15 more)

### Community 28 - "15. Caja y conciliación"
Cohesion: 0.33
Nodes (6): 15.1 CashRegister, 15.2 CashSession, 15.3 Movimientos, 15.4 Arqueo, 15.5 No alterar historia, 15. Caja y conciliación

### Community 29 - "17. Facturación electrónica"
Cohesion: 0.33
Nodes (6): 17.1 Principio, 17.2 Puerto de dominio, 17.3 Estados, 17.4 Asincronía, 17.5 Reintentos, 17. Facturación electrónica

### Community 30 - "19. Frontend React"
Cohesion: 0.33
Nodes (6): 19.1 Estructura, 19.2 Estado, 19.3 Cliente HTTP, 19.4 Formularios, 19.5 Manejo de errores, 19. Frontend React

### Community 31 - "25. Testing"
Cohesion: 0.33
Nodes (6): 25.1 Pirámide, 25.2 Unit tests, 25.3 Integration tests, 25.4 E2E, 25.5 Casos de concurrencia, 25. Testing

### Community 32 - "29. Flujos operativos detallados"
Cohesion: 0.33
Nodes (6): 29.1 Alta de producto, 29.2 Compra, 29.3 Venta, 29.4 Cambio, 29.5 Cierre de caja, 29. Flujos operativos detallados

### Community 33 - "POS SaaS - Orchestrator / Arquitecto"
Cohesion: 0.40
Nodes (4): graphify, Invariantes, POS SaaS - Orchestrator / Arquitecto, Responsabilidades

### Community 34 - "11. Flujo de venta de extremo a extremo"
Cohesion: 0.40
Nodes (5): 11.1 Flujo, 11.2 Transacción, 11.3 Estado de venta, 11.4 Concurrencia, 11. Flujo de venta de extremo a extremo

### Community 35 - "13. Compras y proveedores"
Cohesion: 0.40
Nodes (5): 13.1 Estados de PurchaseOrder, 13.2 Recepción, 13.3 Precio de compra, 13.4 Proveedores, 13. Compras y proveedores

### Community 36 - "14. POS y experiencia de usuario"
Cohesion: 0.40
Nodes (5): 14.1 Principios, 14.2 Atajos, 14.3 Responsive, 14.4 Accesibilidad, 14. POS y experiencia de usuario

### Community 37 - "16. CRM"
Cohesion: 0.40
Nodes (5): 16.1 Datos, 16.2 Métricas, 16.3 Segmentación, 16.4 Consentimiento, 16. CRM

### Community 38 - "22. Observabilidad"
Cohesion: 0.40
Nodes (5): 22.1 Logs, 22.2 Health checks, 22.3 Métricas, 22.4 Alertas, 22. Observabilidad

### Community 39 - "23. Docker y despliegue"
Cohesion: 0.40
Nodes (5): 23.1 Servicios, 23.2 Variables, 23.3 Nginx, 23.4 Backups, 23. Docker y despliegue

### Community 40 - "28. Contratos de dominio"
Cohesion: 0.40
Nodes (5): 28. Contratos de dominio, InventoryMovement, ProductVariant, Sale, SaleItem

### Community 41 - "31. Performance"
Cohesion: 0.40
Nodes (5): 31.1 Objetivo, 31.2 Database, 31.3 Frontend, 31.4 POS, 31. Performance

### Community 42 - "36. Checklist de lanzamiento MVP"
Cohesion: 0.40
Nodes (5): 36. Checklist de lanzamiento MVP, Backend, Calidad, Frontend, Infra

### Community 43 - "43. Runbook operativo inicial"
Cohesion: 0.40
Nodes (5): 43. Runbook operativo inicial, Backend caído, Disco lleno, PostgreSQL caído, Proveedor de facturación caído

### Community 44 - "18. Eventos de dominio y aplicaciones"
Cohesion: 0.50
Nodes (4): 18.1 Eventos, 18.2 Domain Event vs Integration Event, 18.3 Outbox futura, 18. Eventos de dominio y aplicaciones

### Community 45 - "20. Offline y sincronización futura"
Cohesion: 0.50
Nodes (4): 20.1 MVP, 20.2 Preparación, 20.3 Futuro, 20. Offline y sincronización futura

### Community 46 - "24. CI/CD"
Cohesion: 0.50
Nodes (4): 24.1 Pipeline, 24.2 Branching, 24.3 Migraciones, 24. CI/CD

### Community 47 - "27. Convenciones de código"
Cohesion: 0.50
Nodes (4): 27. Convenciones de código, Java, SQL, TypeScript

### Community 48 - "4. Contexto y arquitectura C4"
Cohesion: 0.50
Nodes (4): 4.1 Contexto, 4.2 Contenedores, 4.3 Decisión, 4. Contexto y arquitectura C4

### Community 50 - "Software Architecture Handbook 1.0"
Cohesion: 0.67
Nodes (3): Control del documento, Cómo usar este documento, Software Architecture Handbook 1.0

## Knowledge Gaps
- **5 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `1. Visión del producto` connect `1.2 Principios de producto` to `POS_SaaS_Software_Architecture_Handbook_1.0.md`?**
  _High betweenness centrality (0.031) - this node is a cross-community bridge._
- **Should `Design: Sprint 1 - Cash Session Resilience & Validation` be split into smaller, more focused modules?**
  _Cohesion score 0.09090909090909091 - nodes in this community are weakly interconnected._
- **Why does `7. Modelo de datos PostgreSQL` connect `7. Modelo de datos PostgreSQL` to `POS_SaaS_Software_Architecture_Handbook_1.0.md`?**
  _High betweenness centrality (0.028) - this node is a cross-community bridge._
- **Should `Scenarios` be split into smaller, more focused modules?**
  _Cohesion score 0.10526315789473684 - nodes in this community are weakly interconnected._
- **Why does `5. Arquitectura de dominios` connect `5.3 Agregados principales` to `POS_SaaS_Software_Architecture_Handbook_1.0.md`?**
  _High betweenness centrality (0.028) - this node is a cross-community bridge._
- **Should `Tasks: Sprint 1 - Cash Session Resilience & Validation` be split into smaller, more focused modules?**
  _Cohesion score 0.1111111111111111 - nodes in this community are weakly interconnected._
- **Should `Backlog: V2 - Camino a Producción` be split into smaller, more focused modules?**
  _Cohesion score 0.09523809523809523 - nodes in this community are weakly interconnected._