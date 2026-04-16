# Drillthrough: Precios Unitarios Ex Planta

La migracion actual usa dos reportes standalone relacionados:

- `precios-unitarios-ex-planta-base`: reporte padre standalone
- `precios-unitarios-ex-planta-detalle`: reporte hijo standalone, invocado por drill-through y tambien ejecutable de forma manual

## Relacion entre reportes

- El reporte detalle depende del RDL standalone del reporte base.
- Los parametros compartidos deben mantenerse consistentes entre ambos reportes.
- La logica de normalizacion de producto y unidad sigue siendo un comportamiento compartido entre base y detalle.

## Parametros compartidos

- `pAnio`
- `pProducto`
- `pUnidad`
- `pVista`

## Ubicacion de artefactos locales del detalle

Desde esta carpeta `docs/`, los insumos locales del reporte detalle viven en:

- xml spec: `../inputs/xml-spec/`
- queries: `../inputs/queries/`
- screenshots de referencia: `../inputs/screenshots/`
- pdf y notas: `../inputs/pdf/` y `../inputs/notes/`
- assets y mappings locales: `../inputs/assets/` y `../inputs/mappings/`
- validaciones locales: `../validations/`
