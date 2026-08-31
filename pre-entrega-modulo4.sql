-- ====================================================================================
-- Autor: Yazmim Trucido
-- Descripción: Consultas multicapa para análisis de negocio combinando múltiples tablas 
--              mediante JOINs, GROUP BY y HAVING.
-- ====================================================================================


-- ------------------------------------------------------------------------------------
-- CONSULTA 1: Rentabilidad por categoría
-- Problema de negocio a resolver: Identificar cuáles son las categorías de productos 
-- más rentables para la empresa. Esto permite a los tomadores de decisiones enfocar 
-- las campañas de marketing y el presupuesto de re-stock en las categorías que generan 
-- mayores ingresos, en este caso, categorías que superen los $5000 en ventas totales.
-- ------------------------------------------------------------------------------------
SELECT 
    cat.nombre AS nombre_categoria,
    SUM(v.cantidad) AS unidades_vendidas,
    SUM(v.cantidad * p.precio) AS ingreso_total
FROM ventas v
JOIN productos p ON v.id_producto = p.id_producto
JOIN categorias cat ON p.id_categoria = cat.id_categoria
GROUP BY cat.id_categoria, cat.nombre
HAVING SUM(v.cantidad * p.precio) > 5000;


-- ------------------------------------------------------------------------------------
-- CONSULTA 2: Clientes sin compras
-- Problema de negocio a resolver: Detectar usuarios que se han registrado en la 
-- plataforma pero aún no han realizado su primera compra. 
-- Esta lista es fundamental para que el equipo de marketing envíe correos automatizados 
-- con descuentos de primera compra para incentivar la actividad.
-- ------------------------------------------------------------------------------------
SELECT 
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.email,
    COALESCE(SUM(v.cantidad), 0) AS total_unidades_compradas
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL
GROUP BY c.id_cliente, c.nombre, c.email;


-- ------------------------------------------------------------------------------------
-- CONSULTA 3: Top de compras por cliente
-- Problema de negocio a resolver: Conocer las preferencias individuales de nuestros 
-- clientes y su nivel de actividad. Al saber cuál es el producto que más consumen 
-- y cuándo fue la última vez que compraron, el equipo de ventas puede enviar recordatorios 
-- o sugerencias personalizadas.
-- ------------------------------------------------------------------------------------
SELECT DISTINCT ON (c.id_cliente)
    c.nombre AS nombre_cliente,
    p.nombre AS producto_mas_comprado,
    SUM(v.cantidad) AS total_unidades_de_este_producto,
    MAX(v.fecha_venta) AS ultima_transaccion
FROM clientes c
JOIN ventas v ON c.id_cliente = v.id_cliente
JOIN productos p ON v.id_producto = p.id_producto
GROUP BY c.id_cliente, c.nombre, p.id_producto, p.nombre
ORDER BY c.id_cliente, SUM(v.cantidad) DESC;

