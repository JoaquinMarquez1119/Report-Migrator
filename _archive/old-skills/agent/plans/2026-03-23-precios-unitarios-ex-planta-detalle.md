# Precios Unitarios Ex Planta - detalle Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Construir el reporte standalone `Precios Unitarios Ex Planta - detalle` dentro de la estructura actual del workspace y dejar validado el drill-through desde el reporte base.

**Architecture:** Se reutiliza el generador PowerShell existente como fuente principal del RDL, pero alineando sus rutas al modelo actual de carpetas standalone. La validación estructural se usa como prueba roja inicial para comprobar la ausencia del `.rdl` y luego se lleva a verde generando el archivo final en la raíz del reporte detalle y verificando que el reporte padre siga apuntando al target correcto.

**Tech Stack:** PowerShell, RDL 2016, Power BI Report Builder, validaciones XML sobre `.rdl`

---

### Task 1: Alinear validación con el workspace actual

**Files:**
- Modify: `tests/regression/validate_precios_unitarios_ex_planta_detalle.ps1`

- [ ] **Step 1: Write the failing test**

Usar la validación existente como prueba inicial, pero apuntándola a:
- `reports/precios-unitarios-ex-planta-base/Precios_unitarios_ex_planta_base.rdl`
- `reports/precios-unitarios-ex-planta-detalle/Precios Unitarios Ex Planta - detalle.rdl`

- [ ] **Step 2: Run test to verify it fails**

Run: `powershell -ExecutionPolicy Bypass -File .\tests\regression\validate_precios_unitarios_ex_planta_detalle.ps1`
Expected: FAIL indicando que no existe `reports/precios-unitarios-ex-planta-detalle/Precios Unitarios Ex Planta - detalle.rdl`

- [ ] **Step 3: Write minimal implementation**

Actualizar solo el cálculo de paths de `parentPath` y `detailPath`, preservando el resto de las aserciones estructurales.

- [ ] **Step 4: Run test to verify it still fails for the expected reason**

Run: `powershell -ExecutionPolicy Bypass -File .\tests\regression\validate_precios_unitarios_ex_planta_detalle.ps1`
Expected: FAIL únicamente por ausencia del `.rdl` detalle

### Task 2: Alinear generador y crear el `.rdl` detalle

**Files:**
- Modify: `core/generators/build_precios_unitarios_detalle_rdl.ps1`
- Create: `reports/precios-unitarios-ex-planta-detalle/Precios Unitarios Ex Planta - detalle.rdl`

- [ ] **Step 1: Write the failing test**

La prueba roja es la validación del task anterior, que ya debe fallar solo porque el `.rdl` todavía no existe.

- [ ] **Step 2: Run test to verify it fails**

Run: `powershell -ExecutionPolicy Bypass -File .\tests\regression\validate_precios_unitarios_ex_planta_detalle.ps1`
Expected: FAIL por archivo detalle inexistente

- [ ] **Step 3: Write minimal implementation**

Actualizar el generador para:
- tomar como origen el reporte padre actual `reports/precios-unitarios-ex-planta-base/Precios_unitarios_ex_planta_base.rdl`
- escribir el resultado en `reports/precios-unitarios-ex-planta-detalle/Precios Unitarios Ex Planta - detalle.rdl`
- mantener datasets, parámetros, cuerpo, código embebido y tabs existentes

- [ ] **Step 4: Run generator**

Run: `powershell -ExecutionPolicy Bypass -File .\core\generators\build_precios_unitarios_detalle_rdl.ps1`
Expected: mensaje `RDL detalle regenerado...` y archivo creado en la ruta final

- [ ] **Step 5: Run test to verify it passes**

Run: `powershell -ExecutionPolicy Bypass -File .\tests\regression\validate_precios_unitarios_ex_planta_detalle.ps1`
Expected: `Validacion estructural OK.`

### Task 3: Verificación final del artefacto generado

**Files:**
- Verify: `reports/precios-unitarios-ex-planta-detalle/Precios Unitarios Ex Planta - detalle.rdl`
- Verify: `reports/precios-unitarios-ex-planta-base/Precios_unitarios_ex_planta_base.rdl`

- [ ] **Step 1: Inspect generated RDL**

Confirmar que existan:
- parámetros `pAnio`, `pProducto`, `pUnidad`, `pVista`
- datasets `dsAnio`, `dsProducto`, `dsTexto`, `dsResumen`, `dsDetalle`
- tabs `Resumen` y `Detalle`
- texto `No hay datos disponibles`

- [ ] **Step 2: Re-run validation**

Run: `powershell -ExecutionPolicy Bypass -File .\tests\regression\validate_precios_unitarios_ex_planta_detalle.ps1`
Expected: `Validacion estructural OK.`

- [ ] **Step 3: Summarize remaining gaps**

Si no se puede abrir en Report Builder desde este entorno, dejar explícito que la validación realizada es estructural/XML y no visual interactiva.
