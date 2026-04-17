---
name: cognos-report-migrator
description: Skill maestra del workspace de migración Cognos → Power BI Report Builder. Úsela como punto de entrada siempre que el usuario quiera crear un reporte nuevo, retomar uno en curso, cerrar uno existente, o cuando mencione migración, Cognos, .rdl, Report Builder, drill-through, o reportes dentro de este repo. Coordina las 3 capas de skills (base, playbooks, por reporte) y el ciclo completo: intake → match con playbook → implementación iterativa con bitácora → retrospectiva → promoción de conocimiento.
---

# Cognos Report Migrator (Capa 1 — Base)

Skill maestra. Todo flujo en este workspace arranca acá. No conoce reportes puntuales ni patrones específicos: sabe **cómo se trabaja** en el proyecto y cómo orquestar las otras dos capas.

## Arquitectura de 3 capas

| Capa | Ubicación | Rol | Cantidad |
|---|---|---|---|
| 1 — Base | `skills/base/SKILL.md` | Este archivo. Ciclo de vida, reglas universales, convenciones. Cliente-agnóstica. | 1 |
| 2 — Playbooks | `skills/playbooks/<slug>.md` | Un patrón de reporte por archivo. Pasos específicos, señales de que aplica, errores comunes. | N |
| 3 — Por reporte | `reports/<slug>/SKILL.md` | Bitácora viva del reporte: playbook elegido, iteraciones, decisiones, evidencia. | 1 por reporte |

La Capa 1 **lee** Capa 2 para proponer matches; **crea** y **escribe** Capa 3 durante cada iteración. La Capa 3 no se comparte entre reportes.

## Ámbito

- **Sí:** reconstruir reportes IBM Cognos Analytics como `.rdl` de Power BI Report Builder a partir de XML Spec, queries, PDF, screenshots, drill-through, prompts y reglas de negocio del Cognos original.
- **No:** automatizar la conversión 1-a-1, migrar cubos, ETL, administración de Report Server.

## Ciclo de vida de un reporte

```
1. Intake            → carpeta + inputs + skill Capa 3 + report.yaml (status: intake)
2. Match con playbook→ propuesta + confirmación del usuario (status: in-progress)
3. Implementación    → iteraciones con bitácora en Capa 3
4. Validación        → evidencia comparable contra Cognos (status: review)
5. Cierre            → status: done dispara retrospectiva
6. Retrospectiva     → promoción/edición de playbooks y reglas universales
```

Cada transición de `status` en `report.yaml` es el disparador del siguiente paso. Nunca saltarse un paso; si falta material, dejarlo como `open_questions` en `report.yaml` y seguir con lo disponible.

---

## Paso 1 — Intake (reporte nuevo)

Disparadores: el usuario pide crear un reporte nuevo, o aparece una carpeta nueva en `reports/<slug>/inputs/` sin `SKILL.md` ni `report.yaml`.

### Qué hacer

1. **Definir el slug** con el usuario (kebab-case, sin espacios, refleja el nombre del reporte). Ejemplo: `precios-unitarios-ex-planta-base`.
2. **Crear la estructura mínima** en `reports/<slug>/`:
   ```
   reports/<slug>/
   ├── inputs/          (el usuario deposita aquí los insumos Cognos)
   ├── output/          (el .rdl final y artefactos generados)
   ├── SKILL.md         (bitácora Capa 3, desde template)
   └── report.yaml      (metadata, desde template)
   ```
3. **Materializar `SKILL.md`** desde `skills/base/templates/report-skill.md` reemplazando los placeholders.
4. **Materializar `report.yaml`** desde `skills/base/templates/report.yaml` con `status: intake`.
5. **Inventariar `inputs/`** y categorizar lo que hay (xml-spec, queries, pdf, screenshots, mappings, assets, notes). Lo que falte, registrarlo en `report.yaml:open_questions` — no pedirlo todo junto, pedir lo que bloquea el siguiente paso.

### Orden de lectura de los inputs (no negociable)

1. `inputs/queries/` y consultas derivadas
2. `inputs/xml-spec/`
3. prompts, parámetros, drill-through y wiring visible en el XML
4. PDF y screenshots de referencia
5. mappings, notas funcionales y documentación auxiliar
6. `.rdl` existente si lo hay — **sólo al final**, y sólo para verificar, nunca para deducir

Si hay conflicto entre el `.rdl` existente y Cognos, **Cognos gana** hasta probar lo contrario.

---

## Paso 2 — Match con playbook (Capa 2)

1. Listar `skills/playbooks/*.md` y leer el frontmatter `description` de cada uno.
2. Comparar las señales de cada playbook contra lo observado en los inputs.
3. Proponer al usuario **uno de estos 4 resultados**:
   - **Match simple:** un playbook cubre el reporte. → Adoptar.
   - **Match combinado:** varios playbooks aplican en capas (ej. `matriz-comportamiento` + `drill-through-base-detalle`). → Adoptar ambos, ordenados.
   - **Match parcial:** un playbook cubre el 70% pero falta un pedazo. → Adoptar y anotar el delta en `SKILL.md` Capa 3 como candidato a enmienda de playbook en la retro.
   - **Sin match:** patrón nuevo. → Avisar al usuario que la retro probablemente genere un playbook nuevo. Seguir con reglas universales de esta Capa 1.
4. **Confirmar explícitamente** antes de adoptar. Registrar la decisión en `reports/<slug>/SKILL.md` (sección "Playbook elegido") con timestamp y justificación.
5. Pasar `report.yaml:status` a `in-progress`.

---

## Paso 3 — Implementación iterativa

Ejecutar los pasos del playbook elegido (Capa 2). Independiente de cuál sea, **cada iteración** deja una entrada en la bitácora de Capa 3 con la estructura del template:

- **Pregunta/problema** — qué se estaba resolviendo.
- **Decisión** — qué se decidió y por qué.
- **Acción** — qué cambió concretamente (archivos tocados, queries agregadas, etc.).
- **Evidencia** — screenshots, valores comparados, ruta del `.rdl`.
- **Próximo paso** o bloqueante.

La bitácora es la fuente de la retrospectiva; no escatimar en registrarla.

### Reglas universales de construcción (aplican a todos los playbooks)

Estas reglas son de Capa 1 porque trascienden cualquier patrón:

- **Queries mandan.** El `.rdl` viejo no es fuente de verdad.
- **Inventario funcional antes de tocar el `.rdl`:** parámetros (visibles y ocultos), defaults, labels exactos, datasets de prompts, dataset principal, auxiliares, columnas/medidas/data items, filtros, orden, agrupaciones, visibilidad, drill-through.
- **Separar normalización de parámetros de la lógica de layout.**
- **No recrear conversiones** si Cognos ya expone campos paralelos (moneda, unidad).
- **Construir el RDL por capas** en este orden: datasource → datasets de parámetros → datasets auxiliares → dataset principal → parámetros → layout base → tablix/matrix por rama funcional → expresiones de visibilidad → header/footer/logos → detalle fino.
- **Si Cognos ramifica estructura,** preferir tablixes o datasets separados antes que una sola grilla con condiciones opacas.
- **No inferir lógica sólo desde screenshots.**

---

## Paso 4 — Validación

Orden de validación (aplica a cualquier reporte; el playbook puede añadir validaciones específicas):

1. El `.rdl` abre en Report Builder.
2. Ejecuta sin errores.
3. Los parámetros funcionan (incluyendo defaults y hidden).
4. Cada dataset devuelve lo esperado.
5. Los valores coinciden con Cognos en los escenarios de referencia.
6. El layout coincide visualmente (PDF/screenshots de referencia).
7. Exporta correctamente a PDF/Excel si corresponde.
8. Si hay drill-through, los parámetros se transmiten y los reportes hijos abren.

Validación estructural del `.rdl` (nombres únicos, `ReportParametersLayout`, widths serializados, encoding sin mojibake, rutas de drill-through) puede apoyarse en los scripts de `tools/validation/` cuando existan para ese reporte.

No validar a ojo. **Evidencia comparable** o no cuenta.

Pasar `report.yaml:status` a `review` al entrar en validación y a `done` sólo cuando el usuario lo apruebe.

---

## Paso 5 — Retrospectiva (disparada por `status: done`)

Cuando `report.yaml` pasa a `status: done`, la Capa 1 **propone** al usuario hacer la retrospectiva (no la fuerza — el usuario puede decir "después"). Si acepta:

1. Leer la bitácora completa de `reports/<slug>/SKILL.md`.
2. Clasificar cada decisión/lección en una de estas categorías:
   - **Local al reporte** — se queda en Capa 3, no se promueve.
   - **Refuerza el playbook usado** — se propone enmienda al playbook Capa 2 (nueva señal, nuevo paso, nuevo error común).
   - **Playbook nuevo** — el patrón no existía; proponer crear `skills/playbooks/<nuevo-slug>.md`.
   - **Regla universal** — aplica a todos los reportes; proponer edición de este `SKILL.md` Capa 1.
   - **Automatizable** — ir a `tools/` como script.
3. **Confirmar con el usuario cada promoción por separado** antes de escribir.
4. Registrar la retro al final de `reports/<slug>/SKILL.md` en una sección "Retrospectiva" con fecha y links a los cambios propagados.

El objetivo del loop: cada reporte deja más chico el trabajo del siguiente.

---

## Convenciones del workspace

- **Slug del reporte:** kebab-case, estable, único. Coincide con el nombre de la carpeta y con `report.yaml:slug`.
- **`.rdl` final:** vive en `reports/<slug>/output/`. Nombre en PascalCase con guiones bajos si se quiere (`Precios_Unitarios_Ex_Planta_Base.rdl`).
- **Insumos Cognos:** en `reports/<slug>/inputs/`, subdivididos por tipo (`xml-spec/`, `queries/`, `pdf/`, `screenshots/`, `mappings/`, `assets/`, `notes/`). Sólo crear las subcarpetas que aplican.
- **Evidencia de validación:** en `reports/<slug>/output/validation/` cuando aplique.
- **Scripts de validación reusables:** se promueven a `tools/validation/` en la retro (paso 5, categoría "automatizable").
- **Scripts puntuales del reporte:** quedan en `reports/<slug>/output/scripts/`.

### Layout heredado (reportes previos a esta arquitectura)

Los reportes existentes (`precios-unitarios-ex-planta-base`, `precios-unitarios-ex-planta-detalle`, `tc-promedio-mensual`) tienen el `.rdl` en la raíz del reporte y subcarpetas `work/`, `validations/`, `docs/` en vez de `output/`. **No migrar** esos reportes al layout nuevo a menos que el usuario lo pida explícitamente. Para **reportes nuevos** usar siempre el layout definido arriba.

---

## Bootstrap en un cliente nuevo

Esta skill base es cliente-agnóstica. Para replicar el workspace en otro cliente:

1. Copiar `skills/base/`, `skills/playbooks/`, `tools/`, `.gitignore` al repo nuevo.
2. Crear `reports/` vacío.
3. Crear un README específico del cliente si hace falta.
4. No copiar `_archive/` (es historia de este cliente).
5. Los playbooks Capa 2 son reusables entre clientes: arrancar con los que ya existen y dejar que el loop de retro los extienda.

---

## Reglas duras (no se negocian)

- Nunca empezar deduciendo comportamiento desde el `.rdl`.
- Nunca inferir lógica sólo desde screenshots.
- Nunca asumir una grilla única si Cognos cambia por familia o rama.
- Nunca mezclar en la misma familia productos que usan datasets o columnas distintas.
- Nunca recrear conversiones nuevas si Cognos ya expone campos paralelos.
- Siempre separar normalización de parámetros de la lógica de layout.
- Siempre dejar rastro en la bitácora Capa 3 antes de cerrar una iteración.
- Siempre confirmar con el usuario antes de adoptar un playbook, cerrar un reporte, o promover conocimiento.

---

## Errores comunes a nivel proyecto

- Arrancar a implementar sin hacer intake ni match → se descubre tarde que faltan inputs.
- Saltarse la bitácora por "ir rápido" → la retro se vuelve inútil y el loop de mejora se rompe.
- Promover a playbook cosas que eran específicas del reporte → contamina la Capa 2.
- No promover a playbook cosas que se repitieron → se paga el mismo costo en el próximo reporte.
- Confundir "funciona" con "validado contra Cognos con evidencia".

---

## Templates

- `skills/base/templates/report-skill.md` — bitácora Capa 3.
- `skills/base/templates/report.yaml` — metadata del reporte.

## Playbooks iniciales (Capa 2)

- `skills/playbooks/reporte-lineal-simple.md`
- `skills/playbooks/matriz-comportamiento.md`
- `skills/playbooks/drill-through-base-detalle.md`
