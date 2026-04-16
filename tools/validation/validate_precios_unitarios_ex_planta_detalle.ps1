$ErrorActionPreference = "Stop"

function Assert-True {
    param(
        [bool]$Condition,
        [string]$Message
    )

    if (-not $Condition) {
        throw $Message
    }
}

function Get-ParameterNames {
    param(
        [xml]$Document,
        [System.Xml.XmlNamespaceManager]$Ns
    )

    return @(
        $Document.SelectNodes("//rdl:ReportParameters/rdl:ReportParameter", $Ns) |
            ForEach-Object { $_.Name }
    )
}

function Get-DataSetNames {
    param(
        [xml]$Document,
        [System.Xml.XmlNamespaceManager]$Ns
    )

    return @(
        $Document.SelectNodes("//rdl:DataSets/rdl:DataSet", $Ns) |
            ForEach-Object { $_.Name }
    )
}

function Get-DuplicateReportItemNames {
    param(
        [xml]$Document,
        [System.Xml.XmlNamespaceManager]$Ns
    )

    $reportItemNodes = $Document.SelectNodes(
        "//rdl:Textbox[@Name] | //rdl:Rectangle[@Name] | //rdl:Tablix[@Name] | //rdl:Image[@Name] | //rdl:Subreport[@Name] | //rdl:Line[@Name]",
        $Ns
    )

    return @(
        $reportItemNodes |
            ForEach-Object { $_.Name } |
            Group-Object |
            Where-Object { $_.Count -gt 1 } |
            Select-Object -ExpandProperty Name
    )
}

function Get-InvalidWidths {
    param(
        [xml]$Document,
        [System.Xml.XmlNamespaceManager]$Ns
    )

    $widthNodes = $Document.SelectNodes("//rdl:Width", $Ns)
    $invalidWidths = New-Object System.Collections.Generic.List[string]

    foreach ($node in $widthNodes) {
        $value = $node.InnerText
        if ($value -notmatch '^[0-9]+(\.[0-9]+)?in$') {
            $invalidWidths.Add($value)
            continue
        }

        $numericValue = [double]($value -replace 'in$', '')
        if ($numericValue -gt 455) {
            $invalidWidths.Add($value)
        }
    }

    return @($invalidWidths)
}

function Get-MojibakeMarkers {
    param([string]$RawContent)

    $markers = @(
        [string][char]0x00C3,
        [string][char]0x00C2,
        [string][char]0xFFFD
    )

    return @(
        $markers | Where-Object { $RawContent.Contains($_) }
    )
}

$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$detailPath = Join-Path $repoRoot "reports\precios-unitarios-ex-planta-detalle\Precios Unitarios Ex Planta - detalle.rdl"
$parentPath = Join-Path $repoRoot "reports\precios-unitarios-ex-planta-base\Precios_unitarios_ex_planta_base.rdl"

Assert-True (Test-Path -LiteralPath $parentPath) "No se encontro el reporte padre en '$parentPath'."
Assert-True (Test-Path -LiteralPath $detailPath) "No se encontro el nuevo reporte detalle en '$detailPath'."

[string]$detailRaw = [System.IO.File]::ReadAllText($detailPath, [System.Text.UTF8Encoding]::new($false))
[xml]$detailXml = $detailRaw
[xml]$parentXml = [System.IO.File]::ReadAllText($parentPath, [System.Text.UTF8Encoding]::new($false))

$detailNs = New-Object System.Xml.XmlNamespaceManager($detailXml.NameTable)
$detailNs.AddNamespace("rdl", "http://schemas.microsoft.com/sqlserver/reporting/2016/01/reportdefinition")
$detailNs.AddNamespace("rd", "http://schemas.microsoft.com/SQLServer/reporting/reportdesigner")

$parentNs = New-Object System.Xml.XmlNamespaceManager($parentXml.NameTable)
$parentNs.AddNamespace("rdl", "http://schemas.microsoft.com/sqlserver/reporting/2016/01/reportdefinition")
$parentNs.AddNamespace("rd", "http://schemas.microsoft.com/SQLServer/reporting/reportdesigner")

$detailParameterNames = Get-ParameterNames -Document $detailXml -Ns $detailNs
$detailDataSetNames = Get-DataSetNames -Document $detailXml -Ns $detailNs
$duplicateDetailReportItems = Get-DuplicateReportItemNames -Document $detailXml -Ns $detailNs
$invalidDetailWidths = Get-InvalidWidths -Document $detailXml -Ns $detailNs
$mojibakeMarkers = Get-MojibakeMarkers -RawContent $detailRaw
$detailGrid = $detailXml.SelectSingleNode("//rdl:ReportParametersLayout/rdl:GridLayoutDefinition", $detailNs)
$aniosField = "[A" + [char]0x00F1 + "os]"
$anioBaseBrokenField = "[A" + [char]0x00C3 + [char]0x00B1 + "os]"

foreach ($parameterName in @("pAnio", "pProducto", "pUnidad", "pVista")) {
    Assert-True ($detailParameterNames -contains $parameterName) "Falta el parametro '$parameterName' en el reporte detalle."
}

foreach ($datasetName in @("dsAnio", "dsProducto", "dsTexto", "dsResumen", "dsDetalle")) {
    Assert-True ($detailDataSetNames -contains $datasetName) "Falta el dataset '$datasetName' en el reporte detalle."
}

Assert-True ($duplicateDetailReportItems.Count -eq 0) ("Hay nombres de report items duplicados en el reporte detalle: " + ($duplicateDetailReportItems -join ", "))
Assert-True ($invalidDetailWidths.Count -eq 0) ("Hay Widths invalidos en el reporte detalle: " + ($invalidDetailWidths -join ", "))
Assert-True ($mojibakeMarkers.Count -eq 0) "Hay texto mal codificado (mojibake) en el reporte detalle."
Assert-True (-not $detailRaw.Contains("ï¿½")) "Hay caracteres de reemplazo UTF-8 mal reconstruidos en el reporte detalle."
Assert-True ($null -ne $detailGrid) "Falta el ReportParametersLayout en el reporte detalle."
Assert-True ($detailRaw.Contains($aniosField)) "El dataset dsAnio debe referenciar la columna 'Años' con el nombre exacto del modelo."
Assert-True (-not $detailRaw.Contains($anioBaseBrokenField)) "El dataset dsAnio quedo con el nombre de columna 'Años' mal codificado."
Assert-True ($detailRaw.Contains('<Field Name="PVPImpUSD">')) "Falta el campo calculado 'PVPImpUSD' en el reporte detalle."
Assert-True ($detailRaw.Contains('Fields!PVPImpUSD.Value')) "La vista USD del reporte detalle no usa el campo 'PVPImpUSD'."
Assert-True (-not $detailRaw.Contains('Code.ConvertToUsd(Fields!PVPImp.Value, Fields!TC.Value)')) "La vista USD del reporte detalle sigue convirtiendo desde 'PVPImp' y 'TC' en lugar de usar valores USD precomputados."
Assert-True ($detailRaw.Contains('<Field Name="TasaInflamableUSD">')) "Falta el campo calculado 'TasaInflamableUSD' en el reporte detalle."
Assert-True ($detailRaw.Contains('tablixDetailUSD_TasaInflamable_Header')) "Falta la columna 'Tasa inflamable' en el detalle USD."
Assert-True ($detailRaw.Contains('Fields!TasaInflamableUSD.Value')) "El detalle USD no usa el campo 'TasaInflamableUSD'."
Assert-True ($detailRaw.Contains('Public Function GetProductFamily(')) "Falta la matriz central de familias en el reporte detalle."
Assert-True ($detailRaw.Contains('Public Function GetHistoricalSourceGroup(')) "Falta la funcion de tramo historico en el reporte detalle."
Assert-True ($detailRaw.Contains('Public Function IsColumnAllowed(')) "Falta la funcion central de visibilidad por columna en el reporte detalle."
Assert-True ($detailRaw.Contains('Public Function ShouldUseUsdTm1Summary(')) "Falta la funcion central de seleccion del resumen USD."
Assert-True ($detailRaw.Contains('Public Function ShouldUseLocalMainSummary(')) "Falta la funcion central de seleccion del resumen local principal."
Assert-True ($detailRaw.Contains('Public Function ShouldUseLocalTm1Summary(')) "Falta la funcion central de seleccion del resumen local TM1."
Assert-True (($detailRaw -match 'Case "Gasolina Super 95", "Gasolina Premium 97", "Gasoil 50-S", "Gasoil 10-S", "Gasolina Av 100 Octanos", "Jet A1"') -and ($detailRaw -match 'Case "PVP", "PEPImp", "PEP" : Return True')) "La visibilidad del resumen USD no replica la combinacion de columnas de Cognos para gasolinas, gasoil y aviacion."
Assert-True (($detailRaw -match 'Case "Gasolina Super 95", "Gasolina Premium 97", "Gasoil 50-S", "Gasoil 10-S", "Gasolina Av 100 Octanos", "Jet A1"') -and ($detailRaw -match 'Case "PVP", "PEPImp", "TasaInflamable", "IMESI", "TasaPrim", "FUDAEE", "PEP" : Return True')) "La visibilidad del detalle USD no replica la combinacion de columnas de Cognos para gasolinas, gasoil y aviacion."
Assert-True ($detailRaw.Contains('Case "Aguarras", "Solvente 1197", "Disan", "Base insecticida", "Querosol", "Hexano Comercial"')) "Falta la regla de visibilidad para Base insecticida en el grupo de productos especiales."
Assert-True ($detailRaw.Contains('Case "PVP", "PEPImp", "PEP" : Return True')) "La visibilidad del resumen USD para Base insecticida debe mostrar solo PVP, PEP impuestos incluidos y PEP."
Assert-True ($detailRaw.Contains('Case "PVP", "Margen", "IVADistribucion", "PEPImp", "TasaInflamable", "IMESI", "IVAPrimaria", "PEP" : Return True')) "La visibilidad del detalle para Base insecticida debe replicar el orden y las columnas de Cognos."
Assert-True (($detailRaw -match 'Case "Aguarras", "Solvente 1197", "Disan", "Base insecticida", "Querosol", "Hexano Comercial"') -and ($detailRaw -match 'Case "PrecioPublico", "PrecioExonerado", "IVA", "PrecioSinIVA", "IMESI", "Cotizacion", "PrecioSinImpuesto", "PrecioExPlanta" : Return True')) "La visibilidad del resumen local debe incluir IMESI para los productos especiales como Base insecticida."
Assert-True ($detailRaw.Contains('<Field Name="MontoDiferencialZonasD">')) "Falta el campo 'MontoDiferencialZonasD' requerido por Supergas."
Assert-True ($detailRaw.Contains('<Field Name="MontoDiferencialZonasDUSD">')) "Falta el campo USD 'MontoDiferencialZonasDUSD' requerido por Supergas."
Assert-True ($detailRaw.Contains('tablixSummaryUSD_MontoDiferencial_Header')) "Falta la columna 'Monto diferencial por zonas \"d\"' en el resumen USD."
Assert-True ($detailRaw.Contains('tablixDetailUSD_MontoDiferencial_Header')) "Falta la columna 'Monto diferencial por zonas \"d\"' en el detalle USD."
Assert-True ($detailRaw.Contains('Monto diferencial por zonas &quot;d&quot;')) "El reporte detalle no preserva el renombre 'Monto diferencial por zonas \"d\"' definido en Cognos."
Assert-True ($detailRaw.Contains('Code.IsColumnAllowed(&quot;SummaryUsd&quot;, Parameters!pProducto.Value, Parameters!pAnio.Value, Parameters!pUnidad.Value, &quot;MontoDiferencial&quot;)')) "La visibilidad del resumen USD debe contemplar la columna 'Monto diferencial por zonas \"d\"' desde la matriz central."
Assert-True ($detailRaw.Contains('Code.IsColumnAllowed(&quot;Detail&quot;, Parameters!pProducto.Value, Parameters!pAnio.Value, Parameters!pUnidad.Value, &quot;MontoDiferencial&quot;)')) "La visibilidad del detalle debe contemplar la columna 'Monto diferencial por zonas \"d\"' desde la matriz central."
Assert-True ($detailRaw.Contains('tablixSummaryLocal_PrecioSinImpuesto_Header')) "Falta la columna 'Precio sin impuesto' en el resumen local."
Assert-True ($detailRaw.Contains('tablixSummaryLocal_PrecioExPlantaTM1_Header')) "Falta la columna 'Precio Ex Planta' en el resumen local."
Assert-True ($detailRaw.Contains('tablixSummaryLocal_IMESI_Header')) "Falta la columna 'IMESI' en el resumen local."
Assert-True ($detailRaw.Contains('<Field Name="UnidadTM1">')) "Falta el campo 'UnidadTM1' para etiquetar correctamente las unidades TM1 del resumen local."
Assert-True ($detailRaw.Contains('Code.NormalizeDisplayUnit(First(Fields!UnidadTM1.Value, &quot;dsResumenLocal&quot;))')) "El resumen local TM1 debe mostrar la unidad tomada del dataset TM1."
Assert-True ($detailRaw.Contains('Code.ViewUnitLabel(Parameters!pUnidad.Value, First(Fields!Unidad2.Value, &quot;dsDetalle&quot;))')) "La vista Detalle en moneda local debe etiquetar la cabecera con la unidad local del producto."
Assert-True ($detailRaw.Contains('tablixSummaryLocalMain')) "Falta la tabla secundaria del resumen local basada en el dataset principal."
Assert-True ($detailRaw.Contains('Code.ShouldUseLocalMainSummary(Parameters!pProducto.Value, Parameters!pAnio.Value)')) "La tabla secundaria del resumen local debe activarse desde la matriz central."
Assert-True ($detailRaw.Contains('Code.IsColumnAllowed(&quot;SummaryLocalMain&quot;, Parameters!pProducto.Value, Parameters!pAnio.Value, Parameters!pUnidad.Value, &quot;PEPImp&quot;)')) "La tabla secundaria del resumen local debe controlar visibilidad por columna desde la matriz central."
Assert-True ($detailRaw.Contains('Code.ViewUnitLabel(Parameters!pUnidad.Value, First(Fields!Unidad2.Value, &quot;dsResumen&quot;))')) "La tabla secundaria del resumen local debe usar la unidad local del dataset principal."
Assert-True (($detailRaw -match '<Tablix Name="tablixSummaryUSD">') -and ($detailRaw -match '<NoRowsMessage></NoRowsMessage>')) "Las tablas del resumen no deben mostrar el mensaje por defecto de ausencia de datos."
Assert-True ($detailRaw.Contains('CountRows(&quot;dsResumenLocal&quot;) = 0')) "Las tablas del resumen basadas en dsResumenLocal deben ocultarse cuando no tienen filas para evitar que se vea una esquina vacia."
Assert-True ($detailRaw.Contains('Code.IsColumnAllowed(&quot;SummaryLocalTm1&quot;, Parameters!pProducto.Value, Parameters!pAnio.Value, Parameters!pUnidad.Value, &quot;PrecioSinImpuesto&quot;) Or Count(IIF(Not IsNothing(Fields!PrecioSinImpuesto.Value) And Fields!PrecioSinImpuesto.Value &lt;&gt; 0, 1, Nothing), &quot;dsResumenLocal&quot;) = 0')) "La columna 'Precio sin impuesto' del resumen local debe ocultarse cuando solo tiene vacios o ceros, despues de pasar por la matriz central."
Assert-True ($detailRaw.Contains('Code.IsColumnAllowed(&quot;SummaryLocalTm1&quot;, Parameters!pProducto.Value, Parameters!pAnio.Value, Parameters!pUnidad.Value, &quot;PrecioExPlanta&quot;) Or Count(IIF(Not IsNothing(Fields!PrecioExPlantaTM1.Value) And Fields!PrecioExPlantaTM1.Value &lt;&gt; 0, 1, Nothing), &quot;dsResumenLocal&quot;) = 0')) "La columna 'Precio Ex Planta' del resumen local debe ocultarse cuando solo tiene vacios o ceros, despues de pasar por la matriz central."
Assert-True ($detailRaw.Contains('Code.IsColumnAllowed(&quot;SummaryLocalTm1&quot;, Parameters!pProducto.Value, Parameters!pAnio.Value, Parameters!pUnidad.Value, &quot;IMESI&quot;) Or Count(IIF(Not IsNothing(Fields!IMESI.Value) And Fields!IMESI.Value &lt;&gt; 0, 1, Nothing), &quot;dsResumenLocal&quot;) = 0')) "La columna 'IMESI' del resumen local debe mostrarse solo cuando existe algun valor distinto de cero, despues de pasar por la matriz central."
Assert-True ($detailRaw.Contains('Code.IsColumnAllowed(&quot;SummaryUsd&quot;, Parameters!pProducto.Value, Parameters!pAnio.Value, Parameters!pUnidad.Value, &quot;MontoDiferencial&quot;) Or Count(IIF(Not IsNothing(Fields!MontoDiferencialZonasDUSD.Value) And Fields!MontoDiferencialZonasDUSD.Value &lt;&gt; 0, 1, Nothing), &quot;dsResumen&quot;) = 0')) "La columna 'Monto diferencial por zonas \"d\"' del resumen USD debe ocultarse cuando solo tiene vacios o ceros, despues de pasar por la matriz central."
Assert-True ($detailRaw.Contains('Code.IsColumnAllowed(&quot;Detail&quot;, Parameters!pProducto.Value, Parameters!pAnio.Value, Parameters!pUnidad.Value, &quot;CO2&quot;) Or Count(IIF((Code.NormalizeUnit(Parameters!pUnidad.Value) = &quot;USD/m3&quot; And Not IsNothing(Fields!ImpuestoCO2USD.Value) And Fields!ImpuestoCO2USD.Value &lt;&gt; 0) Or (Code.NormalizeUnit(Parameters!pUnidad.Value) &lt;&gt; &quot;USD/m3&quot; And Not IsNothing(Fields!ImpuestoCO2.Value) And Fields!ImpuestoCO2.Value &lt;&gt; 0), 1, Nothing), &quot;dsDetalle&quot;) = 0')) "La columna 'Impuesto CO2' del detalle debe ocultarse cuando solo tiene vacios o ceros, despues de pasar por la matriz central."
Assert-True ($detailRaw.Contains('Fields!IMESI.Value')) "El resumen local no usa el campo 'IMESI'."
Assert-True (-not $detailRaw.Contains('Count(IIF(Not IsNothing(Fields!PrecioPublico.Value) And Not IsNothing(Fields!CotizacionPromedio.Value), 1, Nothing), &quot;dsResumenLocal&quot;) = 0')) "El resumen TM1 en USD no debe ocultar columnas por ausencia de datos."
Assert-True ($detailRaw.Contains('<Field Name="PrecioPublicoUSDTM1">')) "Falta el campo 'PrecioPublicoUSDTM1' para el resumen TM1 en USD."
Assert-True ($detailRaw.Contains('<Field Name="PrecioExoneradoUSDTM1">')) "Falta el campo 'PrecioExoneradoUSDTM1' para el resumen TM1 en USD."
Assert-True ($detailRaw.Contains('<Field Name="PrecioSinIVAUSDTM1">')) "Falta el campo 'PrecioSinIVAUSDTM1' para el resumen TM1 en USD."
Assert-True ($detailRaw.Contains('<Field Name="PrecioSinImpuestoUSDTM1">')) "Falta el campo 'PrecioSinImpuestoUSDTM1' para el resumen TM1 en USD."
Assert-True ($detailRaw.Contains('<Field Name="PrecioExPlantaUSDTM1">')) "Falta el campo 'PrecioExPlantaUSDTM1' para el resumen TM1 en USD."
Assert-True (($detailRaw -match '&quot;TC&quot;,\s*IF\(\s*\[Anio\] &gt; 2021,') -and ($detailRaw -match '\[TCOriginal\]') -and ($detailRaw -match '\[CotizacionRaw\]')) "El resumen USD debe usar cotizacion TM1 desde 2022 para replicar Cognos."
Assert-True ($detailRaw.Contains('Fields!PrecioPublicoUSDTM1.Value')) "El resumen TM1 en USD no usa el campo 'PrecioPublicoUSDTM1'."
Assert-True ($detailRaw.Contains('Fields!PrecioExoneradoUSDTM1.Value')) "El resumen TM1 en USD no usa el campo 'PrecioExoneradoUSDTM1'."
Assert-True ($detailRaw.Contains('Fields!PrecioSinIVAUSDTM1.Value')) "El resumen TM1 en USD no usa el campo 'PrecioSinIVAUSDTM1'."
Assert-True ($detailRaw.Contains('Fields!PrecioSinImpuestoUSDTM1.Value')) "El resumen TM1 en USD no usa el campo 'PrecioSinImpuestoUSDTM1'."
Assert-True ($detailRaw.Contains('Fields!PrecioExPlantaUSDTM1.Value')) "El resumen TM1 en USD no usa el campo 'PrecioExPlantaUSDTM1'."
Assert-True (-not $detailRaw.Contains('Code.SafeDivide(Fields!PrecioPublico.Value, Fields!CotizacionPromedio.Value)')) "El resumen TM1 en USD no debe recalcular 'Precio Público' dividiendo por cotización."
Assert-True (-not $detailRaw.Contains('Code.SafeDivide(Fields!PrecioExonerado.Value, Fields!CotizacionPromedio.Value)')) "El resumen TM1 en USD no debe recalcular 'Precio Exonerado' dividiendo por cotización."
Assert-True (-not $detailRaw.Contains('Code.SafeDivide(Fields!PrecioSinIVA.Value, Fields!CotizacionPromedio.Value)')) "El resumen TM1 en USD no debe recalcular 'Precio sin IVA' dividiendo por cotización."
Assert-True (-not $detailRaw.Contains('Code.SafeDivide(Fields!PrecioSinImpuesto.Value, Fields!CotizacionPromedio.Value)')) "El resumen TM1 en USD no debe recalcular 'Precio sin impuesto' dividiendo por cotización."

$detailGridColumns = [int]$detailGrid.SelectSingleNode("./rdl:NumberOfColumns", $detailNs).InnerText
$detailGridRows = [int]$detailGrid.SelectSingleNode("./rdl:NumberOfRows", $detailNs).InnerText
$detailGridCells = @($detailGrid.SelectNodes("./rdl:CellDefinitions/rdl:CellDefinition", $detailNs)).Count

Assert-True (($detailGridColumns * $detailGridRows) -ge $detailParameterNames.Count) "La grilla de parametros del reporte detalle no tiene suficientes celdas para todos los parametros."
Assert-True ($detailGridCells -ge $detailParameterNames.Count) "El layout de parametros del reporte detalle no declara suficientes celdas para todos los parametros."

$tabResumen = $detailXml.SelectSingleNode("//rdl:Textbox[@Name='txtTabResumen']", $detailNs)
$tabDetalle = $detailXml.SelectSingleNode("//rdl:Textbox[@Name='txtTabDetalle']", $detailNs)
$tabResumenDetalle = $detailXml.SelectSingleNode("//rdl:Textbox[@Name='txtTabResumenDetalle']", $detailNs)
$tabDetalleDetalle = $detailXml.SelectSingleNode("//rdl:Textbox[@Name='txtTabDetalleDetalle']", $detailNs)
$bodyCanvas = $detailXml.SelectSingleNode("//rdl:Rectangle[@Name='BodyCanvas']", $detailNs)
$emptyState = $detailXml.SelectSingleNode("//rdl:Textbox[rdl:Paragraphs/rdl:Paragraph/rdl:TextRuns/rdl:TextRun/rdl:Value='No hay datos disponibles']", $detailNs)
$summaryBookmark = $detailXml.SelectSingleNode("//rdl:Textbox[@Name='txtTabResumen']/rdl:Bookmark", $detailNs)
$detailBookmark = $detailXml.SelectSingleNode("//rdl:Textbox[@Name='txtTabDetalleDetalle']/rdl:Bookmark", $detailNs)
$summaryToDetailBookmarkLink = $detailXml.SelectSingleNode("//rdl:Textbox[@Name='txtTabDetalle']/rdl:ActionInfo/rdl:Actions/rdl:Action/rdl:BookmarkLink", $detailNs)
$detailToSummaryBookmarkLink = $detailXml.SelectSingleNode("//rdl:Textbox[@Name='txtTabResumenDetalle']/rdl:ActionInfo/rdl:Actions/rdl:Action/rdl:BookmarkLink", $detailNs)
$detailTabDrillthroughs = @($detailXml.SelectNodes("//rdl:Textbox[starts-with(@Name, 'txtTab')]/rdl:ActionInfo/rdl:Actions/rdl:Action/rdl:Drillthrough", $detailNs))

Assert-True ($null -ne $bodyCanvas) "Falta el canvas principal 'BodyCanvas' en el reporte detalle."
Assert-True ($null -ne $tabResumen) "Falta la pestana 'Resumen' en el reporte detalle."
Assert-True ($null -ne $tabDetalle) "Falta la pestana 'Detalle' en el reporte detalle."
Assert-True ($null -ne $tabResumenDetalle) "Falta la pestana 'Resumen' en la seccion detalle del reporte."
Assert-True ($null -ne $tabDetalleDetalle) "Falta la pestana 'Detalle' en la seccion detalle del reporte."
Assert-True ($null -ne $emptyState) "Falta el estado vacio 'No hay datos disponibles' en el reporte detalle."
Assert-True ($null -ne $summaryBookmark) "La seccion Resumen debe definir un bookmark para navegar internamente en preview."
Assert-True ($null -ne $detailBookmark) "La seccion Detalle debe definir un bookmark para navegar internamente en preview."
Assert-True ($null -ne $summaryToDetailBookmarkLink) "La pestana Detalle del resumen debe navegar con bookmark interno."
Assert-True ($null -ne $detailToSummaryBookmarkLink) "La pestana Resumen del detalle debe navegar con bookmark interno."
Assert-True ($summaryBookmark.InnerText -eq "bookmarkSummaryView") "El bookmark de la seccion Resumen debe ser 'bookmarkSummaryView'."
Assert-True ($detailBookmark.InnerText -eq "bookmarkDetailView") "El bookmark de la seccion Detalle debe ser 'bookmarkDetailView'."
Assert-True ($summaryToDetailBookmarkLink.InnerText -eq "bookmarkDetailView") "La pestana Detalle del resumen debe saltar a 'bookmarkDetailView'."
Assert-True ($detailToSummaryBookmarkLink.InnerText -eq "bookmarkSummaryView") "La pestana Resumen del detalle debe saltar a 'bookmarkSummaryView'."
Assert-True ($detailTabDrillthroughs.Count -eq 0) "Las pestanas internas del reporte detalle no deben usar drillthrough; en preview deben navegar con bookmarks."
Assert-True (-not $detailRaw.Contains('Code.ShowDetail(Parameters!pProducto.Value)')) "La vista Detalle no debe quedar bloqueada por una lista fija de productos; debe depender de los datos devueltos."
Assert-True ($detailRaw.Contains('Code.NormalizeUnit(Parameters!pUnidad.Value) &lt;&gt; &quot;USD/m3&quot; Or Code.ShouldUseUsdTm1Summary(Parameters!pProducto.Value, Parameters!pAnio.Value)')) "La tabla resumen en USD debe depender solo de la unidad y la seleccion centralizada de resumen TM1."
Assert-True ($detailRaw.Contains('Code.NormalizeUnit(Parameters!pUnidad.Value) = &quot;USD/m3&quot;')) "La tabla detalle en moneda local debe depender solo de la unidad."
Assert-True ($detailRaw.Contains('CountRows("dsDetalle") &gt; 0')) "El estado vacio del detalle debe mostrarse cuando la vista Detalle no devuelve filas."

$drillNodes = @(
    $parentXml.SelectNodes("//rdl:Drillthrough[rdl:ReportName='Precios Unitarios Ex Planta - detalle']", $parentNs)
)

Assert-True ($drillNodes.Count -ge 2) "Se esperaban al menos 2 acciones de drillthrough al detalle en el reporte padre."

foreach ($drillNode in $drillNodes) {
    $drillParams = @(
        $drillNode.SelectNodes("./rdl:Parameters/rdl:Parameter", $parentNs)
    )

    $drillParamNames = @($drillParams | ForEach-Object { $_.Name })
    foreach ($parameterName in @("pAnio", "pProducto", "pUnidad", "pVista")) {
        Assert-True ($drillParamNames -contains $parameterName) "Falta el parametro '$parameterName' en una accion de drillthrough del reporte padre."
    }

    $pVistaNode = $drillParams | Where-Object { $_.Name -eq "pVista" } | Select-Object -First 1
    Assert-True ($null -ne $pVistaNode) "No se encontro el parametro pVista en una accion de drillthrough."
    Assert-True ($pVistaNode.InnerXml -match "Resumen") "El parametro pVista del drillthrough debe abrir en 'Resumen'."
}

Write-Host "Validacion estructural OK."
