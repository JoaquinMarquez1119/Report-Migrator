SELECT
    "D1"."C0" AS "Años", 
    "D1"."C1" AS "pAño", 
    "D1"."C2" AS "Periodo_Mensual", 
    "D1"."C3" AS "Valor_Mensual", 
    'Productos_ExPlanta' AS "Productos_ExPlanta", 
    "D1"."C4" AS "children__Productos_ExPlanta__", 
    "D1"."C5" AS "Producto", 
    SUM("D1"."C12") AS "Precio_Ex_Planta", 
    SUM("D1"."C13") AS "Densidad", 
    "D1"."C6" AS "Fecha", 
    "D1"."C0" AS "Años___Nombre", 
    "D1"."C7" AS "Mes_Numero_2", 
    "D1"."C8" AS "Año", 
    "D1"."C9" AS "Mes_numero", 
    "D1"."C10" AS "Dia", 
    "D1"."C7" AS "Número", 
    "D1"."C11" AS "Cantidad_dias", 
    "D1"."C1" AS "Número1", 
    "D1"."C3" AS "Periodo_Diario", 
    SUM("D1"."C14") AS "N_A_N_A_N_A_Cotización"
FROM
    (
    SELECT
        "Precios_ExPLanta_2_TM1"."Años" AS "C0", 
        CASE 
            WHEN "Precios_ExPLanta_2_TM1"."Años" <> 'Año Base' THEN CAST("Precios_ExPLanta_2_TM1"."Años" AS INTEGER)
            ELSE NULL
        END AS "C1", 
        "Precios_ExPLanta_2_TM1"."Periodo_Mensual" AS "C2", 
        "Precios_ExPLanta_2_TM1"."Periodo_Diario" AS "C3", 
        "Precios_ExPLanta_2_TM1"."Productos_ExPlanta" AS "C4", 
        CAST("Precios_ExPLanta_2_TM1"."Productos_ExPlanta" AS VARCHAR(20)) AS "C5", 
        (CASE 
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
                    ((CAST(DATEPART(DAY, CAST(CURRENT_TIMESTAMP AS DATE)) AS VARCHAR(2)) + '-') + "Precios_ExPLanta_2_TM1"."Periodo_Mensual")
            ELSE ((CAST(CAST(DATEPART(DAY, DATEADD(DAY, -1, DATEADD(MONTH, 1, DATEADD(DAY, -DAY(CONVERT(DATETIME, CONVERT(VARCHAR(8), (("Precios_ExPLanta_2_TM1"."Años") * 10000) + ((CAST(
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
                END AS INTEGER)) * 100) + 1))) + 1, CONVERT(DATETIME, CONVERT(VARCHAR(8), (("Precios_ExPLanta_2_TM1"."Años") * 10000) + ((CAST(
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
                END AS INTEGER)) * 100) + 1)))))) AS INTEGER) AS VARCHAR(2)) + '-') + "Precios_ExPLanta_2_TM1"."Periodo_Mensual")
        END + '') AS "C6", 
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
        END AS "C7", 
        CASE 
            WHEN "Precios_ExPLanta_2_TM1"."Años" = 'Año Base' THEN 0
            ELSE CAST("Precios_ExPLanta_2_TM1"."Años" AS INTEGER)
        END AS "C8", 
        CAST(
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
            END AS INTEGER) AS "C9", 
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
                    ((CAST(DATEPART(DAY, CAST(CURRENT_TIMESTAMP AS DATE)) AS VARCHAR(2)) + '-') + "Precios_ExPLanta_2_TM1"."Periodo_Mensual")
            ELSE ((CAST(CAST(DATEPART(DAY, DATEADD(DAY, -1, DATEADD(MONTH, 1, DATEADD(DAY, -DAY(CONVERT(DATETIME, CONVERT(VARCHAR(8), (("Precios_ExPLanta_2_TM1"."Años") * 10000) + ((CAST(
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
                END AS INTEGER)) * 100) + 1))) + 1, CONVERT(DATETIME, CONVERT(VARCHAR(8), (("Precios_ExPLanta_2_TM1"."Años") * 10000) + ((CAST(
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
                END AS INTEGER)) * 100) + 1)))))) AS INTEGER) AS VARCHAR(2)) + '-') + "Precios_ExPLanta_2_TM1"."Periodo_Mensual")
        END AS "C10", 
        CAST(DATEPART(DAY, DATEADD(DAY, -1, DATEADD(MONTH, 1, DATEADD(DAY, -DAY(CONVERT(DATETIME, CONVERT(VARCHAR(8), (("Precios_ExPLanta_2_TM1"."Años") * 10000) + ((CAST(
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
            END AS INTEGER)) * 100) + 1))) + 1, CONVERT(DATETIME, CONVERT(VARCHAR(8), (("Precios_ExPLanta_2_TM1"."Años") * 10000) + ((CAST(
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
            END AS INTEGER)) * 100) + 1)))))) AS INTEGER) AS "C11", 
        CASE 
            WHEN "Precios_ExPLanta_2_TM1"."Medidas_ExPlanta" = 'Precio Ex Planta' THEN "Precios_ExPLanta_2_TM1"."Valor"
            ELSE 0
        END AS "C12", 
        CASE 
            WHEN "Precios_ExPLanta_2_TM1"."Medidas_ExPlanta" = 'Densidad' THEN "Precios_ExPLanta_2_TM1"."Valor"
            ELSE 0
        END AS "C13", 
        CASE 
            WHEN 
                "Precios_ExPLanta_2_TM1"."Medidas_ExPlanta" = 'Cotización' AND
                "Precios_ExPLanta_2_TM1"."Mercados" = 'Interno' AND
                "Precios_ExPLanta_2_TM1"."Unidades" = 'N/A'
                THEN
                    "Precios_ExPLanta_2_TM1"."Valor"
            ELSE 0
        END AS "C14"
    FROM
        "APPBI"."DP"."Precios_ExPLanta_2_TM1" "Precios_ExPLanta_2_TM1" 
    WHERE 
        CASE 
            WHEN "Precios_ExPLanta_2_TM1"."Años" <> 'Año Base' THEN CAST("Precios_ExPLanta_2_TM1"."Años" AS INTEGER)
            ELSE NULL
        END = :pAño: AND
        NOT ( CAST("Precios_ExPLanta_2_TM1"."Productos_ExPlanta" AS VARCHAR(20)) LIKE 'RPMS%' ) AND
        "Precios_ExPLanta_2_TM1"."Años" <> 'Año Base' AND
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
    "D1"."C9", 
    "D1"."C10", 
    "D1"."C11"