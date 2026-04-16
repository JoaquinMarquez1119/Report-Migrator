SELECT
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
    "D1"."C11", 
    "D1"."C12", 
    "D1"."C13", 
    "D1"."C14", 
    "D1"."C15", 
    "D1"."C10"
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
        CASE "Precios_ExPLanta_2_TM1"."Productos_ExPlanta"
            WHEN 'Propano Industrial' THEN 'Propano'
            WHEN 'GLP' THEN 'Supergas'
            ELSE "Precios_ExPLanta_2_TM1"."Productos_ExPlanta"
        END AS "C4", 
        CASE 
            WHEN 
                CAST(
                    CASE "Precios_ExPLanta_2_TM1"."Productos_ExPlanta"
                        WHEN 'Propano Industrial' THEN 'Propano'
                        WHEN 'GLP' THEN 'Supergas'
                        ELSE "Precios_ExPLanta_2_TM1"."Productos_ExPlanta"
                    END AS VARCHAR(20)) = 'Gasolina Av 100 Octa'
                THEN
                    'Gasolina Av 100 Octanos'
            ELSE CAST(
                CASE "Precios_ExPLanta_2_TM1"."Productos_ExPlanta"
                    WHEN 'Propano Industrial' THEN 'Propano'
                    WHEN 'GLP' THEN 'Supergas'
                    ELSE "Precios_ExPLanta_2_TM1"."Productos_ExPlanta"
                END AS VARCHAR(20))
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
        "Precios_ExPLanta_2_TM1"."Mercados" AS "C10", 
        CASE 
            WHEN "Precios_ExPLanta_2_TM1"."Medidas_ExPlanta" = 'Cotización' THEN "Precios_ExPLanta_2_TM1"."Valor"
            ELSE 0
        END AS "C11", 
        DATEPART(YEAR, CAST(CURRENT_TIMESTAMP AS DATE)) AS "C12", 
        DATEPART(MONTH, CAST(CURRENT_TIMESTAMP AS DATE)) AS "C13", 
        (CAST(DATEPART(DAY, CAST(CURRENT_TIMESTAMP AS DATE)) AS VARCHAR(2)) + '-') AS "C14", 
        "Precios_ExPLanta_2_TM1"."Cantidad_Dias" AS "C15"
    FROM
        "APPBI"."DP"."Precios_ExPLanta_2_TM1" "Precios_ExPLanta_2_TM1" 
    WHERE 
        CASE 
            WHEN "Precios_ExPLanta_2_TM1"."Años" <> 'Año Base' THEN CAST("Precios_ExPLanta_2_TM1"."Años" AS INTEGER)
            ELSE NULL
        END = :pAño: AND
        NOT ( CASE "Precios_ExPLanta_2_TM1"."Productos_ExPlanta"
            WHEN 'Propano Industrial' THEN 'Propano'
            WHEN 'GLP' THEN 'Supergas'
            ELSE "Precios_ExPLanta_2_TM1"."Productos_ExPlanta"
        END IN ( 
            'Asfalto 150/200', 
            'Asfalto AC-20', 
            'Asfalto MC1', 
            'Asfalto RC2', 
            'Propano Redes', 
            'Supergas A Granel' ) ) AND
        NOT ( 
            CASE 
                WHEN 
                    CAST(
                        CASE "Precios_ExPLanta_2_TM1"."Productos_ExPlanta"
                            WHEN 'Propano Industrial' THEN 'Propano'
                            WHEN 'GLP' THEN 'Supergas'
                            ELSE "Precios_ExPLanta_2_TM1"."Productos_ExPlanta"
                        END AS VARCHAR(20)) = 'Gasolina Av 100 Octa'
                    THEN
                        'Gasolina Av 100 Octanos'
                ELSE CAST(
                    CASE "Precios_ExPLanta_2_TM1"."Productos_ExPlanta"
                        WHEN 'Propano Industrial' THEN 'Propano'
                        WHEN 'GLP' THEN 'Supergas'
                        ELSE "Precios_ExPLanta_2_TM1"."Productos_ExPlanta"
                    END AS VARCHAR(20))
            END LIKE 'RPMS%' ) AND
        "Precios_ExPLanta_2_TM1"."Años" <> 'Año Base' AND
        "Precios_ExPLanta_2_TM1"."Periodo_Mensual" <> 'Base' AND
        "Precios_ExPLanta_2_TM1"."Mercados" = 'Interno'
    ) "D1"

SELECT
    "D1"."C0" AS "pAño", 
    "D1"."C1" AS "Mes_numero", 
    "D1"."C2" AS "Producto", 
    0 AS "Densidad", 
    SUM("D1"."C5") AS "Precio_Ex_Planta_USD", 
    "D1"."C3" AS "TC", 
    SUM("D1"."C5") AS "Precio_Ex_Planta_UYU", 
    "D1"."C4" AS "Dia"
FROM
    (
    SELECT
        "ExPlanta_Planilla_datos"."pAño" AS "C0", 
        "ExPlanta_Planilla_datos"."Mes_numero" AS "C1", 
        "ExPlanta_Planilla_datos"."Producto" AS "C2", 
        CASE 
            WHEN "ExPlanta_Planilla_datos"."pAño" < 2022 THEN "ExPlanta_Planilla_datos"."TC"
            ELSE 0
        END AS "C3", 
        "ExPlanta_Planilla_datos"."Dia" AS "C4", 
        "ExPlanta_Planilla_datos"."Valor" AS "C5"
    FROM
        (
        SELECT
            "D1"."C0" AS "Fecha", 
            "D1"."C1" AS "Año", 
            "D1"."C2" AS "pAño", 
            "D1"."C3" AS "Periodo_Mensual", 
            "D1"."C4" AS "Producto", 
            "D1"."C5" AS "Mes_Número", 
            "D1"."C6" AS "Mes_numero", 
            "D1"."C7" AS "TC", 
            SUM("D1"."C12") AS "Valor", 
            "D1"."C8" AS "Cantidad_dias", 
            "D1"."C9" AS "Dia", 
            "D1"."C10" AS "Concepto", 
            "D1"."C11" AS "FiltroSupergas"
        FROM
            (
            SELECT
                "Precios_Ex_Planta"."Fecha" AS "C0", 
                DATEPART(YEAR, "Precios_Ex_Planta"."Fecha") AS "C1", 
                CAST(DATEPART(YEAR, "Precios_Ex_Planta"."Fecha") AS INTEGER) AS "C2", 
                CASE DATEPART(MONTH, "Precios_Ex_Planta"."Fecha")
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
                CASE 
                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                    ELSE "Precios_Ex_Planta"."Producto"
                END AS "C4", 
                DATEPART(MONTH, "Precios_Ex_Planta"."Fecha") AS "C5", 
                CAST(DATEPART(MONTH, "Precios_Ex_Planta"."Fecha") AS INTEGER) AS "C6", 
                "Precios_Ex_Planta"."TC" AS "C7", 
                DATEPART(DAY, DATEADD(DAY, -1, DATEADD(MONTH, 1, DATEADD(DAY, -DAY("Precios_Ex_Planta"."Fecha") + 1, "Precios_Ex_Planta"."Fecha")))) AS "C8", 
                CASE 
                    WHEN 
                        DATEPART(YEAR, "Precios_Ex_Planta"."Fecha") = DATEPART(YEAR, CAST(CURRENT_TIMESTAMP AS DATE)) AND
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
                                WHEN 9 THEN 'Sep'
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
                        WHEN 9 THEN 'Sep'
                        WHEN 10 THEN 'Oct'
                        WHEN 11 THEN 'Nov'
                        WHEN 12 THEN 'Dic'
                    END)
                END AS "C9", 
                "Precios_Ex_Planta"."Concepto" AS "C10", 
                CASE 
                    WHEN 
                        CASE 
                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                            ELSE "Precios_Ex_Planta"."Producto"
                        END = 'Supergas' AND
                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                        THEN
                            0
                    ELSE 1
                END AS "C11", 
                "Precios_Ex_Planta"."Valor" AS "C12"
            FROM
                "APPBI"."DP"."Precios_Ex_Planta" "Precios_Ex_Planta" 
            WHERE 
                CAST(DATEPART(YEAR, "Precios_Ex_Planta"."Fecha") AS INTEGER) = :pAño: AND
                NOT ( CASE 
                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                    ELSE "Precios_Ex_Planta"."Producto"
                END IN ( 
                    'GasolinaAv100Octanos(Es)', 
                    'GasolinaAv100Octanos(Pa)' ) ) AND
                "Precios_Ex_Planta"."Concepto" IN ( 
                    'PPI sin tasas e impuestos + Factor X', 
                    'PEP' ) AND
                CASE 
                    WHEN 
                        CASE 
                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                            ELSE "Precios_Ex_Planta"."Producto"
                        END = 'Supergas' AND
                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
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
        ) "ExPlanta_Planilla_datos"
    ) "D1" 
GROUP BY 
    "D1"."C0", 
    "D1"."C1", 
    "D1"."C2", 
    "D1"."C3", 
    "D1"."C4"