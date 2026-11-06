USE TFI;

-- Búsqueda de productos que esten disponibles

SELECT * FROM PRODUCTOS WHERE disponible = 1;

EXPLAIN SELECT * FROM PRODUCTOS WHERE disponible = 1;

CREATE INDEX idx_producto_disponible ON PRODUCTOS(disponible);

EXPLAIN SELECT * FROM PRODUCTOS WHERE disponible = 1;

-- Listar productos en un rango de precios

SELECT * FROM PRODUCTOS WHERE precio BETWEEN 400 AND 600;

-- Join: Listar todos los productos con su nombre de categoría

SELECT p.id_producto, p.nombre, p.precio, c.nombre AS categoria
FROM PRODUCTOS p
JOIN CATEGORIA c ON p.categoria_id = c.id_categoria;

-- Join: Calcular la cantidad de productos y el precio promedio por cada categoría

SELECT p.id_producto, p.nombre, p.precio, c.nombre AS categoria
FROM PRODUCTOS p
JOIN CATEGORIA c ON p.categoria_id = c.id_categoria;

-- GROUP BY + HAVING: Listar categorías con stock mayor a determinado valor

-- Subconsulta: Encontrar productos cuyo precio sea mayor al promedio

-- View: vista para que el usuario vea sus pedidos

CREATE VIEW vista_pedidos_detallados AS
SELECT u.id_usuario, u.nombre, u.apellido, p.total, p.fecha, p.estado 
FROM PEDIDO p 
JOIN USUARIO u ON u.id_usuario = p.usuario_id;

SELECT * FROM vista_pedidos_detallados WHERE id_usuario = 144;