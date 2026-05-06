---
name: component-centrado-dinamico-tablix
description: Centrado horizontal de un tablix con ancho variable por familia/contexto, usando columnas spacer al inicio con visibilidad condicional. Útil cuando el ancho visible de un tablix cambia según parámetros (familia, año, mercado) y RDL no permite expresiones en Left/Width.
---

# Componente — Centrado dinámico de tablix vía spacers condicionales

Sirve cuando el ancho visible de un tablix depende de parámetros (familia de producto, año, vista) y la posición horizontal estática (`Left` fijo) deja la tabla pegada al borde izquierdo del banner cuando es angosta. Como RDL no permite expresiones en `Left` o `Width`, no se puede centrar dinámicamente reposicionando el tablix — se centra **agregando columnas spacer al inicio** con ancho fijo por familia y `Visibility.Hidden` condicional.

## Cuándo aplica

- Un tablix con muchas columnas, donde solo una porción es visible por familia/contexto (resto con `IsColumnAllowed(...) = False` o `Count(...) = 0`).
- El usuario quiere ver la tabla angosta centrada bajo el banner, no pegada a la izquierda.
- El reporte tiene varios tablixes hermanos con anchos visibles distintos según la familia activa.

## Cuándo NO aplica

- Si el tablix tiene un solo ancho visible posible → centrarlo estáticamente con `Left = (banner.Width − tablix.Width) / 2`.
- Si el ancho visible excede al banner → no hay espacio para centrar; aceptar tabla a la izquierda con scroll horizontal.

## Estrategia

1. Calcular el ancho visible de cada familia (suma de columnas que esa familia muestra).
2. Para cada ancho visible, calcular el spacer necesario para centrar bajo un ancho de referencia (banner o página): `spacer = (referencia − visible) / 2`.
3. Agregar al inicio del tablix N columnas spacer (una por familia que necesita centrado), cada una con su `<TablixColumn>` ancho fijo, su `<TablixMember>` con `Visibility.Hidden`, y celdas vacías en cada `<TablixRow>`.
4. Función VB en el bloque `<Code>` que mapea (vista, producto) → key del spacer activo (ej. `"S1"`, `"S2"`, `"S3"`).
5. Cada `<TablixMember>` spacer tiene `Hidden = GetPageCenteringKey(...) <> "Sk"` — solo el spacer correspondiente queda visible.

## Estructura RDL (esquema)

### Función VB (bloque `<Code>` del Report)

```vb
Public Function GetPageCenteringKey(viewKey As String, product As String) As String
  Dim family As String = GetProductFamily(product)
  ' Tabla de mapeo familia × vista → spacer key
  If viewKey = "Summary" Then
    Select Case family
      Case "Butano"             : Return "S1"
      Case "LiquidosAv"         : Return "S2"
      Case "QuerosenoMontevideo": Return "S3"
      ' ... otras familias
      Case Else                 : Return ""  ' sin spacer (familia ancha o sin centrado)
    End Select
  ElseIf viewKey = "Detail" Then
    ' análoga para Detail con sus propios spacer keys (D1, D2, ...)
  End If
  Return ""
End Function
```

### Columnas spacer en `<TablixColumns>`

```xml
<TablixColumns>
  <TablixColumn><Width>6.10in</Width></TablixColumn>  <!-- spacer S1 -->
  <TablixColumn><Width>7.00in</Width></TablixColumn>  <!-- spacer S2 -->
  <TablixColumn><Width>7.375in</Width></TablixColumn> <!-- spacer S3 -->
  <!-- ... resto de columnas spacer -->
  <TablixColumn><Width>0.60in</Width></TablixColumn>  <!-- corner cell (Dia) -->
  <!-- ... columnas de datos -->
</TablixColumns>
```

### Members con visibilidad por key

```xml
<TablixColumnHierarchy>
  <TablixMembers>
    <TablixMember>
      <Visibility>
        <Hidden>=Code.GetPageCenteringKey("Summary", Parameters!pProducto.Value) &lt;&gt; "S1"</Hidden>
      </Visibility>
    </TablixMember>
    <TablixMember>
      <Visibility>
        <Hidden>=Code.GetPageCenteringKey("Summary", Parameters!pProducto.Value) &lt;&gt; "S2"</Hidden>
      </Visibility>
    </TablixMember>
    <!-- ... otros spacers -->
    <TablixMember /> <!-- corner cell -->
    <!-- ... members de datos -->
  </TablixMembers>
</TablixColumnHierarchy>
```

### Celdas spacer en cada `<TablixRow>`

Cada fila del tablix necesita una `<TablixCell>` por cada columna spacer, con un textbox vacío:

```xml
<TablixCell>
  <CellContents>
    <Textbox Name="SpSumS1H">
      <CanGrow>true</CanGrow>
      <KeepTogether>true</KeepTogether>
      <Paragraphs>
        <Paragraph><TextRuns><TextRun><Value></Value><Style /></TextRun></TextRuns><Style /></Paragraph>
      </Paragraphs>
      <Style><Border><Style>None</Style></Border></Style>
    </Textbox>
  </CellContents>
</TablixCell>
```

## Cálculo del spacer

Definir referencia (R) y para cada familia con ancho visible (V):

```
spacer_width = (R − V) / 2 − overhead
```

Donde `overhead` es el `Left` del tablix dentro del rectángulo padre (típicamente 0.05in). Si la familia ancha excede a R, no agregarle spacer (sin centrado, queda alineada a la izquierda).

Elegir R:
- **R = banner.Width** (típicamente coincide con la tabla más ancha del reporte) → centra bajo el banner. Recomendado.
- **R = page.Width** → centra en la página impresa, pero las tablas angostas pueden aparecer fuera del viewport interactivo.

## Errores comunes

- **Olvidar la celda spacer en alguna `<TablixRow>`** → el RDL queda con count de celdas distinto al de columnas → falla de deserialización en Report Builder.
- **Olvidar el `<TablixMember>` correspondiente** → el orden de TablixColumns no coincide con TablixColumnHierarchy → render incorrecto.
- **Operador `<>` sin escapar (`&lt;&gt;`) en el `<Hidden>`** → XML inválido, Report Builder rompe al abrir.
- **Spacer fijo de ancho mayor al banner** → la tabla termina más a la derecha que el banner; "desborda" visualmente.
- **Usar un solo spacer y esperar centrado universal** → cada familia con ancho distinto necesita su propio spacer + key.
- **Contar las columnas ocultas (`IsColumnAllowed = False` + `Count = 0`)** dentro del cálculo del ancho visible → el ancho real visible es solo la suma de columnas con datos, no la suma del declarado.
