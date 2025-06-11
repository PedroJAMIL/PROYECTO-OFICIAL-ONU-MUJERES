package com.example.webproyecto.daos;

import com.example.webproyecto.utils.Conexion;
import com.example.webproyecto.dtos.CoordinadorDTO;
import com.example.webproyecto.beans.Credencial;
import com.example.webproyecto.beans.ArchivoCargado;
import com.example.webproyecto.beans.Usuario;

import java.util.ArrayList;
import java.util.List;
import java.util.Base64;

import java.io.InputStream;
import java.sql.*; // Importa java.sql.* para PreparedStatement, ResultSet, SQLException, Types
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

// No es necesario importar estos explícitamente si ya tienes java.sql.*
// import java.sql.PreparedStatement;
// import java.sql.ResultSet;

public class UsuarioDao {

    private final String url = "jdbc:mysql://localhost:3306/proyecto";
    private final String user = "root";
    private final String pass = "root";

    private Connection getConnection() throws SQLException {
        // Podrías considerar usar tu clase Conexion.obtenerConexion() aquí
        // return Conexion.obtenerConexion();
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
        String sql = "INSERT INTO archivocargado (" +
                "nombreArchivoOriginal, rutaGuardado, fechaCarga, idUsuarioQueCargo, " +
                "estadoProcesamiento, mensajeProcesamiento, idFormularioAsociado) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, archivoCargado.getNombreArchivoOriginal());
            stmt.setString(2, archivoCargado.getRutaGuardado());
            stmt.setTimestamp(3, Timestamp.valueOf(archivoCargado.getFechaCarga()));
            stmt.setInt(4, archivoCargado.getIdUsuarioQueCargo());
            stmt.setString(5, archivoCargado.getEstadoProcesamiento());
            stmt.setString(6, archivoCargado.getMensajeProcesamiento());

            if (archivoCargado.getIdFormularioAsociado() != null) {
                stmt.setInt(7, archivoCargado.getIdFormularioAsociado());
            } else {
                stmt.setNull(7, Types.INTEGER);
            }

            int rowsAffected = stmt.executeUpdate();

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
        sql += "ORDER BY ac.fechaCarga DESC";

        try (Connection conn = getConnection();
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
                    Timestamp timestamp = rs.getTimestamp("fechaCarga");
                    if (timestamp != null) {
                        archivo.setFechaCarga(timestamp.toLocalDateTime());
                    }
                    archivo.setIdUsuarioQueCargo(rs.getInt("idUsuarioQueCargo"));
                    archivo.setEstadoProcesamiento(rs.getString("estadoProcesamiento"));
                    archivo.setMensajeProcesamiento(rs.getString("mensajeProcesamiento"));

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
        return obtenerArchivosCargados(0);
    }

    public Usuario obtenerUsuarioPorId(int idUsuario) {
        String sql = "SELECT * FROM usuario WHERE idUsuario = ?";
        Usuario usuario = null; // Inicializar a null

        try (Connection conn = getConnection(); // Usar el método getConnection
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idUsuario);
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
                // Leer el nuevo atributo idDistritoTrabajo
                usuario.setIdDistritoTrabajo((Integer) rs.getObject("idDistritoTrabajo"));
                usuario.setIdRol(rs.getInt("idrol"));
                usuario.setIdEstado(rs.getInt("idEstado"));

                java.sql.Blob fotoBlob = rs.getBlob("foto");
                if (fotoBlob != null && fotoBlob.length() > 0) {
                    byte[] fotoBytes = fotoBlob.getBytes(1, (int) fotoBlob.length());
                    String fotoBase64 = java.util.Base64.getEncoder().encodeToString(fotoBytes);
                    usuario.setFoto(fotoBase64);
                } else {
                    usuario.setFoto(null);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return usuario;
    }
    public List<CoordinadorDTO> listarEncuestadoresPorZonaCoordinador(int idUsuarioCoordinador) {
        List<CoordinadorDTO> lista = new ArrayList<>();

        String sql = """
        SELECT u_enc.*, c.correo
        FROM usuario AS u_coord
        JOIN distrito AS d_coord ON u_coord.idDistritoTrabajo = d_coord.iddistrito
        JOIN distrito AS d_enc ON d_enc.idzona = d_coord.idzona
        JOIN usuario AS u_enc ON u_enc.idDistritoTrabajo = d_enc.iddistrito
        LEFT JOIN credencial c ON u_enc.idUsuario = c.idUsuario
        WHERE u_coord.idUsuario = ?
          AND u_coord.idrol = 2
          AND u_enc.idrol = 3
    """;

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idUsuarioCoordinador);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Usuario u = new Usuario();
                u.setIdUsuario(rs.getInt("idUsuario"));
                u.setNombre(rs.getString("nombre"));
                u.setApellidopaterno(rs.getString("apellidopaterno"));
                u.setApellidomaterno(rs.getString("apellidomaterno"));
                u.setDni(rs.getString("dni"));
                u.setDireccion(rs.getString("direccion"));
                u.setIdDistrito(rs.getInt("idDistrito"));
                u.setIdDistritoTrabajo((Integer) rs.getObject("idDistritoTrabajo"));
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

    public List<CoordinadorDTO> listarEncuestadoresConCorreo() {
        List<CoordinadorDTO> lista = new ArrayList<>();
        String sql = "SELECT u.*, c.correo FROM usuario u LEFT JOIN credencial c ON u.idUsuario = c.idUsuario WHERE u.idRol = 3 ORDER BY u.idUsuario DESC";
        try (Connection conn = getConnection();
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
                u.setIdDistritoTrabajo((Integer) rs.getObject("idDistritoTrabajo")); // Asegúrate de leerlo aquí también si lo necesitas
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
        StringBuilder sql = new StringBuilder("UPDATE usuario SET direccion = ?, idDistrito = ?, idDistritoTrabajo = ?");
        ArrayList<Object> params = new ArrayList<>();

        params.add(usuario.getDireccion());
        params.add(usuario.getIdDistrito());
        // Manejar idDistritoTrabajo (usar setObject para Integer que puede ser null)
        params.add(usuario.getIdDistritoTrabajo()); // Esto se establecerá a NULL si el bean tiene null

        // Agregar foto solo si viene en el objeto
        if (usuario.getFoto() != null && !usuario.getFoto().isEmpty()) {
            sql.append(", foto = ?");
            // Convierte el Base64 a bytes si tu columna foto es BLOB
            // Si la columna foto es String (ruta/URL), simplemente params.add(usuario.getFoto());
            try {
                byte[] fotoBytes = java.util.Base64.getDecoder().decode(usuario.getFoto());
                params.add(new java.io.ByteArrayInputStream(fotoBytes)); // Asume que la DB espera BLOB
            } catch (IllegalArgumentException e) {
                System.err.println("Error al decodificar la imagen Base64: " + e.getMessage());
                // Si la foto es una ruta string, no decodifiques y simplemente añádelo
                params.add(usuario.getFoto()); // Si la foto es solo una cadena (URL/ruta)
            }
        }

        sql.append(" WHERE idUsuario = ?");
        params.add(usuario.getIdUsuario());

        System.out.println("SQL a ejecutar: " + sql.toString());
        System.out.println("Parámetros: " + params);

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            // Establecer parámetros dinámicamente
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    stmt.setString(i + 1, (String) param);
                } else if (param instanceof Integer) {
                    stmt.setInt(i + 1, (Integer) param);
                } else if (param instanceof InputStream) {
                    stmt.setBlob(i + 1, (InputStream) param);
                } else if (param == null) { // Para manejar el caso de idDistritoTrabajo como NULL
                    stmt.setNull(i + 1, Types.INTEGER);
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
        // Este método NO incluye idDistritoTrabajo, si necesitas actualizarlo junto con estos,
        // considera usar actualizarPerfilCompleto o crear un método específico.
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

    public boolean insertarUsuario(Usuario usuario) throws SQLException {
        // **¡¡¡CAMBIO CRÍTICO AQUÍ: ACTUALIZAR LA SENTENCIA SQL Y LOS PLACEHOLDERS!!!**
        // Columnas en DB: nombre, apellidopaterno, apellidomaterno, dni, direccion, idrol, iddistrito, idDistritoTrabajo, idestado, foto, nombrefoto, idZonaTrabajo
        String sql = "INSERT INTO usuario (" +
                "nombre, apellidopaterno, apellidomaterno, dni, direccion, " +
                "idrol, iddistrito, idDistritoTrabajo, idestado, foto, nombrefoto, idZonaTrabajo" +
                ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"; // ¡12 PLACEHOLDERS!

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, usuario.getNombre());
            pstmt.setString(2, usuario.getApellidopaterno());
            pstmt.setString(3, usuario.getApellidomaterno());
            pstmt.setString(4, usuario.getDni());
            pstmt.setString(5, usuario.getDireccion());
            pstmt.setInt(6, usuario.getIdRol()); // idRol
            pstmt.setInt(7, usuario.getIdDistrito()); // idDistrito de residencia

            // idDistritoTrabajo (posición 8)
            if (usuario.getIdDistritoTrabajo() != null) {
                pstmt.setInt(8, usuario.getIdDistritoTrabajo());
            } else {
                pstmt.setNull(8, java.sql.Types.INTEGER);
            }

            pstmt.setInt(9, usuario.getIdEstado()); // idEstado (posición 9)

            // Manejo de 'foto' (longblob) y 'nombrefoto' (varchar)
            // 'usuario.getFoto()' (String) ahora se asume que es el contenido de la foto en Base64
            // 'usuario.getNombrefoto()' (String) es el nombre del archivo
            if (usuario.getFoto() != null && !usuario.getFoto().isEmpty()) {
                try {
                    byte[] fotoBytes = Base64.getDecoder().decode(usuario.getFoto());
                    pstmt.setBlob(10, new java.io.ByteArrayInputStream(fotoBytes)); // Para la columna 'foto' (BLOB)
                } catch (IllegalArgumentException e) {
                    System.err.println("Advertencia: La cadena de foto no es un Base64 válido. Se insertará NULL para la foto binaria.");
                    pstmt.setNull(10, java.sql.Types.BLOB); // Si no es Base64 válido, insertar NULL
                }
            } else {
                pstmt.setNull(10, java.sql.Types.BLOB); // Si no hay foto, insertar NULL
            }

            // nombrefoto (posición 11)
            if (usuario.getNombrefoto() != null && !usuario.getNombrefoto().isEmpty()) {
                pstmt.setString(11, usuario.getNombrefoto());
            } else {
                pstmt.setNull(11, java.sql.Types.VARCHAR);
            }

            // idZonaTrabajo (posición 12)
            if (usuario.getIdZonaTrabajo() != null) {
                pstmt.setInt(12, usuario.getIdZonaTrabajo());
            } else {
                pstmt.setNull(12, java.sql.Types.INTEGER);
            }

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        usuario.setIdUsuario(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        }
        return false;
    }


    public boolean existeDni(String dni) {
        String sql = "SELECT 1 FROM usuario WHERE dni = ?";

        try (Connection conn = getConnection();
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

        try (Connection conn = getConnection();
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
                usuario.setIdDistritoTrabajo((Integer) rs.getObject("idDistritoTrabajo")); // Leer aquí también
                usuario.setIdRol(rs.getInt("idRol"));
                usuario.setIdEstado(rs.getInt("idEstado"));
                // Asumiendo que la foto se guarda como BLOB en la DB y se convierte a Base64 en el bean.
                // Si la foto es String (ruta), usa rs.getString("foto")
                java.sql.Blob fotoBlob = rs.getBlob("foto");
                if (fotoBlob != null && fotoBlob.length() > 0) {
                    byte[] fotoBytes = fotoBlob.getBytes(1, (int) fotoBlob.length());
                    String fotoBase64 = java.util.Base64.getEncoder().encodeToString(fotoBytes);
                    usuario.setFoto(fotoBase64);
                } else {
                    usuario.setFoto(null);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return usuario;
    }

    public boolean actualizarPerfilConFoto(int idUsuario, String direccion, int idDistrito, Integer idDistritoTrabajo, InputStream fotoStream) {
        StringBuilder sql = new StringBuilder("UPDATE usuario SET direccion = ?, idDistrito = ?, idDistritoTrabajo = ?");
        List<Object> params = new ArrayList<>();

        params.add(direccion);
        params.add(idDistrito);
        params.add(idDistritoTrabajo); // Agrega el idDistritoTrabajo

        if (fotoStream != null) {
            sql.append(", foto = ?");
            params.add(fotoStream);
        }

        sql.append(" WHERE idUsuario = ?");
        params.add(idUsuario);

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    stmt.setString(idx++, (String) param);
                } else if (param instanceof Integer) {
                    stmt.setInt(idx++, (Integer) param);
                } else if (param instanceof InputStream) {
                    stmt.setBlob(idx++, (InputStream) param);
                } else if (param == null) { // Para manejar idDistritoTrabajo nulo
                    stmt.setNull(idx++, Types.INTEGER);
                }
            }

            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    public List<CoordinadorDTO> listarCoordinadoresConCorreo() {
        List<CoordinadorDTO> lista = new ArrayList<>();
        String sql = "SELECT u.*, c.correo FROM usuario u LEFT JOIN credencial c ON u.idUsuario = c.idUsuario WHERE u.idRol = 2 ORDER BY u.idUsuario DESC";
        try (Connection conn = getConnection();
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
                u.setIdDistritoTrabajo((Integer) rs.getObject("idDistritoTrabajo")); // Asegúrate de leerlo aquí también si lo necesitas
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
        if (params.size() <= 1) return false; // Solo está el idUsuario, no hay campos a actualizar

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    stmt.setString(idx++, (String) param);
                } else if (param instanceof Integer) {
                    stmt.setInt(idx++, (Integer) param);
                } else if (param instanceof InputStream) {
                    stmt.setBlob(idx++, (InputStream) param);
                } else if (param == null) { // Manejar parámetros nulos (especialmente para idDistritoTrabajo)
                    stmt.setNull(idx++, Types.INTEGER); // Asume que el null es para un INTEGER
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