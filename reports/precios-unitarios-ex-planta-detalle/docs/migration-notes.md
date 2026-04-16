# Guia de migracion exacta de IBM Cognos Analytics a Power BI Report Builder

## Objetivo

Esta guia resume lo aprendido en las migraciones trabajadas hasta ahora y deja una forma de trabajo repetible para replicar reportes de IBM Cognos Analytics en Microsoft Power BI Report Builder con la mayor fidelidad posible.

Aplica especialmente a reportes complejos con:

- multiples consultas
- prompts / parametros
- layouts mixtos
- crosstabs
- drill-through
- expresiones de Cognos
- origen TM1 / cubos migrados a tablas materializadas

## Conclusion principal

La mejor forma de mapear un reporte exacto de Cognos a Power BI Report Builder no es intentar convertirlo automaticamente ni traducir el XML 1 a 1.

La estrategia correcta es hacer una migracion por capas:

1. Capa funcional: que muestra el reporte, con que parametros y con que reglas.
2. Capa de datos: que consultas usa, como se filtran, como se agrupan y como se ordenan.
3. Capa semantica: como se mapean los miembros, propiedades y expresiones de Cognos al modelo semantico de Power BI.
4. Capa visual: header, body, footer, tipografias, bordes, colores, imagenes y alineaciones.
5. Capa de validacion: comparar salida esperada vs salida real con casos de prueba concretos.

En otras palabras: primero se reconstruye la logica del reporte, despues se implementa en RDL.

## Lo mas importante que aprendimos

### 1. El reporte exacto depende mas del analisis previo que del RDL

En Cognos, gran parte de la logica real no esta solo en el layout. Tambien vive en:

- queries
- data items calculados
- member properties
- prompt pages
- slicers
- detail filters
- conditional render
- HTML embebido
- JavaScript
- drill definitions

Si no se reconstruye eso antes de tocar el `.rdl`, la replica visual puede verse parecida pero devolver numeros incorrectos.

### 2. El mapeo de un cubo Cognos/TM1 a Power BI casi nunca es 1 a 1

Aunque la metadata venga de TM1 y se migre a Power BI, el semantic model suele terminar materializado en tablas SQL o en tablas derivadas del modelo.

Eso implica que hay que reconstruir equivalencias para:

- jerarquias
- captions
- member properties
- miembros especiales como `Base`, `Año Base`, `S1`, `T1`, etc.
- medidas
- propiedades como `Mes Numero`, `Numero`, `Cantidad dias`

No conviene asumir que un nombre de campo en Cognos existe igual en Power BI.

### 3. Lo correcto es inventariar las consultas antes de construir

Para reportes complejos hay que documentar, para cada consulta:

- nombre de la query en Cognos
- tipo de query: principal, parametro, descripcion, lookup, drill, soporte
- origen
- columnas devueltas
- expresiones calculadas
- filtros
- orden
- dependencias con parametros
- si alimenta layout, prompt, drill o validaciones

Sin ese inventario, es muy facil mezclar logica de una query con otra.

### 4. Power BI Report Builder replica muy bien la salida paginada, pero no todo el runtime de Cognos

Se puede replicar muy bien:

- layout final
- tablix / matrix / listas
- header / footer
- logos
- colores y bordes
- parametros nativos
- exportacion PDF / Excel
- expresiones VB de visibilidad, formato y texto

No se replica 1 a 1 de forma nativa:

- prompts HTML incrustados en el body
- JavaScript embebido
- comportamiento interactivo exacto de ciertos prompt pages
- toggles HTML con cambio de texto via script

Por eso, la meta realista es:

- exactitud funcional de datos
- fidelidad visual alta
- equivalencia razonable en interaccion

### 5. La validacion de datos tiene que hacerse con casos testigo

Nunca conviene validar "a ojo".

Hay que pedir o preparar:

- 5 a 10 celdas esperadas
- 2 o 3 cortes de parametros
- valores esperados por fila o columna
- capturas o PDF del reporte original

Esa comparacion es la forma mas rapida de detectar:

- agregaciones incorrectas
- duplicados
- filtros faltantes
- ordenamientos mal reconstruidos
- reglas de negocio omitidas

## Metodologia recomendada para una replica exacta

### Fase 1. Recoleccion

Juntar todo el material del reporte original.

### Fase 2. Desarme del Cognos

Extraer del `XML Spec` y del MDX/SQL:

- queries
- prompts
- data items
- propiedades de miembros
- filtros
- ordenamientos
- layout
- estilos
- drill-through

### Fase 3. Mapeo semantico

Armar una tabla de correspondencia entre Cognos y Power BI:

- query Cognos -> dataset RDL
- data item Cognos -> campo DAX / campo del semantic model
- member property -> columna derivada o calculada
- prompt -> report parameter
- list / crosstab -> tablix / matrix
- conditional render -> hidden / toggle / expression

### Fase 4. Construccion del RDL

Construir el reporte en este orden:

1. datasource
2. datasets de parametros
3. datasets auxiliares
4. dataset principal
5. parametros
6. layout base
7. tablix / matrix
8. expresiones visuales
9. header y footer
10. imagenes y detalle fino

### Fase 5. Validacion

Validar en este orden:

1. que abra el `.rdl`
2. que ejecute
3. que los parametros funcionen
4. que los datasets devuelvan filas
5. que los valores coincidan
6. que el layout coincida
7. que PDF / Excel no se rompan

## Estructura de directorio recomendada

Para un reporte complejo, esta es la mejor estructura de carpeta:

```text
NombreReporte/
  00_input_cognos/
    XML Spec.xml
    report.pdf
    screenshots/
      01_prompt.png
      02_reporte.png
      03_detalle.png
    mdx/
      q_principal.txt
      q_param_anio.txt
      q_param_mes.txt
      q_lookup_descripcion.txt
    assets/
      logo_ancap.jpg
      fuentes_o_recursos.txt

  01_analisis/
    inventario_consultas.md
    mapeo_campos_cognos_powerbi.md
    reglas_de_negocio.md
    layout_mapping.md
    dudas_y_decisiones.md
    validacion_esperada.md

  02_powerbi_report_builder/
    rdl/
      reporte_base.rdl
      reporte_v2.rdl
    dax/
      ds_principal.txt
      ds_param_anio.txt
      ds_param_mes.txt
    imagenes/
      logo_ancap.jpg

  03_validacion/
    casos_de_prueba.md
    esperado_vs_actual.md
    export_pdf/
    export_excel/

  99_aprendizajes/
    errores_rdl_y_soluciones.md
    notas_de_sesion.md
```

## Archivos y datos que necesito para mapear un reporte

### Minimo indispensable

- `XML Spec.xml`
- una captura del prompt page
- una captura del reporte final
- PDF exportado del reporte
- nombre del semantic model en Power BI Service
- logo o imagenes del reporte, si las usa

### Muy recomendable

- MDX nativo o SQL de cada consulta
- consultas de parametros
- consultas auxiliares
- detalle de drill-through
- lista de reglas de negocio conocidas
- ejemplos de valores esperados
- nombre exacto de tablas, columnas y medidas del semantic model
- capturas del panel de campos del modelo
- captura del diagrama de relaciones

### Para reportes complejos con muchas consultas

Ademas necesito una lista por consulta con este formato:

- nombre de la query
- para que se usa
- parametros que consume
- columnas que devuelve
- si tiene expresiones calculadas
- si tiene filtros
- si alimenta una tabla, un prompt, una descripcion o un drill

Si no viene esa lista, la puedo reconstruir desde el XML, pero lleva mas tiempo y tiene mas riesgo.

## Plantilla de inventario de consultas

Conviene crear un archivo `inventario_consultas.md` o una tabla como esta:

| Query Cognos | Tipo | Usa parametros | Devuelve | Uso en reporte | Observaciones |
|---|---|---|---|---|---|
| `Consulta1` | principal | `pAño` | producto, fecha, precio | matrix principal | contiene reglas de negocio |
| `pAño` | parametro | no | años | dropdown | excluye `Año Base` |
| `Descripción reporte` | auxiliar | no | descripcion | bloque de ayuda | texto fijo |

Para reportes grandes, esta tabla ahorra mucho retrabajo.

## Como mapear Cognos a Power BI Report Builder

### Mapeo conceptual

| Cognos | Report Builder |
|---|---|
| `query` | `DataSet` |
| `prompt` | `ReportParameter` |
| `prompt page` | panel superior de parametros |
| `list` | `Tablix` |
| `crosstab` | `Matrix` o `Tablix` |
| `singleton` | textbox / dataset de una fila |
| `pageHeader` | `PageHeader` |
| `pageFooter` | `PageFooter` |
| `HTMLItem` | aproximacion con textbox/toggle, no 1 a 1 |
| `reportExpression` | expresion VB en RDL o logica en dataset |
| `detailFilter` | filtro de dataset, grupo o tablix |
| `member caption/property` | columna derivada en DAX o dataset |

### Mapeo tecnico recomendado

1. Pasar primero la logica de negocio al dataset.
2. Dejar en el layout solo lo visual y lo minimo de expresiones.
3. Si Cognos usa propiedades de miembros, materializarlas como columnas derivadas.
4. Si el cubo tenia captions especiales, renombrar en el dataset para no repetir `IIF` en cada celda.
5. Si hay reglas historicas, dejarlas explicitadas en el dataset y documentadas.

## Reglas para reportes complejos

### 1. Separar queries por responsabilidad

No mezclar en un solo dataset lo que en Cognos son responsabilidades distintas.

Por ejemplo:

- dataset de parametros
- dataset principal
- dataset de descripciones
- dataset de lookups
- dataset de drill

### 2. Reconstruir member properties como columnas auxiliares

Si en Cognos una expresion usa:

- `Mes Número`
- `Número`
- `Cantidad dias`
- captions

en Power BI lo mejor es reconstruir eso como columnas derivadas en el dataset y no dejar la logica dispersa por el RDL.

### 3. Mantener una capa de reglas de negocio

Si el reporte tiene reglas como:

- excluir `Año Base`
- ocultar el mes actual
- forzar `0` desde cierta fecha
- renombrar productos

eso debe quedar documentado por separado en `reglas_de_negocio.md`.

### 4. No confiar en la primera agregacion que "parece" correcta

En semantic models y tablas materializadas es comun que:

- un `SUM` infle valores
- un `MAX` o `MIN` parezca arreglarlo pero no sea la logica real
- el problema sea realmente un filtro faltante o una duplicacion por granularidad

Siempre hay que comparar contra el Cognos.

## Errores y pitfalls de RDL que ya encontramos

Estos puntos conviene tenerlos anotados para futuras migraciones:

- `Cursor` no es valido dentro de `Style` en RDL 2016.
- `BorderStyle` no es valido como nodo directo dentro de `Style`.
- `BorderWidth` no es valido como nodo directo dentro de `Style`.
- Para bordes por lado hay que usar `TopBorder`, `BottomBorder`, `LeftBorder`, `RightBorder`.
- Si se define `ReportParametersLayout`, la cantidad de parametros debe coincidir con la cantidad de `CellDefinitions`.
- Los nombres de `DataSource` y los referenciados por los datasets deben coincidir exactamente.
- Si el `.rdl` se arma a mano, cualquier `&` en XML debe escaparse como `&amp;`.
- Un reporte puede abrir pero no ejecutar si el panel de parametros esta mal definido.
- Cuando Report Builder reescribe nombres de campos internos, hay que realinear expresiones y referencias.

## Aprendizajes concretos de los casos trabajados

### Caso 1. TC promedio mensual

- El Cognos usaba prompts incrustados en el body con HTML y JavaScript.
- En Report Builder hubo que mover la interaccion al panel superior de parametros.
- El header azul y el footer se pudieron replicar bien en RDL.
- El toggle de descripcion solo se pudo aproximar, no copiar 1 a 1.
- Los valores no se resolvian solo cambiando `SUM` por `MAX`; la clave era reconstruir correctamente la granularidad y los filtros reales de la consulta.
- Cuando se trabaja con semantic model de Power BI, es muy importante que el nombre del `DataSource` en el `.rdl` coincida exactamente con el configurado en Report Builder.

### Caso 2. Precios Unitarios Ex Planta

- El `XML Spec` fue la fuente mas importante para reconstruir la logica real del reporte.
- La consulta principal no era una tabla simple sino una crosstab basada en miembros, captions y propiedades de miembro.
- El parametro `pAño` excluia `Año Base`.
- La consulta principal dependia de propiedades como `Mes Número`, `Número`, `Cantidad dias` y `Número1`.
- El reporte tenia reglas de negocio embebidas que habia que respetar:
  - ocultar el mes actual
  - renombrar productos
  - forzar `0` para ciertos meses del año 2021
- En el semantic model aparecieron tres tablas relacionadas al dominio:
  - `Precios_Ex_Planta`
  - `Precios_ExPLanta_2_TM1`
  - `Precios_ExPLanta_TM1`
- El hecho de que existan varias tablas similares confirma que no conviene asumir un mapeo 1 a 1 desde el cubo original.

## Diferencias practicas entre Cognos y Report Builder

### Lo que suele poder quedar exacto o casi exacto

- titulo
- subtitulo
- header corporativo
- footer
- colores
- bordes
- logo
- tabla o matrix
- formato numerico
- exportacion PDF

### Lo que suele requerir aproximacion

- prompt page dentro del body
- toggles con JavaScript
- texto interactivo que cambia por script
- ciertos comportamientos HTML

## Checklist previo a empezar una migracion nueva

- tengo el `XML Spec.xml`
- tengo el PDF del reporte
- tengo capturas del prompt y del resultado
- tengo el nombre del semantic model
- tengo el mapeo de tablas/campos del modelo
- tengo las consultas MDX o SQL
- tengo las reglas de negocio conocidas
- tengo 5 a 10 valores esperados para validar
- tengo logo e imagenes del reporte
- se si hay drill-through o no

## Checklist para cerrar una migracion

- el `.rdl` abre sin errores
- el reporte ejecuta
- los parametros cargan valores correctos
- la cantidad de filas/columnas coincide
- los numeros coinciden con Cognos
- el orden coincide con Cognos
- los titulos, colores y logo coinciden
- PDF se ve bien
- Excel no rompe la estructura esperada
- quedaron anotadas las diferencias no replicables 1 a 1

## Mejor forma de trabajar conmigo para el proximo reporte

Si queres acelerar mucho una migracion compleja, la carpeta ideal que deberias dejarme es esta:

```text
NombreReporte/
  XML Spec.xml
  Reporte.pdf
  screenshots/
  mdx/
  semantic_model/
    modelo.txt
    tablas_campos.png
    relaciones.png
  reglas_negocio.txt
  expected_values.txt
  assets/
```

Y dentro de `expected_values.txt`, lo ideal es algo asi:

```text
Corte: pAño=2025
Fila/Columna esperada 1: Gasolina Super 95 / 31-Ene = 123,45
Fila/Columna esperada 2: Gasoil 50-S / 28-Feb = 234,56
Fila/Columna esperada 3: Jet A1 / 31-Mar = 345,67
```

## Recomendacion final

Para reportes simples se puede construir directamente en RDL.

Para reportes medianos o complejos, la mejor practica es trabajar siempre en dos entregables:

1. un archivo de analisis y mapeo
2. el `.rdl`

Ese archivo de analisis evita perder contexto, deja rastreables las reglas y hace mucho mas facil corregir numeros o rehacer partes del layout sin empezar de cero.

## Aprendizaje 2026-03-25

- Si un dataset del `.rdl` apunta a columnas del semantic model con acentos, por ejemplo `[Años]`, hay que validar el `CommandText` leyendo el archivo como UTF-8 explicito. En Windows PowerShell, `Get-Content -Raw` puede mostrar falsos mojibake (`AÃ±os`) aunque el XML este bien grabado.
- Para este reporte, el error de ejecucion en `dsAnio` se rastreo al nombre de columna acentuado. La correccion segura fue dejar el generador escribiendo el `.rdl` en UTF-8 y ajustar la regresion para inspeccionar el archivo con `[System.IO.File]::ReadAllText(..., [System.Text.UTF8Encoding]::new($false))`.
- Regla practica: cuando Report Builder diga que una columna "no puede encontrarse" y el nombre contiene acentos o eñes, primero verificar si el problema es de codificacion del `CommandText` antes de cambiar la logica DAX.
