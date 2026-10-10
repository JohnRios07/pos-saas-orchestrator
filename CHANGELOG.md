# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
