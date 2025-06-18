package com.example.webproyecto.daos;

import com.example.webproyecto.utils.CodeGenerator;
import com.example.webproyecto.utils.PasswordUtil;
import com.example.webproyecto.beans.Usuario;
import java.sql.*;

public class CodigoDao extends BaseDao {
    
    public String generateCodigo(String correo) {
        Usuario usuario = getUsuarioByCorreo(correo);
        String codigo = CodeGenerator.generator();
        String sql = "INSERT INTO codigo_verificacion (idusuario, codigo) VALUES (?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, usuario.getIdUsuario());
            pstmt.setString(2, codigo);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return codigo;
    }
    
    public Usuario getUsuarioByCorreo(String correo) {
        Usuario usuario = null;
        String sql = "SELECT u.* FROM usuario u JOIN credencial c ON u.idusuario = c.idusuario WHERE c.correo = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, correo);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    usuario = new Usuario();
                    usuario.setIdUsuario(rs.getInt("idusuario"));
                    // Omitimos setCorreo porque la clase Usuario no tiene este método
                    // El correo se maneja separadamente en la tabla credencial
                    usuario.setNombre(rs.getString("nombre"));
                    usuario.setApellidopaterno(rs.getString("apellidopaterno"));
                    usuario.setApellidomaterno(rs.getString("apellidomaterno"));
                    usuario.setDni(rs.getString("dni"));
                    usuario.setDireccion(rs.getString("direccion"));
                    usuario.setIdDistrito(rs.getInt("idDistrito"));
                    usuario.setIdRol(rs.getInt("idRol"));
                    usuario.setIdEstado(rs.getInt("idEstado"));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return usuario;
    }

    public boolean findCodigo(String codigoIngresado) {
        String sql = "SELECT codigo FROM codigo_verificacion WHERE codigo = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, codigoIngresado);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);        }
    }

    public void deleteCodigo(String codigo) {
        String sql = "DELETE FROM codigo_verificacion WHERE codigo = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, codigo);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);        }
    }
    
    public void marcarUsuarioComoVerificado(int usuarioId) {
        // Actualizar tanto el estado del usuario como marcar la credencial como verificada
        String sqlUsuario = "UPDATE usuario SET idestado = 1 WHERE idusuario = ?";
        String sqlCredencial = "UPDATE credencial SET verificado = TRUE WHERE idusuario = ?";
        
        try (Connection conn = getConnection()) {
            // Actualizar estado de usuario
            try (PreparedStatement pstmt1 = conn.prepareStatement(sqlUsuario)) {
                pstmt1.setInt(1, usuarioId);
                pstmt1.executeUpdate();
            }
            
            // Marcar credencial como verificada
            try (PreparedStatement pstmt2 = conn.prepareStatement(sqlCredencial)) {
                pstmt2.setInt(1, usuarioId);
                pstmt2.executeUpdate();
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public int getUsuarioIdByCodigo(String codigo) {
        String sql = "SELECT idusuario FROM codigo_verificacion WHERE codigo = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, codigo);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("idusuario");
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return -1;
    }

    public void actualizarContrasena(int usuarioId, String contrasena) {
        String sql = "UPDATE credencial SET contrasenha = ? WHERE idusuario = ?";
        String hashedPassword = PasswordUtil.hashPassword(contrasena);
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, hashedPassword);
            pstmt.setInt(2, usuarioId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}