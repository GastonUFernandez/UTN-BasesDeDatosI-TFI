USE TFI;

-- #########################
-- 1. Carga de datos en Categoria
-- #########################

/*
Se usa el método de 'Tablas semillas' para combinar valores
*/

INSERT INTO Categoria (nombre, descripcion) VALUES
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

DROP TABLE temp_nombres;
DROP TABLE temp_apellidos;

-- #########################
-- 3. Carga de datos en Productos
-- #########################

/*
Se usa el método de 'pseudoaleatoriedad'
*/

-- #########################
-- 4. Carga de datos en Pedidos
-- #########################

/*
Se usa el método de 'Tablas calendario' para las fechas y 'Catálogos/maestras'
*/

-- #########################
-- 5. Carga de datos en Detalle_Pedidos
-- #########################

/*
Se usa el método de 'Expansiones iterativas'
*/
