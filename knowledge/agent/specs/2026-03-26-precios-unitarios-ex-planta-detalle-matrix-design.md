# Precios Unitarios Ex Planta - detalle Matrix Design

**Goal:** Corregir el reporte `Precios Unitarios Ex Planta - detalle` reemplazando la lógica manual y dispersa de columnas por una matriz central de comportamiento, usando como fuente principal la documentación nueva del reporte y sin modificar el reporte base.

**Contexto**

El comportamiento actual del detalle depende de varias funciones VB embebidas en el `.rdl`:

- `ShowSummaryUsdColumn`
- `ShowSummaryLocalColumn`
- `ShowSecondaryLocalSummaryColumn`
- `ShowDetailColumn`
- `UseTm1UsdSummary`

Esa lógica está acoplada al layout y además se mezcla con reglas del tipo "mostrar solo si hay datos distintos de cero". El resultado es frágil: cuando se corrige una combinación puntual de `producto / año / unidad`, otra combinación puede romperse durante la validación con Cognos.

La documentación nueva en `reports/precios-unitarios-ex-planta-detalle/inputs/docs/` pasa a ser la fuente principal de verdad funcional. Esa documentación redefine con más precisión:

- qué productos pertenecen a cada bloque de origen
- qué productos cambian de origen en cada corte histórico
- qué productos requieren densidad
- cómo cambia el tratamiento de GLP / Propano desde julio 2023
- qué expectativas de estructura tiene el reporte por familia

## Fuentes de verdad

Prioridad funcional:

1. `reports/precios-unitarios-ex-planta-detalle/inputs/docs/Documentacion Precio ExPlanta.docx`
2. `reports/precios-unitarios-ex-planta-detalle/inputs/docs/AnalisisExPLANTA.xlsx`
3. `reports/precios-unitarios-ex-planta-detalle/inputs/mappings/detalle-cognos-behavior-matrix.md`
4. `reports/precios-unitarios-ex-planta-detalle/inputs/queries/`
5. `reports/precios-unitarios-ex-planta-detalle/Precios Unitarios Ex Planta - detalle.rdl`

## Problema raíz

El problema no es solo "faltan columnas" o "sobran columnas". El problema raíz es que el detalle hoy decide la estructura visible con reglas parciales repartidas en varias funciones y además condicionadas por presencia de datos.

Eso genera dos fallas sistemáticas:

1. La estructura visible no está centralizada por combinación funcional.
2. La estructura esperada de Cognos queda subordinada al contenido puntual de los datasets, cuando en realidad primero debería decidirse la familia/regla y recién después validar si hay datos.

## Restricción de alcance

La corrección debe hacerse exclusivamente en el reporte detalle.

No se tocarán:

- el reporte base
- la definición del drillthrough en el reporte padre
- la normalización compartida fuera del `.rdl` del detalle

Sí se permite:

- cambiar funciones VB en el bloque `<Code>` del detalle
- cambiar expresiones de visibilidad y uso de tablix dentro del detalle
- agregar funciones auxiliares internas al detalle

## Enfoque recomendado

Se mantendrá el layout actual y los datasets existentes, pero se reemplazará la lógica de comportamiento por una matriz central en el bloque `<Code>`.

La idea es que el `.rdl` tenga una única capa de decisión para responder:

- cuál es el producto normalizado
- a qué familia funcional pertenece
- qué tramo histórico aplica para el año/mes solicitado
- qué columnas son válidas para `Resumen USD`
- qué columnas son válidas para `Resumen local`
- qué columnas son válidas para `Resumen TM1/local`
- qué columnas son válidas para `Detalle`
- qué resumen corresponde usar según producto y unidad

## Diseño funcional

### 1. Normalización de parámetros

Se mantendrá dentro del detalle una normalización explícita de producto y unidad:

- `Asfalto AC-20 -> Asfalto AC-30`
- `Super 95 Sp -> Gasolina Super 95`
- `Premium 97 Sp -> Gasolina Premium 97`
- `Gasoil Comun -> Gasoil 50-S`
- `Gasoil Especial -> Gasoil 10-S`
- `Propano -> Propano Industrial`
- `USD` y `USD/m3` se normalizan a `USD/m3`
- cualquier otra unidad se trata como unidad local

Esto se mantiene local al detalle para cumplir la restricción de no modificar el reporte base.

### 2. Familias funcionales

La matriz central trabajará con familias y no con decisiones columna por columna sueltas.

Familias objetivo:

- Líquidos estándar
- Solventes y especiales
- Fuel oils
- Supergas envasado
- Propano y GLP granel
- Queroseno Montevideo
- Queroseno Interior
- Butano
- Asfaltos

Cada familia definirá:

- columnas válidas por vista
- reglas de resumen esperadas
- particularidades históricas
- dependencias de densidad y cotización

### 3. Tramos históricos

La documentación nueva deja tres cortes explícitos que deben quedar modelados como reglas, no como deducciones indirectas:

- resto de productos: PA hasta `2021-06`, planilla desde `2021-07`
- querosenos: PA hasta `2021-07`, planilla desde `2021-08`
- Supergas / Propano Industrial / Supergas A Granel / Propano Redes: PA hasta `2023-06`, planilla desde `2023-07`

Además:

- `Propano Redes` queda discontinuado desde `2023-07`
- GLP desde planilla corresponde funcionalmente a `Supergas`
- Propano desde planilla corresponde funcionalmente a `Propano Industrial` y `Supergas A Granel`

Aunque el parámetro visible del reporte use `pAnio`, la matriz debe modelar el tramo histórico con el mejor nivel que permite el reporte actual y aplicar esas reglas de manera consistente en la selección de resumen y columnas.

### 4. Separación entre estructura y datos

La nueva lógica debe separar:

- `estructura esperada`: columnas que Cognos espera para la combinación elegida
- `evidencia de datos`: si el dataset trae o no valores para esa columna

La visibilidad final de cada columna debe quedar gobernada por una regla compuesta:

1. la columna pertenece a la estructura válida para esa familia/vista/unidad
2. opcionalmente, hay evidencia suficiente en dataset si la columna es realmente dinámica

La regla 1 pasa a ser dominante. La regla 2 no puede seguir reemplazando a la 1.

### 5. Selección de resumen

El detalle hoy usa múltiples tablix de resumen:

- resumen USD principal
- resumen USD TM1/local
- resumen local TM1
- resumen local principal

La selección entre esos bloques debe salir de funciones de decisión más explícitas que consideren:

- producto normalizado
- unidad normalizada
- familia funcional
- tipo de resumen aplicable

En especial:

- asfaltos deben seguir usando el resumen TM1/local específico
- el resto de familias deben resolver de manera explícita si usan resumen principal o secundario
- la selección no debe depender solo de una lista corta en `UseTm1UsdSummary`

### 6. Columnas por vista

La matriz central definirá catálogos de columnas por familia:

- resumen USD
- resumen local
- detalle

Ejemplos de contratos esperados:

- Líquidos estándar:
  - resumen: `PVP`, `PEP imp.`, `PEP`
  - detalle: `PVP`, `PEP imp.`, `Tasa inflamable`, `IMESI`, `Tasa primaria`, `FUDAEE`, `PEP`
- Supergas:
  - resumen: `PVP`, `PIT`, `PEP imp.`, `PEP`, `Factor`, `PEP calculado por URSEA`, `Monto diferencial`, `PPI n-1`, `PPI n-2`
  - detalle: incluye además `Margen GLP envasado`, `Margen envasado`, `Margen distribución`, `Tasa distribución`, `IVA distribución`, `IVA primaria`
- Propano / GLP granel:
  - sin `PIT` ni `Monto diferencial` como columnas obligatorias
- Queroseno Interior:
  - resumen con `PEP sin flete secundario`
- Asfaltos:
  - resumen TM1/local con columnas propias `Precio público`, `Precio exonerado`, `IVA`, `Precio sin IVA`, `IMESI`, `Cotización`, `Precio sin impuesto`, `Precio ex planta`

## Diseño técnico

### Funciones nuevas o rediseñadas

El bloque `<Code>` del reporte debería converger hacia funciones con esta responsabilidad:

- `NormalizeProduct`
- `NormalizeUnit`
- `GetProductFamily`
- `GetHistoricalSourceGroup`
- `ShouldUseUsdTm1Summary`
- `ShouldUseLocalTm1Summary`
- `IsColumnAllowed(viewKey, product, year, unit, columnKey)`
- `HasMeaningfulData(datasetField, datasetName)` o equivalentes por expresión

La intención es reducir o eliminar la duplicación de `Select Case` por cada tablix.

### Expresiones de visibilidad

Las expresiones de columnas deberán cambiar desde algo como:

`Not Code.ShowDetailColumn(...) Or Count(...) = 0`

hacia algo conceptualmente equivalente a:

`Not Code.IsColumnAllowed("Detalle", ...) Or Code.ShouldHideForMissingData(...)`

con reglas homogéneas en todas las tablix.

### Compatibilidad

No se deben cambiar:

- nombres de datasets
- nombres de campos
- layout general
- bookmarks
- parámetros públicos del reporte

Esto minimiza el riesgo de romper la navegación existente.

## Estrategia de validación

La validación de esta corrección debe orientarse a comportamiento, no solo a abrir el `.rdl`.

Escenarios mínimos:

1. `Gasolina Super 95 / 2025 / USD/m3`
   Debe mostrar estructura de líquidos estándar, sin columnas GLP ni FO.

2. `Supergas / 2025 / unidad local`
   Debe mostrar columnas GLP completas, incluyendo `PIT` y `Monto diferencial`.

3. `Propano Industrial / 2022 / unidad local`
   Debe separarse de Supergas y no mostrar `PIT` ni `Monto diferencial` como obligatorias.

4. `Queroseno Interior / 2021 / USD/m3`
   Debe mostrar `PEP sin flete secundario`.

5. `Asfalto AC-20 / 2022 / USD/m3`
   Debe resolverse como `Asfalto AC-30` y usar la estructura de asfaltos.

6. `Aguarras / 2025 / unidad local`
   Debe usar la estructura de solventes y mantener la lógica de nota URSEA cuando corresponda.

## Riesgos conocidos

- El parámetro `pAnio` es anual, mientras que la documentación y la planilla expresan cortes por mes.
- La lógica actual de "ocultar si todo viene en cero" puede estar compensando problemas de dataset además de layout.
- Algunas columnas pueden requerir distinguir entre "columna estructural" y "columna opcional si no hay datos".
- `Propano Redes` discontinuado desde julio 2023 puede requerir validar qué hace hoy el dataset cuando se pide un año posterior.

## Criterio de éxito

La corrección será considerada exitosa si:

- la estructura visible deja de depender de parches puntuales por producto
- la lógica queda centralizada en una matriz única dentro del detalle
- los escenarios testigo se alinean con Cognos
- futuros ajustes pueden hacerse actualizando la matriz, sin tocar múltiples funciones y tablix por separado

## Notas de implementación

- El workspace actual no está inicializado como repositorio git, por lo que este spec no puede dejarse committeado en esta sesión.
- La siguiente etapa debe ser un plan de implementación detallado antes de editar el `.rdl`.
