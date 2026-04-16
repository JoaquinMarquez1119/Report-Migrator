# Precios Unitarios Ex Planta Base Layout Design

**Goal:** Ajustar la geometria del reporte `Precios Unitarios Ex Planta` para que en Power BI Service se vea lo mas parecido posible a Cognos: header ancho, contenido centrado y matriz alineada con el eje del titulo.

## Contexto

El reporte base actual fue armado sobre un canvas de `10.2in` dentro de una pagina de `11in`. En Power BI Service eso produce una composicion angosta con mucho espacio vacio a la derecha, distinta a la referencia de Cognos.

La matriz principal ademas arranca cerca de `2.05in` desde la izquierda, por lo que su centro visual no coincide con el eje del titulo del encabezado.

## Objetivo visual

El reporte debe:

- ocupar mucho mas ancho util al abrirse en Power BI Service
- conservar un header azul continuo, con logo a la derecha
- mantener titulo y anio centrados
- recentrar la matriz para que quede alineada al eje central del titulo
- preservar el bloque informativo de la izquierda sin alterar la logica ni los datos

## Enfoque elegido

Se modificara directamente el `.rdl` del reporte base.

Cambios previstos:

- ensanchar `Body`, `BodyCanvas` y `rectHeader` de forma agresiva para mejorar el uso de monitores grandes
- aumentar `PageWidth` y recalcular margenes de forma consistente
- ampliar el ancho util del titulo y del anio en el header
- reposicionar ambas tablix (`tablixUSD` y `tablixUYU`) para que compartan eje central con el titulo

## Restricciones

- no se cambian datasets, parametros ni expresiones de negocio
- no se modifica el detalle ni el drill-through
- el resultado sigue siendo un reporte paginado con ancho fijo; no sera responsive, pero si visualmente mucho mas cercano a Cognos

## Verificacion

La regresion estructural debe exigir:

- body ancho (`>= 20in`)
- header y body con el mismo ancho
- consistencia entre `PageWidth`, margenes y body
- centro de la matriz alineado con el centro del titulo
