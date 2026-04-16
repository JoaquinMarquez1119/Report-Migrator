---
name: cognos-report-family-intake
description: Normaliza un nuevo reporte Cognos o un grupo de reportes relacionados dentro del workspace y deja listas sus fichas de trabajo.
---

# Cognos Report Family Intake

## When to use

Usar cuando entra un reporte Cognos nuevo o cuando aparece un grupo de reportes relacionados que deben quedar listos para migracion dentro del modelo standalone del workspace.

## Checklist

- Identificar que reportes deben existir como folders standalone.
- Crear o actualizar `report.yaml` para cada reporte involucrado.
- Ordenar insumos en `inputs/`.
- Separar evidencia, queries, XML spec y otros materiales por reporte.
- Promover conocimiento reusable a `knowledge/` cuando no pertenezca a un solo reporte.
- Registrar preguntas abiertas reales.
