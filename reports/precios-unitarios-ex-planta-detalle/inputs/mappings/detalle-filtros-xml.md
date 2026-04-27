# Filtros canónicos — Precios Unitarios Ex Planta - detalle

Extraído mecánicamente de `inputs/xml-spec/xml-spec-cognos.xml`.
**Esta es la fuente de verdad para visibilidad de columnas.** El archivo `detalle-cognos-behavior-matrix.md` fue inferido — usar este en su lugar.

Última extracción: 2026-04-22

---

## Notas de lectura

- **Concepto2** es el label visible en Cognos (puede ser una etiqueta distinta al nombre crudo en `Precios_Ex_Planta[Concepto]`).
- **columnKey** es el identificador usado en `IsColumnAllowed()` en el RDL.
- **then(1)** = sin restricción de conceptos; todos los conceptos del filtro global de la query pasan.
- El filtro global del Resumen (XML línea 597) limita los Concepto a: PVP, PIT, PEP imp., PEP sin flete, PPI+FactorX→PEP, FactorX→Factor, PPI sin tasas→Ursea, PEP, Factor d GLP→MontoDiferencial, PPI n-1, PPI n-2.
- El Detalle no tiene filtro global de conceptos — cada familia define exactamente qué aparece.

---

## Mapeo Concepto2 label → columnKey RDL

| Concepto2 (label Cognos) | columnKey RDL | Campo dataset |
|---|---|---|
| Precio de Venta al Público (PVP) (impuestos incluidos) | PVP | PVPImp / PVPImpUSD |
| Precio Intermedio Transitorio (PIT) (impuestos incluidos) | PIT | PITImp / PITImpUSD |
| Precio Ex Planta (PEP) (impuestos incluidos) | PEPImp | PEPImp / PEPImpUSD |
| Precio Ex Planta (PEP) sin flete secundario (impuestos incluidos) | PEPSinFlete | PEPSinFleteImp / PEPSinFleteImpUSD |
| PEP / Precio Ex Planta (PEP) / PPI sin tasas e impuestos + Factor X | PEP | PEP / PEPUSD |
| Factor X o factor de ajuste / Factor de ajuste | Factor | FactorAjuste / FactorAjusteUSD |
| PPI sin tasas e impuestos / PEP calculado por URSEA (*) | Ursea | PEPCalcUrsea / PEPCalcUrseaUSD |
| Factor d para GLP Dec 205/023 / Monto diferencial por zonas "d" | MontoDiferencial | MontoDiferencialZonasD / MontoDiferencialZonasDUSD |
| PPI n-1 Periodo URSEA | PPIN1 | PPIN1 / PPIN1USD |
| PPI n-2 Periodo URSEA | PPIN2 | PPIN2 / PPIN2USD |
| Tasa IMM sobre CL dist primaria al interior (23,2% del total) | TasaInflamable | TasaInflamable / TasaInflamableUSD |
| Margen de distribución de GLP envasado | MargenGLPEnvasado | MargenGLPEnvasado / MargenGLPEnvasadoUSD |
| Bonificación estaciones de servicio | Bonificacion | BonificacionEESS / BonificacionEESSUSD |
| Tasa URSEA etapa venta al público | TasaVenta | TasaURSEAVenta / TasaURSEAVentaUSD |
| IVA etapa venta al público | IVAVentaPublico | IVAVentaPublico / IVAVentaPublicoUSD |
| Margen de envasado | MargenEnvasado | MargenEnvasado / MargenEnvasadoUSD |
| Margen de distribuidoras / Margen de distribución | Margen | MargenDistribucion / MargenDistribucionUSD |
| Tasa URSEA etapa distribución | TasaDist | TasaURSEADistribucion / TasaURSEADistribucionUSD |
| IVA etapa distribución | IVADistribucion | IVADistribucion / IVADistribucionUSD |
| Flete / Flete, de plantas a estaciones de servicio (mes n-2) | Flete | Flete / FleteUSD |
| Tasa URSEA etapa secundaria | TasaSec | TasaURSEASecundaria / TasaURSEASecundariaUSD |
| IVA etapa secundaria | IVASec | IVASecundaria / IVASecundariaUSD |
| Compensación Con Fin Social (CFS) / Compensación Bonificación EESS con Fin Social (CFS) | CFS | CompensacionCFS / CompensacionCFSUSD |
| IMESI | IMESI | IMESI / IMESIUSD |
| Impuesto CO2 | CO2 | ImpuestoCO2 / ImpuestoCO2USD |
| Tasa URSEA etapa primaria | TasaPrim | TasaURSEAPrimaria / TasaURSEAPrimariaUSD |
| FUDAEE | FUDAEE | FUDAEE / FUDAEEUSD |
| IVA etapa primaria | IVAPrimaria | IVAPrimaria / IVAPrimariaUSD |
| Fideicomiso Gasoil (dto. 347/006) | Fideicomiso | Fideicomiso / FideicomisoUSD |

---

## Matriz canónica — Vista RESUMEN

Fuente: query `Ex Planta Planilla`, `Filtro` maestro (XML líneas 535–596).

| Familia (GetProductFamily) | Productos Cognos | columnKeys permitidos | XML ref |
|---|---|---|---|
| LiquidosBase | Super 95 Sp, Gasoil Comun, Gasoil Especial, Premium 97 Sp | PVP, PIT, PEPImp, PEPSinFlete, PEP, Factor, Ursea, MontoDiferencial, PPIN1, PPIN2 | línea 560-562 (`then(1)` + filtro global línea 597) |
| LiquidosAv | Gasolina Av 100 Octanos, Jet A1 | PVP, PEPImp, PEP | línea 556-558 (Filtro Ultimos) |
| SolventesEspeciales | Aguarras, Solvente 1197, Disan, Base insecticida, Querosol, Hexano Comercial | PVP, PEPImp, PEP | línea 556-558 (Filtro Ultimos) |
| FuelOils | Fuel Oil Medio, Fuel Oil Pesado | PVP, PEPImp, PEP, Factor, Ursea, PPIN1, PPIN2 | línea 543 (Filtro FO) |
| SupergasEnvasado | Supergas | PVP, PIT, PEPImp, PEP, Factor, Ursea, MontoDiferencial, PPIN1, PPIN2 | línea 550 (Filtro Supergas) |
| PropanoGLPGranel | Propano, Supergas A Granel, Propano Industrial | PVP, PEPImp, PEP, Factor, Ursea, PPIN1, PPIN2 | línea 553 (Filtro Propano) |
| QuerosenoMontevideo | Queroseno Montevideo | PVP, PIT, PEPImp, PEP | línea 537 (Filtro QMontevideo) |
| QuerosenoInterior | Queroseno Interior | PVP, PIT, PEPImp, PEPSinFlete, PEP | línea 535 (Filtro QInterior) |
| Butano | Butano Desodorizado | PVP, PEPSinFlete, PEP | línea 546 (Filtro Butano) |

---

## Matriz canónica — Vista DETALLE

Fuente: query `Ex Planta Planilla Detalle`, `Filtro` maestro (XML líneas 658–689).

| Familia (GetProductFamily) | Productos Cognos | columnKeys permitidos | XML ref |
|---|---|---|---|
| LiquidosBase | Super 95 Sp, Gasoil Comun, Gasoil Especial, Premium 97 Sp | **todos** (`then(1)`) — Count>0 controla visibilidad | línea 680 |
| LiquidosAv | Gasolina Av 100 Octanos, Jet A1 | PVP, PEPImp, TasaInflamable, IMESI, TasaPrim, FUDAEE, Ursea, PEP | línea 675 (Filtro Ultimos) |
| SolventesEspeciales | Aguarras, Solvente 1197, Disan, Base insecticida, Querosol, Hexano Comercial | PVP, Margen, IVADistribucion, PEPImp, TasaInflamable, IMESI, TasaPrim, FUDAEE, IVAPrimaria, Ursea, PEP | línea 676 (Filtro Ultimos1) |
| FuelOils | Fuel Oil Medio, Fuel Oil Pesado | PVP, Margen, TasaDist, IVADistribucion, PEPImp, TasaPrim, FUDAEE, IVAPrimaria, PEP, Factor, Ursea, PPIN1, PPIN2 | línea 674 (Filtro FO) |
| SupergasEnvasado | Supergas | PVP, MargenGLPEnvasado, TasaVenta, IVAVentaPublico, PIT, MargenEnvasado, Margen, TasaDist, IVADistribucion, PEPImp, TasaPrim, FUDAEE, IVAPrimaria, PEP, Factor, Ursea, MontoDiferencial, PPIN1, PPIN2 | línea 678 (Filtro Supergas) |
| PropanoGLPGranel | Propano, Supergas A Granel, Propano Industrial | PVP, Margen, TasaDist, IVADistribucion, PEPImp, TasaPrim, FUDAEE, IVAPrimaria, PEP, Factor, Ursea, PPIN1, PPIN2 | línea 679 (Filtro Propano) |
| QuerosenoMontevideo | Queroseno Montevideo | PVP, Bonificacion, TasaVenta, PIT, Margen, TasaDist, PEPImp, IMESI, TasaPrim, FUDAEE, PEP | línea 673 (Filtro QMontevideo) |
| QuerosenoInterior | Queroseno Interior | PVP, Bonificacion, TasaVenta, PIT, Margen, TasaDist, PEPImp, Flete, TasaSec, IVASec, PEPSinFlete, IMESI, TasaPrim, FUDAEE, PEP | línea 673 (Filtro QInterior) |
| Butano | Butano Desodorizado | PVP, PEPSinFlete, TasaInflamable, TasaPrim, FUDAEE, IVAPrimaria, PEP | línea 677 (Filtro Butano) |

---

## Bugs encontrados vs. estado anterior del RDL

| Familia | Vista | Bug | Acción |
|---|---|---|---|
| LiquidosBase | Summary | Faltaba MontoDiferencial en whitelist | Agregar MontoDiferencial |
| LiquidosAv | Detail | Faltaba Ursea en whitelist | Agregar Ursea |
| SolventesEspeciales | Detail | Faltaban TasaDist, TasaPrim, FUDAEE, Ursea | Agregar los 4 |
| FuelOils | Detail | Usaba `Return True` (exceso) | Poner whitelist explícito de 13 cols |
| PropanoGLPGranel | Detail | Usaba `Return True` (exceso) | Poner whitelist explícito de 13 cols |
| QuerosenoMontevideo | Detail | Usaba `Return True` (exceso) | Poner whitelist explícito de 11 cols |
| QuerosenoInterior | Detail | Usaba `Return True` (exceso) | Poner whitelist explícito de 15 cols |
| Butano | Detail | Usaba `Return True` (exceso) | Poner whitelist explícito de 7 cols |
