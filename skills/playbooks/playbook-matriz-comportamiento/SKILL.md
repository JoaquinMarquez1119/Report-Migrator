---
name: playbook-matriz-comportamiento
description: Playbook para reportes Cognos donde la estructura visible cambia según parámetros, familia, unidad, año, mercado o dataset. Antes de construir el .rdl hay que destilar una matriz de comportamiento desde queries y XML Spec. Encaja cuando el layout solo no explica el reporte y hay ramas funcionales o varias queries que alimentan vistas distintas.
---

# Playbook — Matriz de comportamiento

**Capa 2.** Para reportes no lineales. Se puede combinar con `drill-through-base-detalle`.

## Cuándo aplica

Señales típicas:

- Cambian columnas o secciones según producto, unidad, año, mercado o vista.
- Hay varias queries, `union` o ramas funcionales.
- El drill-through envía parámetros que luego se normalizan.
- El layout visible no alcanza para explicar el comportamiento real.
- Comparar manualmente Cognos ↔ RDL genera iteración excesiva sin matriz.
- Cognos muestra más/menos columnas que Report Builder para el mismo corte → señal de que falta modelar la matriz explícitamente.

**Ejemplo en este repo:** `reports/precios-unitarios-ex-planta-base/` — varias queries, columnas cambian por familia de producto, reglas por año.

## Cuándo NO aplica

- Columnas fijas, un dataset → `reporte-lineal-simple`.
- El reporte sólo cambia por filtros de filas, no por estructura → `reporte-lineal-simple`.

## Regla central

**Cognos es la fuente de verdad.** El `.rdl` existente se usa sólo al final para verificar si la implementación respeta la matriz deducida, nunca para deducirla.

## Pasos

1. **Lectura ordenada** (no negociable):
   1. queries de Cognos y queries derivadas
   2. XML Spec, prompt pages, wiring de parámetros
   3. screenshots y PDF
   4. `.rdl` existente — sólo al final

2. **Destilar la matriz de comportamiento.** Mínimo:
   - tabla de normalización de parámetros (nombre técnico, label, default, hidden, valores por drill-through)
   - matriz por familias con: productos/miembros, parámetros que cambian estructura, qué se muestra en cada vista, dataset/rama que la sostiene, reglas especiales
   - contrato de origen de datasets por vista o sección
   - reglas especiales y cutovers (cambios por año, metodología, renombres)
   - escenarios mínimos de validación (uno por familia como mínimo)

   Guardar la matriz en `reports/<slug>/SKILL.md` (sección "Inventario funcional" y subsección "Matriz de comportamiento"). Si es grande, archivo aparte en `reports/<slug>/inputs/notes/matriz-comportamiento.md`.

3. **Cómo deducir familias.**
   - No agrupar por nombre comercial por defecto.
   - Separar familias sólo cuando Cognos cambie de forma estable en: columnas visibles, dataset/rama, conversiones por unidad, labels/renombres, orden de conceptos, comportamiento de estado vacío.
   - Si dos productos comparten todo eso → misma familia aunque tengan nombres distintos.
   - Si un producto cambia en una sola dimensión de forma estable → familia aparte.

4. **Mapeo Cognos → RDL.**
   - query Cognos → dataset RDL (puede haber varios).
   - prompt Cognos → report parameter + dataset de prompt.
   - data item calculado → field o expresión, documentando cuál.
   - member property → columna derivada.
   - list/crosstab ramificado → **tablixes separados por rama** antes que una sola grilla con condiciones opacas.
   - conditional render → expresión de visibilidad explícita.

5. **Construcción del RDL por capas.**
   - datasource
   - datasets de parámetros
   - datasets auxiliares
   - datasets principales (uno por rama funcional si hace falta)
   - parámetros con normalización separada del layout
   - layout base
   - un tablix/matrix por familia o rama funcional
   - expresiones visuales y de visibilidad explícitas
   - header/footer/logos/detalle fino

6. **Validación por familia.**
   - Al menos un escenario por familia.
   - Verificar columnas presentes/ausentes, no sólo valores.
   - Verificar labels exactos, renombres, notas/footers condicionales, mensajes de estado vacío.
   - Verificar cutovers (ejecutar con parámetros de año anterior y posterior al cutover si aplica).

## Reglas duras

- Nunca deducir familias sólo desde screenshots.
- Nunca tomar el `.rdl` como fuente primaria.
- **Nunca tomar una `behavior-matrix.md` inferida en sesiones anteriores como fuente primaria.** Si existe, validarla columna por columna contra el XML spec antes de usarla. La matriz inferida es un atajo, el XML spec es la fuente.
- Nunca asumir una grilla genérica si Cognos ramifica.
- Nunca mezclar en una familia productos que usan distinta rama de datos.
- Nunca recrear conversiones si Cognos ya expone campos paralelos (USD/local, unidad, etc.).
- **Whitelist explícita por familia, no `Return True` genérico.** En `IsColumnAllowed(viewKey, familia, …)` (o equivalente), enumerar las columnas permitidas de cada familia/vista. Un fallback `Return True` permite columnas que el XML spec restringe → aparecen columnas de más en el render.
- **Validar orden de columnas en TODOS los tablixes, no solo el visible.** Cuando el reporte tiene varios tablixes (Resumen + Detalle, USD + Local), un cambio de orden en uno suele olvidar el otro. Comparar el orden de cada tablix contra Cognos.
- Separar normalización de parámetros de la lógica de layout.

## Errores comunes

- Empezar desde el `.rdl` y recién después revisar Cognos.
- Listar columnas sin documentar el dataset origen de cada una.
- Asumir que una columna ausente es "cero" cuando es una regla de visibilidad.
- Olvidar cutovers por año o cambios metodológicos.
- Describir el comportamiento por producto exacto cuando la regla real es por familia.
- Esconder diferencias estructurales con columnas ocultas en vez de modelarlas.

## Entregable mínimo

Antes de dar por cerrado:

- Matriz de comportamiento escrita.
- Parámetros normalizados documentados.
- Mapeo Cognos → RDL explícito.
- Escenarios representativos de validación (uno por familia mínimo) con evidencia comparable.
- Reglas especiales y cutovers listados en `reports/<slug>/SKILL.md`.
