---
name: report-precios-unitarios-ex-planta-base
description: Bitácora Capa 3 del reporte "Precios Unitarios Ex Planta (base)". Contiene playbook elegido, iteraciones, decisiones, evidencia y retrospectiva. Acoplada a este reporte — no reusable.
---

# Precios Unitarios Ex Planta (base) — Bitácora de migración

> **Capa 3.** Vive con el reporte. No es reusable. Registra todo lo que pasó y por qué.
> Reglas y pasos genéricos viven en `skills/base/SKILL.md`. Patrones específicos en los playbooks listados abajo.

## Metadata rápida

- **Slug:** precios-unitarios-ex-planta-base
- **Creado:** pre-2026-04-17 (implementación original previa a la arquitectura de 3 capas)
- **Capa 3 iniciada:** 2026-04-17 (retroactiva, mínima)
- **Estado actual:** in-progress (reabierto para ajustes visuales + diferencias contra Cognos)
- **Playbook(s) adoptado(s):** `matriz-comportamiento`, `drill-through-base-detalle`
- **Output:** `Precios_unitarios_ex_planta_base.rdl` (en raíz del reporte — layout heredado)
- **Layout:** heredado (`.rdl` en raíz + `inputs/`). No se migra a `output/` en esta ronda (decisión del usuario).

## Histórico (pre-Capa 3)

Este reporte se implementó antes de la arquitectura de 3 capas. Su trabajo previo vive íntegro en `_archive/old-skills/`:

- **Plan de layout original:** [_archive/old-skills/agent/plans/2026-03-26-precios-unitarios-ex-planta-base-layout-plan.md](../../_archive/old-skills/agent/plans/2026-03-26-precios-unitarios-ex-planta-base-layout-plan.md)
- **Spec de diseño del layout:** [_archive/old-skills/agent/specs/2026-03-26-precios-unitarios-ex-planta-base-layout-design.md](../../_archive/old-skills/agent/specs/2026-03-26-precios-unitarios-ex-planta-base-layout-design.md)
- **Proceso/workspace genérico aplicado:** [_archive/old-skills/process/workspace-organization.md](../../_archive/old-skills/process/workspace-organization.md)

Relación con el reporte hijo: este es el **padre** del drill-through hacia `reports/precios-unitarios-ex-planta-detalle/` (ver playbook `drill-through-base-detalle`).

El inventario funcional, matriz de comportamiento y decisiones de implementación originales no se reconstruyen acá. Si algún ajuste los necesita, se copian/extractan puntualmente al resolverse.

## Playbook elegido

- **Playbook primario:** `skills/playbooks/matriz-comportamiento.md`
  - **Por qué encaja:** el reporte tiene varias queries en `inputs/queries/`, columnas/conceptos que cambian por familia de producto, y reglas por año. Señales claras del patrón.
- **Playbook combinado:** `skills/playbooks/drill-through-base-detalle.md`
  - **Por qué encaja:** es el padre de una familia base+detalle; el hijo es `reports/precios-unitarios-ex-planta-detalle/`.
- **Deltas / ajustes:** ninguno identificado a priori. Se anotan acá si aparecen durante los ajustes.
- **Confirmado por el usuario:** 2026-04-17.

## Inventario inicial de inputs

Estado actual de `inputs/` (carpetas que existen en el reporte):

- [x] XML Spec (`inputs/xml-spec/xml-spec-cognos.xml`)
- [x] Queries (`inputs/queries/`)
- [x] PDF de referencia (`inputs/pdf/precios-unitarios-ex-planta.pdf`)
- [x] Screenshots (`inputs/screenshots/` — incluye `report-reference/` y `report-builder-validation/`)
- [x] Mappings (`inputs/mappings/cognos-to-powerbi-report-builder.md`)
- [x] Assets (`inputs/assets/Ancap_logo_horizontal.jpg`)
- [x] Notas funcionales (`inputs/notes/`)
- [x] `.rdl` previo: `Precios_unitarios_ex_planta_base.rdl` (raíz del reporte — la ronda anterior ya lo dejó en estado "done")

## Inventario funcional

_En blanco — se reconstruye puntualmente si algún ajuste lo requiere. Ver "Histórico" para referencias al inventario implícito en los archivos archivados._

## Iteraciones

> Una entrada por iteración desde el 2026-04-17 en adelante. El pasado está en `_archive/`.

### 2026-04-17 — Ajustes solicitados por el usuario (A1–A5)

Ingreso de 5 ajustes combinados (visuales + 1 comportamiento condicional). Se atacan en 3 bloques por costo de validación:

| ID | Ajuste | Tipo | Bloque |
|---|---|---|---|
| A1 | Matriz debe quedar centrada respecto al encabezado (hoy descentrada a la izquierda) | Layout | 1 |
| A2 | Primera celda de la matriz (unidad seleccionada): sin borde superior ni izquierdo, sí derecho e inferior | Layout | 1 |
| A3 | Con filtro "$/lt ó $/kg según corresponda": invertir orden de las 2 primeras columnas — primero producto, después unidad | Comportamiento condicional | 3 |
| A4 | Encabezado más fino de altura + menos espacio entre el año del filtro y el título del reporte | Layout | 1 |
| A5 | Panel "Qué muestra este reporte": arrancar colapsado y expandir al click (hoy arranca expandido) | Interacción (toggle) | 2 |

**Plan de ataque:**
- Bloque 1 (A1+A2+A4): cambios de layout. Validación única contra screenshot/Cognos.
- Bloque 2 (A5): cambio de propiedad `InitialToggleState`. Validación propia.
- Bloque 3 (A3): cambio de orden condicional de columnas por parámetro. Iteración propia con validación separada contra Cognos en ambos estados del filtro.

**Confirmado por el usuario:** 2026-04-17 (orden agrupado).

### 2026-04-17 — Bloque 1 aplicado (A2 + A4); A1 diferido

**A2 — Bordes de la celda esquina de la matriz (unidad seleccionada).**
- Archivo: `Precios_unitarios_ex_planta_base.rdl`, celda `hdrUsdCorner` (~línea 707).
- Cambio: bordes uniformes `Gray Solid` → `TopBorder`/`LeftBorder` = `None`, `RightBorder`/`BottomBorder` = `Gray Solid`.
- Efecto: primera celda queda sin borde superior ni izquierdo, con borde derecho e inferior.

**A4 — Encabezado más fino.**
- `PageHeader.Height` 0.62in → 0.50in.
- `rectHeader.Height` 0.6in → 0.48in.
- `txtTitulo`: `Top` 0.03 → 0.02, `Height` 0.25 → 0.23 (menos espacio entre el año del filtro y el título).
- `txtHeaderAnio`: `Top` 0.28 → 0.25, `Height` 0.18 → 0.17.
- `imgLogo`: `Top` 0.05 → 0.04, `Height` 0.42 → 0.40 (reescalado proporcional).

**A1 — Centrado de la matriz: diferido.**
- Análisis matemático: `tablixUSD` tiene `Left=6.24in` + `Width=8.03in` en body de `Width=20.5in`. Centro del tablix = 10.255in. Centro del título (Width 19.9, Left 0.3) = 10.25in → ya coinciden.
- La "descentralización" percibida puede ser artefacto de proporciones viejas del header (logo 0.42 de alto contra título pequeño). Se re-evalúa después de renderizar con el nuevo header (A4).
- Si sigue descentrado tras validar visualmente, se ajusta en una iteración propia con evidencia.

### 2026-04-17 — Bloque 2 aplicado (A5)

**A5 — Panel "Qué muestra este reporte" arranca colapsado.**
- Archivo: `Precios_unitarios_ex_planta_base.rdl`, `txtDescripcion` (~línea 473).
- Cambio: `<Hidden>false</Hidden>` → `<Hidden>true</Hidden>` dentro del `<Visibility>` con `ToggleItem` apuntando al texto del panel.
- Efecto: al abrir el reporte, el panel arranca colapsado. Click en el toggle lo expande.
- **Nota pendiente de validación:** con `Top` absoluto, colapsar puede dejar espacio vacío arriba de la matriz. Si molesta visualmente, se vuelve en una iteración propia moviendo el toggle a un contenedor que colapse el alto.

### 2026-04-17 — Bloque 3 aplicado (A3)

**A3 — Invertir orden de las dos primeras columnas cuando el filtro es "$/lt ó $/kg".**
- Archivo: `Precios_unitarios_ex_planta_base.rdl`, `tablixUYU` (matriz del lado UYU, que es la que aplica para "$/lt ó $/kg según corresponda").
- Cambios combinados (hay que swappear **ancho** Y **contenido**, sino se rompe la relación ancho↔contenido):
  - `TablixColumn[0]` width 0.62in → 1.45in.
  - `TablixColumn[1]` width 1.45in → 0.62in.
  - Celda detalle `TablixCell[0]` y `TablixCell[1]`: contenidos swappeados (`txtUyuUnidad` y `txtUyuProducto`).
  - Celdas header `hdrUyu0`/`hdrUyu1`: ambas vacías → no requirió swap.
- Resultado: **primero producto (ancho), después unidad (angosta)** en el render UYU.

**Contratos que permanecen:**
- Drill-through sigue pasando los mismos parámetros al detalle; el orden visible de columnas del padre no afecta el contrato.
- La rama USD (`tablixUSD`) no se tocó: es la que NO aplica al filtro "$/lt ó $/kg" y mantiene su layout original.

**Open question A3 (screenshot Cognos):** sigue abierta. Validación contra Cognos se hace al abordar el próximo paso de validación del bloque.

## Validación

_Evidencia comparable contra Cognos para los ajustes de esta ronda. Llenar en el Paso 4._

| # | Escenario | Parámetros | Esperado (Cognos) | Obtenido (RDL) | OK? | Evidencia |
|---|---|---|---|---|---|---|
| 1 |   |   |   |   |   |   |

## Reglas especiales / cutovers

_En blanco — se agregan si aparecen en los ajustes._

## Open questions

_También reflejar en `report.yaml:open_questions` si bloquean el próximo paso._

- **A3 — screenshot del estado esperado con filtro "$/lt ó $/kg":** usuario no lo tiene a mano. Se va a deducir del XML Spec + queries Cognos al abordar el Bloque 3.

## Retrospectiva

_Llenar sólo cuando `report.yaml:status` pase a `done` y el usuario acepte hacer la retro._
