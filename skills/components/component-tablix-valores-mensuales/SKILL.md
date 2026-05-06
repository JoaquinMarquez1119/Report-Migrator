---
name: component-tablix-valores-mensuales
description: Tablix con columnas de meses dinámicas (1-12) donde los meses sin data se ocultan via TablixMember.Visibility.Hidden. Columnas de valor centradas. Usado en reportes de precios con filas de producto y columnas de mes.
---

# Componente — Tablix de valores mensuales

Tablix con filas de producto y columnas de mes (Ene–Dic). Los meses sin data se ocultan dinámicamente. Las columnas de identificación (producto, unidad) son fijas a la izquierda.

## Estructura de columnas

```
| Col producto (1.45in) | Col unidad (0.62in) | Ene | Feb | Mar | ... | Dic |
```

- Las columnas de mes tienen ancho uniforme (0.65in recomendado — permite números de 4 dígitos + decimales centrados).
- Las columnas de mes se ocultan si no tienen datos via `TablixMember.Visibility.Hidden`.

## Estructura RDL (esquema)

```xml
<Tablix Name="tablixUSD">
  <TablixBody>
    <TablixColumns>
      <TablixColumn><Width>1.55in</Width></TablixColumn>  <!-- producto -->
      <TablixColumn><Width>0.54in</Width></TablixColumn>  <!-- unidad (solo en UYU) -->
      <!-- 12 columnas de mes -->
      <TablixColumn><Width>0.65in</Width></TablixColumn>
      <!-- ... × 12 -->
    </TablixColumns>
    <TablixRows>

      <!-- Fila header -->
      <TablixRow>
        <Height>0.28in</Height>
        <TablixCells>
          <!-- Corner cell → ver components/corner-cell.md -->
          <TablixCell>...</TablixCell>
          <!-- Headers de mes -->
          <TablixCell>
            <CellContents>
              <Textbox Name="hdrUsdM01">
                <CanGrow>true</CanGrow>
                <Paragraphs>
                  <Paragraph>
                    <TextRuns>
                      <TextRun>
                        <Value>=IIF(CInt(Parameters!pAnio.Value)=Year(Today()) AND 1=Month(Today()),
                          CStr(Day(Today())) &amp; "-Ene",
                          CStr(Day(DateSerial(CInt(Parameters!pAnio.Value),2,0))) &amp; "-Ene")</Value>
                        <Style>
                          <FontSize>8pt</FontSize>
                          <FontWeight>Bold</FontWeight>
                          <Color>White</Color>
                        </Style>
                      </TextRun>
                    </TextRuns>
                    <Style><TextAlign>Center</TextAlign></Style>
                  </Paragraph>
                </Paragraphs>
                <Style>
                  <Border><Color>Gray</Color><Style>Solid</Style></Border>
                  <BackgroundColor>#153767</BackgroundColor>
                  <VerticalAlign>Middle</VerticalAlign>
                </Style>
              </Textbox>
            </CellContents>
          </TablixCell>
          <!-- ... × 12 -->
        </TablixCells>
      </TablixRow>

      <!-- Fila detalle -->
      <TablixRow>
        <Height>0.25in</Height>
        <TablixCells>
          <!-- Celda producto (con drill-through → ver components/drill-through-action.md) -->
          <TablixCell>...</TablixCell>
          <!-- Celdas de valor por mes -->
          <TablixCell>
            <CellContents>
              <Textbox Name="txtUsdM01">
                <CanGrow>true</CanGrow>
                <Paragraphs>
                  <Paragraph>
                    <TextRuns>
                      <TextRun>
                        <Value>=IIF(
                          IsNothing(Max(IIF(Fields!MesNumero.Value = 1, Fields!PrecioExPlantaUSD.Value, Nothing), "grpProduct"))
                          OR Max(IIF(Fields!MesNumero.Value = 1, Fields!PrecioExPlantaUSD.Value, Nothing), "grpProduct") = 0,
                          "-",
                          Format(CDec(Max(IIF(Fields!MesNumero.Value = 1, Fields!PrecioExPlantaUSD.Value, Nothing), "grpProduct")), "N2")
                        )</Value>
                        <Style><FontSize>8pt</FontSize></Style>
                      </TextRun>
                    </TextRuns>
                    <Style><TextAlign>Center</TextAlign></Style>
                  </Paragraph>
                </Paragraphs>
                <Style>
                  <Border><Color>Gray</Color><Style>Solid</Style></Border>
                  <BackgroundColor>#f2f2f2</BackgroundColor>
                  <VerticalAlign>Middle</VerticalAlign>
                </Style>
              </Textbox>
            </CellContents>
          </TablixCell>
          <!-- ... × 12 -->
        </TablixCells>
      </TablixRow>

    </TablixRows>
  </TablixBody>

  <!-- Visibilidad dinámica de columnas de mes -->
  <TablixColumnHierarchy>
    <TablixMembers>
      <TablixMember />  <!-- col producto — siempre visible -->
      <!-- col unidad — siempre visible (solo tablixUYU) -->
      <!-- 12 meses con visibilidad dinámica -->
      <TablixMember>
        <Visibility>
          <Hidden>=Count(IIF(Fields!MesNumero.Value = 1
            And Not IsNothing(Fields!PrecioExPlantaUSD.Value)
            And Fields!PrecioExPlantaUSD.Value &lt;&gt; 0,
            1, Nothing), "dsTabla") = 0</Hidden>
        </Visibility>
      </TablixMember>
      <!-- ... × 12 -->
    </TablixMembers>
  </TablixColumnHierarchy>

  <!-- Visibilidad de filas (ocultar productos sin data) -->
  <TablixRowHierarchy>
    <TablixMembers>
      <TablixMember />  <!-- fila header — siempre visible -->
      <TablixMember>
        <Group Name="grpProduct">
          <GroupExpressions>
            <GroupExpression>=Fields!Producto.Value</GroupExpression>
          </GroupExpressions>
        </Group>
        <Visibility>
          <Hidden>=IsNothing(First(Fields!Producto.Value, "grpProduct"))
            Or First(Fields!Producto.Value, "grpProduct") = "N/A"
            Or Count(IIF(Not IsNothing(Fields!PrecioExPlantaUSD.Value)
              And Fields!PrecioExPlantaUSD.Value &lt;&gt; 0, 1, Nothing), "grpProduct") = 0</Hidden>
        </Visibility>
      </TablixMember>
    </TablixMembers>
  </TablixRowHierarchy>

  <Top>1.47667in</Top>
  <Left>6.24in</Left>
  <Height>0.53in</Height>
  <Width>8.03in</Width>
  <Visibility>
    <Hidden>=Parameters!pUnidad.Value &lt;&gt; "USD/m3"</Hidden>
  </Visibility>
</Tablix>
```

## Label de mes (expresión)

El label muestra el día real del mes si es el mes actual, o el último día del mes si ya cerró:

```
Mes N = IIF(Año = Year(Today()) AND N = Month(Today()),
  CStr(Day(Today())) & "-Xxx",           ← mes en curso: día actual
  CStr(Day(DateSerial(Año, N+1, 0))) & "-Xxx"  ← mes cerrado: último día
)
```

## Alineación de celdas de valor

- `TextAlign>Center` en el `<Paragraph>` (alineación horizontal).
- `VerticalAlign>Middle` en el `<Style>` del `<Textbox>` (alineación vertical).
- Ambas son necesarias — una no reemplaza a la otra.

## Limitación conocida: centrado visual con meses ocultos

`TablixMember.Visibility.Hidden` colapsa el ancho de la columna en el render. El ancho declarado (`Left` + `Width` del tablix) no cambia, pero las columnas invisibles no ocupan espacio visual.

**Efecto:** con pocos meses visibles, la matriz se ve desplazada hacia uno de los lados respecto al título, aunque matemáticamente el `Left` esté centrado.

**Comportamiento de Cognos:** idéntico. No hay fix — es una limitación del renderer compartida entre Cognos y el Service. Documentar como comportamiento esperado en la bitácora Capa 3.

## Ancho de columnas recomendado

| Contenido | Ancho mínimo | Notas |
|---|---|---|
| Producto (texto) | 1.45in | Para nombres largos |
| Unidad ($/lt, $/kg) | 0.62in | |
| Valor mensual (N2) | 0.65in | Números hasta 4 dígitos + 2 decimales |
| Valor mensual (N2, miles) | 0.72in | Números con separador de miles (1.313,61) |

## Mensaje "sin datos": elegir uno entre `NoRowsMessage` y textbox standalone

SSRS ofrece dos formas de mostrar un mensaje cuando el dataset queda vacío:

1. `<NoRowsMessage>` dentro del tablix → SSRS lo renderiza dentro del área del tablix (esquina superior izquierda, en `Left` del tablix). Útil cuando no querés posicionar el mensaje a mano.
2. Un textbox standalone (ej. `txtEmptyState`) con `Visibility.Hidden = CountRows("ds...") > 0`, posicionado donde uno quiera dentro del rectángulo padre.

**Elegir uno solo.** Si el reporte tiene ambos coexistiendo, cuando no haya datos aparecen los DOS textos al mismo tiempo (uno en la esquina del tablix, otro centrado). Convención: si querés el mensaje centrado bajo el banner, usar el textbox standalone y dejar `<NoRowsMessage></NoRowsMessage>` vacío; si alcanza con que aparezca dentro del tablix, no usar textbox standalone.

## Push-down: textos al pie pegados al tablix

SSRS aplica push-down vertical: cuando un tablix crece (más filas/meses) empuja hacia abajo los report items que están dentro del mismo rectángulo padre. Para que un texto al pie (nota URSEA, "Referentes…") quede pegado a la última fila del tablix sin gaps:

- Posicionar el textbox al pie con `Top` ≈ `tablix.Top + tablix.Height(diseño)` (apenas debajo del bottom de diseño del tablix).
- El push-down lo "pegará" automáticamente a la última fila renderizada cuando el tablix crece.
- No usar `Top` muy lejos hacia abajo (ej. `Top = sectionHeight - 1in`): cuando hay pocas filas, el textbox queda a 2-3in de gap; cuando hay muchas, puede pasar a la página siguiente y "desaparecer" para el usuario.

Limitación: SSRS no permite cerrar el gap dinámicamente con `ColSpan` en footer rows del tablix — en RDL 2016 `ColSpan` solo funciona en header rows de group column hierarchies, no en static rows. Push-down con textbox externo es la solución estable.

## Errores comunes

- **Ancho de columna insuficiente:** números largos se cortan en el Service. Aumentar a 0.65–0.72in y centrar el contenido.
- **Solo `TextAlign` sin `VerticalAlign`:** los números quedan en la esquina superior. Agregar `VerticalAlign>Middle` al `Style` del Textbox.
- **Solo `VerticalAlign` sin `TextAlign`:** los números quedan centrados verticalmente pero pegados a la izquierda. Agregar `TextAlign>Center` al `Style` del `Paragraph`.
- **Swappear columnas:** al cambiar el orden de dos columnas hay que swappear **ancho (`TablixColumn.Width`) Y contenido de las celdas (`TablixCell`)** juntos. Swappear solo uno deja el ancho equivocado para el contenido.
- **Coexistencia de `NoRowsMessage` + textbox `txtEmptyState`** → dos mensajes "Sin datos" simultáneos. Elegir uno.
- **Texto al pie con `Top` lejos del tablix** → gap visual cuando el tablix tiene pocas filas; texto en la página siguiente cuando tiene muchas. Posicionarlo apenas debajo del bottom de diseño del tablix y dejar que el push-down lo acompañe.
