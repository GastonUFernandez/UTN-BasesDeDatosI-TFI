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

-- 2. DISEÑO DE VISTAS PARA OCULTAR INFORMACION SENSIBLE

-- Vista 1: Muestra los usuarios sin exponer sus contraseñas
CREATE OR REPLACE VIEW vista_usuarios_segura AS
SELECT id_usuario, nombre, apellido, email, celular, rol
FROM USUARIO;

-- Vista 2: Muestra el catalogo de productos disponibles al publico
CREATE OR REPLACE VIEW vista_catalogo_disponible AS
SELECT id_producto, categoria_id, nombre, precio, descripcion, stock, disponible
FROM PRODUCTOS
WHERE stock > 0;

-- 3. CONSULTAS DE PRUEBA Y VALIDACION DE INTEGRIDAD

-- Prueba 1: Verificar el acceso a la vista segura de usuarios (no expone la contraseña)
SELECT * FROM vista_usuarios_segura;

-- Prueba 2: Verificar la vista de catalogo activo (solo trae productos con stock disponible)
SELECT * FROM vista_catalogo_disponible;

-- Prueba 3: Intento de violar una restriccion (ejemplo de integracion)
-- INSERT INTO PRODUCTOS (nombre, precio, stock, id_categoria) VALUES ('Producto Invalido', -50.00, 10, 1);
-- El motor de MySQL devolvera error por violacion de restriccion CHECK / datos invalidos.

-- implementa conexion con usuario seguro y PreparedStatement en Java

package tfi.seguridad;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ConexionSegura {

    // Utiliza el usuario con privilegios mínimos creado en la Etapa 4
    private static final String URL = "jdbc:mysql://localhost:3306/TFI?useSSL=false&serverTimezone=UTC";
    private static final String USER = "app_tfi_user";
    private static final String PASS = "ClaveSegura2026$";

    public static Connection conectar() {
        Connection conexion = null;
        try {
            conexion = DriverManager.getConnection(URL, USER, PASS);
            System.out.println("Conexión exitosa con permisos restringidos.");
        } catch (SQLException e) {
            System.err.println("Error de conexión: " + e.getMessage());
        }
        return conexion;
    }

    // Ejemplo de consulta segura usando PreparedStatement (integridad contra SQL Injection)
    public static void consultarCatalogoSeguro(int idCategoriaFiltro) {
        String sql = "SELECT * FROM vista_catalogo_disponible WHERE id_categoria = ?";
        
        try (Connection conn = conectar();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, idCategoriaFiltro);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                System.out.println("Producto: " + rs.getString("nombre") + 
                                   " - Precio: $" + rs.getDouble("precio"));
            }
        } catch (SQLException e) {
            System.err.println("Error al consultar la vista: " + e.getMessage());
        }
    }
}
