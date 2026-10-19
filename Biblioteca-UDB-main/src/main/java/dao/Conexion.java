package dao;

import java.io.InputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class Conexion {
    public static Connection obtener() throws SQLException {
        Properties config = new Properties();
        try (InputStream archivo = Conexion.class.getResourceAsStream("/db.properties")) {
            if (archivo != null) config.load(archivo);
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (IOException | ClassNotFoundException e) {
            throw new SQLException("No se pudo cargar la configuración de MySQL.", e);
        }
        // Las variables de entorno permiten configurar Tomcat sin guardar contraseñas en Git.
        String url = valor("DB_URL", config.getProperty("db.url", "jdbc:mysql://localhost:3306/bibliotecaudb"));
        String usuario = valor("DB_USER", config.getProperty("db.user", "root"));
        String clave = valor("DB_PASSWORD", config.getProperty("db.password", ""));
        return DriverManager.getConnection(url, usuario, clave);
    }

    private static String valor(String nombre, String defecto) {
        String valor = System.getenv(nombre);
        return valor == null ? defecto : valor;
    }
}
