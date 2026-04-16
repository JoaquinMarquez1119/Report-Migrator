SELECT
    "D1"."C0", 
    "D1"."C1", 
    "D1"."C2", 
    "D1"."C3", 
    "D1"."C4", 
    "D1"."C5", 
    "D1"."C11", 
    "D1"."C12", 
    "D1"."C13", 
    "D1"."C6", 
    "D1"."C14", 
    "D1"."C15", 
    "D1"."C16", 
    "D1"."C7", 
    "D1"."C8", 
    "D1"."C9", 
    "D1"."C10", 
    "D1"."C17"
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
        CASE 
            WHEN CAST("Precios_ExPLanta_2_TM1"."Productos_ExPlanta" AS VARCHAR(20)) = 'Gasolina Av 100 Octa' THEN 'Gasolina Av 100 Octanos'
            ELSE CAST("Precios_ExPLanta_2_TM1"."Productos_ExPlanta" AS VARCHAR(20))
        END AS "C5", 
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
        END AS "C6", 
        CASE 
            WHEN "Precios_ExPLanta_2_TM1"."Años" = 'Año Base' THEN 0
            ELSE CAST("Precios_ExPLanta_2_TM1"."Años" AS INTEGER)
        END AS "C7", 
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
            END AS INTEGER) AS "C8", 
        CASE 
            WHEN "Precios_ExPLanta_2_TM1"."Años" = 'Año Base' THEN 0
            ELSE CAST("Precios_ExPLanta_2_TM1"."Años" AS INTEGER)
        END * 100 + CAST(
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
                    WHEN CAST("Precios_ExPLanta_2_TM1"."Productos_ExPlanta" AS VARCHAR(20)) = 'Gasolina Av 100 Octa' THEN 'Gasolina Av 100 Octanos'
                    ELSE CAST("Precios_ExPLanta_2_TM1"."Productos_ExPlanta" AS VARCHAR(20))
                END = 'Queroseno Montevideo' AND
                CASE 
                    WHEN "Precios_ExPLanta_2_TM1"."Años" = 'Año Base' THEN 0
                    ELSE CAST("Precios_ExPLanta_2_TM1"."Años" AS INTEGER)
                END * 100 + CAST(
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
                    END AS INTEGER) > 202107 OR
                CASE 
                    WHEN CAST("Precios_ExPLanta_2_TM1"."Productos_ExPlanta" AS VARCHAR(20)) = 'Gasolina Av 100 Octa' THEN 'Gasolina Av 100 Octanos'
                    ELSE CAST("Precios_ExPLanta_2_TM1"."Productos_ExPlanta" AS VARCHAR(20))
                END = 'Queroseno Interior' AND
                CASE 
                    WHEN "Precios_ExPLanta_2_TM1"."Años" = 'Año Base' THEN 0
                    ELSE CAST("Precios_ExPLanta_2_TM1"."Años" AS INTEGER)
                END * 100 + CAST(
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
                    END AS INTEGER) > 202107
                THEN
                    0
            WHEN 
                CASE 
                    WHEN CAST("Precios_ExPLanta_2_TM1"."Productos_ExPlanta" AS VARCHAR(20)) = 'Gasolina Av 100 Octa' THEN 'Gasolina Av 100 Octanos'
                    ELSE CAST("Precios_ExPLanta_2_TM1"."Productos_ExPlanta" AS VARCHAR(20))
                END <> 'Queroseno Montevideo' AND
                CASE 
                    WHEN CAST("Precios_ExPLanta_2_TM1"."Productos_ExPlanta" AS VARCHAR(20)) = 'Gasolina Av 100 Octa' THEN 'Gasolina Av 100 Octanos'
                    ELSE CAST("Precios_ExPLanta_2_TM1"."Productos_ExPlanta" AS VARCHAR(20))
                END <> 'Queroseno Interior' AND
                CASE 
                    WHEN "Precios_ExPLanta_2_TM1"."Años" = 'Año Base' THEN 0
                    ELSE CAST("Precios_ExPLanta_2_TM1"."Años" AS INTEGER)
                END * 100 + CAST(
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
                    END AS INTEGER) > 202106
                THEN
                    0
            ELSE 1
        END AS "C10", 
        CASE 
            WHEN "Precios_ExPLanta_2_TM1"."Medidas_ExPlanta" = 'Precio Ex Planta' THEN "Precios_ExPLanta_2_TM1"."Valor"
            ELSE 0
        END AS "C11", 
        CASE 
            WHEN "Precios_ExPLanta_2_TM1"."Medidas_ExPlanta" = 'Densidad' THEN "Precios_ExPLanta_2_TM1"."Valor"
            ELSE 0
        END AS "C12", 
        DATEPART(YEAR, CAST(CURRENT_TIMESTAMP AS DATE)) AS "C13", 
        DATEPART(MONTH, CAST(CURRENT_TIMESTAMP AS DATE)) AS "C14", 
        (CAST(DATEPART(DAY, CAST(CURRENT_TIMESTAMP AS DATE)) AS VARCHAR(2)) + '-') AS "C15", 
        "Precios_ExPLanta_2_TM1"."Cantidad_Dias" AS "C16", 
        CASE 
            WHEN "Precios_ExPLanta_2_TM1"."Medidas_ExPlanta" = 'Cotización' THEN "Precios_ExPLanta_2_TM1"."Valor"
            ELSE 0
        END AS "C17"
    FROM
        "APPBI"."DP"."Precios_ExPLanta_2_TM1" "Precios_ExPLanta_2_TM1" 
    WHERE 
        CASE 
            WHEN "Precios_ExPLanta_2_TM1"."Años" <> 'Año Base' THEN CAST("Precios_ExPLanta_2_TM1"."Años" AS INTEGER)
            ELSE NULL
        END = :pAño: AND
        CASE 
            WHEN 
                CASE 
                    WHEN CAST("Precios_ExPLanta_2_TM1"."Productos_ExPlanta" AS VARCHAR(20)) = 'Gasolina Av 100 Octa' THEN 'Gasolina Av 100 Octanos'
                    ELSE CAST("Precios_ExPLanta_2_TM1"."Productos_ExPlanta" AS VARCHAR(20))
                END = 'Queroseno Montevideo' AND
                CASE 
                    WHEN "Precios_ExPLanta_2_TM1"."Años" = 'Año Base' THEN 0
                    ELSE CAST("Precios_ExPLanta_2_TM1"."Años" AS INTEGER)
                END * 100 + CAST(
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
                    END AS INTEGER) > 202107 OR
                CASE 
                    WHEN CAST("Precios_ExPLanta_2_TM1"."Productos_ExPlanta" AS VARCHAR(20)) = 'Gasolina Av 100 Octa' THEN 'Gasolina Av 100 Octanos'
                    ELSE CAST("Precios_ExPLanta_2_TM1"."Productos_ExPlanta" AS VARCHAR(20))
                END = 'Queroseno Interior' AND
                CASE 
                    WHEN "Precios_ExPLanta_2_TM1"."Años" = 'Año Base' THEN 0
                    ELSE CAST("Precios_ExPLanta_2_TM1"."Años" AS INTEGER)
                END * 100 + CAST(
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
                    END AS INTEGER) > 202107
                THEN
                    0
            WHEN 
                CASE 
                    WHEN CAST("Precios_ExPLanta_2_TM1"."Productos_ExPlanta" AS VARCHAR(20)) = 'Gasolina Av 100 Octa' THEN 'Gasolina Av 100 Octanos'
                    ELSE CAST("Precios_ExPLanta_2_TM1"."Productos_ExPlanta" AS VARCHAR(20))
                END <> 'Queroseno Montevideo' AND
                CASE 
                    WHEN CAST("Precios_ExPLanta_2_TM1"."Productos_ExPlanta" AS VARCHAR(20)) = 'Gasolina Av 100 Octa' THEN 'Gasolina Av 100 Octanos'
                    ELSE CAST("Precios_ExPLanta_2_TM1"."Productos_ExPlanta" AS VARCHAR(20))
                END <> 'Queroseno Interior' AND
                CASE 
                    WHEN "Precios_ExPLanta_2_TM1"."Años" = 'Año Base' THEN 0
                    ELSE CAST("Precios_ExPLanta_2_TM1"."Años" AS INTEGER)
                END * 100 + CAST(
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
                    END AS INTEGER) > 202106
                THEN
                    0
            ELSE 1
        END = 1 AND
        NOT ( "Precios_ExPLanta_2_TM1"."Productos_ExPlanta" IN ( 
            'Asfalto 150/200', 
            'Asfalto AC-20', 
            'Asfalto MC1', 
            'Asfalto RC2', 
            'Propano Industrial', 
            'Propano Redes', 
            'Supergas', 
            'Supergas A Granel' ) ) AND
        NOT ( 
            CASE 
                WHEN CAST("Precios_ExPLanta_2_TM1"."Productos_ExPlanta" AS VARCHAR(20)) = 'Gasolina Av 100 Octa' THEN 'Gasolina Av 100 Octanos'
                ELSE CAST("Precios_ExPLanta_2_TM1"."Productos_ExPlanta" AS VARCHAR(20))
            END LIKE 'RPMS%' ) AND
        "Precios_ExPLanta_2_TM1"."Periodo_Mensual" <> 'Base' AND
        "Precios_ExPLanta_2_TM1"."Años" <> 'Año Base'
    ) "D1"