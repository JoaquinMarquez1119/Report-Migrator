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

## Errores comunes

- Subir `PageHeader.Height` sin subir `rectHeader.Height` → franja dorada queda cortada.
- Logo con `ZIndex` menor que el título → el título tapa el logo cuando se superponen.
- No usar `PrintOnFirstPage>true` + `PrintOnLastPage>true` → el header no aparece en todas las páginas.
- Cambiar el título directamente en vez de usar un parámetro o campo → el header queda hardcodeado y no sirve para otros reportes.
