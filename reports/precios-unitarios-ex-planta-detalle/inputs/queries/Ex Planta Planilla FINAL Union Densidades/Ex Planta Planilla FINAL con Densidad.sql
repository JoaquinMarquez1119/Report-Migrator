WITH 
"Cotizaciones" AS 
    (
    SELECT
        "D1"."C0" AS "Años", 
        "D1"."C1" AS "Periodo_Mensual", 
        "D1"."C2" AS "Mes_Número", 
        "D1"."C3" AS "Valor", 
        "D1"."C4" AS "Cantidad_Dias", 
        "D1"."C5" AS "Medidas_ExPlanta", 
        "D1"."C6" AS "N_A_N_A_N_A_Cotización", 
        "D1"."C7" AS "Fecha", 
        "D1"."C8" AS "Dia", 
        "D1"."C9" AS "Productos_ExPlanta"
    FROM
        (
        SELECT
            "Precios_ExPLanta_2_TM1"."Años" AS "C0", 
            "Precios_ExPLanta_2_TM1"."Periodo_Mensual" AS "C1", 
            CASE "Precios_ExPLanta_2_TM1"."Periodo_Mensual"
                WHEN 'Ene' THEN 1
                WHEN 'Feb' THEN 2
                WHEN 'Mar' THEN 3
                WHEN 'Abr' THEN 4
                WHEN 'May' THEN 5
                WHEN 'Jun' THEN 6
                WHEN 'Jul' THEN 7
                WHEN 'Ago' THEN 8
                WHEN 'Sep' THEN 9
                WHEN 'Oct' THEN 10
                WHEN 'Nov' THEN 11
                WHEN 'Dic' THEN 12
            END AS "C2", 
            "Precios_ExPLanta_2_TM1"."Valor" AS "C3", 
            "Precios_ExPLanta_2_TM1"."Cantidad_Dias" AS "C4", 
            "Precios_ExPLanta_2_TM1"."Medidas_ExPlanta" AS "C5", 
            CASE 
                WHEN "Precios_ExPLanta_2_TM1"."Medidas_ExPlanta" = 'Cotización' THEN "Precios_ExPLanta_2_TM1"."Valor"
                ELSE 0
            END AS "C6", 
            CONVERT(DATETIME, CONVERT(VARCHAR(8), (("Precios_ExPLanta_2_TM1"."Años") * 10000) + ((
                CASE "Precios_ExPLanta_2_TM1"."Periodo_Mensual"
                    WHEN 'Ene' THEN 1
                    WHEN 'Feb' THEN 2
                    WHEN 'Mar' THEN 3
                    WHEN 'Abr' THEN 4
                    WHEN 'May' THEN 5
                    WHEN 'Jun' THEN 6
                    WHEN 'Jul' THEN 7
                    WHEN 'Ago' THEN 8
                    WHEN 'Sep' THEN 9
                    WHEN 'Oct' THEN 10
                    WHEN 'Nov' THEN 11
                    WHEN 'Dic' THEN 12
                END) * 100) + 1)) AS "C7", 
            CASE 
                WHEN 
                    "Precios_ExPLanta_2_TM1"."Años" = DATEPART(YEAR, CAST(CURRENT_TIMESTAMP AS DATE)) AND
                    CASE "Precios_ExPLanta_2_TM1"."Periodo_Mensual"
                        WHEN 'Ene' THEN 1
                        WHEN 'Feb' THEN 2
                        WHEN 'Mar' THEN 3
                        WHEN 'Abr' THEN 4
                        WHEN 'May' THEN 5
                        WHEN 'Jun' THEN 6
                        WHEN 'Jul' THEN 7
                        WHEN 'Ago' THEN 8
                        WHEN 'Sep' THEN 9
                        WHEN 'Oct' THEN 10
                        WHEN 'Nov' THEN 11
                        WHEN 'Dic' THEN 12
                    END = DATEPART(MONTH, CAST(CURRENT_TIMESTAMP AS DATE))
                    THEN
                        ((CAST(DATEPART(DAY, CAST(CURRENT_TIMESTAMP AS DATE)) AS VARCHAR(2)) + '-') + "Precios_ExPLanta_2_TM1"."Periodo_Mensual")
                ELSE ((CAST("Precios_ExPLanta_2_TM1"."Cantidad_Dias" AS VARCHAR(2)) + '-') + "Precios_ExPLanta_2_TM1"."Periodo_Mensual")
            END AS "C8", 
            "Precios_ExPLanta_2_TM1"."Productos_ExPlanta" AS "C9"
        FROM
            "APPBI"."DP"."Precios_ExPLanta_2_TM1" "Precios_ExPLanta_2_TM1" 
        WHERE 
            "Precios_ExPLanta_2_TM1"."Años" = :pAño: AND
            CASE 
                WHEN "Precios_ExPLanta_2_TM1"."Medidas_ExPlanta" = 'Cotización' THEN "Precios_ExPLanta_2_TM1"."Valor"
                ELSE 0
            END <> 0 AND
            "Precios_ExPLanta_2_TM1"."Periodo_Mensual" <> 'Base'
        ) "D1" 
    GROUP BY 
        "D1"."C0", 
        "D1"."C1", 
        "D1"."C2", 
        "D1"."C3", 
        "D1"."C4", 
        "D1"."C5", 
        "D1"."C6", 
        "D1"."C7", 
        "D1"."C8", 
        "D1"."C9"
    ), 
"Cotizaciones_FORMATO" AS 
    (
    SELECT
        "D1"."C0" AS "Año", 
        "D1"."C1" AS "Fecha", 
        "D1"."C2" AS "Dia", 
        '' AS "Concepto2", 
        "D1"."C3" AS "TC", 
        0 AS "Valor", 
        0 AS "Valor_USD_m3", 
        0 AS "Orden", 
        "D1"."C4" AS "Productos_ExPlanta"
    FROM
        (
        SELECT
            "Cotizaciones"."Años" AS "C0", 
            "Cotizaciones"."Fecha" AS "C1", 
            "Cotizaciones"."Dia" AS "C2", 
            CASE 
                WHEN "Cotizaciones"."Años" < 2022 THEN 0
                ELSE "Cotizaciones"."N_A_N_A_N_A_Cotización"
            END AS "C3", 
            "Cotizaciones"."Productos_ExPlanta" AS "C4"
        FROM
            "Cotizaciones"
        ) "D1" 
    GROUP BY 
        "D1"."C0", 
        "D1"."C1", 
        "D1"."C2", 
        "D1"."C3", 
        "D1"."C4"
    ), 
"Densidades_datos" AS 
    (
    SELECT
        "D1"."C0" AS "Años", 
        "D1"."C1" AS "pAño", 
        "D1"."C2" AS "Periodo_Mensual", 
        "D1"."C3" AS "Periodo_Mensual4", 
        "D1"."C4" AS "Número", 
        "D1"."C5" AS "Valor_Mensual", 
        'Productos_ExPlanta' AS "Productos_ExPlanta", 
        "D1"."C6" AS "children__Productos_ExPlanta__", 
        "D1"."C7" AS "Producto", 
        "D1"."C8" AS "Medidas_ExPlanta", 
        SUM("D1"."C12") AS "Densidad", 
        "D1"."C9" AS "Filtro", 
        "D1"."C10" AS "Cantidad_dias", 
        "D1"."C11" AS "Dia"
    FROM
        (
        SELECT
            "Precios_ExPLanta_2_TM1"."Años" AS "C0", 
            CASE 
                WHEN "Precios_ExPLanta_2_TM1"."Años" <> 'Año Base' THEN CAST("Precios_ExPLanta_2_TM1"."Años" AS INTEGER)
                ELSE NULL
            END AS "C1", 
            "Precios_ExPLanta_2_TM1"."Periodo_Mensual" AS "C2", 
            CASE 
                
                CASE "Precios_ExPLanta_2_TM1"."Periodo_Mensual"
                    WHEN 'Ene' THEN 1
                    WHEN 'Feb' THEN 2
                    WHEN 'Mar' THEN 3
                    WHEN 'Abr' THEN 4
                    WHEN 'May' THEN 5
                    WHEN 'Jun' THEN 6
                    WHEN 'Jul' THEN 7
                    WHEN 'Ago' THEN 8
                    WHEN 'Sep' THEN 9
                    WHEN 'Oct' THEN 10
                    WHEN 'Nov' THEN 11
                    WHEN 'Dic' THEN 12
                END
                WHEN 1 THEN 'Ene'
                WHEN 2 THEN 'Feb'
                WHEN 3 THEN 'Mar'
                WHEN 4 THEN 'Abr'
                WHEN 5 THEN 'May'
                WHEN 6 THEN 'Jun'
                WHEN 7 THEN 'Jul'
                WHEN 8 THEN 'Ago'
                WHEN 9 THEN 'Sep'
                WHEN 10 THEN 'Oct'
                WHEN 11 THEN 'Nov'
                WHEN 12 THEN 'Dic'
            END AS "C3", 
            CASE "Precios_ExPLanta_2_TM1"."Periodo_Mensual"
                WHEN 'Ene' THEN 1
                WHEN 'Feb' THEN 2
                WHEN 'Mar' THEN 3
                WHEN 'Abr' THEN 4
                WHEN 'May' THEN 5
                WHEN 'Jun' THEN 6
                WHEN 'Jul' THEN 7
                WHEN 'Ago' THEN 8
                WHEN 'Sep' THEN 9
                WHEN 'Oct' THEN 10
                WHEN 'Nov' THEN 11
                WHEN 'Dic' THEN 12
            END AS "C4", 
            "Precios_ExPLanta_2_TM1"."Periodo_Diario" AS "C5", 
            "Precios_ExPLanta_2_TM1"."Productos_ExPlanta" AS "C6", 
            CASE 
                WHEN CAST("Precios_ExPLanta_2_TM1"."Productos_ExPlanta" AS VARCHAR(20)) = 'Gasolina Av 100 Octa' THEN 'Gasolina Av 100 Octanos'
                ELSE CAST("Precios_ExPLanta_2_TM1"."Productos_ExPlanta" AS VARCHAR(20))
            END AS "C7", 
            "Precios_ExPLanta_2_TM1"."Medidas_ExPlanta" AS "C8", 
            CASE 
                WHEN 
                    CASE 
                        WHEN "Precios_ExPLanta_2_TM1"."Años" <> 'Año Base' THEN CAST("Precios_ExPLanta_2_TM1"."Años" AS INTEGER)
                        ELSE NULL
                    END = 2021 AND
                    CASE "Precios_ExPLanta_2_TM1"."Periodo_Mensual"
                        WHEN 'Ene' THEN 1
                        WHEN 'Feb' THEN 2
                        WHEN 'Mar' THEN 3
                        WHEN 'Abr' THEN 4
                        WHEN 'May' THEN 5
                        WHEN 'Jun' THEN 6
                        WHEN 'Jul' THEN 7
                        WHEN 'Ago' THEN 8
                        WHEN 'Sep' THEN 9
                        WHEN 'Oct' THEN 10
                        WHEN 'Nov' THEN 11
                        WHEN 'Dic' THEN 12
                    END < 7 OR
                    CASE 
                        WHEN "Precios_ExPLanta_2_TM1"."Años" <> 'Año Base' THEN CAST("Precios_ExPLanta_2_TM1"."Años" AS INTEGER)
                        ELSE NULL
                    END < 2021
                    THEN
                        0
                ELSE 1
            END AS "C9", 
            DATEPART(DAY, DATEADD(DAY, -1, DATEADD(MONTH, 1, DATEADD(DAY, -DAY(CONVERT(DATETIME, CONVERT(VARCHAR(8), ((
                CASE 
                    WHEN "Precios_ExPLanta_2_TM1"."Años" <> 'Año Base' THEN CAST("Precios_ExPLanta_2_TM1"."Años" AS INTEGER)
                    ELSE NULL
                END) * 10000) + ((
                CASE "Precios_ExPLanta_2_TM1"."Periodo_Mensual"
                    WHEN 'Ene' THEN 1
                    WHEN 'Feb' THEN 2
                    WHEN 'Mar' THEN 3
                    WHEN 'Abr' THEN 4
                    WHEN 'May' THEN 5
                    WHEN 'Jun' THEN 6
                    WHEN 'Jul' THEN 7
                    WHEN 'Ago' THEN 8
                    WHEN 'Sep' THEN 9
                    WHEN 'Oct' THEN 10
                    WHEN 'Nov' THEN 11
                    WHEN 'Dic' THEN 12
                END) * 100) + 1))) + 1, CONVERT(DATETIME, CONVERT(VARCHAR(8), ((
                CASE 
                    WHEN "Precios_ExPLanta_2_TM1"."Años" <> 'Año Base' THEN CAST("Precios_ExPLanta_2_TM1"."Años" AS INTEGER)
                    ELSE NULL
                END) * 10000) + ((
                CASE "Precios_ExPLanta_2_TM1"."Periodo_Mensual"
                    WHEN 'Ene' THEN 1
                    WHEN 'Feb' THEN 2
                    WHEN 'Mar' THEN 3
                    WHEN 'Abr' THEN 4
                    WHEN 'May' THEN 5
                    WHEN 'Jun' THEN 6
                    WHEN 'Jul' THEN 7
                    WHEN 'Ago' THEN 8
                    WHEN 'Sep' THEN 9
                    WHEN 'Oct' THEN 10
                    WHEN 'Nov' THEN 11
                    WHEN 'Dic' THEN 12
                END) * 100) + 1)))))) AS "C10", 
            CASE 
                WHEN 
                    CASE 
                        WHEN "Precios_ExPLanta_2_TM1"."Años" <> 'Año Base' THEN CAST("Precios_ExPLanta_2_TM1"."Años" AS INTEGER)
                        ELSE NULL
                    END = DATEPART(YEAR, CAST(CURRENT_TIMESTAMP AS DATE)) AND
                    CASE "Precios_ExPLanta_2_TM1"."Periodo_Mensual"
                        WHEN 'Ene' THEN 1
                        WHEN 'Feb' THEN 2
                        WHEN 'Mar' THEN 3
                        WHEN 'Abr' THEN 4
                        WHEN 'May' THEN 5
                        WHEN 'Jun' THEN 6
                        WHEN 'Jul' THEN 7
                        WHEN 'Ago' THEN 8
                        WHEN 'Sep' THEN 9
                        WHEN 'Oct' THEN 10
                        WHEN 'Nov' THEN 11
                        WHEN 'Dic' THEN 12
                    END = DATEPART(MONTH, CAST(CURRENT_TIMESTAMP AS DATE))
                    THEN
                        ((CAST(DATEPART(DAY, CAST(CURRENT_TIMESTAMP AS DATE)) AS VARCHAR(2)) + '-') + CASE 
                            
                            CASE "Precios_ExPLanta_2_TM1"."Periodo_Mensual"
                                WHEN 'Ene' THEN 1
                                WHEN 'Feb' THEN 2
                                WHEN 'Mar' THEN 3
                                WHEN 'Abr' THEN 4
                                WHEN 'May' THEN 5
                                WHEN 'Jun' THEN 6
                                WHEN 'Jul' THEN 7
                                WHEN 'Ago' THEN 8
                                WHEN 'Sep' THEN 9
                                WHEN 'Oct' THEN 10
                                WHEN 'Nov' THEN 11
                                WHEN 'Dic' THEN 12
                            END
                            WHEN 1 THEN 'Ene'
                            WHEN 2 THEN 'Feb'
                            WHEN 3 THEN 'Mar'
                            WHEN 4 THEN 'Abr'
                            WHEN 5 THEN 'May'
                            WHEN 6 THEN 'Jun'
                            WHEN 7 THEN 'Jul'
                            WHEN 8 THEN 'Ago'
                            WHEN 9 THEN 'Sep'
                            WHEN 10 THEN 'Oct'
                            WHEN 11 THEN 'Nov'
                            WHEN 12 THEN 'Dic'
                        END)
                ELSE ((CAST(DATEPART(DAY, DATEADD(DAY, -1, DATEADD(MONTH, 1, DATEADD(DAY, -DAY(CONVERT(DATETIME, CONVERT(VARCHAR(8), ((
                    CASE 
                        WHEN "Precios_ExPLanta_2_TM1"."Años" <> 'Año Base' THEN CAST("Precios_ExPLanta_2_TM1"."Años" AS INTEGER)
                        ELSE NULL
                    END) * 10000) + ((
                    CASE "Precios_ExPLanta_2_TM1"."Periodo_Mensual"
                        WHEN 'Ene' THEN 1
                        WHEN 'Feb' THEN 2
                        WHEN 'Mar' THEN 3
                        WHEN 'Abr' THEN 4
                        WHEN 'May' THEN 5
                        WHEN 'Jun' THEN 6
                        WHEN 'Jul' THEN 7
                        WHEN 'Ago' THEN 8
                        WHEN 'Sep' THEN 9
                        WHEN 'Oct' THEN 10
                        WHEN 'Nov' THEN 11
                        WHEN 'Dic' THEN 12
                    END) * 100) + 1))) + 1, CONVERT(DATETIME, CONVERT(VARCHAR(8), ((
                    CASE 
                        WHEN "Precios_ExPLanta_2_TM1"."Años" <> 'Año Base' THEN CAST("Precios_ExPLanta_2_TM1"."Años" AS INTEGER)
                        ELSE NULL
                    END) * 10000) + ((
                    CASE "Precios_ExPLanta_2_TM1"."Periodo_Mensual"
                        WHEN 'Ene' THEN 1
                        WHEN 'Feb' THEN 2
                        WHEN 'Mar' THEN 3
                        WHEN 'Abr' THEN 4
                        WHEN 'May' THEN 5
                        WHEN 'Jun' THEN 6
                        WHEN 'Jul' THEN 7
                        WHEN 'Ago' THEN 8
                        WHEN 'Sep' THEN 9
                        WHEN 'Oct' THEN 10
                        WHEN 'Nov' THEN 11
                        WHEN 'Dic' THEN 12
                    END) * 100) + 1)))))) AS VARCHAR(2)) + '-') + CASE 
                    
                    CASE "Precios_ExPLanta_2_TM1"."Periodo_Mensual"
                        WHEN 'Ene' THEN 1
                        WHEN 'Feb' THEN 2
                        WHEN 'Mar' THEN 3
                        WHEN 'Abr' THEN 4
                        WHEN 'May' THEN 5
                        WHEN 'Jun' THEN 6
                        WHEN 'Jul' THEN 7
                        WHEN 'Ago' THEN 8
                        WHEN 'Sep' THEN 9
                        WHEN 'Oct' THEN 10
                        WHEN 'Nov' THEN 11
                        WHEN 'Dic' THEN 12
                    END
                    WHEN 1 THEN 'Ene'
                    WHEN 2 THEN 'Feb'
                    WHEN 3 THEN 'Mar'
                    WHEN 4 THEN 'Abr'
                    WHEN 5 THEN 'May'
                    WHEN 6 THEN 'Jun'
                    WHEN 7 THEN 'Jul'
                    WHEN 8 THEN 'Ago'
                    WHEN 9 THEN 'Sep'
                    WHEN 10 THEN 'Oct'
                    WHEN 11 THEN 'Nov'
                    WHEN 12 THEN 'Dic'
                END)
            END AS "C11", 
            CASE 
                WHEN "Precios_ExPLanta_2_TM1"."Medidas_ExPlanta" = 'Densidad' THEN "Precios_ExPLanta_2_TM1"."Valor"
                ELSE 0
            END AS "C12"
        FROM
            "APPBI"."DP"."Precios_ExPLanta_2_TM1" "Precios_ExPLanta_2_TM1" 
        WHERE 
            "Precios_ExPLanta_2_TM1"."Años" <> 'Año Base' AND
            NOT ( 
                CASE 
                    WHEN CAST("Precios_ExPLanta_2_TM1"."Productos_ExPlanta" AS VARCHAR(20)) = 'Gasolina Av 100 Octa' THEN 'Gasolina Av 100 Octanos'
                    ELSE CAST("Precios_ExPLanta_2_TM1"."Productos_ExPlanta" AS VARCHAR(20))
                END LIKE 'RPMS%' ) AND
            CASE 
                WHEN CAST("Precios_ExPLanta_2_TM1"."Productos_ExPlanta" AS VARCHAR(20)) = 'Gasolina Av 100 Octa' THEN 'Gasolina Av 100 Octanos'
                ELSE CAST("Precios_ExPLanta_2_TM1"."Productos_ExPlanta" AS VARCHAR(20))
            END <> 'N/A' AND
            NOT ( "Precios_ExPLanta_2_TM1"."Productos_ExPlanta" IN ( 
                'Asfalto 150/200', 
                'Asfalto AC-20', 
                'Asfalto MC1', 
                'Asfalto RC2', 
                'Propano Redes' ) ) AND
            CASE 
                WHEN "Precios_ExPLanta_2_TM1"."Años" <> 'Año Base' THEN CAST("Precios_ExPLanta_2_TM1"."Años" AS INTEGER)
                ELSE NULL
            END = :pAño: AND
            "Precios_ExPLanta_2_TM1"."Periodo_Mensual" <> 'Base' AND
            CASE 
                WHEN 
                    CASE 
                        WHEN "Precios_ExPLanta_2_TM1"."Años" <> 'Año Base' THEN CAST("Precios_ExPLanta_2_TM1"."Años" AS INTEGER)
                        ELSE NULL
                    END = 2021 AND
                    CASE "Precios_ExPLanta_2_TM1"."Periodo_Mensual"
                        WHEN 'Ene' THEN 1
                        WHEN 'Feb' THEN 2
                        WHEN 'Mar' THEN 3
                        WHEN 'Abr' THEN 4
                        WHEN 'May' THEN 5
                        WHEN 'Jun' THEN 6
                        WHEN 'Jul' THEN 7
                        WHEN 'Ago' THEN 8
                        WHEN 'Sep' THEN 9
                        WHEN 'Oct' THEN 10
                        WHEN 'Nov' THEN 11
                        WHEN 'Dic' THEN 12
                    END < 7 OR
                    CASE 
                        WHEN "Precios_ExPLanta_2_TM1"."Años" <> 'Año Base' THEN CAST("Precios_ExPLanta_2_TM1"."Años" AS INTEGER)
                        ELSE NULL
                    END < 2021
                    THEN
                        0
                ELSE 1
            END = 1
        ) "D1" 
    GROUP BY 
        "D1"."C0", 
        "D1"."C1", 
        "D1"."C2", 
        "D1"."C3", 
        "D1"."C4", 
        "D1"."C5", 
        "D1"."C6", 
        "D1"."C7", 
        "D1"."C8", 
        "D1"."C9", 
        "D1"."C10", 
        "D1"."C11"
    ), 
"Ex_Planta_Planilla" AS 
    (
    SELECT
        "D1"."C0" AS "Fecha", 
        "D1"."C1" AS "Año", 
        "D1"."C2" AS "Concepto", 
        "D1"."C3" AS "Concepto2", 
        "D1"."C4" AS "EncabezadosenDatosPrioritarios", 
        "D1"."C5" AS "Producto", 
        SUM("D1"."C21") AS "TC", 
        SUM("D1"."C22") AS "Valor", 
        SUM("D1"."C22") AS "Valor_USD_m3", 
        "D1"."C6" AS "Mes_Número", 
        "D1"."C7" AS "Mes_numero", 
        "D1"."C8" AS "Periodo_Mensual", 
        "D1"."C9" AS "Cantidad_dias", 
        "D1"."C10" AS "Dia", 
        "D1"."C11" AS "Filtro_QInterior", 
        "D1"."C12" AS "Filtro_QMontevideo", 
        "D1"."C13" AS "Filtro_Butano", 
        "D1"."C14" AS "Filtro_Ultimos", 
        "D1"."C15" AS "Filtro_FO", 
        "D1"."C16" AS "Filtro_Supergas", 
        "D1"."C17" AS "Filtro_Propano", 
        "D1"."C18" AS "Filtro", 
        :pUnidad: AS "Unidad", 
        "D1"."C19" AS "Orden", 
        "D1"."C20" AS "Unidad2", 
        SUM(0) AS "Nueva_Cotizacion"
    FROM
        (
        SELECT
            "Precios_Ex_Planta"."Fecha" AS "C0", 
            CAST(DATEPART(YEAR, "Precios_Ex_Planta"."Fecha") AS INTEGER) AS "C1", 
            "Precios_Ex_Planta"."Concepto" AS "C2", 
            CASE 
                WHEN 
                    CASE 
                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                        WHEN 
                            :pProducto: = 'Propano Industrial' AND
                            "Precios_Ex_Planta"."Producto" = 'Propano'
                            THEN
                                'Propano Industrial'
                        ELSE "Precios_Ex_Planta"."Producto"
                    END IN ( 
                        'Premium 97 Sp', 
                        'Super 95 Sp', 
                        'Gasoil Comun', 
                        'Gasoil Especial', 
                        'Fuel Oil Pesado', 
                        'Fuel Oil Medio', 
                        'Queroseno Montevideo', 
                        'Queroseno Interior' ) AND
                    "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                    THEN
                        'Precio Ex Planta (PEP)'
                WHEN 
                    NOT ( CASE 
                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                        WHEN 
                            :pProducto: = 'Propano Industrial' AND
                            "Precios_Ex_Planta"."Producto" = 'Propano'
                            THEN
                                'Propano Industrial'
                        ELSE "Precios_Ex_Planta"."Producto"
                    END IN ( 
                        'Premium 97 Sp', 
                        'Super 95 Sp', 
                        'Gasoil Comun', 
                        'Gasoil Especial', 
                        'Fuel Oil Pesado', 
                        'Fuel Oil Medio' ) ) AND
                    "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                    THEN
                        'Precio Ex Planta (PEP)'
                ELSE "Precios_Ex_Planta"."Concepto"
            END AS "C3", 
            "Precios_Ex_Planta"."EncabezadosenDatosPrioritarios" AS "C4", 
            CASE 
                WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                WHEN 
                    :pProducto: = 'Propano Industrial' AND
                    "Precios_Ex_Planta"."Producto" = 'Propano'
                    THEN
                        'Propano Industrial'
                ELSE "Precios_Ex_Planta"."Producto"
            END AS "C5", 
            DATEPART(MONTH, "Precios_Ex_Planta"."Fecha") AS "C6", 
            CAST(DATEPART(MONTH, "Precios_Ex_Planta"."Fecha") AS INTEGER) AS "C7", 
            CASE DATEPART(MONTH, "Precios_Ex_Planta"."Fecha")
                WHEN 1 THEN 'Ene'
                WHEN 2 THEN 'Feb'
                WHEN 3 THEN 'Mar'
                WHEN 4 THEN 'Abr'
                WHEN 5 THEN 'May'
                WHEN 6 THEN 'Jun'
                WHEN 7 THEN 'Jul'
                WHEN 8 THEN 'Ago'
                WHEN 9 THEN 'Set'
                WHEN 10 THEN 'Oct'
                WHEN 11 THEN 'Nov'
                WHEN 12 THEN 'Dic'
            END AS "C8", 
            DATEPART(DAY, DATEADD(DAY, -1, DATEADD(MONTH, 1, DATEADD(DAY, -DAY("Precios_Ex_Planta"."Fecha") + 1, "Precios_Ex_Planta"."Fecha")))) AS "C9", 
            CASE 
                WHEN 
                    CAST(DATEPART(YEAR, "Precios_Ex_Planta"."Fecha") AS INTEGER) = DATEPART(YEAR, CAST(CURRENT_TIMESTAMP AS DATE)) AND
                    CAST(DATEPART(MONTH, "Precios_Ex_Planta"."Fecha") AS INTEGER) = DATEPART(MONTH, CAST(CURRENT_TIMESTAMP AS DATE))
                    THEN
                        ((CAST(DATEPART(DAY, CAST(CURRENT_TIMESTAMP AS DATE)) AS VARCHAR(2)) + '-') + CASE DATEPART(MONTH, "Precios_Ex_Planta"."Fecha")
                            WHEN 1 THEN 'Ene'
                            WHEN 2 THEN 'Feb'
                            WHEN 3 THEN 'Mar'
                            WHEN 4 THEN 'Abr'
                            WHEN 5 THEN 'May'
                            WHEN 6 THEN 'Jun'
                            WHEN 7 THEN 'Jul'
                            WHEN 8 THEN 'Ago'
                            WHEN 9 THEN 'Set'
                            WHEN 10 THEN 'Oct'
                            WHEN 11 THEN 'Nov'
                            WHEN 12 THEN 'Dic'
                        END)
                ELSE ((CAST(DATEPART(DAY, DATEADD(DAY, -1, DATEADD(MONTH, 1, DATEADD(DAY, -DAY("Precios_Ex_Planta"."Fecha") + 1, "Precios_Ex_Planta"."Fecha")))) AS VARCHAR(2)) + '-') + CASE DATEPART(MONTH, "Precios_Ex_Planta"."Fecha")
                    WHEN 1 THEN 'Ene'
                    WHEN 2 THEN 'Feb'
                    WHEN 3 THEN 'Mar'
                    WHEN 4 THEN 'Abr'
                    WHEN 5 THEN 'May'
                    WHEN 6 THEN 'Jun'
                    WHEN 7 THEN 'Jul'
                    WHEN 8 THEN 'Ago'
                    WHEN 9 THEN 'Set'
                    WHEN 10 THEN 'Oct'
                    WHEN 11 THEN 'Nov'
                    WHEN 12 THEN 'Dic'
                END)
            END AS "C10", 
            CASE 
                WHEN 
                    CASE 
                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                        WHEN 
                            :pProducto: = 'Propano Industrial' AND
                            "Precios_Ex_Planta"."Producto" = 'Propano'
                            THEN
                                'Propano Industrial'
                        ELSE "Precios_Ex_Planta"."Producto"
                    END IN ( 
                        'Queroseno Interior' ) AND
                    CASE 
                        WHEN 
                            CASE 
                                WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                WHEN 
                                    :pProducto: = 'Propano Industrial' AND
                                    "Precios_Ex_Planta"."Producto" = 'Propano'
                                    THEN
                                        'Propano Industrial'
                                ELSE "Precios_Ex_Planta"."Producto"
                            END IN ( 
                                'Premium 97 Sp', 
                                'Super 95 Sp', 
                                'Gasoil Comun', 
                                'Gasoil Especial', 
                                'Fuel Oil Pesado', 
                                'Fuel Oil Medio', 
                                'Queroseno Montevideo', 
                                'Queroseno Interior' ) AND
                            "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                            THEN
                                'Precio Ex Planta (PEP)'
                        WHEN 
                            NOT ( CASE 
                                WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                WHEN 
                                    :pProducto: = 'Propano Industrial' AND
                                    "Precios_Ex_Planta"."Producto" = 'Propano'
                                    THEN
                                        'Propano Industrial'
                                ELSE "Precios_Ex_Planta"."Producto"
                            END IN ( 
                                'Premium 97 Sp', 
                                'Super 95 Sp', 
                                'Gasoil Comun', 
                                'Gasoil Especial', 
                                'Fuel Oil Pesado', 
                                'Fuel Oil Medio' ) ) AND
                            "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                            THEN
                                'Precio Ex Planta (PEP)'
                        ELSE "Precios_Ex_Planta"."Concepto"
                    END IN ( 
                        'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                        'Precio Intermedio Transitorio (PIT) (impuestos incluidos)', 
                        'Precio Ex Planta (PEP) (impuestos incluidos)', 
                        'Precio Ex Planta (PEP) sin flete secundario (impuestos incluidos)', 
                        'Precio Ex Planta (PEP)' )
                    THEN
                        1
                ELSE 0
            END AS "C11", 
            CASE 
                WHEN 
                    CASE 
                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                        WHEN 
                            :pProducto: = 'Propano Industrial' AND
                            "Precios_Ex_Planta"."Producto" = 'Propano'
                            THEN
                                'Propano Industrial'
                        ELSE "Precios_Ex_Planta"."Producto"
                    END IN ( 
                        'Queroseno Montevideo' ) AND
                    CASE 
                        WHEN 
                            CASE 
                                WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                WHEN 
                                    :pProducto: = 'Propano Industrial' AND
                                    "Precios_Ex_Planta"."Producto" = 'Propano'
                                    THEN
                                        'Propano Industrial'
                                ELSE "Precios_Ex_Planta"."Producto"
                            END IN ( 
                                'Premium 97 Sp', 
                                'Super 95 Sp', 
                                'Gasoil Comun', 
                                'Gasoil Especial', 
                                'Fuel Oil Pesado', 
                                'Fuel Oil Medio', 
                                'Queroseno Montevideo', 
                                'Queroseno Interior' ) AND
                            "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                            THEN
                                'Precio Ex Planta (PEP)'
                        WHEN 
                            NOT ( CASE 
                                WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                WHEN 
                                    :pProducto: = 'Propano Industrial' AND
                                    "Precios_Ex_Planta"."Producto" = 'Propano'
                                    THEN
                                        'Propano Industrial'
                                ELSE "Precios_Ex_Planta"."Producto"
                            END IN ( 
                                'Premium 97 Sp', 
                                'Super 95 Sp', 
                                'Gasoil Comun', 
                                'Gasoil Especial', 
                                'Fuel Oil Pesado', 
                                'Fuel Oil Medio' ) ) AND
                            "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                            THEN
                                'Precio Ex Planta (PEP)'
                        ELSE "Precios_Ex_Planta"."Concepto"
                    END IN ( 
                        'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                        'Precio Intermedio Transitorio (PIT) (impuestos incluidos)', 
                        'Precio Ex Planta (PEP) (impuestos incluidos)', 
                        'Precio Ex Planta (PEP)' )
                    THEN
                        1
                ELSE 0
            END AS "C12", 
            CASE 
                WHEN 
                    CASE 
                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                        WHEN 
                            :pProducto: = 'Propano Industrial' AND
                            "Precios_Ex_Planta"."Producto" = 'Propano'
                            THEN
                                'Propano Industrial'
                        ELSE "Precios_Ex_Planta"."Producto"
                    END IN ( 
                        'Butano Desodorizado' ) AND
                    CASE 
                        WHEN 
                            CASE 
                                WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                WHEN 
                                    :pProducto: = 'Propano Industrial' AND
                                    "Precios_Ex_Planta"."Producto" = 'Propano'
                                    THEN
                                        'Propano Industrial'
                                ELSE "Precios_Ex_Planta"."Producto"
                            END IN ( 
                                'Premium 97 Sp', 
                                'Super 95 Sp', 
                                'Gasoil Comun', 
                                'Gasoil Especial', 
                                'Fuel Oil Pesado', 
                                'Fuel Oil Medio', 
                                'Queroseno Montevideo', 
                                'Queroseno Interior' ) AND
                            "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                            THEN
                                'Precio Ex Planta (PEP)'
                        WHEN 
                            NOT ( CASE 
                                WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                WHEN 
                                    :pProducto: = 'Propano Industrial' AND
                                    "Precios_Ex_Planta"."Producto" = 'Propano'
                                    THEN
                                        'Propano Industrial'
                                ELSE "Precios_Ex_Planta"."Producto"
                            END IN ( 
                                'Premium 97 Sp', 
                                'Super 95 Sp', 
                                'Gasoil Comun', 
                                'Gasoil Especial', 
                                'Fuel Oil Pesado', 
                                'Fuel Oil Medio' ) ) AND
                            "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                            THEN
                                'Precio Ex Planta (PEP)'
                        ELSE "Precios_Ex_Planta"."Concepto"
                    END IN ( 
                        'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                        'Precio Ex Planta (PEP) sin flete secundario (impuestos incluidos)', 
                        'Precio Ex Planta (PEP)' )
                    THEN
                        1
                ELSE 0
            END AS "C13", 
            CASE 
                WHEN 
                    CASE 
                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                        WHEN 
                            :pProducto: = 'Propano Industrial' AND
                            "Precios_Ex_Planta"."Producto" = 'Propano'
                            THEN
                                'Propano Industrial'
                        ELSE "Precios_Ex_Planta"."Producto"
                    END IN ( 
                        'Aguarras', 
                        'Gasolina Av 100 Octanos', 
                        'Gasolina Av 100 Octanos(Estado)', 
                        'Gasolina Av 100 Octanos(Particular)', 
                        'Jet A1', 
                        'Solvente 1197', 
                        'Disan', 
                        'Base insecticida', 
                        'Querosol', 
                        'Queroseno Montevideo', 
                        'Queroseno Interior', 
                        'Hexano Comercial' ) AND
                    CASE 
                        WHEN 
                            CASE 
                                WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                WHEN 
                                    :pProducto: = 'Propano Industrial' AND
                                    "Precios_Ex_Planta"."Producto" = 'Propano'
                                    THEN
                                        'Propano Industrial'
                                ELSE "Precios_Ex_Planta"."Producto"
                            END IN ( 
                                'Premium 97 Sp', 
                                'Super 95 Sp', 
                                'Gasoil Comun', 
                                'Gasoil Especial', 
                                'Fuel Oil Pesado', 
                                'Fuel Oil Medio', 
                                'Queroseno Montevideo', 
                                'Queroseno Interior' ) AND
                            "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                            THEN
                                'Precio Ex Planta (PEP)'
                        WHEN 
                            NOT ( CASE 
                                WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                WHEN 
                                    :pProducto: = 'Propano Industrial' AND
                                    "Precios_Ex_Planta"."Producto" = 'Propano'
                                    THEN
                                        'Propano Industrial'
                                ELSE "Precios_Ex_Planta"."Producto"
                            END IN ( 
                                'Premium 97 Sp', 
                                'Super 95 Sp', 
                                'Gasoil Comun', 
                                'Gasoil Especial', 
                                'Fuel Oil Pesado', 
                                'Fuel Oil Medio' ) ) AND
                            "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                            THEN
                                'Precio Ex Planta (PEP)'
                        ELSE "Precios_Ex_Planta"."Concepto"
                    END IN ( 
                        'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                        'Precio Ex Planta (PEP) (impuestos incluidos)', 
                        'Precio Ex Planta (PEP)' )
                    THEN
                        1
                ELSE 0
            END AS "C14", 
            CASE 
                WHEN 
                    CASE 
                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                        WHEN 
                            :pProducto: = 'Propano Industrial' AND
                            "Precios_Ex_Planta"."Producto" = 'Propano'
                            THEN
                                'Propano Industrial'
                        ELSE "Precios_Ex_Planta"."Producto"
                    END IN ( 
                        'Fuel Oil Medio', 
                        'Fuel Oil Pesado' ) AND
                    CASE 
                        WHEN 
                            CASE 
                                WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                WHEN 
                                    :pProducto: = 'Propano Industrial' AND
                                    "Precios_Ex_Planta"."Producto" = 'Propano'
                                    THEN
                                        'Propano Industrial'
                                ELSE "Precios_Ex_Planta"."Producto"
                            END IN ( 
                                'Premium 97 Sp', 
                                'Super 95 Sp', 
                                'Gasoil Comun', 
                                'Gasoil Especial', 
                                'Fuel Oil Pesado', 
                                'Fuel Oil Medio', 
                                'Queroseno Montevideo', 
                                'Queroseno Interior' ) AND
                            "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                            THEN
                                'Precio Ex Planta (PEP)'
                        WHEN 
                            NOT ( CASE 
                                WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                WHEN 
                                    :pProducto: = 'Propano Industrial' AND
                                    "Precios_Ex_Planta"."Producto" = 'Propano'
                                    THEN
                                        'Propano Industrial'
                                ELSE "Precios_Ex_Planta"."Producto"
                            END IN ( 
                                'Premium 97 Sp', 
                                'Super 95 Sp', 
                                'Gasoil Comun', 
                                'Gasoil Especial', 
                                'Fuel Oil Pesado', 
                                'Fuel Oil Medio' ) ) AND
                            "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                            THEN
                                'Precio Ex Planta (PEP)'
                        ELSE "Precios_Ex_Planta"."Concepto"
                    END IN ( 
                        'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                        'Precio Ex Planta (PEP) (impuestos incluidos)', 
                        'Precio Ex Planta (PEP)', 
                        'Factor X o factor de ajuste', 
                        'PPI sin tasas e impuestos', 
                        'PPI n-1 Periodo URSEA', 
                        'PPI n-2 Periodo URSEA' )
                    THEN
                        1
                ELSE 0
            END AS "C15", 
            CASE 
                WHEN 
                    CASE 
                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                        WHEN 
                            :pProducto: = 'Propano Industrial' AND
                            "Precios_Ex_Planta"."Producto" = 'Propano'
                            THEN
                                'Propano Industrial'
                        ELSE "Precios_Ex_Planta"."Producto"
                    END IN ( 
                        'Supergas' ) AND
                    CASE 
                        WHEN 
                            CASE 
                                WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                WHEN 
                                    :pProducto: = 'Propano Industrial' AND
                                    "Precios_Ex_Planta"."Producto" = 'Propano'
                                    THEN
                                        'Propano Industrial'
                                ELSE "Precios_Ex_Planta"."Producto"
                            END IN ( 
                                'Premium 97 Sp', 
                                'Super 95 Sp', 
                                'Gasoil Comun', 
                                'Gasoil Especial', 
                                'Fuel Oil Pesado', 
                                'Fuel Oil Medio', 
                                'Queroseno Montevideo', 
                                'Queroseno Interior' ) AND
                            "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                            THEN
                                'Precio Ex Planta (PEP)'
                        WHEN 
                            NOT ( CASE 
                                WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                WHEN 
                                    :pProducto: = 'Propano Industrial' AND
                                    "Precios_Ex_Planta"."Producto" = 'Propano'
                                    THEN
                                        'Propano Industrial'
                                ELSE "Precios_Ex_Planta"."Producto"
                            END IN ( 
                                'Premium 97 Sp', 
                                'Super 95 Sp', 
                                'Gasoil Comun', 
                                'Gasoil Especial', 
                                'Fuel Oil Pesado', 
                                'Fuel Oil Medio' ) ) AND
                            "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                            THEN
                                'Precio Ex Planta (PEP)'
                        ELSE "Precios_Ex_Planta"."Concepto"
                    END IN ( 
                        'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                        'Precio Intermedio Transitorio (PIT) (impuestos incluidos)', 
                        'Precio Ex Planta (PEP) (impuestos incluidos)', 
                        'PEP', 
                        'Factor X o factor de ajuste', 
                        'PPI sin tasas e impuestos', 
                        'Factor d para GLP Dec 205/023', 
                        'PPI n-1 Periodo URSEA', 
                        'PPI n-2 Periodo URSEA' )
                    THEN
                        1
                ELSE 0
            END AS "C16", 
            CASE 
                WHEN 
                    CASE 
                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                        WHEN 
                            :pProducto: = 'Propano Industrial' AND
                            "Precios_Ex_Planta"."Producto" = 'Propano'
                            THEN
                                'Propano Industrial'
                        ELSE "Precios_Ex_Planta"."Producto"
                    END IN ( 
                        'Propano', 
                        'Supergas A Granel', 
                        'Propano Industrial' ) AND
                    CASE 
                        WHEN 
                            CASE 
                                WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                WHEN 
                                    :pProducto: = 'Propano Industrial' AND
                                    "Precios_Ex_Planta"."Producto" = 'Propano'
                                    THEN
                                        'Propano Industrial'
                                ELSE "Precios_Ex_Planta"."Producto"
                            END IN ( 
                                'Premium 97 Sp', 
                                'Super 95 Sp', 
                                'Gasoil Comun', 
                                'Gasoil Especial', 
                                'Fuel Oil Pesado', 
                                'Fuel Oil Medio', 
                                'Queroseno Montevideo', 
                                'Queroseno Interior' ) AND
                            "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                            THEN
                                'Precio Ex Planta (PEP)'
                        WHEN 
                            NOT ( CASE 
                                WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                WHEN 
                                    :pProducto: = 'Propano Industrial' AND
                                    "Precios_Ex_Planta"."Producto" = 'Propano'
                                    THEN
                                        'Propano Industrial'
                                ELSE "Precios_Ex_Planta"."Producto"
                            END IN ( 
                                'Premium 97 Sp', 
                                'Super 95 Sp', 
                                'Gasoil Comun', 
                                'Gasoil Especial', 
                                'Fuel Oil Pesado', 
                                'Fuel Oil Medio' ) ) AND
                            "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                            THEN
                                'Precio Ex Planta (PEP)'
                        ELSE "Precios_Ex_Planta"."Concepto"
                    END IN ( 
                        'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                        'Precio Ex Planta (PEP) (impuestos incluidos)', 
                        'Precio Ex Planta (PEP)', 
                        'Factor X o factor de ajuste', 
                        'PPI sin tasas e impuestos', 
                        'PPI n-1 Periodo URSEA', 
                        'PPI n-2 Periodo URSEA' )
                    THEN
                        1
                ELSE 0
            END AS "C17", 
            CASE 
                WHEN 
                    CASE 
                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                        WHEN 
                            :pProducto: = 'Propano Industrial' AND
                            "Precios_Ex_Planta"."Producto" = 'Propano'
                            THEN
                                'Propano Industrial'
                        ELSE "Precios_Ex_Planta"."Producto"
                    END IN ( 
                        'Queroseno Montevideo' )
                    THEN
                        CASE 
                            WHEN 
                                CASE 
                                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                    WHEN 
                                        :pProducto: = 'Propano Industrial' AND
                                        "Precios_Ex_Planta"."Producto" = 'Propano'
                                        THEN
                                            'Propano Industrial'
                                    ELSE "Precios_Ex_Planta"."Producto"
                                END IN ( 
                                    'Queroseno Montevideo' ) AND
                                CASE 
                                    WHEN 
                                        CASE 
                                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                            WHEN 
                                                :pProducto: = 'Propano Industrial' AND
                                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                                THEN
                                                    'Propano Industrial'
                                            ELSE "Precios_Ex_Planta"."Producto"
                                        END IN ( 
                                            'Premium 97 Sp', 
                                            'Super 95 Sp', 
                                            'Gasoil Comun', 
                                            'Gasoil Especial', 
                                            'Fuel Oil Pesado', 
                                            'Fuel Oil Medio', 
                                            'Queroseno Montevideo', 
                                            'Queroseno Interior' ) AND
                                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    WHEN 
                                        NOT ( CASE 
                                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                            WHEN 
                                                :pProducto: = 'Propano Industrial' AND
                                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                                THEN
                                                    'Propano Industrial'
                                            ELSE "Precios_Ex_Planta"."Producto"
                                        END IN ( 
                                            'Premium 97 Sp', 
                                            'Super 95 Sp', 
                                            'Gasoil Comun', 
                                            'Gasoil Especial', 
                                            'Fuel Oil Pesado', 
                                            'Fuel Oil Medio' ) ) AND
                                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    ELSE "Precios_Ex_Planta"."Concepto"
                                END IN ( 
                                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                    'Precio Intermedio Transitorio (PIT) (impuestos incluidos)', 
                                    'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                    'Precio Ex Planta (PEP)' )
                                THEN
                                    1
                            ELSE 0
                        END
                WHEN 
                    CASE 
                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                        WHEN 
                            :pProducto: = 'Propano Industrial' AND
                            "Precios_Ex_Planta"."Producto" = 'Propano'
                            THEN
                                'Propano Industrial'
                        ELSE "Precios_Ex_Planta"."Producto"
                    END IN ( 
                        'Queroseno Interior' )
                    THEN
                        CASE 
                            WHEN 
                                CASE 
                                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                    WHEN 
                                        :pProducto: = 'Propano Industrial' AND
                                        "Precios_Ex_Planta"."Producto" = 'Propano'
                                        THEN
                                            'Propano Industrial'
                                    ELSE "Precios_Ex_Planta"."Producto"
                                END IN ( 
                                    'Queroseno Interior' ) AND
                                CASE 
                                    WHEN 
                                        CASE 
                                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                            WHEN 
                                                :pProducto: = 'Propano Industrial' AND
                                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                                THEN
                                                    'Propano Industrial'
                                            ELSE "Precios_Ex_Planta"."Producto"
                                        END IN ( 
                                            'Premium 97 Sp', 
                                            'Super 95 Sp', 
                                            'Gasoil Comun', 
                                            'Gasoil Especial', 
                                            'Fuel Oil Pesado', 
                                            'Fuel Oil Medio', 
                                            'Queroseno Montevideo', 
                                            'Queroseno Interior' ) AND
                                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    WHEN 
                                        NOT ( CASE 
                                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                            WHEN 
                                                :pProducto: = 'Propano Industrial' AND
                                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                                THEN
                                                    'Propano Industrial'
                                            ELSE "Precios_Ex_Planta"."Producto"
                                        END IN ( 
                                            'Premium 97 Sp', 
                                            'Super 95 Sp', 
                                            'Gasoil Comun', 
                                            'Gasoil Especial', 
                                            'Fuel Oil Pesado', 
                                            'Fuel Oil Medio' ) ) AND
                                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    ELSE "Precios_Ex_Planta"."Concepto"
                                END IN ( 
                                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                    'Precio Intermedio Transitorio (PIT) (impuestos incluidos)', 
                                    'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                    'Precio Ex Planta (PEP) sin flete secundario (impuestos incluidos)', 
                                    'Precio Ex Planta (PEP)' )
                                THEN
                                    1
                            ELSE 0
                        END
                WHEN 
                    CASE 
                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                        WHEN 
                            :pProducto: = 'Propano Industrial' AND
                            "Precios_Ex_Planta"."Producto" = 'Propano'
                            THEN
                                'Propano Industrial'
                        ELSE "Precios_Ex_Planta"."Producto"
                    END IN ( 
                        'Fuel Oil Medio', 
                        'Fuel Oil Pesado' )
                    THEN
                        CASE 
                            WHEN 
                                CASE 
                                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                    WHEN 
                                        :pProducto: = 'Propano Industrial' AND
                                        "Precios_Ex_Planta"."Producto" = 'Propano'
                                        THEN
                                            'Propano Industrial'
                                    ELSE "Precios_Ex_Planta"."Producto"
                                END IN ( 
                                    'Fuel Oil Medio', 
                                    'Fuel Oil Pesado' ) AND
                                CASE 
                                    WHEN 
                                        CASE 
                                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                            WHEN 
                                                :pProducto: = 'Propano Industrial' AND
                                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                                THEN
                                                    'Propano Industrial'
                                            ELSE "Precios_Ex_Planta"."Producto"
                                        END IN ( 
                                            'Premium 97 Sp', 
                                            'Super 95 Sp', 
                                            'Gasoil Comun', 
                                            'Gasoil Especial', 
                                            'Fuel Oil Pesado', 
                                            'Fuel Oil Medio', 
                                            'Queroseno Montevideo', 
                                            'Queroseno Interior' ) AND
                                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    WHEN 
                                        NOT ( CASE 
                                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                            WHEN 
                                                :pProducto: = 'Propano Industrial' AND
                                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                                THEN
                                                    'Propano Industrial'
                                            ELSE "Precios_Ex_Planta"."Producto"
                                        END IN ( 
                                            'Premium 97 Sp', 
                                            'Super 95 Sp', 
                                            'Gasoil Comun', 
                                            'Gasoil Especial', 
                                            'Fuel Oil Pesado', 
                                            'Fuel Oil Medio' ) ) AND
                                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    ELSE "Precios_Ex_Planta"."Concepto"
                                END IN ( 
                                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                    'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                    'Precio Ex Planta (PEP)', 
                                    'Factor X o factor de ajuste', 
                                    'PPI sin tasas e impuestos', 
                                    'PPI n-1 Periodo URSEA', 
                                    'PPI n-2 Periodo URSEA' )
                                THEN
                                    1
                            ELSE 0
                        END
                WHEN 
                    CASE 
                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                        WHEN 
                            :pProducto: = 'Propano Industrial' AND
                            "Precios_Ex_Planta"."Producto" = 'Propano'
                            THEN
                                'Propano Industrial'
                        ELSE "Precios_Ex_Planta"."Producto"
                    END IN ( 
                        'Butano Desodorizado' )
                    THEN
                        CASE 
                            WHEN 
                                CASE 
                                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                    WHEN 
                                        :pProducto: = 'Propano Industrial' AND
                                        "Precios_Ex_Planta"."Producto" = 'Propano'
                                        THEN
                                            'Propano Industrial'
                                    ELSE "Precios_Ex_Planta"."Producto"
                                END IN ( 
                                    'Butano Desodorizado' ) AND
                                CASE 
                                    WHEN 
                                        CASE 
                                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                            WHEN 
                                                :pProducto: = 'Propano Industrial' AND
                                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                                THEN
                                                    'Propano Industrial'
                                            ELSE "Precios_Ex_Planta"."Producto"
                                        END IN ( 
                                            'Premium 97 Sp', 
                                            'Super 95 Sp', 
                                            'Gasoil Comun', 
                                            'Gasoil Especial', 
                                            'Fuel Oil Pesado', 
                                            'Fuel Oil Medio', 
                                            'Queroseno Montevideo', 
                                            'Queroseno Interior' ) AND
                                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    WHEN 
                                        NOT ( CASE 
                                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                            WHEN 
                                                :pProducto: = 'Propano Industrial' AND
                                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                                THEN
                                                    'Propano Industrial'
                                            ELSE "Precios_Ex_Planta"."Producto"
                                        END IN ( 
                                            'Premium 97 Sp', 
                                            'Super 95 Sp', 
                                            'Gasoil Comun', 
                                            'Gasoil Especial', 
                                            'Fuel Oil Pesado', 
                                            'Fuel Oil Medio' ) ) AND
                                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    ELSE "Precios_Ex_Planta"."Concepto"
                                END IN ( 
                                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                    'Precio Ex Planta (PEP) sin flete secundario (impuestos incluidos)', 
                                    'Precio Ex Planta (PEP)' )
                                THEN
                                    1
                            ELSE 0
                        END
                WHEN 
                    CASE 
                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                        WHEN 
                            :pProducto: = 'Propano Industrial' AND
                            "Precios_Ex_Planta"."Producto" = 'Propano'
                            THEN
                                'Propano Industrial'
                        ELSE "Precios_Ex_Planta"."Producto"
                    END IN ( 
                        'Supergas' )
                    THEN
                        CASE 
                            WHEN 
                                CASE 
                                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                    WHEN 
                                        :pProducto: = 'Propano Industrial' AND
                                        "Precios_Ex_Planta"."Producto" = 'Propano'
                                        THEN
                                            'Propano Industrial'
                                    ELSE "Precios_Ex_Planta"."Producto"
                                END IN ( 
                                    'Supergas' ) AND
                                CASE 
                                    WHEN 
                                        CASE 
                                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                            WHEN 
                                                :pProducto: = 'Propano Industrial' AND
                                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                                THEN
                                                    'Propano Industrial'
                                            ELSE "Precios_Ex_Planta"."Producto"
                                        END IN ( 
                                            'Premium 97 Sp', 
                                            'Super 95 Sp', 
                                            'Gasoil Comun', 
                                            'Gasoil Especial', 
                                            'Fuel Oil Pesado', 
                                            'Fuel Oil Medio', 
                                            'Queroseno Montevideo', 
                                            'Queroseno Interior' ) AND
                                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    WHEN 
                                        NOT ( CASE 
                                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                            WHEN 
                                                :pProducto: = 'Propano Industrial' AND
                                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                                THEN
                                                    'Propano Industrial'
                                            ELSE "Precios_Ex_Planta"."Producto"
                                        END IN ( 
                                            'Premium 97 Sp', 
                                            'Super 95 Sp', 
                                            'Gasoil Comun', 
                                            'Gasoil Especial', 
                                            'Fuel Oil Pesado', 
                                            'Fuel Oil Medio' ) ) AND
                                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    ELSE "Precios_Ex_Planta"."Concepto"
                                END IN ( 
                                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                    'Precio Intermedio Transitorio (PIT) (impuestos incluidos)', 
                                    'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                    'PEP', 
                                    'Factor X o factor de ajuste', 
                                    'PPI sin tasas e impuestos', 
                                    'Factor d para GLP Dec 205/023', 
                                    'PPI n-1 Periodo URSEA', 
                                    'PPI n-2 Periodo URSEA' )
                                THEN
                                    1
                            ELSE 0
                        END
                WHEN 
                    CASE 
                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                        WHEN 
                            :pProducto: = 'Propano Industrial' AND
                            "Precios_Ex_Planta"."Producto" = 'Propano'
                            THEN
                                'Propano Industrial'
                        ELSE "Precios_Ex_Planta"."Producto"
                    END IN ( 
                        'Propano', 
                        'Supergas A Granel', 
                        'Propano Industrial' )
                    THEN
                        CASE 
                            WHEN 
                                CASE 
                                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                    WHEN 
                                        :pProducto: = 'Propano Industrial' AND
                                        "Precios_Ex_Planta"."Producto" = 'Propano'
                                        THEN
                                            'Propano Industrial'
                                    ELSE "Precios_Ex_Planta"."Producto"
                                END IN ( 
                                    'Propano', 
                                    'Supergas A Granel', 
                                    'Propano Industrial' ) AND
                                CASE 
                                    WHEN 
                                        CASE 
                                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                            WHEN 
                                                :pProducto: = 'Propano Industrial' AND
                                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                                THEN
                                                    'Propano Industrial'
                                            ELSE "Precios_Ex_Planta"."Producto"
                                        END IN ( 
                                            'Premium 97 Sp', 
                                            'Super 95 Sp', 
                                            'Gasoil Comun', 
                                            'Gasoil Especial', 
                                            'Fuel Oil Pesado', 
                                            'Fuel Oil Medio', 
                                            'Queroseno Montevideo', 
                                            'Queroseno Interior' ) AND
                                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    WHEN 
                                        NOT ( CASE 
                                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                            WHEN 
                                                :pProducto: = 'Propano Industrial' AND
                                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                                THEN
                                                    'Propano Industrial'
                                            ELSE "Precios_Ex_Planta"."Producto"
                                        END IN ( 
                                            'Premium 97 Sp', 
                                            'Super 95 Sp', 
                                            'Gasoil Comun', 
                                            'Gasoil Especial', 
                                            'Fuel Oil Pesado', 
                                            'Fuel Oil Medio' ) ) AND
                                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    ELSE "Precios_Ex_Planta"."Concepto"
                                END IN ( 
                                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                    'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                    'Precio Ex Planta (PEP)', 
                                    'Factor X o factor de ajuste', 
                                    'PPI sin tasas e impuestos', 
                                    'PPI n-1 Periodo URSEA', 
                                    'PPI n-2 Periodo URSEA' )
                                THEN
                                    1
                            ELSE 0
                        END
                WHEN 
                    CASE 
                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                        WHEN 
                            :pProducto: = 'Propano Industrial' AND
                            "Precios_Ex_Planta"."Producto" = 'Propano'
                            THEN
                                'Propano Industrial'
                        ELSE "Precios_Ex_Planta"."Producto"
                    END IN ( 
                        'Aguarras', 
                        'Gasolina Av 100 Octa', 
                        'Gasolina Av 100 Octanos', 
                        'Gasolina Av 100 Octanos(Estado)', 
                        'Gasolina Av 100 Octanos(Particular)', 
                        'Jet A1', 
                        'Solvente 1197', 
                        'Disan', 
                        'Base insecticida', 
                        'Querosol', 
                        'Hexano Comercial' )
                    THEN
                        CASE 
                            WHEN 
                                CASE 
                                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                    WHEN 
                                        :pProducto: = 'Propano Industrial' AND
                                        "Precios_Ex_Planta"."Producto" = 'Propano'
                                        THEN
                                            'Propano Industrial'
                                    ELSE "Precios_Ex_Planta"."Producto"
                                END IN ( 
                                    'Aguarras', 
                                    'Gasolina Av 100 Octanos', 
                                    'Gasolina Av 100 Octanos(Estado)', 
                                    'Gasolina Av 100 Octanos(Particular)', 
                                    'Jet A1', 
                                    'Solvente 1197', 
                                    'Disan', 
                                    'Base insecticida', 
                                    'Querosol', 
                                    'Queroseno Montevideo', 
                                    'Queroseno Interior', 
                                    'Hexano Comercial' ) AND
                                CASE 
                                    WHEN 
                                        CASE 
                                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                            WHEN 
                                                :pProducto: = 'Propano Industrial' AND
                                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                                THEN
                                                    'Propano Industrial'
                                            ELSE "Precios_Ex_Planta"."Producto"
                                        END IN ( 
                                            'Premium 97 Sp', 
                                            'Super 95 Sp', 
                                            'Gasoil Comun', 
                                            'Gasoil Especial', 
                                            'Fuel Oil Pesado', 
                                            'Fuel Oil Medio', 
                                            'Queroseno Montevideo', 
                                            'Queroseno Interior' ) AND
                                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    WHEN 
                                        NOT ( CASE 
                                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                            WHEN 
                                                :pProducto: = 'Propano Industrial' AND
                                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                                THEN
                                                    'Propano Industrial'
                                            ELSE "Precios_Ex_Planta"."Producto"
                                        END IN ( 
                                            'Premium 97 Sp', 
                                            'Super 95 Sp', 
                                            'Gasoil Comun', 
                                            'Gasoil Especial', 
                                            'Fuel Oil Pesado', 
                                            'Fuel Oil Medio' ) ) AND
                                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    ELSE "Precios_Ex_Planta"."Concepto"
                                END IN ( 
                                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                    'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                    'Precio Ex Planta (PEP)' )
                                THEN
                                    1
                            ELSE 0
                        END
                WHEN 
                    CASE 
                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                        WHEN 
                            :pProducto: = 'Propano Industrial' AND
                            "Precios_Ex_Planta"."Producto" = 'Propano'
                            THEN
                                'Propano Industrial'
                        ELSE "Precios_Ex_Planta"."Producto"
                    END IN ( 
                        'Super 95 Sp', 
                        'Gasoil Comun', 
                        'Gasoil Especial', 
                        'Premium 97 Sp' )
                    THEN
                        1
                ELSE 0
            END AS "C18", 
            CASE 
                
                CASE 
                    WHEN 
                        CASE 
                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                            WHEN 
                                :pProducto: = 'Propano Industrial' AND
                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                THEN
                                    'Propano Industrial'
                            ELSE "Precios_Ex_Planta"."Producto"
                        END IN ( 
                            'Premium 97 Sp', 
                            'Super 95 Sp', 
                            'Gasoil Comun', 
                            'Gasoil Especial', 
                            'Fuel Oil Pesado', 
                            'Fuel Oil Medio', 
                            'Queroseno Montevideo', 
                            'Queroseno Interior' ) AND
                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                        THEN
                            'Precio Ex Planta (PEP)'
                    WHEN 
                        NOT ( CASE 
                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                            WHEN 
                                :pProducto: = 'Propano Industrial' AND
                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                THEN
                                    'Propano Industrial'
                            ELSE "Precios_Ex_Planta"."Producto"
                        END IN ( 
                            'Premium 97 Sp', 
                            'Super 95 Sp', 
                            'Gasoil Comun', 
                            'Gasoil Especial', 
                            'Fuel Oil Pesado', 
                            'Fuel Oil Medio' ) ) AND
                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                        THEN
                            'Precio Ex Planta (PEP)'
                    ELSE "Precios_Ex_Planta"."Concepto"
                END
                WHEN 'Precio de Venta al Público (PVP) (impuestos incluidos)' THEN 1
                WHEN 'Precio Intermedio Transitorio (PIT) (impuestos incluidos)' THEN 2
                WHEN 'Precio Ex Planta (PEP) (impuestos incluidos)' THEN 3
                WHEN 'Precio Ex Planta (PEP) sin flete secundario (impuestos incluidos)' THEN 4
                WHEN 'PPI sin tasas e impuestos + Factor X' THEN 5
                WHEN 'Precio Ex Planta (PEP)' THEN 6
                WHEN 'PEP' THEN 6
                WHEN 'Precio ex planta (netback PVP)' THEN 6
                WHEN 'Factor X o factor de ajuste' THEN 7
                WHEN 'PPI sin tasas e impuestos' THEN 8
                WHEN 'Monto diferencial por zonas "d"' THEN 9
                WHEN 'PPI n-1 Periodo URSEA' THEN 10
                WHEN 'PPI n-2 Periodo URSEA' THEN 11
                ELSE 9
            END AS "C19", 
            CASE 
                
                CASE 
                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                    WHEN 
                        :pProducto: = 'Propano Industrial' AND
                        "Precios_Ex_Planta"."Producto" = 'Propano'
                        THEN
                            'Propano Industrial'
                    ELSE "Precios_Ex_Planta"."Producto"
                END
                WHEN 'Supergas' THEN '$/kg'
                WHEN 'Supergas A Granel' THEN '$/kg'
                WHEN 'Propano Industrial' THEN '$/kg'
                WHEN 'Propano Redes' THEN '$/kg'
                WHEN 'Asfalto AC-20' THEN '$/kg'
                WHEN 'Asfalto 150/200' THEN '$/kg'
                WHEN 'Asfalto MC1' THEN '$/kg'
                WHEN 'Asfalto RC2' THEN '$/kg'
                WHEN 'Butano Desodorizado' THEN '$/kg'
                ELSE '$/lt'
            END AS "C20", 
            "Precios_Ex_Planta"."TC" AS "C21", 
            "Precios_Ex_Planta"."Valor" AS "C22"
        FROM
            "APPBI"."DP"."Precios_Ex_Planta" "Precios_Ex_Planta" 
        WHERE 
            CAST(DATEPART(YEAR, "Precios_Ex_Planta"."Fecha") AS INTEGER) = :pAño: AND
            "Precios_Ex_Planta"."Concepto" IN ( 
                'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                'Precio Intermedio Transitorio (PIT) (impuestos incluidos)', 
                'Precio Ex Planta (PEP) (impuestos incluidos)', 
                'Precio Ex Planta (PEP) sin flete secundario (impuestos incluidos)', 
                'PPI sin tasas e impuestos + Factor X', 
                'Factor X o factor de ajuste', 
                'PPI sin tasas e impuestos', 
                'Precio Ex Planta (PEP)', 
                'Factor d para GLP Dec 205/023', 
                'PEP', 
                'PPI n-1 Periodo URSEA', 
                'PPI n-2 Periodo URSEA' ) AND
            :pUnidad: = :pUnidad: AND
            CAST(
                CASE 
                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                    WHEN 
                        :pProducto: = 'Propano Industrial' AND
                        "Precios_Ex_Planta"."Producto" = 'Propano'
                        THEN
                            'Propano Industrial'
                    ELSE "Precios_Ex_Planta"."Producto"
                END AS VARCHAR(50)) = :pProducto: AND
            CASE 
                WHEN 
                    CASE 
                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                        WHEN 
                            :pProducto: = 'Propano Industrial' AND
                            "Precios_Ex_Planta"."Producto" = 'Propano'
                            THEN
                                'Propano Industrial'
                        ELSE "Precios_Ex_Planta"."Producto"
                    END IN ( 
                        'Queroseno Montevideo' )
                    THEN
                        CASE 
                            WHEN 
                                CASE 
                                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                    WHEN 
                                        :pProducto: = 'Propano Industrial' AND
                                        "Precios_Ex_Planta"."Producto" = 'Propano'
                                        THEN
                                            'Propano Industrial'
                                    ELSE "Precios_Ex_Planta"."Producto"
                                END IN ( 
                                    'Queroseno Montevideo' ) AND
                                CASE 
                                    WHEN 
                                        CASE 
                                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                            WHEN 
                                                :pProducto: = 'Propano Industrial' AND
                                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                                THEN
                                                    'Propano Industrial'
                                            ELSE "Precios_Ex_Planta"."Producto"
                                        END IN ( 
                                            'Premium 97 Sp', 
                                            'Super 95 Sp', 
                                            'Gasoil Comun', 
                                            'Gasoil Especial', 
                                            'Fuel Oil Pesado', 
                                            'Fuel Oil Medio', 
                                            'Queroseno Montevideo', 
                                            'Queroseno Interior' ) AND
                                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    WHEN 
                                        NOT ( CASE 
                                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                            WHEN 
                                                :pProducto: = 'Propano Industrial' AND
                                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                                THEN
                                                    'Propano Industrial'
                                            ELSE "Precios_Ex_Planta"."Producto"
                                        END IN ( 
                                            'Premium 97 Sp', 
                                            'Super 95 Sp', 
                                            'Gasoil Comun', 
                                            'Gasoil Especial', 
                                            'Fuel Oil Pesado', 
                                            'Fuel Oil Medio' ) ) AND
                                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    ELSE "Precios_Ex_Planta"."Concepto"
                                END IN ( 
                                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                    'Precio Intermedio Transitorio (PIT) (impuestos incluidos)', 
                                    'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                    'Precio Ex Planta (PEP)' )
                                THEN
                                    1
                            ELSE 0
                        END
                WHEN 
                    CASE 
                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                        WHEN 
                            :pProducto: = 'Propano Industrial' AND
                            "Precios_Ex_Planta"."Producto" = 'Propano'
                            THEN
                                'Propano Industrial'
                        ELSE "Precios_Ex_Planta"."Producto"
                    END IN ( 
                        'Queroseno Interior' )
                    THEN
                        CASE 
                            WHEN 
                                CASE 
                                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                    WHEN 
                                        :pProducto: = 'Propano Industrial' AND
                                        "Precios_Ex_Planta"."Producto" = 'Propano'
                                        THEN
                                            'Propano Industrial'
                                    ELSE "Precios_Ex_Planta"."Producto"
                                END IN ( 
                                    'Queroseno Interior' ) AND
                                CASE 
                                    WHEN 
                                        CASE 
                                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                            WHEN 
                                                :pProducto: = 'Propano Industrial' AND
                                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                                THEN
                                                    'Propano Industrial'
                                            ELSE "Precios_Ex_Planta"."Producto"
                                        END IN ( 
                                            'Premium 97 Sp', 
                                            'Super 95 Sp', 
                                            'Gasoil Comun', 
                                            'Gasoil Especial', 
                                            'Fuel Oil Pesado', 
                                            'Fuel Oil Medio', 
                                            'Queroseno Montevideo', 
                                            'Queroseno Interior' ) AND
                                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    WHEN 
                                        NOT ( CASE 
                                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                            WHEN 
                                                :pProducto: = 'Propano Industrial' AND
                                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                                THEN
                                                    'Propano Industrial'
                                            ELSE "Precios_Ex_Planta"."Producto"
                                        END IN ( 
                                            'Premium 97 Sp', 
                                            'Super 95 Sp', 
                                            'Gasoil Comun', 
                                            'Gasoil Especial', 
                                            'Fuel Oil Pesado', 
                                            'Fuel Oil Medio' ) ) AND
                                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    ELSE "Precios_Ex_Planta"."Concepto"
                                END IN ( 
                                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                    'Precio Intermedio Transitorio (PIT) (impuestos incluidos)', 
                                    'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                    'Precio Ex Planta (PEP) sin flete secundario (impuestos incluidos)', 
                                    'Precio Ex Planta (PEP)' )
                                THEN
                                    1
                            ELSE 0
                        END
                WHEN 
                    CASE 
                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                        WHEN 
                            :pProducto: = 'Propano Industrial' AND
                            "Precios_Ex_Planta"."Producto" = 'Propano'
                            THEN
                                'Propano Industrial'
                        ELSE "Precios_Ex_Planta"."Producto"
                    END IN ( 
                        'Fuel Oil Medio', 
                        'Fuel Oil Pesado' )
                    THEN
                        CASE 
                            WHEN 
                                CASE 
                                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                    WHEN 
                                        :pProducto: = 'Propano Industrial' AND
                                        "Precios_Ex_Planta"."Producto" = 'Propano'
                                        THEN
                                            'Propano Industrial'
                                    ELSE "Precios_Ex_Planta"."Producto"
                                END IN ( 
                                    'Fuel Oil Medio', 
                                    'Fuel Oil Pesado' ) AND
                                CASE 
                                    WHEN 
                                        CASE 
                                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                            WHEN 
                                                :pProducto: = 'Propano Industrial' AND
                                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                                THEN
                                                    'Propano Industrial'
                                            ELSE "Precios_Ex_Planta"."Producto"
                                        END IN ( 
                                            'Premium 97 Sp', 
                                            'Super 95 Sp', 
                                            'Gasoil Comun', 
                                            'Gasoil Especial', 
                                            'Fuel Oil Pesado', 
                                            'Fuel Oil Medio', 
                                            'Queroseno Montevideo', 
                                            'Queroseno Interior' ) AND
                                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    WHEN 
                                        NOT ( CASE 
                                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                            WHEN 
                                                :pProducto: = 'Propano Industrial' AND
                                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                                THEN
                                                    'Propano Industrial'
                                            ELSE "Precios_Ex_Planta"."Producto"
                                        END IN ( 
                                            'Premium 97 Sp', 
                                            'Super 95 Sp', 
                                            'Gasoil Comun', 
                                            'Gasoil Especial', 
                                            'Fuel Oil Pesado', 
                                            'Fuel Oil Medio' ) ) AND
                                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    ELSE "Precios_Ex_Planta"."Concepto"
                                END IN ( 
                                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                    'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                    'Precio Ex Planta (PEP)', 
                                    'Factor X o factor de ajuste', 
                                    'PPI sin tasas e impuestos', 
                                    'PPI n-1 Periodo URSEA', 
                                    'PPI n-2 Periodo URSEA' )
                                THEN
                                    1
                            ELSE 0
                        END
                WHEN 
                    CASE 
                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                        WHEN 
                            :pProducto: = 'Propano Industrial' AND
                            "Precios_Ex_Planta"."Producto" = 'Propano'
                            THEN
                                'Propano Industrial'
                        ELSE "Precios_Ex_Planta"."Producto"
                    END IN ( 
                        'Butano Desodorizado' )
                    THEN
                        CASE 
                            WHEN 
                                CASE 
                                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                    WHEN 
                                        :pProducto: = 'Propano Industrial' AND
                                        "Precios_Ex_Planta"."Producto" = 'Propano'
                                        THEN
                                            'Propano Industrial'
                                    ELSE "Precios_Ex_Planta"."Producto"
                                END IN ( 
                                    'Butano Desodorizado' ) AND
                                CASE 
                                    WHEN 
                                        CASE 
                                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                            WHEN 
                                                :pProducto: = 'Propano Industrial' AND
                                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                                THEN
                                                    'Propano Industrial'
                                            ELSE "Precios_Ex_Planta"."Producto"
                                        END IN ( 
                                            'Premium 97 Sp', 
                                            'Super 95 Sp', 
                                            'Gasoil Comun', 
                                            'Gasoil Especial', 
                                            'Fuel Oil Pesado', 
                                            'Fuel Oil Medio', 
                                            'Queroseno Montevideo', 
                                            'Queroseno Interior' ) AND
                                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    WHEN 
                                        NOT ( CASE 
                                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                            WHEN 
                                                :pProducto: = 'Propano Industrial' AND
                                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                                THEN
                                                    'Propano Industrial'
                                            ELSE "Precios_Ex_Planta"."Producto"
                                        END IN ( 
                                            'Premium 97 Sp', 
                                            'Super 95 Sp', 
                                            'Gasoil Comun', 
                                            'Gasoil Especial', 
                                            'Fuel Oil Pesado', 
                                            'Fuel Oil Medio' ) ) AND
                                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    ELSE "Precios_Ex_Planta"."Concepto"
                                END IN ( 
                                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                    'Precio Ex Planta (PEP) sin flete secundario (impuestos incluidos)', 
                                    'Precio Ex Planta (PEP)' )
                                THEN
                                    1
                            ELSE 0
                        END
                WHEN 
                    CASE 
                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                        WHEN 
                            :pProducto: = 'Propano Industrial' AND
                            "Precios_Ex_Planta"."Producto" = 'Propano'
                            THEN
                                'Propano Industrial'
                        ELSE "Precios_Ex_Planta"."Producto"
                    END IN ( 
                        'Supergas' )
                    THEN
                        CASE 
                            WHEN 
                                CASE 
                                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                    WHEN 
                                        :pProducto: = 'Propano Industrial' AND
                                        "Precios_Ex_Planta"."Producto" = 'Propano'
                                        THEN
                                            'Propano Industrial'
                                    ELSE "Precios_Ex_Planta"."Producto"
                                END IN ( 
                                    'Supergas' ) AND
                                CASE 
                                    WHEN 
                                        CASE 
                                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                            WHEN 
                                                :pProducto: = 'Propano Industrial' AND
                                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                                THEN
                                                    'Propano Industrial'
                                            ELSE "Precios_Ex_Planta"."Producto"
                                        END IN ( 
                                            'Premium 97 Sp', 
                                            'Super 95 Sp', 
                                            'Gasoil Comun', 
                                            'Gasoil Especial', 
                                            'Fuel Oil Pesado', 
                                            'Fuel Oil Medio', 
                                            'Queroseno Montevideo', 
                                            'Queroseno Interior' ) AND
                                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    WHEN 
                                        NOT ( CASE 
                                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                            WHEN 
                                                :pProducto: = 'Propano Industrial' AND
                                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                                THEN
                                                    'Propano Industrial'
                                            ELSE "Precios_Ex_Planta"."Producto"
                                        END IN ( 
                                            'Premium 97 Sp', 
                                            'Super 95 Sp', 
                                            'Gasoil Comun', 
                                            'Gasoil Especial', 
                                            'Fuel Oil Pesado', 
                                            'Fuel Oil Medio' ) ) AND
                                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    ELSE "Precios_Ex_Planta"."Concepto"
                                END IN ( 
                                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                    'Precio Intermedio Transitorio (PIT) (impuestos incluidos)', 
                                    'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                    'PEP', 
                                    'Factor X o factor de ajuste', 
                                    'PPI sin tasas e impuestos', 
                                    'Factor d para GLP Dec 205/023', 
                                    'PPI n-1 Periodo URSEA', 
                                    'PPI n-2 Periodo URSEA' )
                                THEN
                                    1
                            ELSE 0
                        END
                WHEN 
                    CASE 
                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                        WHEN 
                            :pProducto: = 'Propano Industrial' AND
                            "Precios_Ex_Planta"."Producto" = 'Propano'
                            THEN
                                'Propano Industrial'
                        ELSE "Precios_Ex_Planta"."Producto"
                    END IN ( 
                        'Propano', 
                        'Supergas A Granel', 
                        'Propano Industrial' )
                    THEN
                        CASE 
                            WHEN 
                                CASE 
                                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                    WHEN 
                                        :pProducto: = 'Propano Industrial' AND
                                        "Precios_Ex_Planta"."Producto" = 'Propano'
                                        THEN
                                            'Propano Industrial'
                                    ELSE "Precios_Ex_Planta"."Producto"
                                END IN ( 
                                    'Propano', 
                                    'Supergas A Granel', 
                                    'Propano Industrial' ) AND
                                CASE 
                                    WHEN 
                                        CASE 
                                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                            WHEN 
                                                :pProducto: = 'Propano Industrial' AND
                                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                                THEN
                                                    'Propano Industrial'
                                            ELSE "Precios_Ex_Planta"."Producto"
                                        END IN ( 
                                            'Premium 97 Sp', 
                                            'Super 95 Sp', 
                                            'Gasoil Comun', 
                                            'Gasoil Especial', 
                                            'Fuel Oil Pesado', 
                                            'Fuel Oil Medio', 
                                            'Queroseno Montevideo', 
                                            'Queroseno Interior' ) AND
                                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    WHEN 
                                        NOT ( CASE 
                                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                            WHEN 
                                                :pProducto: = 'Propano Industrial' AND
                                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                                THEN
                                                    'Propano Industrial'
                                            ELSE "Precios_Ex_Planta"."Producto"
                                        END IN ( 
                                            'Premium 97 Sp', 
                                            'Super 95 Sp', 
                                            'Gasoil Comun', 
                                            'Gasoil Especial', 
                                            'Fuel Oil Pesado', 
                                            'Fuel Oil Medio' ) ) AND
                                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    ELSE "Precios_Ex_Planta"."Concepto"
                                END IN ( 
                                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                    'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                    'Precio Ex Planta (PEP)', 
                                    'Factor X o factor de ajuste', 
                                    'PPI sin tasas e impuestos', 
                                    'PPI n-1 Periodo URSEA', 
                                    'PPI n-2 Periodo URSEA' )
                                THEN
                                    1
                            ELSE 0
                        END
                WHEN 
                    CASE 
                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                        WHEN 
                            :pProducto: = 'Propano Industrial' AND
                            "Precios_Ex_Planta"."Producto" = 'Propano'
                            THEN
                                'Propano Industrial'
                        ELSE "Precios_Ex_Planta"."Producto"
                    END IN ( 
                        'Aguarras', 
                        'Gasolina Av 100 Octa', 
                        'Gasolina Av 100 Octanos', 
                        'Gasolina Av 100 Octanos(Estado)', 
                        'Gasolina Av 100 Octanos(Particular)', 
                        'Jet A1', 
                        'Solvente 1197', 
                        'Disan', 
                        'Base insecticida', 
                        'Querosol', 
                        'Hexano Comercial' )
                    THEN
                        CASE 
                            WHEN 
                                CASE 
                                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                    WHEN 
                                        :pProducto: = 'Propano Industrial' AND
                                        "Precios_Ex_Planta"."Producto" = 'Propano'
                                        THEN
                                            'Propano Industrial'
                                    ELSE "Precios_Ex_Planta"."Producto"
                                END IN ( 
                                    'Aguarras', 
                                    'Gasolina Av 100 Octanos', 
                                    'Gasolina Av 100 Octanos(Estado)', 
                                    'Gasolina Av 100 Octanos(Particular)', 
                                    'Jet A1', 
                                    'Solvente 1197', 
                                    'Disan', 
                                    'Base insecticida', 
                                    'Querosol', 
                                    'Queroseno Montevideo', 
                                    'Queroseno Interior', 
                                    'Hexano Comercial' ) AND
                                CASE 
                                    WHEN 
                                        CASE 
                                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                            WHEN 
                                                :pProducto: = 'Propano Industrial' AND
                                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                                THEN
                                                    'Propano Industrial'
                                            ELSE "Precios_Ex_Planta"."Producto"
                                        END IN ( 
                                            'Premium 97 Sp', 
                                            'Super 95 Sp', 
                                            'Gasoil Comun', 
                                            'Gasoil Especial', 
                                            'Fuel Oil Pesado', 
                                            'Fuel Oil Medio', 
                                            'Queroseno Montevideo', 
                                            'Queroseno Interior' ) AND
                                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    WHEN 
                                        NOT ( CASE 
                                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                            WHEN 
                                                :pProducto: = 'Propano Industrial' AND
                                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                                THEN
                                                    'Propano Industrial'
                                            ELSE "Precios_Ex_Planta"."Producto"
                                        END IN ( 
                                            'Premium 97 Sp', 
                                            'Super 95 Sp', 
                                            'Gasoil Comun', 
                                            'Gasoil Especial', 
                                            'Fuel Oil Pesado', 
                                            'Fuel Oil Medio' ) ) AND
                                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    ELSE "Precios_Ex_Planta"."Concepto"
                                END IN ( 
                                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                    'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                    'Precio Ex Planta (PEP)' )
                                THEN
                                    1
                            ELSE 0
                        END
                WHEN 
                    CASE 
                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                        WHEN 
                            :pProducto: = 'Propano Industrial' AND
                            "Precios_Ex_Planta"."Producto" = 'Propano'
                            THEN
                                'Propano Industrial'
                        ELSE "Precios_Ex_Planta"."Producto"
                    END IN ( 
                        'Super 95 Sp', 
                        'Gasoil Comun', 
                        'Gasoil Especial', 
                        'Premium 97 Sp' )
                    THEN
                        1
                ELSE 0
            END = 1
        ) "D1" 
    GROUP BY 
        "D1"."C0", 
        "D1"."C1", 
        "D1"."C2", 
        "D1"."C3", 
        "D1"."C4", 
        "D1"."C5", 
        "D1"."C6", 
        "D1"."C7", 
        "D1"."C8", 
        "D1"."C9", 
        "D1"."C10", 
        "D1"."C11", 
        "D1"."C12", 
        "D1"."C13", 
        "D1"."C14", 
        "D1"."C15", 
        "D1"."C16", 
        "D1"."C17", 
        "D1"."C18", 
        "D1"."C19", 
        "D1"."C20"
    ), 
"Densidades" AS 
    (
    SELECT
        "D1"."C0" AS "pAño", 
        "D1"."C1" AS "Número", 
        "D1"."C2" AS "Producto", 
        "D1"."C3" AS "Medidas_ExPlanta", 
        "D1"."C4" AS "Fecha", 
        SUM("D1"."C6") AS "Densidad", 
        0 AS "Precio_Ex_Planta_USD", 
        0 AS "TC", 
        0 AS "Precio_Ex_Planta_UYU", 
        "D1"."C5" AS "Dia", 
        0 AS "Orden"
    FROM
        (
        SELECT
            "Densidades_datos"."pAño" AS "C0", 
            "Densidades_datos"."Número" AS "C1", 
            "Densidades_datos"."Producto" AS "C2", 
            "Densidades_datos"."Medidas_ExPlanta" AS "C3", 
            CONVERT(DATETIME, CONVERT(VARCHAR(8), (("Densidades_datos"."pAño") * 10000) + (("Densidades_datos"."Número") * 100) + 1)) AS "C4", 
            "Densidades_datos"."Dia" AS "C5", 
            "Densidades_datos"."Densidad" AS "C6"
        FROM
            "Densidades_datos" 
        WHERE 
            "Densidades_datos"."Medidas_ExPlanta" = 'Densidad' AND
            "Densidades_datos"."Producto" = :pProducto:
        ) "D1" 
    GROUP BY 
        "D1"."C0", 
        "D1"."C1", 
        "D1"."C2", 
        "D1"."C3", 
        "D1"."C4", 
        "D1"."C5"
    ), 
"Ex_Planta_Nuevo_FORMATO" AS 
    (
    SELECT
        "Ex_Planta_Planilla"."Año" AS "Año", 
        "Ex_Planta_Planilla"."Fecha" AS "Fecha", 
        "Ex_Planta_Planilla"."Dia" AS "Dia", 
        "Ex_Planta_Planilla"."Concepto2" AS "Concepto2", 
        SUM(
            CASE 
                WHEN "Ex_Planta_Planilla"."Año" > 2021 THEN 0
                ELSE "Ex_Planta_Planilla"."TC"
            END) AS "TC", 
        SUM("Ex_Planta_Planilla"."Valor") AS "Valor", 
        SUM("Ex_Planta_Planilla"."Valor_USD_m3") AS "Valor_USD_m3", 
        "Ex_Planta_Planilla"."Orden" AS "Orden", 
        "Ex_Planta_Planilla"."Producto" AS "Producto"
    FROM
        "Ex_Planta_Planilla" 
    GROUP BY 
        "Ex_Planta_Planilla"."Año", 
        "Ex_Planta_Planilla"."Fecha", 
        "Ex_Planta_Planilla"."Dia", 
        "Ex_Planta_Planilla"."Concepto2", 
        "Ex_Planta_Planilla"."Orden", 
        "Ex_Planta_Planilla"."Producto"
    ), 
"SQ1_Ex_Planta_Planilla_FINAL" AS 
    (
    SELECT
        "Unión1"."Fecha" AS "C", 
        MAX("Unión1"."TC") AS "Valor_USD_m3"
    FROM
        (
        SELECT
            "Cotizaciones_FORMATO"."Año", 
            "Cotizaciones_FORMATO"."Fecha", 
            "Cotizaciones_FORMATO"."Dia", 
            "Cotizaciones_FORMATO"."Concepto2", 
            "Cotizaciones_FORMATO"."TC", 
            "Cotizaciones_FORMATO"."Valor", 
            "Cotizaciones_FORMATO"."Valor_USD_m3", 
            "Cotizaciones_FORMATO"."Orden", 
            "Cotizaciones_FORMATO"."Productos_ExPlanta"
        FROM
            "Cotizaciones_FORMATO"
        
        UNION
        
        SELECT
            "Ex_Planta_Nuevo_FORMATO"."Año", 
            "Ex_Planta_Nuevo_FORMATO"."Fecha", 
            "Ex_Planta_Nuevo_FORMATO"."Dia", 
            "Ex_Planta_Nuevo_FORMATO"."Concepto2", 
            "Ex_Planta_Nuevo_FORMATO"."TC", 
            "Ex_Planta_Nuevo_FORMATO"."Valor", 
            "Ex_Planta_Nuevo_FORMATO"."Valor_USD_m3", 
            "Ex_Planta_Nuevo_FORMATO"."Orden", 
            "Ex_Planta_Nuevo_FORMATO"."Producto"
        FROM
            "Ex_Planta_Nuevo_FORMATO"
        ) "Unión1"("Año", "Fecha", "Dia", "Concepto2", "TC", "Valor", "Valor_USD_m3", "Orden", "Productos_ExPlanta") 
    WHERE 
        "Unión1"."Productos_ExPlanta" = :pProducto: 
    GROUP BY 
        "Unión1"."Fecha"
    ), 
"TQ0_Ex_Planta_Planilla_FINAL" AS 
    (
    SELECT
        "Unión1"."Año" AS "Año", 
        month("Unión1"."Fecha") AS "Numero", 
        "Unión1"."Productos_ExPlanta" AS "Producto", 
        "Unión1"."Concepto2" AS "Concepto2", 
        "Unión1"."Fecha" AS "Fecha", 
        0 AS "Densidad", 
        "Unión1"."Dia" AS "Dia", 
        "Unión1"."Valor" AS "Valor", 
        "Unión1"."Orden" AS "Orden", 
        "Unión1"."TC" AS "TC"
    FROM
        (
        SELECT
            "Cotizaciones_FORMATO"."Año", 
            "Cotizaciones_FORMATO"."Fecha", 
            "Cotizaciones_FORMATO"."Dia", 
            "Cotizaciones_FORMATO"."Concepto2", 
            "Cotizaciones_FORMATO"."TC", 
            "Cotizaciones_FORMATO"."Valor", 
            "Cotizaciones_FORMATO"."Valor_USD_m3", 
            "Cotizaciones_FORMATO"."Orden", 
            "Cotizaciones_FORMATO"."Productos_ExPlanta"
        FROM
            "Cotizaciones_FORMATO"
        
        UNION
        
        SELECT
            "Ex_Planta_Nuevo_FORMATO"."Año", 
            "Ex_Planta_Nuevo_FORMATO"."Fecha", 
            "Ex_Planta_Nuevo_FORMATO"."Dia", 
            "Ex_Planta_Nuevo_FORMATO"."Concepto2", 
            "Ex_Planta_Nuevo_FORMATO"."TC", 
            "Ex_Planta_Nuevo_FORMATO"."Valor", 
            "Ex_Planta_Nuevo_FORMATO"."Valor_USD_m3", 
            "Ex_Planta_Nuevo_FORMATO"."Orden", 
            "Ex_Planta_Nuevo_FORMATO"."Producto"
        FROM
            "Ex_Planta_Nuevo_FORMATO"
        ) "Unión1"("Año", "Fecha", "Dia", "Concepto2", "TC", "Valor", "Valor_USD_m3", "Orden", "Productos_ExPlanta") 
    WHERE 
        "Unión1"."Productos_ExPlanta" = :pProducto:
    ), 
"SQ0_Ex_Planta_Planilla_FINAL" AS 
    (
    SELECT
        "TQ0_Ex_Planta_Planilla_FINAL"."Año" AS "Año", 
        "TQ0_Ex_Planta_Planilla_FINAL"."Numero" AS "Numero", 
        "TQ0_Ex_Planta_Planilla_FINAL"."Producto" AS "Producto", 
        "TQ0_Ex_Planta_Planilla_FINAL"."Concepto2" AS "Concepto2", 
        "TQ0_Ex_Planta_Planilla_FINAL"."Fecha" AS "Fecha", 
        "TQ0_Ex_Planta_Planilla_FINAL"."Densidad" AS "Densidad", 
        "TQ0_Ex_Planta_Planilla_FINAL"."Dia" AS "Dia", 
        SUM(("TQ0_Ex_Planta_Planilla_FINAL"."Valor" / NULLIF("SQ1_Ex_Planta_Planilla_FINAL"."Valor_USD_m3", 0)) * 1000) AS "Valor_USD_m3", 
        SUM("TQ0_Ex_Planta_Planilla_FINAL"."Valor") AS "Valor", 
        SUM("TQ0_Ex_Planta_Planilla_FINAL"."Orden") AS "Orden"
    FROM
        "SQ1_Ex_Planta_Planilla_FINAL", 
        "TQ0_Ex_Planta_Planilla_FINAL" 
    WHERE 
        "TQ0_Ex_Planta_Planilla_FINAL"."Fecha" = "SQ1_Ex_Planta_Planilla_FINAL"."C" OR ("TQ0_Ex_Planta_Planilla_FINAL"."Fecha" IS NULL AND "SQ1_Ex_Planta_Planilla_FINAL"."C" IS NULL) 
    GROUP BY 
        "TQ0_Ex_Planta_Planilla_FINAL"."Año", 
        "TQ0_Ex_Planta_Planilla_FINAL"."Numero", 
        "TQ0_Ex_Planta_Planilla_FINAL"."Producto", 
        "TQ0_Ex_Planta_Planilla_FINAL"."Concepto2", 
        "TQ0_Ex_Planta_Planilla_FINAL"."Fecha", 
        "TQ0_Ex_Planta_Planilla_FINAL"."Densidad", 
        "TQ0_Ex_Planta_Planilla_FINAL"."Dia"
    ), 
"Ex_Planta_Planilla_FINAL" AS 
    (
    SELECT
        "SQ0_Ex_Planta_Planilla_FINAL"."Año" AS "Año", 
        "SQ0_Ex_Planta_Planilla_FINAL"."Numero" AS "Numero", 
        "SQ0_Ex_Planta_Planilla_FINAL"."Producto" AS "Producto", 
        "SQ0_Ex_Planta_Planilla_FINAL"."Concepto2" AS "Concepto2", 
        "SQ0_Ex_Planta_Planilla_FINAL"."Fecha" AS "Fecha", 
        "SQ0_Ex_Planta_Planilla_FINAL"."Densidad" AS "Densidad", 
        "SQ0_Ex_Planta_Planilla_FINAL"."Valor_USD_m3" AS "Valor_USD_m3", 
        "SQ1_Ex_Planta_Planilla_FINAL"."Valor_USD_m3" AS "TC", 
        "SQ0_Ex_Planta_Planilla_FINAL"."Valor" AS "Valor", 
        "SQ0_Ex_Planta_Planilla_FINAL"."Dia" AS "Dia", 
        "SQ0_Ex_Planta_Planilla_FINAL"."Orden" AS "Orden"
    FROM
        "SQ0_Ex_Planta_Planilla_FINAL", 
        "SQ1_Ex_Planta_Planilla_FINAL" 
    WHERE 
        "SQ1_Ex_Planta_Planilla_FINAL"."C" = "SQ0_Ex_Planta_Planilla_FINAL"."Fecha" OR ("SQ1_Ex_Planta_Planilla_FINAL"."C" IS NULL AND "SQ0_Ex_Planta_Planilla_FINAL"."Fecha" IS NULL)
    )
SELECT
    "Ex_Planta_Planilla_FINAL"."Año" AS "Año", 
    "Ex_Planta_Planilla_FINAL"."Numero" AS "Numero", 
    "Ex_Planta_Planilla_FINAL"."Producto" AS "Producto", 
    "Ex_Planta_Planilla_FINAL"."Concepto2" AS "Concepto2", 
    "Ex_Planta_Planilla_FINAL"."Fecha" AS "Fecha", 
    SUM(
        CASE 
            WHEN 
                "Ex_Planta_Planilla_FINAL"."Producto" IN ( 
                    'Butano Desodorizado', 
                    'Supergas', 
                    'Supergas A Granel', 
                    'Propano', 
                    'Propano Industrial' )
                THEN
                    "Ex_Planta_Planilla_FINAL"."Valor_USD_m3" * "Densidades"."Densidad"
            ELSE "Ex_Planta_Planilla_FINAL"."Valor_USD_m3"
        END) AS "Valor_USD_m3", 
    MAX("Ex_Planta_Planilla_FINAL"."TC") AS "TC", 
    SUM("Ex_Planta_Planilla_FINAL"."Valor") AS "Valor", 
    "Ex_Planta_Planilla_FINAL"."Dia" AS "Dia", 
    "Ex_Planta_Planilla_FINAL"."Orden" AS "Orden", 
    SUM("Densidades"."Densidad") AS "Densidad"
FROM
    "Ex_Planta_Planilla_FINAL"
        INNER JOIN "Densidades"
        ON 
            "Ex_Planta_Planilla_FINAL"."Año" = "Densidades"."pAño" AND
            "Ex_Planta_Planilla_FINAL"."Numero" = "Densidades"."Número" AND
            "Ex_Planta_Planilla_FINAL"."Producto" = "Densidades"."Producto" 
GROUP BY 
    "Ex_Planta_Planilla_FINAL"."Año", 
    "Ex_Planta_Planilla_FINAL"."Numero", 
    "Ex_Planta_Planilla_FINAL"."Producto", 
    "Ex_Planta_Planilla_FINAL"."Concepto2", 
    "Ex_Planta_Planilla_FINAL"."Fecha", 
    "Ex_Planta_Planilla_FINAL"."Dia", 
    "Ex_Planta_Planilla_FINAL"."Orden"