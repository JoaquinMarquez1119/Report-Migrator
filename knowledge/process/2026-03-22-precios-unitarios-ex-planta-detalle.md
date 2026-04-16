# Precios Unitarios Ex Planta - detalle Implementation Plan

> Historical note: this plan documents a previous workspace and a pre-cleanup layout. It is kept as historical implementation context, not as active execution guidance for the current standalone workspace model.

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a new standalone `Precios Unitarios Ex Planta - detalle` RDL that faithfully replicates the Cognos report and wire the parent report drill-through into it.

**Architecture:** Reuse the existing parent RDL as the structural template for data source, shared styling, and drill conventions, but create a separate detail RDL with its own datasets, parameters, and two internal views (`Resumen` and `Detalle`). Add a lightweight XML validation script first so implementation can follow a red/green loop even though the deliverable is report XML rather than application code.

**Tech Stack:** Power BI Report Builder RDL (XML), DAX datasets against Power BI semantic model, PowerShell XML validation

---

### Task 1: Create the validation harness first

**Files:**
- Create: `C:\Users\jmarquez\Desktop\Quanam\Prueba Codex\tests\validate_precios_unitarios_ex_planta_detalle.ps1`
- Test: `C:\Users\jmarquez\Desktop\Quanam\Prueba Codex\tests\validate_precios_unitarios_ex_planta_detalle.ps1`

- [ ] **Step 1: Write the failing validation script**

Create a PowerShell script that loads:

- `Precios Unitarios Ex Planta\Precios Unitarios Ex Planta - detalle.rdl`
- `Precios Unitarios Ex Planta\Precios_unitarios_ex_planta_base.rdl`

and asserts at least:

- the detail report file exists
- the detail report has parameters `pAnio`, `pProducto`, `pUnidad`, `pVista`
- the detail report contains datasets for year, product, summary, detail, and text
- the parent report drill-through targets `Precios Unitarios Ex Planta - detalle`
- the parent drill passes `pAnio`, `pProducto`, `pUnidad`, and `pVista`

- [ ] **Step 2: Run the validation script to verify it fails**

Run: `powershell -ExecutionPolicy Bypass -File .\tests\validate_precios_unitarios_ex_planta_detalle.ps1`

Expected: FAIL because the new detail RDL does not exist yet.

- [ ] **Step 3: Keep the script ready for repeated verification**

Do not weaken assertions. The script should be the guardrail for the remaining tasks.


### Task 2: Scaffold the standalone detail report from the existing report conventions

**Files:**
- Create: `C:\Users\jmarquez\Desktop\Quanam\Prueba Codex\Precios Unitarios Ex Planta\Precios Unitarios Ex Planta - detalle.rdl`
- Modify: `C:\Users\jmarquez\Desktop\Quanam\Prueba Codex\tests\validate_precios_unitarios_ex_planta_detalle.ps1`
- Reference: `C:\Users\jmarquez\Desktop\Quanam\Prueba Codex\Precios Unitarios Ex Planta\Precios_unitarios_ex_planta_base.rdl`
- Reference: `C:\Users\jmarquez\Desktop\Quanam\Prueba Codex\Precios Unitarios Ex Planta\Precios Unitarios Ex Planta - detalle\XML Spec Cognos.xml`

- [ ] **Step 1: Copy the parent RDL structure into a new detail RDL**

Use the parent report as the XML starting point so the new file inherits:

- the same data source definition
- report-level namespaces and metadata
- shared report properties

Then remove summary-only datasets and report items that are not needed.

- [ ] **Step 2: Add the failing validation expectations for the standalone report shape**

Expand the validation script so it also expects:

- `pVista` to be present
- a detail body canvas
- tab selectors for `Resumen` and `Detalle`

- [ ] **Step 3: Run the validation script to verify it still fails**

Run: `powershell -ExecutionPolicy Bypass -File .\tests\validate_precios_unitarios_ex_planta_detalle.ps1`

Expected: FAIL because the new report XML still lacks the required structure.

- [ ] **Step 4: Implement the minimal report shell**

Add to the new report:

- data source
- parameters `pAnio`, `pProducto`, `pUnidad`, `pVista`
- base body layout
- report items for title, tabs, and footer

- [ ] **Step 5: Run the validation script to verify shell assertions pass**

Run: `powershell -ExecutionPolicy Bypass -File .\tests\validate_precios_unitarios_ex_planta_detalle.ps1`

Expected: PASS for file existence and shell structure assertions, with remaining dataset-specific assertions still failing if not complete yet.


### Task 3: Implement prompt datasets and parameter normalization

**Files:**
- Modify: `C:\Users\jmarquez\Desktop\Quanam\Prueba Codex\Precios Unitarios Ex Planta\Precios Unitarios Ex Planta - detalle.rdl`
- Modify: `C:\Users\jmarquez\Desktop\Quanam\Prueba Codex\tests\validate_precios_unitarios_ex_planta_detalle.ps1`
- Reference: `C:\Users\jmarquez\Desktop\Quanam\Prueba Codex\Precios Unitarios Ex Planta\Precios Unitarios Ex Planta - detalle\Consultas de Cognos\pAño.sql`
- Reference: `C:\Users\jmarquez\Desktop\Quanam\Prueba Codex\Precios Unitarios Ex Planta\Precios Unitarios Ex Planta - detalle\Consultas de Cognos\Producto.sql`

- [ ] **Step 1: Write the failing validation for prompt datasets**

Require the detail RDL to contain:

- `dsAnio`
- `dsProducto`
- report parameter valid values wired to those datasets

- [ ] **Step 2: Run the validation script to verify it fails**

Run: `powershell -ExecutionPolicy Bypass -File .\tests\validate_precios_unitarios_ex_planta_detalle.ps1`

Expected: FAIL because prompt datasets are not complete yet.

- [ ] **Step 3: Implement prompt datasets and parameter defaults**

Add:

- `dsAnio` modeled on the parent year dataset
- `dsProducto` that normalizes product names and derives the display unit
- visible prompts for year, product, and unit
- hidden `pVista`

- [ ] **Step 4: Implement parameter normalization expressions**

Normalize:

- `USD` -> `USD/m3`
- `UYU` -> `$/lt ó $/kg según corresponda`

and preserve the product remapping used by the parent drill.

- [ ] **Step 5: Run the validation script to verify prompt assertions pass**

Run: `powershell -ExecutionPolicy Bypass -File .\tests\validate_precios_unitarios_ex_planta_detalle.ps1`

Expected: PASS for parameter and prompt dataset assertions.


### Task 4: Build the `Resumen` view of the detail report

**Files:**
- Modify: `C:\Users\jmarquez\Desktop\Quanam\Prueba Codex\Precios Unitarios Ex Planta\Precios Unitarios Ex Planta - detalle.rdl`
- Modify: `C:\Users\jmarquez\Desktop\Quanam\Prueba Codex\tests\validate_precios_unitarios_ex_planta_detalle.ps1`
- Reference: `C:\Users\jmarquez\Desktop\Quanam\Prueba Codex\Precios Unitarios Ex Planta\Precios Unitarios Ex Planta - detalle\Consultas de Cognos\Ex Planta Planilla.sql`
- Reference: `C:\Users\jmarquez\Desktop\Quanam\Prueba Codex\Precios Unitarios Ex Planta\Precios Unitarios Ex Planta - detalle\Consultas de Cognos\Texto.sql`
- Reference: `C:\Users\jmarquez\Desktop\Quanam\Prueba Codex\Precios Unitarios Ex Planta\Precios Unitarios Ex Planta - detalle\Screenshots del reporte\Pagina Resumen - Gasolina Super 95 - 2025 - USD m3.png`

- [ ] **Step 1: Write failing validation for the summary view**

Add assertions that the detail RDL contains:

- `dsResumen`
- `dsTexto`
- a visible summary tablix
- summary-specific textboxes for notes/footer text

- [ ] **Step 2: Run validation to confirm failure**

Run: `powershell -ExecutionPolicy Bypass -File .\tests\validate_precios_unitarios_ex_planta_detalle.ps1`

Expected: FAIL on summary dataset or tablix assertions.

- [ ] **Step 3: Implement the summary datasets**

Port the summary behavior needed for the standalone report, including:

- monthly rows
- concept ordering and visible renames
- density-aware conversions
- text dataset for `(*) Equivale al precio del Subtotal 3 del Informe URSEA`

- [ ] **Step 4: Implement the summary report items**

Add:

- title/header block
- selected-product and year text
- `Resumen` and `Detalle` tabs with active/inactive styling driven by `pVista`
- summary tablix variants for the two units
- note block and reference footer

- [ ] **Step 5: Run validation to confirm summary assertions pass**

Run: `powershell -ExecutionPolicy Bypass -File .\tests\validate_precios_unitarios_ex_planta_detalle.ps1`

Expected: PASS for summary structure assertions.


### Task 5: Build the `Detalle` view and empty-state behavior

**Files:**
- Modify: `C:\Users\jmarquez\Desktop\Quanam\Prueba Codex\Precios Unitarios Ex Planta\Precios Unitarios Ex Planta - detalle.rdl`
- Modify: `C:\Users\jmarquez\Desktop\Quanam\Prueba Codex\tests\validate_precios_unitarios_ex_planta_detalle.ps1`
- Reference: `C:\Users\jmarquez\Desktop\Quanam\Prueba Codex\Precios Unitarios Ex Planta\Precios Unitarios Ex Planta - detalle\Consultas de Cognos\Ex Planta Planilla Detalle.sql`
- Reference: `C:\Users\jmarquez\Desktop\Quanam\Prueba Codex\Precios Unitarios Ex Planta\Precios Unitarios Ex Planta - detalle\Screenshots del reporte\Pagina Detalle - Gasoliona Super 95 - 2025 - USD m3.png`
- Reference: `C:\Users\jmarquez\Desktop\Quanam\Prueba Codex\Precios Unitarios Ex Planta\Precios Unitarios Ex Planta - detalle\Screenshots del reporte\Pagina Detalle - Propano Industrial - 2022 - lit o kg.png`

- [ ] **Step 1: Write failing validation for the detail view**

Require:

- `dsDetalle`
- a detail tablix or detail-region rectangle
- a textbox with `No hay datos disponibles`

- [ ] **Step 2: Run validation to confirm failure**

Run: `powershell -ExecutionPolicy Bypass -File .\tests\validate_precios_unitarios_ex_planta_detalle.ps1`

Expected: FAIL because detail structures are not complete yet.

- [ ] **Step 3: Implement the detail dataset**

Port the detail logic needed for:

- daily/month-end labels
- concept ordering
- 2-decimal vs 4-decimal formatting signals
- `PPI n-1 Periodo URSEA` and `PPI n-2 Periodo URSEA`
- density-aware conversions

- [ ] **Step 4: Implement the detail tablix variants**

Add:

- USD variant
- local-currency/unit variant
- conditional visibility by normalized unit
- empty-state visibility when dataset returns no rows

- [ ] **Step 5: Run validation to confirm detail assertions pass**

Run: `powershell -ExecutionPolicy Bypass -File .\tests\validate_precios_unitarios_ex_planta_detalle.ps1`

Expected: PASS for detail structure assertions.


### Task 6: Update and verify parent drill-through wiring

**Files:**
- Modify: `C:\Users\jmarquez\Desktop\Quanam\Prueba Codex\Precios Unitarios Ex Planta\Precios_unitarios_ex_planta_base.rdl`
- Modify: `C:\Users\jmarquez\Desktop\Quanam\Prueba Codex\tests\validate_precios_unitarios_ex_planta_detalle.ps1`

- [ ] **Step 1: Write the failing validation for parent drill details**

Require the parent report drillthrough actions to:

- target `Precios Unitarios Ex Planta - detalle`
- pass `pAnio`
- pass `pUnidad`
- pass `pProducto`
- pass `pVista` with value `Resumen`

- [ ] **Step 2: Run validation to confirm failure**

Run: `powershell -ExecutionPolicy Bypass -File .\tests\validate_precios_unitarios_ex_planta_detalle.ps1`

Expected: FAIL if the parent drill is missing any expected parameter or uses the wrong target.

- [ ] **Step 3: Implement the parent drill updates**

Adjust both drillthrough actions in the parent tablixes so they consistently target the new standalone report and send the expected parameters.

- [ ] **Step 4: Run validation to confirm the drill assertions pass**

Run: `powershell -ExecutionPolicy Bypass -File .\tests\validate_precios_unitarios_ex_planta_detalle.ps1`

Expected: PASS for the parent drillthrough assertions.


### Task 7: Final verification pass

**Files:**
- Modify: `C:\Users\jmarquez\Desktop\Quanam\Prueba Codex\tests\validate_precios_unitarios_ex_planta_detalle.ps1`
- Verify: `C:\Users\jmarquez\Desktop\Quanam\Prueba Codex\Precios Unitarios Ex Planta\Precios Unitarios Ex Planta - detalle.rdl`
- Verify: `C:\Users\jmarquez\Desktop\Quanam\Prueba Codex\Precios Unitarios Ex Planta\Precios_unitarios_ex_planta_base.rdl`

- [ ] **Step 1: Run the full validation script**

Run: `powershell -ExecutionPolicy Bypass -File .\tests\validate_precios_unitarios_ex_planta_detalle.ps1`

Expected: PASS with no thrown assertions.

- [ ] **Step 2: Perform a manual XML spot check**

Confirm directly in the RDLs that:

- the detail report contains the expected datasets and parameters
- the parent still contains both product drillthrough actions
- `pVista=Resumen` is being sent from the parent

- [ ] **Step 3: Compare against the supplied screenshots**

Visually compare report structure and labels against:

- one screenshot with summary/detail data present
- one screenshot with empty-state detail

- [ ] **Step 4: Document any residual gaps**

If exact rendering cannot be proven without opening Report Builder, capture that explicitly in the final handoff.
