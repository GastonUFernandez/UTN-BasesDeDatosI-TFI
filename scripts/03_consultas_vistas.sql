USE TFI;

-- Búsqueda de productos con precio específico

DROP INDEX idx_precio_producto ON PRODUCTOS;

SELECT * FROM PRODUCTOS WHERE precio = 122.41;

EXPLAIN SELECT * FROM PRODUCTOS WHERE precio = 122.41;

CREATE INDEX idx_precio_producto ON PRODUCTOS(precio);

EXPLAIN SELECT * FROM PRODUCTOS WHERE precio = 122.41;

-- Listar productos en un rango de precios

SELECT * FROM PRODUCTOS WHERE precio BETWEEN 400 AND 600;

-- Join: Listar todos los productos con su nombre de categoría

SELECT p.id_producto, p.nombre, p.precio, c.nombre AS categoria
FROM PRODUCTOS p
JOIN CATEGORIA c ON p.categoria_id = c.id_categoria;

-- Join: Calcular la cantidad de productos y el precio promedio por cada categoría

SELECT c.nombre, COUNT(*) as Cantidad, ROUND(AVG(p.precio), 2) AS precio_promedio_categoria
FROM PRODUCTOS p
JOIN CATEGORIA c ON p.categoria_id = c.id_categoria
GROUP BY c.id_categoria;

-- GROUP BY + HAVING: Listar categorías con stock mayor a determinado valor

SELECT c.nombre AS categoria, SUM(p.stock)
FROM CATEGORIA c
JOIN PRODUCTOS p ON p.categoria_id = c.id_categoria
GROUP BY c.nombre
HAVING SUM(p.stock) > 97000;

-- Subconsulta: Encontrar productos cuyo precio sea mayor al promedio

SELECT nombre, precio 
FROM PRODUCTOS 
WHERE precio > (
	SELECT AVG(precio) FROM PRODUCTOS
);

-- View: vista para que el usuario vea sus pedidos

CREATE VIEW vista_pedidos_detallados AS
SELECT u.id_usuario, u.nombre, u.apellido, p.total, p.fecha, p.estado 
FROM PEDIDO p 
JOIN USUARIO u ON u.id_usuario = p.usuario_id;

SELECT * FROM vista_pedidos_detallados WHERE id_usuario = 144;