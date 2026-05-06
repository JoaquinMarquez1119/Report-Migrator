---
name: component-page-header
description: Encabezado de página de reporte ANCAP en Power BI Report Builder. Franja oscura con título centrado, año del filtro, y logo ANCAP a la derecha. Vive en PageHeader del RDL.
---

# Componente — Page header

Encabezado de página con fondo azul oscuro (`#0f254c`), franja inferior dorada (`#ffc728`), título centrado, año del parámetro y logo ANCAP a la derecha.

## Estructura RDL

```xml
<PageHeader>
  <Height>0.55in</Height>
  <PrintOnFirstPage>true</PrintOnFirstPage>
  <PrintOnLastPage>true</PrintOnLastPage>
  <ReportItems>

    <Rectangle Name="rectHeader">
      <ReportItems>

        <!-- Título principal -->
        <Textbox Name="txtTitulo">
          <CanGrow>true</CanGrow>
          <KeepTogether>true</KeepTogether>
          <Paragraphs>
            <Paragraph>
              <TextRuns>
                <TextRun>
                  <Value>Composición del precio (Precios unitarios Ex Planta)</Value>
                  <Style>
                    <FontFamily>Tahoma</FontFamily>
                    <FontSize>16pt</FontSize>
                    <FontWeight>Bold</FontWeight>
                    <Color>White</Color>
                  </Style>
                </TextRun>
              </TextRuns>
              <Style><TextAlign>Center</TextAlign></Style>
            </Paragraph>
          </Paragraphs>
          <Top>0.05in</Top>
          <Left>0.3in</Left>
          <Height>0.25in</Height>
          <Width>19.9in</Width>
          <Style><Border><Style>None</Style></Border></Style>
        </Textbox>

        <!-- Año del parámetro (subtítulo) -->
        <Textbox Name="txtHeaderAnio">
          <CanGrow>true</CanGrow>
          <KeepTogether>true</KeepTogether>
          <Paragraphs>
            <Paragraph>
              <TextRuns>
                <TextRun>
                  <Value>=Parameters!pAnio.Value</Value>
                  <Style>
                    <FontSize>12pt</FontSize>
                    <FontWeight>Bold</FontWeight>
                    <Color>White</Color>
                  </Style>
                </TextRun>
              </TextRuns>
              <Style><TextAlign>Center</TextAlign></Style>
            </Paragraph>
          </Paragraphs>
          <Top>0.32in</Top>
          <Left>0.3in</Left>
          <Height>0.18in</Height>
          <Width>19.9in</Width>
          <ZIndex>1</ZIndex>
          <Style><Border><Style>None</Style></Border></Style>
        </Textbox>

        <!-- Logo ANCAP -->
        <Image Name="imgLogo">
          <Source>Embedded</Source>
          <Value>imgAncapLogo</Value>
          <Sizing>FitProportional</Sizing>
          <Top>0.06in</Top>
          <Left>18.85in</Left>
          <Height>0.42in</Height>
          <Width>1.45in</Width>
          <ZIndex>2</ZIndex>
          <Style><Border><Style>None</Style></Border></Style>
        </Image>

      </ReportItems>
      <Top>0in</Top>
      <Left>0in</Left>
      <Height>0.53in</Height>
      <Width>20.5in</Width>
      <Style>
        <Border><Style>None</Style></Border>
        <BottomBorder>
          <Color>#ffc728</Color>
          <Style>Solid</Style>
          <Width>2.25pt</Width>
        </BottomBorder>
        <BackgroundColor>#0f254c</BackgroundColor>
      </Style>
    </Rectangle>

  </ReportItems>
  <Style />
</PageHeader>
```

## Proporciones (página A3 landscape, márgenes 0.25in)

| Elemento | Top | Height | Notas |
|---|---|---|---|
| `PageHeader` | — | 0.55in | Total del encabezado |
| `rectHeader` | 0in | 0.53in | Rectángulo con fondo + franja dorada |
| `txtTitulo` | 0.05in | 0.25in | Título principal |
| `txtHeaderAnio` | 0.32in | 0.18in | Año del filtro, debajo del título |
| `imgLogo` | 0.06in | 0.42in | Logo solapado con título y año |

## Ajuste de alturas

Para aflojar/apretar el encabezado, escalar todos los valores proporcionalmente:
- `PageHeader.Height` = altura total deseada.
- `rectHeader.Height` = `PageHeader.Height` − 0.02in.
- `txtTitulo.Top` ≈ 10% de `rectHeader.Height`.
- `txtHeaderAnio.Top` ≈ 58% de `rectHeader.Height`.
- `imgLogo` centrado verticalmente en `rectHeader`.

## Colores ANCAP

| Elemento | Color |
|---|---|
| Fondo rectHeader | `#0f254c` (azul oscuro) |
| Franja inferior | `#ffc728` (dorado), 2.25pt |
| Texto título / año | `White` |

## Imagen embebida

El logo se embebe en el RDL como base64 en la sección `<EmbeddedImages>`:
```xml
<EmbeddedImages>
  <EmbeddedImage Name="imgAncapLogo">
    <MIMEType>image/jpeg</MIMEType>
    <ImageData><!-- base64 del jpg --></ImageData>
  </EmbeddedImage>
</EmbeddedImages>
```

## Ancho del banner

Regla: **`rectHeader.Width` = ancho del banner del reporte base** del cliente (en ANCAP, 20.5in para A3 landscape con márgenes 0.25in). No escalar al ancho de la tabla más larga del reporte — eso desincroniza visualmente reportes hermanos (base ↔ detalle) y no aporta funcionalidad. Si la tabla es más ancha que el banner, se acepta scroll horizontal por debajo del banner; el banner no necesita cubrir toda la tabla.

## Centrado del texto respecto al logo

El logo ocupa el sector derecho del banner (en ANCAP: `Left=18.85in, Width=1.45in` sobre banner de 20.5in). Si el textbox del título usa `Left=0in, Width=banner.Width, TextAlign=Center`, el texto queda centrado **respecto al banner completo** — no respecto al área visualmente disponible. Resultado: el texto se ve "apretado contra el logo" porque hay más espacio libre a la izquierda que entre texto y logo.

Fix para simetría visual: que el textbox del título termine donde empieza el logo, **`Width = logo.Left`** (en ANCAP: `Width=18.85in`). Con `TextAlign=Center`, el texto queda centrado en el área no-logo (centro en `logo.Left/2`).

```xml
<Textbox Name="txtTitulo">
  ...
  <Top>0.05in</Top>
  <Left>0in</Left>
  <Height>0.25in</Height>
  <Width>18.85in</Width>   <!-- = imgLogo.Left, no rectHeader.Width -->
  ...
</Textbox>
```

Lo mismo para el subtítulo. El banner del reporte base de ANCAP tiene esta proporción heredada: title/subtitle Width=19.9in con Left=0.3in (centro en 10.25in = banner center). Replicar la lógica de "Width = logo.Left" en reportes nuevos da resultado más equilibrado visualmente.

## Errores comunes

- Subir `PageHeader.Height` sin subir `rectHeader.Height` → franja dorada queda cortada.
- Logo con `ZIndex` menor que el título → el título tapa el logo cuando se superponen.
- No usar `PrintOnFirstPage>true` + `PrintOnLastPage>true` → el header no aparece en todas las páginas.
- Cambiar el título directamente en vez de usar un parámetro o campo → el header queda hardcodeado y no sirve para otros reportes.
- **Banner Width = ancho de tabla más larga** del reporte → desincroniza con el reporte base hermano y deja franja vacía con el logo "flotando" lejos. Mantener `rectHeader.Width` igual al banner del base.
- **Textbox de título con `Width=banner.Width`** → texto centrado pero visualmente desplazado hacia el logo. Usar `Width=logo.Left` para centrar en el área no-logo.
