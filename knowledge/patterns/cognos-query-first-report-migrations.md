# Pattern: Cognos Query-First Migrations

## Cuando usarlo

Usar este patron cuando se migra un reporte de IBM Cognos Analytics a Power BI Report Builder y el comportamiento real depende de queries en `inputs/queries`, no solo del layout visible.

## Reglas reutilizables

- Tomar las consultas de Cognos como fuente de verdad para datos, columnas visibles, cortes temporales y reglas por familia de producto.
- Cuando Cognos define una matriz distinta de conceptos o columnas por producto, modelar esa visibilidad de forma explicita en el reporte o en el dataset; no depender solo de ocultar columnas por ausencia de datos.
- No inferir logica solo desde screenshots o desde una primera version del `.rdl`; si hay diferencia, revisar primero la query original.
- Si una misma pantalla mezcla comportamientos distintos por familia de datos, separar datasets o tablix por rama funcional en vez de forzar una sola grilla generica.
- Mantener una normalizacion de nombres desacoplada del layout: sirve para parametros y drillthrough, pero no debe romper compatibilidad con los nombres que esperan las queries fuente.
- No asumir que una opcion de unidad implica una sola conversion universal; en Cognos puede haber columnas con unidades diferentes dentro de la misma vista.
- Cuando Cognos ya expone campos paralelos para moneda o unidad, preferir esos campos antes que recrear conversiones nuevas en expresiones del reporte.
- Verificar el `.rdl` final que abre el usuario, no solo el generador o un archivo temporal.

## Señales de que este patron aplica

- Los valores coinciden en estructura pero no en magnitud.
- Cognos muestra mas o menos columnas que Report Builder para el mismo corte.
- Un producto o familia entra en una vista especial y no sigue la grilla general.
- Un producto muestra una columna extra o le falta una columna aunque los valores visibles parezcan correctos.
- El reporte depende de tablas TM1 o de queries auxiliares aparte del dataset principal.
