---
name: component-corner-cell
description: Celda esquina de un tablix (intersección entre la columna de identificación y la fila de header de meses). Sin borde superior ni izquierdo, con label de unidad. Usada en reportes de precios para indicar la unidad de medida (USD/m3, $/lt ó $/kg).
---

# Componente — Corner cell (celda esquina del tablix)

La celda esquina es la primera celda de la fila header de un tablix — la que queda en la intersección con la columna de identificación (producto/unidad). En reportes de precios ANCAP, muestra la unidad de medida y no tiene borde superior ni izquierdo para integrarse visualmente con el fondo del body.

## Estructura RDL

Cuando la columna de identificación es **una sola** (ej. USD/m3 — solo producto):

```xml
<TablixCell>
  <CellContents>
    <Textbox Name="hdrUsdCorner">
      <CanGrow>true</CanGrow>
      <KeepTogether>true</KeepTogether>
      <Paragraphs>
        <Paragraph>
          <TextRuns>
            <TextRun>
              <Value>USD/m3</Value>
              <Style>
                <FontSize>8pt</FontSize>
              </Style>
            </TextRun>
          </TextRuns>
          <Style><TextAlign>Center</TextAlign></Style>
        </Paragraph>
      </Paragraphs>
      <Style>
        <Border><Style>None</Style></Border>
        <TopBorder><Style>None</Style></TopBorder>
        <LeftBorder><Style>None</Style></LeftBorder>
        <RightBorder><Color>Gray</Color><Style>Solid</Style></RightBorder>
        <BottomBorder><Color>Gray</Color><Style>Solid</Style></BottomBorder>
        <BackgroundColor>White</BackgroundColor>
      </Style>
    </Textbox>
  </CellContents>
</TablixCell>
```

Cuando la columna de identificación es **doble** (ej. $/lt ó $/kg — producto + unidad), la esquina ocupa dos celdas:

```xml
<!-- Celda 0 — ocupa el ancho de la columna producto (más ancha) -->
<TablixCell>
  <CellContents>
    <Textbox Name="hdrUyu0">
      <CanGrow>true</CanGrow>
      <KeepTogether>true</KeepTogether>
      <Paragraphs>
        <Paragraph>
          <TextRuns>
            <TextRun>
              <Value>$/lt ó $/kg</Value>
              <Style><FontSize>8pt</FontSize></Style>
            </TextRun>
          </TextRuns>
          <Style><TextAlign>Center</TextAlign></Style>
        </Paragraph>
      </Paragraphs>
      <Style>
        <Border><Style>None</Style></Border>
        <TopBorder><Style>None</Style></TopBorder>
        <LeftBorder><Style>None</Style></LeftBorder>
        <RightBorder><Style>None</Style></RightBorder>   <!-- sin separador entre las dos celdas de id -->
        <BottomBorder><Color>Gray</Color><Style>Solid</Style></BottomBorder>
        <BackgroundColor>White</BackgroundColor>
      </Style>
    </Textbox>
  </CellContents>
</TablixCell>

<!-- Celda 1 — ocupa el ancho de la columna unidad (más angosta) -->
<TablixCell>
  <CellContents>
    <Textbox Name="hdrUyu1">
      <CanGrow>true</CanGrow>
      <KeepTogether>true</KeepTogether>
      <Paragraphs>
        <Paragraph>
          <TextRuns>
            <TextRun>
              <Value />
              <Style />
            </TextRun>
          </TextRuns>
          <Style />
        </Paragraph>
      </Paragraphs>
      <Style>
        <Border><Style>None</Style></Border>
        <TopBorder><Style>None</Style></TopBorder>
        <LeftBorder><Style>None</Style></LeftBorder>
        <RightBorder><Color>Gray</Color><Style>Solid</Style></RightBorder>  <!-- separador con primer mes -->
        <BottomBorder><Color>Gray</Color><Style>Solid</Style></BottomBorder>
        <BackgroundColor>White</BackgroundColor>
      </Style>
    </Textbox>
  </CellContents>
</TablixCell>
```

## Regla de bordes

| Borde | Valor | Razón |
|---|---|---|
| Top | None | Se integra con el fondo del body (sin línea superior visible) |
| Left | None | Borde izquierdo del tablix ya lo da el body |
| Right | Gray Solid | Separa la zona de identificación de los meses |
| Bottom | Gray Solid | Delimita el header del detalle |

En la variante de doble columna: el `RightBorder` de la celda 0 es `None` (las dos celdas de identificación forman un bloque continuo). Solo la celda 1 tiene `RightBorder Gray Solid`.

## Label

- El label de la corner cell indica la unidad de medida del tablix.
- Si el tablix tiene una sola rama (ej. solo USD/m3): label fijo `"USD/m3"`.
- Si el tablix corresponde a la rama UYU: label `"$/lt ó $/kg"` en la celda más ancha (producto).
- El label no incluye el nombre de la columna "Producto" — eso se da por contexto visual.

## Visibilidad cuando no hay datos

A diferencia de los headers de columnas de datos (que se ocultan via `Count(...) = 0`), la corner cell no tiene lógica de visibilidad por defecto → se renderiza incluso cuando el tablix queda sin filas. Resultado: aparece un cuadradito aislado "USD/m3" en la esquina superior izquierda del área de datos, sin headers ni filas alrededor.

Fix: agregar `Visibility.Hidden = CountRows("ds...") = 0` al textbox del corner. Ejemplo:

```xml
<Textbox Name="hdrUsdCorner">
  <CanGrow>true</CanGrow>
  <KeepTogether>true</KeepTogether>
  <Paragraphs>...</Paragraphs>
  <Visibility>
    <Hidden>=CountRows("dsDetalle") = 0</Hidden>
  </Visibility>
  <Style>...</Style>
</Textbox>
```

Donde `dsDetalle` es el dataset que alimenta el tablix. Si el reporte tiene un textbox standalone tipo `txtEmptyState` con el mensaje "No hay datos disponibles", el corner queda oculto y solo se ve ese mensaje, igual que Cognos.

## Errores comunes

- Aplicar el mismo tratamiento de bordes a ambas celdas en la variante doble → borde vertical entre las dos celdas de identificación, rompiendo la unidad visual del bloque.
- Poner `BackgroundColor` con el color de header (#153767) → la celda queda oscura cuando debería ser blanca (sin unidad seleccionada).
- Olvidar `<Border><Style>None</Style></Border>` antes de los bordes individuales → el border general (Solid) puede pisar a los bordes individuales según el renderer.
- No agregar visibilidad por `CountRows = 0` → corner cell aparece como cuadrado aislado cuando el tablix queda sin datos.
