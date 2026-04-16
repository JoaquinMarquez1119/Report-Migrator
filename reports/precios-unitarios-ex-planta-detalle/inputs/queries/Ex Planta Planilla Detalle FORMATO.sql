WITH 
"Ex_Planta_Planilla_Detalle" AS 
    (
    SELECT
        "D1"."C0" AS "Fecha", 
        "D1"."C1" AS "Año", 
        "D1"."C2" AS "Concepto", 
        "D1"."C3" AS "Concepto2", 
        "D1"."C4" AS "Producto", 
        SUM("D1"."C21") AS "TC", 
        SUM("D1"."C22") AS "Valor", 
        SUM("D1"."C23") AS "Valor_USD_m3", 
        "D1"."C5" AS "Mes_Número", 
        "D1"."C6" AS "Mes_numero", 
        "D1"."C7" AS "Periodo_Mensual", 
        "D1"."C8" AS "Cantidad_dias", 
        "D1"."C9" AS "Dia", 
        "D1"."C10" AS "Filtro_Ultimos", 
        "D1"."C11" AS "Filtro_Ultimos1", 
        "D1"."C12" AS "Filtro_FO", 
        "D1"."C13" AS "Filtro_QInterior", 
        "D1"."C14" AS "Filtro_QMontevideo", 
        "D1"."C15" AS "Filtro_Butano", 
        "D1"."C16" AS "Filtro_Supergas", 
        "D1"."C17" AS "Filtro_Propano", 
        "D1"."C18" AS "Filtro", 
        :pUnidad: AS "Unidad", 
        "D1"."C19" AS "Orden", 
        "D1"."C20" AS "Decimales"
    FROM
        (
        SELECT
            "Precios_Ex_Planta"."Fecha" AS "C0", 
            CAST(DATEPART(YEAR, "Precios_Ex_Planta"."Fecha") AS INTEGER) AS "C1", 
            CASE "Precios_Ex_Planta"."Concepto"
                WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                ELSE "Precios_Ex_Planta"."Concepto"
            END AS "C2", 
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
                    CASE "Precios_Ex_Planta"."Concepto"
                        WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                        WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                        WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                        WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                        WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                        WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                        WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                        WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                        ELSE "Precios_Ex_Planta"."Concepto"
                    END = 'PPI sin tasas e impuestos + Factor X'
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
                    CASE "Precios_Ex_Planta"."Concepto"
                        WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                        WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                        WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                        WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                        WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                        WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                        WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                        WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                        ELSE "Precios_Ex_Planta"."Concepto"
                    END = 'PPI sin tasas e impuestos + Factor X'
                    THEN
                        'Precio Ex Planta (PEP)'
                ELSE 
                    
                    CASE "Precios_Ex_Planta"."Concepto"
                        WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                        WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                        WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                        WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                        WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                        WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                        WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                        WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                        ELSE "Precios_Ex_Planta"."Concepto"
                    END
            END AS "C3", 
            CASE 
                WHEN "Precios_Ex_Planta"."Producto" = 'GLP' THEN 'Supergas'
                WHEN 
                    :pProducto: = 'Propano Industrial' AND
                    "Precios_Ex_Planta"."Producto" = 'Propano'
                    THEN
                        'Propano Industrial'
                ELSE "Precios_Ex_Planta"."Producto"
            END AS "C4", 
            DATEPART(MONTH, "Precios_Ex_Planta"."Fecha") AS "C5", 
            CAST(DATEPART(MONTH, "Precios_Ex_Planta"."Fecha") AS INTEGER) AS "C6", 
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
            END AS "C7", 
            DATEPART(DAY, DATEADD(DAY, -1, DATEADD(MONTH, 1, DATEADD(DAY, -DAY("Precios_Ex_Planta"."Fecha") + 1, "Precios_Ex_Planta"."Fecha")))) AS "C8", 
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
            END AS "C9", 
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
                        'Gasolina Av 100 Octanos', 
                        'Gasolina Av 100 Octanos(Estado)', 
                        'Gasolina Av 100 Octanos(Particular)', 
                        'Jet A1' ) AND
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
                            CASE "Precios_Ex_Planta"."Concepto"
                                WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END = 'PPI sin tasas e impuestos + Factor X'
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
                            CASE "Precios_Ex_Planta"."Concepto"
                                WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END = 'PPI sin tasas e impuestos + Factor X'
                            THEN
                                'Precio Ex Planta (PEP)'
                        ELSE 
                            
                            CASE "Precios_Ex_Planta"."Concepto"
                                WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END
                    END IN ( 
                        'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                        'Precio Ex Planta (PEP) (impuestos incluidos)', 
                        'Tasa IMM sobre CL dist primaria al interior (23,2% del total)', 
                        'IMESI', 
                        'Tasa URSEA etapa primaria', 
                        'FUDAEE', 
                        'PPI sin tasas e impuestos', 
                        'Precio Ex Planta (PEP)' )
                    THEN
                        1
                ELSE 0
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
                        'Aguarras', 
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
                            CASE "Precios_Ex_Planta"."Concepto"
                                WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END = 'PPI sin tasas e impuestos + Factor X'
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
                            CASE "Precios_Ex_Planta"."Concepto"
                                WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END = 'PPI sin tasas e impuestos + Factor X'
                            THEN
                                'Precio Ex Planta (PEP)'
                        ELSE 
                            
                            CASE "Precios_Ex_Planta"."Concepto"
                                WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END
                    END IN ( 
                        'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                        'Margen de distribuidoras', 
                        'IVA etapa distribución', 
                        'Precio Ex Planta (PEP) (impuestos incluidos)', 
                        'Tasa IMM sobre CL dist primaria al interior (23,2% del total)', 
                        'IMESI', 
                        'Tasa URSEA etapa primaria', 
                        'FUDAEE', 
                        'IVA etapa primaria', 
                        'PPI sin tasas e impuestos', 
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
                            CASE "Precios_Ex_Planta"."Concepto"
                                WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END = 'PPI sin tasas e impuestos + Factor X'
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
                            CASE "Precios_Ex_Planta"."Concepto"
                                WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END = 'PPI sin tasas e impuestos + Factor X'
                            THEN
                                'Precio Ex Planta (PEP)'
                        ELSE 
                            
                            CASE "Precios_Ex_Planta"."Concepto"
                                WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END
                    END IN ( 
                        'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                        'Margen de distribuidoras', 
                        'Tasa URSEA etapa distribución', 
                        'IVA etapa distribución', 
                        'Precio Ex Planta (PEP) (impuestos incluidos)', 
                        'Tasa URSEA etapa primaria', 
                        'FUDAEE', 
                        'IVA etapa primaria', 
                        'Precio Ex Planta (PEP)', 
                        'Factor X o factor de ajuste', 
                        'PPI sin tasas e impuestos', 
                        'PPI n-1 Periodo URSEA', 
                        'PPI n-2 Periodo URSEA' )
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
                            CASE "Precios_Ex_Planta"."Concepto"
                                WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END = 'PPI sin tasas e impuestos + Factor X'
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
                            CASE "Precios_Ex_Planta"."Concepto"
                                WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END = 'PPI sin tasas e impuestos + Factor X'
                            THEN
                                'Precio Ex Planta (PEP)'
                        ELSE 
                            
                            CASE "Precios_Ex_Planta"."Concepto"
                                WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END
                    END IN ( 
                        'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                        'Bonificación estaciones de servicio', 
                        'Tasa URSEA etapa venta al público', 
                        'Precio Intermedio Transitorio (PIT) (impuestos incluidos)', 
                        'Margen de distribuidoras', 
                        'Tasa URSEA etapa distribución', 
                        'Precio Ex Planta (PEP) (impuestos incluidos)', 
                        'Flete, de plantas a estaciones de servicio (mes n-2)', 
                        'Tasa URSEA etapa secundaria', 
                        'IVA etapa secundaria', 
                        'Precio Ex Planta (PEP) sin flete secundario (impuestos incluidos)', 
                        'IMESI', 
                        'Tasa URSEA etapa primaria', 
                        'FUDAEE', 
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
                            CASE "Precios_Ex_Planta"."Concepto"
                                WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END = 'PPI sin tasas e impuestos + Factor X'
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
                            CASE "Precios_Ex_Planta"."Concepto"
                                WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END = 'PPI sin tasas e impuestos + Factor X'
                            THEN
                                'Precio Ex Planta (PEP)'
                        ELSE 
                            
                            CASE "Precios_Ex_Planta"."Concepto"
                                WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END
                    END IN ( 
                        'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                        'Bonificación estaciones de servicio', 
                        'Tasa URSEA etapa venta al público', 
                        'Precio Intermedio Transitorio (PIT) (impuestos incluidos)', 
                        'Margen de distribuidoras', 
                        'Tasa URSEA etapa distribución', 
                        'Precio Ex Planta (PEP) (impuestos incluidos)', 
                        'IMESI', 
                        'Tasa URSEA etapa primaria', 
                        'FUDAEE', 
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
                            CASE "Precios_Ex_Planta"."Concepto"
                                WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END = 'PPI sin tasas e impuestos + Factor X'
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
                            CASE "Precios_Ex_Planta"."Concepto"
                                WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END = 'PPI sin tasas e impuestos + Factor X'
                            THEN
                                'Precio Ex Planta (PEP)'
                        ELSE 
                            
                            CASE "Precios_Ex_Planta"."Concepto"
                                WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END
                    END IN ( 
                        'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                        'Precio Ex Planta (PEP) sin flete secundario (impuestos incluidos)', 
                        'Tasa IMM sobre CL dist primaria al interior (23,2% del total)', 
                        'Tasa URSEA etapa primaria', 
                        'FUDAEE', 
                        'IVA etapa primaria', 
                        'Precio Ex Planta (PEP)' )
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
                            CASE "Precios_Ex_Planta"."Concepto"
                                WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END = 'PPI sin tasas e impuestos + Factor X'
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
                            CASE "Precios_Ex_Planta"."Concepto"
                                WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END = 'PPI sin tasas e impuestos + Factor X'
                            THEN
                                'Precio Ex Planta (PEP)'
                        ELSE 
                            
                            CASE "Precios_Ex_Planta"."Concepto"
                                WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END
                    END IN ( 
                        'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                        'Margen de distribución de GLP envasado', 
                        'Tasa URSEA etapa venta al público', 
                        'IVA etapa venta al público', 
                        'Precio Intermedio Transitorio (PIT) (impuestos incluidos)', 
                        'Margen de envasado', 
                        'Margen de distribuidoras', 
                        'Tasa URSEA etapa distribución', 
                        'IVA etapa distribución', 
                        'Precio Ex Planta (PEP) (impuestos incluidos)', 
                        'Tasa URSEA etapa primaria', 
                        'FUDAEE', 
                        'IVA etapa primaria', 
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
                            CASE "Precios_Ex_Planta"."Concepto"
                                WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END = 'PPI sin tasas e impuestos + Factor X'
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
                            CASE "Precios_Ex_Planta"."Concepto"
                                WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END = 'PPI sin tasas e impuestos + Factor X'
                            THEN
                                'Precio Ex Planta (PEP)'
                        ELSE 
                            
                            CASE "Precios_Ex_Planta"."Concepto"
                                WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                ELSE "Precios_Ex_Planta"."Concepto"
                            END
                    END IN ( 
                        'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                        'Margen de distribuidoras', 
                        'Tasa URSEA etapa distribución', 
                        'IVA etapa distribución', 
                        'Precio Ex Planta (PEP) (impuestos incluidos)', 
                        'Tasa URSEA etapa primaria', 
                        'FUDAEE', 
                        'IVA etapa primaria', 
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
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END = 'PPI sin tasas e impuestos + Factor X'
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
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    ELSE 
                                        
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END
                                END IN ( 
                                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                    'Bonificación estaciones de servicio', 
                                    'Tasa URSEA etapa venta al público', 
                                    'Precio Intermedio Transitorio (PIT) (impuestos incluidos)', 
                                    'Margen de distribuidoras', 
                                    'Tasa URSEA etapa distribución', 
                                    'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                    'IMESI', 
                                    'Tasa URSEA etapa primaria', 
                                    'FUDAEE', 
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
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END = 'PPI sin tasas e impuestos + Factor X'
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
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    ELSE 
                                        
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END
                                END IN ( 
                                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                    'Bonificación estaciones de servicio', 
                                    'Tasa URSEA etapa venta al público', 
                                    'Precio Intermedio Transitorio (PIT) (impuestos incluidos)', 
                                    'Margen de distribuidoras', 
                                    'Tasa URSEA etapa distribución', 
                                    'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                    'Flete, de plantas a estaciones de servicio (mes n-2)', 
                                    'Tasa URSEA etapa secundaria', 
                                    'IVA etapa secundaria', 
                                    'Precio Ex Planta (PEP) sin flete secundario (impuestos incluidos)', 
                                    'IMESI', 
                                    'Tasa URSEA etapa primaria', 
                                    'FUDAEE', 
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
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END = 'PPI sin tasas e impuestos + Factor X'
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
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    ELSE 
                                        
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END
                                END IN ( 
                                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                    'Margen de distribuidoras', 
                                    'Tasa URSEA etapa distribución', 
                                    'IVA etapa distribución', 
                                    'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                    'Tasa URSEA etapa primaria', 
                                    'FUDAEE', 
                                    'IVA etapa primaria', 
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
                        'Gasolina Av 100 Octa', 
                        'Gasolina Av 100 Octanos', 
                        'Gasolina Av 100 Octanos(Estado)', 
                        'Gasolina Av 100 Octanos(Particular)', 
                        'Jet A1' )
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
                                    'Gasolina Av 100 Octanos', 
                                    'Gasolina Av 100 Octanos(Estado)', 
                                    'Gasolina Av 100 Octanos(Particular)', 
                                    'Jet A1' ) AND
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
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END = 'PPI sin tasas e impuestos + Factor X'
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
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    ELSE 
                                        
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END
                                END IN ( 
                                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                    'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                    'Tasa IMM sobre CL dist primaria al interior (23,2% del total)', 
                                    'IMESI', 
                                    'Tasa URSEA etapa primaria', 
                                    'FUDAEE', 
                                    'PPI sin tasas e impuestos', 
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
                        'Aguarras', 
                        'Solvente 1197', 
                        'Disan', 
                        'Base insecticida', 
                        'Querosol', 
                        'Queroseno Montevideo', 
                        'Queroseno Interior', 
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
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END = 'PPI sin tasas e impuestos + Factor X'
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
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    ELSE 
                                        
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END
                                END IN ( 
                                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                    'Margen de distribuidoras', 
                                    'IVA etapa distribución', 
                                    'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                    'Tasa IMM sobre CL dist primaria al interior (23,2% del total)', 
                                    'IMESI', 
                                    'Tasa URSEA etapa primaria', 
                                    'FUDAEE', 
                                    'IVA etapa primaria', 
                                    'PPI sin tasas e impuestos', 
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
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END = 'PPI sin tasas e impuestos + Factor X'
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
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    ELSE 
                                        
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END
                                END IN ( 
                                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                    'Precio Ex Planta (PEP) sin flete secundario (impuestos incluidos)', 
                                    'Tasa IMM sobre CL dist primaria al interior (23,2% del total)', 
                                    'Tasa URSEA etapa primaria', 
                                    'FUDAEE', 
                                    'IVA etapa primaria', 
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
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END = 'PPI sin tasas e impuestos + Factor X'
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
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    ELSE 
                                        
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END
                                END IN ( 
                                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                    'Margen de distribución de GLP envasado', 
                                    'Tasa URSEA etapa venta al público', 
                                    'IVA etapa venta al público', 
                                    'Precio Intermedio Transitorio (PIT) (impuestos incluidos)', 
                                    'Margen de envasado', 
                                    'Margen de distribuidoras', 
                                    'Tasa URSEA etapa distribución', 
                                    'IVA etapa distribución', 
                                    'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                    'Tasa URSEA etapa primaria', 
                                    'FUDAEE', 
                                    'IVA etapa primaria', 
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
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END = 'PPI sin tasas e impuestos + Factor X'
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
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    ELSE 
                                        
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END
                                END IN ( 
                                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                    'Margen de distribuidoras', 
                                    'Tasa URSEA etapa distribución', 
                                    'IVA etapa distribución', 
                                    'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                    'Tasa URSEA etapa primaria', 
                                    'FUDAEE', 
                                    'IVA etapa primaria', 
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
                        CASE "Precios_Ex_Planta"."Concepto"
                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                            ELSE "Precios_Ex_Planta"."Concepto"
                        END = 'PPI sin tasas e impuestos + Factor X'
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
                        CASE "Precios_Ex_Planta"."Concepto"
                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                            ELSE "Precios_Ex_Planta"."Concepto"
                        END = 'PPI sin tasas e impuestos + Factor X'
                        THEN
                            'Precio Ex Planta (PEP)'
                    ELSE 
                        
                        CASE "Precios_Ex_Planta"."Concepto"
                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                            ELSE "Precios_Ex_Planta"."Concepto"
                        END
                END
                WHEN 'Precio de Venta al Público (PVP) (impuestos incluidos)' THEN 1
                WHEN 'Margen de distribución de GLP envasado' THEN 2
                WHEN 'Tasa URSEA etapa venta al público' THEN 3
                WHEN 'IVA etapa venta al público' THEN 3
                WHEN 'Precio Intermedio Transitorio (PIT) (impuestos incluidos)' THEN 4
                WHEN 'Bonificación estaciones de servicio' THEN 2
                WHEN 'Tasa URSEA etapa venta al público' THEN 3
                WHEN 'IVA etapa venta al público' THEN 4
                WHEN 'Precio Intermedio Transitorio (PIT) (impuestos incluidos)' THEN 5
                WHEN 'Margen de envasado' THEN 5
                WHEN 'Margen de distribuidoras' THEN 6
                WHEN 'Tasa URSEA etapa distribución' THEN 7
                WHEN 'IVA etapa distribución' THEN 8
                WHEN 'Precio Ex Planta (PEP) (impuestos incluidos)' THEN 9
                WHEN 'Flete, de plantas a estaciones de servicio (mes n-2)' THEN 10
                WHEN 'Tasa inflamable etapa secundaria' THEN 11
                WHEN 'Tasa URSEA etapa secundaria' THEN 12
                WHEN 'IVA etapa secundaria' THEN 13
                WHEN 'Compensación Con Fin Social (CFS)' THEN 14
                WHEN 'Precio Ex Planta (PEP) sin flete secundario (impuestos incluidos)' THEN 15
                WHEN 'Tasa IMM sobre CL dist primaria al interior (23,2% del total)' THEN 16
                WHEN 'IMESI' THEN 17
                WHEN 'Impuesto CO2' THEN 17
                WHEN 'Tasa URSEA etapa primaria' THEN 18
                WHEN 'FUDAEE' THEN 19
                WHEN 'Fideicomiso Gasoil (dto. 347/006)' THEN 20
                WHEN 'IVA etapa primaria' THEN 21
                WHEN 'PPI sin tasas e impuestos + Factor X' THEN 22
                WHEN 'Precio Ex Planta (PEP)' THEN 24
                WHEN 'PEP' THEN 24
                WHEN 'Factor X o factor de ajuste' THEN 25
                WHEN 'Factor de ajuste' THEN 26
                WHEN 'PPI sin tasas e impuestos' THEN 27
                WHEN 'PEP calculado por URSEA (*)' THEN 27
                ELSE 28
            END AS "C19", 
            CASE 
                WHEN 
                    CASE "Precios_Ex_Planta"."Concepto"
                        WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                        WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                        WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                        WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                        WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                        WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                        WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                        WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                        ELSE "Precios_Ex_Planta"."Concepto"
                    END IN ( 
                        'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                        'Precio Intermedio Transitorio (PIT) (impuestos incluidos)', 
                        'Precio Ex Planta (PEP) (impuestos incluidos)', 
                        'Precio Ex Planta (PEP) sin flete secundario (impuestos incluidos)', 
                        'PPI sin tasas e impuestos + Factor X', 
                        'Factor X o factor de ajuste', 
                        'PPI sin tasas e impuestos' )
                    THEN
                        1
                ELSE 0
            END AS "C20", 
            "Precios_Ex_Planta"."TC" AS "C21", 
            "Precios_Ex_Planta"."Valor" AS "C22", 
            ("Precios_Ex_Planta"."Valor" / NULLIF("Precios_Ex_Planta"."TC", 0)) * 1000 AS "C23"
        FROM
            "APPBI"."DP"."Precios_Ex_Planta" "Precios_Ex_Planta" 
        WHERE 
            CAST(DATEPART(YEAR, "Precios_Ex_Planta"."Fecha") AS INTEGER) = :pAño: AND
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
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END = 'PPI sin tasas e impuestos + Factor X'
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
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    ELSE 
                                        
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END
                                END IN ( 
                                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                    'Bonificación estaciones de servicio', 
                                    'Tasa URSEA etapa venta al público', 
                                    'Precio Intermedio Transitorio (PIT) (impuestos incluidos)', 
                                    'Margen de distribuidoras', 
                                    'Tasa URSEA etapa distribución', 
                                    'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                    'IMESI', 
                                    'Tasa URSEA etapa primaria', 
                                    'FUDAEE', 
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
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END = 'PPI sin tasas e impuestos + Factor X'
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
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    ELSE 
                                        
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END
                                END IN ( 
                                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                    'Bonificación estaciones de servicio', 
                                    'Tasa URSEA etapa venta al público', 
                                    'Precio Intermedio Transitorio (PIT) (impuestos incluidos)', 
                                    'Margen de distribuidoras', 
                                    'Tasa URSEA etapa distribución', 
                                    'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                    'Flete, de plantas a estaciones de servicio (mes n-2)', 
                                    'Tasa URSEA etapa secundaria', 
                                    'IVA etapa secundaria', 
                                    'Precio Ex Planta (PEP) sin flete secundario (impuestos incluidos)', 
                                    'IMESI', 
                                    'Tasa URSEA etapa primaria', 
                                    'FUDAEE', 
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
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END = 'PPI sin tasas e impuestos + Factor X'
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
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    ELSE 
                                        
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END
                                END IN ( 
                                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                    'Margen de distribuidoras', 
                                    'Tasa URSEA etapa distribución', 
                                    'IVA etapa distribución', 
                                    'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                    'Tasa URSEA etapa primaria', 
                                    'FUDAEE', 
                                    'IVA etapa primaria', 
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
                        'Gasolina Av 100 Octa', 
                        'Gasolina Av 100 Octanos', 
                        'Gasolina Av 100 Octanos(Estado)', 
                        'Gasolina Av 100 Octanos(Particular)', 
                        'Jet A1' )
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
                                    'Gasolina Av 100 Octanos', 
                                    'Gasolina Av 100 Octanos(Estado)', 
                                    'Gasolina Av 100 Octanos(Particular)', 
                                    'Jet A1' ) AND
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
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END = 'PPI sin tasas e impuestos + Factor X'
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
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    ELSE 
                                        
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END
                                END IN ( 
                                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                    'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                    'Tasa IMM sobre CL dist primaria al interior (23,2% del total)', 
                                    'IMESI', 
                                    'Tasa URSEA etapa primaria', 
                                    'FUDAEE', 
                                    'PPI sin tasas e impuestos', 
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
                        'Aguarras', 
                        'Solvente 1197', 
                        'Disan', 
                        'Base insecticida', 
                        'Querosol', 
                        'Queroseno Montevideo', 
                        'Queroseno Interior', 
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
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END = 'PPI sin tasas e impuestos + Factor X'
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
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    ELSE 
                                        
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END
                                END IN ( 
                                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                    'Margen de distribuidoras', 
                                    'IVA etapa distribución', 
                                    'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                    'Tasa IMM sobre CL dist primaria al interior (23,2% del total)', 
                                    'IMESI', 
                                    'Tasa URSEA etapa primaria', 
                                    'FUDAEE', 
                                    'IVA etapa primaria', 
                                    'PPI sin tasas e impuestos', 
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
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END = 'PPI sin tasas e impuestos + Factor X'
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
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    ELSE 
                                        
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END
                                END IN ( 
                                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                    'Precio Ex Planta (PEP) sin flete secundario (impuestos incluidos)', 
                                    'Tasa IMM sobre CL dist primaria al interior (23,2% del total)', 
                                    'Tasa URSEA etapa primaria', 
                                    'FUDAEE', 
                                    'IVA etapa primaria', 
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
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END = 'PPI sin tasas e impuestos + Factor X'
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
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    ELSE 
                                        
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END
                                END IN ( 
                                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                    'Margen de distribución de GLP envasado', 
                                    'Tasa URSEA etapa venta al público', 
                                    'IVA etapa venta al público', 
                                    'Precio Intermedio Transitorio (PIT) (impuestos incluidos)', 
                                    'Margen de envasado', 
                                    'Margen de distribuidoras', 
                                    'Tasa URSEA etapa distribución', 
                                    'IVA etapa distribución', 
                                    'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                    'Tasa URSEA etapa primaria', 
                                    'FUDAEE', 
                                    'IVA etapa primaria', 
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
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END = 'PPI sin tasas e impuestos + Factor X'
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
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END = 'PPI sin tasas e impuestos + Factor X'
                                        THEN
                                            'Precio Ex Planta (PEP)'
                                    ELSE 
                                        
                                        CASE "Precios_Ex_Planta"."Concepto"
                                            WHEN 'Tasa IMM sobre CL despachado en la tablada para EESS (77% restante)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa IMM (para que cierre 0.6% PVP sin impuestos)' THEN 'Tasa inflamable etapa secundaria'
                                            WHEN 'Tasa URSEA flete, de plantas a estaciones de servicio (mes n-2)' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA S/ IMM cierre' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'Tasa URSEA CFS' THEN 'Tasa URSEA etapa secundaria'
                                            WHEN 'IVA flete, de plantas a estaciones de servicio (mes n-2) + compensación' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA S/ IMM y URSEA cierre ' THEN 'IVA etapa secundaria'
                                            WHEN 'IVA CFS' THEN 'IVA etapa secundaria'
                                            ELSE "Precios_Ex_Planta"."Concepto"
                                        END
                                END IN ( 
                                    'Precio de Venta al Público (PVP) (impuestos incluidos)', 
                                    'Margen de distribuidoras', 
                                    'Tasa URSEA etapa distribución', 
                                    'IVA etapa distribución', 
                                    'Precio Ex Planta (PEP) (impuestos incluidos)', 
                                    'Tasa URSEA etapa primaria', 
                                    'FUDAEE', 
                                    'IVA etapa primaria', 
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
    )
SELECT
    "Ex_Planta_Planilla_Detalle"."Año" AS "Año", 
    "Ex_Planta_Planilla_Detalle"."Fecha" AS "Fecha", 
    "Ex_Planta_Planilla_Detalle"."Dia" AS "Dia", 
    "Ex_Planta_Planilla_Detalle"."Concepto2" AS "Concepto2", 
    SUM(
        CASE 
            WHEN "Ex_Planta_Planilla_Detalle"."Año" > 2021 THEN 0
            ELSE "Ex_Planta_Planilla_Detalle"."TC"
        END) AS "TC", 
    SUM("Ex_Planta_Planilla_Detalle"."Valor") AS "Valor", 
    SUM("Ex_Planta_Planilla_Detalle"."Valor_USD_m3") AS "Valor_USD_m3", 
    "Ex_Planta_Planilla_Detalle"."Orden" AS "Orden", 
    "Ex_Planta_Planilla_Detalle"."Decimales" AS "Decimales", 
    "Ex_Planta_Planilla_Detalle"."Producto" AS "Producto"
FROM
    "Ex_Planta_Planilla_Detalle" 
GROUP BY 
    "Ex_Planta_Planilla_Detalle"."Año", 
    "Ex_Planta_Planilla_Detalle"."Fecha", 
    "Ex_Planta_Planilla_Detalle"."Dia", 
    "Ex_Planta_Planilla_Detalle"."Concepto2", 
    "Ex_Planta_Planilla_Detalle"."Orden", 
    "Ex_Planta_Planilla_Detalle"."Decimales", 
    "Ex_Planta_Planilla_Detalle"."Producto"