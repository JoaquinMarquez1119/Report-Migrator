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

### 2026-04-23 — Side-effect: arranque y cierre de sesión automatizados

- **Pregunta/problema:** El usuario tenía que recordar manualmente que yo actualizara la bitácora al cerrar la sesión.
- **Decisión:** Crear `CLAUDE.md` en la raíz apuntando a `AGENTS.md`. Claude Code lee `CLAUDE.md` automáticamente al iniciar cualquier sesión en el proyecto, heredando los rituales de arranque (leer STATUS.md, report.yaml, SKILL.md) y cierre (actualizar report.yaml + STATUS.md + SKILL.md) sin duplicar reglas.
- **Acción:** Creado `CLAUDE.md` (2 líneas) con "Leer AGENTS.md antes de hacer cualquier cosa. Seguir todas las instrucciones de AGENTS.md sin excepción."

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

### 2026-04-30 — Iteración 10: Fix de Name faltante en rectangles del spacer

- **Pregunta/problema:** Al ejecutar el reporte, Report Builder fallaba con `Falta el atributo 'Name' necesario. línea 5785, posición 91.`
- **Decisión:** Corregir los report items creados para la columna spacer de `tablixDetailLocal`; los `<Rectangle>` dentro de `CellContents` también requieren atributo `Name`.
- **Acción:** Edición de `Precios Unitarios Ex Planta - detalle.rdl`: se nombraron los dos rectangles del spacer como `rectDetailLocalSpacerHeader` y `rectDetailLocalSpacerData`.
- **Evidencia:** Verificación local: parseo XML `XML_OK`, chequeo de report items sin `Name` devuelve `MISSING_NAME_OK`, y chequeo de nombres duplicados devuelve `DUPLICATE_NAME_OK`. El validador estructural existente llega a una regla no relacionada sobre `Width` en `2.25pt` de bordes.
- **Próximo paso:** Usuario vuelve a abrir/publicar el RDL y valida si Report Builder deserializa completo; si aparece otro error de deserialización, continuar desde la línea indicada.

### 2026-04-30 — Iteración 11: Reemplazo de ReportItems vacío en spacer

- **Pregunta/problema:** Report Builder siguió fallando en la línea 5785 con `El contenido del elemento 'ReportItems' ... está incompleto`; el `<ReportItems />` vacío dentro de los rectangles del spacer no cumple el esquema RDL.
- **Decisión:** No usar rectangles vacíos para el spacer. Reemplazarlos por `Textbox` vacíos, que es el patrón ya usado por otras celdas vacías del RDL.
- **Acción:** Edición de `Precios Unitarios Ex Planta - detalle.rdl`: `rectDetailLocalSpacerHeader` y `rectDetailLocalSpacerData` se reemplazaron por `txtDetailLocalSpacerHeader` y `txtDetailLocalSpacerData`, ambos con `<Value></Value>`.
- **Evidencia:** Verificación local: `XML_OK`, `RDL_NAME_CHECK_OK`, y `rg '<ReportItems\s*/>'` no encuentra ocurrencias. El validador estructural amplio sigue frenando por la regla existente de `Width` en `2.25pt`, no relacionada con el spacer.
- **Próximo paso:** Usuario vuelve a abrir/publicar el RDL y confirma si ya deserializa completo; luego validar centrado de `tablixDetailLocal`.

### 2026-05-03 — Iteración 12: Revert del spacer de centrado (Opción 1)

- **Pregunta/problema:** Con el spacer publicado, los usuarios ven dos síntomas en pestaña Detalle: (a) Butano y otras familias angostas: tabla aparenta estar centrada pero el banner azul "se corta" antes de llegar al borde derecho del viewport; (b) Gasolina Super 95 (LiquidosBase): tabla pegada a la izquierda y banner también cortado. Se reproduce con muchos productos.
- **Diagnóstico:** Mediciones del RDL — `tablixDetailLocal.Width=40.85in` (29.85 originales + spacer 11in) excede al `rectDetailSection` y `rectBodyHeaderDetalle`, ambos en 29.85in. Cuando se renderiza `tablixDetailLocal` (unidad local), Report Builder expande el viewport para mostrar el tablix completo, dejando 11in de canvas a la derecha del banner sin fondo azul → se percibe como "header cortado". Para `tablixDetailUSD` (USD/m3, 29.85in, sin spacer), el viewport heredado del body extendido provoca el mismo síntoma. Adicional: el spacer fijo de 11in no centra de verdad — desplaza la tabla 11in pase lo que pase con el ancho del tablix dinámico.
- **Decisión:** Opción 1 (revert) sobre Opción 2 (extender banner+sección a 40.85in). El centrado dinámico real en RDL paginado no es viable — `Left`/`Width` no aceptan expresiones y un spacer fijo no centra para tablas de ancho variable. Coherente con el reporte base y con `tablixDetailUSD`.
- **Acción:** Edición de `Precios Unitarios Ex Planta - detalle.rdl`:
  - `tablixDetailLocal.TablixColumns`: removida la primera `<TablixColumn><Width>11.00in</Width></TablixColumn>` (queda en 30 columnas).
  - Header row y data row: removidas las celdas `txtDetailLocalSpacerHeader` / `txtDetailLocalSpacerData` (queda en 30 celdas por fila).
  - `tablixDetailLocal.TablixColumnHierarchy`: removido el primer `TablixMember` con `Visibility=Not Code.ShouldCenterTable(...)` (queda en 30 members).
  - `tablixDetailLocal.Width`: `40.85in` → `29.85in`.
  - Bloque `<Code>`: eliminada la función `Public Function ShouldCenterTable(...)`.
- **Evidencia:** `XML_OK`, conteos `cols=30 members=30 headerCells=30 dataCells=30 width=29.85in`, búsqueda de `ShouldCenterTable|txtDetailLocalSpacer|40.85in|11.00in` no encuentra ocurrencias.
- **Próximo paso:** Usuario abre/publica el RDL y valida en Power BI service que (a) Butano en pestaña Detalle ya no muestra el "banner cortado", aceptando tabla pegada a izquierda; (b) Gasolina Super 95 en Detalle USD también queda alineada y con banner completo; (c) los tablixes Resumen sub-ancho (`tablixSummaryUSDTM1`, `tablixSummaryLocal`, `tablixSummaryLocalMain`) siguen centrados como en iter 8 — esos `Left` fijos no se tocaron.

### 2026-05-03 — Iteración 13: Banner y nota URSEA fijos a 11in (Opción C de "no scroll horizontal")

- **Pregunta/problema:** Tras revert del spacer (iter 12) el "header cortado" desapareció pero el body sigue en 29.85in (pestaña Detalle dimensionada para gasolinas con 30 cols). Para Butano (7 cols, ~6in de tabla) el reporte exige scroll horizontal hasta 29.85in para llegar al borde derecho del banner y a la nota URSEA. El usuario pidió no tener que scrollear para productos angostos.
- **Diagnóstico:** En RDL paginado el ancho del Body es fijo (max de las secciones). `rectDetailSection.Width=29.85in` lo arrastra al ancho del peor caso. El tablix ancho no se puede achicar sin perder legibilidad (descartado en iter 5). Pero **el banner y la nota URSEA no necesitan ese ancho** — son contenido fijo independiente del producto. Si los recortamos a 11in (PageWidth), un usuario con tabla angosta cabe sin scroll en pantalla; uno con tabla ancha sigue necesitando scroll, pero al scrollear va a ver tabla + canvas vacío fuera del banner (ya aceptado en iter 5 como compromiso).
- **Decisión:** Opción C — recortar banner y nota URSEA a 11in tanto en pestaña Resumen como Detalle. `rectSummarySection`, `rectDetailSection`, los tablixes y el Body global se mantienen en sus anchos actuales (no se tocan). Las posiciones "centradas" de tablixes Resumen sub-ancho (`tablixSummaryUSDTM1`, `tablixSummaryLocal`, `tablixSummaryLocalMain`) tampoco se tocan — siguen centradas respecto a 23.35in, no respecto al banner reducido.
- **Acción:** Edición de `Precios Unitarios Ex Planta - detalle.rdl` — 10 cambios:
  - **Banner Resumen:** `rectBodyHeaderSummary.Width` 23.35→11.00in. `txtBodyTituloSummary.Width` 23.35→11.00in. `txtBodySubtituloSummary.Width` 23.35→11.00in. `imgBodyLogoSummary.Left` 21.90→9.55in.
  - **Banner Detalle:** `rectBodyHeaderDetalle.Width` 29.85→11.00in. `txtBodyTituloDetalle.Width` 29.85→11.00in. `txtBodySubtituloDetalle.Width` 29.85→11.00in. `imgBodyLogoDetalle.Left` 28.40→9.55in.
  - **Notas URSEA:** `txtNotaResumen.Left` 19.05→7.00in (queda alineada al borde derecho del banner: 7+4=11). `txtNotaDetalle.Left` 25.60→7.00in.
- **Evidencia:** `XML_OK`, verificación XPath confirma `rectBodyHeader*.Width=11.00in`, `imgBodyLogo*.Left=9.55in`, `txtNota*.Left=7.00in`.
- **Próximo paso:** Usuario publica y valida en Power BI service que (a) Butano y otros productos angostos en Detalle local caben en pantalla sin scroll horizontal y banner+nota se ven completos en los primeros 11in; (b) gasolinas/gasoils siguen requiriendo scroll para ver toda la tabla, pero el banner sigue acotado a 11in y la franja a la derecha es canvas blanco (no banner cortado). Si la franja blanca a la derecha del banner molesta visualmente para productos anchos, evaluar Opción A (compresión de columnas) en una iteración futura.

### 2026-05-03 — Iteración 14: Banner ajustado al ancho de la tabla más larga por sección

- **Pregunta/problema:** Iteración 13 dejó el banner en 11in, pero el usuario quiere que el banner coincida exactamente con el ancho de la tabla más larga.
- **Decisión:** Banner de cada sección = ancho del tablix más ancho de esa sección. `tablixSummaryUSD`=23.35in para Resumen; `tablixDetailUSD`/`tablixDetailLocal`=29.85in para Detalle. Para productos angostos habrá franja azul vacía dentro del banner (igual que antes de iter 6). Para productos anchos el banner cubrirá exactamente la tabla.
- **Acción:** Edición de `Precios Unitarios Ex Planta - detalle.rdl` — revert de los 10 cambios de iter 13: `rectBodyHeaderSummary.Width` 11→23.35in, `rectBodyHeaderDetalle.Width` 11→29.85in, logos Left 9.55→21.90/28.40in, notas URSEA Left 7.00→19.05/25.60in. Textboxes internos del banner actualizados en la misma proporción.
- **Evidencia:** `XML_OK`, `rectBodyHeaderSummary.Width=23.35in`, `rectBodyHeaderDetalle.Width=29.85in`, logos y notas en posiciones originales.
- **Próximo paso:** Usuario publica y valida que el banner ahora coincide con el ancho de la tabla en todos los productos.

### 2026-05-03 — Iteración 15: Banner Detalle ajustado al ancho real de la tabla visible (21.80in)

- **Pregunta/problema:** El banner Detalle de 29.85in incluía la franja de las 8 columnas ocultas (sin datos para LiquidosBase / 2026). El usuario quiere que el banner coincida con la tabla visible real.
- **Diagnóstico:** Para Gasolina Super 95 / 2026 / USD/m3 (LiquidosBase, caso más largo), 8 columnas no tienen datos y se colapsan via `Count > 0`: MargenGLPEnvasado (1.15in), IVAVentaPublico (0.90in), MargenEnvasado (1.00in), IVADistribucion (0.90in), TasaInflamable (0.90in), IVAPrimaria (0.90in), Fideicomiso (0.90in), MontoDiferencial (1.40in). Total oculto = 8.05in. Tabla visible = 29.85 − 8.05 = **21.80in**.
- **Decisión:** Banner Detalle = 21.80in. Trade-off: si en años anteriores (pre-2023) TasaInflamable tiene datos, la tabla crece a 22.70in y el banner quedaría 0.90in corto. Aceptado por el usuario.
- **Acción:** `rectBodyHeaderDetalle.Width` 29.85→21.80in. `txtBodyTituloDetalle.Width` 29.85→21.80in. `txtBodySubtituloDetalle.Width` 29.85→21.80in. `imgBodyLogoDetalle.Left` 28.40→20.40in (21.80−1.40). `txtNotaDetalle.Left` 25.60→17.80in (21.80−4.00). Banner Resumen no se tocó.
- **Evidencia:** `XML_OK`, dimensiones verificadas via XPath: todos los elementos en 21.80in / 20.40in / 17.80in.
- **Próximo paso:** Usuario publica y valida que el banner Detalle coincide con la tabla para Gasolina Super 95 / 2026 y que para años anteriores (si TasaInflamable tiene datos) el descalce es mínimo.

### 2026-05-03 — Iteración 16: Banner Resumen igualado al banner Detalle (21.80in)

- **Pregunta/problema:** Tras iter 15 el banner Detalle quedó en 21.80in pero el banner Resumen seguía en 23.35in. El usuario observó que ambas pestañas tienen distinto largo de banner.
- **Decisión:** Fijar banner Resumen a 21.80in (igual que Detalle). La tabla visible del Resumen para LiquidosBase/2026 mide ~17.65in — 4.15in menos que el banner. El excedente queda como franja azul vacía dentro del banner, aceptable.
- **Acción:** `rectBodyHeaderSummary.Width` 23.35→21.80in. `txtBodyTituloSummary.Width` 23.35→21.80in. `txtBodySubtituloSummary.Width` 23.35→21.80in. `imgBodyLogoSummary.Left` 21.90→20.40in. `txtNotaResumen.Left` 19.05→17.80in.
- **Evidencia:** `XML_OK`. Ambos `rectBodyHeader*.Width=21.80in`, logos `Left=20.40in`, notas `Left=17.80in`.
- **Próximo paso:** Usuario publica y valida que ambas pestañas tienen el mismo largo de banner.

### 2026-05-03 — Iteración 17: Fix dsTexto — reemplazar texto del base por lógica correcta del detalle

- **Pregunta/problema:** En Power BI aparecía el texto "Los Precios Ex planta surgen de deducirle…" en ambas pestañas del detalle, pero en Cognos no aparece ningún texto para Aguarras (ni para la mayoría de productos).
- **Diagnóstico:** El `dsTexto` del RDL tenía hardcodeado un `ROW(...)` con el texto del **reporte base** (`reports/precios-unitarios-ex-planta-base/inputs/xml-spec/xml-spec-cognos.xml:494`), copiado incorrectamente. La lógica correcta está en `inputs/queries/Texto.sql`: devuelve `''` para 19 productos (todos los solventes, asfaltos, querosenos, Supergas/Propanos, Butano, Jet A1, Av 100) y `'(*) Equivale al precio del Subtotal 3 del Informe URSEA'` para el resto (Gasolinas, Gasoils, Fueloils). El `Visibility.Hidden = Trim(Texto)=""` ya estaba correcto — solo esperaba un dataset que devuelva vacío cuando corresponde.
- **Decisión:** Reemplazar `CommandText` de `dsTexto` por expresión DAX que replica el `CASE WHEN` de `Texto.sql`, usando `@pProducto IN __Excluidos`.
- **Acción:** Edición del `CommandText` de `dsTexto`: eliminado el `ROW(...)` hardcodeado; reemplazado por `VAR __Excluidos = {...19 productos...} RETURN ROW("Texto", IF(@pProducto IN __Excluidos, "", "(*) Equivale..."))`.
- **Evidencia:** `XML_OK`. Para Aguarras (en lista de excluidos) el texto será `""` → textbox se oculta por `Visibility.Hidden`. Para Gasolina Super 95 (no excluido) aparece la nota URSEA corta.
- **Próximo paso:** Usuario publica y valida (a) Aguarras/2026: no aparece texto; (b) Gasolina Super 95/2026: aparece `(*) Equivale al precio del Subtotal 3 del Informe URSEA`.

### 2026-05-03 — Iteración 18: Fix dsTexto — lógica de visibilidad movida a VB.NET (error @pProducto en DAX)

- **Pregunta/problema:** La iteración 17 introdujo `@pProducto IN __Excluidos` en DAX, pero Power BI/AS no admite parámetros `@` inline en queries `EVALUATE`. Error: "The query contains the '' parameter, which is not declared."
- **Decisión:** Mover la lógica de exclusión al bloque `<Code>` VB.NET. `dsTexto` queda como un ROW estático que siempre devuelve el texto URSEA. La visibilidad del textbox pasa a depender directamente de `Parameters!pProducto.Value` a través de una nueva función VB.
- **Acción:**
  - `dsTexto.CommandText`: simplificado a `EVALUATE ROW("Texto", "(*) Equivale al precio del Subtotal 3 del Informe URSEA")`.
  - `<Code>`: agregada función `Public Function ShowNotaUrsea(product As String) As Boolean` — devuelve `False` para los 19 productos excluidos (= lista de `Texto.sql`), `True` para el resto.
  - `txtNotaResumen.Visibility.Hidden` y `txtNotaDetalle.Visibility.Hidden`: cambiado de `=Trim(First(Fields!Texto.Value, "dsTexto")) = ""` a `=Not Code.ShowNotaUrsea(Code.NormalizeProduct(Parameters!pProducto.Value))`.
- **Evidencia:** `XML_OK`. Para Aguarras → `ShowNotaUrsea` retorna `False` → `Not False = True` → textbox oculto. Para Gasolina Super 95 → retorna `True` → `Not True = False` → textbox visible con la nota URSEA.
- **Próximo paso:** Usuario publica y valida (a) Aguarras/2026: sin texto; (b) Gasolina Super 95/2026: aparece nota URSEA.

### 2026-05-03 — Iteración 19: Centrado de tablas por ancho de página (Opción C)

- **Pregunta/problema:** Tablas angostas (Butano, LiquidosAv, SolventesEspeciales, QuerosenoMontevideo) aparecen pegadas a la izquierda con el banner extendido a la derecha.
- **Análisis previo:** Opción A (centrar al banner 21.80in) fue descartada porque los spacers necesarios (hasta 7.43in) empujarían las tablas angostas fuera del viewport inicial (11in de página), obligando a scrollear derecha para encontrar el contenido — peor que el estado actual. Opción C (centrar al ancho de página 10.2in) es mejor: spacers pequeños (≤1.625in), tablas angostas permanecen visibles sin scroll.
- **Decisión:** Implementar Opción C — spacers de centrado relativo a la página (10.2in usable).
- **Spacers computados:**
  - `tablixSummaryUSD`: S1=0.35in (QuerosenoMontevideo, 9.50in visible), S2=1.25in (Butano, 7.70in), S3=1.625in (LiquidosAv/SolventesEspeciales, 6.95in)
  - `tablixDetailUSD` + `tablixDetailLocal`: D1=0.925in (LiquidosAv, 8.35in), D2=1.30in (Butano, 7.60in)
  - Familias >10.2in (LiquidosBase, SupergasEnvasado, Querosenos, FuelOils, Propano): sin spacer
- **Acción:** Script Python — añadida función VB `GetPageCenteringKey(viewKey, product)` al bloque `<Code>`; añadidas columnas spacer + TablixMember + celdas vacías al inicio de los 3 tablixes anchos.
- **Evidencia:** `XML_OK`, `NAMES_OK`.
- **Próximo paso:** Usuario publica y valida: (a) Butano Summary/Detail: tabla centrada en pantalla; (b) LiquidosAv Summary/Detail: centrada; (c) Gasolina Super 95 / Aguarras: sin cambio (>10.2in visible, sin spacer).

### 2026-05-03 — Iteración 20: Corrección del centrado — referencia banner (21.80in) en lugar de página (10.2in)

- **Pregunta/problema:** Usuario reporta que las tablas siguen sin estar centradas tras la Iteración 19.
- **Diagnóstico:** La Iteración 19 usó el ancho de página útil (10.2in) como referencia para centrar, pero el report se renderiza en modo interactivo mostrando el contenido completo (~21.80in). Los spacers resultantes (S1=0.35, S2=1.25, S3=1.625in) producen un desplazamiento apenas perceptible — centrado relativo a la página impresa, no al banner visible.
- **Decisión:** Recalcular spacers usando el banner (21.80in) como referencia. Fórmula: `spacer = (21.80 − visible_width) / 2 − 0.05` (0.05in = Left del tablix dentro del rectángulo).
- **Spacers recalculados:**
  - `tablixSummaryUSD`: S1=6.10in (QuerosenoMontevideo, 9.50in visible), S2=7.00in (Butano, 7.70in), S3=7.375in (LiquidosAv/SolventesEspeciales, 6.95in)
  - `tablixDetailUSD` + `tablixDetailLocal`: D1=6.45in (LiquidosAv, 8.80in), D2=7.125in (Butano, 7.45in)
- **Acción:** Actualización de los 3 `<TablixColumns>` (S1/S2/S3 en tablixSummaryUSD; D1/D2 en tablixDetailUSD y tablixDetailLocal). Ningún cambio en función VB ni en TablixMembers.
- **Evidencia:** Script Python verifica `tablixSummaryUSD: first 4 cols = ['6.10', '7.00', '7.375', '0.60']`, `tablixDetailUSD: ['6.45', '7.125', '0.60', '1.25']`, `tablixDetailLocal: ['6.45', '7.125', '0.60', '1.25']`.
- **Próximo paso:** Probar con Butano Desodorizado (Resumen) — spacer S2=7.00in debe centrar la tabla de 7.70in bajo el banner de 21.80in. Verificar también Jet A1 (S3) y QuerosenoMontevideo (S1).

### 2026-05-03 — Iteración 21: Centrado extendido a todas las familias

- **Pregunta/problema:** Iteración 20 solo cubría QuerosenoMontevideo, Butano, LiquidosAv y SolventesEspeciales. Las restantes familias (QuerosenoInterior, LiquidosBase, FuelOils, PropanoGLPGranel, SupergasEnvasado + variantes en Detalle) quedaban sin spacer.
- **Decisión:** Extender `GetPageCenteringKey` con claves S4–S7 (Summary) y D3–D7 (Detail). LiquidosBase en Detail no recibe spacer porque su ancho visible (29.85in) excede el banner (21.80in).
- **Spacers nuevos (fórmula: (21.80 − visible) / 2 − 0.05):**
  - S4=4.575in (QuerosenoInterior, 12.55in), S5=1.15in (LiquidosBase, 19.40in), S6=4.825in (FuelOils/PropanoGLPGranel, 12.05in), S7=2.675in (SupergasEnvasado, 16.35in)
  - D3=5.125in (SolventesEspeciales, 11.45in), D4=0.95in (SupergasEnvasado, 19.80in), D5=4.125in (FuelOils/PropanoGLPGranel, 13.45in), D6=4.625in (QuerosenoMontevideo, 12.45in), D7=2.65in (QuerosenoInterior, 16.40in)
- **Acción:** Script Python — insertadas 4 TablixColumns+Members+Cells en tablixSummaryUSD (S4–S7) y 5 en tablixDetailUSD + tablixDetailLocal (D3–D7). Actualizada función VB `GetPageCenteringKey`.
- **Evidencia:** `XML_OK`; tablixSummaryUSD cols=22 members=22 OK; tablixDetailUSD cols=37 members=37 OK; tablixDetailLocal cols=37 members=37 OK. Spacer cells: SpSumS*=14, SpDetUSD*=14, SpDetLoc*=14.
- **Próximo paso:** Validar con Gasolina Super 95 (S5, spacer 1.15in), Gasoil (mismo S5), FuelOil Medio (S6/D5), PropanoIndustrial (S6/D5), Supergas (S7/D4).

### 2026-05-04 — Iteración 22: Nota URSEA reposicionada a esquina inferior izquierda

- **Pregunta/problema:** `txtNotaResumen` y `txtNotaDetalle` estaban en `Left=5.50in` con `TextAlign=Right` (esquina derecha). El usuario quiere que aparezcan bajo la esquina inferior izquierda de la tabla.
- **Decisión:** Mover las notas a `Left=0.05in`, `Width=7.50in`, `TextAlign=Left`. Para evitar solapamiento con `txtReferente*` (que estaba en `Left=0.25in`), mover los referentes a `Left=7.60in` — quedan side-by-side en la misma fila: nota a la izquierda, referentes a la derecha.
- **Acción:** Script Python — 2 cambios en txtNotaResumen/txtNotaDetalle, 2 cambios en txtReferenteResumen/txtReferenteDetalle.
- **Evidencia:** `XML_OK`.
- **Corrección inmediata (misma iteración):** Usuario confirmó que quería la nota en la esquina DERECHA (igual que Cognos), no izquierda. Revertido: nota → TextAlign=Right, Left=0.05, Width=20.50in (Summary) / 29.75in (Detail); referentes → Left=0.25in (posición original). El borde derecho de la nota queda en 20.55in (Summary, alineado con tabla LiquidosBase ≈20.60in) y 29.80in (Detail, alineado con tabla LiquidosBase ≈29.85in).
- **Fix secundario (misma sesión):** txtNotaDetalle con Width=29.75in hacía que TextAlign=Right posicionara el texto en x≈29.80in, fuera del viewport. Corregido a Width=20.50in (igual que Summary) → borde derecho 20.55in, visible para LiquidosBase en Detalle.
- **Próximo paso:** Validar que la nota aparece visible en la esquina inferior derecha de la tabla para Gasolina Premium 97 / Gasoil en vista Detalle.

### 2026-05-04 — Iteración 23: Intento fallido de footer rows — revertido

- **Pregunta/problema:** Gap visual de ≈2.22in entre la tabla y los textos (con 5 meses de datos). Se intentó resolver con footer rows dentro de los tablixes (`TablixRowHierarchy` + `TablixRows` + `<ColSpan>N</ColSpan>`).
- **Problema descubierto:** `ColSpan` NO es un elemento válido en `TablixCell` en el esquema RDL 2016 (`http://schemas.microsoft.com/sqlserver/reporting/2016/01/reportdefinition`). Los únicos hijos válidos son `CellContents`, `DataElementName`, `DataElementOutput`. El `ColSpan` que ya existe en el archivo (en los tablixes de spacer `SpSumS1H`, `SpDetUSDD1H`, `SpDetLocD1H`) solo funciona en **header rows de group column hierarchies**, no en static member rows. Un footer row estático no puede tener celdas con colspan.
- **Decisión:** Revertir completamente. Se eliminarán los footer rows y se restaurarán los standalone textboxes. La posición estática `Top=5.95in` es el mejor compromiso posible sin reestructurar las column hierarchies.
- **Acción:** Script Python — eliminados 4 footer TablixRows (los que tenían `ColSpan`), eliminados 4 footer TablixMembers (`<KeepWithGroup>Before</KeepWithGroup>`), restauradas las visibilidades originales de los 4 textboxes standalone.
- **Evidencia:** XML válido; members/rows restaurados a los valores originales.
- **Limitación documentada:** SSRS no permite cerrar el gap dinámicamente sin colspan en el footer. El gap de ≈2.22in (para 5 meses) es inherente al posicionamiento estático. Para 12 meses el gap es ≈0.26in.
- **Próximo paso:** Descartar esta línea de mejora. Aceptar `Top=5.95in` como posición final.

### 2026-05-05 — Iteración 24: Textos al pie movidos junto a la tabla (Top 5.95 → 2.95in)

- **Pregunta/problema:** Usuario reporta que en Detalle (Asfalto AC-30 / 2022 / USD/m3) no aparece ninguno de los dos textos al pie: `txtReferenteDetalle` (siempre) y `txtNotaDetalle` (cuando `ShowNotaUrsea=True`).
- **Diagnóstico:** Los textos estaban en `Top=5.95in` dentro de `rectDetailSection` (Height=6.90in, absoluto en Body 6.95–13.85in). El tablix activo (`tablixDetailUSD`/`Local`) tiene `Top=1.95in`, design `Height=0.98in` (bottom diseño 2.93in). Con 12 meses crece a ≈4in → push-down empuja los textos a Top≈8.95in dentro de la sección (absoluto ≈15.90in). El reporte está paginado (`PageHeight=8.5in`); los textos terminan en una página posterior a la de la tabla y por eso "no aparecen" para el usuario que mira la página de datos. Es la misma brecha de iter 23, agravada por paginación.
- **Decisión:** Mover los 4 textboxes de `Top=5.95in` → `Top=2.95in` (a 0.02in del bottom de diseño del tablix). Con push-down quedan adheridos a la última fila renderizada, sin gap, sobre la misma página.
- **Acción:** Script Python — 4 reemplazos en `Precios Unitarios Ex Planta - detalle.rdl`: `txtNotaResumen`, `txtNotaDetalle`, `txtReferenteResumen`, `txtReferenteDetalle` → `Top=2.95in`.
- **Evidencia:** `XML_OK`. Verificación de los 4 reemplazos = 1 cada uno.
- **Próximo paso:** Usuario publica y valida (a) Asfalto AC-30 / 2022 / USD/m3 / Detalle: aparece `Referentes: Jefe Ventas...` debajo de la tabla, en la misma página; (b) Gasolina Super 95 / 2026 / USD/m3 / Detalle: aparecen los dos textos pegados a la tabla; (c) Resumen: ambos textos también pegados a la tabla.

### 2026-05-05 — Iteración 25: Eliminar duplicado de "No hay datos disponibles" en pestaña Detalle

- **Pregunta/problema:** En Cognos cuando no hay datos aparece un solo texto centrado bajo el banner. En Power BI aparecen DOS: uno en la esquina superior izquierda (≈Left=0.05in) y uno centrado.
- **Diagnóstico:** Coexisten dos mecanismos en el RDL — (a) `tablixDetailUSD` y `tablixDetailLocal` tienen `<NoRowsMessage>No hay datos disponibles</NoRowsMessage>`, que SSRS renderiza dentro del área del tablix (esquina superior izquierda); (b) un textbox standalone `txtEmptyState` (Left=7.20in, Top=2.10in, FontSize=11pt, TextAlign=Center) con `Visibility.Hidden = CountRows("dsDetalle") > 0` que muestra el mismo texto centrado. Los 4 tablixes de Resumen ya tenían `NoRowsMessage` vacío; el problema solo se daba en Detalle.
- **Decisión:** Vaciar `NoRowsMessage` de ambos tablixes Detail. El textbox `txtEmptyState` queda como único responsable del mensaje (centrado, igual que Cognos).
- **Acción:** Edición de `Precios Unitarios Ex Planta - detalle.rdl`: `<NoRowsMessage>No hay datos disponibles</NoRowsMessage>` → `<NoRowsMessage></NoRowsMessage>` en `tablixDetailUSD` y `tablixDetailLocal` (replace_all, 2 reemplazos).
- **Evidencia:** `XML_OK`. Conteo: `<NoRowsMessage>No hay datos disponibles</NoRowsMessage>` = 0 ocurrencias; `<NoRowsMessage></NoRowsMessage>` = 6 (4 Summary previos + 2 Detail nuevos).
- **Próximo paso:** Usuario publica y valida con Asfalto AC-30 / 2022 / USD/m3 / Detalle: aparece UN solo texto "No hay datos disponibles" centrado.

### 2026-05-05 — Iteración 26: Corner cell de tablixes con fondo blanco y letra gris

- **Pregunta/problema:** La celda esquina superior izquierda de los tablixes (intersección entre la columna de unidad y la fila de header) se ve con fondo azul `#153767` y letra blanca. En Cognos esa celda tiene fondo blanco y letra gris (igual al resto de la tabla, no al header).
- **Decisión:** Cambiar las 6 corner cells (`tablixSummaryUSD_Dia_Header`, `tablixSummaryUSDTM1_Dia_Header`, `tablixSummaryLocal_Dia_Header`, `tablixSummaryLocalMain_Dia_Header`, `tablixDetailUSD_Dia_Header`, `tablixDetailLocal_Dia_Header`): `Color=White` → `Color=#666666`, `BackgroundColor=#153767` → `BackgroundColor=White`. Mantener Bold y FontSize=8pt para minimizar cambios; si en validación queda muy bold se itera. Los headers de las demás columnas no se tocan (siguen con bg azul + texto blanco).
- **Acción:** 6 ediciones puntuales en el RDL, una por corner cell, usando el Name del Textbox como discriminador único.
- **Evidencia:** `XML_OK`. Verificación: 6 ocurrencias de `_Dia_Header`, ninguna conserva `<Color>White</Color>` ni `<BackgroundColor>#153767</BackgroundColor>` dentro del bloque corner.
- **Próximo paso:** Usuario publica y valida con cualquier producto con datos (ej. Gasolina Super 95 / 2025 / Resumen): la celda esquina superior izquierda muestra "USD/m3" o "$/lt" con fondo blanco y letra gris.

### 2026-05-05 — Iteración 27: Banner alineado al estilo del reporte base (altura compacta + subtítulo 12pt)

- **Pregunta/problema:** Usuario observa que el banner del detalle es más alto y con el subtítulo más grande que el del reporte base. Pide "igual al base".
- **Diagnóstico:** Comparación con `reports/precios-unitarios-ex-planta-base/Precios_unitarios_ex_planta_base.rdl` líneas 2840–2940 (PageHeader del base) — `rectHeader.Height=0.53in`, título Tahoma 16pt Bold (igual al detalle), subtítulo (`=Parameters!pAnio.Value`) **12pt Bold sin FontFamily** (vs 15pt en detalle), `txtHeaderAnio.Height=0.18in`, logo `Top=0.06in`, `Width=1.45in`. El detalle tenía banner alto 0.78in y subtítulo 15pt — visualmente más voluminoso.
- **Decisión:** Aplicar los cambios universales del estilo (altura, fontsize, altura subtítulo, Top del logo). NO tocar `Width` del banner ni del logo en esta iteración: el `Width=21.80in` heredó de iter 16 (= ancho de tabla más larga visible) — bajarlo a 20.5in (como base) cascadea sobre notas URSEA y referentes y necesita decisión explícita del usuario. Logo Width=1.40in vs base 1.45in: diferencia mínima, dejada para una iter siguiente si se confirma.
- **Acción:** 4 reemplazos en `Precios Unitarios Ex Planta - detalle.rdl` (replace_all, cada uno 2 ocurrencias = Resumen + Detalle):
  - `<Top>0.40in</Top><Left>0in</Left><Height>0.78in</Height>` → `<Top>0.40in</Top><Left>0in</Left><Height>0.53in</Height>` (rect del banner)
  - `<FontSize>15pt</FontSize>` → `<FontSize>12pt</FontSize>` (subtítulo)
  - `<Top>0.32in</Top><Left>0in</Left><Height>0.25in</Height>` → `<Top>0.32in</Top><Left>0in</Left><Height>0.18in</Height>` (subtítulo)
  - `<Top>0.09in</Top>` → `<Top>0.06in</Top>` (logo, único en imgBodyLogo*)
- **Evidencia:** `XML_OK`. Cada reemplazo se aplicó 2 veces = ambos banners.
- **Próximo paso:** Usuario publica y valida que el banner se ve compacto (≈0.53in alto) y el subtítulo más chico que el título. Pendientes de decisión usuario: (a) bajar Width del banner a 20.5in como base — implica reposicionar nota URSEA y referentes; (b) ajustar logo Width 1.40→1.45in.

### 2026-05-05 — Iteración 28: Reordenar columna "Precio Ex Planta (PEP)" raw en tablixes Resumen

- **Pregunta/problema:** Cognos renderiza la columna *raw* "Precio Ex Planta (PEP)" entre "PEP sin flete secundario" y "Factor de ajuste". Power BI la muestra al final, después de PPI n-1 y PPI n-2. Usuario reporta el desfase contra el screenshot de Cognos.
- **Diagnóstico:** Extraje el orden de columnas de los 6 tablixes vía regex sobre `IsColumnAllowed`. Resultado: `tablixSummaryUSD` (14 cols, PEP en pos 14) y `tablixSummaryLocalMain` (10 cols, PEP en pos 10) tenían PEP al final. Los 2 tablixes Detail (`tablixDetailUSD`, `tablixDetailLocal`) ya lo tenían bien (PEP en pos 24, entre Fideicomiso y Factor — visible para LiquidosBase como PEPSinFlete→PEP→Factor). Los 2 tablixes legacy TM1 (`tablixSummaryUSDTM1`, `tablixSummaryLocal`) no tienen PEP raw, por lo que no aplican.
- **Decisión:** Mover el bloque PEP de la última posición a la posición justo después de PEPSinFlete en los 2 tablixes Resumen modernos. Para hacerlo de forma segura escribí `tools/scripts/move_pep_column.py` que (a) extrae cada bloque tablix; (b) mueve el último `<TablixColumn>` a la posición destino; (c) localiza el `<TablixMember>` cuya expresión Hidden referencia la key "PEP" y lo reinserta después del de "PEPSinFlete"; (d) hace lo mismo para las celdas del header row y data row. Splitting balanced top-level por nombre de tag para evitar romper estructuras anidadas.
- **Acción:** Ejecutado `python tools/scripts/move_pep_column.py`. Resultado: `tablixSummaryUSD: total_cols=22, leading=8, PEPSinFlete at full pos 13, moving last col to pos 14`. `tablixSummaryLocalMain: total_cols=11, leading=1, PEPSinFlete at full pos 5, moving last col to pos 6`.
- **Evidencia:** `XML_OK`. Nuevo orden de columnas data — `tablixSummaryUSD`: PVP, PIT, PEPImp, TasaInflamable, PEPSinFlete, **PEP**, IMESI, TasaPrim, FUDAEE, Factor, Ursea, MontoDiferencial, PPIN1, PPIN2. `tablixSummaryLocalMain`: PVP, PIT, PEPImp, PEPSinFlete, **PEP**, Factor, Ursea, MontoDiferencial, PPIN1, PPIN2.
- **Próximo paso:** Usuario publica y valida con Gasolina Super 95 / 2025 / Resumen: orden visible PVP → PIT → PEPImp → PEPSinFlete → **PEP** → Factor → Ursea → PPIN1 → PPIN2 (con MontoDiferencial oculto por Count=0). Para 2022 / Resumen: PVP → PIT → PEPImp → PEPSinFlete → **PEP** → Factor → Ursea (sin PPI, igual a Cognos screenshot 5).

### 2026-05-05 — Iteración 29: Banner Width 21.80→20.50in (igual al base) + logo Width 1.40→1.45in

- **Pregunta/problema:** Decisiones diferidas de iter 27 — usuario confirma "igual al base" para Width del banner y del logo.
- **Diagnóstico:** Base tiene `rectHeader.Width=20.5in`, `imgLogo.Width=1.45in`, `imgLogo.Left=18.85in` (logo right edge=20.30in, dejando 0.20in al borde derecho del rect). Detalle tenía `rectBodyHeader*.Width=21.80in` (heredado de iter 16 = ancho de tabla más larga visible). Notas URSEA (`txtNotaResumen`/`txtNotaDetalle`) ya tenían `Left=0.05in, Width=20.50in, TextAlign=Right` (iter 22) — borde derecho del texto = 20.55in. Con banner=20.50in, el borde del texto sobresale 0.05in del banner: irrelevante visualmente, no se reposiciona.
- **Decisión:** Aplicar literal "igual al base": Width banner 21.80→20.50in, logo Left 20.40→18.85in, logo Width 1.40→1.45in. Notas y referentes se dejan donde están (la diferencia de 0.05in es despreciable).
- **Acción:** 3 reemplazos en `Precios Unitarios Ex Planta - detalle.rdl`:
  - `21.80in` → `20.50in` (replace_all, 6 ocurrencias = 2 rect + 2 título + 2 subtítulo)
  - `<Top>0.06in</Top><Left>20.40in</Left><Height>0.42in</Height><Width>1.40in</Width>` → `<Top>0.06in</Top><Left>18.85in</Left><Height>0.42in</Height><Width>1.45in</Width>` (replace_all, 2 ocurrencias = ambos logos)
- **Evidencia:** `XML_OK`. `21.80in` = 0 ocurrencias; `20.50in` = 8 (banner ×6 + nota Width ×2); `20.40in` = 0; `18.85in` = 2; `<Width>1.45in</Width>` = 2.
- **Próximo paso:** Usuario publica y valida que (a) el banner ahora coincide con el ancho del base; (b) el logo se ve a la derecha del banner como en el base; (c) la nota URSEA y referentes siguen visibles y alineados sin romper. Si el banner queda visualmente "corto" para gasolinas anchas (tabla=21.80in, banner=20.50in), evaluar volver a iter 16 (banner=21.80) o aceptar la diferencia.

### 2026-05-05 — Iteración 30: Corner cell oculto sin datos + bordes solo derecho/inferior + subtítulo más cerca del título

- **Pregunta/problema:** Tres ajustes reportados por el usuario:
  1. Cuando no hay datos, sigue apareciendo un pequeño recuadro "USD/m3" en la esquina superior izquierda del área de datos (corner cell). En Cognos no aparece.
  2. La esquina superior izquierda con la unidad debe quedar **sin borde superior ni izquierdo** (solo derecho e inferior, para que se integre con la fila/columna que sigue sin parecer un cuadro cerrado).
  3. Los textos del banner (título + subtítulo) están demasiado separados.
- **Diagnóstico:**
  1. Los demás headers de columna se ocultan via `Count(...) = 0` en su `Visibility.Hidden`. El corner cell no tenía esa lógica → siempre se renderiza. Mapeo dataset por tablix: `tablixSummaryUSD`/`tablixSummaryLocalMain` → `dsResumen`; `tablixSummaryUSDTM1`/`tablixSummaryLocal` → `dsResumenLocal`; `tablixDetailUSD`/`tablixDetailLocal` → `dsDetalle`.
  2. El corner cell (post-iter 26) tenía `<Border><Color>Gray</Color><Style>Solid</Style></Border>` (4 lados). Reemplazar por `<Border><Style>None</Style></Border>` + `<BottomBorder>` + `<RightBorder>` Solid Gray.
  3. Title `Top=0.05in Height=0.25in` (bottom=0.30in), Subtitle `Top=0.32in Height=0.18in` (gap=0.02in en layout). El visual gap se ve más amplio por padding de línea. Acercando subtitle a `Top=0.27in` se solapa parcialmente con el título pero el text rendering los junta visualmente.
- **Decisión:** Aplicar las 3 correcciones en una iteración. Para minimizar riesgo y dejar trazable, escribí `tools/scripts/fix_corner_and_header.py` que (a) inserta `<Visibility><Hidden>=CountRows("ds...") = 0</Hidden></Visibility>` en cada uno de los 6 corner cells; (b) reemplaza el border full-Solid por Border None + RightBorder + BottomBorder; (c) cambia subtitle Top 0.32→0.27in en ambos banners.
- **Acción:** Ejecutado `python tools/scripts/fix_corner_and_header.py`. 6 corner cells parchados (uno por uno con su dataset correspondiente). Borders y Top de subtítulos reemplazados via string-match exacto.
- **Evidencia:** `XML_OK`. Conteos: `<Visibility><Hidden>=CountRows("ds`: 7 (6 nuevos + 1 pre-existente de `txtEmptyState`). Old corner border: 0 ocurrencias. Nuevo border (Border None + BottomBorder + RightBorder): 6 ocurrencias. Subtítulo Top=0.27in: 2; Top=0.32in: 0 (con Height=0.18in del subtítulo).
- **Próximo paso:** Usuario publica y valida (a) Asfalto AC-30 / 2022 / USD/m3 / Detalle: NO aparece el recuadro "USD/m3" en la esquina superior izquierda; (b) Gasolina Super 95 con datos: corner cell sin border superior ni izquierdo, integrado a la grilla; (c) banner: título y subtítulo más cerca, gap visual reducido. Si el subtítulo queda demasiado cerca del título (overlap visual), bajar Top a 0.28-0.29in en una iter siguiente.

### 2026-05-05 — Iteración 31: Texto del banner centrado en área no-logo (simetría visual con el logo)

- **Pregunta/problema:** Usuario reporta que título y subtítulo del banner no se ven centrados respecto al logo de ANCAP. Pide simetría.
- **Diagnóstico:** Banner Width=20.50in, logo en `Left=18.85in, Width=1.45in` (right edge=20.30in). Título y subtítulo con `Left=0in, Width=20.50in, TextAlign=Center` → text center en x=10.25in (= centro geométrico del banner). Logo ocupa el sector derecho 18.85–20.30. Visualmente: espacio libre 8.75in a izquierda del texto vs 7.10in entre texto y logo → texto "desplazado a la derecha" relativo al área no ocupada por el logo. El base RDL tiene la misma asimetría (text Width=19.9in, banner=20.5in, logo en Left=18.85), pero el usuario pide centrar respecto al logo, no al banner completo.
- **Decisión:** Centrar texto en el área entre banner.Left=0 y logo.Left=18.85. Cambiar `txtBodyTitulo*.Width` y `txtBodySubtitulo*.Width` de 20.50in a 18.85in (Left=0 se mantiene). Nuevo text center = 9.425in. El espacio libre a izquierda y derecha del texto queda simétrico, con logo aparte en el extremo derecho del banner.
- **Acción:** 2 reemplazos en `Precios Unitarios Ex Planta - detalle.rdl` (vía Python para evitar conflictos con el linter):
  - Título: `<Top>0.05in</Top><Left>0in</Left><Height>0.25in</Height><Width>20.50in</Width>` → `...<Width>18.85in</Width>` (2 ocurrencias = ambos banners).
  - Subtítulo: `<Top>0.27in</Top><Left>0in</Left><Height>0.18in</Height><Width>20.50in</Width>` → `...<Width>18.85in</Width>` (2 ocurrencias).
- **Evidencia:** `XML_OK`. Title patches: 2, Subtitle patches: 2.
- **Próximo paso:** Usuario publica y valida que el texto se vea visualmente equilibrado respecto al logo de ANCAP. Si queda demasiado a la izquierda, evaluar Opción 2 (Left=1.65in, Width=17.20in → mirror padding = simetría alrededor del centro del banner).

### 2026-05-05 — Iteración 32: Banner más alto + tipografías más grandes + textos más separados

- **Pregunta/problema:** Tras iter 27 (banner igual al base, alto 0.53in, título 16pt, subtítulo 12pt) y iter 30 (subtítulo más cerca del título, Top=0.27in), el usuario pide aumentar tamaño y separar título y subtítulo.
- **Decisión:** Subir altura del banner a 0.70in, título 16→18pt, subtítulo 12→14pt, subtítulo Top 0.27→0.40in (más separado), título Height 0.25→0.30in y subtítulo Height 0.18→0.22in (para acomodar fonts más grandes), recentrar logo verticalmente Top 0.06→0.14in (= (0.70-0.42)/2).
- **Acción:** 6 reemplazos vía Python (todas con count=2, una por banner Resumen/Detalle):
  - `<FontSize>16pt</FontSize>` → `<FontSize>18pt</FontSize>` (título)
  - `<FontSize>12pt</FontSize>` → `<FontSize>14pt</FontSize>` (subtítulo)
  - `<Top>0.40in</Top><Left>0in</Left><Height>0.53in</Height>` → `...<Height>0.70in</Height>` (rect)
  - `<Top>0.05in</Top><Left>0in</Left><Height>0.25in</Height>` → `...<Height>0.30in</Height>` (título)
  - `<Top>0.27in</Top><Left>0in</Left><Height>0.18in</Height>` → `<Top>0.40in</Top>...<Height>0.22in</Height>` (subtítulo)
  - `<Top>0.06in</Top><Left>18.85in</Left>` → `<Top>0.14in</Top><Left>18.85in</Left>` (logo)
- **Evidencia:** `XML_OK`. Cada patrón aplicado 2 veces. Layout vertical resultante (interior del banner, Height=0.70in): título 0.05→0.35, gap 0.05, subtítulo 0.40→0.62, logo 0.14→0.56. El logo cubre el alto vertical del título y subtítulo.
- **Próximo paso:** Usuario publica y valida que el banner se vea más alto, con tipografías más grandes y mejor separación entre título y subtítulo. Ajustes finos posibles si queda muy alto o muy chico el subtítulo.

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

**Fecha:** 2026-05-05. **Aprobado por:** usuario.

### Lecciones promovidas

| Lección | Destino | Artefacto |
|---|---|---|
| Cognos `case when ... then ...` = display label, no nombre crudo. En DAX usar el nombre crudo del modelo; en headers RDL usar el display label de Cognos | Capa 1 — Reglas universales | `skills/base/SKILL.md` |
| `ColSpan` en RDL 2016 sólo es válido en header rows de group column hierarchies; no en filas estáticas/footer | Capa 1 — Reglas universales | `skills/base/SKILL.md` |
| DAX `EVALUATE` con `@param IN { ... }` inline no funciona — mover decisión a función VB.NET en `<Code>` | Capa 1 — Reglas universales | `skills/base/SKILL.md` |
| `behavior-matrix.md` inferida en sesión previa no es fuente primaria; validar contra XML spec antes de usarla | Capa 2 — Refuerzo playbook | `skills/playbooks/playbook-matriz-comportamiento/SKILL.md` |
| `IsColumnAllowed`: whitelist explícita por familia, no `Return True` genérico | Capa 2 — Refuerzo playbook | `skills/playbooks/playbook-matriz-comportamiento/SKILL.md` |
| Validar orden de columnas en TODOS los tablixes (Resumen + Detalle, USD + Local), no solo el visible | Capa 2 — Refuerzo playbook | `skills/playbooks/playbook-matriz-comportamiento/SKILL.md` |
| Corner cell debe ocultarse cuando no hay datos: `Visibility.Hidden = CountRows("ds...") = 0` | Capa 2b — Refuerzo componente | `skills/components/component-corner-cell/SKILL.md` |
| `<NoRowsMessage>` y textbox standalone tipo `txtEmptyState` no deben coexistir — elegir uno | Capa 2b — Refuerzo componente | `skills/components/component-tablix-valores-mensuales/SKILL.md` |
| Push-down: textos al pie posicionados con `Top` apenas debajo del bottom de diseño del tablix se adhieren a la última fila renderizada | Capa 2b — Refuerzo componente | `skills/components/component-tablix-valores-mensuales/SKILL.md` |
| Banner Width = ancho del reporte base del cliente (no ancho de tabla más larga del reporte) | Capa 2b — Refuerzo componente | `skills/components/component-page-header/SKILL.md` |
| Texto del banner: `Width = logo.Left` para centrar en el área no-logo (simetría visual con el logo) | Capa 2b — Refuerzo componente | `skills/components/component-page-header/SKILL.md` |
| Centrado dinámico de tablix con ancho variable por familia: spacer columns con `Visibility.Hidden` por key | Componente nuevo | `skills/components/component-centrado-dinamico-tablix/SKILL.md` |

### Lecciones locales (no promovidas)

- Iter 6–16: ciclo de tuning del banner width terminó siendo desviación; la regla destilada (banner = ancho base) está promovida.
- Iter 22: posición de nota URSEA — ubicación específica del reporte.
- Iter 27, 32: tuning visual fino del banner (alturas y fontsize concretos) — los valores son específicos, la metodología ya está en page-header.
- Iter 12, 9–11: spacer fijo de centrado fallido reemplazado por la mecánica dinámica de iter 19–21 — la solución estable está promovida en `component-centrado-dinamico-tablix`.

### Cambios estructurales de esta retro

- Nuevo componente `skills/components/component-centrado-dinamico-tablix` agregado al catálogo.
- `skills/base/SKILL.md` ahora documenta 3 nuevas reglas universales (display labels Cognos, ColSpan en RDL 2016, DAX `@param IN` inline).
- `skills/playbooks/playbook-matriz-comportamiento/SKILL.md` reforzado con 3 reglas duras adicionales (matriz inferida no es fuente, whitelist explícita, validar orden por tablix).
- `skills/components/component-corner-cell`, `component-page-header` y `component-tablix-valores-mensuales` con secciones nuevas y errores comunes ampliados.
