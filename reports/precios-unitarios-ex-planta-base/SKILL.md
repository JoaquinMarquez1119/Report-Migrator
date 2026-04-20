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
- **Estado actual:** review (ajustes A1–A5 resueltos, validados en Service)
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

### 2026-04-18 — Validación visual en Service: feedback del usuario

**Contexto nuevo (importante para todas las iteraciones):**
- La validación final es en el **servicio de Power BI** (no en Report Builder).
- Report Builder y el Service renderizan distinto — lo que luce bien en Report Builder puede fallar publicado. **La fuente de verdad es el Service.**
- Esto aplica a todos los reportes del proyecto → candidato a promover a `skills/base/SKILL.md` en la retro.

**Resultado por ajuste:**

| ID | Estado | Evidencia Service | Qué falló |
|---|---|---|---|
| A1 | ❌ Sigue descentrado | screenshot 5 (USD mode, matriz desplazada a la derecha) | Análisis matemático previo era inválido: en el Service el body width o el render real del tablix no coincide con lo calculado. |
| A2 | ❌ En modo $/lt ó $/kg | screenshot 1 | La esquina de `tablixUYU` todavía tiene bordes y **no muestra label** ("$/lt ó $/kg según corresponda"). El fix anterior se aplicó sólo a `hdrUsdCorner` (rama USD). |
| A3 | ✅ OK | — | Orden producto → unidad correcto en modo $/lt ó $/kg. |
| A4 | ⚠️ Parcial | screenshot 2 | El header quedó más fino pero ahora **demasiado pegado** (título muy cerca del año o del borde). Hay que aflojar, no tanto como antes. |
| A5 | ❌ Arranca colapsado pero feo | screenshots 3 y 4 | Panel colapsado deja un hueco grande arriba de la matriz. El `txtDescripcion` tenía `Top` absoluto → al ocultarse, el contenedor no recupera el alto y la matriz queda empujada abajo. |

**Plan de ataque para iteración 2026-04-18:**
- **A1:** revisar cómo calcula centrado el Service. Probablemente hay que usar `Left` dinámico o un contenedor con alineación, no posición absoluta.
- **A2:** aplicar mismo cambio de bordes al corner de `tablixUYU` + agregar label "$/lt ó $/kg según corresponda" en esa celda.
- **A4:** aflojar Top/Height del título un poco (no tanto como el original de 0.62, pero más que 0.50).
- **A5:** opciones — (a) mover `txtDescripcion` a un contenedor que colapse alto cuando se oculta, o (b) bajar el `Top` de todo lo que está debajo para que no quede el hueco. Evaluar después de leer el RDL.

### 2026-04-18 — Correcciones aplicadas (iteración 2): A2-fix, A4-fix, A5-fix; A1 diferido

**A2-fix — corner UYU con label y bordes.**
- `hdrUyu0` (col 0, 1.45in — producto): agregar texto `$/lt ó $/kg` (FontSize 8pt, TextAlign Center). Bordes: TopBorder None, LeftBorder None, RightBorder None, BottomBorder Gray Solid, BackgroundColor White.
- `hdrUyu1` (col 1, 0.62in — unidad): vacío. Bordes: TopBorder None, LeftBorder None, RightBorder Gray Solid, BottomBorder Gray Solid, BackgroundColor White.
- Equivalente al tratamiento de `hdrUsdCorner` en la rama USD.

**A4-fix — aflojar header tras quedar muy pegado.**
- `PageHeader.Height` 0.50 → 0.55in.
- `rectHeader.Height` 0.48 → 0.53in.
- `txtTitulo`: Top 0.02 → 0.05, Height 0.23 → 0.25.
- `txtHeaderAnio`: Top 0.25 → 0.32, Height 0.17 → 0.18.
- `imgLogo`: Top 0.04 → 0.06, Height 0.40 → 0.42.

**A5-fix — eliminar gap vertical en estado colapsado (reestructura).**
- `txtDescripcion`: Height 1.29444 → 0.1in. `CanGrow=true` ya está activo, lo que hace que al expandirse vía toggle el textbox crezca a su contenido natural y empuje a los siblings debajo (comportamiento documentado de SSRS/RDL: peer items debajo se pushean cuando un textbox con CanGrow crece).
- Shift de -1.19in a todos los siblings debajo del textbox (para cerrar el gap en estado colapsado):
  - `rectUnidad`: Top 1.69 → 0.5in.
  - textbox nota 1: Top 2.43944 → 1.24944in.
  - textbox nota 2: Top 2.62944 → 1.43944in.
  - textbox nota 3: Top 2.81944 → 1.62944in.
  - `tablixUSD`: Top 3.16667 → 1.97667in (Left/Width sin cambios).
  - `tablixUYU`: Top 3.16667 → 1.97667in (Left/Width sin cambios).
  - `txtReferente`: Top 3.855 → 2.665in.
- BodyCanvas Height: 4.625 → 3.435in. Body Height: 4.675 → 3.485in.
- **Riesgo/validación crítica:** verificar en Service que al expandir el panel los siblings efectivamente se pusheen hacia abajo. Si NO pushean (comportamiento del renderer del Service distinto al de Report Builder), el contenido expandido se superpondrá con rectUnidad. Plan B si falla: volver al estado arranca-expandido y documentar como limitación.

**A1 — sigue diferido. Nueva hipótesis documentada:**
- El tablix está math-centrado: `tablixUSD` Left 6.24, Width 8.03 → center 10.255; body Width 20.5 → center 10.25. Matemáticamente alineado con el título.
- **Hipótesis nueva:** la matriz usa `TablixMember.Visibility.Hidden` por mes para ocultar columnas sin data. Con 4 meses visibles (estado actual: Ene-Abr 2026), el ancho renderizado efectivo del tablix es ~3.71in en vez de 8.03in → su centro visual se corre a la izquierda, dando la percepción de "descentrado a la izquierda".
- **Cómo validar la hipótesis:** screenshot de Cognos con los mismos 4 meses; si Cognos lo muestra centrado (ajustando Left dinámicamente), hay que replicar el ajuste. Si Cognos también lo muestra off-center, es comportamiento esperado y se cierra.
- Se deja como open question hasta tener el screenshot de Cognos.

### 2026-04-18 — A5: diagnóstico definitivo + revert de shift; A1: hipótesis confirmada

**A5 — diagnóstico definitivo del Service:**
- En el Power BI Service, los items con `Top` absoluto **no se desplazan** cuando un item superior crece o se oculta. La visibilidad toggle muestra/oculta el contenido pero el espacio que ocupa el item en el layout se preserva siempre.
- El "shift -1.19in" de la iteración anterior no funcionó: en estado expandido los siblings shifted se superponían con la descripción (screenshots 2,3). En estado colapsado, la matriz quedaba desplazada a una posición inesperada (screenshot 1).
- **Acción:** revert completo a posiciones originales. `txtDescripcion` queda con `Height=1.29444in` y `Hidden=true`. Toggle funciona, pero el espacio de 1.29in queda vacío cuando colapsado.
- **Limitación documentada:** en SSRS/Service con layout absoluto, el espacio de un item oculto no colapsa. Es un límite del renderer, no de la implementación.
- **Opciones disponibles para el usuario** (decisión pendiente):
  - **A (actual):** arranca colapsado + toggle funciona + gap de 1.29in visible cuando colapsado.
  - **B:** mover `txtDescripcion` al fondo del body (Top ~4.1in, después de Referentes). Toggle en el top sigue funcionando. Cuando expandido, la descripción aparece al pie. Sin gap en el cuerpo del reporte. Requiere nueva iteración.
  - **C:** revertir A5 completamente — descripción siempre visible (sin toggle).

**A1 — hipótesis confirmada por screenshot del usuario:**
- Con 4 meses visibles (Ene-Abr), el ancho efectivo del tablix ≈ 1.55 + 4×0.54 = 3.71in.
- Centro efectivo = 6.24 + 3.71/2 = 8.095in vs. centro del body = 10.25in → off-center ~2.15in a la izquierda.
- Screenshot 4 del usuario muestra la matriz desplazada hacia la derecha del panel (confirmado visualmente).
- **Pendiente:** screenshot de Cognos con los mismos 4 meses para determinar si Cognos centra dinámico o también lo muestra off-center. Si Cognos centra → necesitamos solución (probable: mostrar las 12 columnas siempre, con "-" o vacío para meses sin data, para mantener ancho fijo). Si Cognos también muestra off-center → cerrar como comportamiento esperado.

### 2026-04-19 — A5 Opción F: reestructuración en dos rectángulos hermanos; A1 cerrado como limitación

**A1 — CERRADO como comportamiento esperado.**
- Screenshot de Cognos (2026-04-19) confirma que Cognos también muestra la matriz off-center con 4 meses visibles.
- La percepción de "descentrado" es fidelidad con Cognos. No hay fix necesario.
- Limitación documentada: `TablixMember.Visibility.Hidden` colapsa el ancho efectivo; el Left=6.24in queda subóptimo con <12 meses. Comportamiento idéntico en Cognos y en el Service.

**A5 — Opción F: reemplazar BodyCanvas por dos rectángulos hermanos en Body.**
- Diagnóstico de la iteración anterior: el Service no hace push-down dentro de un Rectangle con layout absoluto. El bug (layout desconfigurado al expandir desde `Hidden=true`) se produce porque los siblings tienen `Top` fijo y el renderer no los recalcula.
- **Solución:** reemplazar el único `<Rectangle Name="BodyCanvas">` por dos `<Rectangle>` hermanos directamente en el `<Body>`. En el Body, los siblings SÍ reciben push-down cuando el item anterior tiene `CanGrow=true`.
  - `rectDescription` (Top=0, Height=0.43in, CanGrow=true): contiene `txtToggleDescripcion` + `txtDescripcion` (Hidden=true). Cuando la descripción se expande, crece este rectángulo y empuja `rectContent` hacia abajo.
  - `rectContent` (Top=0.43in, Height=2.4in): contiene `rectUnidad`, `txtNota1/2/3`, `tablixUSD`, `tablixUYU`, `txtReferente`. Todos sus `Top` ajustados restando 1.69in (origen del rectUnidad previo).
- Body Height ajustado: 4.675 → 2.83in (collapsed state).
- **Riesgo/validación crítica:** verificar en Service que al expandir el panel, `rectContent` se desplaza hacia abajo. Si el renderer del Service no soporta push-down entre rectángulos hermanos en Body (poco probable — es comportamiento documentado de SSRS), reportar y evaluar Plan C (descripción always visible).

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
