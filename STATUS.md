# STATUS.md — Índice de reportes

> Actualizar al terminar cada sesión de trabajo. Es el punto de entrada rápido para cualquier agente.
> Para contexto completo de un reporte: leer `reports/<slug>/report.yaml` y `reports/<slug>/SKILL.md`.

## Estado actual del proyecto

| Reporte | Status | Owner | Próxima acción |
|---|---|---|---|
| [precios-unitarios-ex-planta-base](reports/precios-unitarios-ex-planta-base/report.yaml) | done | — | Cerrado. Retrospectiva completada 2026-04-20. |
| [precios-unitarios-ex-planta-detalle](reports/precios-unitarios-ex-planta-detalle/report.yaml) | done | — | Cerrado. Retrospectiva completada 2026-05-05. |
| [tc-promedio-mensual](reports/tc-promedio-mensual/report.yaml) | done | — | Cerrado. Retrospectiva pendiente si el usuario quiere hacerla. |

## Leyenda

- **Status:** `intake` → `in-progress` → `review` → `done`
- **Owner:** quién tiene la pelota ahora
  - `user` — el agente no debe avanzar sin confirmación del usuario
  - `agent` — el agente puede retomar desde la descripción en `report.yaml:next_action`
  - `—` — cerrado, sin acción pendiente

## Cómo actualizar

Al cerrar una sesión de trabajo en un reporte:
1. Editar la fila correspondiente con el nuevo status y próxima acción.
2. Asegurarse de que `report.yaml:next_action` y `report.yaml:last_touched` estén sincronizados.
3. Commitear junto con los cambios coherentes de la sesión o unidad lógica. No hacer un commit por cada iteración de la bitácora.

## Reportes futuros

_Agregar fila cuando se haga el intake de un reporte nuevo._
