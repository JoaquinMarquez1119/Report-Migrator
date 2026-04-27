# Migrador Reportes

Workspace para migrar reportes de IBM Cognos Analytics a Power BI Report Builder (`.rdl`).

## Punto de entrada

- **`AGENTS.md`** — ritual de arranque obligatorio para cualquier agente (Claude, Codex, Cursor, etc.)
- **`STATUS.md`** — índice de todos los reportes: estado actual y próxima acción

## Estructura

```
reports/<slug>/               — Un reporte por carpeta
  report.yaml                 — Estado, inputs, outputs, next_action, last_touched
  SKILL.md                    — Bitácora: iteraciones, decisiones, validación, open questions
  inputs/                     — Insumos Cognos (xml-spec, queries, pdf, screenshots, mappings)
  output/                     — .rdl final + evidencia de validación

skills/
  base/SKILL.md               — Reglas universales y ciclo de vida (Capa 1)
  playbooks/playbook-*/       — Patrones por tipo de reporte, instalados como skills (Capa 2)
  components/component-*/     — Elementos RDL reutilizables, instalados como skills (Capa 2b)

tools/
  sync-skills.sh              — Sincroniza skills instalados con el repo (correr al arrancar)
  scripts/                    — Scripts PowerShell de generación
  validation/                 — Scripts de validación estructural de .rdl

_archive/                     — Material histórico (pre-reorganización 2026-04-16)
```

## Ciclo de vida de un reporte

```
intake → in-progress → review → done
```

El estado vive en `report.yaml` de cada reporte. `STATUS.md` es el índice consolidado.

## Convenciones

- Cognos es la fuente de verdad. El `.rdl` se valida contra Cognos, no al revés.
- Cada reporte es standalone: tiene sus propios inputs, output y bitácora.
- Las bitácoras (`SKILL.md`) son inmutables: se agregan entradas, no se reescriben.
- Si un patrón aparece en más de un reporte, se promueve a `skills/playbooks/` o `skills/components/`.
- Drafts de playbooks: prefijo `_` en el nombre de la carpeta — el script de sync los saltea.
