import sys

with open('BACKLOG.md', 'r') as f:
    content = f.read()

s23 = """## 🏗️ SPRINT 2-3 - Foundation Notas de Crédito (P1) | ~2-3 semanas
*Base de datos, API y políticas para habilitar el flujo completo*

- [x] **Entidad y Secuencia de Notas de Crédito** (#59): Creación de tabla `credit_notes` con consecutivo seguro (`NC-00000001`), valor original, saldo disponible (`remaining_amount`), estado (`ACTIVE`, `PARTIALLY_USED`, `EXHAUSTED`, `EXPIRED`), vigencia configurable (ej. 30/90 días), `tenant_id`, y cliente asociado o al portador.
- [x] **Invariante Financiero (Cero Egreso de Caja)** (#58): Política de negocio estricta: en cambios o devoluciones no se entrega dinero en efectivo. Se elimina el registro de egreso (`OUT`) en la sesión de caja al procesar devoluciones. La caja física del turno permanece intacta e independiente de cuándo se realizó la venta original.
- [x] **Bloqueo de Ventas sin Caja Abierta** (#25): Analizar e implementar la estrategia: (a) desactivar completamente el POS (`Sales.tsx`) si no hay sesión de caja activa, o (b) permitir armar el carrito pero bloquear el checkout con alerta clara. El backend debe validar en `POST /api/sales` y `POST /api/sales/{id}/refund` que exista `CashSession` activa para el `registerId` del usuario.

---

"""

content = content.replace(s23, "")

new_comp = """- [x] **Entidad y Secuencia de Notas de Crédito** (#59): Tabla `credit_notes` con consecutivo y estados.
- [x] **Invariante Financiero (Cero Egreso de Caja)** (#58): Eliminado egreso físico de caja.
- [x] **Bloqueo de Ventas sin Caja Abierta** (#25): Validación en frontend (checkout bloqueado) y backend.
"""

content = content.replace("### Notas de Crédito y Mejoras UX", "### Notas de Crédito y Mejoras UX\n" + new_comp)

with open('BACKLOG.md', 'w') as f:
    f.write(content)
