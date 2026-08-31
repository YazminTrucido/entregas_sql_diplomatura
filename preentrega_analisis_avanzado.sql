-- ====================================================================================
-- Autor: Yazmin Trucido
-- Descripción: Script de análisis avanzado con Window Functions.
-- ====================================================================================

-- CTE 1: Limpieza y agrupación de datos a nivel mensual por categoría
WITH ventas_mensuales AS (
    SELECT 
        DATE_TRUNC('month', v.fecha_venta) AS mes,
        cat.nombre AS categoria,
        SUM(v.cantidad * p.precio) AS total_ventas_mes
    FROM ventas v
    JOIN productos p ON v.id_producto = p.id_producto
    JOIN categorias cat ON p.id_categoria = cat.id_categoria
    GROUP BY 
        DATE_TRUNC('month', v.fecha_venta),
        cat.nombre
),

-- CTE 2: Cálculo de métricas avanzadas usando Window Functions
metricas_ventana AS (
    SELECT 
        mes,
        categoria,
        total_ventas_mes,
        -- Ranking: Particionamos por mes para comparar categorías dentro del mismo periodo. 
        -- Orden descendente para que el mayor ingreso sea el #1.
        RANK() OVER (PARTITION BY mes ORDER BY total_ventas_mes DESC) AS ranking_mensual,
        -- Running Total: Particionamos por categoría y ordenamos cronológicamente (mes)
        -- para acumular las ventas a lo largo del tiempo.
        SUM(total_ventas_mes) OVER (PARTITION BY categoria ORDER BY mes) AS ventas_acumuladas,
        -- Promedio Histórico: Particionamos solo por categoría para obtener el promedio 
        -- global de ventas de esa categoría en todos los meses registrados.
        AVG(total_ventas_mes) OVER (PARTITION BY categoria) AS promedio_historico_categoria
    FROM ventas_mensuales
)

-- Consulta Final: Selección de columnas y aplicación de lógica condicional de negocio
SELECT 
    mes,
    categoria,
    ROUND(total_ventas_mes, 2) AS total_ventas_mes,
    ranking_mensual,
    ROUND(ventas_acumuladas, 2) AS ventas_acumuladas,
    -- Comparativa: Comparamos la venta del mes actual contra el promedio histórico de la categoría
    CASE 
        WHEN total_ventas_mes > promedio_historico_categoria THEN 'Exitoso'
        ELSE 'Bajo el promedio'
    END AS desempeño_mensual
FROM metricas_ventana
ORDER BY 
    mes DESC, 
    ranking_mensual;