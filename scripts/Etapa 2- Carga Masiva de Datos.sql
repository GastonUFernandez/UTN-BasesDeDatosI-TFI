-- =========================================================================
-- TFI - BASES DE DATOS I: ESTRUCTURA Y CARGA MASIVA (ETAPA 2)
-- =========================================================================

CREATE DATABASE IF NOT EXISTS TFI;
USE TFI;

-- 1. Tabla CATEGORIA
CREATE TABLE IF NOT EXISTS CATEGORIA (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    eliminado BOOLEAN NOT NULL DEFAULT FALSE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tabla PRODUCTOS
CREATE TABLE IF NOT EXISTS PRODUCTOS (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    categoria_id INT NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    precio DECIMAL(12,2) NOT NULL CHECK (precio >= 0),
    descripcion TEXT,
    stock INT NOT NULL CHECK (stock >= 0),
    disponible BOOLEAN NOT NULL,
    eliminado BOOLEAN NOT NULL DEFAULT FALSE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_categoria FOREIGN KEY (categoria_id) REFERENCES CATEGORIA(id_categoria)
);

-- 3. Tabla USUARIO (Roles alineados a 'ADMIN' y 'USUARIO')
CREATE TABLE IF NOT EXISTS USUARIO (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    celular VARCHAR(30),
    contraseña VARCHAR(255) NOT NULL,
    rol VARCHAR(50) NOT NULL CHECK (rol IN ('ADMIN', 'USUARIO')),
    eliminado BOOLEAN NOT NULL DEFAULT FALSE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 4. Tabla PEDIDO
CREATE TABLE IF NOT EXISTS PEDIDO (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    fecha DATETIME NOT NULL,
    estado VARCHAR(50) NOT NULL CHECK (estado IN ('PENDIENTE', 'CONFIRMADO', 'TERMINADO', 'CANCELADO')),
    total DECIMAL(12,2) NOT NULL CHECK (total >= 0),
    forma_de_pago VARCHAR(50) NOT NULL CHECK (forma_de_pago IN ('TARJETA', 'TRANSFERENCIA', 'EFECTIVO')),
    eliminado BOOLEAN NOT NULL DEFAULT FALSE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_usuario FOREIGN KEY (usuario_id) REFERENCES USUARIO(id_usuario)
);

-- 5. Tabla DETALLE_PEDIDO
CREATE TABLE IF NOT EXISTS DETALLE_PEDIDO (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    subtotal DECIMAL(12,2) NOT NULL CHECK (subtotal >= 0),
    CONSTRAINT fk_pedido FOREIGN KEY (pedido_id) REFERENCES PEDIDO(id_pedido),
    CONSTRAINT fk_producto FOREIGN KEY (producto_id) REFERENCES PRODUCTOS(id_producto)
);

-- 1. Desactivar temporalmente las restricciones de FK para poder vaciar sin problemas
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE DETALLE_PEDIDO;
TRUNCATE TABLE PEDIDO;
TRUNCATE TABLE PRODUCTOS;
TRUNCATE TABLE USUARIO;
TRUNCATE TABLE CATEGORIA;

-- Volver a activar las restricciones de FK
SET FOREIGN_KEY_CHECKS = 1;

-- 2. Configurar la profundidad de recursividad
SET cte_max_recursion_depth = 50000;

-- 3. Inserción de Categorías Semilla
INSERT INTO CATEGORIA (nombre, descripcion) VALUES 
('Tecnología', 'Dispositivos y accesorios electrónicos'),
('Ropa', 'Indumentaria y calzado'),
('Hogar', 'Artículos para el hogar y cocina'),
('Deportes', 'Equipamiento deportivo');

-- 4. Generar 500 PRODUCTOS
INSERT INTO PRODUCTOS (categoria_id, nombre, precio, descripcion, stock, disponible)
SELECT 
    FLOOR(1 + RAND() * 4) AS categoria_id,
    CONCAT('Producto_', n) AS nombre,
    ROUND(500 + (RAND() * 49500), 2) AS precio,
    CONCAT('Descripción detallada del producto número ', n) AS descripcion,
    FLOOR(10 + RAND() * 200) AS stock,
    IF(RAND() > 0.1, TRUE, FALSE) AS disponible
FROM (
	WITH RECURSIVE seq AS (
        SELECT 1 AS n
        UNION ALL
        SELECT n + 1 FROM seq WHERE n < 500
    )
    SELECT n FROM seq
) AS t;

-- 5. Generar 5.000 USUARIOS
INSERT INTO USUARIO (nombre, apellido, email, celular, contraseña, rol)
SELECT 
    CONCAT('Nombre_', n) AS nombre,
    CONCAT('Apellido_', n) AS apellido,
    CONCAT('usuario_', n, '@mail.com') AS email,
    CONCAT('11', LPAD(FLOOR(RAND() * 100000000), 8, '0')) AS celular,
    'e10adc3949ba59abbe56e057f20f883e' AS contraseña,
    CASE WHEN n MOD 20 = 0 THEN 'ADMIN' ELSE 'USUARIO' END AS rol
FROM (
    WITH RECURSIVE seq AS (
        SELECT 1 AS n
        UNION ALL
        SELECT n + 1 FROM seq WHERE n < 5000
    )
    SELECT n FROM seq
) AS t;

-- 6. Generar 15.000 PEDIDOS
INSERT INTO PEDIDO (usuario_id, fecha, estado, total, forma_de_pago)
SELECT 
    FLOOR(1 + RAND() * 5000) AS usuario_id,
    DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 365) DAY) AS fecha,
    CASE FLOOR(RAND() * 4) 
        WHEN 0 THEN 'PENDIENTE' 
        WHEN 1 THEN 'CONFIRMADO' 
        WHEN 2 THEN 'TERMINADO' 
        ELSE 'CANCELADO' 
    END AS estado,
    ROUND(1000 + (RAND() * 150000), 2) AS total,
    CASE FLOOR(RAND() * 3) 
        WHEN 0 THEN 'TARJETA' 
        WHEN 1 THEN 'EFECTIVO' 
        ELSE 'TRANSFERENCIA' 
    END AS forma_de_pago
FROM (
	WITH RECURSIVE seq AS (
        SELECT 1 AS n
        UNION ALL
        SELECT n + 1 FROM seq WHERE n < 15000
    )
    SELECT n FROM seq
) AS t;

-- 7. Generar 35.000 DETALLES DE PEDIDO
INSERT INTO DETALLE_PEDIDO (pedido_id, producto_id, cantidad, subtotal)
SELECT 
    FLOOR(1 + RAND() * 15000) AS pedido_id,
    FLOOR(1 + RAND() * 500) AS producto_id,
    FLOOR(1 + RAND() * 5) AS cantidad,
    ROUND(500 + (RAND() * 10000), 2) AS subtotal
FROM (
	WITH RECURSIVE seq AS (
        SELECT 1 AS n
        UNION ALL
        SELECT n + 1 FROM seq WHERE n < 35000
    )
    SELECT n FROM seq
) AS t;