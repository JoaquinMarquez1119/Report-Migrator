SELECT
    "D1"."C0" AS "Producto", 
    "D1"."C1" AS "Texto"
FROM
    (
    SELECT
        "Precios_Ex_Planta"."Producto" AS "C0", 
        CASE 
            WHEN 
                "Precios_Ex_Planta"."Producto" IN ( 
                    'Queroseno Montevideo', 
                    'Queroseno Interior', 
                    'Gasolina Av 100 Octanos', 
                    'Jet A1', 
                    'Supergas A Granel', 
                    'Supergas', 
                    'Propano Industrial', 
                    'Propano Redes', 
                    'Butano Desodorizado', 
                    'Solvente 1197', 
                    'Disan', 
                    'Base insecticida', 
                    'Asfalto AC-30', 
                    'Asfalto 150/200', 
                    'Asfalto MC1', 
                    'Asfalto RC2', 
                    'Aguarras', 
                    'Querosol', 
                    'Hexano Comercial' )
                THEN
                    ''
            ELSE '(*) Equivale al precio del Subtotal 3 del Informe URSEA'
        END AS "C1"
    FROM
        "APPBI"."DP"."Precios_Ex_Planta" "Precios_Ex_Planta" 
    WHERE 
        CAST("Precios_Ex_Planta"."Producto" AS VARCHAR(20)) = :pProducto:
    ) "D1" 
GROUP BY 
    "D1"."C0", 
    "D1"."C1"