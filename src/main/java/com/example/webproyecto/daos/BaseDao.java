package com.example.webproyecto.daos;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class BaseDao {
    protected Connection getConnection() throws SQLException {
        String url = "jdbc:mysql://localhost:3306/onu_mujeres";
        String user = "root";
        String password = "root";
        return DriverManager.getConnection(url, user, password);
    }
}