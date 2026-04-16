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

function Convert-InchesToNumber {
    param([string]$Value)

    if ($Value -notmatch '^[0-9]+(\.[0-9]+)?in$') {
        throw "Valor de tamano invalido: '$Value'"
    }

    return [double]($Value -replace 'in$', '')
}

function Get-Center {
    param(
        [double]$Left,
        [double]$Width
    )

    return $Left + ($Width / 2.0)
}

$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$reportPath = Join-Path $repoRoot "reports\precios-unitarios-ex-planta-base\Precios_unitarios_ex_planta_base.rdl"

Assert-True (Test-Path -LiteralPath $reportPath) "No se encontro el reporte base en '$reportPath'."

[xml]$reportXml = [System.IO.File]::ReadAllText($reportPath, [System.Text.UTF8Encoding]::new($false))

$ns = New-Object System.Xml.XmlNamespaceManager($reportXml.NameTable)
$ns.AddNamespace("rdl", "http://schemas.microsoft.com/sqlserver/reporting/2016/01/reportdefinition")

$bodyWidthNode = $reportXml.SelectSingleNode("//rdl:ReportSection/rdl:Body/following-sibling::rdl:Width[1]", $ns)
$bodyCanvasNode = $reportXml.SelectSingleNode("//rdl:Rectangle[@Name='BodyCanvas']", $ns)
$headerNode = $reportXml.SelectSingleNode("//rdl:Rectangle[@Name='rectHeader']", $ns)
$titleNode = $reportXml.SelectSingleNode("//rdl:Textbox[@Name='txtTitulo']", $ns)
$anioNode = $reportXml.SelectSingleNode("//rdl:Textbox[@Name='txtHeaderAnio']", $ns)
$descripcionNode = $reportXml.SelectSingleNode("//rdl:Textbox[@Name='txtDescripcion']", $ns)
$descripcionVisibilityNode = $reportXml.SelectSingleNode("//rdl:Textbox[@Name='txtDescripcion']/rdl:Visibility", $ns)
$descripcionHiddenNode = $reportXml.SelectSingleNode("//rdl:Textbox[@Name='txtDescripcion']/rdl:Visibility/rdl:Hidden", $ns)
$descripcionToggleNode = $reportXml.SelectSingleNode("//rdl:Textbox[@Name='txtDescripcion']/rdl:Visibility/rdl:ToggleItem", $ns)
$usdNode = $reportXml.SelectSingleNode("//rdl:Tablix[@Name='tablixUSD']", $ns)
$uyuNode = $reportXml.SelectSingleNode("//rdl:Tablix[@Name='tablixUYU']", $ns)
$pageWidthNode = $reportXml.SelectSingleNode("//rdl:Page/rdl:PageWidth", $ns)
$leftMarginNode = $reportXml.SelectSingleNode("//rdl:Page/rdl:LeftMargin", $ns)
$rightMarginNode = $reportXml.SelectSingleNode("//rdl:Page/rdl:RightMargin", $ns)

Assert-True ($null -ne $bodyWidthNode) "No se encontro el Width del Body del reporte base."
Assert-True ($null -ne $bodyCanvasNode) "No se encontro el canvas principal 'BodyCanvas'."
Assert-True ($null -ne $headerNode) "No se encontro el header principal 'rectHeader'."
Assert-True ($null -ne $titleNode) "No se encontro el textbox de titulo 'txtTitulo'."
Assert-True ($null -ne $anioNode) "No se encontro el textbox del anio en el header."
Assert-True ($null -ne $descripcionNode) "No se encontro el bloque 'txtDescripcion'."
Assert-True ($null -ne $descripcionVisibilityNode) "El bloque 'txtDescripcion' debe declarar visibilidad explicita."
Assert-True ($null -ne $descripcionHiddenNode) "El bloque 'txtDescripcion' debe declarar el estado inicial Hidden."
Assert-True ($null -ne $descripcionToggleNode) "El bloque 'txtDescripcion' debe seguir controlado por el toggle del encabezado."
Assert-True ($null -ne $usdNode) "No se encontro la tablix USD."
Assert-True ($null -ne $uyuNode) "No se encontro la tablix en moneda local."
Assert-True ($null -ne $pageWidthNode) "No se encontro el PageWidth del reporte base."
Assert-True ($null -ne $leftMarginNode) "No se encontro el LeftMargin del reporte base."
Assert-True ($null -ne $rightMarginNode) "No se encontro el RightMargin del reporte base."

$bodyWidth = Convert-InchesToNumber $bodyWidthNode.InnerText
$bodyCanvasWidth = Convert-InchesToNumber ($bodyCanvasNode.SelectSingleNode("./rdl:Width", $ns).InnerText)
$headerWidth = Convert-InchesToNumber ($headerNode.SelectSingleNode("./rdl:Width", $ns).InnerText)
$titleLeft = Convert-InchesToNumber ($titleNode.SelectSingleNode("./rdl:Left", $ns).InnerText)
$titleWidth = Convert-InchesToNumber ($titleNode.SelectSingleNode("./rdl:Width", $ns).InnerText)
$anioLeft = Convert-InchesToNumber ($anioNode.SelectSingleNode("./rdl:Left", $ns).InnerText)
$anioWidth = Convert-InchesToNumber ($anioNode.SelectSingleNode("./rdl:Width", $ns).InnerText)
$usdLeft = Convert-InchesToNumber ($usdNode.SelectSingleNode("./rdl:Left", $ns).InnerText)
$usdWidth = Convert-InchesToNumber ($usdNode.SelectSingleNode("./rdl:Width", $ns).InnerText)
$uyuLeft = Convert-InchesToNumber ($uyuNode.SelectSingleNode("./rdl:Left", $ns).InnerText)
$uyuWidth = Convert-InchesToNumber ($uyuNode.SelectSingleNode("./rdl:Width", $ns).InnerText)
$pageWidth = Convert-InchesToNumber $pageWidthNode.InnerText
$leftMargin = Convert-InchesToNumber $leftMarginNode.InnerText
$rightMargin = Convert-InchesToNumber $rightMarginNode.InnerText

$titleCenter = Get-Center -Left $titleLeft -Width $titleWidth
$anioCenter = Get-Center -Left $anioLeft -Width $anioWidth
$usdCenter = Get-Center -Left $usdLeft -Width $usdWidth
$uyuCenter = Get-Center -Left $uyuLeft -Width $uyuWidth

Assert-True ($bodyWidth -ge 20.0) "El body del reporte sigue siendo angosto ($bodyWidth in); debe ensancharse mas para reducir el espacio blanco en Power BI Service."
Assert-True ([math]::Abs($bodyCanvasWidth - $bodyWidth) -lt 0.01) "El BodyCanvas debe ocupar todo el ancho del body."
Assert-True ([math]::Abs($headerWidth - $bodyWidth) -lt 0.01) "El header debe ocupar el mismo ancho que el body."
Assert-True ([math]::Abs(($leftMargin + $bodyWidth + $rightMargin) - $pageWidth) -lt 0.01) "PageWidth debe ser consistente con body y margenes."
Assert-True ([math]::Abs($titleCenter - $usdCenter) -le 0.15) "La tablix USD debe quedar centrada respecto al titulo del encabezado."
Assert-True ([math]::Abs($titleCenter - $uyuCenter) -le 0.15) "La tablix local debe quedar centrada respecto al titulo del encabezado."
Assert-True ([math]::Abs($titleCenter - $anioCenter) -le 0.05) "El anio del encabezado debe compartir el mismo eje central que el titulo."
Assert-True ($descripcionToggleNode.InnerText -eq "txtToggleDescripcion") "La descripcion debe seguir vinculada al toggle 'txtToggleDescripcion'."
Assert-True ($descripcionHiddenNode.InnerText.Trim().ToLowerInvariant() -eq "false") "La descripcion debe abrir visible por defecto."

Write-Host "Validacion de layout base OK."
