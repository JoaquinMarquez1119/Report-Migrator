# Cognos Behavior Matrix - Precios Unitarios Ex Planta - detalle

Aplicacion de la skill `cognos-to-report-builder-behavior-matrix` para este reporte.

## 1. Inventario de fuentes de verdad

| Tipo de artefacto | Ubicacion | Que responde | Prioridad |
|---|---|---|---|
| Queries | `inputs/queries/Consulta3$.sql`, `inputs/queries/Consulta3USD.sql`, `inputs/queries/Ex Planta Nuevo FORMATO.sql`, `inputs/queries/Ex Planta Planilla Detalle.sql`, `inputs/queries/Densidades.sql`, `inputs/queries/Texto.sql`, `inputs/queries/Producto.sql`, `inputs/queries/pAño.sql` | Familias, conceptos, cutovers, ramas y soporte de prompts | Alta |
| XML spec / prompts | `inputs/xml-spec/xml-spec-cognos.xml` | Wiring de parametros, defaults funcionales, prompt page y nombres reales de queries | Alta |
| Screenshots | `inputs/screenshots/report-reference/Pagina Resumen - Gasolina Super 95 - 2025 - USD m3.png`, `inputs/screenshots/report-reference/Pagina Detalle - Gasoliona Super 95 - 2025 - USD m3.png`, `inputs/screenshots/report-reference/Pagina Resumen - Propano Industrial - 2022 - lit o kg.png`, `inputs/screenshots/report-reference/Pagina Detalle - Propano Industrial - 2022 - lit o kg.png` | Labels visibles, pestanas y evidencia de dos familias representativas | Media |
| PDF | `inputs/pdf/precios-unitarios-ex-planta-detalle.pdf` | Salida renderizada completa del reporte Cognos | Media |
| RDL actual | `Precios Unitarios Ex Planta - detalle.rdl` | Verificacion final de que la implementacion actual respeta la matriz | Baja |

Notas:

- La lectura primaria se hizo sobre queries y `xml-spec`.
- El PDF esta disponible, pero en esta sesion no hubo tooling local de Poppler (`pdftoppm`/`pdfinfo`) para re-renderizarlo automaticamente.

## 2. Normalizacion de parametros

| Parametro | Valores de entrada | Valor interno normalizado | Notas |
|---|---|---|---|
| `pAnio` | anos de `Precios_ExPLanta_2_TM1` | entero del anio | Cognos excluye `Año Base` desde la query `pAño`. |
| `pProducto` | valor del drill del reporte padre o seleccion manual | se normaliza por nombre funcional | Casos confirmados: `Asfalto AC-20 -> Asfalto AC-30`, `Super 95 Sp -> Gasolina Super 95`, `Premium 97 Sp -> Gasolina Premium 97`, `Gasoil Comun -> Gasoil 50-S`, `Gasoil Especial -> Gasoil 10-S`, `Propano -> Propano Industrial`. |
| `pProducto` en prompt Cognos | `GLP`, `Propano Industrial`, `Supergas A Granel`, resto | prompt visible agrupa a `GLP -> Supergas` y `Propano Industrial` / `Supergas A Granel -> Propano` | La query `Producto` no expone todos los nombres internos tal cual salen de la tabla base. |
| `pUnidad` | `USD`, `USD/m3`, o unidad local | `USD/m3` o `$/lt o $/kg segun corresponda` | El drill del padre puede mandar `USD`/`UYU`; el detalle trabaja con labels equivalentes a Cognos. |
| `pVista` | no viene de Cognos | `Resumen` por default | Parametro oculto de Report Builder para la pestana activa. En Cognos la navegacion es parte del layout, no del prompt page. |

## 3. Matriz por familias de comportamiento

| Familia | Miembros incluidos | Parametros que afectan | Resumen | Detalle | Dataset o rama origen | Reglas especiales |
|---|---|---|---|---|---|---|
| Liquidos estandar | `Gasolina Super 95`, `Gasolina Premium 97`, `Gasoil 50-S`, `Gasoil 10-S`, `Gasolina Av 100 Octanos`, `Jet A1` | `pUnidad`, `pAnio` | `PVP`, `PEP imp.`, `PEP` | `PVP`, `PEP imp.`, `Tasa inflamable`, `IMESI`, `Tasa primaria`, `FUDAEE`, `PEP` | Resumen TM1 (`Consulta3$` / `Consulta3USD`) mas rama formato nuevo (`Ex Planta Nuevo FORMATO`) segun periodo; detalle desde `Ex Planta Planilla Detalle FINAL` | El corte TM1 general apaga esta rama despues de `202106`. |
| Solventes y especiales | `Aguarras`, `Solvente 1197`, `Disan`, `Base insecticida`, `Querosol`, `Hexano Comercial` | `pUnidad` | `PVP`, `PEP imp.`, `PEP` | `PVP`, `Margen distribucion`, `IVA distribucion`, `PEP imp.`, `Tasa inflamable`, `IMESI`, `IVA primaria`, `PEP` | Rama formato nuevo y planilla detalle | La nota `(*) Equivale al precio del Subtotal 3 del Informe URSEA` aplica a esta familia via query `Texto *`. |
| Fuel oils | `Fuel Oil Medio`, `Fuel Oil Pesado` | `pUnidad`, `pAnio` | `PVP`, `PEP imp.`, `PEP`, `Factor`, `PEP calculado por URSEA`, `PPI n-1`, `PPI n-2` | grilla detalle completa, con columnas sujetas a presencia real de datos | Rama formato nuevo / planilla detalle | Cognos separa esta familia con `Filtro_FO`. `PPI sin tasas e impuestos + Factor X` se relabela a `Precio Ex Planta (PEP)`. |
| Supergas envasado | `Supergas` | `pUnidad`, `pAnio` | `PVP`, `PIT`, `PEP imp.`, `PEP`, `Factor`, `PEP calculado por URSEA`, `Monto diferencial por zonas "d"`, `PPI n-1`, `PPI n-2` | `PVP`, `Margen GLP envasado`, `Tasa venta`, `IVA venta publico`, `PIT`, `Margen envasado`, `Margen distribucion`, `Tasa distribucion`, `IVA distribucion`, `PEP imp.`, `Tasa primaria`, `FUDAEE`, `IVA primaria`, `PEP`, `Factor`, `PEP calculado por URSEA`, `Monto diferencial`, `PPI n-1`, `PPI n-2` | Rama formato nuevo (`Ex Planta Nuevo FORMATO`) y planilla detalle con densidades cuando la unidad lo requiere | Cognos separa esta familia con `Filtro_Supergas`. `Factor d para GLP Dec 205/023` alimenta la salida visible de monto diferencial. Cutover TM1 propio despues de `202306`. |
| Propano y GLP granel | `Propano Industrial`, `Supergas A Granel`, `Propano Redes` | `pUnidad`, `pAnio` | `PVP`, `PEP imp.`, `PEP`, `Factor`, `PEP calculado por URSEA`, `PPI n-1`, `PPI n-2` | grilla detalle completa, sin `PIT` ni `Monto diferencial` como columnas obligatorias | Rama formato nuevo y planilla detalle | Cognos separa esta familia con `Filtro_Propano`. `Supergas A Granel` y `Propano Industrial` se agrupan en el prompt como `Propano`. Cutover TM1 propio despues de `202306`. |
| Queroseno Montevideo | `Queroseno Montevideo` | `pUnidad`, `pAnio` | `PVP`, `PIT`, `PEP imp.`, `PEP` | grilla detalle completa, con presencia real de conceptos | Resumen TM1 y rama formato nuevo | Tiene corte historico propio: despues de `202107` la rama TM1 deja de devolver datos visibles. |
| Queroseno Interior | `Queroseno Interior` | `pUnidad`, `pAnio` | `PVP`, `PIT`, `PEP imp.`, `PEP sin flete secundario`, `PEP` | grilla detalle completa, con presencia real de conceptos | Resumen TM1 y rama formato nuevo | Comparte el corte `202107`, pero se separa de Montevideo porque cambia la columna visible `PEP sin flete secundario`. |
| Butano | `Butano Desodorizado` | `pUnidad` | `PVP`, `PEP sin flete secundario`, `PEP` | grilla detalle completa, con columnas sujetas a datos | Rama formato nuevo / planilla detalle | Se separa porque su resumen es mas corto que el de GLP/propano y Cognos le asigna bandera propia (`Filtro_Butano`). |
| Asfaltos | `Asfalto AC-30`, `Asfalto 150/200`, `Asfalto MC1`, `Asfalto RC2` | `pUnidad`, `pAnio` | Resumen TM1/local con `Precio publico`, `Precio exonerado`, `IVA`, `Precio sin IVA`, `IMESI`, `Cotizacion`, `Precio sin impuesto`, `Precio ex planta` | grilla detalle completa, con columnas sujetas a datos | Resumen TM1/local y planilla detalle; el nombre entra por drill como `Asfalto AC-20` y se normaliza a `Asfalto AC-30` | Esta familia no usa el resumen secundario de formato nuevo. El caso `Asfalto AC-20` nunca debe modelarse como familia aparte. |

Para cada familia:

- Columnas ocultas: no son ceros implicitos; Cognos directamente cambia la estructura visible segun familia y unidad.
- Decimales: los conceptos monetarios principales van a 2 decimales; cargos y componentes secundarios usan 4.
- Estado vacio: si no hay filas en la rama elegida, el reporte muestra `No hay datos disponibles`.
- Diferencias por unidad: `USD/m3` obliga a usar conversion con `TC` y, para productos en `$/kg`, tambien con `Densidad`.

## 4. Contrato de origen de datasets

| Vista o seccion | Dataset o query origen | Por que aplica | Rama alternativa |
|---|---|---|---|
| Prompt `pAnio` | `pAño` | lista de anios valida y exclusion de `Año Base` | ninguna |
| Prompt `pProducto` | `Producto` | define el agrupamiento visible del selector y el remapeo `GLP`/`Propano` | ninguna |
| Nota / footer | `Texto *` / `Texto.sql` | muestra o elimina la nota URSEA segun producto | ninguna |
| Resumen TM1 historico local | `Consulta3$` | crosstab historica basada en `Precios_ExPLanta_2_TM1` | `Consulta3USD` para `USD/m3` |
| Resumen TM1 historico USD | `Consulta3USD` | crosstab historica con `Precio Ex Planta`, `Densidad`, `Demanda` y conversion a USD | `Consulta3$` si la vista es local |
| Resumen formato nuevo | `Ex Planta Nuevo FORMATO` mas cotizaciones asociadas | resume conceptos del esquema nuevo y respeta familias `FO`, `Supergas`, `Propano`, `Butano` | ninguna |
| Detalle local | `Ex Planta Planilla Detalle` -> `Ex Planta Planilla Detalle FINAL` | ordena conceptos, mantiene labels exactos y filtra por `pAnio`, `pProducto`, `pUnidad` | union con densidades para `USD/m3` |
| Detalle con conversion por densidad | `Densidades` + `Ex Planta Planilla Detalle FINAL con Densidad` | necesario para productos cuya unidad base es `$/kg` cuando la vista es `USD/m3` | detalle local sin union cuando la unidad no es `USD/m3` |

## 5. Reglas especiales

- Cognos es la fuente de verdad para familias y columnas; el `.rdl` solo confirma que la implementacion actual sigue esa deduccion.
- `PPI sin tasas e impuestos + Factor X` no siempre queda visible con ese nombre: para varias familias se relabela a `Precio Ex Planta (PEP)`.
- `Factor d para GLP Dec 205/023` es una regla de negocio propia de GLP y no debe perderse al resumirla como monto diferencial.
- La query `Texto *` define que algunos productos llevan nota URSEA y otros no; no es un detalle cosmetico.
- Hay tres cutovers historicos en la rama TM1:
  - querosenos: despues de `202107`
  - productos fuera de la lista especial (`asfaltos`, `GLP`, `querosenos`): despues de `202106`
  - `Supergas`, `Supergas A Granel`, `Propano Industrial`, `Propano Redes`: despues de `202306`
- `Densidad` y `TC` no son datasets decorativos: son parte del contrato para convertir correctamente a `USD/m3`.

## 6. Escenarios minimos de validacion

| Escenario | Por que existe | Parametros | Familia esperada | Que verificar |
|---|---|---|---|---|
| 1 | cubrir liquidos estandar en vista USD | `pAnio=2025`, `pProducto=Gasolina Super 95`, `pUnidad=USD/m3`, `pVista=Resumen` | Liquidos estandar | solo `PVP`, `PEP imp.`, `PEP`; sin columnas GLP ni FO |
| 2 | validar GLP con reglas propias | `pAnio=2025`, `pProducto=Supergas`, `pUnidad=$/lt o $/kg segun corresponda`, `pVista=Detalle` | Supergas envasado | aparecen `PIT`, `Margen GLP envasado`, `Margen envasado`, `Monto diferencial`, `PPIN1/2` |
| 3 | separar propano de supergas | `pAnio=2022`, `pProducto=Propano Industrial`, `pUnidad=$/lt o $/kg segun corresponda`, `pVista=Resumen` | Propano y GLP granel | no aparece `PIT` ni `Monto diferencial`; si aparecen `Factor`, `Ursea`, `PPIN1/2` |
| 4 | cubrir queroseno con estructura propia | `pAnio=2021`, `pProducto=Queroseno Interior`, `pUnidad=USD/m3`, `pVista=Resumen` | Queroseno Interior | aparece `PEP sin flete secundario`; si se corre despues del corte historico la rama TM1 no debe poblarse |
| 5 | validar normalizacion de drill | `pAnio=2022`, `pProducto=Asfalto AC-20`, `pUnidad=USD/m3`, `pVista=Resumen` | Asfaltos | el reporte trabaja como `Asfalto AC-30`; usa resumen TM1/local y no el secundario de formato nuevo |
| 6 | cubrir familia de solventes con nota URSEA | `pAnio=2025`, `pProducto=Aguarras`, `pUnidad=$/lt o $/kg segun corresponda`, `pVista=Detalle` | Solventes y especiales | aparecen columnas de margen/IVA distribucion y la nota `(*)` sigue la regla de `Texto *` |

## 7. Resumen para implementacion

- Las familias reales no son "todos los productos" ni "resumen vs detalle"; cambian por producto, unidad y periodo historico.
- `pAnio` y `pProducto` cambian estructura; `pUnidad` cambia dataset/expresiones y tambien puede requerir `Densidad`; `pVista` solo cambia la pestana activa en Report Builder.
- El reporte necesita ramas visibles distintas:
  - resumen TM1 historico
  - resumen formato nuevo
  - detalle local
  - detalle con conversion por densidad
- Las reglas mas peligrosas de re-inferir desde el `.rdl` son los cutovers (`202106`, `202107`, `202306`), el remapeo de `Propano`, y la separacion `Supergas` vs `Propano` vs `Butano`.
