---
name: migrar-reportes-cognos
description: Migrar reportes de IBM Cognos Analytics a Power BI Report Builder con alta fidelidad funcional y visual. Use when haya que reconstruir un reporte `.rdl` a partir de XML Spec, queries, PDF, screenshots, drill-through, prompts o reglas de negocio de Cognos, especialmente cuando el comportamiento cambia por familia, unidad, anio, dataset o rama funcional.
---

# Migrar Reportes Cognos

## Overview

Reconstruir un reporte de Cognos en Power BI Report Builder sin depender de una conversion automatica 1 a 1.

Tomar a Cognos como fuente de verdad: primero reconstruir la logica del reporte y despues implementar el `.rdl`.

## Flujo base

1. Identificar el folder del reporte y reunir sus artefactos.
2. Leer primero queries y XML Spec; dejar el `.rdl` para el final.
3. Inventariar parametros, datasets, ramas, filtros y reglas visibles.
4. Si el comportamiento cambia segun contexto, armar una matriz de comportamiento.
5. Mapear Cognos -> Report Builder de forma explicita.
6. Construir el `.rdl` por capas.
7. Validar con escenarios concretos y evidencia comparable.

Leer [references/artifacts-checklist.md](references/artifacts-checklist.md) al inicio y usar [references/handoff-template.md](references/handoff-template.md) al cerrar o pausar la migracion.

## Orden de lectura

Leer los artefactos en este orden:

1. `inputs/queries/` y consultas derivadas
2. `inputs/xml-spec/` o `XML Spec.xml`
3. prompts, parametros, drill-through y wiring visible en el XML
4. PDF y screenshots de referencia
5. mappings, notas funcionales y documentacion auxiliar
6. `.rdl` actual, solo al final

Si hay conflicto entre el `.rdl` existente y Cognos, asumir que Cognos tiene razon hasta probar lo contrario.

## Inventario funcional

Antes de tocar el `.rdl`, dejar por escrito:

- parametros visibles y ocultos
- valores por defecto
- labels exactos
- datasets de prompts
- dataset principal
- datasets auxiliares, lookups, unions y ramas especiales
- columnas, medidas y data items calculados
- filtros, ordenamientos y agrupaciones
- reglas de visibilidad
- drill-through y parametros que transmite

## Matriz de comportamiento

Si el reporte cambia segun producto, unidad, anio, mercado o vista, armar una matriz de comportamiento.

La matriz debe responder:

- que familias de comportamiento existen
- que parametros alteran la estructura visible
- que dataset o rama alimenta cada familia
- que columnas, etiquetas y notas aparecen en cada caso
- que reglas especiales no se pueden perder

No agrupar por nombre comercial por defecto. Separar familias solo cuando Cognos cambie de forma estable la estructura, el dataset, las conversiones o las reglas visibles.

## Mapeo Cognos a Report Builder

Reconstruir equivalencias explicitas:

- query Cognos -> dataset RDL
- prompt Cognos -> report parameter
- data item Cognos -> field del dataset
- member property -> columna derivada o calculada
- list o crosstab -> tablix o matrix
- conditional render -> expresion de visibilidad
- drill-through -> action con parametros normalizados

No asumir que un nombre de Cognos existe igual en el modelo semantico o en SQL.

## Construccion del RDL

Construir en este orden:

1. datasource
2. datasets de parametros
3. datasets auxiliares
4. dataset principal
5. parametros
6. layout base
7. tablix o matrix por rama funcional
8. expresiones visuales y de visibilidad
9. header, footer, logos y detalle fino

Si Cognos ramifica en estructura o logica, preferir tablixes separados o datasets separados antes que una sola grilla generica llena de condiciones opacas.

## Validacion

Validar en este orden:

1. que el `.rdl` abre
2. que ejecuta sin errores
3. que los parametros funcionan
4. que cada dataset devuelve lo esperado
5. que los valores coinciden con Cognos
6. que el layout coincide visualmente
7. que exporta bien a PDF o Excel si corresponde

No validar a ojo. Trabajar con escenarios concretos y evidencia comparable.

## Reglas duras

- Nunca empezar deduciendo el comportamiento desde el `.rdl`.
- Nunca inferir logica solo desde screenshots.
- Nunca asumir una grilla unica si Cognos cambia por familia o por rama de datos.
- Nunca mezclar en la misma familia productos que usan datasets o columnas distintas.
- Nunca recrear conversiones nuevas si Cognos ya expone campos paralelos que resuelven la unidad o la moneda.
- Siempre separar normalizacion de parametros de la logica de layout.

## Entregable minimo

Antes de considerar terminada la migracion, dejar documentado:

- inventario de parametros y datasets
- matriz de comportamiento o justificacion de que no hace falta
- mapeo Cognos -> RDL
- reglas especiales y cutovers
- escenarios de validacion con evidencia

## Errores comunes

- construir el layout primero y revisar queries despues
- confiar en una version previa del `.rdl` como fuente de verdad
- validar solo un caso feliz
- mezclar reglas de datos con reglas de visibilidad
- esconder diferencias estructurales con columnas ocultas en vez de modelarlas
- perder renombres, notas, footers o mensajes vacios que Cognos muestra segun contexto
