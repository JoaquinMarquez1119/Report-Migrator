# Migration Log — Reorganización a arquitectura de 3 capas

**Estado:** EJECUTADO — ver sección 6 para el detalle de movimientos aplicados.
**Baseline commit:** `fd72eca baseline pre-reorganization`
**Reorg commit:** `7548af9 reorg: move artifacts to 3-layer structure (skills archived pending reconstruction)`
**Fecha:** 2026-04-16

---

## 0. Arquitectura objetivo (recordatorio)

```
report-migrator/
├── skills/
│   ├── base/                    (Capa 1: genérico Cognos→RDL)    — vacío esta sesión
│   └── playbooks/               (Capa 2: por patrón de reporte) — vacío esta sesión
├── reports/                     (Capa 3: uno por reporte)
│   └── <nombre-reporte>/
│       ├── inputs/
│       ├── output/
│       └── notes.md
├── _archive/
│   └── old-skills/              (todo el conocimiento actual, intacto)
└── MIGRATION_LOG.md
```

Reglas: sólo `mv`, nunca `rm`. Sin modificar contenido. Esta sesión sólo mueve; la reconstrucción de `skills/base` y `skills/playbooks` queda para después.

---

## 1. Auditoría — clasificación del estado actual

### Totales
- 176 archivos versionados en el baseline.
- Top-level: `README.md`, `.gitignore`, `knowledge/`, `reports/`, `tools/`, `.qodo/`.

### (a) Artefactos de entrada de reporte
Todo lo bajo `reports/<reporte>/inputs/**`: XML spec, mappings, queries SQL, diagramas PNG, PDFs, screenshots de Cognos / report-reference / validation, assets (logos), notas (`inputs/notes/modelo-de-datos.txt`), docs de negocio (`AnalisisExPLANTA.xlsx`, `Documentacion Precio ExPlanta.docx`).

Se distribuyen así:
- `reports/tc-promedio-mensual/inputs/` — xml-spec, pdf, screenshots.
- `reports/precios-unitarios-ex-planta-base/inputs/` — xml-spec, pdf, queries, screenshots (con 3 subcarpetas de validación), mappings, assets.
- `reports/precios-unitarios-ex-planta-detalle/inputs/` — xml-spec, pdf, queries, screenshots, mappings (incluye behavior-matrix), assets, notes, docs.

### (b) Artefactos de salida de reporte
- `reports/tc-promedio-mensual/TC_promedio_mensual_base.rdl`
- `reports/precios-unitarios-ex-planta-base/Precios_unitarios_ex_planta_base.rdl`
- `reports/precios-unitarios-ex-planta-detalle/Precios Unitarios Ex Planta - detalle.rdl`
- Cada reporte trae además `report.yaml` (metadata), `work/power-bi-report-builder/{base,generated,manual-edits}` (vacíos hoy), `validations/` (vacío hoy), `docs/` (vacío en base/tc-promedio-mensual; en detalle contiene `drillthrough.md` y `migration-notes.md`).

### (c) Skills destiladas por reporte (con frontmatter formal)
Ninguna skill formal (con `name:/description:` frontmatter) es "por reporte". Todas las que tienen frontmatter son globales o patrones. Lo que SÍ es por reporte vive en `knowledge/agent/plans/` y `knowledge/agent/specs/` como planes/diseños de implementación con alcance a un reporte específico:
- `knowledge/agent/plans/2026-03-23-precios-unitarios-ex-planta-detalle.md` — plan de construcción del detalle.
- `knowledge/agent/plans/2026-03-26-precios-unitarios-ex-planta-base-layout-plan.md` — plan de ajuste geométrico del base.
- `knowledge/agent/plans/2026-03-26-precios-unitarios-ex-planta-detalle-matrix-plan.md` — plan de matriz interna del detalle.
- `knowledge/agent/specs/2026-03-26-precios-unitarios-ex-planta-base-layout-design.md` — spec del layout del base.
- `knowledge/agent/specs/2026-03-26-precios-unitarios-ex-planta-detalle-matrix-design.md` — spec de la matriz del detalle.
- `knowledge/decisions/2026-03-22-precios-unitarios-ex-planta-detalle-design.md` — decisión de diseño del detalle.
- `knowledge/process/2026-03-22-precios-unitarios-ex-planta-detalle.md` — plan histórico del detalle (marcado como retired).

### (d) Skills globales / generales (con frontmatter formal o rol equivalente)
- `knowledge/agent/skills/cognos-report-family-intake.md` — checklist genérico de intake de un reporte/familia nueva.
- `knowledge/agent/skills/cognos-to-rdl-report-creation.md` — guía genérica Cognos→RDL.
- `knowledge/agent/skills/cognos-to-report-builder-behavior-matrix.md` — cómo deducir matriz de comportamiento (aplica cuando el reporte no es lineal).
- `knowledge/agent/skills/migration-retrospective.md` — checklist para cerrar una migración y decidir qué promover.
- `knowledge/agent/skills/rdl-validation.md` — validaciones genéricas de `.rdl`.
- `knowledge/agent/skills/migrar-reportes-cognos/SKILL.md` + `references/artifacts-checklist.md` + `references/handoff-template.md` + `agents/openai.yaml` — skill empaquetada, flujo end-to-end de migración.
- `knowledge/patterns/cognos-query-first-report-migrations.md` — patrón: las queries mandan, no el layout.
- `knowledge/patterns/drillthrough-nested-reports.md` — patrón: drill-through entre reportes standalone.
- `knowledge/examples/cognos-behavior-matrix-template.md` — plantilla de matriz de comportamiento.
- `knowledge/process/guia-migracion-exacta-cognos-a-report-builder.md` — guía transversal de migración.
- `knowledge/process/workspace-organization.md` — reglas de organización del workspace (standalone por reporte).
- `knowledge/troubleshooting/report-builder-rdl-troubleshooting-seed.md` — seed de errores reales y correcciones.
- `knowledge/agent/plans/2026-03-22-report-structure-simplification.md` — plan de simplificación estructural (global).
- `knowledge/agent/specs/2026-03-22-report-structure-simplification-design.md` — spec asociada.
- `knowledge/decisions/2026-03-22-workspace-hibrido-migracion-reportes-design.md` — decisión histórica (marcada como retired).
- `knowledge/process/2026-03-22-workspace-reorganization.md` — plan histórico (marcado como retired).

### (e) Configuración / scripts / utilidades
- `tools/scripts/build_precios_unitarios_detalle_rdl.ps1` — generador PowerShell del `.rdl` detalle.
- `tools/validation/validate_precios_unitarios_ex_planta_base_layout.ps1` — validación estructural del base.
- `tools/validation/validate_precios_unitarios_ex_planta_detalle.ps1` — validación estructural del detalle.
- `.qodo/agents/` y `.qodo/workflows/` — aparentemente vacíos (sin archivos versionados). Config de agente Qodo.
- `.gitignore` — recién agregado en esta sesión.
- `README.md` — describe la estructura actual.

### (f) Desconocido / requiere tu input
Ver sección **4. Preguntas abiertas**. En particular `tools/`, `.qodo/`, `README.md`, el subárbol interno de `reports/<nombre>/`, y los planes/specs por reporte bajo `knowledge/agent/`.

### Resumen de contenido de cada skill (1-2 líneas, sin juicio aún)
Ver clasificación arriba (sección c y d); cada bullet incluye qué conocimiento contiene.

---

## 2. Mapeo propuesto (archivo → destino)

### 2.1 Skills y conocimiento → `_archive/old-skills/`
**Regla:** todo `knowledge/**` se mueve intacto bajo `_archive/old-skills/`, preservando la jerarquía interna (`agent/skills/`, `agent/plans/`, `agent/specs/`, `decisions/`, `examples/`, `patterns/`, `process/`, `troubleshooting/`).

| Origen | Destino | Razón |
|---|---|---|
| `knowledge/agent/skills/cognos-report-family-intake.md` | `_archive/old-skills/agent/skills/cognos-report-family-intake.md` | Skill global, pendiente reconstrucción en `skills/base/`. |
| `knowledge/agent/skills/cognos-to-rdl-report-creation.md` | `_archive/old-skills/agent/skills/cognos-to-rdl-report-creation.md` | Skill global. |
| `knowledge/agent/skills/cognos-to-report-builder-behavior-matrix.md` | `_archive/old-skills/agent/skills/cognos-to-report-builder-behavior-matrix.md` | Skill global / candidata a playbook. |
| `knowledge/agent/skills/migration-retrospective.md` | `_archive/old-skills/agent/skills/migration-retrospective.md` | Skill global. |
| `knowledge/agent/skills/rdl-validation.md` | `_archive/old-skills/agent/skills/rdl-validation.md` | Skill global. |
| `knowledge/agent/skills/migrar-reportes-cognos/**` (4 archivos) | `_archive/old-skills/agent/skills/migrar-reportes-cognos/**` | Skill empaquetada completa. |
| `knowledge/agent/plans/*.md` (4 archivos) | `_archive/old-skills/agent/plans/*.md` | Planes de implementación (3 específicos, 1 global). |
| `knowledge/agent/specs/*.md` (3 archivos) | `_archive/old-skills/agent/specs/*.md` | Specs de diseño (2 específicos, 1 global). |
| `knowledge/decisions/*.md` (2 archivos) | `_archive/old-skills/decisions/*.md` | Decisiones (1 específica, 1 retired). |
| `knowledge/examples/cognos-behavior-matrix-template.md` | `_archive/old-skills/examples/cognos-behavior-matrix-template.md` | Plantilla reutilizable. |
| `knowledge/patterns/*.md` (2 archivos) | `_archive/old-skills/patterns/*.md` | Patrones — candidatos a `skills/playbooks/`. |
| `knowledge/process/*.md` (4 archivos) | `_archive/old-skills/process/*.md` | Procesos (2 activos, 2 retired). |
| `knowledge/troubleshooting/report-builder-rdl-troubleshooting-seed.md` | `_archive/old-skills/troubleshooting/report-builder-rdl-troubleshooting-seed.md` | Seed de troubleshooting. |
| (carpeta vacía) `knowledge/` | eliminada por git tras el `mv` (directorios sin archivos no se versionan). | — |

**Nota:** los planes/specs que son "por reporte" (los 7 listados en §1.c) quedan en `_archive/old-skills/agent/plans|specs|decisions|process/` junto al resto. **NO** los muevo a `reports/<nombre>/` en esta sesión porque (1) tu arquitectura objetivo no prevé ese tipo de doc adentro de `reports/<nombre>/` más allá de `notes.md`, y (2) el criterio de "sólo mover, no modificar contenido" haría incómodo consolidarlos en un `notes.md`. **Confirmar en pregunta Q5.**

### 2.2 Reportes → se quedan donde están
Los 3 reportes ya viven en `reports/<nombre>/`, coincidente con Capa 3. Sin movimiento de archivos en esta sesión para lo interno — ver pregunta Q1 sobre si reorganizamos el interior (`inputs/ + output/ + notes.md` vs. el actual `inputs/ + work/ + validations/ + docs/ + .rdl + report.yaml`).

### 2.3 tools/, .qodo/, README.md, .gitignore
Ver preguntas Q2, Q3, Q4.

---

## 3. Casos dudosos marcados explícitamente

Los agrupo en la sección 4 como preguntas directas.

---

## 4. Preguntas abiertas (necesito tu input antes del Paso 4)

### Q1 — Interior de `reports/<nombre>/`
Tu arquitectura objetivo dice:
```
reports/<nombre>/
├── inputs/
├── output/
└── notes.md
```
Lo actual es:
```
reports/<nombre>/
├── inputs/            (OK, coincide)
├── work/              (subcarpetas generated/base/manual-edits, hoy vacías)
├── validations/       (hoy vacías)
├── docs/              (en detalle: drillthrough.md + migration-notes.md; en otros: vacía)
├── <Nombre>.rdl       (el artefacto final a la raíz)
└── report.yaml        (metadata)
```
**Opciones:**
- **(a) No tocar el interior esta sesión.** Deja `reports/<nombre>/` tal cual. La adopción de `output/` + `notes.md` queda para una sesión de contenido (ya que `notes.md` requeriría consolidar docs/, y crear un archivo nuevo es contenido). **Recomendado por mí dada la regla 2.**
- **(b) Mover `.rdl` + `work/` + `validations/` a `output/`**, consolidar `docs/` → `_archive/old-skills/per-report/<nombre>/docs/`, dejar `report.yaml` donde está. Sin crear `notes.md` (sería contenido nuevo).
- **(c) Otra variante tuya.**

### Q2 — `tools/` (PowerShell scripts)
Son scripts operativos (no conocimiento destilado): generador del detalle + 2 validadores. Tu arquitectura objetivo no lista `tools/`.
**Opciones:**
- **(a) Mantener `tools/` en la raíz.** No es skill, es ejecutable. **Recomendado por mí.**
- **(b) Mover a `_archive/old-skills/tools/`** como histórico congelado.
- **(c) Mover a `reports/<nombre>/output/scripts/`** asociando cada script al reporte que genera/valida (requiere elegir el dueño de cada script).

### Q3 — `.qodo/`
Carpeta de config de agente Qodo con `agents/` y `workflows/` sin archivos versionados. No hay contenido real que mover.
**Opciones:**
- **(a) Dejarla en la raíz** (es config, no skill). **Recomendado.**
- **(b) Mover `.qodo/` a `_archive/old-skills/.qodo/`.**

### Q4 — `README.md`
Describe la estructura actual (`reports/`, `knowledge/`, `tools/`), por lo que queda desactualizado post-reorganización. La regla dice "no modificar contenido".
**Opciones:**
- **(a) Dejarlo en la raíz sin tocar** y encarar su rewrite en una sesión de contenido posterior. **Recomendado.**
- **(b) Moverlo a `_archive/old-skills/README.md`** y dejar el root sin README hasta que se reescriba.

### Q5 — Planes/specs por reporte
Los 7 documentos listados en §1.c (bajo `knowledge/agent/plans/`, `knowledge/agent/specs/`, `knowledge/decisions/`, `knowledge/process/`) son específicos de un reporte puntual. En mi propuesta los mando todos a `_archive/old-skills/` junto al resto.
**Opciones:**
- **(a) Todos a `_archive/old-skills/...`** (preserva jerarquía; simple; sin mod de contenido). **Recomendado.**
- **(b) Moverlos a `reports/<nombre>/notes/`** o similar, anexándolos al reporte correspondiente (rompe ligeramente la arquitectura objetivo porque introduce `notes/` en vez de `notes.md`).

### Q6 — Nombre del repo / directorio raíz
Tu arquitectura habla de `report-migrator/` como raíz conceptual, pero el directorio real es `Migrador Reportes`. **No propongo renombrarlo** (es el directorio de Windows y podría romper rutas externas). Confirmame si querés que lo trate sólo como nombre conceptual.

### Q7 — Reporte a mitad sin resolver
Mencionás "Drill de Precios Unitarios Ex Planta" como el 3° a mitad. El repo tiene `precios-unitarios-ex-planta-detalle/` con `status: in-progress` en su `report.yaml`. ¿Es ése el que está a mitad, o hay otro que todavía no está en el directorio y que vamos a crear en `reports/<nombre-del-drill>/`? Si es el mismo, no hay acción en esta sesión.

---

## 5. Plan de ejecución (sólo tras tu OK)

Orden propuesto:
1. Crear `skills/base/`, `skills/playbooks/`, `_archive/`, `_archive/old-skills/` (directorios vacíos con `.gitkeep` para que git los registre).
2. `git mv knowledge/* _archive/old-skills/` preservando estructura (7 subárboles).
3. Resolver Q1–Q7 según tu input.
4. Commit: `reorg: move artifacts to 3-layer structure (skills archived pending reconstruction)`.
5. Actualizar esta sección de `MIGRATION_LOG.md` con el detalle de movimientos efectivamente ejecutados (timestamps, hashes, conteos).

**No ejecuto nada hasta que me digas OK y respondas Q1–Q7.**

---

## 6. Ejecución (2026-04-16)

**Decisión del usuario:** seguir las recomendaciones (a) para Q1–Q5, y las confirmaciones por defecto para Q6/Q7.

### 6.1 Resumen de decisiones aplicadas
- **Q1 (a):** El interior de `reports/<nombre>/` queda intacto (no se crea `output/` ni `notes.md` en esta sesión; la adopción de ese layout requiere consolidación de contenido y se posterga).
- **Q2 (a):** `tools/` se mantiene en la raíz.
- **Q3 (a):** `.qodo/` se mantiene en la raíz.
- **Q4 (a):** `README.md` se mantiene en la raíz sin modificar (rewrite pendiente).
- **Q5 (a):** Los 7 planes/specs/decisiones específicos de un reporte viajan junto al resto de `knowledge/` hacia `_archive/old-skills/` preservando su jerarquía original (sin desparramarlos a cada `reports/<nombre>/`).
- **Q6:** `report-migrator` se toma como nombre conceptual; el directorio real `Migrador Reportes` no se renombra.
- **Q7:** El reporte "in-progress" se identifica con `reports/precios-unitarios-ex-planta-detalle/` (su `report.yaml` ya tiene `status: in-progress`); no se crea ningún 4° reporte.

### 6.2 Operaciones realizadas

Todas por `git mv` (history preservada). Sin eliminaciones. Sin modificaciones de contenido en archivos preexistentes al baseline.

**Creación de directorios nuevos** (tras el `git mv` los que quedan vacíos llevan `.gitkeep` para que git los rastree):
- `skills/base/.gitkeep` — vacío, pendiente reconstrucción Capa 1.
- `skills/playbooks/.gitkeep` — vacío, pendiente reconstrucción Capa 2.
- `_archive/` — contenedor.
- `_archive/old-skills/` — destino del archivado (lo crea implícitamente el `git mv`).

**Movimientos** (26 archivos renombrados):

| Origen | Destino |
|---|---|
| `knowledge/agent/plans/2026-03-22-report-structure-simplification.md` | `_archive/old-skills/agent/plans/2026-03-22-report-structure-simplification.md` |
| `knowledge/agent/plans/2026-03-23-precios-unitarios-ex-planta-detalle.md` | `_archive/old-skills/agent/plans/2026-03-23-precios-unitarios-ex-planta-detalle.md` |
| `knowledge/agent/plans/2026-03-26-precios-unitarios-ex-planta-base-layout-plan.md` | `_archive/old-skills/agent/plans/2026-03-26-precios-unitarios-ex-planta-base-layout-plan.md` |
| `knowledge/agent/plans/2026-03-26-precios-unitarios-ex-planta-detalle-matrix-plan.md` | `_archive/old-skills/agent/plans/2026-03-26-precios-unitarios-ex-planta-detalle-matrix-plan.md` |
| `knowledge/agent/skills/cognos-report-family-intake.md` | `_archive/old-skills/agent/skills/cognos-report-family-intake.md` |
| `knowledge/agent/skills/cognos-to-rdl-report-creation.md` | `_archive/old-skills/agent/skills/cognos-to-rdl-report-creation.md` |
| `knowledge/agent/skills/cognos-to-report-builder-behavior-matrix.md` | `_archive/old-skills/agent/skills/cognos-to-report-builder-behavior-matrix.md` |
| `knowledge/agent/skills/migrar-reportes-cognos/SKILL.md` | `_archive/old-skills/agent/skills/migrar-reportes-cognos/SKILL.md` |
| `knowledge/agent/skills/migrar-reportes-cognos/agents/openai.yaml` | `_archive/old-skills/agent/skills/migrar-reportes-cognos/agents/openai.yaml` |
| `knowledge/agent/skills/migrar-reportes-cognos/references/artifacts-checklist.md` | `_archive/old-skills/agent/skills/migrar-reportes-cognos/references/artifacts-checklist.md` |
| `knowledge/agent/skills/migrar-reportes-cognos/references/handoff-template.md` | `_archive/old-skills/agent/skills/migrar-reportes-cognos/references/handoff-template.md` |
| `knowledge/agent/skills/migration-retrospective.md` | `_archive/old-skills/agent/skills/migration-retrospective.md` |
| `knowledge/agent/skills/rdl-validation.md` | `_archive/old-skills/agent/skills/rdl-validation.md` |
| `knowledge/agent/specs/2026-03-22-report-structure-simplification-design.md` | `_archive/old-skills/agent/specs/2026-03-22-report-structure-simplification-design.md` |
| `knowledge/agent/specs/2026-03-26-precios-unitarios-ex-planta-base-layout-design.md` | `_archive/old-skills/agent/specs/2026-03-26-precios-unitarios-ex-planta-base-layout-design.md` |
| `knowledge/agent/specs/2026-03-26-precios-unitarios-ex-planta-detalle-matrix-design.md` | `_archive/old-skills/agent/specs/2026-03-26-precios-unitarios-ex-planta-detalle-matrix-design.md` |
| `knowledge/decisions/2026-03-22-precios-unitarios-ex-planta-detalle-design.md` | `_archive/old-skills/decisions/2026-03-22-precios-unitarios-ex-planta-detalle-design.md` |
| `knowledge/decisions/2026-03-22-workspace-hibrido-migracion-reportes-design.md` | `_archive/old-skills/decisions/2026-03-22-workspace-hibrido-migracion-reportes-design.md` |
| `knowledge/examples/cognos-behavior-matrix-template.md` | `_archive/old-skills/examples/cognos-behavior-matrix-template.md` |
| `knowledge/patterns/cognos-query-first-report-migrations.md` | `_archive/old-skills/patterns/cognos-query-first-report-migrations.md` |
| `knowledge/patterns/drillthrough-nested-reports.md` | `_archive/old-skills/patterns/drillthrough-nested-reports.md` |
| `knowledge/process/2026-03-22-precios-unitarios-ex-planta-detalle.md` | `_archive/old-skills/process/2026-03-22-precios-unitarios-ex-planta-detalle.md` |
| `knowledge/process/2026-03-22-workspace-reorganization.md` | `_archive/old-skills/process/2026-03-22-workspace-reorganization.md` |
| `knowledge/process/guia-migracion-exacta-cognos-a-report-builder.md` | `_archive/old-skills/process/guia-migracion-exacta-cognos-a-report-builder.md` |
| `knowledge/process/workspace-organization.md` | `_archive/old-skills/process/workspace-organization.md` |
| `knowledge/troubleshooting/report-builder-rdl-troubleshooting-seed.md` | `_archive/old-skills/troubleshooting/report-builder-rdl-troubleshooting-seed.md` |

**Razón única del movimiento** (aplica a los 26): archivado intacto de la capa de conocimiento actual bajo `_archive/old-skills/` para habilitar la reconstrucción posterior en `skills/base/` (Capa 1) y `skills/playbooks/` (Capa 2) sin pérdida ni edición del material original.

**No movidos (se mantienen por decisión explícita):**
- `README.md` (Q4a)
- `.gitignore` (creado esta sesión, actualizado para ignorar `.claude/`)
- `tools/**` (Q2a)
- `.qodo/**` (Q3a) — carpeta de config del agente Qodo; sin archivos versionados.
- `reports/**` (Q1a) — los 3 reportes con sus artefactos de entrada/salida se mantienen en su ubicación actual.

**Archivos nuevos creados esta sesión:**
- `.gitignore` (Paso 1; agregada entrada `.claude/` en Paso 4).
- `MIGRATION_LOG.md` (este documento).
- `skills/base/.gitkeep`, `skills/playbooks/.gitkeep` (placeholders para directorios vacíos).

### 6.3 Estructura resultante

```
.
├── .gitignore
├── .qodo/                    (sin cambios; sin archivos versionados)
├── MIGRATION_LOG.md          (nuevo)
├── README.md                 (sin cambios)
├── _archive/
│   └── old-skills/           (26 archivos, jerarquía preservada)
│       ├── agent/
│       │   ├── plans/        (4)
│       │   ├── skills/       (5 sueltos + migrar-reportes-cognos/)
│       │   └── specs/        (3)
│       ├── decisions/        (2)
│       ├── examples/         (1)
│       ├── patterns/         (2)
│       ├── process/          (4)
│       └── troubleshooting/  (1)
├── reports/
│   ├── precios-unitarios-ex-planta-base/    (sin cambios)
│   ├── precios-unitarios-ex-planta-detalle/ (sin cambios)
│   └── tc-promedio-mensual/                 (sin cambios)
├── skills/
│   ├── base/.gitkeep         (vacío, pendiente Capa 1)
│   └── playbooks/.gitkeep    (vacío, pendiente Capa 2)
└── tools/
    ├── scripts/              (sin cambios)
    └── validation/           (sin cambios)
```

### 6.4 Verificación
- `git status`: clean tras el commit.
- Nada eliminado (`git log --diff-filter=D` vacío para este commit).
- Todos los movimientos registrados como renames (100% similitud) — `git log --follow` funciona sobre cualquier archivo archivado.
