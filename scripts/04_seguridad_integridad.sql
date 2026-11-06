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

-- Otorgar permisos sobre las vistas creadas en la Etapa 4
GRANT SELECT ON TFI.vista_usuarios_segura TO 'app_tfi_user'@'localhost';
GRANT SELECT ON TFI.vista_catalogo_disponible TO 'app_tfi_user'@'localhost';

-- Actualizar los privilegios en el servidor
FLUSH PRIVILEGES;

package tfi.conexion; // Ajustá esto según el paquete que hayas creado

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ConexionSegura {

    // Configuración con el usuario de privilegios mínimos creado en la Etapa 4
    private static final String URL = "jdbc:mysql://localhost:3306/TFI?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String USER = "app_tfi_user";
    private static final String PASS = "ClaveSegura2026$";

    public static Connection conectar() {
        Connection conexion = null;
        try {
            conexion = DriverManager.getConnection(URL, USER, PASS);
            System.out.println("¡Conexión exitosa con permisos restringidos!");
        } catch (SQLException e) {
            System.err.println("Error de conexión: " + e.getMessage());
        }
        return conexion;
    }

    // Método que utiliza PreparedStatement para evitar Inyección SQL y consultar la vista segura
    public static void consultarCatalogoSeguro(int idCategoriaFiltro) {
        // Consulta usando la vista y la columna categoria_id que validamos en Workbench
        String sql = "SELECT * FROM vista_catalogo_disponible WHERE categoria_id = ?";
        
        try (Connection conn = conectar();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, idCategoriaFiltro);
            ResultSet rs = pstmt.executeQuery();
            
            System.out.println("--- Resultados del catálogo para la categoría " + idCategoriaFiltro + " ---");
            boolean hayResultados = false;
            while (rs.next()) {
                hayResultados = true;
                System.out.println("Producto: " + rs.getString("nombre") + 
                                   " | Precio: $" + rs.getDouble("precio") + 
                                   " | Stock: " + rs.getInt("stock"));
            }
            if (!hayResultados) {
                System.out.println("No hay productos con stock disponible para esta categoría.");
            }
        } catch (SQLException e) {
            System.err.println("Error al consultar la vista: " + e.getMessage());
        }
    }

    // Método main para probar la ejecución directamente desde NetBeans
    public static void main(String[] args) {
        System.out.println("Iniciando prueba de conexión segura en Java...\n");
        
        Connection c = conectar();
        
        if (c != null) {
            System.out.println("\n----------------------------------------");
            consultarCatalogoSeguro(1); // Prueba consultando la categoría 1
            System.out.println("----------------------------------------");
        }
    }
}
