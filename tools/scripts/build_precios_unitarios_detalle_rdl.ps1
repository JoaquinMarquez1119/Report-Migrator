$ErrorActionPreference = "Stop"
$invariantCulture = [System.Globalization.CultureInfo]::InvariantCulture

function Xml-Escape {
    param([string]$Text)
    return [System.Security.SecurityElement]::Escape($Text)
}

function Repair-Mojibake {
    param([string]$Text)

    $cp1252 = [System.Text.Encoding]::GetEncoding(1252)
    $utf8 = [System.Text.Encoding]::UTF8
    return $utf8.GetString($cp1252.GetBytes($Text))
}

function Normalize-GeneratedText {
    param([string]$Text)

    $replacement = [char]0xFFFD
    $ntilde = [char]0x00F1
    $aacute = [char]0x00E1
    $eacute = [char]0x00E9
    $iacute = [char]0x00ED
    $oacute = [char]0x00F3
    $uacute = [char]0x00FA

    $replacements = @(
        @{ Bad = "A${replacement}os"; Good = "A${ntilde}os" },
        @{ Bad = "A${replacement}o Base"; Good = "A${ntilde}o Base" },
        @{ Bad = "AÃ±os"; Good = "A${ntilde}os" },
        @{ Bad = "AÃ±o Base"; Good = "A${ntilde}o Base" },
        @{ Bad = "Aï¿½os"; Good = "A${ntilde}os" },
        @{ Bad = "Aï¿½o Base"; Good = "A${ntilde}o Base" },
        @{ Bad = "Seleccionar A${replacement}o:"; Good = "Seleccionar A${ntilde}o:" },
        @{ Bad = "Seleccionar AÃ±o:"; Good = "Seleccionar A${ntilde}o:" },
        @{ Bad = "Seleccionar Aï¿½o:"; Good = "Seleccionar A${ntilde}o:" },
        @{ Bad = "Precio P${replacement}blico"; Good = "Precio P${uacute}blico" },
        @{ Bad = "Precio PÃºblico"; Good = "Precio P${uacute}blico" },
        @{ Bad = "Precio Pï¿½blico"; Good = "Precio P${uacute}blico" },
        @{ Bad = "Precio de Venta al P${replacement}blico (PVP) (impuestos incluidos)"; Good = "Precio de Venta al P${uacute}blico (PVP) (impuestos incluidos)" },
        @{ Bad = "Precio de Venta al PÃºblico (PVP) (impuestos incluidos)"; Good = "Precio de Venta al P${uacute}blico (PVP) (impuestos incluidos)" },
        @{ Bad = "Precio de Venta al Pï¿½blico (PVP) (impuestos incluidos)"; Good = "Precio de Venta al P${uacute}blico (PVP) (impuestos incluidos)" },
        @{ Bad = "Bonificaci${replacement}n estaciones de servicio"; Good = "Bonificaci${oacute}n estaciones de servicio" },
        @{ Bad = "BonificaciÃ³n estaciones de servicio"; Good = "Bonificaci${oacute}n estaciones de servicio" },
        @{ Bad = "Bonificaciï¿½n estaciones de servicio"; Good = "Bonificaci${oacute}n estaciones de servicio" },
        @{ Bad = "Tasa URSEA etapa venta al p${replacement}blico"; Good = "Tasa URSEA etapa venta al p${uacute}blico" },
        @{ Bad = "Tasa URSEA etapa venta al pÃºblico"; Good = "Tasa URSEA etapa venta al p${uacute}blico" },
        @{ Bad = "Tasa URSEA etapa venta al pï¿½blico"; Good = "Tasa URSEA etapa venta al p${uacute}blico" },
        @{ Bad = "IVA etapa venta al p${replacement}blico"; Good = "IVA etapa venta al p${uacute}blico" },
        @{ Bad = "IVA etapa venta al pÃºblico"; Good = "IVA etapa venta al p${uacute}blico" },
        @{ Bad = "IVA etapa venta al pï¿½blico"; Good = "IVA etapa venta al p${uacute}blico" },
        @{ Bad = "Margen de distribuci${replacement}n"; Good = "Margen de distribuci${oacute}n" },
        @{ Bad = "Margen de distribuciÃ³n"; Good = "Margen de distribuci${oacute}n" },
        @{ Bad = "Margen de distribuciï¿½n"; Good = "Margen de distribuci${oacute}n" },
        @{ Bad = "Margen de distribuci${replacement}n de GLP envasado"; Good = "Margen de distribuci${oacute}n de GLP envasado" },
        @{ Bad = "Margen de distribuciÃ³n de GLP envasado"; Good = "Margen de distribuci${oacute}n de GLP envasado" },
        @{ Bad = "Margen de distribuciï¿½n de GLP envasado"; Good = "Margen de distribuci${oacute}n de GLP envasado" },
        @{ Bad = "Tasa URSEA etapa distribuci${replacement}n"; Good = "Tasa URSEA etapa distribuci${oacute}n" },
        @{ Bad = "Tasa URSEA etapa distribuciÃ³n"; Good = "Tasa URSEA etapa distribuci${oacute}n" },
        @{ Bad = "Tasa URSEA etapa distribuciï¿½n"; Good = "Tasa URSEA etapa distribuci${oacute}n" },
        @{ Bad = "IVA etapa distribuci${replacement}n"; Good = "IVA etapa distribuci${oacute}n" },
        @{ Bad = "IVA etapa distribuciÃ³n"; Good = "IVA etapa distribuci${oacute}n" },
        @{ Bad = "IVA etapa distribuciï¿½n"; Good = "IVA etapa distribuci${oacute}n" },
        @{ Bad = "Compensaci${replacement}n Con Fin Social (CFS)"; Good = "Compensaci${oacute}n Con Fin Social (CFS)" },
        @{ Bad = "CompensaciÃ³n Con Fin Social (CFS)"; Good = "Compensaci${oacute}n Con Fin Social (CFS)" },
        @{ Bad = "Compensaciï¿½n Con Fin Social (CFS)"; Good = "Compensaci${oacute}n Con Fin Social (CFS)" },
        @{ Bad = "Compensaci${replacement}n Bonificaci${replacement}n EESS con Fin Social (CFS)"; Good = "Compensaci${oacute}n Bonificaci${oacute}n EESS con Fin Social (CFS)" },
        @{ Bad = "CompensaciÃ³n BonificaciÃ³n EESS con Fin Social (CFS)"; Good = "Compensaci${oacute}n Bonificaci${oacute}n EESS con Fin Social (CFS)" },
        @{ Bad = "Compensaciï¿½n Bonificaciï¿½n EESS con Fin Social (CFS)"; Good = "Compensaci${oacute}n Bonificaci${oacute}n EESS con Fin Social (CFS)" },
        @{ Bad = "Cotizaci${replacement}n"; Good = "Cotizaci${oacute}n" },
        @{ Bad = "CotizaciÃ³n"; Good = "Cotizaci${oacute}n" },
        @{ Bad = "Cotizaciï¿½n"; Good = "Cotizaci${oacute}n" },
        @{ Bad = "$/lt ${replacement} $/kg seg${replacement}n corresponda"; Good = "$/lt ${oacute} $/kg seg${uacute}n corresponda" },
        @{ Bad = "$/lt Ã³ $/kg segÃºn corresponda"; Good = "$/lt ${oacute} $/kg seg${uacute}n corresponda" },
        @{ Bad = "$/lt ï¿½ $/kg segï¿½n corresponda"; Good = "$/lt ${oacute} $/kg seg${uacute}n corresponda" },
        @{ Bad = "m${replacement}rgenes"; Good = "m${aacute}rgenes" },
        @{ Bad = "mÃ¡rgenes"; Good = "m${aacute}rgenes" },
        @{ Bad = "mï¿½rgenes"; Good = "m${aacute}rgenes" }
    )

    foreach ($replacementEntry in $replacements) {
        $Text = $Text.Replace($replacementEntry.Bad, $replacementEntry.Good)
    }

    return $Text
}

function Fix-GeneratedText {
    param([string]$Text)

    return Normalize-GeneratedText $Text
}

function Remove-InvalidUnicode {
    param([string]$Text)

    if ([string]::IsNullOrEmpty($Text)) {
        return $Text
    }

    $builder = New-Object System.Text.StringBuilder
    foreach ($char in $Text.ToCharArray()) {
        if (-not [char]::IsSurrogate($char)) {
            [void]$builder.Append($char)
        }
    }

    return $builder.ToString()
}

function Remove-InvalidTextChars {
    param([string]$Text)

    if ([string]::IsNullOrEmpty($Text)) {
        return $Text
    }

    $builder = New-Object System.Text.StringBuilder
    foreach ($char in $Text.ToCharArray()) {
        $codePoint = [int][char]$char
        $isAllowedControl = $codePoint -in 9, 10, 13
        if (($codePoint -ge 32 -or $isAllowedControl) -and -not [char]::IsSurrogate($char)) {
            [void]$builder.Append($char)
        }
    }

    return $builder.ToString()
}

function Normalize-MojibakeSequences {
    param([string]$Text)

    if ([string]::IsNullOrEmpty($Text)) {
        return $Text
    }

    $prefix = [string][char]0x00C3
    $sequenceReplacements = @(
        @{ Bad = $prefix + [string][char]0x00B1; Good = [string][char]0x00F1 },
        @{ Bad = $prefix + [string][char]0x00A1; Good = [string][char]0x00E1 },
        @{ Bad = $prefix + [string][char]0x00A9; Good = [string][char]0x00E9 },
        @{ Bad = $prefix + [string][char]0x00AD; Good = [string][char]0x00ED },
        @{ Bad = $prefix + [string][char]0x00B3; Good = [string][char]0x00F3 },
        @{ Bad = $prefix + [string][char]0x00BA; Good = [string][char]0x00FA }
    )

    foreach ($replacementEntry in $sequenceReplacements) {
        $Text = $Text.Replace($replacementEntry.Bad, $replacementEntry.Good)
    }

    return $Text
}

function New-StaticTablix {
    param(
        [string]$Name,
        [string]$DataSetName,
        [string]$Left,
        [string]$Top,
        [array]$Columns,
        [string]$HiddenExpr,
        [string]$NoRowsMessage = "No hay datos disponibles"
    )

    $hasSubHeader = $false
    foreach ($column in $Columns) {
        if ($column.SubHeader) {
            $hasSubHeader = $true
            break
        }
    }

    $tablixColumns = New-Object System.Collections.Generic.List[string]
    foreach ($column in $Columns) {
        $tablixColumns.Add("<TablixColumn><Width>$($column.Width)</Width></TablixColumn>")
    }

    $headerRowCells = New-Object System.Collections.Generic.List[string]
    $subHeaderRowCells = New-Object System.Collections.Generic.List[string]
    $detailRowCells = New-Object System.Collections.Generic.List[string]

    foreach ($column in $Columns) {
        $headerRowCells.Add(@"
<TablixCell>
  <CellContents>
    <Textbox Name="$($Name)_$($column.Name)_Header">
      <CanGrow>true</CanGrow>
      <KeepTogether>true</KeepTogether>
      <Paragraphs>
        <Paragraph>
          <TextRuns>
            <TextRun>
              <Value>$(Xml-Escape $column.Header)</Value>
              <Style>
                <Color>White</Color>
                <FontSize>8pt</FontSize>
                <FontWeight>Bold</FontWeight>
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
        <PaddingLeft>3pt</PaddingLeft>
        <PaddingRight>3pt</PaddingRight>
        <PaddingTop>3pt</PaddingTop>
        <PaddingBottom>3pt</PaddingBottom>
      </Style>
    </Textbox>
  </CellContents>
</TablixCell>
"@)

        if ($hasSubHeader) {
            $subText = if ($column.SubHeader) { $column.SubHeader } else { "" }
            $subHeaderRowCells.Add(@"
<TablixCell>
  <CellContents>
    <Textbox Name="$($Name)_$($column.Name)_SubHeader">
      <CanGrow>true</CanGrow>
      <KeepTogether>true</KeepTogether>
      <Paragraphs>
        <Paragraph>
          <TextRuns>
            <TextRun>
              <Value>$(Xml-Escape $subText)</Value>
              <Style>
                <Color>Black</Color>
                <FontSize>8pt</FontSize>
                <FontWeight>Bold</FontWeight>
              </Style>
            </TextRun>
          </TextRuns>
          <Style><TextAlign>Center</TextAlign></Style>
        </Paragraph>
      </Paragraphs>
      <Style>
        <Border><Color>Gray</Color><Style>Solid</Style></Border>
        <BackgroundColor>#C8C8C8</BackgroundColor>
        <VerticalAlign>Middle</VerticalAlign>
        <PaddingLeft>3pt</PaddingLeft>
        <PaddingRight>3pt</PaddingRight>
        <PaddingTop>3pt</PaddingTop>
        <PaddingBottom>3pt</PaddingBottom>
      </Style>
    </Textbox>
  </CellContents>
</TablixCell>
"@)
        }

        $detailRowCells.Add(@"
<TablixCell>
  <CellContents>
    <Textbox Name="$($Name)_$($column.Name)_Detail">
      <CanGrow>true</CanGrow>
      <KeepTogether>true</KeepTogether>
      <Paragraphs>
        <Paragraph>
          <TextRuns>
            <TextRun>
              <Value>$(Xml-Escape $column.Expression)</Value>
              <Style><FontSize>8pt</FontSize></Style>
            </TextRun>
          </TextRuns>
          <Style><TextAlign>$($column.Align)</TextAlign></Style>
        </Paragraph>
      </Paragraphs>
      <Style>
        <Border><Color>Gray</Color><Style>Solid</Style></Border>
        <BackgroundColor>#F2F2F2</BackgroundColor>
        <VerticalAlign>Middle</VerticalAlign>
        <PaddingLeft>4pt</PaddingLeft>
        <PaddingRight>4pt</PaddingRight>
        <PaddingTop>4pt</PaddingTop>
        <PaddingBottom>4pt</PaddingBottom>
      </Style>
    </Textbox>
  </CellContents>
</TablixCell>
"@)
    }

    $tablixRows = New-Object System.Collections.Generic.List[string]
    $tablixRows.Add("<TablixRow><Height>0.38in</Height><TablixCells>$($headerRowCells -join '')</TablixCells></TablixRow>")
    if ($hasSubHeader) {
        $tablixRows.Add("<TablixRow><Height>0.28in</Height><TablixCells>$($subHeaderRowCells -join '')</TablixCells></TablixRow>")
    }
    $tablixRows.Add("<TablixRow><Height>0.28in</Height><TablixCells>$($detailRowCells -join '')</TablixCells></TablixRow>")

    $columnHierarchyMembers = ($Columns | ForEach-Object {
        if ($_.HideExpr) {
            "<TablixMember><Visibility><Hidden>$(Xml-Escape $_.HideExpr)</Hidden></Visibility></TablixMember>"
        }
        else {
            "<TablixMember />"
        }
    }) -join ""

    $rowHierarchyMembers = @(
        "<TablixMember><KeepWithGroup>After</KeepWithGroup><RepeatOnNewPage>true</RepeatOnNewPage></TablixMember>"
    )
    if ($hasSubHeader) {
        $rowHierarchyMembers += "<TablixMember><KeepWithGroup>After</KeepWithGroup><RepeatOnNewPage>true</RepeatOnNewPage></TablixMember>"
    }
    $rowHierarchyMembers += @"
<TablixMember>
  <Group Name="${Name}_Details" />
  <SortExpressions>
    <SortExpression><Value>=Fields!SortKey.Value</Value></SortExpression>
  </SortExpressions>
</TablixMember>
"@

    $totalWidth = 0.0
    foreach ($column in $Columns) {
        $totalWidth += [double]($column.Width -replace 'in', '')
    }
    $height = if ($hasSubHeader) { "1.14in" } else { "0.98in" }

    return @"
<Tablix Name="$Name">
  <TablixBody>
    <TablixColumns>$($tablixColumns -join '')</TablixColumns>
    <TablixRows>$($tablixRows -join '')</TablixRows>
  </TablixBody>
  <TablixColumnHierarchy><TablixMembers>$columnHierarchyMembers</TablixMembers></TablixColumnHierarchy>
  <TablixRowHierarchy><TablixMembers>$($rowHierarchyMembers -join '')</TablixMembers></TablixRowHierarchy>
  <NoRowsMessage>$(Xml-Escape $NoRowsMessage)</NoRowsMessage>
  <DataSetName>$DataSetName</DataSetName>
  <Visibility><Hidden>$(Xml-Escape $HiddenExpr)</Hidden></Visibility>
  <Top>$Top</Top>
  <Left>$Left</Left>
  <Height>$height</Height>
  <Width>$($totalWidth.ToString('0.00', $invariantCulture))in</Width>
  <Style><Border><Style>None</Style></Border></Style>
</Tablix>
"@
}

function New-NonZeroColumnHiddenExpr {
    param(
        [string]$ShowExpr,
        [string]$FieldRef,
        [string]$DataSetName
    )

    return "$ShowExpr Or Count(IIF(Not IsNothing($FieldRef) And $FieldRef <> 0, 1, Nothing), ""$DataSetName"") = 0"
}

function New-UnitAwareNonZeroColumnHiddenExpr {
    param(
        [string]$ShowExpr,
        [string]$LocalFieldRef,
        [string]$UsdFieldRef,
        [string]$DataSetName
    )

    return "$ShowExpr Or Count(IIF((Code.NormalizeUnit(Parameters!pUnidad.Value) = ""USD/m3"" And Not IsNothing($UsdFieldRef) And $UsdFieldRef <> 0) Or (Code.NormalizeUnit(Parameters!pUnidad.Value) <> ""USD/m3"" And Not IsNothing($LocalFieldRef) And $LocalFieldRef <> 0), 1, Nothing), ""$DataSetName"") = 0"
}

function New-ColumnAllowanceExpr {
    param(
        [string]$ViewKey,
        [string]$ColumnKey
    )

    return "Not Code.IsColumnAllowed(""$ViewKey"", Parameters!pProducto.Value, Parameters!pAnio.Value, Parameters!pUnidad.Value, ""$ColumnKey"")"
}

$workspaceRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$parentPath = Join-Path $workspaceRoot "reports\precios-unitarios-ex-planta-base\Precios_unitarios_ex_planta_base.rdl"
$detailPath = Join-Path $workspaceRoot "reports\precios-unitarios-ex-planta-detalle\Precios Unitarios Ex Planta - detalle.rdl"
$content = Get-Content -LiteralPath $parentPath -Raw

$allDataQuery = Fix-GeneratedText @'
EVALUATE
VAR __CurDate = TODAY()
VAR __CurYear = YEAR(__CurDate)
VAR __CurMonth = MONTH(__CurDate)
VAR __CurDay = DAY(__CurDate)
VAR __TM1Lookup =
    ADDCOLUMNS(
        SUMMARIZECOLUMNS(
            'Precios_ExPLanta_2_TM1'[Años],
            'Precios_ExPLanta_2_TM1'[Periodo_Mensual],
            'Precios_ExPLanta_2_TM1'[Productos_ExPlanta],
            FILTER(
                ALL('Precios_ExPLanta_2_TM1'),
                'Precios_ExPLanta_2_TM1'[Años] <> "Año Base" &&
                'Precios_ExPLanta_2_TM1'[Periodo_Mensual] <> "Base" &&
                LEFT('Precios_ExPLanta_2_TM1'[Productos_ExPlanta], 4) <> "RPMS"
            ),
            "CotizacionRaw", CALCULATE(SUM('Precios_ExPLanta_2_TM1'[Valor]), 'Precios_ExPLanta_2_TM1'[Medidas_ExPlanta] = "CotizaciÃ³n", 'Precios_ExPLanta_2_TM1'[Unidades] = "N/A"),
            "DensidadRaw", CALCULATE(SUM('Precios_ExPLanta_2_TM1'[Valor]), 'Precios_ExPLanta_2_TM1'[Medidas_ExPlanta] = "Densidad")
        ),
        "LookupAnio", VALUE('Precios_ExPLanta_2_TM1'[Años]),
        "LookupMesNumero", SWITCH('Precios_ExPLanta_2_TM1'[Periodo_Mensual], "Ene", 1, "Feb", 2, "Mar", 3, "Abr", 4, "May", 5, "Jun", 6, "Jul", 7, "Ago", 8, "Sep", 9, "Oct", 10, "Nov", 11, "Dic", 12, BLANK()),
        "LookupProducto", SWITCH('Precios_ExPLanta_2_TM1'[Productos_ExPlanta], "Asfalto AC-20", "Asfalto AC-30", "Super 95 Sp", "Gasolina Super 95", "Premium 97 Sp", "Gasolina Premium 97", "Gasolina Av 100 Octa", "Gasolina Av 100 Octanos", "Gasoil Comun", "Gasoil 50-S", "Gasoil Especial", "Gasoil 10-S", "Propano", "Propano Industrial", 'Precios_ExPLanta_2_TM1'[Productos_ExPlanta])
    )
VAR __Base =
    ADDCOLUMNS(
        SUMMARIZECOLUMNS(
            'Precios_Ex_Planta'[Fecha],
            'Precios_Ex_Planta'[Producto],
            "TCOriginal", MAX('Precios_Ex_Planta'[TC]),
            "PrecioPublico", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] = "Precio PÃºblico"),
            "PrecioExonerado", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] = "Precio Exonerado"),
            "IVA", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] = "IVA"),
            "PrecioSinIVA", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] = "Precio sin IVA"),
            "PVPImp", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] = "Precio de Venta al PÃºblico (PVP) (impuestos incluidos)"),
            "PITImp", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] = "Precio Intermedio Transitorio (PIT) (impuestos incluidos)"),
            "PEPImp", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] = "Precio Ex Planta (PEP) (impuestos incluidos)"),
            "PEPSinFleteImp", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] = "Precio Ex Planta (PEP) sin flete secundario (impuestos incluidos)"),
            "PEP", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] IN { "PEP", "PPI sin tasas e impuestos + Factor X" }),
            "FactorAjuste", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] IN { "Factor X o factor de ajuste", "Factor de ajuste" }),
            "PEPCalcUrsea", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] IN { "PPI sin tasas e impuestos", "PEP calculado por URSEA (*)" }),
            "MontoDiferencialZonasD", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] IN { "Factor d para GLP Dec 205/023", "Monto diferencial por zonas ""d""" }),
            "PPIN1", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] = "PPI n-1 Periodo URSEA"),
            "PPIN2", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] = "PPI n-2 Periodo URSEA"),
            "TasaInflamable", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] = "Tasa IMM sobre CL dist primaria al interior (23,2% del total)"),
            "MargenGLPEnvasado", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] = "Margen de distribuciÃ³n de GLP envasado"),
            "BonificacionEESS", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] = "BonificaciÃ³n estaciones de servicio"),
            "TasaURSEAVenta", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] = "Tasa URSEA etapa venta al pÃºblico"),
            "IVAVentaPublico", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] = "IVA etapa venta al pÃºblico"),
            "MargenEnvasado", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] = "Margen de envasado"),
            "MargenDistribucion", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] IN { "Margen de distribuidoras", "Margen de distribuciÃ³n" }),
            "TasaURSEADistribucion", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] = "Tasa URSEA etapa distribuciÃ³n"),
            "IVADistribucion", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] = "IVA etapa distribuciÃ³n"),
            "Flete", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] IN { "Flete", "Flete, de plantas a estaciones de servicio (mes n-2)" }),
            "TasaURSEASecundaria", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] = "Tasa URSEA etapa secundaria"),
            "IVASecundaria", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] = "IVA etapa secundaria"),
            "CompensacionCFS", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] IN { "CompensaciÃ³n Con Fin Social (CFS)", "CompensaciÃ³n BonificaciÃ³n EESS con Fin Social (CFS)" }),
            "IMESI", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] = "IMESI"),
            "ImpuestoCO2", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] = "Impuesto CO2"),
            "TasaURSEAPrimaria", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] = "Tasa URSEA etapa primaria"),
            "FUDAEE", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] = "FUDAEE"),
            "IVAPrimaria", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] = "IVA etapa primaria"),
            "Fideicomiso", CALCULATE(SUM('Precios_Ex_Planta'[Valor]), 'Precios_Ex_Planta'[Concepto] = "Fideicomiso Gasoil (dto. 347/006)")
        ),
        "Anio", YEAR('Precios_Ex_Planta'[Fecha]),
        "MesNumero", MONTH('Precios_Ex_Planta'[Fecha]),
        "SortKey", YEAR('Precios_Ex_Planta'[Fecha]) * 100 + MONTH('Precios_Ex_Planta'[Fecha]),
        "ProductoNormalizado", SWITCH('Precios_Ex_Planta'[Producto], "GLP", "Supergas", "Asfalto AC-20", "Asfalto AC-30", "Super 95 Sp", "Gasolina Super 95", "Premium 97 Sp", "Gasolina Premium 97", "Gasolina Av 100 Octa", "Gasolina Av 100 Octanos", "Gasoil Comun", "Gasoil 50-S", "Gasoil Especial", "Gasoil 10-S", "Propano", "Propano Industrial", 'Precios_Ex_Planta'[Producto]),
        "ProductoLookup", SWITCH('Precios_Ex_Planta'[Producto], "GLP", "Supergas", "Asfalto AC-20", "Asfalto AC-30", "Super 95 Sp", "Gasolina Super 95", "Premium 97 Sp", "Gasolina Premium 97", "Gasolina Av 100 Octa", "Gasolina Av 100 Octanos", "Gasoil Comun", "Gasoil 50-S", "Gasoil Especial", "Gasoil 10-S", "Propano", "Propano Industrial", 'Precios_Ex_Planta'[Producto]),
        "Dia", IF(
            YEAR('Precios_Ex_Planta'[Fecha]) = __CurYear && MONTH('Precios_Ex_Planta'[Fecha]) = __CurMonth,
            FORMAT(__CurDay, "0") & "-" & SWITCH(MONTH('Precios_Ex_Planta'[Fecha]), 1, "Ene", 2, "Feb", 3, "Mar", 4, "Abr", 5, "May", 6, "Jun", 7, "Jul", 8, "Ago", 9, "Set", 10, "Oct", 11, "Nov", 12, "Dic"),
            FORMAT(DAY(EOMONTH('Precios_Ex_Planta'[Fecha], 0)), "0") & "-" & SWITCH(MONTH('Precios_Ex_Planta'[Fecha]), 1, "Ene", 2, "Feb", 3, "Mar", 4, "Abr", 5, "May", 6, "Jun", 7, "Jul", 8, "Ago", 9, "Set", 10, "Oct", 11, "Nov", 12, "Dic")
        ),
        "Unidad2", SWITCH(
            SWITCH('Precios_Ex_Planta'[Producto], "GLP", "Supergas", "Gasolina Av 100 Octa", "Gasolina Av 100 Octanos", 'Precios_Ex_Planta'[Producto]),
            "Supergas", "$/kg",
            "Supergas A Granel", "$/kg",
            "Propano", "$/kg",
            "Propano Industrial", "$/kg",
            "Propano Redes", "$/kg",
            "Asfalto AC-20", "$/kg",
            "Asfalto AC-30", "$/kg",
            "Asfalto 150/200", "$/kg",
            "Asfalto MC1", "$/kg",
            "Asfalto RC2", "$/kg",
            "Butano Desodorizado", "$/kg",
            "$/lt"
        )
    )
VAR __WithLookup =
    ADDCOLUMNS(
        __Base,
        "TC", IF(
            [Anio] > 2021,
            MAXX(
                FILTER(__TM1Lookup, [LookupAnio] = [Anio] && [LookupMesNumero] = [MesNumero] && [LookupProducto] = [ProductoLookup]),
                [CotizacionRaw]
            ),
            COALESCE(
                [TCOriginal],
                MAXX(
                    FILTER(__TM1Lookup, [LookupAnio] = [Anio] && [LookupMesNumero] = [MesNumero] && [LookupProducto] = [ProductoLookup]),
                    [CotizacionRaw]
                )
            )
        ),
        "Densidad", MAXX(
            FILTER(__TM1Lookup, [LookupAnio] = [Anio] && [LookupMesNumero] = [MesNumero] && [LookupProducto] = [ProductoLookup]),
            [DensidadRaw]
        )
    )
VAR __Final =
    ADDCOLUMNS(
        __WithLookup,
        "PVPImpUSD", IF([Unidad2] = "$/kg", DIVIDE([PVPImp] * [Densidad] * 1000, [TC], BLANK()), DIVIDE([PVPImp] * 1000, [TC], BLANK())),
        "PITImpUSD", IF([Unidad2] = "$/kg", DIVIDE([PITImp] * [Densidad] * 1000, [TC], BLANK()), DIVIDE([PITImp] * 1000, [TC], BLANK())),
        "PEPImpUSD", IF([Unidad2] = "$/kg", DIVIDE([PEPImp] * [Densidad] * 1000, [TC], BLANK()), DIVIDE([PEPImp] * 1000, [TC], BLANK())),
        "PEPSinFleteImpUSD", IF([Unidad2] = "$/kg", DIVIDE([PEPSinFleteImp] * [Densidad] * 1000, [TC], BLANK()), DIVIDE([PEPSinFleteImp] * 1000, [TC], BLANK())),
        "PEPUSD", IF([Unidad2] = "$/kg", DIVIDE([PEP] * [Densidad] * 1000, [TC], BLANK()), DIVIDE([PEP] * 1000, [TC], BLANK())),
        "FactorAjusteUSD", IF([Unidad2] = "$/kg", DIVIDE([FactorAjuste] * [Densidad] * 1000, [TC], BLANK()), DIVIDE([FactorAjuste] * 1000, [TC], BLANK())),
        "PEPCalcUrseaUSD", IF([Unidad2] = "$/kg", DIVIDE([PEPCalcUrsea] * [Densidad] * 1000, [TC], BLANK()), DIVIDE([PEPCalcUrsea] * 1000, [TC], BLANK())),
        "MontoDiferencialZonasDUSD", IF([Unidad2] = "$/kg", DIVIDE([MontoDiferencialZonasD] * [Densidad] * 1000, [TC], BLANK()), DIVIDE([MontoDiferencialZonasD] * 1000, [TC], BLANK())),
        "PPIN1USD", IF([Unidad2] = "$/kg", DIVIDE([PPIN1] * [Densidad] * 1000, [TC], BLANK()), DIVIDE([PPIN1] * 1000, [TC], BLANK())),
        "PPIN2USD", IF([Unidad2] = "$/kg", DIVIDE([PPIN2] * [Densidad] * 1000, [TC], BLANK()), DIVIDE([PPIN2] * 1000, [TC], BLANK())),
        "TasaInflamableUSD", IF([Unidad2] = "$/kg", DIVIDE([TasaInflamable] * [Densidad] * 1000, [TC], BLANK()), DIVIDE([TasaInflamable] * 1000, [TC], BLANK())),
        "MargenGLPEnvasadoUSD", IF([Unidad2] = "$/kg", DIVIDE([MargenGLPEnvasado] * [Densidad] * 1000, [TC], BLANK()), DIVIDE([MargenGLPEnvasado] * 1000, [TC], BLANK())),
        "BonificacionEESSUSD", IF([Unidad2] = "$/kg", DIVIDE([BonificacionEESS] * [Densidad] * 1000, [TC], BLANK()), DIVIDE([BonificacionEESS] * 1000, [TC], BLANK())),
        "TasaURSEAVentaUSD", IF([Unidad2] = "$/kg", DIVIDE([TasaURSEAVenta] * [Densidad] * 1000, [TC], BLANK()), DIVIDE([TasaURSEAVenta] * 1000, [TC], BLANK())),
        "IVAVentaPublicoUSD", IF([Unidad2] = "$/kg", DIVIDE([IVAVentaPublico] * [Densidad] * 1000, [TC], BLANK()), DIVIDE([IVAVentaPublico] * 1000, [TC], BLANK())),
        "MargenEnvasadoUSD", IF([Unidad2] = "$/kg", DIVIDE([MargenEnvasado] * [Densidad] * 1000, [TC], BLANK()), DIVIDE([MargenEnvasado] * 1000, [TC], BLANK())),
        "MargenDistribucionUSD", IF([Unidad2] = "$/kg", DIVIDE([MargenDistribucion] * [Densidad] * 1000, [TC], BLANK()), DIVIDE([MargenDistribucion] * 1000, [TC], BLANK())),
        "TasaURSEADistribucionUSD", IF([Unidad2] = "$/kg", DIVIDE([TasaURSEADistribucion] * [Densidad] * 1000, [TC], BLANK()), DIVIDE([TasaURSEADistribucion] * 1000, [TC], BLANK())),
        "IVADistribucionUSD", IF([Unidad2] = "$/kg", DIVIDE([IVADistribucion] * [Densidad] * 1000, [TC], BLANK()), DIVIDE([IVADistribucion] * 1000, [TC], BLANK())),
        "FleteUSD", IF([Unidad2] = "$/kg", DIVIDE([Flete] * [Densidad] * 1000, [TC], BLANK()), DIVIDE([Flete] * 1000, [TC], BLANK())),
        "TasaURSEASecundariaUSD", IF([Unidad2] = "$/kg", DIVIDE([TasaURSEASecundaria] * [Densidad] * 1000, [TC], BLANK()), DIVIDE([TasaURSEASecundaria] * 1000, [TC], BLANK())),
        "IVASecundariaUSD", IF([Unidad2] = "$/kg", DIVIDE([IVASecundaria] * [Densidad] * 1000, [TC], BLANK()), DIVIDE([IVASecundaria] * 1000, [TC], BLANK())),
        "CompensacionCFSUSD", IF([Unidad2] = "$/kg", DIVIDE([CompensacionCFS] * [Densidad] * 1000, [TC], BLANK()), DIVIDE([CompensacionCFS] * 1000, [TC], BLANK())),
        "IMESIUSD", IF([Unidad2] = "$/kg", DIVIDE([IMESI] * [Densidad] * 1000, [TC], BLANK()), DIVIDE([IMESI] * 1000, [TC], BLANK())),
        "ImpuestoCO2USD", IF([Unidad2] = "$/kg", DIVIDE([ImpuestoCO2] * [Densidad] * 1000, [TC], BLANK()), DIVIDE([ImpuestoCO2] * 1000, [TC], BLANK())),
        "TasaURSEAPrimariaUSD", IF([Unidad2] = "$/kg", DIVIDE([TasaURSEAPrimaria] * [Densidad] * 1000, [TC], BLANK()), DIVIDE([TasaURSEAPrimaria] * 1000, [TC], BLANK())),
        "FUDAEEUSD", IF([Unidad2] = "$/kg", DIVIDE([FUDAEE] * [Densidad] * 1000, [TC], BLANK()), DIVIDE([FUDAEE] * 1000, [TC], BLANK())),
        "IVAPrimariaUSD", IF([Unidad2] = "$/kg", DIVIDE([IVAPrimaria] * [Densidad] * 1000, [TC], BLANK()), DIVIDE([IVAPrimaria] * 1000, [TC], BLANK())),
        "FideicomisoUSD", IF([Unidad2] = "$/kg", DIVIDE([Fideicomiso] * [Densidad] * 1000, [TC], BLANK()), DIVIDE([Fideicomiso] * 1000, [TC], BLANK()))
    )
RETURN
SELECTCOLUMNS(
    FILTER(__Final, NOT ISBLANK([Producto]) && [Producto] <> "N/A"),
    "Anio", [Anio],
    "MesNumero", [MesNumero],
    "SortKey", [SortKey],
    "Dia", [Dia],
    "Producto", [ProductoNormalizado],
    "Unidad2", [Unidad2],
    "TC", [TC],
    "PrecioPublico", [PrecioPublico],
    "PrecioExonerado", [PrecioExonerado],
    "IVA", [IVA],
    "PrecioSinIVA", [PrecioSinIVA],
    "PVPImp", [PVPImp],
    "PITImp", [PITImp],
    "PEPImp", [PEPImp],
    "PEPSinFleteImp", [PEPSinFleteImp],
    "PEP", [PEP],
    "FactorAjuste", [FactorAjuste],
    "PEPCalcUrsea", [PEPCalcUrsea],
    "MontoDiferencialZonasD", [MontoDiferencialZonasD],
    "PPIN1", [PPIN1],
    "PPIN2", [PPIN2],
    "TasaInflamable", [TasaInflamable],
    "PVPImpUSD", [PVPImpUSD],
    "PITImpUSD", [PITImpUSD],
    "PEPImpUSD", [PEPImpUSD],
    "PEPSinFleteImpUSD", [PEPSinFleteImpUSD],
    "PEPUSD", [PEPUSD],
    "FactorAjusteUSD", [FactorAjusteUSD],
    "PEPCalcUrseaUSD", [PEPCalcUrseaUSD],
    "MontoDiferencialZonasDUSD", [MontoDiferencialZonasDUSD],
    "PPIN1USD", [PPIN1USD],
    "PPIN2USD", [PPIN2USD],
    "TasaInflamableUSD", [TasaInflamableUSD],
    "MargenGLPEnvasado", [MargenGLPEnvasado],
    "BonificacionEESS", [BonificacionEESS],
    "TasaURSEAVenta", [TasaURSEAVenta],
    "IVAVentaPublico", [IVAVentaPublico],
    "MargenEnvasado", [MargenEnvasado],
    "MargenDistribucion", [MargenDistribucion],
    "TasaURSEADistribucion", [TasaURSEADistribucion],
    "IVADistribucion", [IVADistribucion],
    "Flete", [Flete],
    "TasaURSEASecundaria", [TasaURSEASecundaria],
    "IVASecundaria", [IVASecundaria],
    "CompensacionCFS", [CompensacionCFS],
    "IMESI", [IMESI],
    "ImpuestoCO2", [ImpuestoCO2],
    "TasaURSEAPrimaria", [TasaURSEAPrimaria],
    "FUDAEE", [FUDAEE],
    "IVAPrimaria", [IVAPrimaria],
    "Fideicomiso", [Fideicomiso],
    "MargenGLPEnvasadoUSD", [MargenGLPEnvasadoUSD],
    "BonificacionEESSUSD", [BonificacionEESSUSD],
    "TasaURSEAVentaUSD", [TasaURSEAVentaUSD],
    "IVAVentaPublicoUSD", [IVAVentaPublicoUSD],
    "MargenEnvasadoUSD", [MargenEnvasadoUSD],
    "MargenDistribucionUSD", [MargenDistribucionUSD],
    "TasaURSEADistribucionUSD", [TasaURSEADistribucionUSD],
    "IVADistribucionUSD", [IVADistribucionUSD],
    "FleteUSD", [FleteUSD],
    "TasaURSEASecundariaUSD", [TasaURSEASecundariaUSD],
    "IVASecundariaUSD", [IVASecundariaUSD],
    "CompensacionCFSUSD", [CompensacionCFSUSD],
    "IMESIUSD", [IMESIUSD],
    "ImpuestoCO2USD", [ImpuestoCO2USD],
    "TasaURSEAPrimariaUSD", [TasaURSEAPrimariaUSD],
    "FUDAEEUSD", [FUDAEEUSD],
    "IVAPrimariaUSD", [IVAPrimariaUSD],
    "FideicomisoUSD", [FideicomisoUSD]
)
ORDER BY [SortKey]
'@

$summaryLocalQuery = Fix-GeneratedText @'
EVALUATE
VAR __CurDate = TODAY()
VAR __CurYear = YEAR(__CurDate)
VAR __CurMonth = MONTH(__CurDate)
VAR __Base =
    SUMMARIZECOLUMNS(
        'Precios_ExPLanta_2_TM1'[Años],
        'Precios_ExPLanta_2_TM1'[Periodo_Mensual],
        'Precios_ExPLanta_2_TM1'[Productos_ExPlanta],
        FILTER(
            ALL('Precios_ExPLanta_2_TM1'),
            'Precios_ExPLanta_2_TM1'[Mercados] = "Interno" &&
            'Precios_ExPLanta_2_TM1'[Años] <> "Año Base" &&
            'Precios_ExPLanta_2_TM1'[Periodo_Mensual] <> "Base" &&
            LEFT('Precios_ExPLanta_2_TM1'[Productos_ExPlanta], 4) <> "RPMS" &&
            'Precios_ExPLanta_2_TM1'[Unidades] IN { "$/ton", "$/m3", "$/litro", "$/kg", "U$S/ton", "U$S/m3", "N/A" }
        ),
        "PrecioPublico", CALCULATE(SUM('Precios_ExPLanta_2_TM1'[Valor]), 'Precios_ExPLanta_2_TM1'[Medidas_ExPlanta] = "Precio PÃºblico", 'Precios_ExPLanta_2_TM1'[Unidades] IN { "$/ton", "$/m3", "$/litro", "$/kg" }),
        "PrecioPublicoUSDTM1", CALCULATE(SUM('Precios_ExPLanta_2_TM1'[Valor]), 'Precios_ExPLanta_2_TM1'[Medidas_ExPlanta] = "Precio PÃºblico", 'Precios_ExPLanta_2_TM1'[Unidades] IN { "U$S/ton", "U$S/m3" }),
        "PrecioExonerado", CALCULATE(SUM('Precios_ExPLanta_2_TM1'[Valor]), 'Precios_ExPLanta_2_TM1'[Medidas_ExPlanta] = "Precio Exonerado", 'Precios_ExPLanta_2_TM1'[Unidades] IN { "$/ton", "$/m3", "$/litro", "$/kg" }),
        "PrecioExoneradoUSDTM1", CALCULATE(SUM('Precios_ExPLanta_2_TM1'[Valor]), 'Precios_ExPLanta_2_TM1'[Medidas_ExPlanta] = "Precio Exonerado", 'Precios_ExPLanta_2_TM1'[Unidades] IN { "U$S/ton", "U$S/m3" }),
        "IVA", CALCULATE(SUM('Precios_ExPLanta_2_TM1'[Valor]), 'Precios_ExPLanta_2_TM1'[Medidas_ExPlanta] = "IVA", 'Precios_ExPLanta_2_TM1'[Unidades] = "N/A"),
        "PrecioSinIVA", CALCULATE(SUM('Precios_ExPLanta_2_TM1'[Valor]), 'Precios_ExPLanta_2_TM1'[Medidas_ExPlanta] = "Precio sin IVA", 'Precios_ExPLanta_2_TM1'[Unidades] IN { "$/ton", "$/m3", "$/litro", "$/kg" }),
        "PrecioSinIVAUSDTM1", CALCULATE(SUM('Precios_ExPLanta_2_TM1'[Valor]), 'Precios_ExPLanta_2_TM1'[Medidas_ExPlanta] = "Precio sin IVA", 'Precios_ExPLanta_2_TM1'[Unidades] IN { "U$S/ton", "U$S/m3" }),
        "IMESI", CALCULATE(SUM('Precios_ExPLanta_2_TM1'[Valor]), 'Precios_ExPLanta_2_TM1'[Medidas_ExPlanta] = "IMESI"),
        "CotizacionPromedio", CALCULATE(SUM('Precios_ExPLanta_2_TM1'[Valor]), 'Precios_ExPLanta_2_TM1'[Medidas_ExPlanta] = "CotizaciÃ³n Promedio", 'Precios_ExPLanta_2_TM1'[Unidades] = "N/A"),
        "Cotizacion", CALCULATE(SUM('Precios_ExPLanta_2_TM1'[Valor]), 'Precios_ExPLanta_2_TM1'[Medidas_ExPlanta] = "CotizaciÃ³n", 'Precios_ExPLanta_2_TM1'[Unidades] = "N/A"),
        "PrecioSinImpuesto", CALCULATE(SUM('Precios_ExPLanta_2_TM1'[Valor]), 'Precios_ExPLanta_2_TM1'[Medidas_ExPlanta] = "Precio sin impuesto", 'Precios_ExPLanta_2_TM1'[Unidades] IN { "$/ton", "$/m3", "$/litro", "$/kg" }),
        "PrecioSinImpuestoUSDTM1", CALCULATE(SUM('Precios_ExPLanta_2_TM1'[Valor]), 'Precios_ExPLanta_2_TM1'[Medidas_ExPlanta] = "Precio sin impuesto", 'Precios_ExPLanta_2_TM1'[Unidades] IN { "U$S/ton", "U$S/m3" }),
        "UnidadTM1", COALESCE(
            CALCULATE(MAX('Precios_ExPLanta_2_TM1'[Unidades]), 'Precios_ExPLanta_2_TM1'[Medidas_ExPlanta] = "Precio Ex Planta", 'Precios_ExPLanta_2_TM1'[Unidades] IN { "$/ton", "$/m3", "$/litro", "$/kg" }),
            CALCULATE(MAX('Precios_ExPLanta_2_TM1'[Unidades]), 'Precios_ExPLanta_2_TM1'[Medidas_ExPlanta] = "Precio PÃºblico", 'Precios_ExPLanta_2_TM1'[Unidades] IN { "$/ton", "$/m3", "$/litro", "$/kg" })
        ),
        "MargenBonificaciones", CALCULATE(SUM('Precios_ExPLanta_2_TM1'[Valor]), 'Precios_ExPLanta_2_TM1'[Medidas_ExPlanta] = "Margen y Bonificaciones"),
        "TasaInflamable", CALCULATE(SUM('Precios_ExPLanta_2_TM1'[Valor]), 'Precios_ExPLanta_2_TM1'[Medidas_ExPlanta] = "Tasa de Inflamable"),
        "TasaURSEA", CALCULATE(SUM('Precios_ExPLanta_2_TM1'[Valor]), 'Precios_ExPLanta_2_TM1'[Medidas_ExPlanta] = "Tasa de URSEA"),
        "FideicomisoTM1", CALCULATE(SUM('Precios_ExPLanta_2_TM1'[Valor]), 'Precios_ExPLanta_2_TM1'[Medidas_ExPlanta] = "Fideicomiso"),
        "FleteTM1", CALCULATE(SUM('Precios_ExPLanta_2_TM1'[Valor]), 'Precios_ExPLanta_2_TM1'[Medidas_ExPlanta] = "Flete"),
        "PrecioExPlantaTM1", CALCULATE(SUM('Precios_ExPLanta_2_TM1'[Valor]), 'Precios_ExPLanta_2_TM1'[Medidas_ExPlanta] = "Precio Ex Planta", 'Precios_ExPLanta_2_TM1'[Unidades] IN { "$/ton", "$/m3", "$/litro", "$/kg" }),
        "PrecioExPlantaUSDTM1", CALCULATE(SUM('Precios_ExPLanta_2_TM1'[Valor]), 'Precios_ExPLanta_2_TM1'[Medidas_ExPlanta] = "Precio Ex Planta", 'Precios_ExPLanta_2_TM1'[Unidades] IN { "U$S/ton", "U$S/m3" }),
        "DensidadTM1", CALCULATE(SUM('Precios_ExPLanta_2_TM1'[Valor]), 'Precios_ExPLanta_2_TM1'[Medidas_ExPlanta] = "Densidad")
    )
VAR __WithAttrs =
    ADDCOLUMNS(
        __Base,
        "Anio", IFERROR(VALUE('Precios_ExPLanta_2_TM1'[Años]), BLANK()),
        "MesNumero", SWITCH('Precios_ExPLanta_2_TM1'[Periodo_Mensual], "Ene", 1, "Feb", 2, "Mar", 3, "Abr", 4, "May", 5, "Jun", 6, "Jul", 7, "Ago", 8, "Sep", 9, "Oct", 10, "Nov", 11, "Dic", 12, BLANK()),
        "ProductoNormalizado", SWITCH('Precios_ExPLanta_2_TM1'[Productos_ExPlanta], "GLP", "Supergas", "Asfalto AC-20", "Asfalto AC-30", "Super 95 Sp", "Gasolina Super 95", "Premium 97 Sp", "Gasolina Premium 97", "Gasolina Av 100 Octa", "Gasolina Av 100 Octanos", "Gasoil Comun", "Gasoil 50-S", "Gasoil Especial", "Gasoil 10-S", "Propano", "Propano Industrial", 'Precios_ExPLanta_2_TM1'[Productos_ExPlanta])
    )
VAR __Final =
    ADDCOLUMNS(
        __WithAttrs,
        "SortKey", [Anio] * 100 + [MesNumero],
        "Dia", IF(
            [Anio] = __CurYear && [MesNumero] = __CurMonth,
            FORMAT(DAY(__CurDate), "0") & "-" & SWITCH([MesNumero], 1, "Ene", 2, "Feb", 3, "Mar", 4, "Abr", 5, "May", 6, "Jun", 7, "Jul", 8, "Ago", 9, "Set", 10, "Oct", 11, "Nov", 12, "Dic"),
            FORMAT(DAY(EOMONTH(DATE([Anio], [MesNumero], 1), 0)), "0") & "-" & SWITCH([MesNumero], 1, "Ene", 2, "Feb", 3, "Mar", 4, "Abr", 5, "May", 6, "Jun", 7, "Jul", 8, "Ago", 9, "Set", 10, "Oct", 11, "Nov", 12, "Dic")
        )
    )
RETURN
SELECTCOLUMNS(
    FILTER(
        __Final,
        NOT ISBLANK([Anio]) &&
        NOT ISBLANK([MesNumero]) &&
        NOT ISBLANK([ProductoNormalizado]) &&
        [ProductoNormalizado] <> "N/A" &&
        NOT ([Anio] = __CurYear && [MesNumero] = __CurMonth) &&
        SWITCH(
            TRUE(),
            [ProductoNormalizado] IN { "Queroseno Montevideo", "Queroseno Interior" }, [SortKey] <= 202107,
            [ProductoNormalizado] IN { "Propano Industrial", "Propano Redes", "Supergas", "Supergas A Granel" }, [SortKey] <= 202306,
            [ProductoNormalizado] IN { "Asfalto AC-30", "Asfalto 150/200", "Asfalto MC1", "Asfalto RC2", "Queroseno Montevideo", "Queroseno Interior" }, TRUE(),
            [SortKey] <= 202106
        )
    ),
    "Anio", [Anio],
    "MesNumero", [MesNumero],
    "SortKey", [SortKey],
    "Dia", [Dia],
    "Producto", [ProductoNormalizado],
    "PrecioPublico", [PrecioPublico],
    "PrecioPublicoUSDTM1", [PrecioPublicoUSDTM1],
    "PrecioExonerado", [PrecioExonerado],
    "PrecioExoneradoUSDTM1", [PrecioExoneradoUSDTM1],
    "IVA", [IVA],
    "PrecioSinIVA", [PrecioSinIVA],
    "PrecioSinIVAUSDTM1", [PrecioSinIVAUSDTM1],
    "IMESI", [IMESI],
    "CotizacionPromedio", [CotizacionPromedio],
    "Cotizacion", [Cotizacion],
    "PrecioSinImpuesto", [PrecioSinImpuesto],
    "PrecioSinImpuestoUSDTM1", [PrecioSinImpuestoUSDTM1],
    "UnidadTM1", [UnidadTM1],
    "MargenBonificaciones", [MargenBonificaciones],
    "TasaInflamable", [TasaInflamable],
    "TasaURSEA", [TasaURSEA],
    "FideicomisoTM1", [FideicomisoTM1],
    "FleteTM1", [FleteTM1],
    "PrecioExPlantaTM1", [PrecioExPlantaTM1],
    "PrecioExPlantaUSDTM1", [PrecioExPlantaUSDTM1],
    "DensidadTM1", [DensidadTM1]
)
ORDER BY [SortKey]
'@

$summaryUsdColumns = @(
    @{ Name = "Dia"; Width = "0.60in"; Header = "USD/m3"; SubHeader = ""; Expression = "=Fields!Dia.Value"; Align = "Center" },
    @{ Name = "PVP"; Width = "2.90in"; Header = "Precio de Venta al PÃºblico (PVP) (impuestos incluidos)"; SubHeader = ""; Expression = "=Code.FormatValue(Fields!PVPImpUSD.Value, 2)"; Align = "Right"; HideExpr = "=$(New-NonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'SummaryUsd' 'PVP') 'Fields!PVPImpUSD.Value' 'dsResumen')" },
    @{ Name = "PIT"; Width = "2.55in"; Header = "Precio Intermedio Transitorio (PIT) (impuestos incluidos)"; SubHeader = ""; Expression = "=Code.FormatValue(Fields!PITImpUSD.Value, 2)"; Align = "Right"; HideExpr = "=$(New-NonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'SummaryUsd' 'PIT') 'Fields!PITImpUSD.Value' 'dsResumen')" },
    @{ Name = "PEPImp"; Width = "2.30in"; Header = "Precio Ex Planta (PEP) (impuestos incluidos)"; SubHeader = ""; Expression = "=Code.FormatValue(Fields!PEPImpUSD.Value, 2)"; Align = "Right"; HideExpr = "=$(New-NonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'SummaryUsd' 'PEPImp') 'Fields!PEPImpUSD.Value' 'dsResumen')" },
    @{ Name = "TasaInflamable"; Width = "1.05in"; Header = "Tasa inflamable"; SubHeader = ""; Expression = "=Code.FormatValue(Fields!TasaInflamableUSD.Value, 4)"; Align = "Right"; HideExpr = "=$(New-NonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'SummaryUsd' 'TasaInflamable') 'Fields!TasaInflamableUSD.Value' 'dsResumen')" },
    @{ Name = "PEPSinFlete"; Width = "3.05in"; Header = "Precio Ex Planta (PEP) sin flete secundario (impuestos incluidos)"; SubHeader = ""; Expression = "=Code.FormatValue(Fields!PEPSinFleteImpUSD.Value, 2)"; Align = "Right"; HideExpr = "=$(New-NonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'SummaryUsd' 'PEPSinFlete') 'Fields!PEPSinFleteImpUSD.Value' 'dsResumen')" },
    @{ Name = "IMESI"; Width = "0.95in"; Header = "IMESI"; SubHeader = ""; Expression = "=Code.FormatValue(Fields!IMESIUSD.Value, 4)"; Align = "Right"; HideExpr = "=$(New-NonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'SummaryUsd' 'IMESI') 'Fields!IMESIUSD.Value' 'dsResumen')" },
    @{ Name = "TasaPrim"; Width = "1.05in"; Header = "Tasa URSEA etapa primaria"; SubHeader = ""; Expression = "=Code.FormatValue(Fields!TasaURSEAPrimariaUSD.Value, 4)"; Align = "Right"; HideExpr = "=$(New-NonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'SummaryUsd' 'TasaPrim') 'Fields!TasaURSEAPrimariaUSD.Value' 'dsResumen')" },
    @{ Name = "FUDAEE"; Width = "0.90in"; Header = "FUDAEE"; SubHeader = ""; Expression = "=Code.FormatValue(Fields!FUDAEEUSD.Value, 4)"; Align = "Right"; HideExpr = "=$(New-NonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'SummaryUsd' 'FUDAEE') 'Fields!FUDAEEUSD.Value' 'dsResumen')" },
    @{ Name = "Factor"; Width = "1.05in"; Header = "Factor de ajuste"; SubHeader = ""; Expression = "=Code.FormatValue(Fields!FactorAjusteUSD.Value, 2)"; Align = "Right"; HideExpr = "=$(New-NonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'SummaryUsd' 'Factor') 'Fields!FactorAjusteUSD.Value' 'dsResumen')" },
    @{ Name = "Ursea"; Width = "1.55in"; Header = "PEP calculado por URSEA (*)"; SubHeader = ""; Expression = "=Code.FormatValue(Fields!PEPCalcUrseaUSD.Value, 2)"; Align = "Right"; HideExpr = "=$(New-NonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'SummaryUsd' 'Ursea') 'Fields!PEPCalcUrseaUSD.Value' 'dsResumen')" },
    @{ Name = "MontoDiferencial"; Width = "1.75in"; Header = "Monto diferencial por zonas ""d"""; SubHeader = ""; Expression = "=Code.FormatValue(Fields!MontoDiferencialZonasDUSD.Value, 2)"; Align = "Right"; HideExpr = "=$(New-NonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'SummaryUsd' 'MontoDiferencial') 'Fields!MontoDiferencialZonasDUSD.Value' 'dsResumen')" },
    @{ Name = "PPIN1"; Width = "1.25in"; Header = "PPI n-1 Periodo URSEA"; SubHeader = ""; Expression = "=Code.FormatValue(Fields!PPIN1USD.Value, 2)"; Align = "Right"; HideExpr = "=$(New-NonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'SummaryUsd' 'PPIN1') 'Fields!PPIN1USD.Value' 'dsResumen')" },
    @{ Name = "PPIN2"; Width = "1.25in"; Header = "PPI n-2 Periodo URSEA"; SubHeader = ""; Expression = "=Code.FormatValue(Fields!PPIN2USD.Value, 2)"; Align = "Right"; HideExpr = "=$(New-NonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'SummaryUsd' 'PPIN2') 'Fields!PPIN2USD.Value' 'dsResumen')" },
    @{ Name = "PEP"; Width = "1.15in"; Header = "Precio Ex Planta (PEP)"; SubHeader = ""; Expression = "=Code.FormatValue(Fields!PEPUSD.Value, 2)"; Align = "Right"; HideExpr = "=$(New-NonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'SummaryUsd' 'PEP') 'Fields!PEPUSD.Value' 'dsResumen')" }
)

$summaryUsdTm1Columns = @(
    @{ Name = "Dia"; Width = "0.60in"; Header = ""; SubHeader = ""; Expression = "=Fields!Dia.Value"; Align = "Center" },
    @{ Name = "PrecioPublicoUsd"; Width = "1.10in"; Header = "Precio PÃºblico"; SubHeader = "U$S/ton"; Expression = "=Code.FormatValue(Fields!PrecioPublicoUSDTM1.Value, 2)"; Align = "Right"; HideExpr = '=False' },
    @{ Name = "PrecioExoneradoUsd"; Width = "1.10in"; Header = "Precio Exonerado"; SubHeader = "U$S/ton"; Expression = "=Code.FormatValue(Fields!PrecioExoneradoUSDTM1.Value, 2)"; Align = "Right"; HideExpr = '=False' },
    @{ Name = "IVA"; Width = "0.80in"; Header = "IVA"; SubHeader = "N/A"; Expression = "=Code.FormatValue(Fields!IVA.Value, 2)"; Align = "Right"; HideExpr = '=False' },
    @{ Name = "PrecioSinIVAUsd"; Width = "1.10in"; Header = "Precio sin IVA"; SubHeader = "U$S/ton"; Expression = "=Code.FormatValue(Fields!PrecioSinIVAUSDTM1.Value, 2)"; Align = "Right"; HideExpr = '=False' },
    @{ Name = "Cotizacion"; Width = "0.95in"; Header = "CotizaciÃ³n"; SubHeader = "N/A"; Expression = "=Code.FormatValue(Fields!Cotizacion.Value, 2)"; Align = "Right"; HideExpr = '=False' },
    @{ Name = "PrecioSinImpuestoUsd"; Width = "1.10in"; Header = "Precio sin impuesto"; SubHeader = "U$S/ton"; Expression = "=Code.FormatValue(Fields!PrecioSinImpuestoUSDTM1.Value, 2)"; Align = "Right"; HideExpr = '=False' },
    @{ Name = "PrecioExPlantaTM1"; Width = "1.10in"; Header = "Precio Ex Planta"; SubHeader = "U$S/m3"; Expression = "=Code.FormatValue(Fields!PrecioExPlantaUSDTM1.Value, 2)"; Align = "Right"; HideExpr = '=False' }
)

$summaryLocalColumns = @(
    @{ Name = "Dia"; Width = "0.60in"; Header = ""; SubHeader = ""; Expression = "=Fields!Dia.Value"; Align = "Center" },
    @{ Name = "PrecioPublico"; Width = "1.10in"; Header = "Precio PÃºblico"; SubHeader = '=Code.NormalizeDisplayUnit(First(Fields!UnidadTM1.Value, "dsResumenLocal"))'; Expression = "=Code.FormatValue(Fields!PrecioPublico.Value, 2)"; Align = "Right"; HideExpr = "=$(New-NonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'SummaryLocalTm1' 'PrecioPublico') 'Fields!PrecioPublico.Value' 'dsResumenLocal')" },
    @{ Name = "PrecioExonerado"; Width = "1.10in"; Header = "Precio Exonerado"; SubHeader = '=Code.NormalizeDisplayUnit(First(Fields!UnidadTM1.Value, "dsResumenLocal"))'; Expression = "=Code.FormatValue(Fields!PrecioExonerado.Value, 2)"; Align = "Right"; HideExpr = "=$(New-NonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'SummaryLocalTm1' 'PrecioExonerado') 'Fields!PrecioExonerado.Value' 'dsResumenLocal')" },
    @{ Name = "IVA"; Width = "0.80in"; Header = "IVA"; SubHeader = "N/A"; Expression = "=Code.FormatValue(Fields!IVA.Value, 2)"; Align = "Right"; HideExpr = "=$(New-NonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'SummaryLocalTm1' 'IVA') 'Fields!IVA.Value' 'dsResumenLocal')" },
    @{ Name = "PrecioSinIVA"; Width = "1.10in"; Header = "Precio sin IVA"; SubHeader = '=Code.NormalizeDisplayUnit(First(Fields!UnidadTM1.Value, "dsResumenLocal"))'; Expression = "=Code.FormatValue(Fields!PrecioSinIVA.Value, 2)"; Align = "Right"; HideExpr = "=$(New-NonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'SummaryLocalTm1' 'PrecioSinIVA') 'Fields!PrecioSinIVA.Value' 'dsResumenLocal')" },
    @{ Name = "IMESI"; Width = "0.95in"; Header = "IMESI"; SubHeader = '=Code.NormalizeDisplayUnit(First(Fields!UnidadTM1.Value, "dsResumenLocal"))'; Expression = "=Code.FormatValue(Fields!IMESI.Value, 2)"; Align = "Right"; HideExpr = "=$(New-NonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'SummaryLocalTm1' 'IMESI') 'Fields!IMESI.Value' 'dsResumenLocal')" },
    @{ Name = "Cotizacion"; Width = "0.95in"; Header = "CotizaciÃ³n"; SubHeader = "N/A"; Expression = "=Code.FormatValue(Fields!Cotizacion.Value, 2)"; Align = "Right"; HideExpr = "=$(New-NonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'SummaryLocalTm1' 'Cotizacion') 'Fields!Cotizacion.Value' 'dsResumenLocal')" },
    @{ Name = "PrecioSinImpuesto"; Width = "1.10in"; Header = "Precio sin impuesto"; SubHeader = '=Code.NormalizeDisplayUnit(First(Fields!UnidadTM1.Value, "dsResumenLocal"))'; Expression = "=Code.FormatValue(Fields!PrecioSinImpuesto.Value, 2)"; Align = "Right"; HideExpr = "=$(New-NonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'SummaryLocalTm1' 'PrecioSinImpuesto') 'Fields!PrecioSinImpuesto.Value' 'dsResumenLocal')" },
    @{ Name = "PrecioExPlantaTM1"; Width = "1.10in"; Header = "Precio Ex Planta"; SubHeader = '=Code.NormalizeDisplayUnit(First(Fields!UnidadTM1.Value, "dsResumenLocal"))'; Expression = "=Code.FormatValue(Fields!PrecioExPlantaTM1.Value, 2)"; Align = "Right"; HideExpr = "=$(New-NonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'SummaryLocalTm1' 'PrecioExPlanta') 'Fields!PrecioExPlantaTM1.Value' 'dsResumenLocal')" }
)

$summaryLocalMainColumns = @(
    @{ Name = "Dia"; Width = "0.60in"; Header = '=Code.ViewUnitLabel(Parameters!pUnidad.Value, First(Fields!Unidad2.Value, "dsResumen"))'; SubHeader = ""; Expression = "=Fields!Dia.Value"; Align = "Center" },
    @{ Name = "PVP"; Width = "2.90in"; Header = "Precio de Venta al PÃºblico (PVP) (impuestos incluidos)"; SubHeader = ""; Expression = "=Code.FormatValue(Fields!PVPImp.Value, 2)"; Align = "Right"; HideExpr = "=$(New-NonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'SummaryLocalMain' 'PVP') 'Fields!PVPImp.Value' 'dsResumen')" },
    @{ Name = "PIT"; Width = "2.55in"; Header = "Precio Intermedio Transitorio (PIT) (impuestos incluidos)"; SubHeader = ""; Expression = "=Code.FormatValue(Fields!PITImp.Value, 2)"; Align = "Right"; HideExpr = "=$(New-NonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'SummaryLocalMain' 'PIT') 'Fields!PITImp.Value' 'dsResumen')" },
    @{ Name = "PEPImp"; Width = "2.30in"; Header = "Precio Ex Planta (PEP) (impuestos incluidos)"; SubHeader = ""; Expression = "=Code.FormatValue(Fields!PEPImp.Value, 2)"; Align = "Right"; HideExpr = "=$(New-NonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'SummaryLocalMain' 'PEPImp') 'Fields!PEPImp.Value' 'dsResumen')" },
    @{ Name = "PEPSinFlete"; Width = "3.05in"; Header = "Precio Ex Planta (PEP) sin flete secundario (impuestos incluidos)"; SubHeader = ""; Expression = "=Code.FormatValue(Fields!PEPSinFleteImp.Value, 2)"; Align = "Right"; HideExpr = "=$(New-NonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'SummaryLocalMain' 'PEPSinFlete') 'Fields!PEPSinFleteImp.Value' 'dsResumen')" },
    @{ Name = "Factor"; Width = "1.05in"; Header = "Factor de ajuste"; SubHeader = ""; Expression = "=Code.FormatValue(Fields!FactorAjuste.Value, 2)"; Align = "Right"; HideExpr = "=$(New-NonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'SummaryLocalMain' 'Factor') 'Fields!FactorAjuste.Value' 'dsResumen')" },
    @{ Name = "Ursea"; Width = "1.55in"; Header = "PEP calculado por URSEA (*)"; SubHeader = ""; Expression = "=Code.FormatValue(Fields!PEPCalcUrsea.Value, 2)"; Align = "Right"; HideExpr = "=$(New-NonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'SummaryLocalMain' 'Ursea') 'Fields!PEPCalcUrsea.Value' 'dsResumen')" },
    @{ Name = "MontoDiferencial"; Width = "1.75in"; Header = "Monto diferencial por zonas ""d"""; SubHeader = ""; Expression = "=Code.FormatValue(Fields!MontoDiferencialZonasD.Value, 2)"; Align = "Right"; HideExpr = "=$(New-NonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'SummaryLocalMain' 'MontoDiferencial') 'Fields!MontoDiferencialZonasD.Value' 'dsResumen')" },
    @{ Name = "PPIN1"; Width = "1.25in"; Header = "PPI n-1 Periodo URSEA"; SubHeader = ""; Expression = "=Code.FormatValue(Fields!PPIN1.Value, 2)"; Align = "Right"; HideExpr = "=$(New-NonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'SummaryLocalMain' 'PPIN1') 'Fields!PPIN1.Value' 'dsResumen')" },
    @{ Name = "PPIN2"; Width = "1.25in"; Header = "PPI n-2 Periodo URSEA"; SubHeader = ""; Expression = "=Code.FormatValue(Fields!PPIN2.Value, 2)"; Align = "Right"; HideExpr = "=$(New-NonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'SummaryLocalMain' 'PPIN2') 'Fields!PPIN2.Value' 'dsResumen')" },
    @{ Name = "PEP"; Width = "1.15in"; Header = "Precio Ex Planta (PEP)"; SubHeader = ""; Expression = "=Code.FormatValue(Fields!PEP.Value, 2)"; Align = "Right"; HideExpr = "=$(New-NonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'SummaryLocalMain' 'PEP') 'Fields!PEP.Value' 'dsResumen')" }
)

$detailColumns = @(
    @{ Name = "Dia"; Width = "0.60in"; Header = '=Code.ViewUnitLabel(Parameters!pUnidad.Value, First(Fields!Unidad2.Value, "dsDetalle"))'; SubHeader = ""; Expression = "=Fields!Dia.Value"; Align = "Center" },
    @{ Name = "PVP"; Width = "1.25in"; Header = "Precio de Venta al PÃºblico (PVP) (impuestos incluidos)"; SubHeader = ""; Expression = "=Code.ValueByUnit(Fields!PVPImp.Value, Fields!PVPImpUSD.Value, Parameters!pUnidad.Value, 2)"; Align = "Right"; HideExpr = "=$(New-UnitAwareNonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'Detail' 'PVP') 'Fields!PVPImp.Value' 'Fields!PVPImpUSD.Value' 'dsDetalle')" },
    @{ Name = "MargenGLPEnvasado"; Width = "1.15in"; Header = "Margen de distribuciÃ³n de GLP envasado"; SubHeader = ""; Expression = "=Code.ValueByUnit(Fields!MargenGLPEnvasado.Value, Fields!MargenGLPEnvasadoUSD.Value, Parameters!pUnidad.Value, 4)"; Align = "Right"; HideExpr = "=$(New-UnitAwareNonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'Detail' 'MargenGLPEnvasado') 'Fields!MargenGLPEnvasado.Value' 'Fields!MargenGLPEnvasadoUSD.Value' 'dsDetalle')" },
    @{ Name = "Bonificacion"; Width = "1.15in"; Header = "BonificaciÃ³n estaciones de servicio"; SubHeader = ""; Expression = "=Code.ValueByUnit(Fields!BonificacionEESS.Value, Fields!BonificacionEESSUSD.Value, Parameters!pUnidad.Value, 4)"; Align = "Right"; HideExpr = "=$(New-UnitAwareNonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'Detail' 'Bonificacion') 'Fields!BonificacionEESS.Value' 'Fields!BonificacionEESSUSD.Value' 'dsDetalle')" },
    @{ Name = "TasaVenta"; Width = "1.00in"; Header = "Tasa URSEA etapa venta al pÃºblico"; SubHeader = ""; Expression = "=Code.ValueByUnit(Fields!TasaURSEAVenta.Value, Fields!TasaURSEAVentaUSD.Value, Parameters!pUnidad.Value, 4)"; Align = "Right"; HideExpr = "=$(New-UnitAwareNonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'Detail' 'TasaVenta') 'Fields!TasaURSEAVenta.Value' 'Fields!TasaURSEAVentaUSD.Value' 'dsDetalle')" },
    @{ Name = "IVAVentaPublico"; Width = "0.95in"; Header = "IVA etapa venta al pÃºblico"; SubHeader = ""; Expression = "=Code.ValueByUnit(Fields!IVAVentaPublico.Value, Fields!IVAVentaPublicoUSD.Value, Parameters!pUnidad.Value, 4)"; Align = "Right"; HideExpr = "=$(New-UnitAwareNonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'Detail' 'IVAVentaPublico') 'Fields!IVAVentaPublico.Value' 'Fields!IVAVentaPublicoUSD.Value' 'dsDetalle')" },
    @{ Name = "PIT"; Width = "1.20in"; Header = "Precio Intermedio Transitorio (PIT) (impuestos incluidos)"; SubHeader = ""; Expression = "=Code.ValueByUnit(Fields!PITImp.Value, Fields!PITImpUSD.Value, Parameters!pUnidad.Value, 2)"; Align = "Right"; HideExpr = "=$(New-UnitAwareNonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'Detail' 'PIT') 'Fields!PITImp.Value' 'Fields!PITImpUSD.Value' 'dsDetalle')" },
    @{ Name = "MargenEnvasado"; Width = "1.00in"; Header = "Margen de envasado"; SubHeader = ""; Expression = "=Code.ValueByUnit(Fields!MargenEnvasado.Value, Fields!MargenEnvasadoUSD.Value, Parameters!pUnidad.Value, 4)"; Align = "Right"; HideExpr = "=$(New-UnitAwareNonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'Detail' 'MargenEnvasado') 'Fields!MargenEnvasado.Value' 'Fields!MargenEnvasadoUSD.Value' 'dsDetalle')" },
    @{ Name = "Margen"; Width = "1.00in"; Header = "Margen de distribuidoras"; SubHeader = ""; Expression = "=Code.ValueByUnit(Fields!MargenDistribucion.Value, Fields!MargenDistribucionUSD.Value, Parameters!pUnidad.Value, 4)"; Align = "Right"; HideExpr = "=$(New-UnitAwareNonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'Detail' 'Margen') 'Fields!MargenDistribucion.Value' 'Fields!MargenDistribucionUSD.Value' 'dsDetalle')" },
    @{ Name = "TasaDist"; Width = "1.00in"; Header = "Tasa URSEA etapa distribuciÃ³n"; SubHeader = ""; Expression = "=Code.ValueByUnit(Fields!TasaURSEADistribucion.Value, Fields!TasaURSEADistribucionUSD.Value, Parameters!pUnidad.Value, 4)"; Align = "Right"; HideExpr = "=$(New-UnitAwareNonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'Detail' 'TasaDist') 'Fields!TasaURSEADistribucion.Value' 'Fields!TasaURSEADistribucionUSD.Value' 'dsDetalle')" },
    @{ Name = "IVADistribucion"; Width = "0.95in"; Header = "IVA etapa distribuciÃ³n"; SubHeader = ""; Expression = "=Code.ValueByUnit(Fields!IVADistribucion.Value, Fields!IVADistribucionUSD.Value, Parameters!pUnidad.Value, 4)"; Align = "Right"; HideExpr = "=$(New-UnitAwareNonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'Detail' 'IVADistribucion') 'Fields!IVADistribucion.Value' 'Fields!IVADistribucionUSD.Value' 'dsDetalle')" },
    @{ Name = "PEPImp"; Width = "1.20in"; Header = "Precio Ex Planta (PEP) (impuestos incluidos)"; SubHeader = ""; Expression = "=Code.ValueByUnit(Fields!PEPImp.Value, Fields!PEPImpUSD.Value, Parameters!pUnidad.Value, 2)"; Align = "Right"; HideExpr = "=$(New-UnitAwareNonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'Detail' 'PEPImp') 'Fields!PEPImp.Value' 'Fields!PEPImpUSD.Value' 'dsDetalle')" },
    @{ Name = "TasaInflamable"; Width = "0.95in"; Header = "Tasa inflamable"; SubHeader = ""; Expression = "=Code.ValueByUnit(Fields!TasaInflamable.Value, Fields!TasaInflamableUSD.Value, Parameters!pUnidad.Value, 4)"; Align = "Right"; HideExpr = "=$(New-UnitAwareNonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'Detail' 'TasaInflamable') 'Fields!TasaInflamable.Value' 'Fields!TasaInflamableUSD.Value' 'dsDetalle')" },
    @{ Name = "Flete"; Width = "0.70in"; Header = "Flete"; SubHeader = ""; Expression = "=Code.ValueByUnit(Fields!Flete.Value, Fields!FleteUSD.Value, Parameters!pUnidad.Value, 4)"; Align = "Right"; HideExpr = "=$(New-UnitAwareNonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'Detail' 'Flete') 'Fields!Flete.Value' 'Fields!FleteUSD.Value' 'dsDetalle')" },
    @{ Name = "TasaSec"; Width = "1.00in"; Header = "Tasa URSEA etapa secundaria"; SubHeader = ""; Expression = "=Code.ValueByUnit(Fields!TasaURSEASecundaria.Value, Fields!TasaURSEASecundariaUSD.Value, Parameters!pUnidad.Value, 4)"; Align = "Right"; HideExpr = "=$(New-UnitAwareNonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'Detail' 'TasaSec') 'Fields!TasaURSEASecundaria.Value' 'Fields!TasaURSEASecundariaUSD.Value' 'dsDetalle')" },
    @{ Name = "IVASec"; Width = "0.85in"; Header = "IVA etapa secundaria"; SubHeader = ""; Expression = "=Code.ValueByUnit(Fields!IVASecundaria.Value, Fields!IVASecundariaUSD.Value, Parameters!pUnidad.Value, 4)"; Align = "Right"; HideExpr = "=$(New-UnitAwareNonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'Detail' 'IVASec') 'Fields!IVASecundaria.Value' 'Fields!IVASecundariaUSD.Value' 'dsDetalle')" },
    @{ Name = "CFS"; Width = "1.35in"; Header = "CompensaciÃ³n BonificaciÃ³n EESS con Fin Social (CFS)"; SubHeader = ""; Expression = "=Code.ValueByUnit(Fields!CompensacionCFS.Value, Fields!CompensacionCFSUSD.Value, Parameters!pUnidad.Value, 4)"; Align = "Right"; HideExpr = "=$(New-UnitAwareNonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'Detail' 'CFS') 'Fields!CompensacionCFS.Value' 'Fields!CompensacionCFSUSD.Value' 'dsDetalle')" },
    @{ Name = "PEPSinFlete"; Width = "1.35in"; Header = "Precio Ex Planta (PEP) sin flete secundario (impuestos incluidos)"; SubHeader = ""; Expression = "=Code.ValueByUnit(Fields!PEPSinFleteImp.Value, Fields!PEPSinFleteImpUSD.Value, Parameters!pUnidad.Value, 2)"; Align = "Right"; HideExpr = "=$(New-UnitAwareNonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'Detail' 'PEPSinFlete') 'Fields!PEPSinFleteImp.Value' 'Fields!PEPSinFleteImpUSD.Value' 'dsDetalle')" },
    @{ Name = "IMESI"; Width = "0.75in"; Header = "IMESI"; SubHeader = ""; Expression = "=Code.ValueByUnit(Fields!IMESI.Value, Fields!IMESIUSD.Value, Parameters!pUnidad.Value, 4)"; Align = "Right"; HideExpr = "=$(New-UnitAwareNonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'Detail' 'IMESI') 'Fields!IMESI.Value' 'Fields!IMESIUSD.Value' 'dsDetalle')" },
    @{ Name = "CO2"; Width = "0.75in"; Header = "Impuesto CO2"; SubHeader = ""; Expression = "=Code.ValueByUnit(Fields!ImpuestoCO2.Value, Fields!ImpuestoCO2USD.Value, Parameters!pUnidad.Value, 4)"; Align = "Right"; HideExpr = "=$(New-UnitAwareNonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'Detail' 'CO2') 'Fields!ImpuestoCO2.Value' 'Fields!ImpuestoCO2USD.Value' 'dsDetalle')" },
    @{ Name = "TasaPrim"; Width = "0.90in"; Header = "Tasa URSEA etapa primaria"; SubHeader = ""; Expression = "=Code.ValueByUnit(Fields!TasaURSEAPrimaria.Value, Fields!TasaURSEAPrimariaUSD.Value, Parameters!pUnidad.Value, 4)"; Align = "Right"; HideExpr = "=$(New-UnitAwareNonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'Detail' 'TasaPrim') 'Fields!TasaURSEAPrimaria.Value' 'Fields!TasaURSEAPrimariaUSD.Value' 'dsDetalle')" },
    @{ Name = "FUDAEE"; Width = "0.75in"; Header = "FUDAEE"; SubHeader = ""; Expression = "=Code.ValueByUnit(Fields!FUDAEE.Value, Fields!FUDAEEUSD.Value, Parameters!pUnidad.Value, 4)"; Align = "Right"; HideExpr = "=$(New-UnitAwareNonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'Detail' 'FUDAEE') 'Fields!FUDAEE.Value' 'Fields!FUDAEEUSD.Value' 'dsDetalle')" },
    @{ Name = "IVAPrimaria"; Width = "0.90in"; Header = "IVA etapa primaria"; SubHeader = ""; Expression = "=Code.ValueByUnit(Fields!IVAPrimaria.Value, Fields!IVAPrimariaUSD.Value, Parameters!pUnidad.Value, 4)"; Align = "Right"; HideExpr = "=$(New-UnitAwareNonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'Detail' 'IVAPrimaria') 'Fields!IVAPrimaria.Value' 'Fields!IVAPrimariaUSD.Value' 'dsDetalle')" },
    @{ Name = "Fideicomiso"; Width = "0.95in"; Header = "Fideicomiso"; SubHeader = ""; Expression = "=Code.ValueByUnit(Fields!Fideicomiso.Value, Fields!FideicomisoUSD.Value, Parameters!pUnidad.Value, 4)"; Align = "Right"; HideExpr = "=$(New-UnitAwareNonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'Detail' 'Fideicomiso') 'Fields!Fideicomiso.Value' 'Fields!FideicomisoUSD.Value' 'dsDetalle')" },
    @{ Name = "PEP"; Width = "0.95in"; Header = "Precio Ex Planta (PEP)"; SubHeader = ""; Expression = "=Code.ValueByUnit(Fields!PEP.Value, Fields!PEPUSD.Value, Parameters!pUnidad.Value, 2)"; Align = "Right"; HideExpr = "=$(New-UnitAwareNonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'Detail' 'PEP') 'Fields!PEP.Value' 'Fields!PEPUSD.Value' 'dsDetalle')" },
    @{ Name = "Factor"; Width = "0.85in"; Header = "Factor de ajuste"; SubHeader = ""; Expression = "=Code.ValueByUnit(Fields!FactorAjuste.Value, Fields!FactorAjusteUSD.Value, Parameters!pUnidad.Value, 2)"; Align = "Right"; HideExpr = "=$(New-UnitAwareNonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'Detail' 'Factor') 'Fields!FactorAjuste.Value' 'Fields!FactorAjusteUSD.Value' 'dsDetalle')" },
    @{ Name = "Ursea"; Width = "1.10in"; Header = "PPI sin tasas e impuestos"; SubHeader = ""; Expression = "=Code.ValueByUnit(Fields!PEPCalcUrsea.Value, Fields!PEPCalcUrseaUSD.Value, Parameters!pUnidad.Value, 2)"; Align = "Right"; HideExpr = "=$(New-UnitAwareNonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'Detail' 'Ursea') 'Fields!PEPCalcUrsea.Value' 'Fields!PEPCalcUrseaUSD.Value' 'dsDetalle')" },
    @{ Name = "MontoDiferencial"; Width = "1.35in"; Header = "Monto diferencial por zonas ""d"""; SubHeader = ""; Expression = "=Code.ValueByUnit(Fields!MontoDiferencialZonasD.Value, Fields!MontoDiferencialZonasDUSD.Value, Parameters!pUnidad.Value, 2)"; Align = "Right"; HideExpr = "=$(New-UnitAwareNonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'Detail' 'MontoDiferencial') 'Fields!MontoDiferencialZonasD.Value' 'Fields!MontoDiferencialZonasDUSD.Value' 'dsDetalle')" },
    @{ Name = "PPIN1"; Width = "1.00in"; Header = "PPI n-1 Periodo URSEA"; SubHeader = ""; Expression = "=Code.ValueByUnit(Fields!PPIN1.Value, Fields!PPIN1USD.Value, Parameters!pUnidad.Value, 2)"; Align = "Right"; HideExpr = "=$(New-UnitAwareNonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'Detail' 'PPIN1') 'Fields!PPIN1.Value' 'Fields!PPIN1USD.Value' 'dsDetalle')" },
    @{ Name = "PPIN2"; Width = "1.00in"; Header = "PPI n-2 Periodo URSEA"; SubHeader = ""; Expression = "=Code.ValueByUnit(Fields!PPIN2.Value, Fields!PPIN2USD.Value, Parameters!pUnidad.Value, 2)"; Align = "Right"; HideExpr = "=$(New-UnitAwareNonZeroColumnHiddenExpr (New-ColumnAllowanceExpr 'Detail' 'PPIN2') 'Fields!PPIN2.Value' 'Fields!PPIN2USD.Value' 'dsDetalle')" }
)

$tablixSummaryUsd = New-StaticTablix -Name "tablixSummaryUSD" -DataSetName "dsResumen" -Left "0.05in" -Top "1.95in" -Columns $summaryUsdColumns -HiddenExpr '=Code.NormalizeUnit(Parameters!pUnidad.Value) <> "USD/m3" Or Code.ShouldUseUsdTm1Summary(Parameters!pProducto.Value, Parameters!pAnio.Value)' -NoRowsMessage ""
$tablixSummaryUsdTm1 = New-StaticTablix -Name "tablixSummaryUSDTM1" -DataSetName "dsResumenLocal" -Left "0.80in" -Top "1.85in" -Columns $summaryUsdTm1Columns -HiddenExpr '=Code.NormalizeUnit(Parameters!pUnidad.Value) <> "USD/m3" Or Not Code.ShouldUseUsdTm1Summary(Parameters!pProducto.Value, Parameters!pAnio.Value) Or CountRows("dsResumenLocal") = 0' -NoRowsMessage ""
$tablixSummaryLocal = New-StaticTablix -Name "tablixSummaryLocal" -DataSetName "dsResumenLocal" -Left "4.20in" -Top "1.70in" -Columns $summaryLocalColumns -HiddenExpr '=Code.NormalizeUnit(Parameters!pUnidad.Value) = "USD/m3" Or Not Code.ShouldUseLocalTm1Summary(Parameters!pProducto.Value, Parameters!pAnio.Value) Or CountRows("dsResumenLocal") = 0' -NoRowsMessage ""
$tablixSummaryLocalMain = New-StaticTablix -Name "tablixSummaryLocalMain" -DataSetName "dsResumen" -Left "6.05in" -Top "3.75in" -Columns $summaryLocalMainColumns -HiddenExpr '=Code.NormalizeUnit(Parameters!pUnidad.Value) = "USD/m3" Or Not Code.ShouldUseLocalMainSummary(Parameters!pProducto.Value, Parameters!pAnio.Value) Or CountRows("dsResumen") = 0' -NoRowsMessage ""
$tablixDetailUsd = New-StaticTablix -Name "tablixDetailUSD" -DataSetName "dsDetalle" -Left "0.05in" -Top "1.95in" -Columns $detailColumns -HiddenExpr '=Code.NormalizeUnit(Parameters!pUnidad.Value) <> "USD/m3"'
$tablixDetailLocal = New-StaticTablix -Name "tablixDetailLocal" -DataSetName "dsDetalle" -Left "0.05in" -Top "1.95in" -Columns $detailColumns -HiddenExpr '=Code.NormalizeUnit(Parameters!pUnidad.Value) = "USD/m3"'

$bodyFragment = Fix-GeneratedText @"
<Body>
  <ReportItems>
    <Rectangle Name="BodyCanvas">
      <ReportItems>
        <Rectangle Name="rectSummarySection"><ReportItems><Textbox Name="txtTabResumen"><CanGrow>true</CanGrow><KeepTogether>true</KeepTogether><Bookmark>bookmarkSummaryView</Bookmark><Paragraphs><Paragraph><TextRuns><TextRun><Value>Resumen</Value><Style><FontSize>9pt</FontSize></Style></TextRun></TextRuns><Style><TextAlign>Center</TextAlign></Style></Paragraph></Paragraphs><Top>0in</Top><Left>0.02in</Left><Height>0.32in</Height><Width>0.82in</Width><Style><Border><Color>Silver</Color><Style>Solid</Style></Border><BackgroundColor>White</BackgroundColor><VerticalAlign>Middle</VerticalAlign><PaddingLeft>4pt</PaddingLeft><PaddingRight>4pt</PaddingRight><PaddingTop>4pt</PaddingTop><PaddingBottom>4pt</PaddingBottom></Style></Textbox><Textbox Name="txtTabDetalle"><CanGrow>true</CanGrow><KeepTogether>true</KeepTogether><Paragraphs><Paragraph><TextRuns><TextRun><Value>Detalle</Value><Style><FontSize>9pt</FontSize></Style></TextRun></TextRuns><Style><TextAlign>Center</TextAlign></Style></Paragraph></Paragraphs><ActionInfo><Actions><Action><BookmarkLink>bookmarkDetailView</BookmarkLink></Action></Actions></ActionInfo><Top>0in</Top><Left>0.84in</Left><Height>0.32in</Height><Width>0.82in</Width><Style><Border><Color>Silver</Color><Style>Solid</Style></Border><BackgroundColor>#EFEFEF</BackgroundColor><VerticalAlign>Middle</VerticalAlign><PaddingLeft>4pt</PaddingLeft><PaddingRight>4pt</PaddingRight><PaddingTop>4pt</PaddingTop><PaddingBottom>4pt</PaddingBottom></Style></Textbox><Rectangle Name="rectBodyHeaderSummary"><ReportItems><Textbox Name="txtBodyTituloSummary"><CanGrow>true</CanGrow><KeepTogether>true</KeepTogether><Paragraphs><Paragraph><TextRuns><TextRun><Value>Precios Unitarios Ex Planta</Value><Style><Color>White</Color><FontSize>16pt</FontSize><FontWeight>Bold</FontWeight></Style></TextRun></TextRuns><Style><TextAlign>Center</TextAlign></Style></Paragraph></Paragraphs><Top>0.05in</Top><Left>0in</Left><Height>0.25in</Height><Width>19.50in</Width><Style><Border><Style>None</Style></Border><BackgroundColor>#1B345D</BackgroundColor></Style></Textbox><Textbox Name="txtBodySubtituloSummary"><CanGrow>true</CanGrow><KeepTogether>true</KeepTogether><Paragraphs><Paragraph><TextRuns><TextRun><Value>=Code.NormalizeProduct(Parameters!pProducto.Value) &amp; " - " &amp; Parameters!pAnio.Value</Value><Style><Color>White</Color><FontSize>15pt</FontSize><FontWeight>Bold</FontWeight></Style></TextRun></TextRuns><Style><TextAlign>Center</TextAlign></Style></Paragraph></Paragraphs><Top>0.32in</Top><Left>0in</Left><Height>0.25in</Height><Width>19.50in</Width><Style><Border><Style>None</Style></Border><BackgroundColor>#1B345D</BackgroundColor></Style></Textbox><Image Name="imgBodyLogoSummary"><Source>Embedded</Source><Value>imgAncapLogo</Value><Sizing>FitProportional</Sizing><Top>0.09in</Top><Left>17.65in</Left><Height>0.42in</Height><Width>1.40in</Width><Style><Border><Style>None</Style></Border></Style></Image></ReportItems><Top>0.40in</Top><Left>0in</Left><Height>0.78in</Height><Width>19.50in</Width><Style><Border><Color>#F3C23C</Color><Style>Solid</Style></Border><BackgroundColor>#1B345D</BackgroundColor></Style></Rectangle>$tablixSummaryUsd$tablixSummaryUsdTm1$tablixSummaryLocal$tablixSummaryLocalMain<Textbox Name="txtNotaResumen"><CanGrow>true</CanGrow><KeepTogether>true</KeepTogether><Paragraphs><Paragraph><TextRuns><TextRun><Value>=First(Fields!Texto.Value, "dsTexto")</Value><Style><FontSize>8pt</FontSize></Style></TextRun></TextRuns><Style><TextAlign>Right</TextAlign></Style></Paragraph></Paragraphs><Visibility><Hidden>=Trim(First(Fields!Texto.Value, "dsTexto")) = ""</Hidden></Visibility><Top>5.92in</Top><Left>15.20in</Left><Height>0.28in</Height><Width>4.00in</Width><Style><Border><Style>None</Style></Border></Style></Textbox><Textbox Name="txtReferenteResumen"><CanGrow>true</CanGrow><KeepTogether>true</KeepTogether><Paragraphs><Paragraph><TextRuns><TextRun><Value>Referentes: Jefe Ventas Combustibles y Lubricantes</Value><Style><FontSize>9pt</FontSize></Style></TextRun></TextRuns></Paragraph></Paragraphs><Top>6.45in</Top><Left>0.25in</Left><Height>0.25in</Height><Width>5.00in</Width><Style><Border><Style>None</Style></Border></Style></Textbox></ReportItems><Top>0in</Top><Left>0in</Left><Height>6.90in</Height><Width>19.50in</Width><Style><Border><Style>None</Style></Border></Style></Rectangle>
        <Rectangle Name="rectDetailSection"><ReportItems><Textbox Name="txtTabResumenDetalle"><CanGrow>true</CanGrow><KeepTogether>true</KeepTogether><Paragraphs><Paragraph><TextRuns><TextRun><Value>Resumen</Value><Style><FontSize>9pt</FontSize></Style></TextRun></TextRuns><Style><TextAlign>Center</TextAlign></Style></Paragraph></Paragraphs><ActionInfo><Actions><Action><BookmarkLink>bookmarkSummaryView</BookmarkLink></Action></Actions></ActionInfo><Top>0in</Top><Left>0.02in</Left><Height>0.32in</Height><Width>0.82in</Width><Style><Border><Color>Silver</Color><Style>Solid</Style></Border><BackgroundColor>#EFEFEF</BackgroundColor><VerticalAlign>Middle</VerticalAlign><PaddingLeft>4pt</PaddingLeft><PaddingRight>4pt</PaddingRight><PaddingTop>4pt</PaddingTop><PaddingBottom>4pt</PaddingBottom></Style></Textbox><Textbox Name="txtTabDetalleDetalle"><CanGrow>true</CanGrow><KeepTogether>true</KeepTogether><Bookmark>bookmarkDetailView</Bookmark><Paragraphs><Paragraph><TextRuns><TextRun><Value>Detalle</Value><Style><FontSize>9pt</FontSize></Style></TextRun></TextRuns><Style><TextAlign>Center</TextAlign></Style></Paragraph></Paragraphs><Top>0in</Top><Left>0.84in</Left><Height>0.32in</Height><Width>0.82in</Width><Style><Border><Color>Silver</Color><Style>Solid</Style></Border><BackgroundColor>White</BackgroundColor><VerticalAlign>Middle</VerticalAlign><PaddingLeft>4pt</PaddingLeft><PaddingRight>4pt</PaddingRight><PaddingTop>4pt</PaddingTop><PaddingBottom>4pt</PaddingBottom></Style></Textbox><Rectangle Name="rectBodyHeaderDetalle"><ReportItems><Textbox Name="txtBodyTituloDetalle"><CanGrow>true</CanGrow><KeepTogether>true</KeepTogether><Paragraphs><Paragraph><TextRuns><TextRun><Value>Precios Unitarios Ex Planta</Value><Style><Color>White</Color><FontSize>16pt</FontSize><FontWeight>Bold</FontWeight></Style></TextRun></TextRuns><Style><TextAlign>Center</TextAlign></Style></Paragraph></Paragraphs><Top>0.05in</Top><Left>0in</Left><Height>0.25in</Height><Width>19.50in</Width><Style><Border><Style>None</Style></Border><BackgroundColor>#1B345D</BackgroundColor></Style></Textbox><Textbox Name="txtBodySubtituloDetalle"><CanGrow>true</CanGrow><KeepTogether>true</KeepTogether><Paragraphs><Paragraph><TextRuns><TextRun><Value>=Code.NormalizeProduct(Parameters!pProducto.Value) &amp; " - " &amp; Parameters!pAnio.Value</Value><Style><Color>White</Color><FontSize>15pt</FontSize><FontWeight>Bold</FontWeight></Style></TextRun></TextRuns><Style><TextAlign>Center</TextAlign></Style></Paragraph></Paragraphs><Top>0.32in</Top><Left>0in</Left><Height>0.25in</Height><Width>19.50in</Width><Style><Border><Style>None</Style></Border><BackgroundColor>#1B345D</BackgroundColor></Style></Textbox><Image Name="imgBodyLogoDetalle"><Source>Embedded</Source><Value>imgAncapLogo</Value><Sizing>FitProportional</Sizing><Top>0.09in</Top><Left>17.65in</Left><Height>0.42in</Height><Width>1.40in</Width><Style><Border><Style>None</Style></Border></Style></Image></ReportItems><Top>0.40in</Top><Left>0in</Left><Height>0.78in</Height><Width>19.50in</Width><Style><Border><Color>#F3C23C</Color><Style>Solid</Style></Border><BackgroundColor>#1B345D</BackgroundColor></Style></Rectangle>$tablixDetailUsd$tablixDetailLocal<Textbox Name="txtEmptyState"><CanGrow>true</CanGrow><KeepTogether>true</KeepTogether><Paragraphs><Paragraph><TextRuns><TextRun><Value>No hay datos disponibles</Value><Style><FontSize>11pt</FontSize></Style></TextRun></TextRuns><Style><TextAlign>Center</TextAlign></Style></Paragraph></Paragraphs><Visibility><Hidden>=CountRows("dsDetalle") &gt; 0</Hidden></Visibility><Top>2.10in</Top><Left>7.20in</Left><Height>0.25in</Height><Width>5.00in</Width><Style><Border><Style>None</Style></Border></Style></Textbox><Textbox Name="txtReferenteDetalle"><CanGrow>true</CanGrow><KeepTogether>true</KeepTogether><Paragraphs><Paragraph><TextRuns><TextRun><Value>Referentes: Jefe Ventas Combustibles y Lubricantes</Value><Style><FontSize>9pt</FontSize></Style></TextRun></TextRuns></Paragraph></Paragraphs><Top>6.45in</Top><Left>0.25in</Left><Height>0.25in</Height><Width>5.00in</Width><Style><Border><Style>None</Style></Border></Style></Textbox></ReportItems><Top>6.95in</Top><Left>0in</Left><Height>6.90in</Height><Width>19.50in</Width><PageBreak><BreakLocation>Start</BreakLocation></PageBreak><Style><Border><Style>None</Style></Border></Style></Rectangle>
      </ReportItems>
      <Top>0in</Top><Left>0in</Left><Height>13.85in</Height><Width>19.50in</Width><Style><Border><Style>None</Style></Border></Style>
    </Rectangle>
  </ReportItems>
  <Height>13.85in</Height>
  <Style />
</Body>
"@

$reportParametersFragment = Fix-GeneratedText @"
<ReportParameters>
  <ReportParameter Name="pAnio"><DataType>Integer</DataType><DefaultValue><Values><Value>=Year(Today())</Value></Values></DefaultValue><Prompt>Seleccionar Año:</Prompt><ValidValues><DataSetReference><DataSetName>dsAnio</DataSetName><ValueField>Anio</ValueField><LabelField>Anio</LabelField></DataSetReference></ValidValues></ReportParameter>
  <ReportParameter Name="pProducto"><DataType>String</DataType><Prompt>Producto:</Prompt><ValidValues><DataSetReference><DataSetName>dsProducto</DataSetName><ValueField>Producto</ValueField><LabelField>Producto</LabelField></DataSetReference></ValidValues></ReportParameter>
  <ReportParameter Name="pUnidad"><DataType>String</DataType><DefaultValue><Values><Value>USD/m3</Value></Values></DefaultValue><Prompt>Unidad:</Prompt><ValidValues><ParameterValues><ParameterValue><Value>USD/m3</Value><Label>USD/m3</Label></ParameterValue><ParameterValue><Value>$/lt Ã³ $/kg segÃºn corresponda</Value><Label>$/lt Ã³ $/kg segÃºn corresponda</Label></ParameterValue></ParameterValues></ValidValues></ReportParameter>
  <ReportParameter Name="pVista"><DataType>String</DataType><DefaultValue><Values><Value>Resumen</Value></Values></DefaultValue><Hidden>true</Hidden></ReportParameter>
</ReportParameters>
"@

$reportParametersLayoutFragment = @"
<ReportParametersLayout><GridLayoutDefinition><NumberOfColumns>4</NumberOfColumns><NumberOfRows>1</NumberOfRows><CellDefinitions><CellDefinition><ColumnIndex>0</ColumnIndex><RowIndex>0</RowIndex><ParameterName>pAnio</ParameterName></CellDefinition><CellDefinition><ColumnIndex>1</ColumnIndex><RowIndex>0</RowIndex><ParameterName>pProducto</ParameterName></CellDefinition><CellDefinition><ColumnIndex>2</ColumnIndex><RowIndex>0</RowIndex><ParameterName>pUnidad</ParameterName></CellDefinition><CellDefinition><ColumnIndex>3</ColumnIndex><RowIndex>0</RowIndex><ParameterName>pVista</ParameterName></CellDefinition></CellDefinitions></GridLayoutDefinition></ReportParametersLayout>
"@

$dataSetsFragment = Fix-GeneratedText @"
<DataSets>
  <DataSet Name="dsAnio">
    <Query>
      <DataSourceName>BI_DatosPrioritarios</DataSourceName>
      <CommandText>$(Xml-Escape @'
EVALUATE
VAR __Anios =
    ADDCOLUMNS(
        DISTINCT('Precios_ExPLanta_2_TM1'[Años]),
        "AnioNum", IFERROR(VALUE('Precios_ExPLanta_2_TM1'[Años]), BLANK())
    )
RETURN
SELECTCOLUMNS(
    FILTER(__Anios, NOT ISBLANK([AnioNum]) && [AnioNum] <= YEAR(TODAY())),
    "Anio", [AnioNum]
)
ORDER BY [Anio] DESC
'@)</CommandText>
    </Query>
    <Fields>
      <Field Name="Anio"><rd:TypeName>System.Int32</rd:TypeName><DataField>[Anio]</DataField></Field>
    </Fields>
  </DataSet>
  <DataSet Name="dsProducto">
    <Query>
      <DataSourceName>BI_DatosPrioritarios</DataSourceName>
      <CommandText>$(Xml-Escape @'
EVALUATE
VAR __ProductosTM1 =
    SELECTCOLUMNS(
        FILTER(
            DISTINCT('Precios_ExPLanta_2_TM1'[Productos_ExPlanta]),
            NOT ISBLANK('Precios_ExPLanta_2_TM1'[Productos_ExPlanta]) &&
            'Precios_ExPLanta_2_TM1'[Productos_ExPlanta] <> "Año Base" &&
            LEFT('Precios_ExPLanta_2_TM1'[Productos_ExPlanta], 4) <> "RPMS"
        ),
        "Producto",
        SWITCH(
            'Precios_ExPLanta_2_TM1'[Productos_ExPlanta],
            "Asfalto AC-20", "Asfalto AC-30",
            "Super 95 Sp", "Gasolina Super 95",
            "Premium 97 Sp", "Gasolina Premium 97",
            "Gasolina Av 100 Octa", "Gasolina Av 100 Octanos",
            "Gasoil Comun", "Gasoil 50-S",
            "Gasoil Especial", "Gasoil 10-S",
            "Propano", "Propano Industrial",
            'Precios_ExPLanta_2_TM1'[Productos_ExPlanta]
        )
    )
VAR __ProductosPlanilla =
    SELECTCOLUMNS(
        FILTER(
            DISTINCT('Precios_Ex_Planta'[Producto]),
            NOT ISBLANK('Precios_Ex_Planta'[Producto]) &&
            'Precios_Ex_Planta'[Producto] <> "N/A"
        ),
        "Producto",
        SWITCH(
            'Precios_Ex_Planta'[Producto],
            "GLP", "Supergas",
            "Asfalto AC-20", "Asfalto AC-30",
            "Super 95 Sp", "Gasolina Super 95",
            "Premium 97 Sp", "Gasolina Premium 97",
            "Gasolina Av 100 Octa", "Gasolina Av 100 Octanos",
            "Gasoil Comun", "Gasoil 50-S",
            "Gasoil Especial", "Gasoil 10-S",
            "Propano", "Propano Industrial",
            'Precios_Ex_Planta'[Producto]
        )
    )
VAR __ProductosPadre =
    DATATABLE(
        "Producto", STRING,
        {
            { "Gasolina Super 95" },
            { "Gasolina Premium 97" },
            { "Queroseno Montevideo" },
            { "Queroseno Interior" },
            { "Gasoil 50-S" },
            { "Gasoil 10-S" },
            { "Gasolina Av 100 Octanos" },
            { "Jet A1" },
            { "Supergas" },
            { "Supergas A Granel" },
            { "Butano Desodorizado" },
            { "Propano Industrial" },
            { "Propano Redes" },
            { "Fuel Oil Pesado" },
            { "Fuel Oil Medio" },
            { "Solvente 1197" },
            { "Disan" },
            { "Base insecticida" },
            { "Aguarras" },
            { "Querosol" },
            { "Hexano Comercial" },
            { "Asfalto AC-30" },
            { "Asfalto 150/200" },
            { "Asfalto MC1" },
            { "Asfalto RC2" }
        }
    )
RETURN
DISTINCT(
    UNION(__ProductosTM1, __ProductosPlanilla, __ProductosPadre)
)
ORDER BY [Producto]
'@)</CommandText>
    </Query>
    <Fields>
      <Field Name="Producto"><rd:TypeName>System.String</rd:TypeName><DataField>[Producto]</DataField></Field>
    </Fields>
  </DataSet>
  <DataSet Name="dsTexto">
    <Query>
      <DataSourceName>BI_DatosPrioritarios</DataSourceName>
      <CommandText>$(Xml-Escape @'
EVALUATE
ROW(
    "Texto",
    "Los Precios Ex planta surgen de deducirle a los Precios de venta al PÃºblico, los costos unitarios de flete, tasas, mÃ¡rgenes, bonificaciones e impuestos que correspondieran, como se observa al ingresar a cada producto."
    & UNICHAR(10) &
    "La Tasa inflamable fue derogada a partir del 13 de agosto de 2023."
    & UNICHAR(10) &
    "Para los productos cuyas paridades de importaciÃ³n publica URSEA, la diferencia entre los Precios ex planta calculados de esta manera y el Precio ex planta calculado por URSEA, es el Factor de Ajuste."
)
'@)</CommandText>
    </Query>
    <Fields>
      <Field Name="Texto"><rd:TypeName>System.String</rd:TypeName><DataField>[Texto]</DataField></Field>
    </Fields>
  </DataSet>
  <DataSet Name="dsResumen">
    <Query>
      <DataSourceName>BI_DatosPrioritarios</DataSourceName>
      <CommandText>$(Xml-Escape $allDataQuery)</CommandText>
    </Query>
    <Filters>
      <Filter>
        <FilterExpression>=Fields!Anio.Value</FilterExpression>
        <Operator>Equal</Operator>
        <FilterValues><FilterValue>=Parameters!pAnio.Value</FilterValue></FilterValues>
      </Filter>
      <Filter>
        <FilterExpression>=Code.NormalizeProduct(Fields!Producto.Value)</FilterExpression>
        <Operator>Equal</Operator>
        <FilterValues><FilterValue>=Code.NormalizeProduct(Parameters!pProducto.Value)</FilterValue></FilterValues>
      </Filter>
    </Filters>
    <Fields>
      <Field Name="Anio"><rd:TypeName>System.Int32</rd:TypeName><DataField>[Anio]</DataField></Field>
      <Field Name="MesNumero"><rd:TypeName>System.Int32</rd:TypeName><DataField>[MesNumero]</DataField></Field>
      <Field Name="SortKey"><rd:TypeName>System.Int32</rd:TypeName><DataField>[SortKey]</DataField></Field>
      <Field Name="Dia"><rd:TypeName>System.String</rd:TypeName><DataField>[Dia]</DataField></Field>
      <Field Name="Producto"><rd:TypeName>System.String</rd:TypeName><DataField>[Producto]</DataField></Field>
      <Field Name="Unidad2"><rd:TypeName>System.String</rd:TypeName><DataField>[Unidad2]</DataField></Field>
      <Field Name="TC"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[TC]</DataField></Field>
      <Field Name="PrecioPublico"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PrecioPublico]</DataField></Field>
      <Field Name="PrecioExonerado"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PrecioExonerado]</DataField></Field>
      <Field Name="IVA"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[IVA]</DataField></Field>
      <Field Name="PrecioSinIVA"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PrecioSinIVA]</DataField></Field>
      <Field Name="PVPImp"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PVPImp]</DataField></Field>
      <Field Name="PITImp"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PITImp]</DataField></Field>
      <Field Name="PEPImp"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PEPImp]</DataField></Field>
      <Field Name="PEPSinFleteImp"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PEPSinFleteImp]</DataField></Field>
      <Field Name="PEP"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PEP]</DataField></Field>
      <Field Name="FactorAjuste"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[FactorAjuste]</DataField></Field>
      <Field Name="PEPCalcUrsea"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PEPCalcUrsea]</DataField></Field>
      <Field Name="MontoDiferencialZonasD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[MontoDiferencialZonasD]</DataField></Field>
      <Field Name="PPIN1"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PPIN1]</DataField></Field>
      <Field Name="PPIN2"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PPIN2]</DataField></Field>
      <Field Name="TasaInflamable"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[TasaInflamable]</DataField></Field>
      <Field Name="PVPImpUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PVPImpUSD]</DataField></Field>
      <Field Name="PITImpUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PITImpUSD]</DataField></Field>
      <Field Name="PEPImpUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PEPImpUSD]</DataField></Field>
      <Field Name="PEPSinFleteImpUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PEPSinFleteImpUSD]</DataField></Field>
      <Field Name="PEPUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PEPUSD]</DataField></Field>
      <Field Name="FactorAjusteUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[FactorAjusteUSD]</DataField></Field>
      <Field Name="PEPCalcUrseaUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PEPCalcUrseaUSD]</DataField></Field>
      <Field Name="MontoDiferencialZonasDUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[MontoDiferencialZonasDUSD]</DataField></Field>
      <Field Name="PPIN1USD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PPIN1USD]</DataField></Field>
      <Field Name="PPIN2USD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PPIN2USD]</DataField></Field>
      <Field Name="TasaInflamableUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[TasaInflamableUSD]</DataField></Field>
      <Field Name="MargenGLPEnvasado"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[MargenGLPEnvasado]</DataField></Field>
      <Field Name="BonificacionEESS"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[BonificacionEESS]</DataField></Field>
      <Field Name="TasaURSEAVenta"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[TasaURSEAVenta]</DataField></Field>
      <Field Name="IVAVentaPublico"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[IVAVentaPublico]</DataField></Field>
      <Field Name="MargenEnvasado"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[MargenEnvasado]</DataField></Field>
      <Field Name="MargenDistribucion"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[MargenDistribucion]</DataField></Field>
      <Field Name="TasaURSEADistribucion"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[TasaURSEADistribucion]</DataField></Field>
      <Field Name="IVADistribucion"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[IVADistribucion]</DataField></Field>
      <Field Name="Flete"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[Flete]</DataField></Field>
      <Field Name="TasaURSEASecundaria"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[TasaURSEASecundaria]</DataField></Field>
      <Field Name="IVASecundaria"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[IVASecundaria]</DataField></Field>
      <Field Name="CompensacionCFS"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[CompensacionCFS]</DataField></Field>
      <Field Name="IMESI"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[IMESI]</DataField></Field>
      <Field Name="ImpuestoCO2"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[ImpuestoCO2]</DataField></Field>
      <Field Name="TasaURSEAPrimaria"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[TasaURSEAPrimaria]</DataField></Field>
      <Field Name="FUDAEE"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[FUDAEE]</DataField></Field>
      <Field Name="IVAPrimaria"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[IVAPrimaria]</DataField></Field>
      <Field Name="Fideicomiso"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[Fideicomiso]</DataField></Field>
      <Field Name="MargenGLPEnvasadoUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[MargenGLPEnvasadoUSD]</DataField></Field>
      <Field Name="BonificacionEESSUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[BonificacionEESSUSD]</DataField></Field>
      <Field Name="TasaURSEAVentaUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[TasaURSEAVentaUSD]</DataField></Field>
      <Field Name="IVAVentaPublicoUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[IVAVentaPublicoUSD]</DataField></Field>
      <Field Name="MargenEnvasadoUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[MargenEnvasadoUSD]</DataField></Field>
      <Field Name="MargenDistribucionUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[MargenDistribucionUSD]</DataField></Field>
      <Field Name="TasaURSEADistribucionUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[TasaURSEADistribucionUSD]</DataField></Field>
      <Field Name="IVADistribucionUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[IVADistribucionUSD]</DataField></Field>
      <Field Name="FleteUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[FleteUSD]</DataField></Field>
      <Field Name="TasaURSEASecundariaUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[TasaURSEASecundariaUSD]</DataField></Field>
      <Field Name="IVASecundariaUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[IVASecundariaUSD]</DataField></Field>
      <Field Name="CompensacionCFSUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[CompensacionCFSUSD]</DataField></Field>
      <Field Name="IMESIUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[IMESIUSD]</DataField></Field>
      <Field Name="ImpuestoCO2USD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[ImpuestoCO2USD]</DataField></Field>
      <Field Name="TasaURSEAPrimariaUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[TasaURSEAPrimariaUSD]</DataField></Field>
      <Field Name="FUDAEEUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[FUDAEEUSD]</DataField></Field>
      <Field Name="IVAPrimariaUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[IVAPrimariaUSD]</DataField></Field>
      <Field Name="FideicomisoUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[FideicomisoUSD]</DataField></Field>
    </Fields>
  </DataSet>
  <DataSet Name="dsResumenLocal">
    <Query>
      <DataSourceName>BI_DatosPrioritarios</DataSourceName>
      <CommandText>$(Xml-Escape $summaryLocalQuery)</CommandText>
    </Query>
    <Filters>
      <Filter>
        <FilterExpression>=Fields!Anio.Value</FilterExpression>
        <Operator>Equal</Operator>
        <FilterValues><FilterValue>=Parameters!pAnio.Value</FilterValue></FilterValues>
      </Filter>
      <Filter>
        <FilterExpression>=Code.NormalizeProduct(Fields!Producto.Value)</FilterExpression>
        <Operator>Equal</Operator>
        <FilterValues><FilterValue>=Code.NormalizeProduct(Parameters!pProducto.Value)</FilterValue></FilterValues>
      </Filter>
    </Filters>
    <Fields>
      <Field Name="Anio"><rd:TypeName>System.Int32</rd:TypeName><DataField>[Anio]</DataField></Field>
      <Field Name="MesNumero"><rd:TypeName>System.Int32</rd:TypeName><DataField>[MesNumero]</DataField></Field>
      <Field Name="SortKey"><rd:TypeName>System.Int32</rd:TypeName><DataField>[SortKey]</DataField></Field>
      <Field Name="Dia"><rd:TypeName>System.String</rd:TypeName><DataField>[Dia]</DataField></Field>
      <Field Name="Producto"><rd:TypeName>System.String</rd:TypeName><DataField>[Producto]</DataField></Field>
      <Field Name="PrecioPublico"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PrecioPublico]</DataField></Field>
      <Field Name="PrecioPublicoUSDTM1"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PrecioPublicoUSDTM1]</DataField></Field>
      <Field Name="PrecioExonerado"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PrecioExonerado]</DataField></Field>
      <Field Name="PrecioExoneradoUSDTM1"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PrecioExoneradoUSDTM1]</DataField></Field>
      <Field Name="IVA"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[IVA]</DataField></Field>
      <Field Name="PrecioSinIVA"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PrecioSinIVA]</DataField></Field>
      <Field Name="PrecioSinIVAUSDTM1"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PrecioSinIVAUSDTM1]</DataField></Field>
      <Field Name="IMESI"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[IMESI]</DataField></Field>
      <Field Name="CotizacionPromedio"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[CotizacionPromedio]</DataField></Field>
      <Field Name="Cotizacion"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[Cotizacion]</DataField></Field>
      <Field Name="PrecioSinImpuesto"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PrecioSinImpuesto]</DataField></Field>
      <Field Name="PrecioSinImpuestoUSDTM1"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PrecioSinImpuestoUSDTM1]</DataField></Field>
      <Field Name="UnidadTM1"><rd:TypeName>System.String</rd:TypeName><DataField>[UnidadTM1]</DataField></Field>
      <Field Name="MargenBonificaciones"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[MargenBonificaciones]</DataField></Field>
      <Field Name="TasaInflamable"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[TasaInflamable]</DataField></Field>
      <Field Name="TasaURSEA"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[TasaURSEA]</DataField></Field>
      <Field Name="FideicomisoTM1"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[FideicomisoTM1]</DataField></Field>
      <Field Name="FleteTM1"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[FleteTM1]</DataField></Field>
      <Field Name="PrecioExPlantaTM1"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PrecioExPlantaTM1]</DataField></Field>
      <Field Name="PrecioExPlantaUSDTM1"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PrecioExPlantaUSDTM1]</DataField></Field>
      <Field Name="DensidadTM1"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[DensidadTM1]</DataField></Field>
    </Fields>
  </DataSet>
  <DataSet Name="dsDetalle">
    <Query>
      <DataSourceName>BI_DatosPrioritarios</DataSourceName>
      <CommandText>$(Xml-Escape $allDataQuery)</CommandText>
    </Query>
    <Filters>
      <Filter>
        <FilterExpression>=Fields!Anio.Value</FilterExpression>
        <Operator>Equal</Operator>
        <FilterValues><FilterValue>=Parameters!pAnio.Value</FilterValue></FilterValues>
      </Filter>
      <Filter>
        <FilterExpression>=Code.NormalizeProduct(Fields!Producto.Value)</FilterExpression>
        <Operator>Equal</Operator>
        <FilterValues><FilterValue>=Code.NormalizeProduct(Parameters!pProducto.Value)</FilterValue></FilterValues>
      </Filter>
    </Filters>
    <Fields>
      <Field Name="Anio"><rd:TypeName>System.Int32</rd:TypeName><DataField>[Anio]</DataField></Field>
      <Field Name="MesNumero"><rd:TypeName>System.Int32</rd:TypeName><DataField>[MesNumero]</DataField></Field>
      <Field Name="SortKey"><rd:TypeName>System.Int32</rd:TypeName><DataField>[SortKey]</DataField></Field>
      <Field Name="Dia"><rd:TypeName>System.String</rd:TypeName><DataField>[Dia]</DataField></Field>
      <Field Name="Producto"><rd:TypeName>System.String</rd:TypeName><DataField>[Producto]</DataField></Field>
      <Field Name="Unidad2"><rd:TypeName>System.String</rd:TypeName><DataField>[Unidad2]</DataField></Field>
      <Field Name="TC"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[TC]</DataField></Field>
      <Field Name="PVPImp"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PVPImp]</DataField></Field>
      <Field Name="PITImp"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PITImp]</DataField></Field>
      <Field Name="PEPImp"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PEPImp]</DataField></Field>
      <Field Name="PEPSinFleteImp"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PEPSinFleteImp]</DataField></Field>
      <Field Name="PEP"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PEP]</DataField></Field>
      <Field Name="FactorAjuste"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[FactorAjuste]</DataField></Field>
      <Field Name="PEPCalcUrsea"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PEPCalcUrsea]</DataField></Field>
      <Field Name="MontoDiferencialZonasD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[MontoDiferencialZonasD]</DataField></Field>
      <Field Name="PPIN1"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PPIN1]</DataField></Field>
      <Field Name="PPIN2"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PPIN2]</DataField></Field>
      <Field Name="TasaInflamable"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[TasaInflamable]</DataField></Field>
      <Field Name="PVPImpUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PVPImpUSD]</DataField></Field>
      <Field Name="PITImpUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PITImpUSD]</DataField></Field>
      <Field Name="PEPImpUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PEPImpUSD]</DataField></Field>
      <Field Name="PEPSinFleteImpUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PEPSinFleteImpUSD]</DataField></Field>
      <Field Name="PEPUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PEPUSD]</DataField></Field>
      <Field Name="FactorAjusteUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[FactorAjusteUSD]</DataField></Field>
      <Field Name="PEPCalcUrseaUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PEPCalcUrseaUSD]</DataField></Field>
      <Field Name="MontoDiferencialZonasDUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[MontoDiferencialZonasDUSD]</DataField></Field>
      <Field Name="PPIN1USD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PPIN1USD]</DataField></Field>
      <Field Name="PPIN2USD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[PPIN2USD]</DataField></Field>
      <Field Name="TasaInflamableUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[TasaInflamableUSD]</DataField></Field>
      <Field Name="MargenGLPEnvasado"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[MargenGLPEnvasado]</DataField></Field>
      <Field Name="BonificacionEESS"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[BonificacionEESS]</DataField></Field>
      <Field Name="TasaURSEAVenta"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[TasaURSEAVenta]</DataField></Field>
      <Field Name="IVAVentaPublico"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[IVAVentaPublico]</DataField></Field>
      <Field Name="MargenEnvasado"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[MargenEnvasado]</DataField></Field>
      <Field Name="MargenDistribucion"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[MargenDistribucion]</DataField></Field>
      <Field Name="TasaURSEADistribucion"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[TasaURSEADistribucion]</DataField></Field>
      <Field Name="IVADistribucion"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[IVADistribucion]</DataField></Field>
      <Field Name="Flete"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[Flete]</DataField></Field>
      <Field Name="TasaURSEASecundaria"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[TasaURSEASecundaria]</DataField></Field>
      <Field Name="IVASecundaria"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[IVASecundaria]</DataField></Field>
      <Field Name="CompensacionCFS"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[CompensacionCFS]</DataField></Field>
      <Field Name="IMESI"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[IMESI]</DataField></Field>
      <Field Name="ImpuestoCO2"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[ImpuestoCO2]</DataField></Field>
      <Field Name="TasaURSEAPrimaria"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[TasaURSEAPrimaria]</DataField></Field>
      <Field Name="FUDAEE"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[FUDAEE]</DataField></Field>
      <Field Name="IVAPrimaria"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[IVAPrimaria]</DataField></Field>
      <Field Name="Fideicomiso"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[Fideicomiso]</DataField></Field>
      <Field Name="MargenGLPEnvasadoUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[MargenGLPEnvasadoUSD]</DataField></Field>
      <Field Name="BonificacionEESSUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[BonificacionEESSUSD]</DataField></Field>
      <Field Name="TasaURSEAVentaUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[TasaURSEAVentaUSD]</DataField></Field>
      <Field Name="IVAVentaPublicoUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[IVAVentaPublicoUSD]</DataField></Field>
      <Field Name="MargenEnvasadoUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[MargenEnvasadoUSD]</DataField></Field>
      <Field Name="MargenDistribucionUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[MargenDistribucionUSD]</DataField></Field>
      <Field Name="TasaURSEADistribucionUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[TasaURSEADistribucionUSD]</DataField></Field>
      <Field Name="IVADistribucionUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[IVADistribucionUSD]</DataField></Field>
      <Field Name="FleteUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[FleteUSD]</DataField></Field>
      <Field Name="TasaURSEASecundariaUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[TasaURSEASecundariaUSD]</DataField></Field>
      <Field Name="IVASecundariaUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[IVASecundariaUSD]</DataField></Field>
      <Field Name="CompensacionCFSUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[CompensacionCFSUSD]</DataField></Field>
      <Field Name="IMESIUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[IMESIUSD]</DataField></Field>
      <Field Name="ImpuestoCO2USD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[ImpuestoCO2USD]</DataField></Field>
      <Field Name="TasaURSEAPrimariaUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[TasaURSEAPrimariaUSD]</DataField></Field>
      <Field Name="FUDAEEUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[FUDAEEUSD]</DataField></Field>
      <Field Name="IVAPrimariaUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[IVAPrimariaUSD]</DataField></Field>
      <Field Name="FideicomisoUSD"><rd:TypeName>System.Decimal</rd:TypeName><DataField>[FideicomisoUSD]</DataField></Field>
    </Fields>
  </DataSet>
</DataSets>
"@

$codeFragment = Fix-GeneratedText @"
<Code>
Public Function NormalizeUnit(ByVal input As String) As String
  If input = "USD" Or input = "USD/m3" Then Return "USD/m3"
  Return "$/lt Ã³ $/kg segÃºn corresponda"
End Function
Public Function NormalizeDisplayUnit(ByVal input As Object) As String
  If input Is Nothing Then Return ""

  Dim raw As String = Convert.ToString(input)
  Select Case raw
    Case "$/litro" : Return "$/lt"
    Case Else : Return raw
  End Select
End Function
Public Function NormalizeProduct(ByVal input As String) As String
  Select Case input
    Case "Asfalto AC-20" : Return "Asfalto AC-30"
    Case "Super 95 Sp" : Return "Gasolina Super 95"
    Case "Premium 97 Sp" : Return "Gasolina Premium 97"
    Case "Gasoil Comun" : Return "Gasoil 50-S"
    Case "Gasoil Especial" : Return "Gasoil 10-S"
    Case "Propano" : Return "Propano Industrial"
    Case Else : Return input
  End Select
End Function
Public Function ParseYearValue(ByVal yearValue As Object) As Integer
  If yearValue Is Nothing Then Return 0

  Try
    Return Convert.ToInt32(yearValue)
  Catch
    Return 0
  End Try
End Function
Public Function GetProductFamily(ByVal product As String) As String
  Dim normalized As String = NormalizeProduct(product)

  Select Case normalized
    Case "Gasolina Super 95", "Gasolina Premium 97", "Gasoil 50-S", "Gasoil 10-S", "Gasolina Av 100 Octanos", "Jet A1"
      Return "LiquidosEstandar"
    Case "Aguarras", "Solvente 1197", "Disan", "Base insecticida", "Querosol", "Hexano Comercial"
      Return "SolventesEspeciales"
    Case "Fuel Oil Medio", "Fuel Oil Pesado"
      Return "FuelOils"
    Case "Supergas"
      Return "SupergasEnvasado"
    Case "Propano Industrial", "Supergas A Granel", "Propano Redes"
      Return "PropanoGLPGranel"
    Case "Queroseno Montevideo"
      Return "QuerosenoMontevideo"
    Case "Queroseno Interior"
      Return "QuerosenoInterior"
    Case "Butano Desodorizado"
      Return "Butano"
    Case "Asfalto AC-30", "Asfalto 150/200", "Asfalto MC1", "Asfalto RC2"
      Return "Asfaltos"
    Case Else
      Return "Default"
  End Select
End Function
Public Function GetHistoricalSourceGroup(ByVal product As String, ByVal yearValue As Object) As String
  Dim normalized As String = NormalizeProduct(product)
  Dim yearNumber As Integer = ParseYearValue(yearValue)

  Select Case normalized
    Case "Supergas", "Propano Industrial", "Supergas A Granel", "Propano Redes"
      Select Case yearNumber
        Case 0
          Return "SinAnio"
        Case 1 To 2022
          Return "PAFijo"
        Case 2023
          Return "Transicion2023"
        Case Else
          If normalized = "Propano Redes" Then Return "Discontinuado"
          Return "PlanillaGLPPropano"
      End Select
    Case "Queroseno Montevideo", "Queroseno Interior"
      Select Case yearNumber
        Case 0
          Return "SinAnio"
        Case 1 To 2020
          Return "PAHasta2020"
        Case 2021
          Return "Transicion2021Queroseno"
        Case Else
          Return "PlanillaPost2021"
      End Select
    Case "Asfalto AC-30", "Asfalto 150/200", "Asfalto MC1", "Asfalto RC2"
      Return "PAFijo"
    Case Else
      Select Case yearNumber
        Case 0
          Return "SinAnio"
        Case 1 To 2020
          Return "PAHasta2020"
        Case 2021
          Return "Transicion2021"
        Case Else
          Return "PlanillaPost2021"
      End Select
  End Select
End Function
Public Function ShouldUseUsdTm1Summary(ByVal product As String, ByVal yearValue As Object) As Boolean
  Select Case GetProductFamily(product)
    Case "Asfaltos"
      Return True
    Case Else
      Return False
  End Select
End Function
Public Function ShouldUseLocalTm1Summary(ByVal product As String, ByVal yearValue As Object) As Boolean
  Return Not (GetHistoricalSourceGroup(product, yearValue) = "Discontinuado")
End Function
Public Function ShouldUseLocalMainSummary(ByVal product As String, ByVal yearValue As Object) As Boolean
  If GetHistoricalSourceGroup(product, yearValue) = "Discontinuado" Then Return False
  Return Not (GetProductFamily(product) = "Asfaltos")
End Function
Public Function IsColumnAllowed(ByVal viewKey As String, ByVal product As String, ByVal yearValue As Object, ByVal unitValue As String, ByVal columnKey As String) As Boolean
  Dim family As String = GetProductFamily(product)

  Select Case viewKey
    Case "SummaryUsd"
      If ShouldUseUsdTm1Summary(product, yearValue) Then Return False

      Select Case family
        Case "QuerosenoMontevideo"
          Select Case columnKey
            Case "PVP", "PIT", "PEPImp", "PEP" : Return True
            Case Else : Return False
          End Select
        Case "QuerosenoInterior"
          Select Case columnKey
            Case "PVP", "PIT", "PEPImp", "PEPSinFlete", "PEP" : Return True
            Case Else : Return False
          End Select
        Case "Butano"
          Select Case columnKey
            Case "PVP", "PEPSinFlete", "PEP" : Return True
            Case Else : Return False
          End Select
        Case "LiquidosEstandar", "SolventesEspeciales"
          Select Case columnKey
            Case "PVP", "PEPImp", "PEP" : Return True
            Case Else : Return False
          End Select
        Case "FuelOils"
          Select Case columnKey
            Case "PVP", "PEPImp", "PEP", "Factor", "Ursea", "PPIN1", "PPIN2" : Return True
            Case Else : Return False
          End Select
        Case "SupergasEnvasado"
          Select Case columnKey
            Case "PVP", "PIT", "PEPImp", "PEP", "Factor", "Ursea", "MontoDiferencial", "PPIN1", "PPIN2" : Return True
            Case Else : Return False
          End Select
        Case "PropanoGLPGranel"
          Select Case columnKey
            Case "PVP", "PEPImp", "PEP", "Factor", "Ursea", "PPIN1", "PPIN2" : Return True
            Case Else : Return False
          End Select
        Case Else
          Return True
      End Select
    Case "SummaryLocalTm1"
      If Not ShouldUseLocalTm1Summary(product, yearValue) Then Return False

      Select Case family
        Case "Asfaltos", "SolventesEspeciales"
          Select Case columnKey
            Case "PrecioPublico", "PrecioExonerado", "IVA", "PrecioSinIVA", "IMESI", "Cotizacion", "PrecioSinImpuesto", "PrecioExPlanta" : Return True
            Case Else : Return False
          End Select
        Case Else
          Select Case columnKey
            Case "PrecioPublico", "PrecioExonerado", "IVA", "PrecioSinIVA", "Cotizacion" : Return True
            Case Else : Return False
          End Select
      End Select
    Case "SummaryLocalMain"
      If Not ShouldUseLocalMainSummary(product, yearValue) Then Return False

      Select Case family
        Case "QuerosenoMontevideo"
          Select Case columnKey
            Case "PVP", "PIT", "PEPImp", "PEP" : Return True
            Case Else : Return False
          End Select
        Case "QuerosenoInterior"
          Select Case columnKey
            Case "PVP", "PIT", "PEPImp", "PEPSinFlete", "PEP" : Return True
            Case Else : Return False
          End Select
        Case "Butano"
          Select Case columnKey
            Case "PVP", "PEPSinFlete", "PEP" : Return True
            Case Else : Return False
          End Select
        Case "LiquidosEstandar", "SolventesEspeciales"
          Select Case columnKey
            Case "PVP", "PEPImp", "PEP" : Return True
            Case Else : Return False
          End Select
        Case "FuelOils"
          Select Case columnKey
            Case "PVP", "PEPImp", "PEP", "Factor", "Ursea", "PPIN1", "PPIN2" : Return True
            Case Else : Return False
          End Select
        Case "SupergasEnvasado"
          Select Case columnKey
            Case "PVP", "PIT", "PEPImp", "PEP", "Factor", "Ursea", "MontoDiferencial", "PPIN1", "PPIN2" : Return True
            Case Else : Return False
          End Select
        Case "PropanoGLPGranel"
          Select Case columnKey
            Case "PVP", "PEPImp", "PEP", "Factor", "Ursea", "PPIN1", "PPIN2" : Return True
            Case Else : Return False
          End Select
        Case Else
          Return False
      End Select
    Case "Detail"
      Select Case family
        Case "SupergasEnvasado"
          Select Case columnKey
            Case "PVP", "MargenGLPEnvasado", "TasaVenta", "IVAVentaPublico", "PIT", "MargenEnvasado", "Margen", "TasaDist", "IVADistribucion", "PEPImp", "TasaPrim", "FUDAEE", "IVAPrimaria", "PEP", "Factor", "Ursea", "MontoDiferencial", "PPIN1", "PPIN2" : Return True
            Case Else : Return False
          End Select
        Case "LiquidosEstandar"
          Select Case columnKey
            Case "PVP", "PEPImp", "TasaInflamable", "IMESI", "TasaPrim", "FUDAEE", "PEP" : Return True
            Case Else : Return False
          End Select
        Case "SolventesEspeciales"
          Select Case columnKey
            Case "PVP", "Margen", "IVADistribucion", "PEPImp", "TasaInflamable", "IMESI", "IVAPrimaria", "PEP" : Return True
            Case Else : Return False
          End Select
        Case Else
          Return True
      End Select
    Case Else
      Return True
  End Select
End Function
Public Function ConvertToUsd(ByVal value As Object, ByVal tc As Object) As Object
  If value Is Nothing Or tc Is Nothing Then Return Nothing
  If Convert.ToDecimal(tc) = 0D Then Return Nothing
  Return Convert.ToDecimal(value) / Convert.ToDecimal(tc)
End Function
Public Function SafeDivide(ByVal numerator As Object, ByVal denominator As Object) As Object
  If numerator Is Nothing Or denominator Is Nothing Then Return Nothing
  If Convert.ToDecimal(denominator) = 0D Then Return Nothing
  Return Convert.ToDecimal(numerator) / Convert.ToDecimal(denominator)
End Function
Public Function FormatValue(ByVal value As Object, ByVal decimals As Integer) As String
  If value Is Nothing Then Return ""
  Return Convert.ToDecimal(value).ToString("N" &amp; decimals.ToString())
End Function
Public Function ValueByUnit(ByVal localValue As Object, ByVal usdValue As Object, ByVal unitValue As String, ByVal decimals As Integer) As String
  If NormalizeUnit(unitValue) = "USD/m3" Then Return FormatValue(usdValue, decimals)
  Return FormatValue(localValue, decimals)
End Function
Public Function ViewUnitLabel(ByVal unitValue As String, ByVal localUnit As Object) As String
  If NormalizeUnit(unitValue) = "USD/m3" Then Return "USD/m3"
  Return NormalizeDisplayUnit(localUnit)
End Function
</Code>
"@

$content = [regex]::Replace($content, '(?s)<DataSets>.*?</DataSets>', $dataSetsFragment)
$content = [regex]::Replace($content, '(?s)<Body>.*?</Body>', $bodyFragment)
$content = [regex]::Replace($content, '(?s)<ReportParameters>.*?</ReportParameters>', $reportParametersFragment)
$content = [regex]::Replace($content, '(?s)<ReportParametersLayout>.*?</ReportParametersLayout>', $reportParametersLayoutFragment)
$content = [regex]::Replace($content, '(?s)<Code>.*?</Code>', $codeFragment)
if ($content -notmatch '<Code>') {
    $content = [regex]::Replace($content, '(?s)<EmbeddedImages>', "$codeFragment`r`n<EmbeddedImages>")
}
$content = [regex]::Replace($content, '(?s)\s*<PageHeader>.*?</PageHeader>', '')
$content = [regex]::Replace($content, '(?s)</Body>\s*<Width>.*?</Width>\s*<Page>', "</Body>`r`n      <Width>19.50in</Width>`r`n      <Page>")
for ($iteration = 0; $iteration -lt 3; $iteration++) {
    $content = Fix-GeneratedText $content
}
$content = Normalize-MojibakeSequences $content
$content = Remove-InvalidUnicode $content
$content = Remove-InvalidTextChars $content

$utf8Encoding = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($detailPath, $content, $utf8Encoding)
Write-Host "RDL detalle regenerado en '$detailPath'."


