package com.example.webproyecto.daos;
import com.example.webproyecto.utils.Conexion;
import com.example.webproyecto.dtos.CoordinadorDTO;
import com.example.webproyecto.beans.Credencial;
import com.example.webproyecto.beans.ArchivoCargado;
import com.example.webproyecto.beans.Usuario;
import java.util.ArrayList;
import java.util.List;

import java.io.InputStream;
import java.sql.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import java.sql.PreparedStatement;
import java.sql.ResultSet;


public class UsuarioDao {

    private final String url = "jdbc:mysql://localhost:3306/proyecto";
    private final String user = "root";
    private final String pass = "root";

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, user, pass);
    }
    /**
     * Guarda un nuevo registro de archivo cargado en la base de datos.
     * Importante: Este método asume que la 'foto' en el bean Usuario es un String (ruta/URL).
     * Si 'foto' es un BLOB (InputStream), el manejo en actualizarPerfilCoordinador deberá ser ajustado.
     *
     * @param archivoCargado El objeto ArchivoCargado a guardar.
     * @return true si la operación fue exitosa, false en caso contrario.
     */
    public boolean guardarArchivoCargado(com.example.webproyecto.beans.ArchivoCargado archivoCargado) {
        // Asegúrate de que tienes 'private final String url = "jdbc:mysql://localhost:3306/proyecto";'
        // 'private final String user = "root";' y 'private final String pass = "root";'
        // definidos en tu clase UsuarioDao para que 'getConnection()' funcione.

        String sql = "INSERT INTO archivocargado (" +
                "nombreArchivoOriginal, rutaGuardado, fechaCarga, idUsuarioQueCargo, " +
                "estadoProcesamiento, mensajeProcesamiento, idFormularioAsociado) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); // Usando el getConnection() que ya tienes en UsuarioDao
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, archivoCargado.getNombreArchivoOriginal());
            stmt.setString(2, archivoCargado.getRutaGuardado());
            // Para LocalDateTime a Timestamp (necesitarás importar java.sql.Timestamp)
            stmt.setTimestamp(3, Timestamp.valueOf(archivoCargado.getFechaCarga()));
            stmt.setInt(4, archivoCargado.getIdUsuarioQueCargo());
            stmt.setString(5, archivoCargado.getEstadoProcesamiento());
            stmt.setString(6, archivoCargado.getMensajeProcesamiento());

            // Manejar idFormularioAsociado que puede ser nulo
            if (archivoCargado.getIdFormularioAsociado() != null) {
                stmt.setInt(7, archivoCargado.getIdFormularioAsociado());
            } else {
                stmt.setNull(7, Types.INTEGER); // Necesitarás importar java.sql.Types
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
     * Podría ser útil para el historial de un coordinador específico.
     *
     * @param idUsuario Si es mayor que 0, filtra por este ID de usuario. Si es 0, trae todos los archivos.
     * @return Una lista de objetos ArchivoCargado.
     */
    public List<com.example.webproyecto.beans.ArchivoCargado> obtenerArchivosCargados(int idUsuario) {
        List<com.example.webproyecto.beans.ArchivoCargado> listaArchivos = new ArrayList<>();
        String sql = "SELECT ac.*, u.nombre AS nombreUsuario, u.apellidopaterno AS apellidoPaternoUsuario " +
                "FROM archivocargado ac " +
                "JOIN usuario u ON ac.idUsuarioQueCargo = u.idUsuario ";

        if (idUsuario > 0) {
            sql += "WHERE ac.idUsuarioQueCargo = ? ";
        }
        sql += "ORDER BY ac.fechaCarga DESC"; // Ordenar por fecha de carga, los más recientes primero

        try (Connection conn = getConnection(); // Usando el getConnection() que ya tienes en UsuarioDao
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (idUsuario > 0) {
                stmt.setInt(1, idUsuario);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    com.example.webproyecto.beans.ArchivoCargado archivo = new com.example.webproyecto.beans.ArchivoCargado();
                    archivo.setIdArchivoCargado(rs.getInt("idArchivoCargado"));
                    archivo.setNombreArchivoOriginal(rs.getString("nombreArchivoOriginal"));
                    archivo.setRutaGuardado(rs.getString("rutaGuardado"));
                    // Para Timestamp a LocalDateTime (necesitarás importar java.time.LocalDateTime)
                    Timestamp timestamp = rs.getTimestamp("fechaCarga");
                    if (timestamp != null) {
                        archivo.setFechaCarga(timestamp.toLocalDateTime());
                    }
                    archivo.setIdUsuarioQueCargo(rs.getInt("idUsuarioQueCargo"));
                    archivo.setEstadoProcesamiento(rs.getString("estadoProcesamiento"));
                    archivo.setMensajeProcesamiento(rs.getString("mensajeProcesamiento"));

                    // Verificar si idFormularioAsociado es NULL en la BD
                    int idFormulario = rs.getInt("idFormularioAsociado");
                    if (rs.wasNull()) {
                        archivo.setIdFormularioAsociado(null);
                    } else {
                        archivo.setIdFormularioAsociado(idFormulario);
                    }

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
     * Obtiene una lista de todos los archivos cargados.
     *
     * @return Una lista de objetos ArchivoCargado.
     */
    public List<com.example.webproyecto.beans.ArchivoCargado> obtenerTodosLosArchivosCargados() {
        return obtenerArchivosCargados(0); // Llama al método anterior con 0 para no filtrar por usuario
    }
    public Usuario obtenerUsuarioPorId(int idUsuario) {
        String sql = "SELECT * FROM usuario WHERE idUsuario = ?";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idUsuario);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setIdUsuario(rs.getInt("idUsuario"));
                usuario.setNombre(rs.getString("nombre"));
                usuario.setApellidopaterno(rs.getString("apellidopaterno"));
                usuario.setApellidomaterno(rs.getString("apellidomaterno"));
                usuario.setDni(rs.getString("dni"));
                usuario.setDireccion(rs.getString("direccion"));
                usuario.setIdDistrito(rs.getInt("idDistrito"));
                usuario.setIdRol(rs.getInt("idrol"));
                usuario.setIdEstado(rs.getInt("idEstado"));
                // Remove nombrefoto logic
                java.sql.Blob fotoBlob = rs.getBlob("foto");
                if (fotoBlob != null && fotoBlob.length() > 0) {
                    byte[] fotoBytes = fotoBlob.getBytes(1, (int) fotoBlob.length());
                    String fotoBase64 = java.util.Base64.getEncoder().encodeToString(fotoBytes);
                    usuario.setFoto(fotoBase64);
                } else {
                    usuario.setFoto(null);
                }
                return usuario;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    public List<CoordinadorDTO> listarEncuestadoresConCorreo() {
        List<CoordinadorDTO> lista = new ArrayList<>();
        String sql = "SELECT u.*, c.correo FROM usuario u LEFT JOIN credencial c ON u.idUsuario = c.idUsuario WHERE u.idRol = 3 ORDER BY u.idUsuario DESC";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Usuario u = new Usuario();
                u.setIdUsuario(rs.getInt("idUsuario"));
                u.setNombre(rs.getString("nombre"));
                u.setApellidopaterno(rs.getString("apellidopaterno"));
                u.setApellidomaterno(rs.getString("apellidomaterno"));
                u.setDni(rs.getString("dni"));
                u.setDireccion(rs.getString("direccion"));
                u.setIdDistrito(rs.getInt("idDistrito"));
                u.setIdRol(rs.getInt("idRol"));
                u.setIdEstado(rs.getInt("idEstado"));
                u.setFoto(rs.getString("foto"));

                Credencial c = new Credencial();
                c.setCorreo(rs.getString("correo"));

                lista.add(new CoordinadorDTO(u, c));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
    public boolean actualizarPerfilCompleto(Usuario usuario) {
        // Construcción dinámica de la consulta SQL
        StringBuilder sql = new StringBuilder("UPDATE usuario SET direccion = ?, idDistrito = ?");
        ArrayList<Object> params = new ArrayList<>();

        params.add(usuario.getDireccion());
        params.add(usuario.getIdDistrito());

        // Agregar foto solo si viene en el objeto
        if (usuario.getFoto() != null && !usuario.getFoto().isEmpty()) {
            sql.append(", foto = ?");
            params.add(usuario.getFoto());
        }

        sql.append(" WHERE idUsuario = ?");
        params.add(usuario.getIdUsuario());

        System.out.println("SQL a ejecutar: " + sql.toString());
        System.out.println("Parámetros: " + params);

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            // Establecer parámetros dinámicamente
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    stmt.setString(i + 1, (String) param);
                } else if (param instanceof Integer) {
                    stmt.setInt(i + 1, (Integer) param);
                }
            }

            int filasAfectadas = stmt.executeUpdate();
            System.out.println("Filas afectadas: " + filasAfectadas);

            if (filasAfectadas == 0) {
                System.err.println("ADVERTENCIA: Ninguna fila actualizada. Verifica que el usuario con ID " +
                        usuario.getIdUsuario() + " existe");
            }

            return filasAfectadas > 0;

        } catch (SQLException e) {
            System.err.println("Error SQL al actualizar perfil:");
            System.err.println("- Código de error: " + e.getErrorCode());
            System.err.println("- Estado SQL: " + e.getSQLState());
            System.err.println("- Mensaje: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /*public boolean actualizarFotoPerfil(int idUsuario, InputStream fotoStream) {
        String sql = "UPDATE usuario SET foto = ? WHERE idUsuario = ?";

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            // Si fotoStream es null, establecerá NULL en la base de datos
            if (fotoStream != null) {
                stmt.setBlob(1, fotoStream);
            } else {
                stmt.setNull(1, Types.BLOB);
            }
            stmt.setInt(2, idUsuario);

            int filasAfectadas = stmt.executeUpdate();
            return filasAfectadas > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }*/
    public boolean cambiarEstadoUsuario(int idUsuario, int nuevoEstado) {
        String sql = "UPDATE usuario SET idEstado = ? WHERE idUsuario = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, nuevoEstado);
            ps.setInt(2, idUsuario);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean actualizarDireccionYDistrito(int idUsuario, String direccion, int idDistrito) {
        String sql = "UPDATE usuario SET direccion = ?, idDistrito = ? WHERE idUsuario = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, direccion);
            stmt.setInt(2, idDistrito);
            stmt.setInt(3, idUsuario);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al actualizar dirección y distrito:");
            e.printStackTrace();
            return false;
        }
    }

    // Métodos adicionales para UsuarioDao.java

    // Métodos adicionales para UsuarioDao
    public boolean insertarUsuario(Usuario usuario) {
        String sql = "INSERT INTO usuario (nombre, apellidopaterno, apellidomaterno, dni, direccion, "
                + "idDistrito, idRol, idEstado) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, usuario.getNombre());
            stmt.setString(2, usuario.getApellidopaterno());
            stmt.setString(3, usuario.getApellidomaterno());
            stmt.setString(4, usuario.getDni());
            stmt.setString(5, usuario.getDireccion());
            stmt.setInt(6, usuario.getIdDistrito());
            stmt.setInt(7, usuario.getIdRol());
            stmt.setInt(8, usuario.getIdEstado());

            int filasAfectadas = stmt.executeUpdate();

            if (filasAfectadas > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        usuario.setIdUsuario(generatedKeys.getInt(1));
                        return true;
                    }
                }
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    public boolean existeDni(String dni) {
        String sql = "SELECT 1 FROM usuario WHERE dni = ?";

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, dni);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Usuario obtenerUsuarioPorDni(String dni) {
        Usuario usuario = null;
        String sql = "SELECT * FROM usuario WHERE dni = ?";

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, dni);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                usuario = new Usuario();
                usuario.setIdUsuario(rs.getInt("idUsuario"));
                usuario.setNombre(rs.getString("nombre"));
                usuario.setApellidopaterno(rs.getString("apellidopaterno"));
                usuario.setApellidomaterno(rs.getString("apellidomaterno"));
                usuario.setDni(rs.getString("dni"));
                usuario.setDireccion(rs.getString("direccion"));
                usuario.setIdDistrito(rs.getInt("idDistrito"));
                usuario.setIdRol(rs.getInt("idRol"));
                usuario.setIdEstado(rs.getInt("idEstado"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return usuario;
    }

    public boolean actualizarPerfilConFoto(int idUsuario, String direccion, int idDistrito, InputStream fotoStream) {
        String sql;
        if (fotoStream != null) {
            sql = "UPDATE usuario SET direccion = ?, idDistrito = ?, foto = ? WHERE idUsuario = ?";
        } else {
            sql = "UPDATE usuario SET direccion = ?, idDistrito = ? WHERE idUsuario = ?";
        }
        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, direccion);
            stmt.setInt(2, idDistrito);
            if (fotoStream != null) {
                stmt.setBlob(3, fotoStream);
                stmt.setInt(4, idUsuario);
            } else {
                stmt.setInt(3, idUsuario);
            }
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
//    public void actualizarEstadoUsuario(int idUsuario, int nuevoEstado) {
//        String sql = "UPDATE usuario SET idestado = ? WHERE idusuario = ?";
//        try (Connection conn = Conexion.obtenerConexion(); PreparedStatement stmt = conn.prepareStatement(sql)) {
//            stmt.setInt(1, nuevoEstado);
//            stmt.setInt(2, idUsuario);
//            stmt.executeUpdate();
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//    }

    public List<CoordinadorDTO> listarCoordinadoresConCorreo() {
        List<CoordinadorDTO> lista = new ArrayList<>();
        String sql = "SELECT u.*, c.correo FROM usuario u LEFT JOIN credencial c ON u.idUsuario = c.idUsuario WHERE u.idRol = 2 ORDER BY u.idUsuario DESC";
        try (Connection conn = DriverManager.getConnection(url, user, pass);
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Usuario u = new Usuario();
                u.setIdUsuario(rs.getInt("idUsuario"));
                u.setNombre(rs.getString("nombre"));
                u.setApellidopaterno(rs.getString("apellidopaterno"));
                u.setApellidomaterno(rs.getString("apellidomaterno"));
                u.setDni(rs.getString("dni"));
                u.setDireccion(rs.getString("direccion"));
                u.setIdDistrito(rs.getInt("idDistrito"));
                u.setIdRol(rs.getInt("idRol"));
                u.setIdEstado(rs.getInt("idEstado"));
                u.setFoto(rs.getString("foto"));

                Credencial c = new Credencial();
                c.setCorreo(rs.getString("correo"));

                lista.add(new CoordinadorDTO(u, c));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
    
    public boolean actualizarPorPartes(int idUsuario, String direccion, Integer idDistrito, InputStream fotoStream) {
        StringBuilder sql = new StringBuilder("UPDATE usuario SET ");
        List<Object> params = new ArrayList<>();
        boolean needsComma = false;

        if (direccion != null) {
            sql.append("direccion = ?");
            params.add(direccion);
            needsComma = true;
        }
        if (idDistrito != null) {
            if (needsComma) sql.append(", ");
            sql.append("idDistrito = ?");
            params.add(idDistrito);
            needsComma = true;
        }
        if (fotoStream != null) {
            if (needsComma) sql.append(", ");
            sql.append("foto = ?");
            params.add(fotoStream);
        }
        sql.append(" WHERE idUsuario = ?");
        params.add(idUsuario);

        // Si no hay campos para actualizar, no hacer nada
        if (params.size() <= 1) return false;

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    stmt.setString(idx++, (String) param);
                } else if (param instanceof Integer) {
                    stmt.setInt(idx++, (Integer) param);
                } else if (param instanceof InputStream) {
                    stmt.setBlob(idx++, (InputStream) param);
                }
            }
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

}