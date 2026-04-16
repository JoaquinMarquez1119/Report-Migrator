---
name: cognos-to-rdl-report-creation
description: Guia generica para traducir un reporte Cognos a Power BI Report Builder dentro de este proyecto.
---

# Cognos To RDL Report Creation

## When to use

Usar al crear o rehacer un reporte `.rdl` a partir de XML Spec, consultas, evidencia visual y reglas de negocio de Cognos.

## Checklist

- Identificar fuente de verdad para layout, prompts, logica y validacion.
- Mapear datasets y parametros.
- Definir si el reporte es standalone o drill-through.
- Construir el `.rdl` en `work/` o regenerarlo desde `tools/scripts/`.
- Publicar el resultado validado en la raiz del reporte.
- Promover patrones generales a `knowledge/patterns/`.
