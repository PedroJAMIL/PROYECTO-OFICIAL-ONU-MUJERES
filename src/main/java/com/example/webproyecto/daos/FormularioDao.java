package com.example.webproyecto.daos;

import com.example.webproyecto.beans.Formulario;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FormularioDao {

    private final String url = "jdbc:mysql://localhost:3306/proyecto";
    private final String user = "root";
    private final String pass = "root";

    public List<Formulario> obtenerTodosLosFormularios() {
        List<Formulario> lista = new ArrayList<>();

        String sql = "SELECT * FROM formulario";

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            Class.forName("com.mysql.cj.jdbc.Driver");

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Formulario formulario = new Formulario();
                formulario.setIdFormulario(rs.getInt("idFormulario"));
                formulario.setTitulo(rs.getString("titulo"));
                formulario.setDescripcion(rs.getString("descripcion"));
                formulario.setFechaCreacion(rs.getTimestamp("fechaCreacion"));
                formulario.setIdCoordinador(rs.getInt("idCoordinador"));
                formulario.setIdCarpeta(rs.getInt("idCarpeta"));
                // Si tienes un campo "activo" en la tabla, descomenta la siguiente línea:
                // formulario.setActivo(rs.getBoolean("activo"));

                lista.add(formulario);
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return lista;
    }
}