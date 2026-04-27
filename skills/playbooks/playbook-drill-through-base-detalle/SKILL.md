---
name: playbook-drill-through-base-detalle
description: Playbook para familias de reportes donde un reporte padre abre uno o más reportes hijos vía drill-through. Cada reporte vive como standalone en su propia carpeta, pero comparten parámetros y contrato de navegación. Encaja cuando hay un "base" y un "detalle" (o varios detalles) que deben migrarse juntos. Combinable con otros playbooks para el contenido interno de cada reporte.
---

# Playbook — Drill-through base + detalle

**Capa 2.** Patrón estructural — trata la relación entre reportes, no el contenido de cada uno. Se combina con el playbook del contenido (`reporte-lineal-simple` o `matriz-comportamiento`) aplicado a cada reporte individualmente.

## Cuándo aplica

Señales típicas:

- Cognos tiene un reporte "principal" que enlaza a uno o más reportes "hijos".
- El drill-through pasa parámetros (típicamente identificadores, claves de fila, fechas).
- Los reportes hijos se abren en ventana/tab nueva y funcionan standalone si se les pasa los parámetros correctos.
- El PDF/documentación los trata como un conjunto.
- En el XML Spec hay `drillLinks` o acciones con parámetros explícitos.

**Ejemplo en este repo:** `reports/precios-unitarios-ex-planta-base/` (padre) + `reports/precios-unitarios-ex-planta-detalle/` (hijo).

## Cuándo NO aplica

- El drill-through es a un reporte externo que no se va a migrar → tratar el padre como lineal o con matriz, ignorar el drill.
- El "detalle" está embebido dentro del mismo `.rdl` como subreport o sección → no es drill-through, es layout interno.

## Principio: reportes independientes

**Cada reporte (padre e hijos) vive en su propia carpeta `reports/<slug>/` y es independiente.** Se puede abrir y validar por separado pasándole sus parámetros. El drill-through es una acción de navegación, no una dependencia estructural.

Ventajas:
- Cada uno tiene su propio `report.yaml`, `SKILL.md`, `inputs/`, `output/`.
- Cada uno elige su playbook de contenido (pueden ser distintos).
- Validación aislada posible.
- Cambios en uno no rompen al otro mientras respeten el contrato de parámetros.

## Pasos

1. **Identificar la familia.** Listar el reporte padre y cada hijo. Darles slugs consistentes (prefijo común, sufijo `-base`, `-detalle`, `-detalle-<qué>`). Crear una carpeta standalone por cada uno vía el flujo normal de intake de la Capa 1.

2. **Contrato de parámetros del drill-through.** Documentar explícitamente en el `SKILL.md` Capa 3 **de ambos reportes**:
   - Qué parámetros envía el padre.
   - Con qué nombre los recibe el hijo (puede haber renombre).
   - Qué normalizaciones se aplican entre envío y recepción.
   - Qué valores son mandatorios y qué defaults tiene el hijo si se abre standalone.
   - Qué parámetros son ocultos vs. visibles en el hijo.

   Este contrato es el **único acoplamiento** entre los reportes.

3. **Elegir playbook de contenido por reporte.** El padre y los hijos pueden necesitar playbooks distintos. Ejemplo: padre con `matriz-comportamiento`, hijo con `reporte-lineal-simple`. Registrar en el `report.yaml:playbooks` y en `SKILL.md:Playbook elegido` de cada uno.

4. **Separar inputs.**
   - Queries, XML Spec, screenshots, PDFs propios de cada reporte van en **su** `inputs/`.
   - Lo común (mappings, assets compartidos, logos) se duplica mínimamente si es necesario para que cada reporte sea autónomo. **No inventar** un directorio compartido `shared/`.
   - Evidencia visual del padre y del hijo estrictamente separadas — screenshots del padre en `<padre>/inputs/screenshots/`, del hijo en `<hijo>/inputs/screenshots/`.

5. **Implementar cada reporte siguiendo su playbook de contenido.** Trabajarlos en el orden que el usuario prefiera. Recomendado: empezar por el hijo si es más simple (queda validable standalone sin depender del padre) y después el padre con la acción de drill apuntando al hijo ya funcional.

6. **Acción de drill en el padre.**
   - En el RDL del padre: `Action` tipo "Go to report" con nombre/path del hijo y parámetros explícitos.
   - Los nombres de parámetros en la acción deben coincidir con los parámetros del hijo (o aplicar el renombre documentado).
   - Usar expresiones para construir los valores, no literales, cuando el valor viene de la fila.

7. **Validación del contrato.**
   - Validar cada reporte standalone primero (contra Cognos, usando su playbook de contenido).
   - Validar la navegación: clickear el drill en el padre y verificar que el hijo abre con los valores correctos.
   - Validar casos borde: fila sin valor, parámetro nulo, parámetro con caracteres especiales.
   - Validar que el hijo abierto standalone con los mismos parámetros muestra lo mismo que abierto vía drill.

## Reglas duras

- Cada reporte es standalone. Nunca compartir `.rdl` parcial entre reportes de la familia.
- El contrato de parámetros va escrito en los `SKILL.md` de **ambos** lados.
- No esconder lógica del hijo en el padre ni viceversa.
- Si el padre y el hijo comparten una regla de negocio, documentarla en ambos o promoverla a `skills/base/` en la retro.

## Errores comunes

- Tratar al hijo como un subreport embebido → se pierde la capacidad de abrirlo standalone.
- Duplicar queries entre padre e hijo sin darse cuenta → terminan desincronizadas.
- Renombrar parámetros en el drill sin documentar → se rompe cuando otro desarrollador toca uno de los reportes.
- Validar sólo vía drill y nunca standalone → problemas del hijo pasan desapercibidos.
- Mezclar screenshots de padre e hijo en la misma carpeta de evidencia.

## Entregable mínimo

- Una carpeta `reports/<slug>/` por cada reporte de la familia, todas con su `.rdl`, `report.yaml`, `SKILL.md`, `inputs/`, `output/`.
- Contrato de parámetros del drill documentado en los `SKILL.md` de padre e hijo(s).
- Validación standalone de cada reporte + validación de navegación drill-through con evidencia.
- Playbook de contenido registrado en el `report.yaml` de cada reporte.
