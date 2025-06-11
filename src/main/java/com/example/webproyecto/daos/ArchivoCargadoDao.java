package com.example.webproyecto.daos;

import com.example.webproyecto.beans.ArchivoCargado; // Importa tu bean ArchivoCargado
// No importamos Usuario aquí, ya que el DAO es solo para ArchivoCargado
// No importamos com.example.webproyecto.utils.Conexion; si no la vamos a usar aquí

import java.sql.Connection;
import java.sql.DriverManager; // Necesario para la conexión directa
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp; // Para manejar LocalDateTime con la base de datos
import java.sql.Types;     // Para manejar valores NULL
import java.time.LocalDateTime; // Para el tipo de fecha en ArchivoCargado
import java.util.ArrayList;
import java.util.List;

public class ArchivoCargadoDao {

    // --- Configuración de la conexión a la base de datos (copiada de tu UsuarioDao) ---
    private final String url = "jdbc:mysql://localhost:3306/proyecto";
    private final String user = "root";
    private final String pass = "root";

    // --- Método para obtener la conexión a la base de datos ---
    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, user, pass);
    }

    /**
     * Guarda un nuevo registro de archivo cargado en la base de datos.
     *
     * @param archivoCargado El objeto ArchivoCargado a guardar.
     * @return true si la operación fue exitosa, false en caso contrario.
     */
    public boolean guardarArchivoCargado(ArchivoCargado archivoCargado) {
        String sql = "INSERT INTO archivocargado (" +
                "nombreArchivoOriginal, rutaGuardado, fechaCarga, idUsuarioQueCargo, " +
                "estadoProcesamiento, mensajeProcesamiento, idFormularioAsociado) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); // Usa el getConnection() de este DAO
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, archivoCargado.getNombreArchivoOriginal());
            stmt.setString(2, archivoCargado.getRutaGuardado());
            stmt.setTimestamp(3, Timestamp.valueOf(archivoCargado.getFechaCarga()));
            stmt.setInt(4, archivoCargado.getIdUsuarioQueCargo());
            stmt.setString(5, archivoCargado.getEstadoProcesamiento());
            stmt.setString(6, archivoCargado.getMensajeProcesamiento());

            // Manejar idFormularioAsociado que puede ser nulo
            if (archivoCargado.getIdFormularioAsociado() != null) {
                stmt.setInt(7, archivoCargado.getIdFormularioAsociado());
            } else {
                stmt.setNull(7, Types.INTEGER);
            }

            int rowsAffected = stmt.executeUpdate();

            // Si se insertó correctamente, obtener el ID generado (si lo necesitas en el bean)
            if (rowsAffected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        archivoCargado.setIdArchivoCargado(rs.getInt(1));
                    }
                }
                return true;
            }

        } catch (SQLException e) {
            System.err.println("Error al guardar el archivo cargado: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Obtiene una lista de archivos cargados, opcionalmente filtrados por usuario.
     * Incluye información básica del usuario que cargó el archivo (nombre y apellido).
     *
     * @param idUsuario Si es mayor que 0, filtra por este ID de usuario. Si es 0, trae todos los archivos.
     * @return Una lista de objetos ArchivoCargado.
     */
    public List<ArchivoCargado> obtenerArchivosCargados(int idUsuario) {
        List<ArchivoCargado> listaArchivos = new ArrayList<>();
        // Incluimos un JOIN con 'usuario' para poder obtener el nombre del usuario si se necesita
        // aunque el bean ArchivoCargado no tiene directamente campos para el nombre del usuario,
        // esto es útil si en el futuro decides mostrarlo en el JSP o en un DTO.
        String sql = "SELECT ac.*, u.nombre AS nombreUsuario, u.apellidopaterno AS apellidoPaternoUsuario " +
                "FROM archivocargado ac " +
                "JOIN usuario u ON ac.idUsuarioQueCargo = u.idUsuario ";

        if (idUsuario > 0) {
            sql += "WHERE ac.idUsuarioQueCargo = ? ";
        }
        sql += "ORDER BY ac.fechaCarga DESC"; // Ordenar por fecha de carga, los más recientes primero

        try (Connection conn = getConnection(); // Usa el getConnection() de este DAO
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (idUsuario > 0) {
                stmt.setInt(1, idUsuario);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ArchivoCargado archivo = new ArchivoCargado();
                    archivo.setIdArchivoCargado(rs.getInt("idArchivoCargado"));
                    archivo.setNombreArchivoOriginal(rs.getString("nombreArchivoOriginal"));
                    archivo.setRutaGuardado(rs.getString("rutaGuardado"));

                    Timestamp timestamp = rs.getTimestamp("fechaCarga");
                    if (timestamp != null) {
                        archivo.setFechaCarga(timestamp.toLocalDateTime());
                    }
                    archivo.setIdUsuarioQueCargo(rs.getInt("idUsuarioQueCargo"));
                    archivo.setEstadoProcesamiento(rs.getString("estadoProcesamiento"));
                    archivo.setMensajeProcesamiento(rs.getString("mensajeProcesamiento"));

                    // Manejo del campo idFormularioAsociado que puede ser NULL
                    int idFormulario = rs.getInt("idFormularioAsociado");
                    if (rs.wasNull()) { // Verifica si el valor leído de la BD fue NULL
                        archivo.setIdFormularioAsociado(null);
                    } else {
                        archivo.setIdFormularioAsociado(idFormulario);
                    }

                    // Si quisieras el nombre del usuario en el objeto ArchivoCargado, necesitarías
                    // modificar el bean ArchivoCargado para incluir esos campos, o crear un DTO.
                    // Por ahora, solo los seleccionamos en la consulta.
                    // String nombreUsuario = rs.getString("nombreUsuario");
                    // String apellidoPaternoUsuario = rs.getString("apellidoPaternoUsuario");

                    listaArchivos.add(archivo);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al obtener la lista de archivos cargados: " + e.getMessage());
            e.printStackTrace();
        }
        return listaArchivos;
    }

    /**
     * Obtiene una lista de todos los archivos cargados (sin filtrar por usuario).
     *
     * @return Una lista de objetos ArchivoCargado.
     */
    public List<ArchivoCargado> obtenerTodosLosArchivosCargados() {
        return obtenerArchivosCargados(0); // Llama al método anterior con 0 para no filtrar por usuario
    }

    // Puedes añadir más métodos según sea necesario (ej: actualizar estado de procesamiento, eliminar, etc.)
}