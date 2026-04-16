SELECT
    "D1"."C0" AS "Productos", 
    "D1"."C1" AS "Años", 
    "D1"."C2" AS "Periodo_Mensual", 
    "D1"."C3" AS "Fecha", 
    "D1"."C4" AS "Mes_Número", 
    "D1"."C5" AS "Mercados", 
    "D1"."C6" AS "Unidades__", 
    "D1"."C7" AS "Unidades_U_S", 
    0 AS "children__Unidades__1", 
    SUM("D1"."C13") AS "Precio_Público", 
    SUM("D1"."C14") AS "Precio_Exonerado", 
    SUM("D1"."C15") AS "IVA", 
    SUM("D1"."C16") AS "Precio_sin_IVA", 
    SUM("D1"."C17") AS "IMESI", 
    SUM("D1"."C18") AS "Cotización_Dólar_Promedio", 
    SUM("D1"."C19") AS "Cotización", 
    SUM("D1"."C20") AS "Precio_sin_impuesto", 
    SUM("D1"."C21") AS "Margen_y_Bonificaciones", 
    SUM("D1"."C22") AS "Tasa_de_Inflamable", 
    SUM("D1"."C23") AS "Tasa_de_URSEA", 
    SUM("D1"."C24") AS "Fideicomiso", 
    SUM("D1"."C25") AS "Flete", 
    SUM("D1"."C26") AS "Precio_Ex_Planta", 
    SUM("D1"."C27") AS "Densidad", 
    SUM("D1"."C28") AS "Demanda", 
    SUM("D1"."C13") / NULLIF(SUM("D1"."C18"), 0) AS "U_S_m3_P_pub", 
    SUM("D1"."C14") / NULLIF(SUM("D1"."C18"), 0) AS "U_S_m3_ex", 
    SUM("D1"."C16") / NULLIF(SUM("D1"."C18"), 0) AS "U_S_m3_s_iva", 
    "D1"."C8" AS "Cantidad_Dias", 
    "D1"."C9" AS "Dia", 
    "D1"."C10" AS "Filtro", 
    "D1"."C11" AS "AñoMes", 
    "D1"."C12" AS "Filtro_ProdMes"
FROM
    (
    SELECT
        CASE 
            WHEN "Precios_ExPLanta_2_TM1"."Productos_ExPlanta" = 'GLP' THEN 'Supergas'
            ELSE "Precios_ExPLanta_2_TM1"."Productos_ExPlanta"
        END AS "C0", 
        "Precios_ExPLanta_2_TM1"."Años" AS "C1", 
        "Precios_ExPLanta_2_TM1"."Periodo_Mensual" AS "C2", 
        (CASE 
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
        END + '') AS "C3", 
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
        "Precios_ExPLanta_2_TM1"."Mercados" AS "C5", 
        CASE 
            WHEN 
                "Precios_ExPLanta_2_TM1"."Unidades" IN ( 
                    '$/ton', 
                    '$/m3', 
                    '$/litro', 
                    '$/kg', 
                    'N/A' )
                THEN
                    "Precios_ExPLanta_2_TM1"."Unidades"
            ELSE NULL
        END AS "C6", 
        CASE 
            WHEN 
                "Precios_ExPLanta_2_TM1"."Unidades" IN ( 
                    'U$S/m3', 
                    'U$S/ton', 
                    'N/A' )
                THEN
                    "Precios_ExPLanta_2_TM1"."Unidades"
            ELSE NULL
        END AS "C7", 
        "Precios_ExPLanta_2_TM1"."Cantidad_Dias" AS "C8", 
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
        END AS "C9", 
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
                    0
            ELSE 1
        END AS "C10", 
        CAST("Precios_ExPLanta_2_TM1"."Años" AS INTEGER) * 100 + CASE "Precios_ExPLanta_2_TM1"."Periodo_Mensual"
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
        END AS "C11", 
        CASE 
            WHEN 
                :pProducto: IN ( 
                    'Queroseno Montevideo', 
                    'Queroseno Interior' ) AND
                CAST("Precios_ExPLanta_2_TM1"."Años" AS INTEGER) * 100 + CASE "Precios_ExPLanta_2_TM1"."Periodo_Mensual"
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
                END > 202107
                THEN
                    0
            WHEN 
                NOT ( :pProducto: IN ( 
                    'Asfalto 150/200', 
                    'Asfalto AC-20', 
                    'Asfalto MC1', 
                    'Asfalto RC2', 
                    'Propano Industrial', 
                    'Propano Redes', 
                    'Supergas', 
                    'Supergas A Granel', 
                    'Queroseno Montevideo', 
                    'Queroseno Interior' ) ) AND
                CAST("Precios_ExPLanta_2_TM1"."Años" AS INTEGER) * 100 + CASE "Precios_ExPLanta_2_TM1"."Periodo_Mensual"
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
                END > 202106
                THEN
                    0
            WHEN 
                :pProducto: IN ( 
                    'Propano Industrial', 
                    'Propano Redes', 
                    'Supergas', 
                    'Supergas A Granel' ) AND
                CAST("Precios_ExPLanta_2_TM1"."Años" AS INTEGER) * 100 + CASE "Precios_ExPLanta_2_TM1"."Periodo_Mensual"
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
                END > 202306
                THEN
                    0
            ELSE 1
        END AS "C12", 
        CASE 
            WHEN "Precios_ExPLanta_2_TM1"."Medidas_ExPlanta" = 'Precio Público' THEN "Precios_ExPLanta_2_TM1"."Valor"
            ELSE 0
        END AS "C13", 
        CASE 
            WHEN "Precios_ExPLanta_2_TM1"."Medidas_ExPlanta" = 'Precio Exonerado' THEN "Precios_ExPLanta_2_TM1"."Valor"
            ELSE 0
        END AS "C14", 
        CASE 
            WHEN "Precios_ExPLanta_2_TM1"."Medidas_ExPlanta" = 'IVA' THEN "Precios_ExPLanta_2_TM1"."Valor"
            ELSE 0
        END AS "C15", 
        CASE 
            WHEN "Precios_ExPLanta_2_TM1"."Medidas_ExPlanta" = 'Precio sin IVA' THEN "Precios_ExPLanta_2_TM1"."Valor"
            ELSE 0
        END AS "C16", 
        CASE 
            WHEN "Precios_ExPLanta_2_TM1"."Medidas_ExPlanta" = 'IMESI' THEN "Precios_ExPLanta_2_TM1"."Valor"
            ELSE 0
        END AS "C17", 
        CASE 
            WHEN "Precios_ExPLanta_2_TM1"."Medidas_ExPlanta" = 'Cotización Promedio' THEN "Precios_ExPLanta_2_TM1"."Valor"
            ELSE 0
        END AS "C18", 
        CASE 
            WHEN "Precios_ExPLanta_2_TM1"."Medidas_ExPlanta" = 'Cotización' THEN "Precios_ExPLanta_2_TM1"."Valor"
            ELSE 0
        END AS "C19", 
        CASE 
            WHEN "Precios_ExPLanta_2_TM1"."Medidas_ExPlanta" = 'Precio sin impuesto' THEN "Precios_ExPLanta_2_TM1"."Valor"
            ELSE 0
        END AS "C20", 
        CASE 
            WHEN "Precios_ExPLanta_2_TM1"."Medidas_ExPlanta" = 'Margen y Bonificaciones' THEN "Precios_ExPLanta_2_TM1"."Valor"
            ELSE 0
        END AS "C21", 
        CASE 
            WHEN "Precios_ExPLanta_2_TM1"."Medidas_ExPlanta" = 'Tasa de Inflamable' THEN "Precios_ExPLanta_2_TM1"."Valor"
            ELSE 0
        END AS "C22", 
        CASE 
            WHEN "Precios_ExPLanta_2_TM1"."Medidas_ExPlanta" = 'Tasa de URSEA' THEN "Precios_ExPLanta_2_TM1"."Valor"
            ELSE 0
        END AS "C23", 
        CASE 
            WHEN "Precios_ExPLanta_2_TM1"."Medidas_ExPlanta" = 'Fideicomiso' THEN "Precios_ExPLanta_2_TM1"."Valor"
            ELSE 0
        END AS "C24", 
        CASE 
            WHEN "Precios_ExPLanta_2_TM1"."Medidas_ExPlanta" = 'Flete' THEN "Precios_ExPLanta_2_TM1"."Valor"
            ELSE 0
        END AS "C25", 
        CASE 
            WHEN "Precios_ExPLanta_2_TM1"."Medidas_ExPlanta" = 'Precio Ex Planta' THEN "Precios_ExPLanta_2_TM1"."Valor"
            ELSE 0
        END AS "C26", 
        CASE 
            WHEN "Precios_ExPLanta_2_TM1"."Medidas_ExPlanta" = 'Densidad' THEN "Precios_ExPLanta_2_TM1"."Valor"
            ELSE 0
        END AS "C27", 
        CASE 
            WHEN "Precios_ExPLanta_2_TM1"."Medidas_ExPlanta" = 'Demanda' THEN "Precios_ExPLanta_2_TM1"."Valor"
            ELSE 0
        END AS "C28"
    FROM
        "APPBI"."DP"."Precios_ExPLanta_2_TM1" "Precios_ExPLanta_2_TM1" 
    WHERE 
        "Precios_ExPLanta_2_TM1"."Mercados" = 'Interno' AND
        "Precios_ExPLanta_2_TM1"."Años" = :pAño: AND
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
                    0
            ELSE 1
        END = 1 AND
        CASE 
            WHEN 
                :pProducto: IN ( 
                    'Queroseno Montevideo', 
                    'Queroseno Interior' ) AND
                CAST("Precios_ExPLanta_2_TM1"."Años" AS INTEGER) * 100 + CASE "Precios_ExPLanta_2_TM1"."Periodo_Mensual"
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
                END > 202107
                THEN
                    0
            WHEN 
                NOT ( :pProducto: IN ( 
                    'Asfalto 150/200', 
                    'Asfalto AC-20', 
                    'Asfalto MC1', 
                    'Asfalto RC2', 
                    'Propano Industrial', 
                    'Propano Redes', 
                    'Supergas', 
                    'Supergas A Granel', 
                    'Queroseno Montevideo', 
                    'Queroseno Interior' ) ) AND
                CAST("Precios_ExPLanta_2_TM1"."Años" AS INTEGER) * 100 + CASE "Precios_ExPLanta_2_TM1"."Periodo_Mensual"
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
                END > 202106
                THEN
                    0
            WHEN 
                :pProducto: IN ( 
                    'Propano Industrial', 
                    'Propano Redes', 
                    'Supergas', 
                    'Supergas A Granel' ) AND
                CAST("Precios_ExPLanta_2_TM1"."Años" AS INTEGER) * 100 + CASE "Precios_ExPLanta_2_TM1"."Periodo_Mensual"
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
                END > 202306
                THEN
                    0
            ELSE 1
        END = 1 AND
        CASE 
            WHEN "Precios_ExPLanta_2_TM1"."Productos_ExPlanta" = 'GLP' THEN 'Supergas'
            ELSE "Precios_ExPLanta_2_TM1"."Productos_ExPlanta"
        END = :pProducto: AND
        NOT ( CASE 
            WHEN 
                "Precios_ExPLanta_2_TM1"."Unidades" IN ( 
                    'U$S/m3', 
                    'U$S/ton', 
                    'N/A' )
                THEN
                    "Precios_ExPLanta_2_TM1"."Unidades"
            ELSE NULL
        END IS NULL )
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
    "D1"."C12"