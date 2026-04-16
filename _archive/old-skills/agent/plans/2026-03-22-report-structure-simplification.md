# Report Structure Simplification Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reorganize `reports/` into a flat, report-first structure where each report folder exposes its `.rdl` at the top level and keeps all source material in predictable locations.

**Architecture:** Migrate one report at a time, preserving file contents while flattening directory depth and rewriting metadata/documentation references. Treat `precios-unitarios-ex-planta` base and detalle as separate standalone reports, and keep `tc-promedio-mensual` as a single in-place standalone report.

**Tech Stack:** PowerShell, filesystem moves, YAML metadata, Markdown documentation, RDL assets

---

## File Structure Map

**Create:**
- `reports/precios-unitarios-ex-planta-base/`
- `reports/precios-unitarios-ex-planta-detalle/`
- `reports/precios-unitarios-ex-planta-base/inputs/`
- `reports/precios-unitarios-ex-planta-detalle/inputs/`
- `reports/tc-promedio-mensual/inputs/`
- `reports/*/work/`
- `reports/*/validations/`
- `reports/*/docs/`

**Modify:**
- `README.md`
- `docs/superpowers/specs/2026-03-22-report-structure-simplification-design.md`
- `reports/precios-unitarios-ex-planta/reports/base/report.yaml`
- `reports/precios-unitarios-ex-planta/reports/detalle/report.yaml`
- `reports/tc-promedio-mensual/reports/base/report.yaml`

**Remove after migration verification:**
- `reports/precios-unitarios-ex-planta/family.yaml`
- `reports/precios-unitarios-ex-planta/`
- `reports/tc-promedio-mensual/reports/base/`
- `reports/tc-promedio-mensual/shared/`
- `reports/tc-promedio-mensual/source/`
- Empty legacy folders left behind by the migration

**Assumption to preserve existing material cleanly:**
- Add optional `inputs/assets/` and `inputs/mappings/` when a migrated report already contains image assets or mapping notes that are used as inputs.

### Task 1: Align Documentation With The Final Target Structure

**Files:**
- Modify: `docs/superpowers/specs/2026-03-22-report-structure-simplification-design.md`
- Modify: `README.md`

- [ ] **Step 1: Update the approved design doc with the two optional migrated input folders**

Add `inputs/assets/` and `inputs/mappings/` as optional legacy-preservation folders used only when a report already depends on those materials.

- [ ] **Step 2: Update the README structure section**

Rewrite the `reports/` description so it no longer talks about families and instead documents:
- one folder per report
- `.rdl` at top level
- `inputs/`, `work/`, `validations/`, `docs/`

- [ ] **Step 3: Update the README "Punto de partida" flow**

Replace the current family-oriented onboarding with a report-oriented flow that points new work to `reports/<reporte>/inputs/`.

- [ ] **Step 4: Verify docs no longer mention `family.yaml` as a required concept**

Run: `Select-String -Path README.md,docs/superpowers/specs/2026-03-22-report-structure-simplification-design.md -Pattern 'family.yaml|familia'`

Expected: only intentional migration notes remain, not active instructions.

### Task 2: Flatten `tc-promedio-mensual` In Place

**Files:**
- Modify: `reports/tc-promedio-mensual/reports/base/report.yaml`
- Create: `reports/tc-promedio-mensual/report.yaml`
- Create: `reports/tc-promedio-mensual/inputs/xml-spec/`
- Create: `reports/tc-promedio-mensual/inputs/pdf/`
- Create: `reports/tc-promedio-mensual/inputs/screenshots/`
- Create: `reports/tc-promedio-mensual/work/`
- Create: `reports/tc-promedio-mensual/validations/`
- Create: `reports/tc-promedio-mensual/docs/`

- [ ] **Step 1: Capture the current inventory before moving files**

Run: `Get-ChildItem 'reports/tc-promedio-mensual' -Recurse | Select-Object FullName`

Expected: current `reports/base`, `shared`, and `source` tree is listed for comparison.

- [ ] **Step 2: Move the main `.rdl` to the report root**

Move:
- `reports/tc-promedio-mensual/reports/base/output/rdl/TC_promedio_mensual_base.rdl`

To:
- `reports/tc-promedio-mensual/TC_promedio_mensual_base.rdl`

- [ ] **Step 3: Consolidate all incoming material under `inputs/`**

Move:
- `reports/tc-promedio-mensual/source/cognos/xml-spec/XML Spec.xml` -> `reports/tc-promedio-mensual/inputs/xml-spec/XML Spec.xml`
- `reports/tc-promedio-mensual/source/evidence/pdf/PDF del reporte.pdf` -> `reports/tc-promedio-mensual/inputs/pdf/PDF del reporte.pdf`
- `reports/tc-promedio-mensual/source/evidence/screenshots/*` -> `reports/tc-promedio-mensual/inputs/screenshots/`

- [ ] **Step 4: Move work-in-progress material**

Move:
- `reports/tc-promedio-mensual/reports/base/working/power-bi-report-builder/` -> `reports/tc-promedio-mensual/work/power-bi-report-builder/`

- [ ] **Step 5: Preserve any report notes and validations**

Move or create:
- `reports/tc-promedio-mensual/reports/base/docs/*` -> `reports/tc-promedio-mensual/docs/`
- `reports/tc-promedio-mensual/reports/base/output/validation/*` -> `reports/tc-promedio-mensual/validations/`

- [ ] **Step 6: Rewrite metadata for the new root-level report**

Create `reports/tc-promedio-mensual/report.yaml` using the existing content as a base, then update paths so they point to:
- `inputs/xml-spec/XML Spec.xml`
- `inputs/pdf/PDF del reporte.pdf`
- `inputs/screenshots`
- `TC_promedio_mensual_base.rdl`
- `validations/`

Remove family-specific fields that no longer help with a standalone structure.

- [ ] **Step 7: Remove empty legacy folders only after verification**

Delete only if empty:
- `reports/tc-promedio-mensual/reports/`
- `reports/tc-promedio-mensual/shared/`
- `reports/tc-promedio-mensual/source/`

- [ ] **Step 8: Verify the flattened report**

Run: `Get-ChildItem 'reports/tc-promedio-mensual'`

Expected entries include:
- `TC_promedio_mensual_base.rdl`
- `report.yaml`
- `inputs`
- `work`
- `validations`
- `docs`

### Task 3: Create Standalone Folder For `precios-unitarios-ex-planta` Base

**Files:**
- Create: `reports/precios-unitarios-ex-planta-base/`
- Create: `reports/precios-unitarios-ex-planta-base/report.yaml`
- Create: `reports/precios-unitarios-ex-planta-base/inputs/xml-spec/`
- Create: `reports/precios-unitarios-ex-planta-base/inputs/queries/`
- Create: `reports/precios-unitarios-ex-planta-base/inputs/screenshots/`
- Create: `reports/precios-unitarios-ex-planta-base/inputs/pdf/`
- Create: `reports/precios-unitarios-ex-planta-base/inputs/notes/`
- Create: `reports/precios-unitarios-ex-planta-base/inputs/assets/`
- Create: `reports/precios-unitarios-ex-planta-base/inputs/mappings/`
- Create: `reports/precios-unitarios-ex-planta-base/work/`
- Create: `reports/precios-unitarios-ex-planta-base/validations/`
- Create: `reports/precios-unitarios-ex-planta-base/docs/`

- [ ] **Step 1: Create the destination folder tree**

Create the target structure under `reports/precios-unitarios-ex-planta-base/` before moving content.

- [ ] **Step 2: Move the main `.rdl` to the new report root**

Move:
- `reports/precios-unitarios-ex-planta/reports/base/output/rdl/Precios_unitarios_ex_planta_base.rdl`

To:
- `reports/precios-unitarios-ex-planta-base/Precios_unitarios_ex_planta_base.rdl`

- [ ] **Step 3: Move base input material**

Move:
- `reports/precios-unitarios-ex-planta/source/cognos/xml-spec/base/xml-spec-cognos.xml` -> `reports/precios-unitarios-ex-planta-base/inputs/xml-spec/xml-spec-cognos.xml`
- `reports/precios-unitarios-ex-planta/source/cognos/queries/base/` -> `reports/precios-unitarios-ex-planta-base/inputs/queries/`
- `reports/precios-unitarios-ex-planta/source/evidence/pdf/base/precios-unitarios-ex-planta.pdf` -> `reports/precios-unitarios-ex-planta-base/inputs/pdf/precios-unitarios-ex-planta.pdf`
- `reports/precios-unitarios-ex-planta/source/evidence/notes/base/*` -> `reports/precios-unitarios-ex-planta-base/inputs/notes/`
- `reports/precios-unitarios-ex-planta/source/evidence/screenshots/report-reference/base/*` -> `reports/precios-unitarios-ex-planta-base/inputs/screenshots/report-reference/`
- `reports/precios-unitarios-ex-planta/source/evidence/screenshots/cognos-validation/base/*` -> `reports/precios-unitarios-ex-planta-base/inputs/screenshots/cognos-validation/`
- `reports/precios-unitarios-ex-planta/source/evidence/screenshots/report-builder-validation/base/*` -> `reports/precios-unitarios-ex-planta-base/inputs/screenshots/report-builder-validation/`

- [ ] **Step 4: Move inherited shared assets that this report consumes**

Move:
- `reports/precios-unitarios-ex-planta/shared/assets/Ancap_logo_horizontal.jpg` -> `reports/precios-unitarios-ex-planta-base/inputs/assets/Ancap_logo_horizontal.jpg`
- `reports/precios-unitarios-ex-planta/shared/mappings/cognos-to-powerbi-report-builder.md` -> `reports/precios-unitarios-ex-planta-base/inputs/mappings/cognos-to-powerbi-report-builder.md`

- [ ] **Step 5: Move work, validations, and docs**

Move:
- `reports/precios-unitarios-ex-planta/reports/base/working/power-bi-report-builder/` -> `reports/precios-unitarios-ex-planta-base/work/power-bi-report-builder/`
- `reports/precios-unitarios-ex-planta/reports/base/output/validation/*` -> `reports/precios-unitarios-ex-planta-base/validations/`
- `reports/precios-unitarios-ex-planta/reports/base/docs/*` -> `reports/precios-unitarios-ex-planta-base/docs/`

Also move family-level docs that describe only the base report if, after inspection, they are not shared:
- `reports/precios-unitarios-ex-planta/docs/family-notes.md`

- [ ] **Step 6: Rewrite the base report metadata**

Create `reports/precios-unitarios-ex-planta-base/report.yaml` based on `reports/precios-unitarios-ex-planta/reports/base/report.yaml`, then update all references to the new local paths.

Set or preserve:
- report id
- human-readable report name
- standalone status
- source paths under `inputs/`
- output path `Precios_unitarios_ex_planta_base.rdl`

- [ ] **Step 7: Verify the standalone base report**

Run: `Get-ChildItem 'reports/precios-unitarios-ex-planta-base'`

Expected entries include:
- `Precios_unitarios_ex_planta_base.rdl`
- `report.yaml`
- `inputs`
- `work`
- `validations`
- `docs`

### Task 4: Create Standalone Folder For `precios-unitarios-ex-planta` Detalle

**Files:**
- Create: `reports/precios-unitarios-ex-planta-detalle/`
- Create: `reports/precios-unitarios-ex-planta-detalle/report.yaml`
- Create: `reports/precios-unitarios-ex-planta-detalle/inputs/xml-spec/`
- Create: `reports/precios-unitarios-ex-planta-detalle/inputs/queries/`
- Create: `reports/precios-unitarios-ex-planta-detalle/inputs/screenshots/`
- Create: `reports/precios-unitarios-ex-planta-detalle/inputs/pdf/`
- Create: `reports/precios-unitarios-ex-planta-detalle/inputs/notes/`
- Create: `reports/precios-unitarios-ex-planta-detalle/inputs/assets/`
- Create: `reports/precios-unitarios-ex-planta-detalle/inputs/mappings/`
- Create: `reports/precios-unitarios-ex-planta-detalle/work/`
- Create: `reports/precios-unitarios-ex-planta-detalle/validations/`
- Create: `reports/precios-unitarios-ex-planta-detalle/docs/`

- [ ] **Step 1: Create the destination folder tree**

Create the target structure under `reports/precios-unitarios-ex-planta-detalle/`.

- [ ] **Step 2: Move the main `.rdl` to the new report root**

Move:
- `reports/precios-unitarios-ex-planta/reports/detalle/output/rdl/Precios Unitarios Ex Planta - detalle.rdl`

To:
- `reports/precios-unitarios-ex-planta-detalle/Precios Unitarios Ex Planta - detalle.rdl`

- [ ] **Step 3: Move detalle input material**

Move:
- `reports/precios-unitarios-ex-planta/source/cognos/xml-spec/detalle/xml-spec-cognos.xml` -> `reports/precios-unitarios-ex-planta-detalle/inputs/xml-spec/xml-spec-cognos.xml`
- `reports/precios-unitarios-ex-planta/source/cognos/queries/detalle/` -> `reports/precios-unitarios-ex-planta-detalle/inputs/queries/`
- `reports/precios-unitarios-ex-planta/source/evidence/pdf/detalle/precios-unitarios-ex-planta-detalle.pdf` -> `reports/precios-unitarios-ex-planta-detalle/inputs/pdf/precios-unitarios-ex-planta-detalle.pdf`
- `reports/precios-unitarios-ex-planta/source/evidence/notes/detalle/*` -> `reports/precios-unitarios-ex-planta-detalle/inputs/notes/`
- `reports/precios-unitarios-ex-planta/source/evidence/screenshots/report-reference/detalle/*` -> `reports/precios-unitarios-ex-planta-detalle/inputs/screenshots/report-reference/`

- [ ] **Step 4: Move inherited shared assets and validations**

Move:
- `reports/precios-unitarios-ex-planta/shared/assets/detalle-ancap_logo_horizontal.jpg` -> `reports/precios-unitarios-ex-planta-detalle/inputs/assets/detalle-ancap_logo_horizontal.jpg`
- `reports/precios-unitarios-ex-planta/shared/mappings/detalle-cognos-to-powerbi-report-builder.md` -> `reports/precios-unitarios-ex-planta-detalle/inputs/mappings/detalle-cognos-to-powerbi-report-builder.md`
- `reports/precios-unitarios-ex-planta/shared/validations/*` -> `reports/precios-unitarios-ex-planta-detalle/validations/`

- [ ] **Step 5: Move work and docs**

Move:
- `reports/precios-unitarios-ex-planta/reports/detalle/working/power-bi-report-builder/` -> `reports/precios-unitarios-ex-planta-detalle/work/power-bi-report-builder/`
- `reports/precios-unitarios-ex-planta/reports/detalle/output/validation/*` -> `reports/precios-unitarios-ex-planta-detalle/validations/`
- `reports/precios-unitarios-ex-planta/reports/detalle/docs/*` -> `reports/precios-unitarios-ex-planta-detalle/docs/`
- `reports/precios-unitarios-ex-planta/docs/drillthrough.md` -> `reports/precios-unitarios-ex-planta-detalle/docs/drillthrough.md`

- [ ] **Step 6: Rewrite the detalle report metadata**

Create `reports/precios-unitarios-ex-planta-detalle/report.yaml` based on `reports/precios-unitarios-ex-planta/reports/detalle/report.yaml`, then update all references to the new local paths.

Preserve the drill-through dependency by rewriting `dependencies.parent_report` to:
- `../precios-unitarios-ex-planta-base/Precios_unitarios_ex_planta_base.rdl`

- [ ] **Step 7: Verify the standalone detalle report**

Run: `Get-ChildItem 'reports/precios-unitarios-ex-planta-detalle'`

Expected entries include:
- `Precios Unitarios Ex Planta - detalle.rdl`
- `report.yaml`
- `inputs`
- `work`
- `validations`
- `docs`

### Task 5: Remove The Legacy Family Container And Sweep For Stale References

**Files:**
- Modify: `README.md`
- Remove: `reports/precios-unitarios-ex-planta/`
- Remove: legacy empty directories under `reports/tc-promedio-mensual/`

- [ ] **Step 1: Confirm all three standalone report folders exist**

Run: `Get-ChildItem 'reports' -Directory | Select-Object Name`

Expected names include:
- `precios-unitarios-ex-planta-base`
- `precios-unitarios-ex-planta-detalle`
- `tc-promedio-mensual`

- [ ] **Step 2: Search for stale paths into removed folders**

Run: `Get-ChildItem -Recurse -File | Select-String 'reports/precios-unitarios-ex-planta/|source/|shared/|reports/base/|reports/detalle/'`

Expected: only intentional historical references remain in migration notes, if any.

- [ ] **Step 3: Remove the legacy family container**

Delete `reports/precios-unitarios-ex-planta/` only after Tasks 3 and 4 are fully verified.

- [ ] **Step 4: Re-run the top-level tree check**

Run: `Get-ChildItem 'reports' -Recurse -Directory | ForEach-Object { $_.FullName.Substring((Join-Path (Get-Location) '').Length) }`

Expected: no nested `reports/<familia>/reports/<reporte>/...` structure remains.

- [ ] **Step 5: Spot-check report roots for manual usability**

Run:
- `Get-ChildItem 'reports/precios-unitarios-ex-planta-base'`
- `Get-ChildItem 'reports/precios-unitarios-ex-planta-detalle'`
- `Get-ChildItem 'reports/tc-promedio-mensual'`

Expected: each root immediately shows its `.rdl`, `report.yaml`, and the same small set of support folders.

### Task 6: Final Verification

**Files:**
- Verify: `README.md`
- Verify: `reports/precios-unitarios-ex-planta-base/report.yaml`
- Verify: `reports/precios-unitarios-ex-planta-detalle/report.yaml`
- Verify: `reports/tc-promedio-mensual/report.yaml`

- [ ] **Step 1: Verify each `report.yaml` resolves only local paths**

Run: `Get-Content 'reports/precios-unitarios-ex-planta-base/report.yaml','reports/precios-unitarios-ex-planta-detalle/report.yaml','reports/tc-promedio-mensual/report.yaml'`

Expected: no path depends on a removed family container.

- [ ] **Step 2: Verify root-level `.rdl` presence**

Run: `Get-ChildItem 'reports' -Recurse -File -Filter *.rdl | Select-Object FullName`

Expected: every `.rdl` lives directly under its report folder, not under `output/rdl/`.

- [ ] **Step 3: Verify there are no orphaned empty directories**

Run: `Get-ChildItem 'reports' -Recurse -Directory | Where-Object { @(Get-ChildItem $_.FullName -Force).Count -eq 0 } | Select-Object FullName`

Expected: no unexpected empty directories are left behind.

- [ ] **Step 4: Commit if a Git repository exists**

Run: `Test-Path '.git'`

Expected: if `True`, create a commit for the migration. If `False`, skip commit and report that the workspace is not a Git repository.
