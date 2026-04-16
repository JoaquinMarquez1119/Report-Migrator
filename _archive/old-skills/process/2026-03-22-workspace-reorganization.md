# Workspace Reorganization Implementation Plan

> Historical note: this plan documents an intermediate family-based layout that has since been retired in favor of standalone report folders under `reports/<reporte>/`.

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reorganize the workspace into report families, reusable core assets, and project-local knowledge without losing existing migration material.

**Architecture:** The workspace will be split into `reports/`, `core/`, `knowledge/`, `intake/`, and structured `tests/`. Existing case material will be moved into two initial families: `precios-unitarios-ex-planta` and `tc-promedio-mensual`, with the detail report nested under the first family and shared drill-through knowledge promoted into `knowledge/`.

**Tech Stack:** PowerShell filesystem operations, Markdown docs, YAML metadata, Power BI Report Builder `.rdl`, Cognos source artifacts.

---

### Task 1: Create the target directory skeleton

**Files:**
- Create: `README.md`
- Create: `reports/`
- Create: `core/`
- Create: `knowledge/`
- Create: `intake/`
- Modify: workspace root directory structure

- [ ] **Step 1: Create the top-level directories**

Run:

```powershell
New-Item -ItemType Directory -Force -Path 'reports','core','knowledge','intake' | Out-Null
```

Expected: the four directories exist at the workspace root.

- [ ] **Step 2: Create the reusable subdirectories**

Run:

```powershell
$dirs = @(
  'core/generators','core/parsers','core/validators','core/mappings','core/templates','core/shared',
  'knowledge/docs/process','knowledge/docs/patterns','knowledge/docs/troubleshooting','knowledge/docs/decisions',
  'knowledge/skills','knowledge/checklists','knowledge/examples',
  'intake/pending','intake/normalized',
  'tests/unit','tests/integration','tests/regression'
)
$dirs | ForEach-Object { New-Item -ItemType Directory -Force -Path $_ | Out-Null }
```

Expected: all reusable subdirectories exist.

### Task 2: Create report family containers

**Files:**
- Create: `reports/precios-unitarios-ex-planta/family.yaml`
- Create: `reports/tc-promedio-mensual/family.yaml`
- Create: family directory skeletons under `reports/`

- [ ] **Step 1: Create the `precios-unitarios-ex-planta` family structure**

Run:

```powershell
$dirs = @(
  'reports/precios-unitarios-ex-planta/source/cognos/xml-spec',
  'reports/precios-unitarios-ex-planta/source/cognos/queries',
  'reports/precios-unitarios-ex-planta/source/cognos/exports',
  'reports/precios-unitarios-ex-planta/source/evidence/screenshots',
  'reports/precios-unitarios-ex-planta/source/evidence/pdf',
  'reports/precios-unitarios-ex-planta/source/evidence/notes',
  'reports/precios-unitarios-ex-planta/reports/base/working/power-bi-report-builder/base',
  'reports/precios-unitarios-ex-planta/reports/base/working/power-bi-report-builder/generated',
  'reports/precios-unitarios-ex-planta/reports/base/working/power-bi-report-builder/manual-edits',
  'reports/precios-unitarios-ex-planta/reports/base/output/rdl',
  'reports/precios-unitarios-ex-planta/reports/base/output/validation',
  'reports/precios-unitarios-ex-planta/reports/base/docs',
  'reports/precios-unitarios-ex-planta/reports/detalle/working/power-bi-report-builder/base',
  'reports/precios-unitarios-ex-planta/reports/detalle/working/power-bi-report-builder/generated',
  'reports/precios-unitarios-ex-planta/reports/detalle/working/power-bi-report-builder/manual-edits',
  'reports/precios-unitarios-ex-planta/reports/detalle/output/rdl',
  'reports/precios-unitarios-ex-planta/reports/detalle/output/validation',
  'reports/precios-unitarios-ex-planta/reports/detalle/docs',
  'reports/precios-unitarios-ex-planta/shared/mappings',
  'reports/precios-unitarios-ex-planta/shared/assets',
  'reports/precios-unitarios-ex-planta/shared/validations',
  'reports/precios-unitarios-ex-planta/docs'
)
$dirs | ForEach-Object { New-Item -ItemType Directory -Force -Path $_ | Out-Null }
```

Expected: the family directory tree exists.

- [ ] **Step 2: Create the `tc-promedio-mensual` family structure**

Run:

```powershell
$dirs = @(
  'reports/tc-promedio-mensual/source/cognos/xml-spec',
  'reports/tc-promedio-mensual/source/cognos/queries',
  'reports/tc-promedio-mensual/source/cognos/exports',
  'reports/tc-promedio-mensual/source/evidence/screenshots',
  'reports/tc-promedio-mensual/source/evidence/pdf',
  'reports/tc-promedio-mensual/source/evidence/notes',
  'reports/tc-promedio-mensual/reports/base/working/power-bi-report-builder/base',
  'reports/tc-promedio-mensual/reports/base/working/power-bi-report-builder/generated',
  'reports/tc-promedio-mensual/reports/base/working/power-bi-report-builder/manual-edits',
  'reports/tc-promedio-mensual/reports/base/output/rdl',
  'reports/tc-promedio-mensual/reports/base/output/validation',
  'reports/tc-promedio-mensual/reports/base/docs',
  'reports/tc-promedio-mensual/shared/mappings',
  'reports/tc-promedio-mensual/shared/assets',
  'reports/tc-promedio-mensual/shared/validations',
  'reports/tc-promedio-mensual/docs'
)
$dirs | ForEach-Object { New-Item -ItemType Directory -Force -Path $_ | Out-Null }
```

Expected: the second family directory tree exists.

### Task 3: Move existing report artifacts into their family structure

**Files:**
- Modify: existing root folders and files under `Precios Unitarios Ex Planta`
- Modify: existing root folder and files under `TC Promedio Mensual`
- Modify: `scripts/build_precios_unitarios_detalle_rdl.ps1`
- Modify: `tests/validate_precios_unitarios_ex_planta_detalle.ps1`

- [ ] **Step 1: Move source and evidence for `Precios Unitarios Ex Planta`**

Move the Cognos XML spec, Cognos query folder, screenshots, PDFs, notes, logo, and mapping documents into `reports/precios-unitarios-ex-planta/source/...` and `reports/precios-unitarios-ex-planta/shared/...`.

- [ ] **Step 2: Move the base and detail `.rdl` files into their report folders**

Move the base report file into `reports/precios-unitarios-ex-planta/reports/base/output/rdl/` and the detail report file into `reports/precios-unitarios-ex-planta/reports/detalle/output/rdl/`.

- [ ] **Step 3: Move `TC Promedio Mensual` into its family**

Move the XML spec, PDF, screenshots, and base `.rdl` into the corresponding `reports/tc-promedio-mensual/...` directories.

- [ ] **Step 4: Relocate the detail build script and validation test**

Move `scripts/build_precios_unitarios_detalle_rdl.ps1` to `core/generators/` and `tests/validate_precios_unitarios_ex_planta_detalle.ps1` to `tests/regression/`.

### Task 4: Move knowledge into `knowledge/` and seed reusable documentation

**Files:**
- Modify: `docs/superpowers/*`
- Create: `knowledge/docs/patterns/drillthrough-nested-reports.md`
- Create: `knowledge/docs/process/workspace-organization.md`

- [ ] **Step 1: Move specs, plans, and troubleshooting seed into `knowledge/`**

Move:

- `docs/superpowers/specs/*` -> `knowledge/docs/decisions/`
- `docs/superpowers/plans/*` -> `knowledge/docs/process/`
- `docs/superpowers/skills/*` -> `knowledge/docs/troubleshooting/` or `knowledge/skills/` as appropriate

- [ ] **Step 2: Create the first reusable process and pattern docs**

Write one process document describing the family/report layout and one pattern document describing nested drill-through reports.

### Task 5: Create metadata files and a root guide

**Files:**
- Create: `reports/precios-unitarios-ex-planta/family.yaml`
- Create: `reports/precios-unitarios-ex-planta/reports/base/report.yaml`
- Create: `reports/precios-unitarios-ex-planta/reports/detalle/report.yaml`
- Create: `reports/tc-promedio-mensual/family.yaml`
- Create: `reports/tc-promedio-mensual/reports/base/report.yaml`
- Create: `README.md`

- [ ] **Step 1: Write family and report metadata**

Create minimal YAML files that declare names, slugs, status, and key inputs/outputs.

- [ ] **Step 2: Write the root `README.md`**

Document the new structure, the two initial families, and where reusable knowledge now lives.

### Task 6: Verify the reorganization

**Files:**
- Verify: entire workspace tree after moves

- [ ] **Step 1: List the new root tree**

Run:

```powershell
Get-ChildItem -Force
```

Expected: `reports`, `core`, `knowledge`, `intake`, and `tests` are visible at the root.

- [ ] **Step 2: Spot-check the moved report directories**

Run:

```powershell
Get-ChildItem 'reports/precios-unitarios-ex-planta' -Recurse -Depth 3
Get-ChildItem 'reports/tc-promedio-mensual' -Recurse -Depth 3
```

Expected: the family folders contain the moved assets, report folders, and metadata files.

- [ ] **Step 3: Confirm old root case folders are gone**

Run:

```powershell
Get-ChildItem -Force
```

Expected: legacy folders like `Precios Unitarios Ex Planta` and `TC Promedio Mensual` no longer exist at the root.
