# Report Builder / RDL Troubleshooting Seed

Documento vivo para capturar errores reales encontrados al construir reportes paginados `.rdl` en Report Builder / Power BI Report Builder, con foco en reutilizar estas lecciones como skill futura.

## Uso sugerido

- Registrar el error exacto como lo muestra Report Builder.
- Anotar la causa raíz confirmada, no una hipótesis.
- Dejar la corrección aplicada y la regla preventiva.
- Priorizar problemas de RDL, DAX embebido, parámetros, layout, encoding y ejecución local.

## Casos registrados

### 1. Report item names duplicados

- Problema:
  `More than one report item in the report has the name 'rectHeader'. Report item names must be unique within a report.`
- Síntoma:
  El reporte abre, pero falla al ejecutar o procesar localmente.
- Causa raíz:
  El `.rdl` detalle heredó un `PageHeader` del reporte base y además se agregó un encabezado nuevo dentro del `Body`. Eso duplicó nombres como `rectHeader`, `txtTitulo` e `imgLogo`.
- Corrección aplicada:
  Se renombraron los elementos del encabezado agregado en `Body` (`rectBodyHeader`, `txtBodyTitulo`, `imgBodyLogo`) y además se eliminó el `PageHeader` heredado en la regeneración del `.rdl`.
- Regla preventiva:
  Si se usa un `.rdl` existente como base, revisar siempre `Body`, `PageHeader`, `PageFooter` y cualquier bloque heredado antes de agregar nuevos report items.
- Archivos tocados:
  `scripts/build_precios_unitarios_detalle_rdl.ps1`
  `tests/validate_precios_unitarios_ex_planta_detalle.ps1`
- Estado:
  Corregido.

### 2. Layout de parámetros con menos celdas que parámetros

- Problema:
  `The parameter panel layout for this report contains more parameters than total cells available.`
- Síntoma:
  El reporte carga, pero falla antes de mostrar prompts o al intentar renderizar el panel de parámetros.
- Causa raíz:
  El reporte tenía 4 parámetros (`pAnio`, `pProducto`, `pUnidad`, `pVista`) pero `ReportParametersLayout` declaraba solo 3 celdas. Aunque `pVista` era oculto, el motor local igual validó el total contra la grilla.
- Corrección aplicada:
  Se actualizó `ReportParametersLayout` a 4 columnas / 4 celdas, incluyendo `pVista`.
- Regla preventiva:
  Verificar siempre que la grilla de `ReportParametersLayout` tenga al menos tantas celdas declaradas como parámetros reales del reporte.
- Archivos tocados:
  `scripts/build_precios_unitarios_detalle_rdl.ps1`
  `tests/validate_precios_unitarios_ex_planta_detalle.ps1`
- Estado:
  Corregido.

### 3. Width inválido por coma decimal

- Problema:
  `The value of the Width property for the report section 'ReportSection0' is "2265.05in", which is out of range. It must be between 0in and 455in.`
- Síntoma:
  El reporte valida estructuralmente, pero falla al ejecutar con un ancho absurdo.
- Causa raíz:
  El script generador serializaba algunos `Width` usando cultura local, produciendo valores como `22,65in`. El motor del `.rdl` interpretó esos valores de forma incorrecta.
- Corrección aplicada:
  Se cambió la serialización de widths a cultura invariante, generando `17.65in`, `5.65in`, `22.65in`, etc.
- Regla preventiva:
  Cualquier medida numérica en RDL (`Width`, `Height`, `Top`, `Left`, etc.) debe serializarse con punto decimal y cultura invariante.
- Archivos tocados:
  `scripts/build_precios_unitarios_detalle_rdl.ps1`
  `tests/validate_precios_unitarios_ex_planta_detalle.ps1`
- Estado:
  Corregido.

### 4. Texto mal codificado en queries y prompts

- Problema:
  `Column 'AÃ±os' in table 'Precios_ExPLanta_2_TM1' cannot be found or may not be used in this expression.`
- Síntoma:
  Fallan datasets o filtros con columnas / conceptos que sí existen en el modelo, pero aparecen con texto corrupto como `AÃ±os`, `PÃºblico`, `BonificaciÃ³n`, etc.
- Causa raíz:
  El generador estaba emitiendo cadenas con mojibake por problemas de encoding en los fragmentos DAX, prompts y labels del `.rdl`.
- Corrección aplicada:
  Se agregó una normalización de texto generada para reparar mojibake y reemplazar explícitamente etiquetas críticas (`Años`, `Año Base`, `Precio Público`, `Bonificación`, `Cotización`, `Compensación`, `distribución`, `según`, etc.).
- Regla preventiva:
  Si el reporte contiene acentos o `ñ`, validar siempre el XML final buscando mojibake (`Ã`, `Â`, `�`) antes de probar la ejecución. En DAX embebido, los nombres deben coincidir exactamente con el modelo semántico.
- Archivos tocados:
  `scripts/build_precios_unitarios_detalle_rdl.ps1`
  `tests/validate_precios_unitarios_ex_planta_detalle.ps1`
- Estado:
  Corregido.

### 5. ADDCOLUMNS intenta agregar una columna ya existente

- Problema:
  `Function 'ADDCOLUMNS' cannot add column [Producto] since it already exists.`
- Síntoma:
  Falla la ejecución de datasets como `dsResumen` o `dsDetalle`.
- Causa raíz:
  La query base usaba `SUMMARIZECOLUMNS(..., 'Precios_Ex_Planta'[Producto], ...)` y luego otro `ADDCOLUMNS(..., "Producto", ...)`, lo que genera un conflicto por nombre duplicado.
- Corrección aplicada:
  Se renombró la columna derivada a `ProductoNormalizado` en `ADDCOLUMNS` y recién luego se proyectó como `"Producto", [ProductoNormalizado]` en `SELECTCOLUMNS`.
- Regla preventiva:
  En DAX, no agregar en `ADDCOLUMNS` una columna con el mismo nombre de una ya presente en la tabla de entrada. Si hace falta transformar un campo existente, usar un nombre intermedio y renombrarlo después.
- Archivos tocados:
  `scripts/build_precios_unitarios_detalle_rdl.ps1`
- Estado:
  Corregido.

### 6. Pestanas internas resueltas con drillthrough al mismo reporte

- Problema:
  La pestana `Detalle` no cambia de vista en `Report Preview` y el reporte sigue mostrando la tabla de `Resumen`.
- Sintoma:
  En Cognos la pestana cambia entre dos tablas distintas, pero en Power BI Report Builder la vista previa local no navega al hacer clic en la pestana interna.
- Causa raiz:
  El `.rdl` estaba implementando las pestanas internas con `Drillthrough` al mismo reporte, pasando `pVista=Resumen` o `pVista=Detalle`. Ese patron depende de reabrir el reporte y no funciona de forma confiable en `Report Preview`.
- Correccion aplicada:
  Se reemplazo la navegacion interna por bookmarks dentro del mismo `.rdl`, separando `Resumen` y `Detalle` en secciones/paginas distintas del cuerpo y agregando tabs propias en cada una.
- Regla preventiva:
  Si un reporte necesita tabs internas que funcionen tambien en `Report Preview`, no usar `Drillthrough` al mismo `.rdl`. Usar bookmarks internos y secciones/paginas separadas dentro del reporte.
- Archivos tocados:
  `tools/scripts/build_precios_unitarios_detalle_rdl.ps1`
  `tools/validation/validate_precios_unitarios_ex_planta_detalle.ps1`
- Estado:
  Corregido.

## Reglas transversales para futuros reportes

- Validar XML del `.rdl` antes de abrirlo en Report Builder.
- Validar nombres únicos de report items (`Textbox`, `Rectangle`, `Image`, `Tablix`, etc.).
- Validar `ReportParametersLayout` contra la cantidad total de parámetros.
- Validar `Width` con regex y rango máximo permitido.
- Validar ausencia de mojibake en el XML final.
- Si se genera RDL por script, no leer y escribir el mismo archivo en paralelo durante la validación.
- En queries DAX embebidas, evitar renombrar columnas sobre sí mismas dentro de `ADDCOLUMNS`.

## Próximo uso como skill

Cuando este documento madure, convertirlo en una skill formal con:

- frontmatter `name` y `description`
- sección `When to Use`
- checklist de validaciones pre-render
- catálogo de errores frecuentes
- patrones de corrección para RDL + DAX embebido
