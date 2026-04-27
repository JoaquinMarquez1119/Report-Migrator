# AGENTS.md — Punto de entrada para cualquier agente

Este repo es un workspace de migración de reportes IBM Cognos Analytics → Power BI Report Builder.
Trabajan acá Claude, Codex, Aider, Cursor, o cualquier agente con acceso al repo.

## Ritual de arranque (obligatorio antes de tocar nada)

1. **Leer este archivo** — ya lo estás haciendo.
2. **Correr `bash tools/sync-skills.sh`** — sincroniza playbooks y componentes instalados con el estado actual del repo. Carpetas con prefijo `_` son drafts y se saltean.
3. **Leer `STATUS.md`** — índice de todos los reportes, cuál está activo, qué falta.
4. **Si el usuario ya pidió algo concreto:** ir al reporte → leer `reports/<slug>/report.yaml` → leer `reports/<slug>/SKILL.md`.
5. **Si el usuario no especificó:** preguntarle cuál reporte retomar, o si quiere empezar uno nuevo.

Los playbooks y componentes ya están disponibles como skills del sistema — no hace falta leerlos manualmente.

No empezar a generar código ni editar `.rdl` hasta haber hecho los pasos 1–4.

## Estructura del repo

```
reports/<slug>/           — Un reporte por carpeta
  report.yaml             — Estado, inputs, outputs, next_action, last_touched
  SKILL.md                — Bitácora: iteraciones, decisiones, validación, open questions
  inputs/                 — Insumos Cognos (xml-spec, queries, pdf, screenshots, mappings)
  output/                 — .rdl final + validación (reportes nuevos)
  [o .rdl en raíz]        — Layout heredado (reportes pre-arquitectura)

skills/base/SKILL.md      — Reglas universales, ciclo de vida completo
skills/base/templates/    — Templates para report.yaml y SKILL.md Capa 3
skills/playbooks/         — Patrones reutilizables (uno por archivo)
tools/                    — Scripts de validación y utilitarios
STATUS.md                 — Índice de estado de todos los reportes
```

## Cómo saber qué hacer ahora

1. Leer `STATUS.md` — la columna "Próxima acción" es el punto de continuación.
2. En `report.yaml` de cada reporte: campo `next_action.owner` dice si espera al **usuario** o al **agente**.
   - `owner: user` → no avanzar sin confirmación del usuario. Preguntarle si ya hizo la acción.
   - `owner: agent` → retomar desde `next_action.description`.
3. Campo `last_touched` → contexto de la última sesión (quién trabajó, qué hizo).

## Reglas duras

- Cognos es la fuente de verdad. El `.rdl` existente se valida contra Cognos, no al revés.
- Las iteraciones de las bitácoras (`SKILL.md`) son inmutables: no se reescriben, se agregan entradas nuevas.
- **Después de cada cambio sustantivo** (edición de `.rdl`, decisión de diseño, diagnóstico, revert, etc.): agregar nueva iteración en `reports/<slug>/SKILL.md` **sin esperar a que el usuario lo pida**. Formato: `### YYYY-MM-DD — Iteración N: <título>` con Pregunta/problema, Decisión, Acción, Evidencia, Próximo paso. Es parte del trabajo, no un paso opcional de cierre.
- Al terminar una sesión: actualizar `report.yaml` (`next_action`, `last_touched`), actualizar `STATUS.md`, commitear.
- No saltarse el ritual de arranque aunque el usuario diga "continuá directo".
- No mezclar trabajo de reportes distintos en el mismo commit.

## Ciclo de vida de un reporte

`intake` → `in-progress` → `review` → `done`

Cada transición de `status` en `report.yaml` dispara el siguiente paso del ciclo (ver `skills/base/SKILL.md`).

## Hoy trabajan acá

- **Claude Code** (claude-opus / claude-sonnet)
- **Codex** (OpenAI) — puede tomar sesiones cuando Claude no tiene créditos
- **Handoff:** el estado en `STATUS.md` + `report.yaml:next_action` es el contrato entre agentes.
