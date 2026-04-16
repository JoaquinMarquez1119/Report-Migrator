# Diseno: Precios Unitarios Ex Planta - detalle

Fecha: 2026-03-22
Estado: Aprobado en conversacion, pendiente de revision final del documento

## Objetivo

Construir un nuevo reporte `Precios Unitarios Ex Planta - detalle` en Power BI Report Builder que replique el comportamiento y la presentacion de Cognos de forma fiel.

El reporte debe:

- funcionar como destino principal de drill-through desde `Precios Unitarios Ex Planta`
- poder abrirse de forma autonoma con prompts propios
- replicar la experiencia visual de Cognos, incluyendo encabezado, pestanas `Resumen` y `Detalle`, tablas condicionales, notas, textos laterales y estado vacio

## Alcance

Esta entrega incluye:

- un nuevo `.rdl` independiente para el detalle
- configuracion del drill-through desde el reporte padre
- soporte para apertura manual con prompts
- normalizacion de parametros para que la apertura manual y el drill usen la misma logica interna

Esta entrega no incluye:

- cambios ajenos al flujo `Precios Unitarios Ex Planta`
- refactor general del reporte padre fuera de lo necesario para el drill

## Enfoque elegido

Se implementara un nuevo `.rdl` independiente para el detalle y se reutilizara el reporte padre como punto de entrada principal.

Motivos:

- replica mejor la separacion funcional de Cognos
- facilita el uso por drill-through y tambien la apertura manual
- mantiene aislada la logica mas compleja del detalle
- reduce el acoplamiento con el dataset resumido del reporte padre

## Reportes involucrados

- Reporte padre: `Precios_unitarios_ex_planta_base.rdl`
- Nuevo reporte destino: `Precios Unitarios Ex Planta - detalle.rdl`

## Flujo funcional

### Apertura por drill-through

Desde el reporte padre, el click sobre el producto en la matriz debe abrir el nuevo reporte detalle enviando:

- `pAnio`
- `pProducto`
- `pUnidad`
- `pVista`

La apertura inicial por drill debe ir a `Resumen` para replicar la experiencia de Cognos con pestanas internas.

### Apertura manual

El nuevo reporte detalle tambien debe abrirse de forma independiente mostrando prompts para:

- anio
- producto
- unidad

## Parametros

El nuevo reporte debe tener estos parametros:

### `pAnio`

- tipo: entero
- visible
- prompt: `Seleccionar Año:`
- origen de valores: dataset equivalente a `dsAnio`
- default: `Year(Today())`

### `pProducto`

- tipo: texto
- visible
- origen de valores: dataset de productos normalizados
- debe servir tanto para apertura manual como para drill-through

### `pUnidad`

- tipo: texto
- visible
- valores visibles:
  - `USD/m3`
  - `$/lt ó $/kg según corresponda`
- debe aceptar tambien los codigos cortos enviados por el drill del reporte padre:
  - `USD`
  - `UYU`

### `pVista`

- tipo: texto
- oculto
- controla la pestana activa
- valores esperados:
  - `Resumen`
  - `Detalle`

## Normalizacion de parametros

### Unidad

La logica interna del reporte trabajara con valores visuales de Cognos:

- `USD/m3`
- `$/lt ó $/kg según corresponda`

Si el reporte llega por drill con:

- `USD` -> se normaliza a `USD/m3`
- `UYU` -> se normaliza a `$/lt ó $/kg según corresponda`

### Producto

El drill del reporte padre ya aplica una normalizacion que debe mantenerse para el nuevo reporte:

- `Asfalto AC-20` -> `Asfalto AC-30`
- `Super 95 Sp` -> `Gasolina Super 95`
- `Premium 97 Sp` -> `Gasolina Premium 97`
- `Gasoil Comun` -> `Gasoil 50-S`
- `Gasoil Especial` -> `Gasoil 10-S`
- `Propano` -> `Propano Industrial`

El dataset de productos del reporte detalle debe ser consistente con esa convencion.

## Diseno visual

El nuevo `.rdl` debe replicar visualmente Cognos:

- barra superior azul con titulo
- nombre del producto y anio centrados
- logo ANCAP a la derecha
- pestanas superiores `Resumen` y `Detalle`
- contenido central condicionado por `pVista`
- referente al pie: `Referentes: Jefe Ventas Combustibles y Lubricantes`

## Pestana Resumen

La pestana `Resumen` debe replicar la pagina `Resumen` del spec de Cognos.

Debe incluir:

- matriz resumen por mes
- estructura condicional por unidad
- corner label fijo `USD/m3` para vista USD
- corner label dinamico con unidad del producto para vista moneda local
- bloque de texto lateral
- nota condicional de Butano
- formatos numericos y renombres visibles de conceptos

## Pestana Detalle

La pestana `Detalle` debe replicar la pagina `Detalle` del spec de Cognos.

Debe incluir:

- matriz detalle por dia y concepto
- version condicional para `USD/m3`
- version condicional para `$/lt ó $/kg según corresponda`
- mensaje exacto `No hay datos disponibles` cuando no existan filas
- orden exacto de conceptos
- formato decimal condicional por concepto

## Datasets previstos

La implementacion en Report Builder no debe copiar uno a uno todos los nodos intermedios de Cognos si eso degrada mantenibilidad. La regla es replicar la salida final exacta con un conjunto acotado de datasets equivalentes.

Datasets previstos:

- `dsAnio`
- `dsProducto`
- `dsTexto`
- `dsResumen`
- `dsDetalle`
- dataset auxiliar o logica embebida para densidad, segun convenga

## Reglas de negocio a preservar

### Regla de densidad

La logica de densidad debe mantenerse porque afecta la conversion a `USD/m3` de productos expresados en `$/kg`. No es opcional ni solo visual.

### Renombres visibles

Deben conservarse los renombres funcionales presentes en Cognos, incluyendo:

- `Precio Ex Planta (PEP)`
- `PEP calculado por URSEA (*)`
- `Monto diferencial por zonas "d"`
- `Factor de ajuste`
- `PPI n-1 Periodo URSEA`
- `PPI n-2 Periodo URSEA`

### Orden de conceptos

El detalle debe respetar el orden de conceptos definido en Cognos, incluyendo la incorporacion de:

- `PPI n-1 Periodo URSEA`
- `PPI n-2 Periodo URSEA`

### Formato decimal

El detalle debe aplicar 2 o 4 decimales segun el concepto, siguiendo la logica de `Decimales` y el estilo condicional del spec.

### Estado vacio

Cuando un producto no tenga datos para la vista seleccionada, debe mostrarse exactamente:

- `No hay datos disponibles`

## Drill-through desde el reporte padre

El reporte padre ya apunta a `Precios Unitarios Ex Planta - detalle` en las acciones de drill.

Debe ajustarse y verificarse que:

- el target exista como nuevo `.rdl`
- `pAnio` se pase sin transformacion
- `pUnidad` se pase como hoy y sea normalizado por el detalle
- `pProducto` mantenga el mapeo actual del padre
- `pVista` se envie como `Resumen`

## Verificacion prevista

Antes de cerrar implementacion se debe validar:

- comparacion visual contra las capturas adjuntas del detalle
- al menos un caso con datos y uno sin datos
- funcionamiento del drill desde el padre
- apertura manual del detalle con prompts visibles
- consistencia de anio, producto y unidad entre reporte padre y detalle

## Riesgos y consideraciones

- el directorio de trabajo no es un repositorio git, por lo que no se podra hacer commit del spec ni de la implementacion dentro de este workspace
- el spec de Cognos contiene logica extensa; en Report Builder debe priorizarse fidelidad de salida antes que traslacion literal de cada consulta intermedia
- la compatibilidad entre valores de unidad del drill (`USD`/`UYU`) y los labels visibles del standalone debe resolverse dentro del reporte detalle

## Implementacion esperada

La siguiente fase debe producir:

- el nuevo `.rdl` del detalle
- la actualizacion del drill en el reporte padre
- una verificacion basica de consistencia visual y funcional
