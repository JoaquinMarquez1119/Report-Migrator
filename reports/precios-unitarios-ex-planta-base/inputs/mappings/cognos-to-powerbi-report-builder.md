# Mapeo Cognos -> Power BI Report Builder

## 1. Hallazgos clave

- El reporte de IBM Cognos parte del paquete/modelo `Datos Prioritarios`.
- Power BI Report Builder trabaja sobre archivos `.rdl` (Report Definition Language), que son XML.
- El reporte Cognos usa una mezcla de:
  - layout tabular para header/body/footer
  - prompts HTML incrustados dentro del body
  - JavaScript para defaults automáticos y para expandir/colapsar la descripción
  - una lista simple con agrupación por `Año` y `Mes`

## 2. Qué hay en el reporte Cognos actual

### Nombre del reporte

- `TC promedio mensual`

### Título visible

- `Tipo de Cambio Promedio SAP`

### Descripción visible

- `Promedio mensual del tipo de cambio dólares estadounidense vs pesos uruguayos promedio. Fuente SAP`

### Parámetros

- `Año Inicial`
- `Mes Inicial`
- `Año Final`
- `Mes Final`

### Defaults automáticos en Cognos

El prompt page de Cognos ejecuta JavaScript y completa:

- fecha desde = mes anterior del año anterior
- fecha hasta = mes anterior del año actual

Equivalencia práctica en RDL:

- `Año Inicial` = `Year(DateAdd("m", -13, Today()))`
- `Mes Inicial` = `Month(DateAdd("m", -13, Today()))`
- `Año Final` = `Year(DateAdd("m", -1, Today()))`
- `Mes Final` = `Month(DateAdd("m", -1, Today()))`

### Dataset principal en Cognos

Query: `TC Promedio`

Campos seleccionados:

- `Unidades`
- `Productos_ExPlanta`
- `Mercados`
- `Periodo_Diario`
- `Medidas_ExPlanta`
- `Cotización Promedio` = total de `[Valor]`
- `Periodo_Mensual`
- `Mes` = mapeo Ene..Dic -> 1..12
- `Año`
- `Fecha` = último día del mes armado desde `Año` + `Mes`
- `Descripción de miembro` = `Periodo_Mensual`

Filtros aplicados:

- `Unidades = 'N/A'`
- `Productos_ExPlanta = 'N/A'`
- `Mercados = 'N/A'`
- `Periodo_Diario = 'Valor Mensual'`
- `Medidas_ExPlanta = 'Cotización Promedio'`
- `Fecha between make_timestamp(Año Inicial, Mes Inicial, 01) and last_of_month(make_timestamp(Año Final, Mes Final, 01))`

### Datasets auxiliares en Cognos

- Query `Año`
  - campo `Años`
- Query `Mes`
  - campo numérico `Mes`
  - campo descriptivo `Periodo_Mensual`
- Query `Descripción reporte`
  - texto fijo

### Layout

- Encabezado azul con línea inferior amarilla
- Título a la izquierda
- logo ANCAP a la derecha
- link `¿Qué muestra este reporte?`
- bloque de descripción expandible
- cuatro prompts de filtro en dos filas
- botón `Filtrar`
- tabla simple, centrada, con 3 columnas:
  - Año
  - Mes
  - Cotización Promedio
- pie con fecha, número de página y hora
- orientación landscape

## 3. Formato nativo de Power BI Report Builder

Power BI Report Builder usa `.rdl`, es decir, un XML de definición de reporte paginado. El `.rdl` describe:

- data sources
- datasets
- parámetros
- layout
- expresiones
- page header/footer

Fuentes oficiales:

- [RDL en Microsoft Learn](https://learn.microsoft.com/es-es/power-bi/paginated-reports/report-definition-language)
- [Power BI Report Builder](https://learn.microsoft.com/en-us/power-bi/paginated-reports/report-builder-power-bi)
- [Conectar a un Power BI semantic model](https://learn.microsoft.com/en-us/power-bi/paginated-reports/report-builder-shared-datasets)
- [Parámetros en Report Builder](https://learn.microsoft.com/en-us/power-bi/paginated-reports/parameters/report-builder-parameters)
- [Parámetros DAX para semantic model](https://learn.microsoft.com/en-us/power-bi/paginated-reports/parameters/define-parameters-in-the-dax-query-designer-for-analysis-services)

## 4. Mapeo técnico Cognos -> RDL

| Cognos | Power BI Report Builder |
|---|---|
| `report` XML | archivo `.rdl` |
| `query` | `DataSet` |
| `modelPath` | `Power BI Semantic Model Connection` al dataset `Datos Prioritarios` |
| `selectValue parameter=...` | `ReportParameter` con `AvailableValues` desde dataset |
| `promptButton type="finish"` | botón nativo `View Report` del visor |
| `pageHeader` | `PageHeader` |
| `pageFooter` | `PageFooter` |
| `list` | `Tablix` |
| `listGroups` | `Row Groups` / sort del tablix |
| `textItem` | `Textbox` |
| `image` | `Image` |
| CSS embebido | propiedades de estilo RDL |
| HTML + JavaScript | no tiene equivalencia 1:1 en paginated report estándar |

## 5. Qué sí se puede replicar exacto o casi exacto

- título
- header corporativo
- orientación landscape
- tabla de datos
- bordes, alineaciones, tipografías, colores
- footer con fecha / página / hora
- parámetros equivalentes
- defaults dinámicos
- conexión al semantic model `Datos Prioritarios`

## 6. Qué no se puede replicar 1:1 de forma nativa

### Prompts dentro del cuerpo del reporte

En Cognos los combos de año/mes están dibujados dentro del body del reporte. En Report Builder, el patrón nativo es que los parámetros aparezcan en el panel superior del visor, no incrustados como controles HTML dentro del canvas del reporte.

### JavaScript embebido

La lógica:

- mostrar/ocultar descripción
- autocompletar parámetros vía script
- autoejecutar `Filtrar`

no se traslada de forma literal al `.rdl`.

### Texto del toggle

El cambio entre:

- `¿Qué muestra este reporte?`
- `Ocultar descripción del reporte`

no tiene un clon nativo directo. Se puede aproximar con visibilidad alternable del textbox o con una versión fija de la descripción.

## 7. Propuesta de implementación en Power BI Report Builder

### Opción recomendada: equivalencia funcional

- usar parámetros nativos arriba del reporte:
  - `Año Inicial`
  - `Mes Inicial`
  - `Año Final`
  - `Mes Final`
- usar defaults dinámicos
- dibujar en el body solo:
  - título
  - descripción fija o colapsable aproximada
  - tablix
- mantener header/footer y estilo visual del reporte

### Opción de fidelidad visual para PDF/impresión

- dibujar una franja superior dentro del body para parecerse al Cognos
- dejar la descripción fija visible
- usar el panel de parámetros solo para ejecución
- optimizar el `.rdl` para exportación PDF y Excel

## 8. Borrador de datasets necesarios en Report Builder

### Dataset `dsAnios`

Objetivo:

- poblar available values de `Año Inicial` y `Año Final`

Campos esperados:

- `Años`

### Dataset `dsMeses`

Objetivo:

- poblar available values de `Mes Inicial` y `Mes Final`

Campos esperados:

- `Mes`
- `Periodo_Mensual`

### Dataset `dsDescripcion`

Objetivo:

- mostrar la descripción del reporte

Campos esperados:

- `Descripcion`

### Dataset `dsTCPromedio`

Objetivo:

- devolver:
  - `Año`
  - `Periodo_Mensual`
  - `Mes`
  - `CotizacionPromedio`

Filtros esperados:

- `Unidades = N/A`
- `Productos_ExPlanta = N/A`
- `Mercados = N/A`
- `Periodo_Diario = Valor Mensual`
- `Medidas_ExPlanta = Cotización Promedio`
- rango año/mes según parámetros

## 9. Preguntas mínimas para terminar la réplica exacta

1. ¿Querés que priorice equivalencia funcional nativa de paginated reports, o una réplica visual lo más parecida posible aunque los filtros queden en el panel superior y no dentro del body?
2. ¿Tenés el logo de ANCAP en un archivo de imagen para incrustarlo en el `.rdl`, o querés que lo deje como placeholder?
3. ¿Querés que el reporte quede conectado directo al semantic model `Datos Prioritarios` en Power BI Service, o preferís que primero te deje el `.rdl` armado con placeholders de conexión?
4. ¿Podés confirmarme los nombres exactos de la tabla y columnas en el semantic model? Del XML infiero:
   - tabla: `Precios_ExPLanta_TM1`
   - columnas: `Años`, `Periodo_Mensual`, `Valor`, `Unidades`, `Productos_ExPlanta`, `Mercados`, `Periodo_Diario`, `Medidas_ExPlanta`
5. ¿Querés que la descripción quede siempre visible en la versión Report Builder, o querés que intente una aproximación con toggle de visibilidad?

## 10. Siguiente paso recomendado

Con esas confirmaciones, el siguiente entregable debería ser:

- un `.rdl` base funcional
- datasets y parámetros ya definidos
- layout replicado
- tablix con formato final
- instrucciones de publicación al workspace del servicio Power BI

## 11. Errores RDL detectados al convertir manualmente

Estos puntos conviene tenerlos presentes a futuro cuando se arme un `.rdl` a mano:

- `Cursor` no es un elemento válido dentro de `Style` en RDL 2016.
- `BorderStyle` no es un elemento válido dentro de `Style` en RDL 2016.
- `BorderWidth` no es un elemento válido dentro de `Style` en RDL 2016.
- Para bordes por lado hay que usar nodos como `TopBorder`, `BottomBorder`, `LeftBorder`, `RightBorder`.
- Un `.rdl` puede ser XML bien formado y aun así fallar en deserialización si no respeta el esquema exacto de Report Builder.
- Si el reporte define parámetros, conviene declarar `ReportParametersLayout` para que el panel de parámetros tenga exactamente una celda por parámetro.
