package com.example.webproyecto.daos;

import com.example.webproyecto.beans.Credencial;
import com.example.webproyecto.beans.Usuario;
import com.mysql.cj.jdbc.Blob;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;

public class CredencialDao {

    private final String url = "jdbc:mysql://localhost:3306/proyecto";
    private final String user = "root";
    private final String pass = "root";

    // Utilidad para hashear con SHA-256
    private String sha256(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = md.digest(input.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hashBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }    public Usuario validarLogin(String correo, String contrasenha) {
        Usuario usuario = null;

        String sql = """
            SELECT u.idUsuario, u.nombre, u.apellidopaterno, u.apellidomaterno, u.dni, u.direccion,
                   u.idRol, u.idDistrito, u.idEstado, u.foto, c.contrasenha
            FROM usuario u
            INNER JOIN credencial c ON u.idUsuario = c.idUsuario
            WHERE c.correo = ? AND u.idEstado IN (1,2,3) AND c.verificado = TRUE
            """;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(url, user, pass);
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setString(1, correo);

                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    String hashAlmacenado = rs.getString("contrasenha");
                    String hashIngresado = sha256(contrasenha);
                    
                    if (hashIngresado.equals(hashAlmacenado)) {
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
                        usuario.setFoto(rs.getString("foto"));
                    }
                }

            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }        return usuario;
    }

    /* ====== CÓDIGO DE VERIFICACIÓN POR CORREO (COMENTADO) ======
    public Usuario validarLogin(String correo, String contrasenha) {
        Usuario usuario = null;
        
        String sql = """
            SELECT u.idUsuario, u.nombre, u.apellidopaterno, u.apellidomaterno, u.dni, u.direccion,
                   u.idRol, u.idDistrito, u.idEstado, u.foto, c.contrasenha
            FROM usuario u
            INNER JOIN credencial c ON u.idUsuario = c.idUsuario
            WHERE c.correo = ? AND u.idEstado = 1 AND c.verificado = TRUE
            """;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(url, user, pass);
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setString(1, correo);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    String hashAlmacenado = rs.getString("contrasenha");
                    
                    if (hashAlmacenado != null) {
                        // Validar contraseña hasheada
                        String hashIngresado = sha256(contrasenha);
                        if (hashIngresado.equals(hashAlmacenado)) {
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
                            usuario.setFoto(rs.getString("foto"));
                        }
                    }
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return usuario;
    }    ====== FIN CÓDIGO DE VERIFICACIÓN POR CORREO ====== */

    /* ====== CÓDIGO MODO DESARROLLO (COMENTADO) ======
    public Usuario validarLogin(String correo, String contrasenha) {
        Usuario usuario = null;

        // MODO DESARROLLO: Desactivar verificación por correo temporalmente
        boolean verificacionDesactivada = true; // Cambiar a false para activar verificación

        String sql = """
            SELECT u.idUsuario, u.nombre, u.apellidopaterno, u.apellidomaterno, u.dni, u.direccion,
                   u.idRol, u.idDistrito, u.idEstado, u.foto, c.contrasenha
            FROM usuario u
            INNER JOIN credencial c ON u.idUsuario = c.idUsuario
            WHERE c.correo = ? AND u.idEstado IN (1,2,3) AND c.verificado = TRUE
            """;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(url, user, pass);
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setString(1, correo);

                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    String hashAlmacenado = rs.getString("contrasenha");
                    
                    if (verificacionDesactivada && hashAlmacenado == null) {
                        // En modo desarrollo: permitir login sin contraseña
                        // Redirigir al usuario a establecer contraseña
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
                        usuario.setFoto(rs.getString("foto"));
                        // Marcamos que necesita establecer contraseña
                        usuario.setIdEstado(-1); // Estado especial para "necesita contraseña"
                    } else if (hashAlmacenado != null) {
                        // Flujo normal con contraseña
                        String hashIngresado = sha256(contrasenha);
                        if (hashIngresado.equals(hashAlmacenado)) {
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
                            usuario.setFoto(rs.getString("foto"));
                        }
                    }
                }

            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }        return usuario;
    }
    ====== FIN CÓDIGO MODO DESARROLLO ====== */

    public boolean cambiarContrasenha(int idUsuario, String contrasenaActual, String nuevaContrasenha) {
        // Hashear ambas contraseñas antes de usarlas
        String hashActual = sha256(contrasenaActual);
        String hashNueva = sha256(nuevaContrasenha);

        String sqlVerificar = "SELECT 1 FROM credencial WHERE idUsuario = ? AND contrasenha = ?";
        String sqlActualizar = "UPDATE credencial SET contrasenha = ? WHERE idUsuario = ?";

        try (Connection conn = DriverManager.getConnection(url, user, pass)) {
            // Verificar contraseña actual
            try (PreparedStatement stmtVerificar = conn.prepareStatement(sqlVerificar)) {
                stmtVerificar.setInt(1, idUsuario);
                stmtVerificar.setString(2, hashActual);

                ResultSet rs = stmtVerificar.executeQuery();
                if (!rs.next()) {
                    return false; // La contraseña actual no coincide
                }
            }

            // Actualizar a la nueva contraseña
            try (PreparedStatement stmtActualizar = conn.prepareStatement(sqlActualizar)) {
                stmtActualizar.setString(1, hashNueva);
                stmtActualizar.setInt(2, idUsuario);

                return stmtActualizar.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;        }
    }

    // Método para insertar credencial con flujo directo
    public boolean insertarCredencial(Credencial credencial) {
        String sql = "INSERT INTO credencial (correo, contrasenha, idUsuario, verificado) VALUES (?, ?, ?, ?)";

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, credencial.getCorreo());
            stmt.setString(2, sha256(credencial.getContrasenha())); // Hashear contraseña
            stmt.setInt(3, credencial.getIdUsuario());
            stmt.setBoolean(4, true); // Siempre verificado en el nuevo flujo
            
            int filasAfectadas = stmt.executeUpdate();
            return filasAfectadas > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /* ====== CÓDIGO DE VERIFICACIÓN POR CORREO (COMENTADO) ======
    public boolean insertarCredencial(Credencial credencial) {
        String sql = "INSERT INTO credencial (correo, contrasenha, idUsuario, verificado) VALUES (?, ?, ?, ?)";

        // MODO DESARROLLO: Desactivar verificación por correo temporalmente
        boolean verificacionDesactivada = true; // Cambiar a false para activar verificación

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, credencial.getCorreo());
            
            if (verificacionDesactivada) {
                // En modo desarrollo: marcar como verificado automáticamente
                stmt.setNull(2, java.sql.Types.VARCHAR); // Sin contraseña inicialmente
                stmt.setBoolean(4, true); // Marcado como verificado para permitir login
            } else {
                // Flujo original con verificación por correo
                if (credencial.getContrasenha() != null) {
                    stmt.setString(2, sha256(credencial.getContrasenha()));
                    stmt.setBoolean(4, true); // Verificado si tiene contraseña
                } else {
                    stmt.setNull(2, java.sql.Types.VARCHAR); // Sin contraseña inicialmente
                    stmt.setBoolean(4, false); // No verificado hasta que establezca contraseña
                }
            }
            
            stmt.setInt(3, credencial.getIdUsuario());

            int filasAfectadas = stmt.executeUpdate();
            return filasAfectadas > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    ====== FIN CÓDIGO DE VERIFICACIÓN POR CORREO ====== */

    public boolean existeCorreo(String correo) {
        String sql = "SELECT 1 FROM credencial WHERE correo = ?";

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, correo);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean actualizarCorreo(int idUsuario, String nuevoCorreo) {
        String sql = "UPDATE credencial SET correo = ? WHERE idUsuario = ?";

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, nuevoCorreo);
            stmt.setInt(2, idUsuario);

            int filasAfectadas = stmt.executeUpdate();
            return filasAfectadas > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean insertarUsuario(Usuario usuario) {
        String sql = "INSERT INTO usuario (nombre, apellidopaterno, apellidomaterno, dni, direccion, idDistrito, idRol, idEstado, foto) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
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
            stmt.setString(9, usuario.getFoto());
            int filas = stmt.executeUpdate();
            if (filas > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    usuario.setIdUsuario(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

}


