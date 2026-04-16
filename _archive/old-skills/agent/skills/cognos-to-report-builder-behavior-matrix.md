---
name: cognos-to-report-builder-behavior-matrix
description: Guia para deducir una matriz de comportamiento desde artefactos de IBM Cognos antes de construir o validar un reporte en Power BI Report Builder.
---

# Cognos To Report Builder Behavior Matrix

## When to use

Usar cuando un reporte Cognos no es estructuralmente lineal y el comportamiento visible cambia segun parametros, familias, datasets, drill-through o reglas de negocio.

Senales tipicas:

- cambian columnas o secciones segun producto, unidad, anio, mercado o vista
- hay varias queries, unions o ramas funcionales
- el drill-through envia parametros que luego se normalizan
- el layout visible no alcanza para explicar el comportamiento real
- las comparativas manuales contra Cognos generan iteracion excesiva

No usar cuando el reporte tiene columnas fijas, un dataset principal y los parametros solo filtran filas.

## Regla central

Cognos es la fuente de verdad.

El `.rdl` actual no se usa para deducir el comportamiento; se usa despues para verificar si la implementacion respeta la matriz deducida desde Cognos.

## Orden de lectura

Leer los artefactos en este orden:

1. queries de Cognos y queries derivadas
2. xml spec, prompt pages y wiring de parametros
3. screenshots y PDF de evidencia
4. `.rdl` actual, solo al final

Si falta alguno, trabajar con la mejor evidencia disponible y dejar la ausencia explicitada.

## Objetivo de la skill

Producir una matriz que le diga a Codex que debe mostrar el reporte en Power BI Report Builder sin tener que comparar manualmente cada combinacion de parametros.

La salida minima siempre debe incluir:

- tabla de normalizacion de parametros
- matriz de comportamiento por familias
- contrato de origen de datasets por vista o seccion
- reglas especiales y cutovers
- escenarios minimos de validacion

## Como deducir familias de comportamiento

No agrupar por nombre comercial ni hacer una fila por producto por defecto.

Crear una familia solo cuando sus miembros compartan lo mismo en:

- columnas visibles
- dataset o rama funcional de origen
- conversiones por unidad
- labels y renombres
- orden de conceptos
- comportamiento de estado vacio

Separar familias distintas cuando Cognos cambie aunque sea una de esas dimensiones de forma estable.

## Lo que hay que extraer de Cognos

### Parametros

- nombres tecnicos
- labels visibles
- defaults
- hidden params
- normalizaciones y remapeos
- valores que llegan por drill-through

### Datasets y ramas

- dataset principal
- datasets auxiliares
- queries que solo alimentan prompts
- queries que cambian la estructura visible
- unions y ramas condicionales

### Reglas visibles

- columnas por familia
- orden de conceptos
- decimales
- labels exactos
- notas o footers condicionales
- mensajes de estado vacio

### Reglas no visibles

- renombres de producto
- renombres de unidad
- conversiones por densidad o cotizacion
- cambios por anio o metodologia
- campos paralelos para USD/local

## Salida esperada

La matriz final debe responder, para cada familia:

- que productos o miembros la integran
- que parametros cambian la estructura
- que se muestra en cada vista
- que dataset o rama sostiene esa vista
- que reglas especiales no se pueden perder

Usar la plantilla en [knowledge/examples/cognos-behavior-matrix-template.md](C:/Users/jmarquez/Desktop/Quanam/Migrador%20Reportes/knowledge/examples/cognos-behavior-matrix-template.md).

## Reglas duras

- nunca deducir familias solo desde screenshots
- nunca tomar el `.rdl` como fuente primaria
- nunca asumir una grilla generica si Cognos ramifica
- nunca mezclar en una misma familia productos que usan distinta rama de datos
- separar normalizacion de parametros de la logica de layout

## Errores comunes

- empezar desde el `.rdl` y recien despues revisar Cognos
- listar columnas pero no documentar el dataset origen
- asumir que una columna ausente es cero y no una regla de visibilidad
- olvidar cutovers por anio o cambios metodologicos
- describir el comportamiento por producto exacto cuando la regla real es por familia

## Entregable minimo para handoff

Antes de construir el reporte, dejar escrito:

- la matriz por familias
- los parametros normalizados
- los escenarios representativos de validacion
- las reglas que obligan a usar tablixes separados o ramas de dataset distintas
