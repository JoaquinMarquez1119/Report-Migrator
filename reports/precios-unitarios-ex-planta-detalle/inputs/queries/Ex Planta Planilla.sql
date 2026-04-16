SELECT
    "D1"."C0" AS "Fecha", 
    "D1"."C1" AS "Año", 
    "D1"."C2" AS "Concepto", 
    "D1"."C3" AS "Concepto2", 
    "D1"."C4" AS "EncabezadosenDatosPrioritarios", 
    "D1"."C5" AS "Producto", 
    SUM("D1"."C21") AS "TC", 
    SUM("D1"."C22") AS "Valor", 
    SUM("D1"."C22") AS "Valor_USD_m3", 
    "D1"."C6" AS "Mes_Número", 
    "D1"."C7" AS "Mes_numero", 
    "D1"."C8" AS "Periodo_Mensual", 
    "D1"."C9" AS "Cantidad_dias", 
    "D1"."C10" AS "Dia", 
    "D1"."C11" AS "Filtro_QInterior", 
    "D1"."C12" AS "Filtro_QMontevideo", 
    "D1"."C13" AS "Filtro_Butano", 
    "D1"."C14" AS "Filtro_Ultimos", 
    "D1"."C15" AS "Filtro_FO", 
    "D1"."C16" AS "Filtro_Supergas", 
    "D1"."C17" AS "Filtro_Propano", 
    "D1"."C18" AS "Filtro", 
    :pUnidad: AS "Unidad", 
    "D1"."C19" AS "Orden", 
    "D1"."C20" AS "Unidad2", 
    SUM(0) AS "Nueva_Cotizacion"
FROM
    (
    SELECT
        "Precios_Ex_Planta"."Fecha" AS "C0", 
        CAST(DATEPART(YEAR, "Precios_Ex_Planta"."Fecha") AS INTEGER) AS "C1", 
        "Precios_Ex_Planta"."Concepto" AS "C2", 
        CASE 
            WHEN 
                CASE 
                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                    WHEN 
                        :pProducto: = 'Propano Industrial' AND
                        "Precios_Ex_Planta"."Producto" = 'Propano'
                        THEN
                            'Propano Industrial'
                    ELSE "Precios_Ex_Planta"."Producto"
                END IN ( 
                    'Premium 97 Sp', 
                    'Super 95 Sp', 
                    'Gasoil Comun', 
                    'Gasoil Especial', 
                    'Fuel Oil Pesado', 
                    'Fuel Oil Medio', 
                    'Queroseno Montevideo', 
                    'Queroseno Interior' ) AND
                "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                THEN
                    'Precio Ex Planta (PEP)'
            WHEN 
                NOT ( CASE 
                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                    WHEN 
                        :pProducto: = 'Propano Industrial' AND
                        "Precios_Ex_Planta"."Producto" = 'Propano'
                        THEN
                            'Propano Industrial'
                    ELSE "Precios_Ex_Planta"."Producto"
                END IN ( 
                    'Premium 97 Sp', 
                    'Super 95 Sp', 
                    'Gasoil Comun', 
                    'Gasoil Especial', 
                    'Fuel Oil Pesado', 
                    'Fuel Oil Medio' ) ) AND
                "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                THEN
                    'Precio Ex Planta (PEP)'
            ELSE "Precios_Ex_Planta"."Concepto"
        END AS "C3", 
        "Precios_Ex_Planta"."EncabezadosenDatosPrioritarios" AS "C4", 
        CASE 
            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
            WHEN 
                :pProducto: = 'Propano Industrial' AND
                "Precios_Ex_Planta"."Producto" = 'Propano'
                THEN
                    'Propano Industrial'
            ELSE "Precios_Ex_Planta"."Producto"
        END AS "C5", 
        DATEPART(MONTH, "Precios_Ex_Planta"."Fecha") AS "C6", 
        CAST(DATEPART(MONTH, "Precios_Ex_Planta"."Fecha") AS INTEGER) AS "C7", 
        CASE DATEPART(MONTH, "Precios_Ex_Planta"."Fecha")
            WHEN 1 THEN 'Ene'
            WHEN 2 THEN 'Feb'
            WHEN 3 THEN 'Mar'
            WHEN 4 THEN 'Abr'
            WHEN 5 THEN 'May'
            WHEN 6 THEN 'Jun'
            WHEN 7 THEN 'Jul'
            WHEN 8 THEN 'Ago'
            WHEN 9 THEN 'Set'
            WHEN 10 THEN 'Oct'
            WHEN 11 THEN 'Nov'
            WHEN 12 THEN 'Dic'
        END AS "C8", 
        DATEPART(DAY, DATEADD(DAY, -1, DATEADD(MONTH, 1, DATEADD(DAY, -DAY("Precios_Ex_Planta"."Fecha") + 1, "Precios_Ex_Planta"."Fecha")))) AS "C9", 
        CASE 
            WHEN 
                CAST(DATEPART(YEAR, "Precios_Ex_Planta"."Fecha") AS INTEGER) = DATEPART(YEAR, CAST(CURRENT_TIMESTAMP AS DATE)) AND
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
                        WHEN 9 THEN 'Set'
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
                WHEN 9 THEN 'Set'
                WHEN 10 THEN 'Oct'
                WHEN 11 THEN 'Nov'
                WHEN 12 THEN 'Dic'
            END)
        END AS "C10", 
        CASE 
            WHEN 
                CASE 
                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                    WHEN 
                        :pProducto: = 'Propano Industrial' AND
                        "Precios_Ex_Planta"."Producto" = 'Propano'
                        THEN
                            'Propano Industrial'
                    ELSE "Precios_Ex_Planta"."Producto"
                END IN ( 
                    'Queroseno Interior' ) AND
                CASE 
                    WHEN 
                        CASE 
                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                            WHEN 
                                :pProducto: = 'Propano Industrial' AND
                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                THEN
                                    'Propano Industrial'
                            ELSE "Precios_Ex_Planta"."Producto"
                        END IN ( 
                            'Premium 97 Sp', 
                            'Super 95 Sp', 
                            'Gasoil Comun', 
                            'Gasoil Especial', 
                            'Fuel Oil Pesado', 
                            'Fuel Oil Medio', 
                            'Queroseno Montevideo', 
                            'Queroseno Interior' ) AND
                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                        THEN
                            'Precio Ex Planta (PEP)'
                    WHEN 
                        NOT ( CASE 
                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                            WHEN 
                                :pProducto: = 'Propano Industrial' AND
                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                THEN
                                    'Propano Industrial'
                            ELSE "Precios_Ex_Planta"."Producto"
                        END IN ( 
                            'Premium 97 Sp', 
                            'Super 95 Sp', 
                            'Gasoil Comun', 
                            'Gasoil Especial', 
                            'Fuel Oil Pesado', 
                            'Fuel Oil Medio' ) ) AND
                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                        THEN
                            'Precio Ex Planta (PEP)'
                    ELSE "Precios_Ex_Planta"."Concepto"
                END IN ( 
                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                    'Precio Intermedio Transitorio (PIT) (impuestos incluidos)', 
                    'Precio Ex Planta (PEP) (impuestos incluidos)', 
                    'Precio Ex Planta (PEP) sin flete secundario (impuestos incluidos)', 
                    'Precio Ex Planta (PEP)' )
                THEN
                    1
            ELSE 0
        END AS "C11", 
        CASE 
            WHEN 
                CASE 
                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                    WHEN 
                        :pProducto: = 'Propano Industrial' AND
                        "Precios_Ex_Planta"."Producto" = 'Propano'
                        THEN
                            'Propano Industrial'
                    ELSE "Precios_Ex_Planta"."Producto"
                END IN ( 
                    'Queroseno Montevideo' ) AND
                CASE 
                    WHEN 
                        CASE 
                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                            WHEN 
                                :pProducto: = 'Propano Industrial' AND
                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                THEN
                                    'Propano Industrial'
                            ELSE "Precios_Ex_Planta"."Producto"
                        END IN ( 
                            'Premium 97 Sp', 
                            'Super 95 Sp', 
                            'Gasoil Comun', 
                            'Gasoil Especial', 
                            'Fuel Oil Pesado', 
                            'Fuel Oil Medio', 
                            'Queroseno Montevideo', 
                            'Queroseno Interior' ) AND
                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                        THEN
                            'Precio Ex Planta (PEP)'
                    WHEN 
                        NOT ( CASE 
                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                            WHEN 
                                :pProducto: = 'Propano Industrial' AND
                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                THEN
                                    'Propano Industrial'
                            ELSE "Precios_Ex_Planta"."Producto"
                        END IN ( 
                            'Premium 97 Sp', 
                            'Super 95 Sp', 
                            'Gasoil Comun', 
                            'Gasoil Especial', 
                            'Fuel Oil Pesado', 
                            'Fuel Oil Medio' ) ) AND
                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                        THEN
                            'Precio Ex Planta (PEP)'
                    ELSE "Precios_Ex_Planta"."Concepto"
                END IN ( 
                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                    'Precio Intermedio Transitorio (PIT) (impuestos incluidos)', 
                    'Precio Ex Planta (PEP) (impuestos incluidos)', 
                    'Precio Ex Planta (PEP)' )
                THEN
                    1
            ELSE 0
        END AS "C12", 
        CASE 
            WHEN 
                CASE 
                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                    WHEN 
                        :pProducto: = 'Propano Industrial' AND
                        "Precios_Ex_Planta"."Producto" = 'Propano'
                        THEN
                            'Propano Industrial'
                    ELSE "Precios_Ex_Planta"."Producto"
                END IN ( 
                    'Butano Desodorizado' ) AND
                CASE 
                    WHEN 
                        CASE 
                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                            WHEN 
                                :pProducto: = 'Propano Industrial' AND
                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                THEN
                                    'Propano Industrial'
                            ELSE "Precios_Ex_Planta"."Producto"
                        END IN ( 
                            'Premium 97 Sp', 
                            'Super 95 Sp', 
                            'Gasoil Comun', 
                            'Gasoil Especial', 
                            'Fuel Oil Pesado', 
                            'Fuel Oil Medio', 
                            'Queroseno Montevideo', 
                            'Queroseno Interior' ) AND
                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                        THEN
                            'Precio Ex Planta (PEP)'
                    WHEN 
                        NOT ( CASE 
                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                            WHEN 
                                :pProducto: = 'Propano Industrial' AND
                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                THEN
                                    'Propano Industrial'
                            ELSE "Precios_Ex_Planta"."Producto"
                        END IN ( 
                            'Premium 97 Sp', 
                            'Super 95 Sp', 
                            'Gasoil Comun', 
                            'Gasoil Especial', 
                            'Fuel Oil Pesado', 
                            'Fuel Oil Medio' ) ) AND
                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                        THEN
                            'Precio Ex Planta (PEP)'
                    ELSE "Precios_Ex_Planta"."Concepto"
                END IN ( 
                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                    'Precio Ex Planta (PEP) sin flete secundario (impuestos incluidos)', 
                    'Precio Ex Planta (PEP)' )
                THEN
                    1
            ELSE 0
        END AS "C13", 
        CASE 
            WHEN 
                CASE 
                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                    WHEN 
                        :pProducto: = 'Propano Industrial' AND
                        "Precios_Ex_Planta"."Producto" = 'Propano'
                        THEN
                            'Propano Industrial'
                    ELSE "Precios_Ex_Planta"."Producto"
                END IN ( 
                    'Aguarras', 
                    'Gasolina Av 100 Octanos', 
                    'Gasolina Av 100 Octanos(Estado)', 
                    'Gasolina Av 100 Octanos(Particular)', 
                    'Jet A1', 
                    'Solvente 1197', 
                    'Disan', 
                    'Base insecticida', 
                    'Querosol', 
                    'Queroseno Montevideo', 
                    'Queroseno Interior', 
                    'Hexano Comercial' ) AND
                CASE 
                    WHEN 
                        CASE 
                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                            WHEN 
                                :pProducto: = 'Propano Industrial' AND
                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                THEN
                                    'Propano Industrial'
                            ELSE "Precios_Ex_Planta"."Producto"
                        END IN ( 
                            'Premium 97 Sp', 
                            'Super 95 Sp', 
                            'Gasoil Comun', 
                            'Gasoil Especial', 
                            'Fuel Oil Pesado', 
                            'Fuel Oil Medio', 
                            'Queroseno Montevideo', 
                            'Queroseno Interior' ) AND
                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                        THEN
                            'Precio Ex Planta (PEP)'
                    WHEN 
                        NOT ( CASE 
                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                            WHEN 
                                :pProducto: = 'Propano Industrial' AND
                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                THEN
                                    'Propano Industrial'
                            ELSE "Precios_Ex_Planta"."Producto"
                        END IN ( 
                            'Premium 97 Sp', 
                            'Super 95 Sp', 
                            'Gasoil Comun', 
                            'Gasoil Especial', 
                            'Fuel Oil Pesado', 
                            'Fuel Oil Medio' ) ) AND
                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                        THEN
                            'Precio Ex Planta (PEP)'
                    ELSE "Precios_Ex_Planta"."Concepto"
                END IN ( 
                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                    'Precio Ex Planta (PEP) (impuestos incluidos)', 
                    'Precio Ex Planta (PEP)' )
                THEN
                    1
            ELSE 0
        END AS "C14", 
        CASE 
            WHEN 
                CASE 
                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                    WHEN 
                        :pProducto: = 'Propano Industrial' AND
                        "Precios_Ex_Planta"."Producto" = 'Propano'
                        THEN
                            'Propano Industrial'
                    ELSE "Precios_Ex_Planta"."Producto"
                END IN ( 
                    'Fuel Oil Medio', 
                    'Fuel Oil Pesado' ) AND
                CASE 
                    WHEN 
                        CASE 
                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                            WHEN 
                                :pProducto: = 'Propano Industrial' AND
                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                THEN
                                    'Propano Industrial'
                            ELSE "Precios_Ex_Planta"."Producto"
                        END IN ( 
                            'Premium 97 Sp', 
                            'Super 95 Sp', 
                            'Gasoil Comun', 
                            'Gasoil Especial', 
                            'Fuel Oil Pesado', 
                            'Fuel Oil Medio', 
                            'Queroseno Montevideo', 
                            'Queroseno Interior' ) AND
                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                        THEN
                            'Precio Ex Planta (PEP)'
                    WHEN 
                        NOT ( CASE 
                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                            WHEN 
                                :pProducto: = 'Propano Industrial' AND
                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                THEN
                                    'Propano Industrial'
                            ELSE "Precios_Ex_Planta"."Producto"
                        END IN ( 
                            'Premium 97 Sp', 
                            'Super 95 Sp', 
                            'Gasoil Comun', 
                            'Gasoil Especial', 
                            'Fuel Oil Pesado', 
                            'Fuel Oil Medio' ) ) AND
                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                        THEN
                            'Precio Ex Planta (PEP)'
                    ELSE "Precios_Ex_Planta"."Concepto"
                END IN ( 
                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                    'Precio Ex Planta (PEP) (impuestos incluidos)', 
                    'Precio Ex Planta (PEP)', 
                    'Factor X o factor de ajuste', 
                    'PPI sin tasas e impuestos', 
                    'PPI n-1 Periodo URSEA', 
                    'PPI n-2 Periodo URSEA' )
                THEN
                    1
            ELSE 0
        END AS "C15", 
        CASE 
            WHEN 
                CASE 
                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                    WHEN 
                        :pProducto: = 'Propano Industrial' AND
                        "Precios_Ex_Planta"."Producto" = 'Propano'
                        THEN
                            'Propano Industrial'
                    ELSE "Precios_Ex_Planta"."Producto"
                END IN ( 
                    'Supergas' ) AND
                CASE 
                    WHEN 
                        CASE 
                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                            WHEN 
                                :pProducto: = 'Propano Industrial' AND
                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                THEN
                                    'Propano Industrial'
                            ELSE "Precios_Ex_Planta"."Producto"
                        END IN ( 
                            'Premium 97 Sp', 
                            'Super 95 Sp', 
                            'Gasoil Comun', 
                            'Gasoil Especial', 
                            'Fuel Oil Pesado', 
                            'Fuel Oil Medio', 
                            'Queroseno Montevideo', 
                            'Queroseno Interior' ) AND
                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                        THEN
                            'Precio Ex Planta (PEP)'
                    WHEN 
                        NOT ( CASE 
                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                            WHEN 
                                :pProducto: = 'Propano Industrial' AND
                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                THEN
                                    'Propano Industrial'
                            ELSE "Precios_Ex_Planta"."Producto"
                        END IN ( 
                            'Premium 97 Sp', 
                            'Super 95 Sp', 
                            'Gasoil Comun', 
                            'Gasoil Especial', 
                            'Fuel Oil Pesado', 
                            'Fuel Oil Medio' ) ) AND
                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                        THEN
                            'Precio Ex Planta (PEP)'
                    ELSE "Precios_Ex_Planta"."Concepto"
                END IN ( 
                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                    'Precio Intermedio Transitorio (PIT) (impuestos incluidos)', 
                    'Precio Ex Planta (PEP) (impuestos incluidos)', 
                    'PEP', 
                    'Factor X o factor de ajuste', 
                    'PPI sin tasas e impuestos', 
                    'Factor d para GLP Dec 205/023', 
                    'PPI n-1 Periodo URSEA', 
                    'PPI n-2 Periodo URSEA' )
                THEN
                    1
            ELSE 0
        END AS "C16", 
        CASE 
            WHEN 
                CASE 
                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                    WHEN 
                        :pProducto: = 'Propano Industrial' AND
                        "Precios_Ex_Planta"."Producto" = 'Propano'
                        THEN
                            'Propano Industrial'
                    ELSE "Precios_Ex_Planta"."Producto"
                END IN ( 
                    'Propano', 
                    'Supergas A Granel', 
                    'Propano Industrial' ) AND
                CASE 
                    WHEN 
                        CASE 
                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                            WHEN 
                                :pProducto: = 'Propano Industrial' AND
                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                THEN
                                    'Propano Industrial'
                            ELSE "Precios_Ex_Planta"."Producto"
                        END IN ( 
                            'Premium 97 Sp', 
                            'Super 95 Sp', 
                            'Gasoil Comun', 
                            'Gasoil Especial', 
                            'Fuel Oil Pesado', 
                            'Fuel Oil Medio', 
                            'Queroseno Montevideo', 
                            'Queroseno Interior' ) AND
                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                        THEN
                            'Precio Ex Planta (PEP)'
                    WHEN 
                        NOT ( CASE 
                            WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                            WHEN 
                                :pProducto: = 'Propano Industrial' AND
                                "Precios_Ex_Planta"."Producto" = 'Propano'
                                THEN
                                    'Propano Industrial'
                            ELSE "Precios_Ex_Planta"."Producto"
                        END IN ( 
                            'Premium 97 Sp', 
                            'Super 95 Sp', 
                            'Gasoil Comun', 
                            'Gasoil Especial', 
                            'Fuel Oil Pesado', 
                            'Fuel Oil Medio' ) ) AND
                        "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                        THEN
                            'Precio Ex Planta (PEP)'
                    ELSE "Precios_Ex_Planta"."Concepto"
                END IN ( 
                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                    'Precio Ex Planta (PEP) (impuestos incluidos)', 
                    'Precio Ex Planta (PEP)', 
                    'Factor X o factor de ajuste', 
                    'PPI sin tasas e impuestos', 
                    'PPI n-1 Periodo URSEA', 
                    'PPI n-2 Periodo URSEA' )
                THEN
                    1
            ELSE 0
        END AS "C17", 
        CASE 
            WHEN 
                CASE 
                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                    WHEN 
                        :pProducto: = 'Propano Industrial' AND
                        "Precios_Ex_Planta"."Producto" = 'Propano'
                        THEN
                            'Propano Industrial'
                    ELSE "Precios_Ex_Planta"."Producto"
                END IN ( 
                    'Queroseno Montevideo' )
                THEN
                    CASE 
                        WHEN 
                            CASE 
                                WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                WHEN 
                                    :pProducto: = 'Propano Industrial' AND
                                    "Precios_Ex_Planta"."Producto" = 'Propano'
                                    THEN
                                        'Propano Industrial'
                                ELSE "Precios_Ex_Planta"."Producto"
                            END IN ( 
                                'Queroseno Montevideo' ) AND
                            CASE 
                                WHEN 
                                    CASE 
                                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                        WHEN 
                                            :pProducto: = 'Propano Industrial' AND
                                            "Precios_Ex_Planta"."Producto" = 'Propano'
                                            THEN
                                                'Propano Industrial'
                                        ELSE "Precios_Ex_Planta"."Producto"
                                    END IN ( 
                                        'Premium 97 Sp', 
                                        'Super 95 Sp', 
                                        'Gasoil Comun', 
                                        'Gasoil Especial', 
                                        'Fuel Oil Pesado', 
                                        'Fuel Oil Medio', 
                                        'Queroseno Montevideo', 
                                        'Queroseno Interior' ) AND
                                    "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                    THEN
                                        'Precio Ex Planta (PEP)'
                                WHEN 
                                    NOT ( CASE 
                                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                        WHEN 
                                            :pProducto: = 'Propano Industrial' AND
                                            "Precios_Ex_Planta"."Producto" = 'Propano'
                                            THEN
                                                'Propano Industrial'
                                        ELSE "Precios_Ex_Planta"."Producto"
                                    END IN ( 
                                        'Premium 97 Sp', 
                                        'Super 95 Sp', 
                                        'Gasoil Comun', 
                                        'Gasoil Especial', 
                                        'Fuel Oil Pesado', 
                                        'Fuel Oil Medio' ) ) AND
                                    "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                    THEN
                                        'Precio Ex Planta (PEP)'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END IN ( 
                                'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                'Precio Intermedio Transitorio (PIT) (impuestos incluidos)', 
                                'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                'Precio Ex Planta (PEP)' )
                            THEN
                                1
                        ELSE 0
                    END
            WHEN 
                CASE 
                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                    WHEN 
                        :pProducto: = 'Propano Industrial' AND
                        "Precios_Ex_Planta"."Producto" = 'Propano'
                        THEN
                            'Propano Industrial'
                    ELSE "Precios_Ex_Planta"."Producto"
                END IN ( 
                    'Queroseno Interior' )
                THEN
                    CASE 
                        WHEN 
                            CASE 
                                WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                WHEN 
                                    :pProducto: = 'Propano Industrial' AND
                                    "Precios_Ex_Planta"."Producto" = 'Propano'
                                    THEN
                                        'Propano Industrial'
                                ELSE "Precios_Ex_Planta"."Producto"
                            END IN ( 
                                'Queroseno Interior' ) AND
                            CASE 
                                WHEN 
                                    CASE 
                                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                        WHEN 
                                            :pProducto: = 'Propano Industrial' AND
                                            "Precios_Ex_Planta"."Producto" = 'Propano'
                                            THEN
                                                'Propano Industrial'
                                        ELSE "Precios_Ex_Planta"."Producto"
                                    END IN ( 
                                        'Premium 97 Sp', 
                                        'Super 95 Sp', 
                                        'Gasoil Comun', 
                                        'Gasoil Especial', 
                                        'Fuel Oil Pesado', 
                                        'Fuel Oil Medio', 
                                        'Queroseno Montevideo', 
                                        'Queroseno Interior' ) AND
                                    "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                    THEN
                                        'Precio Ex Planta (PEP)'
                                WHEN 
                                    NOT ( CASE 
                                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                        WHEN 
                                            :pProducto: = 'Propano Industrial' AND
                                            "Precios_Ex_Planta"."Producto" = 'Propano'
                                            THEN
                                                'Propano Industrial'
                                        ELSE "Precios_Ex_Planta"."Producto"
                                    END IN ( 
                                        'Premium 97 Sp', 
                                        'Super 95 Sp', 
                                        'Gasoil Comun', 
                                        'Gasoil Especial', 
                                        'Fuel Oil Pesado', 
                                        'Fuel Oil Medio' ) ) AND
                                    "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                    THEN
                                        'Precio Ex Planta (PEP)'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END IN ( 
                                'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                'Precio Intermedio Transitorio (PIT) (impuestos incluidos)', 
                                'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                'Precio Ex Planta (PEP) sin flete secundario (impuestos incluidos)', 
                                'Precio Ex Planta (PEP)' )
                            THEN
                                1
                        ELSE 0
                    END
            WHEN 
                CASE 
                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                    WHEN 
                        :pProducto: = 'Propano Industrial' AND
                        "Precios_Ex_Planta"."Producto" = 'Propano'
                        THEN
                            'Propano Industrial'
                    ELSE "Precios_Ex_Planta"."Producto"
                END IN ( 
                    'Fuel Oil Medio', 
                    'Fuel Oil Pesado' )
                THEN
                    CASE 
                        WHEN 
                            CASE 
                                WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                WHEN 
                                    :pProducto: = 'Propano Industrial' AND
                                    "Precios_Ex_Planta"."Producto" = 'Propano'
                                    THEN
                                        'Propano Industrial'
                                ELSE "Precios_Ex_Planta"."Producto"
                            END IN ( 
                                'Fuel Oil Medio', 
                                'Fuel Oil Pesado' ) AND
                            CASE 
                                WHEN 
                                    CASE 
                                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                        WHEN 
                                            :pProducto: = 'Propano Industrial' AND
                                            "Precios_Ex_Planta"."Producto" = 'Propano'
                                            THEN
                                                'Propano Industrial'
                                        ELSE "Precios_Ex_Planta"."Producto"
                                    END IN ( 
                                        'Premium 97 Sp', 
                                        'Super 95 Sp', 
                                        'Gasoil Comun', 
                                        'Gasoil Especial', 
                                        'Fuel Oil Pesado', 
                                        'Fuel Oil Medio', 
                                        'Queroseno Montevideo', 
                                        'Queroseno Interior' ) AND
                                    "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                    THEN
                                        'Precio Ex Planta (PEP)'
                                WHEN 
                                    NOT ( CASE 
                                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                        WHEN 
                                            :pProducto: = 'Propano Industrial' AND
                                            "Precios_Ex_Planta"."Producto" = 'Propano'
                                            THEN
                                                'Propano Industrial'
                                        ELSE "Precios_Ex_Planta"."Producto"
                                    END IN ( 
                                        'Premium 97 Sp', 
                                        'Super 95 Sp', 
                                        'Gasoil Comun', 
                                        'Gasoil Especial', 
                                        'Fuel Oil Pesado', 
                                        'Fuel Oil Medio' ) ) AND
                                    "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                    THEN
                                        'Precio Ex Planta (PEP)'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END IN ( 
                                'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                'Precio Ex Planta (PEP)', 
                                'Factor X o factor de ajuste', 
                                'PPI sin tasas e impuestos', 
                                'PPI n-1 Periodo URSEA', 
                                'PPI n-2 Periodo URSEA' )
                            THEN
                                1
                        ELSE 0
                    END
            WHEN 
                CASE 
                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                    WHEN 
                        :pProducto: = 'Propano Industrial' AND
                        "Precios_Ex_Planta"."Producto" = 'Propano'
                        THEN
                            'Propano Industrial'
                    ELSE "Precios_Ex_Planta"."Producto"
                END IN ( 
                    'Butano Desodorizado' )
                THEN
                    CASE 
                        WHEN 
                            CASE 
                                WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                WHEN 
                                    :pProducto: = 'Propano Industrial' AND
                                    "Precios_Ex_Planta"."Producto" = 'Propano'
                                    THEN
                                        'Propano Industrial'
                                ELSE "Precios_Ex_Planta"."Producto"
                            END IN ( 
                                'Butano Desodorizado' ) AND
                            CASE 
                                WHEN 
                                    CASE 
                                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                        WHEN 
                                            :pProducto: = 'Propano Industrial' AND
                                            "Precios_Ex_Planta"."Producto" = 'Propano'
                                            THEN
                                                'Propano Industrial'
                                        ELSE "Precios_Ex_Planta"."Producto"
                                    END IN ( 
                                        'Premium 97 Sp', 
                                        'Super 95 Sp', 
                                        'Gasoil Comun', 
                                        'Gasoil Especial', 
                                        'Fuel Oil Pesado', 
                                        'Fuel Oil Medio', 
                                        'Queroseno Montevideo', 
                                        'Queroseno Interior' ) AND
                                    "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                    THEN
                                        'Precio Ex Planta (PEP)'
                                WHEN 
                                    NOT ( CASE 
                                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                        WHEN 
                                            :pProducto: = 'Propano Industrial' AND
                                            "Precios_Ex_Planta"."Producto" = 'Propano'
                                            THEN
                                                'Propano Industrial'
                                        ELSE "Precios_Ex_Planta"."Producto"
                                    END IN ( 
                                        'Premium 97 Sp', 
                                        'Super 95 Sp', 
                                        'Gasoil Comun', 
                                        'Gasoil Especial', 
                                        'Fuel Oil Pesado', 
                                        'Fuel Oil Medio' ) ) AND
                                    "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                    THEN
                                        'Precio Ex Planta (PEP)'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END IN ( 
                                'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                'Precio Ex Planta (PEP) sin flete secundario (impuestos incluidos)', 
                                'Precio Ex Planta (PEP)' )
                            THEN
                                1
                        ELSE 0
                    END
            WHEN 
                CASE 
                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                    WHEN 
                        :pProducto: = 'Propano Industrial' AND
                        "Precios_Ex_Planta"."Producto" = 'Propano'
                        THEN
                            'Propano Industrial'
                    ELSE "Precios_Ex_Planta"."Producto"
                END IN ( 
                    'Supergas' )
                THEN
                    CASE 
                        WHEN 
                            CASE 
                                WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                WHEN 
                                    :pProducto: = 'Propano Industrial' AND
                                    "Precios_Ex_Planta"."Producto" = 'Propano'
                                    THEN
                                        'Propano Industrial'
                                ELSE "Precios_Ex_Planta"."Producto"
                            END IN ( 
                                'Supergas' ) AND
                            CASE 
                                WHEN 
                                    CASE 
                                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                        WHEN 
                                            :pProducto: = 'Propano Industrial' AND
                                            "Precios_Ex_Planta"."Producto" = 'Propano'
                                            THEN
                                                'Propano Industrial'
                                        ELSE "Precios_Ex_Planta"."Producto"
                                    END IN ( 
                                        'Premium 97 Sp', 
                                        'Super 95 Sp', 
                                        'Gasoil Comun', 
                                        'Gasoil Especial', 
                                        'Fuel Oil Pesado', 
                                        'Fuel Oil Medio', 
                                        'Queroseno Montevideo', 
                                        'Queroseno Interior' ) AND
                                    "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                    THEN
                                        'Precio Ex Planta (PEP)'
                                WHEN 
                                    NOT ( CASE 
                                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                        WHEN 
                                            :pProducto: = 'Propano Industrial' AND
                                            "Precios_Ex_Planta"."Producto" = 'Propano'
                                            THEN
                                                'Propano Industrial'
                                        ELSE "Precios_Ex_Planta"."Producto"
                                    END IN ( 
                                        'Premium 97 Sp', 
                                        'Super 95 Sp', 
                                        'Gasoil Comun', 
                                        'Gasoil Especial', 
                                        'Fuel Oil Pesado', 
                                        'Fuel Oil Medio' ) ) AND
                                    "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                    THEN
                                        'Precio Ex Planta (PEP)'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END IN ( 
                                'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                'Precio Intermedio Transitorio (PIT) (impuestos incluidos)', 
                                'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                'PEP', 
                                'Factor X o factor de ajuste', 
                                'PPI sin tasas e impuestos', 
                                'Factor d para GLP Dec 205/023', 
                                'PPI n-1 Periodo URSEA', 
                                'PPI n-2 Periodo URSEA' )
                            THEN
                                1
                        ELSE 0
                    END
            WHEN 
                CASE 
                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                    WHEN 
                        :pProducto: = 'Propano Industrial' AND
                        "Precios_Ex_Planta"."Producto" = 'Propano'
                        THEN
                            'Propano Industrial'
                    ELSE "Precios_Ex_Planta"."Producto"
                END IN ( 
                    'Propano', 
                    'Supergas A Granel', 
                    'Propano Industrial' )
                THEN
                    CASE 
                        WHEN 
                            CASE 
                                WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                WHEN 
                                    :pProducto: = 'Propano Industrial' AND
                                    "Precios_Ex_Planta"."Producto" = 'Propano'
                                    THEN
                                        'Propano Industrial'
                                ELSE "Precios_Ex_Planta"."Producto"
                            END IN ( 
                                'Propano', 
                                'Supergas A Granel', 
                                'Propano Industrial' ) AND
                            CASE 
                                WHEN 
                                    CASE 
                                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                        WHEN 
                                            :pProducto: = 'Propano Industrial' AND
                                            "Precios_Ex_Planta"."Producto" = 'Propano'
                                            THEN
                                                'Propano Industrial'
                                        ELSE "Precios_Ex_Planta"."Producto"
                                    END IN ( 
                                        'Premium 97 Sp', 
                                        'Super 95 Sp', 
                                        'Gasoil Comun', 
                                        'Gasoil Especial', 
                                        'Fuel Oil Pesado', 
                                        'Fuel Oil Medio', 
                                        'Queroseno Montevideo', 
                                        'Queroseno Interior' ) AND
                                    "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                    THEN
                                        'Precio Ex Planta (PEP)'
                                WHEN 
                                    NOT ( CASE 
                                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                        WHEN 
                                            :pProducto: = 'Propano Industrial' AND
                                            "Precios_Ex_Planta"."Producto" = 'Propano'
                                            THEN
                                                'Propano Industrial'
                                        ELSE "Precios_Ex_Planta"."Producto"
                                    END IN ( 
                                        'Premium 97 Sp', 
                                        'Super 95 Sp', 
                                        'Gasoil Comun', 
                                        'Gasoil Especial', 
                                        'Fuel Oil Pesado', 
                                        'Fuel Oil Medio' ) ) AND
                                    "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                    THEN
                                        'Precio Ex Planta (PEP)'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END IN ( 
                                'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                'Precio Ex Planta (PEP)', 
                                'Factor X o factor de ajuste', 
                                'PPI sin tasas e impuestos', 
                                'PPI n-1 Periodo URSEA', 
                                'PPI n-2 Periodo URSEA' )
                            THEN
                                1
                        ELSE 0
                    END
            WHEN 
                CASE 
                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                    WHEN 
                        :pProducto: = 'Propano Industrial' AND
                        "Precios_Ex_Planta"."Producto" = 'Propano'
                        THEN
                            'Propano Industrial'
                    ELSE "Precios_Ex_Planta"."Producto"
                END IN ( 
                    'Aguarras', 
                    'Gasolina Av 100 Octa', 
                    'Gasolina Av 100 Octanos', 
                    'Gasolina Av 100 Octanos(Estado)', 
                    'Gasolina Av 100 Octanos(Particular)', 
                    'Jet A1', 
                    'Solvente 1197', 
                    'Disan', 
                    'Base insecticida', 
                    'Querosol', 
                    'Hexano Comercial' )
                THEN
                    CASE 
                        WHEN 
                            CASE 
                                WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                WHEN 
                                    :pProducto: = 'Propano Industrial' AND
                                    "Precios_Ex_Planta"."Producto" = 'Propano'
                                    THEN
                                        'Propano Industrial'
                                ELSE "Precios_Ex_Planta"."Producto"
                            END IN ( 
                                'Aguarras', 
                                'Gasolina Av 100 Octanos', 
                                'Gasolina Av 100 Octanos(Estado)', 
                                'Gasolina Av 100 Octanos(Particular)', 
                                'Jet A1', 
                                'Solvente 1197', 
                                'Disan', 
                                'Base insecticida', 
                                'Querosol', 
                                'Queroseno Montevideo', 
                                'Queroseno Interior', 
                                'Hexano Comercial' ) AND
                            CASE 
                                WHEN 
                                    CASE 
                                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                        WHEN 
                                            :pProducto: = 'Propano Industrial' AND
                                            "Precios_Ex_Planta"."Producto" = 'Propano'
                                            THEN
                                                'Propano Industrial'
                                        ELSE "Precios_Ex_Planta"."Producto"
                                    END IN ( 
                                        'Premium 97 Sp', 
                                        'Super 95 Sp', 
                                        'Gasoil Comun', 
                                        'Gasoil Especial', 
                                        'Fuel Oil Pesado', 
                                        'Fuel Oil Medio', 
                                        'Queroseno Montevideo', 
                                        'Queroseno Interior' ) AND
                                    "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                    THEN
                                        'Precio Ex Planta (PEP)'
                                WHEN 
                                    NOT ( CASE 
                                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                        WHEN 
                                            :pProducto: = 'Propano Industrial' AND
                                            "Precios_Ex_Planta"."Producto" = 'Propano'
                                            THEN
                                                'Propano Industrial'
                                        ELSE "Precios_Ex_Planta"."Producto"
                                    END IN ( 
                                        'Premium 97 Sp', 
                                        'Super 95 Sp', 
                                        'Gasoil Comun', 
                                        'Gasoil Especial', 
                                        'Fuel Oil Pesado', 
                                        'Fuel Oil Medio' ) ) AND
                                    "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                    THEN
                                        'Precio Ex Planta (PEP)'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END IN ( 
                                'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                'Precio Ex Planta (PEP)' )
                            THEN
                                1
                        ELSE 0
                    END
            WHEN 
                CASE 
                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                    WHEN 
                        :pProducto: = 'Propano Industrial' AND
                        "Precios_Ex_Planta"."Producto" = 'Propano'
                        THEN
                            'Propano Industrial'
                    ELSE "Precios_Ex_Planta"."Producto"
                END IN ( 
                    'Super 95 Sp', 
                    'Gasoil Comun', 
                    'Gasoil Especial', 
                    'Premium 97 Sp' )
                THEN
                    1
            ELSE 0
        END AS "C18", 
        CASE 
            
            CASE 
                WHEN 
                    CASE 
                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                        WHEN 
                            :pProducto: = 'Propano Industrial' AND
                            "Precios_Ex_Planta"."Producto" = 'Propano'
                            THEN
                                'Propano Industrial'
                        ELSE "Precios_Ex_Planta"."Producto"
                    END IN ( 
                        'Premium 97 Sp', 
                        'Super 95 Sp', 
                        'Gasoil Comun', 
                        'Gasoil Especial', 
                        'Fuel Oil Pesado', 
                        'Fuel Oil Medio', 
                        'Queroseno Montevideo', 
                        'Queroseno Interior' ) AND
                    "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                    THEN
                        'Precio Ex Planta (PEP)'
                WHEN 
                    NOT ( CASE 
                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                        WHEN 
                            :pProducto: = 'Propano Industrial' AND
                            "Precios_Ex_Planta"."Producto" = 'Propano'
                            THEN
                                'Propano Industrial'
                        ELSE "Precios_Ex_Planta"."Producto"
                    END IN ( 
                        'Premium 97 Sp', 
                        'Super 95 Sp', 
                        'Gasoil Comun', 
                        'Gasoil Especial', 
                        'Fuel Oil Pesado', 
                        'Fuel Oil Medio' ) ) AND
                    "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                    THEN
                        'Precio Ex Planta (PEP)'
                ELSE "Precios_Ex_Planta"."Concepto"
            END
            WHEN 'Precio de Venta al Público (PVP) (impuestos incluidos)' THEN 1
            WHEN 'Precio Intermedio Transitorio (PIT) (impuestos incluidos)' THEN 2
            WHEN 'Precio Ex Planta (PEP) (impuestos incluidos)' THEN 3
            WHEN 'Precio Ex Planta (PEP) sin flete secundario (impuestos incluidos)' THEN 4
            WHEN 'PPI sin tasas e impuestos + Factor X' THEN 5
            WHEN 'Precio Ex Planta (PEP)' THEN 6
            WHEN 'PEP' THEN 6
            WHEN 'Precio ex planta (netback PVP)' THEN 6
            WHEN 'Factor X o factor de ajuste' THEN 7
            WHEN 'PPI sin tasas e impuestos' THEN 8
            WHEN 'Monto diferencial por zonas "d"' THEN 9
            WHEN 'PPI n-1 Periodo URSEA' THEN 10
            WHEN 'PPI n-2 Periodo URSEA' THEN 11
            ELSE 9
        END AS "C19", 
        CASE 
            
            CASE 
                WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                WHEN 
                    :pProducto: = 'Propano Industrial' AND
                    "Precios_Ex_Planta"."Producto" = 'Propano'
                    THEN
                        'Propano Industrial'
                ELSE "Precios_Ex_Planta"."Producto"
            END
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
        END AS "C20", 
        "Precios_Ex_Planta"."TC" AS "C21", 
        "Precios_Ex_Planta"."Valor" AS "C22"
    FROM
        "APPBI"."DP"."Precios_Ex_Planta" "Precios_Ex_Planta" 
    WHERE 
        CAST(DATEPART(YEAR, "Precios_Ex_Planta"."Fecha") AS INTEGER) = :pAño: AND
        "Precios_Ex_Planta"."Concepto" IN ( 
            'Precio de Venta al Público (PVP) (impuestos incluidos)', 
            'Precio Intermedio Transitorio (PIT) (impuestos incluidos)', 
            'Precio Ex Planta (PEP) (impuestos incluidos)', 
            'Precio Ex Planta (PEP) sin flete secundario (impuestos incluidos)', 
            'PPI sin tasas e impuestos + Factor X', 
            'Factor X o factor de ajuste', 
            'PPI sin tasas e impuestos', 
            'Precio Ex Planta (PEP)', 
            'Factor d para GLP Dec 205/023', 
            'PEP', 
            'PPI n-1 Periodo URSEA', 
            'PPI n-2 Periodo URSEA' ) AND
        :pUnidad: = :pUnidad: AND
        CAST(
            CASE 
                WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                WHEN 
                    :pProducto: = 'Propano Industrial' AND
                    "Precios_Ex_Planta"."Producto" = 'Propano'
                    THEN
                        'Propano Industrial'
                ELSE "Precios_Ex_Planta"."Producto"
            END AS VARCHAR(50)) = :pProducto: AND
        CASE 
            WHEN 
                CASE 
                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                    WHEN 
                        :pProducto: = 'Propano Industrial' AND
                        "Precios_Ex_Planta"."Producto" = 'Propano'
                        THEN
                            'Propano Industrial'
                    ELSE "Precios_Ex_Planta"."Producto"
                END IN ( 
                    'Queroseno Montevideo' )
                THEN
                    CASE 
                        WHEN 
                            CASE 
                                WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                WHEN 
                                    :pProducto: = 'Propano Industrial' AND
                                    "Precios_Ex_Planta"."Producto" = 'Propano'
                                    THEN
                                        'Propano Industrial'
                                ELSE "Precios_Ex_Planta"."Producto"
                            END IN ( 
                                'Queroseno Montevideo' ) AND
                            CASE 
                                WHEN 
                                    CASE 
                                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                        WHEN 
                                            :pProducto: = 'Propano Industrial' AND
                                            "Precios_Ex_Planta"."Producto" = 'Propano'
                                            THEN
                                                'Propano Industrial'
                                        ELSE "Precios_Ex_Planta"."Producto"
                                    END IN ( 
                                        'Premium 97 Sp', 
                                        'Super 95 Sp', 
                                        'Gasoil Comun', 
                                        'Gasoil Especial', 
                                        'Fuel Oil Pesado', 
                                        'Fuel Oil Medio', 
                                        'Queroseno Montevideo', 
                                        'Queroseno Interior' ) AND
                                    "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                    THEN
                                        'Precio Ex Planta (PEP)'
                                WHEN 
                                    NOT ( CASE 
                                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                        WHEN 
                                            :pProducto: = 'Propano Industrial' AND
                                            "Precios_Ex_Planta"."Producto" = 'Propano'
                                            THEN
                                                'Propano Industrial'
                                        ELSE "Precios_Ex_Planta"."Producto"
                                    END IN ( 
                                        'Premium 97 Sp', 
                                        'Super 95 Sp', 
                                        'Gasoil Comun', 
                                        'Gasoil Especial', 
                                        'Fuel Oil Pesado', 
                                        'Fuel Oil Medio' ) ) AND
                                    "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                    THEN
                                        'Precio Ex Planta (PEP)'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END IN ( 
                                'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                'Precio Intermedio Transitorio (PIT) (impuestos incluidos)', 
                                'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                'Precio Ex Planta (PEP)' )
                            THEN
                                1
                        ELSE 0
                    END
            WHEN 
                CASE 
                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                    WHEN 
                        :pProducto: = 'Propano Industrial' AND
                        "Precios_Ex_Planta"."Producto" = 'Propano'
                        THEN
                            'Propano Industrial'
                    ELSE "Precios_Ex_Planta"."Producto"
                END IN ( 
                    'Queroseno Interior' )
                THEN
                    CASE 
                        WHEN 
                            CASE 
                                WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                WHEN 
                                    :pProducto: = 'Propano Industrial' AND
                                    "Precios_Ex_Planta"."Producto" = 'Propano'
                                    THEN
                                        'Propano Industrial'
                                ELSE "Precios_Ex_Planta"."Producto"
                            END IN ( 
                                'Queroseno Interior' ) AND
                            CASE 
                                WHEN 
                                    CASE 
                                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                        WHEN 
                                            :pProducto: = 'Propano Industrial' AND
                                            "Precios_Ex_Planta"."Producto" = 'Propano'
                                            THEN
                                                'Propano Industrial'
                                        ELSE "Precios_Ex_Planta"."Producto"
                                    END IN ( 
                                        'Premium 97 Sp', 
                                        'Super 95 Sp', 
                                        'Gasoil Comun', 
                                        'Gasoil Especial', 
                                        'Fuel Oil Pesado', 
                                        'Fuel Oil Medio', 
                                        'Queroseno Montevideo', 
                                        'Queroseno Interior' ) AND
                                    "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                    THEN
                                        'Precio Ex Planta (PEP)'
                                WHEN 
                                    NOT ( CASE 
                                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                        WHEN 
                                            :pProducto: = 'Propano Industrial' AND
                                            "Precios_Ex_Planta"."Producto" = 'Propano'
                                            THEN
                                                'Propano Industrial'
                                        ELSE "Precios_Ex_Planta"."Producto"
                                    END IN ( 
                                        'Premium 97 Sp', 
                                        'Super 95 Sp', 
                                        'Gasoil Comun', 
                                        'Gasoil Especial', 
                                        'Fuel Oil Pesado', 
                                        'Fuel Oil Medio' ) ) AND
                                    "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                    THEN
                                        'Precio Ex Planta (PEP)'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END IN ( 
                                'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                'Precio Intermedio Transitorio (PIT) (impuestos incluidos)', 
                                'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                'Precio Ex Planta (PEP) sin flete secundario (impuestos incluidos)', 
                                'Precio Ex Planta (PEP)' )
                            THEN
                                1
                        ELSE 0
                    END
            WHEN 
                CASE 
                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                    WHEN 
                        :pProducto: = 'Propano Industrial' AND
                        "Precios_Ex_Planta"."Producto" = 'Propano'
                        THEN
                            'Propano Industrial'
                    ELSE "Precios_Ex_Planta"."Producto"
                END IN ( 
                    'Fuel Oil Medio', 
                    'Fuel Oil Pesado' )
                THEN
                    CASE 
                        WHEN 
                            CASE 
                                WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                WHEN 
                                    :pProducto: = 'Propano Industrial' AND
                                    "Precios_Ex_Planta"."Producto" = 'Propano'
                                    THEN
                                        'Propano Industrial'
                                ELSE "Precios_Ex_Planta"."Producto"
                            END IN ( 
                                'Fuel Oil Medio', 
                                'Fuel Oil Pesado' ) AND
                            CASE 
                                WHEN 
                                    CASE 
                                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                        WHEN 
                                            :pProducto: = 'Propano Industrial' AND
                                            "Precios_Ex_Planta"."Producto" = 'Propano'
                                            THEN
                                                'Propano Industrial'
                                        ELSE "Precios_Ex_Planta"."Producto"
                                    END IN ( 
                                        'Premium 97 Sp', 
                                        'Super 95 Sp', 
                                        'Gasoil Comun', 
                                        'Gasoil Especial', 
                                        'Fuel Oil Pesado', 
                                        'Fuel Oil Medio', 
                                        'Queroseno Montevideo', 
                                        'Queroseno Interior' ) AND
                                    "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                    THEN
                                        'Precio Ex Planta (PEP)'
                                WHEN 
                                    NOT ( CASE 
                                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                        WHEN 
                                            :pProducto: = 'Propano Industrial' AND
                                            "Precios_Ex_Planta"."Producto" = 'Propano'
                                            THEN
                                                'Propano Industrial'
                                        ELSE "Precios_Ex_Planta"."Producto"
                                    END IN ( 
                                        'Premium 97 Sp', 
                                        'Super 95 Sp', 
                                        'Gasoil Comun', 
                                        'Gasoil Especial', 
                                        'Fuel Oil Pesado', 
                                        'Fuel Oil Medio' ) ) AND
                                    "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                    THEN
                                        'Precio Ex Planta (PEP)'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END IN ( 
                                'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                'Precio Ex Planta (PEP)', 
                                'Factor X o factor de ajuste', 
                                'PPI sin tasas e impuestos', 
                                'PPI n-1 Periodo URSEA', 
                                'PPI n-2 Periodo URSEA' )
                            THEN
                                1
                        ELSE 0
                    END
            WHEN 
                CASE 
                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                    WHEN 
                        :pProducto: = 'Propano Industrial' AND
                        "Precios_Ex_Planta"."Producto" = 'Propano'
                        THEN
                            'Propano Industrial'
                    ELSE "Precios_Ex_Planta"."Producto"
                END IN ( 
                    'Butano Desodorizado' )
                THEN
                    CASE 
                        WHEN 
                            CASE 
                                WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                WHEN 
                                    :pProducto: = 'Propano Industrial' AND
                                    "Precios_Ex_Planta"."Producto" = 'Propano'
                                    THEN
                                        'Propano Industrial'
                                ELSE "Precios_Ex_Planta"."Producto"
                            END IN ( 
                                'Butano Desodorizado' ) AND
                            CASE 
                                WHEN 
                                    CASE 
                                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                        WHEN 
                                            :pProducto: = 'Propano Industrial' AND
                                            "Precios_Ex_Planta"."Producto" = 'Propano'
                                            THEN
                                                'Propano Industrial'
                                        ELSE "Precios_Ex_Planta"."Producto"
                                    END IN ( 
                                        'Premium 97 Sp', 
                                        'Super 95 Sp', 
                                        'Gasoil Comun', 
                                        'Gasoil Especial', 
                                        'Fuel Oil Pesado', 
                                        'Fuel Oil Medio', 
                                        'Queroseno Montevideo', 
                                        'Queroseno Interior' ) AND
                                    "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                    THEN
                                        'Precio Ex Planta (PEP)'
                                WHEN 
                                    NOT ( CASE 
                                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                        WHEN 
                                            :pProducto: = 'Propano Industrial' AND
                                            "Precios_Ex_Planta"."Producto" = 'Propano'
                                            THEN
                                                'Propano Industrial'
                                        ELSE "Precios_Ex_Planta"."Producto"
                                    END IN ( 
                                        'Premium 97 Sp', 
                                        'Super 95 Sp', 
                                        'Gasoil Comun', 
                                        'Gasoil Especial', 
                                        'Fuel Oil Pesado', 
                                        'Fuel Oil Medio' ) ) AND
                                    "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                    THEN
                                        'Precio Ex Planta (PEP)'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END IN ( 
                                'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                'Precio Ex Planta (PEP) sin flete secundario (impuestos incluidos)', 
                                'Precio Ex Planta (PEP)' )
                            THEN
                                1
                        ELSE 0
                    END
            WHEN 
                CASE 
                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                    WHEN 
                        :pProducto: = 'Propano Industrial' AND
                        "Precios_Ex_Planta"."Producto" = 'Propano'
                        THEN
                            'Propano Industrial'
                    ELSE "Precios_Ex_Planta"."Producto"
                END IN ( 
                    'Supergas' )
                THEN
                    CASE 
                        WHEN 
                            CASE 
                                WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                WHEN 
                                    :pProducto: = 'Propano Industrial' AND
                                    "Precios_Ex_Planta"."Producto" = 'Propano'
                                    THEN
                                        'Propano Industrial'
                                ELSE "Precios_Ex_Planta"."Producto"
                            END IN ( 
                                'Supergas' ) AND
                            CASE 
                                WHEN 
                                    CASE 
                                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                        WHEN 
                                            :pProducto: = 'Propano Industrial' AND
                                            "Precios_Ex_Planta"."Producto" = 'Propano'
                                            THEN
                                                'Propano Industrial'
                                        ELSE "Precios_Ex_Planta"."Producto"
                                    END IN ( 
                                        'Premium 97 Sp', 
                                        'Super 95 Sp', 
                                        'Gasoil Comun', 
                                        'Gasoil Especial', 
                                        'Fuel Oil Pesado', 
                                        'Fuel Oil Medio', 
                                        'Queroseno Montevideo', 
                                        'Queroseno Interior' ) AND
                                    "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                    THEN
                                        'Precio Ex Planta (PEP)'
                                WHEN 
                                    NOT ( CASE 
                                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                        WHEN 
                                            :pProducto: = 'Propano Industrial' AND
                                            "Precios_Ex_Planta"."Producto" = 'Propano'
                                            THEN
                                                'Propano Industrial'
                                        ELSE "Precios_Ex_Planta"."Producto"
                                    END IN ( 
                                        'Premium 97 Sp', 
                                        'Super 95 Sp', 
                                        'Gasoil Comun', 
                                        'Gasoil Especial', 
                                        'Fuel Oil Pesado', 
                                        'Fuel Oil Medio' ) ) AND
                                    "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                    THEN
                                        'Precio Ex Planta (PEP)'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END IN ( 
                                'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                'Precio Intermedio Transitorio (PIT) (impuestos incluidos)', 
                                'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                'PEP', 
                                'Factor X o factor de ajuste', 
                                'PPI sin tasas e impuestos', 
                                'Factor d para GLP Dec 205/023', 
                                'PPI n-1 Periodo URSEA', 
                                'PPI n-2 Periodo URSEA' )
                            THEN
                                1
                        ELSE 0
                    END
            WHEN 
                CASE 
                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                    WHEN 
                        :pProducto: = 'Propano Industrial' AND
                        "Precios_Ex_Planta"."Producto" = 'Propano'
                        THEN
                            'Propano Industrial'
                    ELSE "Precios_Ex_Planta"."Producto"
                END IN ( 
                    'Propano', 
                    'Supergas A Granel', 
                    'Propano Industrial' )
                THEN
                    CASE 
                        WHEN 
                            CASE 
                                WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                WHEN 
                                    :pProducto: = 'Propano Industrial' AND
                                    "Precios_Ex_Planta"."Producto" = 'Propano'
                                    THEN
                                        'Propano Industrial'
                                ELSE "Precios_Ex_Planta"."Producto"
                            END IN ( 
                                'Propano', 
                                'Supergas A Granel', 
                                'Propano Industrial' ) AND
                            CASE 
                                WHEN 
                                    CASE 
                                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                        WHEN 
                                            :pProducto: = 'Propano Industrial' AND
                                            "Precios_Ex_Planta"."Producto" = 'Propano'
                                            THEN
                                                'Propano Industrial'
                                        ELSE "Precios_Ex_Planta"."Producto"
                                    END IN ( 
                                        'Premium 97 Sp', 
                                        'Super 95 Sp', 
                                        'Gasoil Comun', 
                                        'Gasoil Especial', 
                                        'Fuel Oil Pesado', 
                                        'Fuel Oil Medio', 
                                        'Queroseno Montevideo', 
                                        'Queroseno Interior' ) AND
                                    "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                    THEN
                                        'Precio Ex Planta (PEP)'
                                WHEN 
                                    NOT ( CASE 
                                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                        WHEN 
                                            :pProducto: = 'Propano Industrial' AND
                                            "Precios_Ex_Planta"."Producto" = 'Propano'
                                            THEN
                                                'Propano Industrial'
                                        ELSE "Precios_Ex_Planta"."Producto"
                                    END IN ( 
                                        'Premium 97 Sp', 
                                        'Super 95 Sp', 
                                        'Gasoil Comun', 
                                        'Gasoil Especial', 
                                        'Fuel Oil Pesado', 
                                        'Fuel Oil Medio' ) ) AND
                                    "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                    THEN
                                        'Precio Ex Planta (PEP)'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END IN ( 
                                'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                'Precio Ex Planta (PEP)', 
                                'Factor X o factor de ajuste', 
                                'PPI sin tasas e impuestos', 
                                'PPI n-1 Periodo URSEA', 
                                'PPI n-2 Periodo URSEA' )
                            THEN
                                1
                        ELSE 0
                    END
            WHEN 
                CASE 
                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                    WHEN 
                        :pProducto: = 'Propano Industrial' AND
                        "Precios_Ex_Planta"."Producto" = 'Propano'
                        THEN
                            'Propano Industrial'
                    ELSE "Precios_Ex_Planta"."Producto"
                END IN ( 
                    'Aguarras', 
                    'Gasolina Av 100 Octa', 
                    'Gasolina Av 100 Octanos', 
                    'Gasolina Av 100 Octanos(Estado)', 
                    'Gasolina Av 100 Octanos(Particular)', 
                    'Jet A1', 
                    'Solvente 1197', 
                    'Disan', 
                    'Base insecticida', 
                    'Querosol', 
                    'Hexano Comercial' )
                THEN
                    CASE 
                        WHEN 
                            CASE 
                                WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                WHEN 
                                    :pProducto: = 'Propano Industrial' AND
                                    "Precios_Ex_Planta"."Producto" = 'Propano'
                                    THEN
                                        'Propano Industrial'
                                ELSE "Precios_Ex_Planta"."Producto"
                            END IN ( 
                                'Aguarras', 
                                'Gasolina Av 100 Octanos', 
                                'Gasolina Av 100 Octanos(Estado)', 
                                'Gasolina Av 100 Octanos(Particular)', 
                                'Jet A1', 
                                'Solvente 1197', 
                                'Disan', 
                                'Base insecticida', 
                                'Querosol', 
                                'Queroseno Montevideo', 
                                'Queroseno Interior', 
                                'Hexano Comercial' ) AND
                            CASE 
                                WHEN 
                                    CASE 
                                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                        WHEN 
                                            :pProducto: = 'Propano Industrial' AND
                                            "Precios_Ex_Planta"."Producto" = 'Propano'
                                            THEN
                                                'Propano Industrial'
                                        ELSE "Precios_Ex_Planta"."Producto"
                                    END IN ( 
                                        'Premium 97 Sp', 
                                        'Super 95 Sp', 
                                        'Gasoil Comun', 
                                        'Gasoil Especial', 
                                        'Fuel Oil Pesado', 
                                        'Fuel Oil Medio', 
                                        'Queroseno Montevideo', 
                                        'Queroseno Interior' ) AND
                                    "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                    THEN
                                        'Precio Ex Planta (PEP)'
                                WHEN 
                                    NOT ( CASE 
                                        WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                                        WHEN 
                                            :pProducto: = 'Propano Industrial' AND
                                            "Precios_Ex_Planta"."Producto" = 'Propano'
                                            THEN
                                                'Propano Industrial'
                                        ELSE "Precios_Ex_Planta"."Producto"
                                    END IN ( 
                                        'Premium 97 Sp', 
                                        'Super 95 Sp', 
                                        'Gasoil Comun', 
                                        'Gasoil Especial', 
                                        'Fuel Oil Pesado', 
                                        'Fuel Oil Medio' ) ) AND
                                    "Precios_Ex_Planta"."Concepto" = 'PPI sin tasas e impuestos + Factor X'
                                    THEN
                                        'Precio Ex Planta (PEP)'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END IN ( 
                                'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                'Precio Ex Planta (PEP)' )
                            THEN
                                1
                        ELSE 0
                    END
            WHEN 
                CASE 
                    WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                    WHEN 
                        :pProducto: = 'Propano Industrial' AND
                        "Precios_Ex_Planta"."Producto" = 'Propano'
                        THEN
                            'Propano Industrial'
                    ELSE "Precios_Ex_Planta"."Producto"
                END IN ( 
                    'Super 95 Sp', 
                    'Gasoil Comun', 
                    'Gasoil Especial', 
                    'Premium 97 Sp' )
                THEN
                    1
            ELSE 0
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
    "D1"."C11", 
    "D1"."C12", 
    "D1"."C13", 
    "D1"."C14", 
    "D1"."C15", 
    "D1"."C16", 
    "D1"."C17", 
    "D1"."C18", 
    "D1"."C19", 
    "D1"."C20"