SELECT
    "D1"."C0" AS "Años", 
    "D1"."C1" AS "Año_nombre1"
FROM
    (
    SELECT
        "Precios_ExPLanta_2_TM1"."Años" AS "C0", 
        CAST("Precios_ExPLanta_2_TM1"."Años" AS INTEGER) AS "C1"
    FROM
        "APPBI"."DP"."Precios_ExPLanta_2_TM1" "Precios_ExPLanta_2_TM1"
    ) "D1" 
GROUP BY 
    "D1"."C0", 
    "D1"."C1"