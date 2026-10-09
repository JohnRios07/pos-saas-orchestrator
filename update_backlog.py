import sys
with open('BACKLOG.md', 'r') as f:
    content = f.read()

# Remove the Sprint 4-6 section entirely
sprint_4_6_text = """## 💳 SPRINT 4-6 - Core Features Notas de Crédito (P1) | ~3-4 semanas
*Flujo completo de emisión y redención*

- [ ] **Flujo de Emisión desde Historial** (#60-64): Al tramitar una devolución (total o parcial) de una venta:
  - **Devolución parcial**: Permitir seleccionar una o varias líneas de la venta (items) sin obligar a devolver la compra completa. UI en `SalesHistory.tsx` → modal con checklist de líneas de la venta, cantidades editables (máx. lo vendido).
  - Reingreso de las prendas seleccionadas al inventario (+1 en Kardex por cada item).
  - Emisión de la Nota de Crédito por el importe correspondiente (suma de líneas devueltas × precio unitario - descuentos proporcionales).
  - **Generación e impresión de comprobante en tirilla térmica de 80 mm** (formato similar a la tirilla de venta, adaptado para Nota de Crédito): encabezado del negocio, consecutivo NC (`NC-00000001`), fecha, cajero, detalle de prendas devueltas con SKU y `Talla | Color`, importe total de la NC, saldo disponible, vigencia, y cierre con datos del negocio. Reutilizar `PdfReceiptGenerator` adaptando plantilla para NC.
- [ ] **Flujo de Redención en el POS (Nueva Venta)** (#65-69):
  - En la pasarela de pago del POS (`Sales.tsx`), habilitar método de redención: "Nota de Crédito".
  - Búsqueda y validación del código/consecutivo de la NC con descuento automático sobre el total.
  - Si la nueva prenda es de mayor valor, el saldo restante se cobra mediante Efectivo o Transferencia (ingresando únicamente este excedente a la caja activa).
  - Si la nueva prenda es de menor valor, se descuenta lo consumido y la NC conserva el saldo a favor para futuras compras.
- [ ] **Notas de Crédito y Cambios (Integración Completa)** (#17): Política comercial: No se entrega efectivo al cliente. Al recibir una devolución o cambio, no se genera egreso de caja física (`OUT`), sino una Nota de Crédito / Bono con código único o asignado al cliente. Esta Nota de Crédito se puede canjear como forma de pago en una nueva venta en el POS (cobrando el excedente si la nueva prenda es de mayor valor).

---

"""

content = content.replace(sprint_4_6_text, "")

# Add the new section above "## ✅ COMPLETADOS (v1.0.0 - MVP)"
new_completed_section = """## ✅ COMPLETADOS (v1.2.0 - Sprint 2)

### Notas de Crédito y Mejoras UX
- [x] **Flujo de Emisión desde Historial** (#60-64): Devoluciones parciales/totales implementadas, selección de items en modal, reingreso a inventario y emisión de comprobante PDF en formato 80mm con consecutivo.
- [x] **Flujo de Redención en el POS (Nueva Venta)** (#65-69): Método de pago "Nota de Crédito" integrado en el checkout, búsqueda y validación de saldos, deducciones automáticas y pagos mixtos (excedentes).
- [x] **Notas de Crédito y Cambios (Integración Completa)** (#17): Sin egreso de caja física (`OUT`); las devoluciones emiten Notas de Crédito, cerrando el ciclo comercial.
- [x] **Refinamiento Modal de Pagos (UX):** Formato de moneda para efectivo y transferencias (usando `Intl.NumberFormat`), cálculo dinámico de cambio a devolver, y validación estricta de límites (la transferencia no puede superar el total, y el efectivo solo envía a backend el monto aplicado).

"""

content = content.replace("## ✅ COMPLETADOS (v1.0.0 - MVP)", new_completed_section + "## ✅ COMPLETADOS (v1.0.0 - MVP)")

with open('BACKLOG.md', 'w') as f:
    f.write(content)

