package com.example.webproyecto.daos.encuestador;
import com.example.webproyecto.beans.Formulario;
import java.util.List;
import java.util.ArrayList;
import java.sql.*;
import com.example.webproyecto.utils.Conexion;

public class FormularioDao {

    private final String url = "jdbc:mysql://localhost:3306/proyecto";
    private final String user = "root";
    private final String pass = "root";

    /**
     * Retorna el título de un formulario dado su ID.
     *
     * @param idFormulario ID del formulario
     * @return título del formulario si existe, cadena vacía si no
     */
    public String obtenerTituloFormularioPorId(int idFormulario) {
        String titulo = "";

        String sql = "SELECT idFormulario, titulo, activo FROM formulario";

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idFormulario);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {    
                    titulo = rs.getString("titulo");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return titulo;
    }

    public List<Formulario> obtenerFormularioPorId(int idFormulario) throws SQLException {
        List<Formulario> formularios = new ArrayList<>();
        String sql = "SELECT idFormulario, titulo, activo FROM formulario WHERE idFormulario = ?";
        try (Connection conn = Conexion.obtenerConexion();
            PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idFormulario);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Formulario f = new Formulario();
                    f.setIdFormulario(rs.getInt("idFormulario"));
                    f.setTitulo(rs.getString("titulo"));
                    f.setActivo(rs.getBoolean("activo"));
                    formularios.add(f);
                }
            }
        }
        return formularios;
    }
    public List<Formulario> obtenerTodosLosFormularios() throws SQLException {
    List<Formulario> formularios = new ArrayList<>();
    String sql = "SELECT idFormulario, titulo, activo FROM formulario";
    try (Connection conn = Conexion.obtenerConexion();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            Formulario f = new Formulario();
            f.setIdFormulario(rs.getInt("idFormulario"));
            f.setTitulo(rs.getString("titulo"));
            f.setActivo(rs.getBoolean("activo"));
            formularios.add(f);
        }
    }
    return formularios;
}

    public void actualizarFormulario(Formulario formulario) throws SQLException {
        String sql = "UPDATE formulario SET titulo = ?, activo = ? WHERE idFormulario = ?";
        try (Connection conn = Conexion.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, formulario.getTitulo());
            ps.setBoolean(2, formulario.isActivo());
            ps.setInt(3, formulario.getIdFormulario());
            ps.executeUpdate();
        }
    }

    public void eliminarFormulario(int idFormulario) throws SQLException {
        String sql = "DELETE FROM formulario WHERE idFormulario = ?";
        try (Connection conn = Conexion.obtenerConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idFormulario);
            ps.executeUpdate();
        }
    }
        public void insertarFormulario(Formulario formulario) throws SQLException {
        String sql = "INSERT INTO formulario (titulo, descripcion, fechaCreacion, idCoordinador, idCarpeta, activo) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = Conexion.obtenerConexion();
            PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, formulario.getTitulo());
            ps.setString(2, formulario.getDescripcion());
            ps.setDate(3, new java.sql.Date(formulario.getFechaCreacion().getTime()));
            ps.setInt(4, formulario.getIdCoordinador());
            ps.setInt(5, formulario.getIdCarpeta());
            ps.setBoolean(6, formulario.isActivo());
            ps.executeUpdate();
        }
    }
}

