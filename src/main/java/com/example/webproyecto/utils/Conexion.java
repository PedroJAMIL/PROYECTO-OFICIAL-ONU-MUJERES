
// Ruta: com/example/webproyecto/utils/Conexion.java
package com.example.webproyecto.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {
    private static final String URL = "jdbc:mysql://localhost:3306/proyecto";
    private static final String USER = "root";
    private static final String PASSWORD = "root";

    public static Connection obtenerConexion() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}