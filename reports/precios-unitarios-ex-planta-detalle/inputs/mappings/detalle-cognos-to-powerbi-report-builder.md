# Mapeo Cognos -> Power BI Report Builder

## Objetivo del archivo

Este archivo documenta el mapeo funcional entre el reporte original de Cognos y el reporte paginado `Precios Unitarios Ex Planta - detalle`.

La matriz de comportamiento deducida desde Cognos vive en `detalle-cognos-behavior-matrix.md`. Este archivo queda como referencia rapida; la matriz es el handoff minimo para reconstruir o validar familias, ramas y escenarios de prueba.

Su objetivo no es guardar decisiones de diseno generales ni servir como especificacion completa del `.rdl`. Su funcion es mas acotada:

- resumir cuales insumos de Cognos son la fuente de verdad
- dejar visibles las reglas que afectan columnas, labels, orden y conversiones
- ayudar a mantener el reporte sin tener que redescubrir la logica cada vez
- evitar que la comparacion con Cognos dependa solo de screenshots

## Fuentes de verdad para este reporte

Para este reporte, la fuente principal de verdad no es el layout del `.rdl`, sino los insumos originales de Cognos:

- queries: `../queries/`
- prompts y wiring del reporte: `../xml-spec/xml-spec-cognos.xml`
- evidencia visual: `../screenshots/` y `../pdf/`

Regla practica:

- si hay conflicto entre el `.rdl` y una screenshot, revisar primero las queries de Cognos
- si Cognos muestra distintas columnas segun producto o unidad, esa logica debe modelarse de forma explicita

## Alcance funcional del detalle

El reporte detalle debe poder abrirse de dos formas:

- por drill-through desde `precios-unitarios-ex-planta-base`
- de forma manual con sus propios parametros

Los parametros funcionales esperados son:

- `pAnio`
- `pProducto`
- `pUnidad`
- `pVista`

`pVista` controla la pestana activa (`Resumen` o `Detalle`).

## Normalizacion de parametros

### Unidad

El reporte puede recibir valores cortos desde el drill del padre, pero internamente debe trabajar con labels equivalentes a Cognos:

- `USD` -> `USD/m3`
- `UYU` -> `$/lt o $/kg segun corresponda`

### Producto

El detalle debe aceptar la convencion usada por el drill del reporte padre y normalizar nombres cuando corresponda. Casos ya conocidos:

- `Asfalto AC-20` -> `Asfalto AC-30`
- `Super 95 Sp` -> `Gasolina Super 95`
- `Premium 97 Sp` -> `Gasolina Premium 97`
- `Gasoil Comun` -> `Gasoil 50-S`
- `Gasoil Especial` -> `Gasoil 10-S`
- `Propano` -> `Propano Industrial`

## Datasets esperados en Report Builder

El detalle no necesita reproducir uno a uno todos los nodos intermedios de Cognos, pero si debe conservar la salida funcional.

Datasets principales esperados:

- `dsAnio`
- `dsProducto`
- `dsTexto`
- `dsResumen`
- `dsDetalle`

## Reglas funcionales a preservar

### 1. Las columnas cambian segun producto y unidad

Este reporte no usa una unica grilla universal. Cognos muestra distintas combinaciones de columnas segun:

- familia de producto
- unidad seleccionada
- presencia real de ciertos conceptos
- cortes de anio en algunas ramas de datos

Por eso, la validacion correcta no es "comparar una sola corrida", sino verificar reglas de visibilidad por clase de comportamiento.

### 2. La logica de densidad es obligatoria

La conversion a `USD/m3` para productos expresados en `$/kg` depende de densidad. Esa logica no es cosmetica ni opcional.

### 3. Hay columnas y labels que deben mantenerse exactos

Entre los conceptos que deben preservarse tal como vienen de Cognos estan:

- `Precio Ex Planta (PEP)`
- `PEP calculado por URSEA (*)`
- `Monto diferencial por zonas "d"`
- `Factor de ajuste`
- `PPI n-1 Periodo URSEA`
- `PPI n-2 Periodo URSEA`

### 4. El orden de conceptos tambien es parte del contrato

No alcanza con devolver los mismos valores. El orden visible del detalle forma parte de la salida esperada.

## Uso recomendado de este archivo

Este `.md` sirve como nota de referencia rapida para quien toque el reporte despues:

- antes de cambiar columnas o expresiones de visibilidad
- antes de tocar normalizacion de parametros
- antes de rehacer conversiones a USD
- antes de revisar diferencias contra Cognos en drill-through

Si hace falta mas detalle, complementar con:

- `../../docs/drillthrough.md`
- `../../../../knowledge/patterns/cognos-query-first-report-migrations.md`
- `../../../../knowledge/decisions/2026-03-22-precios-unitarios-ex-planta-detalle-design.md`

## Que no deberia contener este archivo

Para mantenerlo util, este archivo no deberia mezclar:

- contenido de otros reportes
- pasos de implementacion temporales
- preguntas abiertas de una conversacion puntual
- texto copiado de reportes no relacionados
