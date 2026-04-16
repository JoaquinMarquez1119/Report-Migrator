# Migrador Reportes

Workspace para migrar reportes de IBM Cognos Analytics 11 a Microsoft Power BI Report Builder.

## Estructura

- `reports/`: un folder por reporte; el `.rdl` principal queda en la raiz del reporte junto a `inputs/`, `work/`, `validations/` y `docs/`.
- `tools/`: scripts y validaciones reutilizables del workspace.
- `knowledge/`: proceso, decisiones, patrones, troubleshooting y documentacion tecnica del workspace.

## Reportes actuales

- `reports/precios-unitarios-ex-planta-base/`
  Reporte standalone con su propio `.rdl`, `report.yaml`, `inputs/`, `work/`, `validations/` y `docs/`.
- `reports/precios-unitarios-ex-planta-detalle/`
  Reporte standalone para el detalle drill-through, separado del reporte base y con soporte local completo.
- `reports/tc-promedio-mensual/`
  Reporte standalone ya alineado al modelo final del workspace.

## Convenciones

- Cada reporte individual tiene un `report.yaml`.
- Los insumos Cognos y la evidencia visual viven en `reports/<reporte>/inputs/`.
- `inputs/assets/` y `inputs/mappings/` solo se usan si el reporte ya depende de esos materiales.
- El `.rdl` vive en la raiz del reporte y las validaciones en `reports/<reporte>/validations/`.
- Los scripts y checks reutilizables se promueven a `tools/`.
- El conocimiento reusable del proceso se promueve a `knowledge/`.

## Punto de partida para nuevo trabajo

1. Crear o ubicar el reporte en `reports/<reporte>/`.
2. Ingresar el material inicial en `reports/<reporte>/inputs/`.
3. Dejar el `.rdl` principal visible en la raiz del reporte.
4. Usar `work/` para iteraciones y `validations/` para evidencia final.
5. Registrar decisiones y patrones reutilizables en `knowledge/`.
