# Workspace Organization

## Objetivo

Mantener el workspace ordenado por reporte, con una separacion clara entre insumos, construccion, entregables y conocimiento reusable.

## Reglas

- Todo reporte nuevo entra por `intake/` o se crea directamente en `reports/<reporte>/`.
- Cada reporte tiene su propio `.rdl`, `report.yaml`, `inputs/`, `work/`, `validations/` y `docs/`.
- Si un reporte dispara a otro por drill-through, cada uno sigue viviendo en su carpeta standalone.
- Guias, patrones y aprendizajes reutilizables se promueven a `knowledge/`.
- Scripts y validadores reutilizables van a `tools/`.
- Patrones y troubleshooting general van a `knowledge/`.

## Modelo de trabajo

1. Normalizar insumos.
2. Declarar `report.yaml`.
3. Construir o ajustar el `.rdl`.
4. Validar.
5. Promover aprendizaje reusable.

## Contrato de `report.yaml`

### Campos requeridos para todo reporte standalone

- `id`: identificador estable del reporte.
- `name`: nombre visible del reporte.
- `slug`: nombre tecnico del folder en `reports/<reporte>/`.
- `standalone`: debe ser `true` para reportes que siguen el modelo actual.
- `status`: estado operativo del reporte.
- `source_of_truth`: referencia a los artefactos que mandan por categoria.
- `inputs`: insumos que realmente usa el reporte.
- `outputs`: artefactos entregables y rutas de validacion.
- `open_questions`: lista de dudas pendientes, aunque este vacia.

### Campos y secciones opcionales

- `source_of_truth.logic`: solo cuando la logica del reporte depende de queries, notas tecnicas u otra fuente adicional.
- `source_of_truth.prompts`: solo cuando el XML spec, screenshots u otra referencia manda sobre prompts o navegacion.
- `source_of_truth.validation`: solo cuando existe una fuente concreta para contrastar salida esperada.
- `inputs.queries`: solo cuando el reporte conserva consultas fuente como parte del trabajo.
- `inputs.assets`: solo cuando el reporte depende de logos, imagenes u otros activos locales.
- `inputs.mappings`: solo cuando existe mapeo Cognos -> Report Builder o equivalentes.
- `dependencies`: solo cuando el reporte depende de otro reporte, un drill-through, un dataset externo o una decision compartida.

### Regla practica

Incluir siempre los campos requeridos. Agregar campos opcionales solo cuando ayudan a describir artefactos reales del reporte y evitar placeholders innecesarios.
