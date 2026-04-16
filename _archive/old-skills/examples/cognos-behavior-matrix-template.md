# Cognos Behavior Matrix Template

Usar esta plantilla para deducir el comportamiento de un reporte a partir de Cognos antes de construirlo en Power BI Report Builder.

## 1. Inventario de fuentes de verdad

| Tipo de artefacto | Ubicacion | Que responde | Prioridad |
|---|---|---|---|
| Queries |  | Conceptos, ramas, filtros, origen de datasets | Alta |
| XML spec / prompts |  | Parametros, defaults, wiring, drill-through | Alta |
| Screenshots |  | Labels, agrupaciones, tabs, secciones | Media |
| PDF |  | Salida renderizada y pistas de paginacion | Media |
| RDL actual |  | Implementacion actual solamente | Baja |

## 2. Normalizacion de parametros

| Parametro | Valores de entrada | Valor interno normalizado | Notas |
|---|---|---|---|
|  |  |  |  |

## 3. Matriz por familias de comportamiento

| Familia | Miembros incluidos | Parametros que afectan | Resumen | Detalle | Dataset o rama origen | Reglas especiales |
|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |

Para cada familia aclarar tambien:

- columnas visibles
- columnas ocultas
- labels y renombres
- orden de conceptos
- decimales
- estado vacio
- diferencias por unidad
- diferencias por anio o metodologia

## 4. Contrato de origen de datasets

| Vista o seccion | Dataset o query origen | Por que aplica | Rama alternativa |
|---|---|---|---|
|  |  |  |  |

## 5. Reglas especiales

Anotar aqui reglas que no salen solo del layout:

- renombres de producto
- remapeos de unidad
- conversiones por densidad o cotizacion
- conceptos agregados desde cierto anio
- defaults de drill-through
- notas o footers condicionales

## 6. Escenarios minimos de validacion

Elegir escenarios representativos, no todas las combinaciones.

| Escenario | Por que existe | Parametros | Familia esperada | Que verificar |
|---|---|---|---|---|
|  |  |  |  |  |

## 7. Resumen para implementacion

Escribir un resumen corto para que otro Codex pueda construir el reporte:

- que familias existen
- que parametros cambian estructura y cuales solo filtran filas
- que vistas requieren tablixes separados
- que reglas son peligrosas de re-inferir desde el `.rdl`
