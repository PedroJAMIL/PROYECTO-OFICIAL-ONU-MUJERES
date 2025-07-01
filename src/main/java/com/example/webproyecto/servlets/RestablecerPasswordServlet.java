package com.example.webproyecto.servlets;

import com.example.webproyecto.daos.CodigoDao;
import com.example.webproyecto.daos.CredencialDao;
import com.example.webproyecto.beans.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/restablecerPassword")
public class RestablecerPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("🔐 RestablecerPasswordServlet - Iniciando proceso");
        
        String correo = request.getParameter("correo");
        String codigo = request.getParameter("codigo");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validaciones básicas
        if (correo == null || correo.trim().isEmpty()) {
            System.out.println("❌ Correo vacío");
            request.setAttribute("error", "Correo no válido");
            request.setAttribute("correoUsuario", correo);
            request.getRequestDispatcher("restablecerPassword.jsp").forward(request, response);
            return;
        }
        
        if (codigo == null || codigo.trim().isEmpty() || codigo.length() != 6) {
            System.out.println("❌ Código inválido: " + codigo);
            request.setAttribute("error", "Código de verificación inválido");
            request.setAttribute("correoUsuario", correo);
            request.getRequestDispatcher("restablecerPassword.jsp").forward(request, response);
            return;
        }
        
        if (password == null || password.trim().isEmpty()) {
            System.out.println("❌ Contraseña vacía");
            request.setAttribute("error", "La contraseña es requerida");
            request.setAttribute("correoUsuario", correo);
            request.getRequestDispatcher("restablecerPassword.jsp").forward(request, response);
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            System.out.println("❌ Contraseñas no coinciden");
            request.setAttribute("error", "Las contraseñas no coinciden");
            request.setAttribute("correoUsuario", correo);
            request.getRequestDispatcher("restablecerPassword.jsp").forward(request, response);
            return;
        }
        
        // Validar fortaleza de contraseña
        if (!isValidPassword(password)) {
            System.out.println("❌ Contraseña no cumple requisitos");
            request.setAttribute("error", "La contraseña debe tener al menos 8 caracteres, incluyendo mayúsculas, minúsculas, números y caracteres especiales");
            request.setAttribute("correoUsuario", correo);
            request.getRequestDispatcher("restablecerPassword.jsp").forward(request, response);
            return;
        }
        
        correo = correo.trim().toLowerCase();
        codigo = codigo.trim().toUpperCase();
        
        System.out.println("🔐 Procesando restablecimiento para: " + correo + " con código: " + codigo);
        
        CodigoDao codigoDao = new CodigoDao();
        
        try {
            // Verificar que el usuario existe
            Usuario usuario = codigoDao.getUsuarioByCorreo(correo);
            if (usuario == null) {
                System.out.println("❌ Usuario no encontrado: " + correo);
                request.setAttribute("error", "Usuario no encontrado");
                request.setAttribute("correoUsuario", correo);
                request.getRequestDispatcher("restablecerPassword.jsp").forward(request, response);
                return;
            }
            
            // Verificar código usando el método específico para recuperación de contraseña
            boolean codigoValido = codigoDao.verificarCodigoRecuperacion(correo, codigo);
            if (!codigoValido) {
                System.out.println("❌ Código inválido o expirado: " + codigo);
                request.setAttribute("error", "Código de verificación inválido o expirado");
                request.setAttribute("correoUsuario", correo);
                request.getRequestDispatcher("restablecerPassword.jsp").forward(request, response);
                return;
            }
            
            System.out.println("✅ Código válido, procediendo a actualizar contraseña");
            
            // Actualizar contraseña usando CredencialDao
            CredencialDao credencialDao = new CredencialDao();
            boolean contrasenhaActualizada = credencialDao.actualizarContrasenha(correo, password);
            
            if (contrasenhaActualizada) {
                System.out.println("✅ Contraseña actualizada para correo: " + correo);
                
                // Eliminar código usado específicamente de recuperación
                codigoDao.eliminarCodigoRecuperacion(correo);
                System.out.println("✅ Código de recuperación eliminado tras uso exitoso");
                
                // Verificar si es una petición AJAX
                String requestedWith = request.getHeader("X-Requested-With");
                String accept = request.getHeader("Accept");
                
                if ("XMLHttpRequest".equals(requestedWith) || 
                    (accept != null && accept.contains("application/json"))) {
                    // Respuesta JSON para AJAX
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("{\"success\": true, \"message\": \"Contraseña restablecida exitosamente\"}");
                } else {
                    // Respuesta HTML que el JavaScript puede detectar
                    response.setContentType("text/html");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("success - Contraseña restablecida exitosamente");
                }
            } else {
                System.out.println("❌ Error al actualizar contraseña");
                request.setAttribute("error", "Error al actualizar la contraseña");
                request.setAttribute("correoUsuario", correo);
                request.getRequestDispatcher("restablecerPassword.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error en RestablecerPasswordServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error interno del sistema. Inténtalo más tarde.");
            request.setAttribute("correoUsuario", correo);
            request.getRequestDispatcher("restablecerPassword.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String correo = request.getParameter("correo");
        if (correo != null && !correo.trim().isEmpty()) {
            request.setAttribute("correoUsuario", correo);
            request.getRequestDispatcher("restablecerPassword.jsp").forward(request, response);
        } else {
            response.sendRedirect("recuperarPassword.jsp");
        }
    }
    
    /**
     * Valida que la contraseña cumpla con los requisitos de seguridad
     */
    private boolean isValidPassword(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }
        
        boolean hasUpper = false;
        boolean hasLower = false;
        boolean hasDigit = false;
        boolean hasSpecial = false;
        
        String specialChars = "@$!%*?&";
        
        for (char c : password.toCharArray()) {
            if (Character.isUpperCase(c)) {
                hasUpper = true;
            } else if (Character.isLowerCase(c)) {
                hasLower = true;
            } else if (Character.isDigit(c)) {
                hasDigit = true;
            } else if (specialChars.indexOf(c) >= 0) {
                hasSpecial = true;
            }
        }
        
        return hasUpper && hasLower && hasDigit && hasSpecial;
    }
}
