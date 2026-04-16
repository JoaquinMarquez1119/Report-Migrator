---
name: rdl-validation
description: Validaciones genericas para revisar estructura, encoding y consistencia de reportes RDL.
---

# RDL Validation

## When to use

Usar antes de dar por bueno un `.rdl`, especialmente cuando fue generado o modificado por script.

## Checklist

- Verificar que el `.rdl` exista en la raiz del reporte.
- Validar nombres unicos de report items.
- Validar datasets y parametros requeridos.
- Validar `ReportParametersLayout`.
- Validar widths y medidas serializadas.
- Buscar mojibake y texto mal codificado.
- Verificar rutas y dependencias de drill-through cuando aplique.
