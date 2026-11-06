
-- ETAPA 4: SEGURIDAD E INTEGRIDAD


-- 1. CREACION DE USUARIO CON PRIVILEGIOS MINIMOS

-- Crear el usuario de la aplicacion
CREATE USER IF NOT EXISTS 'app_tfi_user'@'localhost' IDENTIFIED BY 'ClaveSegura2026$';

-- Darle solo los permisos necesarios para operar
GRANT SELECT, INSERT, UPDATE ON TFI.PEDIDO TO 'app_tfi_user'@'localhost';
GRANT SELECT, INSERT, UPDATE ON TFI.DETALLE_PEDIDO TO 'app_tfi_user'@'localhost';
GRANT SELECT ON TFI.PRODUCTOS TO 'app_tfi_user'@'localhost';
GRANT SELECT ON TFI.CATEGORIA TO 'app_tfi_user'@'localhost';
GRANT SELECT ON TFI.USUARIO TO 'app_tfi_user'@'localhost';

-- Actualizar los privilegios
FLUSH PRIVILEGES;

/*
Prueba de acceso restringido:
Si se conecta con el usuario 'app_tfi_user' y se intenta borrar una tabla:
-- DROP TABLE PRODUCTOS;
-- Error devuelto por MySQL: 
-- ERROR 1142 (42000): DROP command denied to user 'app_tfi_user'@'localhost' for table 'PRODUCTOS'
*/


-- 2. DISEÑO DE VISTAS PARA OCULTAR INFORMACION SENSIBLE Y SUS PRUEBAS

-- Vista 1: Muestra los usuarios sin exponer sus contraseñas
CREATE OR REPLACE VIEW vista_usuarios_segura AS
SELECT id_usuario, nombre, apellido, email, celular, rol
FROM USUARIO;

-- Prueba de la Vista 1: Verificar el acceso a la vista segura (no expone la contraseña)
SELECT * FROM vista_usuarios_segura;


-- Vista 2: Muestra el catalogo de productos disponibles al publico
CREATE OR REPLACE VIEW vista_catalogo_disponible AS
SELECT id_producto, categoria_id, nombre, precio, descripcion, stock, disponible
FROM PRODUCTOS
WHERE stock > 0;

-- Prueba de la Vista 2: Verificar la vista de catalogo activo (solo trae productos con stock disponible)
SELECT * FROM vista_catalogo_disponible;

-- 3. VALIDACIONES Y PRUEBAS DE INTEGRIDAD (MÍNIMO 2 ESCENARIOS)

-- Prueba de Integridad 1: Restricción CHECK (Precio fuera de rango / negativo)
-- INSERT INTO PRODUCTOS (nombre, precio, stock, categoria_id) VALUES ('Producto Invalido', -50.00, 10, 1);
/*
Error devuelto por MySQL:
ERROR 3819 (HY000): Check constraint 'productos_chk_1' is violated.
(El motor rechaza el ingreso porque el precio no puede ser menor a 0).
*/


-- Prueba de Integridad 2: Restricción UNIQUE / Clave Duplicada (Email duplicado en USUARIO)
-- INSERT INTO USUARIO (nombre, apellido, email, password, rol) VALUES ('Juan', 'Perez', 'correo_ya_existente@mail.com', '1234', 'Cliente');
/*
Error devuelto por MySQL:
ERROR 1062 (23000): Duplicate entry 'correo_ya_existente@mail.com' for key 'usuario.email'
(El motor impide duplicar un dato definido como UNIQUE).
*/



-- 4. CONSULTA SEGURA MEDIANTE PROCEDIMIENTO ALMACENADO Y PRUEBA ANTI-INYECCIÓN

DELIMITER //

CREATE PROCEDURE sp_buscar_productos_por_precio(IN p_precio_maximo DECIMAL(12,2))
BEGIN
    SELECT id_producto, nombre, precio, stock 
    FROM PRODUCTOS 
    WHERE precio <= p_precio_maximo;
END //

DELIMITER ;

-- Ejemplo de ejecución segura:
-- CALL sp_buscar_productos_por_precio(500.00);

/*
DOCUMENTACIÓN DE LA PRUEBA ANTI-INYECCIÓN:

1. El intento malicioso: 
   ¿Qué pasaría si un usuario intentara inyectar código malicioso a través del parámetro? 
   Por ejemplo, si se ejecutara intentando manipular el tipado (ej: CALL sp_buscar_productos_por_precio('500 OR 1=1; DROP TABLE PRODUCTOS;--')).
   Sin embargo, al estar el parámetro estrictamente tipado como DECIMAL(12,2), el motor de MySQL bloqueará 
   de entrada cualquier intento de pasar texto con comandos o cadenas inválidas, arrojando un error de conversión de tipo de dato:
   -- ERROR 1366 (HY000): Incorrect decimal value: '500 OR 1=1...' for column 'p_precio_maximo' at row 1

2. La breve explicación: 
   El procedimiento almacenado está protegido contra SQL Injection debido a dos factores clave:
   - Tipado estricto: El parámetro de entrada `IN` es de tipo `DECIMAL(12,2)`, por lo que el motor de base de datos fuerza a que 
     cualquier valor recibido sea numérico, rechazando texto o fragmentos de código SQL.
   - Parametrización: Al utilizar variables declaradas en lugar de concatenación dinámica de strings (como comandos PREPARE/EXECUTE con 
     cadenas de texto concatenadas), MySQL trata el valor recibido estrictamente como un **dato** y jamás como código ejecutable, 
     garantizando la integridad y seguridad de la base de datos.
*/
