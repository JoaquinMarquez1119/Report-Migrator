# Simplificacion de estructura por reporte

## Objetivo

Reducir la profundidad y la cantidad de carpetas necesarias para trabajar en un reporte.

La nueva estructura debe cumplir estas metas:

- Al abrir la carpeta del reporte, el archivo `.rdl` final debe estar visible en el nivel superior.
- Debe ser evidente donde colocar cada tipo de input sin tener que navegar por ramas largas.
- Cada reporte se trata como una unidad individual, sin depender de una jerarquia adicional.
- La estructura debe ser facil de replicar al iniciar un reporte nuevo.

## Problemas de la estructura actual

La estructura actual concentra la complejidad dentro de `reports/`:

- Existe una jerarquia adicional entre la carpeta agrupadora y el reporte.
- Los insumos estan repartidos entre `source/`, `shared/`, `reports/`, `output/` y `working/`.
- El `.rdl` queda demasiado enterrado en el arbol.
- Para agregar un reporte nuevo hay que recordar demasiadas carpetas y convenciones.

## Estructura propuesta

Cada reporte vive directamente bajo `reports/<reporte>/`.

```text
reports/
  <reporte>/
    <reporte>.rdl
    report.yaml
    inputs/
      xml-spec/
      queries/
      screenshots/
      pdf/
      notes/
      exports/
    work/
    validations/
    docs/
```

## Reglas de uso

### Nivel superior del reporte

- `<reporte>.rdl`: version principal del reporte. Debe quedar visible apenas se abre la carpeta.
- `report.yaml`: metadata, estado y referencias del reporte.

### `inputs/`

Contiene todos los insumos de entrada del reporte.

- `xml-spec/`: XML Spec de Cognos u otras especificaciones exportadas.
- `queries/`: consultas extraidas o material relacionado a queries.
- `screenshots/`: capturas de referencia, validacion o comparacion.
- `pdf/`: PDFs de referencia.
- `notes/`: notas manuales, observaciones funcionales y hallazgos.
- `exports/`: exportaciones auxiliares provenientes de Cognos u otras herramientas.

Principio: si algo sirve como referencia o fuente para construir el reporte, va en `inputs/`.
Los subdirectorios opcionales `assets/` y `mappings/` solo se agregan cuando un reporte ya depende de esos materiales y conviene preservarlos.

### `work/`

Espacio de trabajo temporal.

- Archivos intermedios
- Versiones parciales
- Material generado que todavia no corresponde promover
- Ediciones manuales en progreso

Principio: si no es un input original y todavia no es un resultado final, va en `work/`.

### `validations/`

Resultados de validacion del reporte.

- Comparaciones
- Checks manuales o automaticos
- Evidencia de validacion final

### `docs/`

Documentacion corta y especifica del reporte.

- decisiones
- aclaraciones funcionales
- notas de implementacion que no correspondan a `notes/`

## Convenciones

- No introducir una capa adicional de agrupacion salvo que en el futuro aparezca una necesidad real de agrupar reportes.
- No usar `shared/` por defecto.
- No crear subcarpetas nuevas fuera de este esquema sin una razon concreta.
- Mantener nombres predecibles y cortos.
- Cuando un tipo de input no exista, la carpeta puede quedar vacia o no crearse todavia.

## Flujo para crear un reporte nuevo

1. Crear `reports/<reporte>/`.
2. Crear `report.yaml`.
3. Dejar el `.rdl` principal en el nivel superior del reporte.
4. Crear `inputs/` y sus subcarpetas necesarias.
5. Crear `docs/` para decisiones, aclaraciones y notas del reporte.
6. Usar `work/` para trabajo intermedio.
7. Guardar evidencia final en `validations/`.

## Impacto esperado

- Menos tiempo buscando donde va cada archivo.
- Menor carga mental para iniciar un reporte nuevo.
- Mejor navegacion manual.
- Mejor contexto operativo para trabajar con agentes sobre un reporte puntual.

## Alcance de una futura migracion

Cuando se implemente esta reorganizacion:

- `reports/<familia>/reports/<reporte>/...` pasara a `reports/<reporte>/...`
- `source/cognos/*` y `source/evidence/*` se consolidaran dentro de `inputs/`
- `output/validation` pasara a `validations/`
- `working/*` pasara a `work/`
- El `.rdl` se movera al nivel superior del reporte

## Fuera de alcance por ahora

- Cambios en el contenido interno de los archivos `.rdl`
- Automatizaciones nuevas
- Rediseno de `core/`, `knowledge/`, `intake/` o `tests/`
