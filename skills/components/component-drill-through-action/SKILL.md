---
name: component-drill-through-action
description: Acción de drill-through en una celda de tablix que abre un reporte hijo pasando parámetros. Incluye el contrato de parámetros padre→hijo, normalización de valores y validación del contrato.
---

# Componente — Drill-through action

Acción que al hacer click en una celda (típicamente el nombre del producto) abre un reporte hijo en una ventana/tab nueva, pasando los parámetros necesarios para que el hijo se ejecute en el contexto correcto.

## Estructura RDL (en el textbox de la celda)

```xml
<Textbox Name="txtUsdProducto">
  <!-- ... párrafos, style ... -->
  <ActionInfo>
    <Actions>
      <Action>
        <Drillthrough>
          <ReportName><!-- path al reporte hijo, relativo al servidor --></ReportName>
          <Parameters>
            <Parameter Name="pAnio">
              <Value>=Parameters!pAnio.Value</Value>
            </Parameter>
            <Parameter Name="pUnidad">
              <Value>=IIF(Parameters!pUnidad.Value = "USD/m3",
                "USD/m3",
                "$/lt ó $/kg según corresponda")</Value>
            </Parameter>
            <Parameter Name="pProducto">
              <Value>=Switch(
                Fields!Producto.Value = "Asfalto AC-20", "Asfalto AC-30",
                Fields!Producto.Value = "Super 95 Sp",   "Gasolina Super 95",
                Fields!Producto.Value = "Premium 97 Sp", "Gasolina Premium 97",
                Fields!Producto.Value = "Gasoil Comun",  "Gasoil 50-S",
                Fields!Producto.Value = "Gasoil Especial","Gasoil 10-S",
                Fields!Producto.Value = "Propano",        "Propano Industrial",
                True, Fields!Producto.Value
              )</Value>
            </Parameter>
            <Parameter Name="pVista">
              <Value>Resumen</Value>
            </Parameter>
          </Parameters>
        </Drillthrough>
      </Action>
    </Actions>
  </ActionInfo>
</Textbox>
```

## Contrato de parámetros

Documentar en el `SKILL.md` de **ambos** reportes (padre e hijo):

| Parámetro | Enviado por el padre | Recibido por el hijo | Normalización |
|---|---|---|---|
| `pAnio` | `=Parameters!pAnio.Value` | `pAnio` | Sin cambios |
| `pUnidad` | Expresión IIF (ver arriba) | `pUnidad` | El padre normaliza el label antes de enviar |
| `pProducto` | Expresión Switch (ver arriba) | `pProducto` | El padre renombra productos de Cognos al nombre del hijo |
| `pVista` | Literal `"Resumen"` | `pVista` | Fijo — el drill siempre abre la vista Resumen |

## Normalización de valores

El padre puede necesitar transformar los valores antes de enviarlos:

- **Renombre de producto:** `Switch(Fields!Producto.Value = "X", "Y", ...)` cuando el nombre del producto en el dataset padre difiere del nombre esperado por el hijo.
- **Normalización de unidad:** el padre usa `"USD/m3"` / `"$/lt ó $/kg según corresponda"` pero el hijo puede usar labels distintos. La IIF mapea explícitamente.
- **Parámetros fijos:** si el hijo tiene parámetros que el drill siempre setea igual (ej. `pVista = "Resumen"`), documentarlos como fijos para no confundirlos con parámetros dinámicos.

## Path del reporte hijo

```xml
<ReportName>/ruta/en/servidor/NombreReporteHijo</ReportName>
```

- El path es relativo al servidor de Power BI Report Server.
- No incluir extensión `.rdl`.
- Debe coincidir exactamente con el path de publicación del hijo — sensible a mayúsculas en algunos servidores.

## Validación del contrato

1. **Standalone del hijo:** ejecutar el reporte hijo directamente con los mismos parámetros que el drill enviaría. El resultado debe coincidir con lo que se ve al hacer drill desde el padre.
2. **Drill real:** hacer click en el padre y verificar que el hijo abre con los valores correctos en los parámetros.
3. **Casos borde:** producto con nombre especial (caracteres, espacios), parámetro nulo, año distinto al actual.

## Errores comunes

- **`ReportName` incorrecto:** el drill falla silenciosamente o lanza error genérico. Verificar el path exacto en el servidor.
- **Nombre de parámetro no coincide:** `<Parameter Name="X">` en el padre pero el hijo espera `pX`. El hijo ignora el parámetro y usa su default, produciendo resultados incorrectos sin error visible.
- **Normalización ausente:** si el nombre del producto en el padre difiere del esperado por el hijo, el hijo muestra "sin datos" en vez de reportar error. Revisar el mapeo `Switch`.
- **Validar solo via drill:** problemas del hijo pasan desapercibidos. Siempre validar el hijo standalone primero.
- **Hardcodear parámetros fijos dentro del hijo:** si `pVista` solo puede ser `"Resumen"` vía drill, documentarlo en el contrato pero no hardcodearlo en el hijo — el hijo debería funcionar standalone con ese parámetro pasado explícitamente.
