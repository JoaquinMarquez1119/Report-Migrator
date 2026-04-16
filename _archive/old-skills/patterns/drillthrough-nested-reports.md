# Pattern: Drillthrough Nested Reports

## Cuando usarlo

Usar este patron cuando un reporte principal abre uno o mas reportes independientes via drill-through y conviene preservar la relacion funcional entre ellos sin mezclarlos en una sola carpeta tecnica.

## Estructura recomendada

- un folder standalone por reporte en `reports/<reporte>/`
- un reporte padre como punto de entrada
- uno o mas reportes hijos en sus propios folders standalone
- assets, mappings y validaciones ubicados dentro del reporte que los usa
- conocimiento transversal promovido a `knowledge/`

## Reglas operativas

- El reporte hijo debe ser independiente aunque se abra por drill-through.
- Los parametros comunes deben documentarse en los `report.yaml` involucrados y en una nota reusable si aplica.
- La logica reusable no debe quedar escondida en un solo reporte.
- Las evidencias visuales del padre y del hijo deben separarse.
- Si ambos reportes comparten decisiones o mapeos, promoverlos a `knowledge/docs/` o duplicar solo lo minimo necesario en `inputs/`.

## Caso actual

- padre: `precios-unitarios-ex-planta-base`
- hijo: `precios-unitarios-ex-planta-detalle`
