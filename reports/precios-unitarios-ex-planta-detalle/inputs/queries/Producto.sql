SELECT
    "D1"."C0" AS "Producto", 
    "D1"."C1" AS "Unidad2", 
    'Propano' AS "Parametro"
FROM
    (
    SELECT
        CASE "Precios_Ex_Planta"."Producto"
            WHEN 'GLP' THEN 'Supergas'
            WHEN 'Propano Industrial' THEN 'Propano'
            WHEN 'Supergas A Granel' THEN 'Propano'
            ELSE "Precios_Ex_Planta"."Producto"
        END AS "C0", 
        CASE 
            
            CASE "Precios_Ex_Planta"."Producto"
                WHEN 'GLP' THEN 'Supergas'
                WHEN 'Propano Industrial' THEN 'Propano'
                WHEN 'Supergas A Granel' THEN 'Propano'
                ELSE "Precios_Ex_Planta"."Producto"
            END
            WHEN 'GLP' THEN '$/kg'
            WHEN 'Propano' THEN '$/kg'
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
        END AS "C1"
    FROM
        "APPBI"."DP"."Precios_Ex_Planta" "Precios_Ex_Planta" 
    WHERE 
        CAST(
            CASE "Precios_Ex_Planta"."Producto"
                WHEN 'GLP' THEN 'Supergas'
                WHEN 'Propano Industrial' THEN 'Propano'
                WHEN 'Supergas A Granel' THEN 'Propano'
                ELSE "Precios_Ex_Planta"."Producto"
            END AS VARCHAR(20)) = 'Propano'
    ) "D1" 
GROUP BY 
    "D1"."C0", 
    "D1"."C1"