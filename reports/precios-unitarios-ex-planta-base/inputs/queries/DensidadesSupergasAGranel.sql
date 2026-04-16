WITH 
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
        SUM("D1"."C11") AS "Densidad", 
        "D1"."C8" AS "Filtro", 
        "D1"."C9" AS "Cantidad_dias", 
        "D1"."C10" AS "Dia"
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
            END AS "C8", 
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
                END) * 100) + 1)))))) AS "C9", 
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
            END AS "C10", 
            CASE 
                WHEN "Precios_ExPLanta_2_TM1"."Medidas_ExPlanta" = 'Densidad' THEN "Precios_ExPLanta_2_TM1"."Valor"
                ELSE 0
            END AS "C11"
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
        "D1"."C10"
    )
SELECT
    "Densidades_datos"."pAño" AS "pAño", 
    "Densidades_datos"."Número" AS "Número", 
    'Propano' AS "Producto", 
    SUM("Densidades_datos"."Densidad") AS "Densidad", 
    0 AS "Precio_Ex_Planta_USD", 
    0 AS "TC", 
    0 AS "Precio_Ex_Planta_UYU", 
    "Densidades_datos"."Dia" AS "Dia"
FROM
    "Densidades_datos" 
WHERE 
    "Densidades_datos"."Producto" = 'Propano Industrial' 
GROUP BY 
    "Densidades_datos"."pAño", 
    "Densidades_datos"."Número", 
    "Densidades_datos"."Dia"