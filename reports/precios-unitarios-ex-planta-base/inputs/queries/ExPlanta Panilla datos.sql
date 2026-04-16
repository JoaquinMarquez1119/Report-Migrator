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