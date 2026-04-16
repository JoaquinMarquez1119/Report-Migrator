# Precios Unitarios Ex Planta Base Layout Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ensanchar y recentrar el reporte base `Precios Unitarios Ex Planta` para que en Power BI Service se vea mucho mas parecido a Cognos.

**Architecture:** El ajuste se limita a la geometria del `.rdl`: page width, body width, header width y posiciones horizontales de los elementos clave. La logica de datos y visibilidad se mantiene intacta para reducir riesgo funcional.

**Tech Stack:** RDL 2016, Power BI Report Builder, PowerShell para validacion estructural

---

### Task 1: Blindar el layout esperado

**Files:**
- Create: `C:\Users\jmarquez\Desktop\Quanam\Migrador Reportes\tests\regression\validate_precios_unitarios_ex_planta_base_layout.ps1`
- Test: `C:\Users\jmarquez\Desktop\Quanam\Migrador Reportes\tests\regression\validate_precios_unitarios_ex_planta_base_layout.ps1`

- [ ] **Step 1: Crear una validacion que exija un body ancho**
- [ ] **Step 2: Ejecutar la validacion y confirmar que falle con el layout actual**

### Task 2: Ajustar la geometria del reporte base

**Files:**
- Modify: `C:\Users\jmarquez\Desktop\Quanam\Migrador Reportes\reports\precios-unitarios-ex-planta-base\Precios_unitarios_ex_planta_base.rdl`

- [ ] **Step 1: Ensanchar body, canvas y header**
- [ ] **Step 2: Recalcular page width y margenes**
- [ ] **Step 3: Ensanchar el area centrada del titulo y del anio**
- [ ] **Step 4: Reposicionar ambas tablix para que queden centradas respecto al titulo**

### Task 3: Verificar el resultado

**Files:**
- Test: `C:\Users\jmarquez\Desktop\Quanam\Migrador Reportes\tests\regression\validate_precios_unitarios_ex_planta_base_layout.ps1`

- [ ] **Step 1: Ejecutar la validacion y llevarla a verde**
- [ ] **Step 2: Revisar que el cambio haya quedado acotado a layout**
