---
name: report-precios-unitarios-ex-planta-detalle
description: Bitácora Capa 3 del reporte "Precios Unitarios Ex Planta - detalle". Contiene playbook elegido, iteraciones, decisiones, evidencia y retrospectiva. Acoplada a este reporte — no reusable.
---

# Precios Unitarios Ex Planta - detalle — Bitácora de migración

> **Capa 3.** Vive con el reporte. No es reusable. Registra todo lo que pasó y por qué.
> Reglas y pasos genéricos viven en `skills/base/SKILL.md`. Patrones específicos en los playbooks listados abajo.

## Metadata rápida

- **Slug:** precios-unitarios-ex-planta-detalle
- **Creado:** pre-2026-04-22 (implementación original previa a la arquitectura de 3 capas)
- **Capa 3 iniciada:** 2026-04-22 (retroactiva)
- **Estado actual:** in-progress
- **Playbook(s) adoptado(s):** `matriz-comportamiento`, `drill-through-base-detalle`
- **Output:** `Precios Unitarios Ex Planta - detalle.rdl` (en raíz del reporte — layout heredado)
- **Layout:** heredado (`.rdl` en raíz + `inputs/`). No se migra a `output/` en esta ronda.

## Histórico (pre-Capa 3)

Este reporte se implementó antes de la arquitectura de 3 capas. Su trabajo previo vive íntegro en `_archive/old-skills/`:

- **Plan original:** [_archive/old-skills/agent/plans/2026-03-23-precios-unitarios-ex-planta-detalle.md](../../_archive/old-skills/agent/plans/2026-03-23-precios-unitarios-ex-planta-detalle.md)
- **Spec de diseño de la matriz de comportamiento:** [_archive/old-skills/agent/specs/2026-03-26-precios-unitarios-ex-planta-detalle-matrix-design.md](../../_archive/old-skills/agent/specs/2026-03-26-precios-unitarios-ex-planta-detalle-matrix-design.md)
- **Plan de la matriz de comportamiento:** [_archive/old-skills/agent/plans/2026-03-26-precios-unitarios-ex-planta-detalle-matrix-plan.md](../../_archive/old-skills/agent/plans/2026-03-26-precios-unitarios-ex-planta-detalle-matrix-plan.md)
- **Proceso/workspace aplicado:** [_archive/old-skills/process/2026-03-22-precios-unitarios-ex-planta-detalle.md](../../_archive/old-skills/process/2026-03-22-precios-unitarios-ex-planta-detalle.md)

Relación con el reporte padre: este es el **hijo** del drill-through desde `reports/precios-unitarios-ex-planta-base/`. También es ejecutable de forma standalone con los mismos parámetros.

El mapping completo de campos Cognos → Power BI vive en `inputs/mappings/detalle-cognos-to-powerbi-report-builder.md`. La matriz de comportamiento inferida (familias, columnas permitidas por familia) vive en `inputs/mappings/detalle-cognos-behavior-matrix.md` — **nota:** esta matriz fue inferida antes de leer el XML spec a fondo; la fuente de verdad real son las queries y el XML spec, no este archivo.

## Playbook elegido

- **Playbook primario:** `skills/playbooks/matriz-comportamiento.md`
  - **Por qué encaja:** el reporte tiene 8 queries en `inputs/queries/`, columnas que cambian por familia de producto (9 familias distintas), reglas por año (3 cutovers históricos: 202106, 202107, 202306), y dos pestañas con columnas diferentes (Resumen / Detalle).
- **Playbook combinado:** `skills/playbooks/drill-through-base-detalle.md`
  - **Por qué encaja:** es el hijo de una familia base+detalle; el padre es `reports/precios-unitarios-ex-planta-base/`.
- **Deltas / ajustes:**
  - La variable `MostrarPestañaDetalle` del XML spec oculta la pestaña Detalle para 8 productos (Supergas, Propano Industrial, Propano Redes, Supergas A Granel, Asfalto RC2, Asfalto MC1, Asfalto AC-30, Asfalto 150/200). Este comportamiento no está implementado todavía en el RDL.
  - Los datasets usan formato **wide** (una fila por Fecha/Producto, ~60 columnas), mientras que Cognos usa formato **long** (una fila por Concepto2). La visibilidad de columnas se maneja con `IsColumnAllowed()` en VB.NET + `Count > 0` por datos presentes.
- **Confirmado por el usuario:** 2026-04-22.

## Inventario inicial de inputs

- [x] XML Spec (`inputs/xml-spec/xml-spec-cognos.xml`)
- [x] Queries (`inputs/queries/` — 8 archivos: Consulta3$.sql, Consulta3USD.sql, Ex Planta Nuevo FORMATO.sql, Ex Planta Planilla Detalle.sql, Densidades.sql, Texto.sql, Producto.sql, pAño.sql)
- [x] PDF de referencia (`inputs/pdf/precios-unitarios-ex-planta-detalle.pdf`)
- [x] Screenshots (`inputs/screenshots/report-reference/` — 4 capturas de 2 productos representativos)
- [x] Mappings (`inputs/mappings/detalle-cognos-to-powerbi-report-builder.md`, `inputs/mappings/detalle-cognos-behavior-matrix.md`)
- [x] Assets (`inputs/assets/detalle-ancap_logo_horizontal.jpg`)
- [x] Notas funcionales (`inputs/notes/`)
- [x] Docs (`docs/drillthrough.md`, `docs/migration-notes.md`)
- [x] `.rdl` previo: `Precios Unitarios Ex Planta - detalle.rdl` (raíz del reporte)

## Inventario funcional

### Parámetros

| Parámetro | Tipo | Origen | Notas |
|---|---|---|---|
| `pAnio` | entero | dataset `dsAnio` ← `pAño.sql` | excluye `Año Base` |
| `pProducto` | string | dataset `dsProducto` ← `Producto.sql` | agrupamiento GLP→Supergas, Propano→Propano Industrial |
| `pUnidad` | string | opciones fijas | `USD/m3` o `$/lt ó $/kg según corresponda` |
| `pVista` | string oculto | default `Resumen` | controla pestaña activa; no viene de Cognos |

### Datasets principales

| Dataset | Uso | Filtros aplicados |
|---|---|---|
| `dsResumen` | Pestaña Resumen (tablixSummaryUSD, tablixSummaryLocalMain, tablixSummaryLocal) | pAnio + NormalizeProduct(pProducto) |
| `dsDetalle` | Pestaña Detalle (tablixDetailUSD / tablixDetailLocal) | pAnio + NormalizeProduct(pProducto) |
| `dsResumenLocal` | TM1 histórico local (tablixSummaryLocal) | pAnio + NormalizeProduct(pProducto) |
| `dsAnio` | Prompt año | — |
| `dsProducto` | Prompt producto | — |
| `dsTexto` | Nota URSEA footer | pProducto |

### Lógica de visibilidad de columnas

Dos mecanismos combinados por columna en el tablix:
1. `Not Code.IsColumnAllowed(viewKey, producto, año, unidad, columnKey)` — whitelist por familia
2. `Count(IIF(valor <> 0, 1, Nothing), "dsXxx") = 0` — ocultar si no hay datos

La función `GetProductFamily()` en VB.NET mapea producto normalizado → familia. `IsColumnAllowed()` recibe `viewKey` (SummaryUsd / SummaryLocalMain / SummaryLocalTm1 / Detail) y devuelve si esa columna está permitida para esa familia/vista.

### Familias y cutovers históricos

- **202106:** productos fuera de la lista especial (asfaltos, GLP, querosenos) dejan de tener datos en la rama TM1
- **202107:** querosenos dejan de tener datos en la rama TM1
- **202306:** Supergas, Supergas A Granel, Propano Industrial, Propano Redes dejan de tener datos en la rama TM1

## Iteraciones

> Una entrada por iteración desde 2026-04-22 en adelante. El pasado pre-Capa 3 está en `_archive/`.

### 2026-04-22 — Iteración 1: Diagnóstico del problema de columnas faltantes/sobrantes

- **Pregunta/problema:** Para Gasolina Super 95 / 2026 / USD/m3, Cognos muestra 9 columnas en Resumen y 21 en Detalle. Power BI mostraba 3 en Resumen y solo las columnas básicas en Detalle. El problema se reproduce para otros productos también.
- **Decisión:** Leer el XML spec como fuente de verdad antes de tocar código. El archivo `detalle-cognos-behavior-matrix.md` fue inferido incorrectamente en una sesión anterior — no debe usarse como referencia primaria.
- **Acción:** Lectura exhaustiva de `inputs/xml-spec/xml-spec-cognos.xml`, específicamente las secciones de filtros por familia (líneas 535–596 para Resumen, 658–688 para Detalle). Hallazgos clave:
  - Gasolina Super 95, Gasolina Premium 97, Gasoil 50-S, Gasoil 10-S tienen `then(1)` en el filtro maestro — **sin restricción de conceptos** en Resumen.
  - Jet A1 y Gasolina Av 100 tienen `Filtro Ultimos` (7 columnas restringidas).
  - La función `GetProductFamily()` en el RDL agrupaba ambos subgrupos como `"LiquidosEstandar"`, aplicando la restricción de 3 columnas a los que no debían tenerla.
- **Evidencia:** Screenshots del usuario (Imagen 1 y 2): Cognos muestra 9 cols en Resumen, Power BI mostraba 3.
- **Próximo paso:** Corregir `GetProductFamily()` e `IsColumnAllowed()`.

### 2026-04-22 — Iteración 2: Split de familia LiquidosEstandar

- **Pregunta/problema:** `GetProductFamily()` retornaba `"LiquidosEstandar"` para 6 productos distintos con comportamientos distintos según el XML spec.
- **Decisión:** Dividir en dos familias: `LiquidosBase` (then(1), sin restricción) y `LiquidosAv` (Filtro Ultimos, 7 columnas).
- **Acción:** Edición de `Precios Unitarios Ex Planta - detalle.rdl`:
  - `GetProductFamily()`: `"Gasolina Super 95", "Gasolina Premium 97", "Gasoil 50-S", "Gasoil 10-S"` → `"LiquidosBase"` / `"Gasolina Av 100 Octanos", "Jet A1"` → `"LiquidosAv"`
  - `IsColumnAllowed()` para `LiquidosBase` en todos los viewKeys: whitelist de 9 columnas para Summary (PVP, PIT, PEPImp, PEPSinFlete, PEP, Factor, Ursea, PPIN1, PPIN2) y `Return True` inicial en Detail (corregido en iteración 3)
  - `IsColumnAllowed()` para `LiquidosAv`: whitelist restringido a 3 cols en Summary, 7 cols en Detail
- **Evidencia:** Primera publicación mostró 12 cols en Resumen (3 de más) y 19 en Detalle (2 de menos).
- **Próximo paso:** Ajustar whitelist de LiquidosBase en Summary; investigar columnas faltantes en Detalle.

### 2026-04-22 — Iteración 3: Corrección de whitelists Summary y strings de conceptos DAX

- **Pregunta/problema:** Dos problemas simultáneos:
  1. Resumen mostraba 12 columnas (3 de más): IMESI, Tasa URSEA primaria, FUDAEE tienen datos en `Precios_Ex_Planta` pero son conceptos de Detalle, no de Resumen. El `Return True` inicial era demasiado permisivo.
  2. Detalle mostraba 19 columnas (2 de menos): Tasa URSEA etapa secundaria e IVA etapa secundaria siempre aparecían vacías.
- **Decisión:**
  1. Para Summary de LiquidosBase: reemplazar `Return True` por whitelist explícito de 9 columnas (igual que FuelOils/PropanoGranel pero con PIT y PEPSinFlete adicionales, sin Factor/Ursea/PPIN para este caso).
  2. Para las columnas faltantes: leer el XML spec para encontrar los nombres crudos reales. El XML spec revela que `"Tasa URSEA etapa secundaria"` es una etiqueta de display que Cognos asigna a 3 conceptos crudos distintos.
- **Acción:** Edición de `Precios Unitarios Ex Planta - detalle.rdl`:
  - `IsColumnAllowed("SummaryUsd"/"SummaryLocalMain", LiquidosBase)`: whitelist → `"PVP", "PIT", "PEPImp", "PEPSinFlete", "PEP", "Factor", "Ursea", "PPIN1", "PPIN2"`
  - `dsResumen` y `dsDetalle` (CommandText DAX): `TasaURSEASecundaria` corregido de `= "Tasa URSEA etapa secundaria"` a `IN { "Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)", "Tasa URSEA S/ IMM cierre", "Tasa URSEA CFS" }`. Idem para `IVASecundaria`.
  - Fuente en XML spec líneas 619–623.
- **Evidencia:** Pendiente de validación por el usuario tras publicación.
- **Próximo paso:** Validar contra Cognos: Resumen debe mostrar 9 cols, Detalle 21 cols para Super 95/2026/USD/m3. Si siguen faltando cols en Detalle, los nombres de concepto en `Precios_Ex_Planta` pueden diferir de los del XML spec.

### 2026-04-22 — Iteración 4: Reescritura completa de IsColumnAllowed desde XML spec (Fase 1+3 del plan)

- **Pregunta/problema:** El plan acordado requiere una fuente de verdad canónica extraída mecánicamente del XML spec, y corregir todos los whitelists de una sola vez en lugar de ir familia por familia.
- **Decisión:** Crear `inputs/mappings/detalle-filtros-xml.md` con la matriz canónica completa (9 familias × 2 vistas), luego reescribir `IsColumnAllowed()` completo usando esa matriz.
- **Acción:**
  - Creado `inputs/mappings/detalle-filtros-xml.md` — fuente de verdad para visibilidad de columnas (reemplaza `detalle-cognos-behavior-matrix.md`)
  - Reescritura completa de `IsColumnAllowed()` en el RDL:
    - **Summary (SummaryUsd + SummaryLocalMain):** corregido LiquidosBase (agregado MontoDiferencial faltante)
    - **Detail:** corregidos todos los bugs documentados en la matriz:
      - LiquidosAv: agregado Ursea (faltaba)
      - SolventesEspeciales: agregados TasaDist, TasaPrim, FUDAEE, Ursea (faltaban)
      - FuelOils: reemplazado `Return True` genérico por whitelist explícito de 13 cols
      - PropanoGLPGranel: reemplazado `Return True` genérico por whitelist explícito de 13 cols
      - QuerosenoMontevideo: reemplazado `Return True` genérico por whitelist explícito de 11 cols
      - QuerosenoInterior: reemplazado `Return True` genérico por whitelist explícito de 15 cols
      - Butano: reemplazado `Return True` genérico por whitelist explícito de 7 cols
- **Evidencia:** Pendiente de validación por el usuario.
- **Próximo paso:** Publicar y validar al menos 1 caso por familia. Si alguna columna sigue faltando, el problema está en los strings de concepto del DAX (Fase 2 del plan).

### 2026-04-23 — Iteración 5: Layout fidelity (compresión + revert) y rename de headers display

- **Pregunta/problema:** (a) En Power BI service la tabla Detalle no ocupaba el ancho del header; intenté comprimir 30 columnas de 29.90in → 19.50in con fuentes 7pt y CanGrow=false, pero quedó ilegible (números en 2 líneas, palabras cortadas tipo "distribui/doras"). (b) Tres headers mostraban el nombre crudo del concepto DAX en lugar del display name de Cognos.
- **Decisión:**
  (a) Revertir la compresión. Los reportes paginados son fixed-layout; forzar responsive sacrifica legibilidad. Se acepta scroll horizontal en pantallas <2880px.
  (b) Renombrar solo los `<Value>` de los headers (no tocar filtros DAX): usar el display name que sale del `case when` del XML spec Cognos.
- **Acción:** Edición de `Precios Unitarios Ex Planta - detalle.rdl`:
  - **Revert layout:** columnas Detalle restauradas a 0.60–1.40in (total 29.85in), headers a 8pt, CanGrow=true en datos, altura fila header 0.38in, contenedor y body 29.85in, logo Detalle Left=28.20in, nota Detalle Left=25.60in.
  - **Renames de headers display** (los filtros DAX siguen apuntando al crudo):
    - `"Margen de distribuidoras"` → `"Margen de distribución"` (2 ocurrencias)
    - `"Tasa URSEA etapa primaria"` → `"Tasa URSEA primaria"` (3 ocurrencias)
    - `"PPI sin tasas e impuestos"` → `"PEP calculado por URSEA (*)"` (2 ocurrencias en Detalle; Resumen ya tenía la versión correcta)
  - **Causa raíz del bug de headers:** al armar los headers originalmente se usó la misma string del filtro DAX sin consultar el `case when ... then ...` de relabeling del XML spec (líneas 87–90, 114–117, 176, 180, 225, 229 del xml-spec-cognos.xml).
- **Evidencia:** Verificación post-cambio: 0 occurrences de los strings viejos en `<Value>`, DAX `&quot;...&quot;` intacto con 2 ocurrencias cada uno.
- **Próximo paso:** Usuario valida en Power BI service que headers, ancho de tabla y legibilidad sean correctos.

### 2026-04-24 — Iteración 6: Banner fijo 11in para eliminar franja azul vacía

- **Pregunta/problema:** Al publicar, el banner azul (título + logo) se extendía hasta 29.85in (Detalle) / 23.35in (Resumen), dejando una franja azul vacía enorme a la derecha para productos con tablas angostas (ej. Butano Desodorizado, `tablixSummaryLocal` = 7.85in, 8 cols). El scroll horizontal llevaba al usuario a una zona donde solo veía banner azul vacío con el logo ANCAP al final, sin contenido útil.
- **Diagnóstico:**
  - `Body`/`BodyCanvas` = 29.85in (dominado por `rectDetailSection` que contiene `tablixDetailLocal`/`tablixDetailUSD` dimensionados para la variante más ancha: gasolinas 21 cols).
  - Banner Resumen (`rectBodyHeaderSummary`): 23.35in, logo Left=21.55in.
  - Banner Detalle (`rectBodyHeaderDetalle`): 29.85in, logo Left=28.20in.
  - El banner se había dimensionado para "coincidir" con el tablix más ancho de su sección, pero eso obliga a mostrar franja vacía cuando el producto activo es angosto.
- **Decisión:** Fijar ambos banners a 11in (= `PageWidth`), anclados a la izquierda, logo al borde derecho del banner (Left=9.55in, Width=1.40in). El body global sigue en 29.85in porque los Detail tablix de productos anchos lo requieren (retro iteración 5: se aceptó scroll horizontal en esos casos a favor de legibilidad). Se desacopla el ancho del banner del ancho del body.
- **Acción:** Edición de `Precios Unitarios Ex Planta - detalle.rdl`:
  - `rectBodyHeaderSummary`: Width 23.35in → 11.00in. `txtBodyTituloSummary` + `txtBodySubtituloSummary`: Width 23.35in → 11.00in. `imgBodyLogoSummary`: Left 21.55in → 9.55in.
  - `rectBodyHeaderDetalle`: Width 29.85in → 11.00in. `txtBodyTituloDetalle` + `txtBodySubtituloDetalle`: Width 29.85in → 11.00in. `imgBodyLogoDetalle`: Left 28.20in → 9.55in.
- **Evidencia:** Pendiente de validación por el usuario tras publicación (productos angostos como Butano y anchos como Gasolina Super 95).
- **Próximo paso:** Validar que el banner se ve correcto para productos angostos (sin franja vacía) y anchos (al scrollear a la derecha, el banner queda fuera de vista, comportamiento esperado).

### 2026-04-24 — Iteración 7: Unificar estilo de banner con el reporte base

- **Pregunta/problema:** Al ver el reporte en Power BI service en monitor 24", el banner (fijo a 11in desde iteración 6) quedaba visualmente corto frente a la sección, y la nota URSEA (`Left=19.05in` en Resumen / `25.60in` en Detalle) aparecía flotando en la esquina inferior derecha muy alejada del banner, dando sensación de layout roto. El usuario pidió "header igual al del reporte base" (estructura + estilo, conservando el texto actual).
- **Diagnóstico:**
  - Base (`Precios_unitarios_ex_planta_base.rdl`): banner vive en `<PageHeader>`, width 20.5in (≈ `PageWidth` 21in), fondo `#0f254c`, `BottomBorder #ffc728` 2.25pt, fuente Tahoma, logo anclado al borde derecho (`Left=18.85in`).
  - Detalle: banner vive en el body dentro de `rectSummarySection` (23.35in) y `rectDetailSection` (29.85in), fondo `#1B345D`, `Border` completo `#F3C23C`, sin fuente declarada.
- **Decisión:** Conservar banner en body (no mover a PageHeader — las notas URSEA y el tabbing por sección ya están anclados a cada `rectSection`, moverlo obligaría a refactor más amplio). Ajustar ancho del banner al ancho de su sección contenedora + adoptar el estilo visual del base (colores + `BottomBorder` + Tahoma). Esto revierte parcialmente iteración 6 (vuelve a haber franja azul para productos angostos), pero el usuario priorizó coherencia visual con base sobre el ajuste dinámico por producto.
- **Acción:** Edición de `Precios Unitarios Ex Planta - detalle.rdl`:
  - `rectBodyHeaderSummary`: Width 11→23.35in. `txtBodyTituloSummary` + `txtBodySubtituloSummary`: Width 11→23.35in, agregado `<FontFamily>Tahoma</FontFamily>`, `BackgroundColor` `#1B345D`→`#0f254c`. `imgBodyLogoSummary`: Left 9.55→21.90in. Rectángulo: `Border Solid #F3C23C`→`Border None` + `BottomBorder Solid #ffc728 2.25pt`, `BackgroundColor` `#1B345D`→`#0f254c`.
  - `rectBodyHeaderDetalle`: mismo tratamiento con Width=29.85in, logo Left=28.40in.
- **Evidencia:** Pendiente de validación en Power BI service (Aguarras/2026/USD/m3 fue el caso que disparó el pedido).
- **Próximo paso:** Validar que (a) el banner ocupe todo el ancho del contenido en Resumen y Detalle, (b) estilo visual coincida con el reporte base, (c) la nota URSEA ya no se perciba aislada.

### 2026-04-24 — Iteración 8: Centrado de matrices

- **Pregunta/problema:** En monitor 24" las matrices (tablixes) de productos angostos (ej. Butano) aparecen pegadas a la izquierda, desperdiciando el espacio horizontal central. El usuario pidió centrarlas.
- **Diagnóstico:**
  - RDL no permite expresiones en `Left`/`Top`/`Width` — centrado estático es la única opción válida.
  - 3 tablixes de Resumen tienen ancho variable pero menor a la sección: `tablixSummaryUSDTM1` (7.85in), `tablixSummaryLocal` (8.80in), `tablixSummaryLocalMain` (19.40in) — se pueden centrar estáticamente ajustando `Left`.
  - 3 tablixes "full-width" (`tablixSummaryUSD` 23.35in, `tablixDetailUSD` 29.85in, `tablixDetailLocal` 29.85in) muestran solo los conceptos activos por producto (columnas dinámicamente ocultas vía `IsColumnAllowed`). Centrado estático no es posible; se requiere una columna spacer con visibilidad condicional.
- **Decisión:**
  - Tablixes sub-ancho de Resumen: centrado estático via `Left = (secciónWidth - tablixWidth) / 2`.
  - Tablixes full-width: columna spacer de 11in al inicio, `Visibility.Hidden = Not Code.ShouldCenterTable(...)`. Opción A: aceptar que la suma de columnas (TablixWidth + 11in) exceda el ancho de la sección — Report Builder puede emitir warning pero renderiza correctamente. Piloto en `tablixDetailLocal`.
- **Acción:** Edición de `Precios Unitarios Ex Planta - detalle.rdl`:
  - `tablixSummaryUSDTM1`: Left 0.80 → 7.75in (centrado en 23.35in: (23.35–7.85)/2 = 7.75).
  - `tablixSummaryLocal`: Left 4.20 → 7.28in (centrado en 23.35in: (23.35–8.80)/2 = 7.28).
  - `tablixSummaryLocalMain`: Left 6.05 → 1.98in (centrado en 23.35in: (23.35–19.40)/2 = 1.975).
  - Agregada función `Public Function ShouldCenterTable(viewKey, product) As Boolean` en bloque `<Code>`: retorna `True` para cualquier familia que no sea `LiquidosBase`.
  - `tablixDetailLocal` (piloto): añadida columna spacer 11in al inicio de `<TablixColumns>`, correspondiente `<TablixMember>` al inicio de `<TablixColumnHierarchy>` (Hidden = Not ShouldCenterTable), celdas spacer en fila header y fila data. Width actualizado de 29.85in → 40.85in.
- **Evidencia:** Verificación programática post-edición: 31 TablixColumns, 31 TablixMember en jerarquía, 31 células en ambas filas, Width=40.85in, tablixDetailUSD sin cambios (Width=29.85in).
- **Próximo paso:** Validar en Power BI service que tablixDetailLocal se centra correctamente para Butano (y similares) y que LiquidosBase sigue sin spacer. Si OK, extender a tablixSummaryUSD y tablixDetailUSD.

### 2026-04-30 — Iteración 9: Fix de XML inválido en ShouldCenterTable

- **Pregunta/problema:** Al ejecutar/publicar el reporte, Power BI Report Builder fallaba con `Un nombre no puede empezar con el carácter '>', valor hexadecimal 0x3E. línea 7879, posición 18.`
- **Decisión:** Corregir la causa mínima en el bloque `<Code>`: el operador VB `<>` agregado en `ShouldCenterTable()` quedó sin escapar dentro del XML del RDL.
- **Acción:** Edición de `Precios Unitarios Ex Planta - detalle.rdl`: `Return family <> "LiquidosBase"` → `Return family &lt;&gt; "LiquidosBase"`.
- **Evidencia:** Parseo XML reproducía el error antes del cambio. Después del cambio, `[xml](Get-Content -Raw ...)` devuelve `XML_OK` y `rg -F '<>'` no encuentra operadores sin escapar.
- **Próximo paso:** Usuario vuelve a abrir/publicar el RDL en Power BI Report Builder/Service y valida el piloto de centrado de `tablixDetailLocal` para productos angostos y `LiquidosBase`.

### 2026-04-23 — Side-effect: arranque y cierre de sesión automatizados

- **Pregunta/problema:** El usuario tenía que recordar manualmente que yo actualizara la bitácora al cerrar la sesión.
- **Decisión:** Crear `CLAUDE.md` en la raíz apuntando a `AGENTS.md`. Claude Code lee `CLAUDE.md` automáticamente al iniciar cualquier sesión en el proyecto, heredando los rituales de arranque (leer STATUS.md, report.yaml, SKILL.md) y cierre (actualizar report.yaml + STATUS.md + SKILL.md) sin duplicar reglas.
- **Acción:** Creado `CLAUDE.md` (2 líneas) con "Leer AGENTS.md antes de hacer cualquier cosa. Seguir todas las instrucciones de AGENTS.md sin excepción."

## Validación

| # | Escenario | Parámetros | Esperado (Cognos) | Obtenido (RDL) | OK? | Evidencia |
|---|---|---|---|---|---|---|
| 1 | Resumen USD - Líquidos base | pAnio=2026, pProducto=Gasolina Super 95, pUnidad=USD/m3, pVista=Resumen | 9 columnas | 12 → pendiente re-validar | parcial | Screenshots sesión 2026-04-22 |
| 2 | Detalle USD - Líquidos base | pAnio=2026, pProducto=Gasolina Super 95, pUnidad=USD/m3, pVista=Detalle | 21 columnas | 19 → pendiente re-validar | parcial | Screenshots sesión 2026-04-22 |

## Reglas especiales / cutovers

- **`MostrarPestañaDetalle`** (XML spec línea 857): la pestaña Detalle debe ocultarse para Supergas, Supergas A Granel, Propano Redes, Propano Industrial, Asfalto RC2, Asfalto MC1, Asfalto AC-30, Asfalto 150/200. **No implementado todavía.**
- **Cutover 202106:** para LiquidosBase, LiquidosAv, SolventesEspeciales, FuelOils, Butano la rama TM1 deja de tener datos.
- **Cutover 202107:** para QuerosenoMontevideo y QuerosenoInterior la rama TM1 deja de tener datos.
- **Cutover 202306:** para SupergasEnvasado, PropanoGLPGranel la rama TM1 deja de tener datos.
- **`then(1)` en Filtro maestro:** Gasolina Super 95, Gasolina Premium 97, Gasoil 50-S, Gasoil 10-S no tienen restricción de conceptos en Cognos — todos los conceptos con datos aparecen.
- **Etiquetas de display vs. nombres crudos:** varios conceptos del XML spec son relabelings. Siempre usar el nombre crudo de `Precios_Ex_Planta[Concepto]` en el DAX, no la etiqueta de display de Cognos.
- **Nota URSEA (`(*) Equivale al precio del Subtotal 3 del Informe URSEA`):** aplica a SolventesEspeciales vía query `Texto *`. Dataset `dsTexto` controla si se muestra o no.

## Open questions

- ¿Los nombres crudos de `IVA etapa secundaria` / `Tasa URSEA etapa secundaria` en `Precios_Ex_Planta` coinciden con los del XML spec (`"IVA flete..."`, `"Tasa URSEA CFS"`, etc.)? Pendiente de validar tras próxima publicación.
- ¿Implementar `MostrarPestañaDetalle` ahora o dejarlo para una iteración posterior?

## Retrospectiva

_Llenar sólo cuando `report.yaml:status` pase a `done`._
