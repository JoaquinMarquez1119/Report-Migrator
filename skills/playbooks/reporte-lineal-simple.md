---
name: playbook-reporte-lineal-simple
description: Playbook para reportes Cognos con un dataset principal, columnas fijas, parámetros que sólo filtran filas, sin drill-through ni matriz de comportamiento. Baseline del workspace. Encaja cuando el layout visible explica el reporte completo y no hay ramas funcionales.
---

# Playbook — Reporte lineal simple

**Capa 2.** Patrón baseline. Si un reporte no encaja claramente en otro playbook, casi siempre encaja acá.

## Cuándo aplica

Señales típicas en los inputs:

- Una sola query principal en `inputs/queries/` (más, a lo sumo, queries de prompts).
- Columnas fijas entre ejecuciones; los parámetros filtran filas pero no cambian estructura.
- Sin drill-through (o sólo un drill decorativo a un dashboard externo que no hay que migrar).
- Sin `union`, sin ramas funcionales, sin cambio de dataset por familia.
- El PDF/screenshots de referencia alcanzan para entender el reporte.
- Típicamente una tablix única. Puede tener totales/subtotales pero no secciones alternativas.

**Ejemplo en este repo:** `reports/tc-promedio-mensual/` — reporte standalone, dataset único, columnas fijas.

## Cuándo NO aplica

- Las columnas visibles cambian según producto/unidad/año → `matriz-comportamiento`.
- El reporte abre otro con drill-through que hay que migrar → `drill-through-base-detalle`.
- Hay varias queries que alimentan ramas distintas de la vista → `matriz-comportamiento`.

## Pasos

1. **Inventario funcional mínimo.**
   - Parámetros (visibles + ocultos) con defaults y labels exactos.
   - Dataset de cada prompt.
   - Dataset principal con columnas, tipos y orden.
   - Filtros, orden, agrupaciones, totales.
   - Reglas de visibilidad (si las hay — deberían ser pocas o ninguna).

2. **Mapeo Cognos → Report Builder.**
   - query Cognos → dataset RDL (uno).
   - prompt Cognos → report parameter.
   - data item → field del dataset.
   - list/crosstab simple → tablix.

3. **Construcción del RDL.**
   - datasource
   - datasets de parámetros
   - dataset principal
   - parámetros con defaults y layout
   - tablix con header/detail/footer
   - header/footer del reporte, logo si aplica
   - formato numérico, fecha y alineación exactos según PDF

4. **Validación.**
   - Abre y ejecuta.
   - Parámetros funcionan incluyendo defaults.
   - Valores coinciden contra al menos 2 escenarios (típicamente: default + un caso extremo).
   - Totales/subtotales coinciden.
   - Exporta a PDF igual al PDF de referencia.

## Errores comunes

- **Sobre-parametrizar:** agregar lógica condicional "por si acaso". Si Cognos no la tiene, no la agregues.
- **Re-formatear:** cambiar decimales, separadores o alineación por criterio propio. Respetar Cognos al pixel.
- **Olvidar el footer condicional** (fecha de ejecución, usuario, filtros aplicados) si Cognos lo muestra.
- **Validar un solo caso.**

## Entregable mínimo

- `.rdl` en `output/`.
- Evidencia de validación en `output/validation/` con al menos 2 escenarios comparados contra Cognos (screenshot Cognos + screenshot RDL + tabla de valores).
- Bitácora Capa 3 con inventario funcional y lista de escenarios validados.
