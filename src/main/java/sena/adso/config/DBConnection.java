package sena.adso.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author Carlos Parra
 */
public class DBConnection {
     private static final String URL = "jdbc:mysql://localhost:3306/panaderia";
     private static final String USER = "root";
    private static final String PASSWORD = "";
    
    // Variable de instancia única para la conexión (patrón Singleton)
    private static Connection connection;
    
    /**
     * Obtiene una conexión a la base de datos.
     * Si la conexión no existe o está cerrada, crea una nueva.
     * 
     * @return Connection - Objeto de conexión a la base de datos
     * @throws RuntimeException Si ocurre un error al conectar
     */
    public static Connection getConnection() {
        try {
            // Verifica si la conexión es nula o está cerrada para crear una nueva
            if (connection == null || connection.isClosed()) {
                // Carga el driver de MySQL
                Class.forName("com.mysql.cj.jdbc.Driver");
                // Establece la conexión con los parámetros configurados
                connection = DriverManager.getConnection(URL, USER, PASSWORD);
            }
            return connection;
        } catch (SQLException | ClassNotFoundException e) {
            // Captura y convierte las excepciones en RuntimeException con mensaje descriptivo
            throw new RuntimeException("Error al conectar con la base de datos", e);
        }
    }
    
    /**
     * Cierra la conexión a la base de datos si está abierta.
     * 
     * @throws RuntimeException Si ocurre un error al cerrar la conexión
     */
    public static void closeConnection() {
        try {
            // Verifica que la conexión exista y no esté cerrada antes de intentar cerrarla
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al cerrar la conexión", e);
        }
    }
}
