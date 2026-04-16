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
    )
SELECT
    "D1"."C0" AS "Año", 
    "D1"."C1" AS "Fecha", 
    "D1"."C2" AS "Dia", 
    '' AS "Concepto2", 
    "D1"."C3" AS "TC", 
    0 AS "Valor", 
    0 AS "Valor_USD_m3", 
    0 AS "Orden", 
    0 AS "Decimales", 
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