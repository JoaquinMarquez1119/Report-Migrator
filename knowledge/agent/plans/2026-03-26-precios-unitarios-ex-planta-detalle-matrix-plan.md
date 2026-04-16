# Precios Unitarios Ex Planta - detalle Matrix Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Centralizar la lógica de comportamiento del reporte `Precios Unitarios Ex Planta - detalle` en una única matriz interna, usando la documentación nueva como fuente principal y sin tocar el reporte base.

**Architecture:** La implementación debe hacerse en el generador del detalle para evitar editar el `.rdl` final a mano y para que la estructura quede regenerable. La matriz vivirá en el bloque `<Code>` del reporte y las tablix pasarán a consultarla mediante helpers unificados para selección de resumen y visibilidad de columnas.

**Tech Stack:** PowerShell, generación de RDL 2016, expresiones VB embebidas en Report Builder, validación estructural con `tests/regression/validate_precios_unitarios_ex_planta_detalle.ps1`

---

### Task 1: Blindar la regresión para exigir la matriz central

**Files:**
- Modify: `C:\Users\jmarquez\Desktop\Quanam\Migrador Reportes\tests\regression\validate_precios_unitarios_ex_planta_detalle.ps1`
- Test: `C:\Users\jmarquez\Desktop\Quanam\Migrador Reportes\tests\regression\validate_precios_unitarios_ex_planta_detalle.ps1`

- [ ] **Step 1: Agregar assertions para la nueva capa central**

Agregar validaciones de texto sobre el `.rdl` generado para exigir la presencia de helpers nuevos, por ejemplo:

```powershell
Assert-True ($detailRaw.Contains('Public Function GetProductFamily(')) "Falta la matriz central de familias en el detalle."
Assert-True ($detailRaw.Contains('Public Function IsColumnAllowed(')) "Falta la funcion central de visibilidad por columna."
Assert-True ($detailRaw.Contains('Public Function ShouldUseUsdTm1Summary(')) "Falta la funcion central de seleccion de resumen USD."
Assert-True ($detailRaw.Contains('Public Function ShouldUseLocalMainSummary(')) "Falta la funcion central de seleccion de resumen local."
```

- [ ] **Step 2: Agregar assertions para reglas documentadas nuevas**

Cubrir al menos estas reglas:

```powershell
Assert-True ($detailRaw.Contains('Case "Propano Redes"')) "La matriz debe contemplar Propano Redes."
Assert-True ($detailRaw.Contains('Case 2023')) "La matriz debe contemplar el corte historico 2023."
Assert-True ($detailRaw.Contains('MontoDiferencial')) "La matriz debe mantener la columna de monto diferencial."
Assert-True ($detailRaw.Contains('PEPSinFlete')) "La matriz debe mantener la regla de PEPSinFlete para queroseno interior y butano."
```

- [ ] **Step 3: Ejecutar la regresión y verificar que falle**

Run:

```powershell
powershell -ExecutionPolicy Bypass -File C:\Users\jmarquez\Desktop\Quanam\Migrador Reportes\tests\regression\validate_precios_unitarios_ex_planta_detalle.ps1
```

Expected: `FAIL` con mensajes que indiquen que faltan las nuevas funciones o reglas centrales.

- [ ] **Step 4: No tocar producción hasta ver el rojo**

Guardar el resultado fallido en la sesión y confirmar que la regresión falla por ausencia de la nueva matriz, no por errores accidentales del script.

### Task 2: Reemplazar la lógica dispersa por una matriz central en el generador

**Files:**
- Modify: `C:\Users\jmarquez\Desktop\Quanam\Migrador Reportes\core\generators\build_precios_unitarios_detalle_rdl.ps1`
- Reference: `C:\Users\jmarquez\Desktop\Quanam\Migrador Reportes\docs\superpowers\specs\2026-03-26-precios-unitarios-ex-planta-detalle-matrix-design.md`
- Reference: `C:\Users\jmarquez\Desktop\Quanam\Migrador Reportes\reports\precios-unitarios-ex-planta-detalle\inputs\docs\Documentacion Precio ExPlanta.docx`
- Reference: `C:\Users\jmarquez\Desktop\Quanam\Migrador Reportes\reports\precios-unitarios-ex-planta-detalle\inputs\docs\AnalisisExPLANTA.xlsx`

- [ ] **Step 1: Identificar el bloque de código embebido actual**

Ubicar en el generador:

- `NormalizeProduct`
- `NormalizeUnit`
- `ShowSummaryUsdColumn`
- `ShowSummaryLocalColumn`
- `ShowSecondaryLocalSummary`
- `ShowSecondaryLocalSummaryColumn`
- `ShowDetailColumn`
- `UseTm1UsdSummary`

- [ ] **Step 2: Diseñar la matriz dentro del bloque `<Code>`**

Modelar la matriz con helpers claros, por ejemplo:

```vb
Public Function GetProductFamily(ByVal product As String) As String
Public Function GetHistoricalSourceGroup(ByVal product As String, ByVal yearValue As Object) As String
Public Function IsColumnAllowed(ByVal viewKey As String, ByVal product As String, ByVal yearValue As Object, ByVal unitValue As String, ByVal columnKey As String) As Boolean
Public Function ShouldUseUsdTm1Summary(ByVal product As String, ByVal yearValue As Object) As Boolean
Public Function ShouldUseLocalMainSummary(ByVal product As String, ByVal yearValue As Object) As Boolean
```

- [ ] **Step 3: Migrar las reglas actuales a familias funcionales**

Pasar a una sola matriz las reglas de:

- líquidos estándar
- solventes y especiales
- fuel oils
- supergas
- propano y GLP granel
- queroseno Montevideo
- queroseno Interior
- butano
- asfaltos

- [ ] **Step 4: Incluir los cortes históricos documentados**

Expresar dentro de la lógica:

- resto de productos: PA hasta `2021-06`, planilla desde `2021-07`
- querosenos: PA hasta `2021-07`, planilla desde `2021-08`
- supergas / propano / supergas a granel / propano redes: PA hasta `2023-06`, planilla desde `2023-07`

- [ ] **Step 5: Mantener la normalización de drill local al detalle**

Preservar explícitamente:

```vb
Asfalto AC-20 -> Asfalto AC-30
Propano -> Propano Industrial
Super 95 Sp -> Gasolina Super 95
Premium 97 Sp -> Gasolina Premium 97
Gasoil Comun -> Gasoil 50-S
Gasoil Especial -> Gasoil 10-S
```

- [ ] **Step 6: Mantener helpers utilitarios ya válidos**

No romper:

- `NormalizeDisplayUnit`
- `FormatValue`
- `ValueByUnit`
- `ViewUnitLabel`

### Task 3: Reescribir las expresiones de resumen para consumir la matriz central

**Files:**
- Modify: `C:\Users\jmarquez\Desktop\Quanam\Migrador Reportes\core\generators\build_precios_unitarios_detalle_rdl.ps1`
- Generated output: `C:\Users\jmarquez\Desktop\Quanam\Migrador Reportes\reports\precios-unitarios-ex-planta-detalle\Precios Unitarios Ex Planta - detalle.rdl`

- [ ] **Step 1: Cambiar las columnas del resumen USD**

Reemplazar expresiones del tipo:

```powershell
'Not Code.ShowSummaryUsdColumn(Parameters!pProducto.Value, "PVP")'
```

por una llamada central equivalente a:

```powershell
'Not Code.IsColumnAllowed("SummaryUsd", Parameters!pProducto.Value, Parameters!pAnio.Value, Parameters!pUnidad.Value, "PVP")'
```

- [ ] **Step 2: Cambiar las columnas del resumen local TM1**

Reemplazar el uso de `ShowSummaryLocalColumn` por `IsColumnAllowed("SummaryLocalTm1", ...)`.

- [ ] **Step 3: Cambiar la tabla secundaria del resumen local**

Reemplazar:

- `ShowSecondaryLocalSummary`
- `ShowSecondaryLocalSummaryColumn`

por helpers de selección y columnas centralizados.

- [ ] **Step 4: Cambiar la selección de tablix de resumen**

Reemplazar el uso de `UseTm1UsdSummary` por helpers más explícitos, por ejemplo:

```powershell
=Code.NormalizeUnit(Parameters!pUnidad.Value) <> "USD/m3" Or Code.ShouldUseUsdTm1Summary(Parameters!pProducto.Value, Parameters!pAnio.Value)
```

Y su equivalente para el resumen local principal/secundario.

- [ ] **Step 5: Mantener la capa de “datos no vacíos” como regla secundaria**

Conservar `Count(...) = 0` o `CountRows(...) = 0` solo como segunda condición, después de la matriz de negocio.

### Task 4: Reescribir la visibilidad del detalle para consumir la misma matriz

**Files:**
- Modify: `C:\Users\jmarquez\Desktop\Quanam\Migrador Reportes\core\generators\build_precios_unitarios_detalle_rdl.ps1`
- Generated output: `C:\Users\jmarquez\Desktop\Quanam\Migrador Reportes\reports\precios-unitarios-ex-planta-detalle\Precios Unitarios Ex Planta - detalle.rdl`

- [ ] **Step 1: Cambiar todas las columnas del detalle**

Reemplazar expresiones del tipo:

```powershell
'Not Code.ShowDetailColumn(Parameters!pProducto.Value, "TasaPrim")'
```

por:

```powershell
'Not Code.IsColumnAllowed("Detail", Parameters!pProducto.Value, Parameters!pAnio.Value, Parameters!pUnidad.Value, "TasaPrim")'
```

- [ ] **Step 2: Verificar los contratos más sensibles**

Revisar que la matriz resultante preserve:

- `Supergas`: `PIT`, `MontoDiferencial`, `MargenGLPEnvasado`, `MargenEnvasado`
- `Propano Industrial` y `Supergas A Granel`: sin `PIT` ni `MontoDiferencial` obligatorios
- `Gasolina/Gasoil/Aviación`: `TasaInflamable`, `IMESI`, `TasaPrim`, `FUDAEE`
- `Aguarras/Base insecticida/...`: `Margen`, `IVADistribucion`, `IVAPrimaria`

- [ ] **Step 3: Mantener la lógica por unidad**

No modificar la mecánica de:

- `ValueByUnit`
- campos `...USD`
- cabeceras con `ViewUnitLabel`

### Task 5: Regenerar el RDL y llevar la regresión a verde

**Files:**
- Modify: `C:\Users\jmarquez\Desktop\Quanam\Migrador Reportes\core\generators\build_precios_unitarios_detalle_rdl.ps1`
- Output: `C:\Users\jmarquez\Desktop\Quanam\Migrador Reportes\reports\precios-unitarios-ex-planta-detalle\Precios Unitarios Ex Planta - detalle.rdl`
- Test: `C:\Users\jmarquez\Desktop\Quanam\Migrador Reportes\tests\regression\validate_precios_unitarios_ex_planta_detalle.ps1`

- [ ] **Step 1: Ejecutar el generador**

Run:

```powershell
powershell -ExecutionPolicy Bypass -File C:\Users\jmarquez\Desktop\Quanam\Migrador Reportes\core\generators\build_precios_unitarios_detalle_rdl.ps1
```

Expected: genera o actualiza sin errores [Precios Unitarios Ex Planta - detalle.rdl](C:\Users\jmarquez\Desktop\Quanam\Migrador%20Reportes\reports\precios-unitarios-ex-planta-detalle\Precios%20Unitarios%20Ex%20Planta%20-%20detalle.rdl)

- [ ] **Step 2: Ejecutar la regresión estructural**

Run:

```powershell
powershell -ExecutionPolicy Bypass -File C:\Users\jmarquez\Desktop\Quanam\Migrador Reportes\tests\regression\validate_precios_unitarios_ex_planta_detalle.ps1
```

Expected: `Validacion estructural OK.`

- [ ] **Step 3: Verificar escenarios representativos en el RDL generado**

Inspeccionar el `.rdl` final para confirmar que la matriz central quedó serializada y que las expresiones usan los nuevos helpers.

- [ ] **Step 4: Documentar el resultado**

Actualizar, si hace falta, la nota de comportamiento en:

`C:\Users\jmarquez\Desktop\Quanam\Migrador Reportes\reports\precios-unitarios-ex-planta-detalle\inputs\mappings\detalle-cognos-behavior-matrix.md`

solo si durante la implementación aparece una regla nueva no documentada.

- [ ] **Step 5: Commit**

No aplicar en esta sesión porque el workspace actual no está inicializado como repositorio git.
