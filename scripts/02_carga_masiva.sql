USE TFI;

-- #########################
-- 1. Carga de datos en Categoria
-- #########################

/*
Se usa el método de 'Tablas semillas' para combinar valores
*/

INSERT INTO CATEGORIA (nombre, descripcion) VALUES
  ( "Electronica", "Productos electrónicos"),
  ( "Hogar", "Productos del hogar"),
  ( "Ropa", ""),
  ( "Comestibles", "Productos comestibles"),
  ( "Bebidas", "Productos bebibles");

-- #########################
-- 2. Carga de datos en Usuarios
-- #########################

/*
Se usa el método de 'Tablas semillas' para combinar valores
*/

-- Crear tabla temporal

CREATE TEMPORARY TABLE temp_nombres (
  nombre VARCHAR(50)
);

INSERT INTO temp_nombres (nombre) VALUES
-- 100 nombres masculinos
('Juan'), ('Carlos'), ('Mateo'), ('Lucas'), ('Santiago'),
('Martín'), ('Nicolás'), ('Tomás'), ('Joaquín'), ('Agustín'),
('Facundo'), ('Franco'), ('Thiago'), ('Benjamín'), ('Lautaro'),
('Gabriel'), ('Daniel'), ('Alejandro'), ('Andrés'), ('Diego'),
('Pablo'), ('Marcos'), ('Federico'), ('Gonzalo'), ('Ignacio'),
('Emiliano'), ('Valentín'), ('Julián'), ('Bruno'), ('Damián'),
('Ezequiel'), ('Maximiliano'), ('Sebastián'), ('Leonardo'), ('Manuel'),
('Ricardo'), ('Roberto'), ('Fernando'), ('Eduardo'), ('Javier'),
('Adrián'), ('Ángel'), ('Esteban'), ('Hernán'), ('Ramiro'),
('Rodrigo'), ('Simón'), ('Pedro'), ('Francisco'), ('José'),
('Miguel'), ('Antonio'), ('David'), ('Samuel'), ('Iván'),
('Enzo'), ('Dylan'), ('Axel'), ('Bautista'), ('Ciro'),
('Máximo'), ('Jeremías'), ('Kevin'), ('Cristian'), ('Matías'),
('Leandro'), ('Guillermo'), ('Hugo'), ('Alberto'), ('Raúl'),
('Fabián'), ('Oscar'), ('Rubén'), ('Mario'), ('Sergio'),
('Rafael'), ('Alonso'), ('Álvaro'), ('Alex'), ('Eric'),
('Ian'), ('Gael'), ('Lorenzo'), ('Dante'), ('Salvador'),
('Patricio'), ('Lisandro'), ('Aarón'), ('Ismael'), ('Joel'),
('Elías'), ('Felipe'), ('Vicente'), ('Emmanuel'), ('Camilo'),
('Cristóbal'), ('Mauricio'), ('Rocco'), ('Ulises'), ('Tobías');

INSERT INTO temp_nombres (nombre) VALUES
-- 100 nombres femeninos
('María'), ('Ana'), ('Lucía'), ('Sofía'), ('Valentina'),
('Martina'), ('Camila'), ('Julieta'), ('Catalina'), ('Emma'),
('Isabella'), ('Victoria'), ('Mía'), ('Olivia'), ('Emilia'),
('Renata'), ('Josefina'), ('Agustina'), ('Florencia'), ('Carolina'),
('Daniela'), ('Gabriela'), ('Paula'), ('Laura'), ('Clara'),
('Julia'), ('Abril'), ('Alma'), ('Bianca'), ('Lola'),
('Zoe'), ('Aitana'), ('Antonella'), ('Delfina'), ('Pilar'),
('Malena'), ('Milagros'), ('Candela'), ('Rocío'), ('Micaela'),
('Juliana'), ('Carla'), ('Elena'), ('Alicia'), ('Valeria'),
('Natalia'), ('Andrea'), ('Victoria'), ('Luciana'), ('Mariana'),
('Romina'), ('Belén'), ('Celeste'), ('Brenda'), ('Noelia'),
('Vanesa'), ('Silvia'), ('Patricia'), ('Verónica'), ('Lorena'),
('Graciela'), ('Cecilia'), ('Mónica'), ('Claudia'), ('Marcela'),
('Alejandra'), ('Fernanda'), ('Mercedes'), ('Lourdes'), ('Rafaela'),
('Amparo'), ('Ariadna'), ('Ainhoa'), ('Alba'), ('Inés'),
('Ava'), ('Chloe'), ('Lara'), ('Nerea'), ('Irene'),
('Elisa'), ('Jimena'), ('Manuela'), ('Maite'), ('Ariadna'),
('Constanza'), ('Guadalupe'), ('Paz'), ('Sol'), ('Luz'),
('Violeta'), ('Amelia'), ('Antonina'), ('Bárbara'), ('Carmina'),
('Francesca'), ('Isabel'), ('Margarita'), ('Teresa'), ('Eva');

CREATE TEMPORARY TABLE temp_apellidos (
  apellido VARCHAR(50)
);

INSERT INTO temp_apellidos (apellido) VALUES
('González'), ('Rodríguez'), ('Gómez'), ('Fernández'), ('López'), ('Díaz'), ('Martínez'), ('Pérez'), ('Sánchez'),
('Romero'), ('Sosa'), ('Álvarez'), ('Torres'), ('Ruiz'), ('Ramírez'), ('Flores'), ('Acosta'), ('Benítez'), ('Medina'), ('Herrera'), ('Suárez'),
('Aguirre'), ('Gutiérrez'), ('Molina'), ('Silva'), ('Castro'), ('Rojas'), ('Ortiz'), ('Núñez'), ('Luna'), ('Juárez'), ('Cabrera'),
('Ríos'), ('Vega'), ('Méndez'), ('Pereyra'), ('Vargas'), ('Campos'), ('Cardozo'), ('Navarro'), ('Morales'), ('Ferreyra'), ('Correa'), ('Carrizo'),
('Peralta'), ('Miranda'), ('Figueroa'), ('Quiroga'), ('Ponce'), ('Maldonado'), ('Arias'), ('Cáceres'), ('Domínguez'), ('Vázquez'), ('Ojeda'), ('Escobar'),
('Barrios'), ('Córdoba'), ('Franco'), ('Mansilla'), ('Roldán'), ('Bustamante'), ('Ibarra'), ('Godoy'), ('Montenegro'), ('Alonso'), ('Bravo'), ('Delgado'),
('Carmona'), ('Serrano'), ('Cortés'), ('Reyes'), ('Márquez'), ('Vidal'), ('Santos'), ('Paz'), ('Leiva'), ('Bustos'), ('Aguilar'), ('Valdez'), ('Villalba'),
('Cejas'), ('Paredes'), ('Ocampo'), ('Toledo'), ('Andrada'), ('Escudero'), ('Coronel'), ('Ledesma'), ('Barreto'), ('Maidana'), ('Olivera'), ('Barrera'),
('Soria'), ('Montiel'), ('Ramos'), ('Castaño');


INSERT INTO USUARIO (id_usuario, nombre, apellido, email, contraseña, rol)
SELECT 
    ROW_NUMBER() OVER () AS id_usuario,
    n.nombre,
    a.apellido,
    CONCAT(LOWER(n.nombre), '.', LOWER(a.apellido), ROW_NUMBER() OVER(), '@mail.com') AS email,
    'password123' AS contraseña,
    'CLIENTE' AS rol
FROM temp_nombres n
CROSS JOIN temp_apellidos a;


-- #########################
-- 3. Carga de datos en PRODUCTOS
-- #########################

/*
Se usa el método de 'pseudoaleatoriedad'
*/

INSERT INTO PRODUCTOS (categoria_id, nombre, precio, descripcion, stock, disponible)
SELECT
    FLOOR(1 + (RAND() * 4)) AS categoria_id,
    CONCAT('Producto_', ROW_NUMBER() OVER ()) AS nombre,
    ROUND(10 + (RAND() * 990), 2) AS precio,
    'Descripción de prueba para el producto' AS descripcion,
    FLOOR(10 + (RAND() * 500)) AS stock,
    1 AS disponible
FROM temp_nombres;

-- Acá recién limpiamos las tablas temporales que se usaron arriba y abajo
DROP TABLE temp_nombres;
DROP TABLE temp_apellidos;


-- #########################
-- 4. Carga de datos en PEDIDO
-- #########################

/*
Se usa el método de 'Tablas calendario' para las fechas y 'Catálogos/maestras'
*/

INSERT INTO PEDIDO (usuario_id, fecha, estado, total, forma_de_pago)
SELECT
    id_usuario,
    DATE_ADD('2026-01-01', INTERVAL FLOOR(RAND() * 300) DAY) AS fecha,
    CASE 
        WHEN RAND() < 0.7 THEN 'COMPLETADO'
        WHEN RAND() < 0.9 THEN 'PENDIENTE'
        ELSE 'CANCELADO'
    END AS estado,
    ROUND(50 + (RAND() * 2000), 2) AS total,
    CASE 
        WHEN RAND() < 0.5 THEN 'TARJETA'
        ELSE 'TRANSFERENCIA'
    END AS forma_de_pago
FROM USUARIO;


-- #########################
-- 5. Carga de datos en DETALLE_PEDIDO
-- #########################

/*
Se usa el método de 'Expansiones iterativas'
*/

INSERT INTO DETALLE_PEDIDO (pedido_id, producto_id, cantidad, subtotal)
WITH RECURSIVE contador AS (
	-- Semilla
	SELECT 1 AS n
	UNION ALL
	-- Iteración: solo incrementa, sin RAND()
	SELECT n + 1 FROM contador WHERE n < 35000
),
datos AS (
	SELECT
		-- Pedido: ID aleatorio en [1, 15000]
        FLOOR(1 + (RAND() * 15000)) AS id_pedido,
        -- Producto: ID aleatorio en [1, 500]
		FLOOR(1 + (RAND() * 500)) AS id_producto,
        -- Cantidad: aleatoria en [1, 5], calculada UNA sola vez
        FLOOR(1 + (RAND() * 5)) AS cantidad
  FROM contador
)
SELECT
    d.id_pedido,
    d.id_producto,
    d.cantidad,
    pr.precio * d.cantidad AS subtotal
FROM datos d
JOIN PRODUCTOS pr ON pr.id_producto = d.id_producto;