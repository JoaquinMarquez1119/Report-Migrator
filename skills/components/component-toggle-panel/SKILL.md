---
name: component-toggle-panel
description: Panel de texto colapsable con toggle en Power BI Report Builder / SSRS. Arranca colapsado o expandido. El push-down en el Power BI Service requiere estructura específica de dos Rectangle hermanos en el Body.
---

# Componente — Toggle panel

Panel de texto que el usuario puede mostrar/ocultar haciendo click en un textbox de enlace.

## Estructura RDL

El Service **no hace push-down** dentro de un `Rectangle` con layout absoluto. Si el panel y el contenido siguiente están en el mismo contenedor, el espacio del panel oculto se preserva (gap visible) y al expandir puede superponerse con los items de abajo.

**Solución correcta para el Service:** dos `<Rectangle>` hermanos directamente en el `<Body>`. El Body sí respeta push-down entre siblings.

```xml
<Body>
  <ReportItems>

    <!-- Rect 1: contiene solo el toggle + el panel -->
    <Rectangle Name="rectDescription">
      <ReportItems>

        <Textbox Name="txtToggle">
          <CanGrow>true</CanGrow>
          <KeepTogether>true</KeepTogether>
          <Paragraphs>
            <Paragraph>
              <TextRuns>
                <TextRun>
                  <Value>¿Qué muestra este reporte?</Value>
                  <Style>
                    <FontSize>9pt</FontSize>
                    <TextDecoration>Underline</TextDecoration>
                    <Color>Blue</Color>
                  </Style>
                </TextRun>
              </TextRuns>
              <Style />
            </Paragraph>
          </Paragraphs>
          <Top>0.07in</Top>
          <Left>0.12in</Left>
          <Height>0.22in</Height>
          <Width>2.3in</Width>
          <Style><Border><Style>None</Style></Border></Style>
        </Textbox>

        <Textbox Name="txtDescripcion">
          <CanGrow>true</CanGrow>        <!-- CRÍTICO: permite que rectDescription crezca -->
          <KeepTogether>true</KeepTogether>
          <Paragraphs>
            <Paragraph>
              <TextRuns>
                <TextRun>
                  <Value>=First(Fields!Descripcion.Value, "dsDescripcion")</Value>
                  <Style><FontSize>8.5pt</FontSize></Style>
                </TextRun>
              </TextRuns>
              <Style />
            </Paragraph>
          </Paragraphs>
          <Top>0.33in</Top>
          <Left>0.12in</Left>
          <Height>1.3in</Height>       <!-- alto aproximado del contenido expandido -->
          <Width>9.8in</Width>
          <Visibility>
            <Hidden>true</Hidden>       <!-- false = arranca expandido -->
            <ToggleItem>txtToggle</ToggleItem>
          </Visibility>
          <Style><Border><Style>None</Style></Border></Style>
        </Textbox>

      </ReportItems>
      <Top>0in</Top>
      <Left>0in</Left>
      <Height>0.43in</Height>   <!-- alto colapsado = toggle height + buffer -->
      <Width>20.5in</Width>
      <!-- NO usar CanGrow en Rectangle — propiedad inválida en el schema RDL -->
      <Style><Border><Style>None</Style></Border></Style>
    </Rectangle>

    <!-- Rect 2: todo el contenido que debe bajar al expandir -->
    <Rectangle Name="rectContent">
      <ReportItems>
        <!-- ... resto del body ... -->
      </ReportItems>
      <Top>0.43in</Top>   <!-- = rectDescription.Height colapsado -->
      <Left>0in</Left>
      <Height>2.4in</Height>
      <Width>20.5in</Width>
      <Style><Border><Style>None</Style></Border></Style>
    </Rectangle>

  </ReportItems>
  <Height>2.83in</Height>   <!-- = rectDescription.Height + rectContent.Height -->
</Body>
```

## Propiedades clave

| Propiedad | Dónde | Valor | Notas |
|---|---|---|---|
| `CanGrow` | `txtDescripcion` | `true` | Permite que el Rectangle padre crezca al expandir |
| `Hidden` | `txtDescripcion > Visibility` | `true` / `false` | `true` = arranca colapsado |
| `ToggleItem` | `txtDescripcion > Visibility` | nombre del textbox toggle | Debe coincidir exactamente con `Name` del toggle |
| `CanGrow` | `Rectangle` | — | **No existe.** El Rectangle crece automáticamente si su hijo `Textbox` tiene `CanGrow=true` |

## Comportamiento en el Service

- **Colapsado:** `rectDescription` muestra solo el toggle (0.43in). `rectContent` queda inmediatamente abajo.
- **Expandido:** `txtDescripcion` crece con `CanGrow=true` → `rectDescription` se expande → `rectContent` se desplaza hacia abajo (push-down entre siblings en Body).
- **No funciona:** si toggle + panel + contenido siguiente están todos dentro del mismo `Rectangle`. El renderer del Service no hace push-down dentro de Rectangle con layout absoluto.

## Errores comunes

- Poner `CanGrow` en el `Rectangle` → error de deserialización al abrir el RDL. Solo aplica a `Textbox`.
- Dejar todo en un solo contenedor (`BodyCanvas` único) → al expandir, el contenido se superpone con el panel.
- `ToggleItem` apunta a un nombre incorrecto → el toggle no funciona, no hay error visible.
- `Hidden=true` inicial dentro de un Rectangle con siblings de `Top` absoluto → gap visible al colapsar, superposición al expandir.

## Variantes

- **Arranca expandido:** `<Hidden>false</Hidden>`. Al colapsar desde el Service funciona bien en ambas estructuras.
- **Descripción desde dataset:** `=First(Fields!Descripcion.Value, "dsDescripcion")` — requiere dataset adicional que devuelva el texto.
- **Descripción literal:** `<Value>Texto fijo aquí</Value>` — no requiere dataset.
