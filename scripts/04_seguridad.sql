USE TFI;

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
DROP TABLE PRODUCTOS;
La base de datos bloquea la accion porque no tiene permisos administrativos.
*/


-- 2. DISEÑO DE VISTAS PARA OCULTAR INFORMACION SENSIBLE

-- Vista 1: Muestra los usuarios sin exponer sus contraseñas
CREATE OR REPLACE VIEW vista_usuarios_segura AS
SELECT id_usuario, nombre, apellido, email, celular, rol
FROM USUARIO;

-- Vista 2: Muestra el catalogo de productos disponibles al publico
CREATE OR REPLACE VIEW vista_catalogo_disponible AS
SELECT p.id_producto, p.nombre AS producto, c.nombre AS categoria, p.precio, p.stock
FROM PRODUCTOS p
JOIN CATEGORIA c ON p.categoria_id = c.id_categoria
WHERE p.disponible = 1 AND p.stock > 0;


-- 3. PRUEBAS DE INTEGRIDAD

/*
Prueba A: Violacion de regla CHECK (Precio negativo)
Intentar insertar un producto con precio menor o igual a cero dara error:
INSERT INTO PRODUCTOS (categoria_id, nombre, precio, descripcion, stock, disponible)
VALUES (1, 'Producto Fallido', -50.00, 'Prueba', 10, 1);
*/

/*
Prueba B: Violacion de clave foranea (FOREIGN KEY)
Intentar registrar un pedido con un usuario que no existe dara error:
INSERT INTO PEDIDO (usuario_id, fecha, estado, total, forma_de_pago)
VALUES (99999, '2026-11-06 10:00:00', 'PENDIENTE', 1500.00, 'TARJETA');
*/


-- 4. DOCUMENTACION DE CONSULTA SEGURA (JAVA / PREPAREDSTATEMENT)

/*
Ejemplo de codigo Java seguro:
-------------------------------------------------------------------------
public USUARIO buscarUsuarioPorEmail(Connection conexion, String emailInput) {
    String sql = "SELECT id_usuario, nombre, apellido, email, rol FROM USUARIO WHERE email = ?";
    USUARIO usuario = null;

    try (PreparedStatement pstmt = conexion.prepareStatement(sql)) {
        // Se usa PreparedStatement para evitar inyeccion SQL
        pstmt.setString(1, emailInput);
        
        try (ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                usuario = new USUARIO();
                usuario.setIdUsuario(rs.getInt("id_usuario"));
                usuario.setNombre(rs.getString("nombre"));
                usuario.setEmail(rs.getString("email"));
            }
        }
    } catch (SQLException e) {
        System.err.println("Error: " + e.getMessage());
    }
    return usuario;
}
-------------------------------------------------------------------------

Explicacion de la prueba anti-inyeccion:
- Si se ingresa un texto malicioso como: ' OR '1'='1
- Sin proteccion, modificaria la consulta y traeria todos los datos.
- Con PreparedStatement, la base de datos busca ese texto de forma literal, 
  no encuentra coincidencia y no se produce ninguna vulnerabilidad.
*/
