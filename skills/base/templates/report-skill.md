---
name: report-{{SLUG}}
description: Bitácora Capa 3 del reporte "{{NOMBRE}}". Contiene playbook elegido, iteraciones, decisiones, evidencia y retrospectiva. Acoplada a este reporte — no reusable.
---

# {{NOMBRE}} — Bitácora de migración

> **Capa 3.** Vive con el reporte. No es reusable. Registra todo lo que pasó y por qué.
> Reglas y pasos genéricos viven en `skills/base/SKILL.md`. Patrón específico en el playbook listado abajo.

## Metadata rápida

- **Slug:** {{SLUG}}
- **Creado:** {{FECHA_ISO}}
- **Estado actual:** intake
- **Playbook(s) adoptado(s):** _pendiente — se define en el Paso 2_
- **Output esperado:** `reports/{{SLUG}}/output/{{NOMBRE_ARCHIVO_RDL}}.rdl`

## Inventario inicial de inputs

> Completar en el intake. Lo que falte va a `report.yaml:open_questions`.

- [ ] XML Spec (`inputs/xml-spec/`)
- [ ] Queries (`inputs/queries/`)
- [ ] PDF de referencia (`inputs/pdf/`)
- [ ] Screenshots (`inputs/screenshots/`)
- [ ] Mappings (`inputs/mappings/`)
- [ ] Assets (`inputs/assets/`)
- [ ] Notas funcionales (`inputs/notes/`)
- [ ] `.rdl` previo (si existe, sólo para verificar al final)

## Playbook elegido

_Llenar tras el Paso 2 (Match con playbook). Una sola entrada, o varias si es match combinado._

- **Playbook:** `skills/playbooks/<slug>.md`
- **Por qué encaja:** <señales observadas en los inputs>
- **Deltas / ajustes:** <qué del playbook no aplica tal cual>
- **Confirmado por el usuario:** <fecha>

## Inventario funcional

_Llenar antes de tocar el `.rdl`. Ver sección "Reglas universales de construcción" en `skills/base/SKILL.md`._

- Parámetros visibles: …
- Parámetros ocultos / normalizados: …
- Datasets de prompts: …
- Dataset principal: …
- Datasets auxiliares / lookups / ramas: …
- Columnas / medidas / data items calculados: …
- Filtros / orden / agrupaciones: …
- Reglas de visibilidad: …
- Drill-through (si aplica): …

## Iteraciones

> Una entrada por iteración. No borrar entradas viejas — tacharlas o marcarlas como superseded si cambian.

### {{FECHA_ISO}} — Iteración 1: <título corto>

- **Pregunta/problema:**
- **Decisión:**
- **Acción:** (archivos tocados, queries, cambios en el `.rdl`)
- **Evidencia:** (ruta a screenshot, valores comparados, etc.)
- **Próximo paso / bloqueante:**

<!-- agregar iteraciones siguientes acá -->

## Validación

_Evidencia comparable contra Cognos. Llenar en el Paso 4._

| # | Escenario | Parámetros | Esperado (Cognos) | Obtenido (RDL) | OK? | Evidencia |
|---|---|---|---|---|---|---|
| 1 |   |   |   |   |   |   |

## Reglas especiales / cutovers

_Cosas que no se pueden perder y no están en el playbook genérico._

- …

## Open questions

_Mover al `report.yaml:open_questions` también si bloquea el próximo paso._

- …

## Retrospectiva

_Llenar sólo cuando `report.yaml:status` pase a `done` y el usuario acepte hacer la retro._

### Lecciones

1. **Lección:** …
   - **Categoría:** local | refuerza playbook | playbook nuevo | regla universal | automatizable
   - **Acción propuesta:** …
   - **Aprobado:** sí/no — <fecha>
   - **Materializado en:** <link al archivo editado/creado>

### Cambios propagados

- …
