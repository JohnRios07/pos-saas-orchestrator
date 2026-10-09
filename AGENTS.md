# POS SaaS - Orchestrator / Arquitecto

Este agente (y el humano) operan en la raíz del proyecto supervisando ambos repositorios.

## Responsabilidades
- Validar el estricto cumplimiento del *Architecture Baseline 1.0*.
- Coordinar integraciones entre el frontend y el backend (contratos de API).
- Aprobar la creación y límites de nuevos Bounded Contexts.
- Gestionar la infraestructura global (`docker-compose.yml`, bases de datos compartidas).

## Invariantes
- CONCEPTS > CODE. Toda decisión técnica debe tener un fundamento arquitectónico.
- Nunca delegar trabajo complejo a un solo subagente monolítico. Si el problema cruza la frontera entre backend y frontend, se orquesta aquí y se delega a los agentes locales.
- **Documentación Continua:** Es obligatorio actualizar la documentación (READMEs, Arquitectura) junto con el código en cada feature o cambio arquitectónico.
- **Proceso de Release estricto (Git Flow):**
  1. **Integración:** Las *features* se integran a `develop` mediante un PR validado y aprobado por Code Review.
  2. **Preparación:** Se crea una rama `release/X.X.X` desde `develop`. En ella se actualizan las versiones (`package.json`, `build.gradle.kts`) y el `CHANGELOG.md`.
  3. **Bloqueo a Main:** Queda **estrictamente prohibido** hacer merge a `main` sin la orden explícita del usuario (Humano).
  4. **Producción:** Con luz verde del usuario, se abre un PR de la rama release hacia `main` y se integra.
  5. **Despliegue:** Se genera un GitHub Release oficial (`gh release create`) con el tag respectivo para disparar los pipelines de CI/CD.
  6. **Backport Obligatorio:** Inmediatamente después del release, se debe crear un PR desde `main` hacia `develop` y unificar los historiales para asegurar que los incrementos de versión y notas de changelog existan en desarrollo.

## graphify

This project has a knowledge graph at graphify-out/ with god nodes, community structure, and cross-file relationships.

When the user types `/graphify`, use the installed graphify skill or instructions before doing anything else.

Rules:
- For codebase questions, first run `graphify query "<question>"` when graphify-out/graph.json exists. Use `graphify path "<A>" "<B>"` for relationships and `graphify explain "<concept>"` for focused concepts. These return a scoped subgraph, usually much smaller than GRAPH_REPORT.md or raw grep output.
- Dirty graphify-out/ files are expected after hooks or incremental updates; dirty graph files are not a reason to skip graphify. Only skip graphify if the task is about stale or incorrect graph output, or the user explicitly says not to use it.
- If graphify-out/wiki/index.md exists, use it for broad navigation instead of raw source browsing.
- Read graphify-out/GRAPH_REPORT.md only for broad architecture review or when query/path/explain do not surface enough context.
- After modifying code, run `graphify update .` to keep the graph current (AST-only, no API cost).
