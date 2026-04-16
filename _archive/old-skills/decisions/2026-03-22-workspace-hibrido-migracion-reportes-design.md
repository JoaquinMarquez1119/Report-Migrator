# Diseno: Workspace hibrido para migracion de familias de reportes Cognos a Power BI Report Builder

> Historical note: this document records a retired intermediate family-based layout. The active workspace model now uses standalone report folders under `reports/<reporte>/`.

Fecha: 2026-03-22
Estado: Aprobado en conversacion

## Objetivo

Ordenar este workspace para que soporte la migracion progresiva de muchas familias de reportes desde IBM Cognos Analytics 11 hacia Microsoft Power BI Report Builder, combinando:

- trabajo operativo por cada familia de reportes y por cada reporte individual
- un nucleo reutilizable para automatizacion
- documentacion y skills locales al proyecto para mejorar el agente con cada migracion

## Decisiones aprobadas

- Se adopta un enfoque hibrido: nucleo comun reusable mas carpetas por reporte.
- Se crea una carpeta base `reports/` para agrupar todos los reportes del proyecto.
- Cada familia funcional de reportes tendra su propia carpeta dentro de `reports/`.
- Cada reporte individual tendra una carpeta de trabajo completa y una ficha estandar `report.yaml`.
- La fuente de conocimiento del agente vivira solo dentro de este proyecto, bajo `knowledge/`.
- La reorganizacion inicial sera intermedia: se renombra y reubica con una convencion estable, sin intentar convertir todo el workspace en framework completo desde el primer paso.
- Los aprendizajes se registraran como patrones generales reutilizables, no solo como notas del caso puntual.

## Estructura objetivo

```text
Migrador Reportes/
  README.md
  reports/
    <slug-familia>/
      family.yaml
      source/
        cognos/
          xml-spec/
          queries/
          exports/
        evidence/
          screenshots/
          pdf/
          notes/
      reports/
        base/
          report.yaml
          working/
            power-bi-report-builder/
              base/
              generated/
              manual-edits/
          output/
            rdl/
            validation/
          docs/
            migration-notes.md
            decisions.md
        detalle/
          report.yaml
          working/
            power-bi-report-builder/
              base/
              generated/
              manual-edits/
          output/
            rdl/
            validation/
          docs/
            migration-notes.md
            decisions.md
      shared/
        mappings/
        assets/
        validations/
      docs/
        family-notes.md
        drillthrough.md
  core/
    generators/
    parsers/
    validators/
    mappings/
    templates/
    shared/
  knowledge/
    docs/
      process/
      decisions/
      troubleshooting/
      patterns/
    skills/
    checklists/
    examples/
  intake/
    pending/
    normalized/
  tests/
    unit/
    integration/
    regression/
```

## Principios de organizacion

### 1. Separacion por responsabilidad

- `reports/` concentra el trabajo de cada familia funcional y de cada reporte individual.
- `core/` guarda piezas reutilizables para automatizacion y validacion.
- `knowledge/` concentra el aprendizaje operativo del proyecto.
- `intake/` evita mezclar material crudo con reportes ya normalizados.
- `tests/` pasa a ser infraestructura comun, no una bolsa de scripts sueltos por caso.

### 2. Convencion estable de nombres

- Cada familia de reportes usa un `slug` en `kebab-case`, por ejemplo `precios-unitarios-ex-planta`.
- Dentro de cada familia, los reportes individuales pueden identificarse como `base`, `detalle`, `resumen` u otro nombre funcional corto.
- El `slug` se usa en carpetas, archivos tecnicos y referencias internas.
- El nombre visible del reporte puede conservar espacios y mayusculas en documentacion y entregables.

### 3. Frontera clara entre insumo, trabajo y salida

- `source/` contiene insumos originales o copias ordenadas de Cognos y evidencia.
- `shared/` contiene activos y reglas que se comparten dentro de la misma familia.
- `working/` es la zona de construccion del reporte individual.
- `output/` contiene entregables ya validados o candidatos a entrega.

## Modelo por familia y por reporte

Cada familia de reportes tendra un `family.yaml` con campos minimos:

- `id`
- `name`
- `slug`
- `reports`
- `shared_assets`
- `cross_report_patterns`
- `open_questions`

Cada reporte individual tendra un `report.yaml` como ficha obligatoria. Campos minimos:

- `id`
- `name`
- `slug`
- `status`: `intake`, `analysis`, `mapping`, `build`, `validation`, `done`
- `priority`
- `source_of_truth`
- `inputs`
- `outputs`
- `decisions`
- `open_questions`

## Patron general: familias con drill-through

El proyecto debe capturar como conocimiento reusable los casos donde un reporte principal dispara uno o mas reportes independientes via `drill-through`.

Para estos casos:

- los reportes relacionados viven dentro de la misma familia
- la relacion funcional se documenta en `docs/drillthrough.md`
- los parametros compartidos, mappings y decisiones transversales van a `shared/`
- el patron general se promueve a `knowledge/docs/patterns/`

Este patron nace del caso `Precios Unitarios Ex Planta` + `Precios Unitarios Ex Planta - detalle`, pero se documentara como una regla general del proceso.

## Regla de fuente de verdad

No se usara un unico artefacto como verdad absoluta. En cambio, cada reporte declarara en `report.yaml` que artefacto manda para cada aspecto:

- layout visual
- prompts y navegacion
- logica de negocio
- datasets o consultas
- validacion visual

Esto permite trabajar con XML Spec, consultas, PDFs, screenshots y notas sin forzar una simplificacion incorrecta.

## Flujo operativo por reporte

1. Ingresar material crudo en `intake/` o directamente en `reports/<slug-familia>/source/`.
2. Completar `family.yaml` y luego `report.yaml` para cada reporte involucrado.
3. Declarar fuente de verdad por tipo de informacion.
4. Documentar el mapeo Cognos -> Report Builder en `docs/migration-notes.md`.
5. Documentar relaciones entre reportes en `docs/drillthrough.md` cuando aplique.
6. Construir o ajustar artefactos en `working/`.
7. Publicar resultados validados en `output/`.
8. Promover aprendizaje reusable a `knowledge/` o `core/`.

## Reglas de promocion de conocimiento

- Si algo sirve para un solo reporte, queda en `reports/<slug-familia>/reports/<reporte>/docs/`.
- Si algo sirve para una familia completa, queda en `reports/<slug-familia>/docs/` o `shared/`.
- Si sirve para varios reportes, pasa a `knowledge/docs/`.
- Si es automatizable o ejecutable, pasa a `core/`.
- Si es un procedimiento repetible para el agente, se formaliza en `knowledge/skills/`.

## Conocimiento del agente dentro del proyecto

El proyecto mantendra sus propias skills y documentacion operativa dentro de `knowledge/`.

Primeras skills recomendadas:

- `cognos-report-family-intake`
- `cognos-to-rdl-report-creation`
- `rdl-validation`
- `migration-retrospective`

Primeras areas documentales recomendadas:

- `knowledge/docs/process/`
- `knowledge/docs/troubleshooting/`
- `knowledge/docs/patterns/`
- `knowledge/checklists/`
- `knowledge/examples/`

Primeros patrones generales a registrar:

- `drillthrough-nested-reports`
- `parameter-normalization`
- `cognos-tabbed-report-to-rdl`
- `shared-assets-across-related-reports`

## Aplicacion al workspace actual

El workspace ya contiene material valioso en:

- `Precios Unitarios Ex Planta`
- `TC Promedio Mensual`
- `scripts`
- `tests`
- `docs/superpowers`

La reorganizacion inicial debe:

- conservar ese material
- moverlo a la estructura estandar aprobada
- agrupar `Precios Unitarios Ex Planta` y `Precios Unitarios Ex Planta - detalle` en una misma familia
- tratar `TC Promedio Mensual` como otra familia inicial
- migrar el conocimiento existente desde `docs/superpowers` hacia `knowledge/`
- minimizar cambios profundos de implementacion en esta primera pasada
- dejar una base lista para sumar muchos reportes a futuro

## Riesgos y consideraciones

- El directorio actual no es un repositorio git, por lo que no se puede cumplir el paso de commit del spec dentro de este workspace.
- Hay material ya creado con nombres historicos; la reorganizacion debe evitar romper referencias sin necesidad.
- Parte del conocimiento actual esta mezclado dentro de casos concretos; habra que promoverlo gradualmente a `knowledge/` y `core/`.
- El caso de reportes relacionados por drill-through requiere una estructura que preserve independencia tecnica y relacion funcional a la vez.

## Siguiente paso esperado

La siguiente fase debe traducir este diseno en un plan concreto de implementacion para:

- crear la estructura base
- reubicar el material actual
- crear la documentacion inicial
- sembrar las primeras skills locales genericas del proyecto
- registrar el patron de drill-through entre reportes relacionados
