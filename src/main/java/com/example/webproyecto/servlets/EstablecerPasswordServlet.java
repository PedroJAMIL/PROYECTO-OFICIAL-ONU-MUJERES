package com.example.webproyecto.servlets;

import com.example.webproyecto.daos.CredencialDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/EstablecerPasswordServlet")
public class EstablecerPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String correo = request.getParameter("correo");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validaciones básicas
        if (correo == null || correo.trim().isEmpty() || 
            password == null || password.trim().isEmpty() || 
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("error", "Todos los campos son requeridos");
            request.setAttribute("correoUsuario", correo);
            request.getRequestDispatcher("establecerPassword.jsp").forward(request, response);
            return;
        }

        // Validar que las contraseñas coincidan
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Las contraseñas no coinciden");
            request.setAttribute("correoUsuario", correo);
            request.getRequestDispatcher("establecerPassword.jsp").forward(request, response);
            return;
        }

        // Validar fortaleza de la contraseña
        if (!isValidPassword(password)) {
            request.setAttribute("error", "La contraseña no cumple con los requisitos de seguridad");
            request.setAttribute("correoUsuario", correo);
            request.getRequestDispatcher("establecerPassword.jsp").forward(request, response);
            return;
        }

        correo = correo.trim().toLowerCase();

        System.out.println("🔐 Estableciendo contraseña para: " + correo);

        CredencialDao credencialDao = new CredencialDao();

        try {
            // Crear/actualizar credencial con la contraseña
            boolean exito = credencialDao.actualizarContrasenha(correo, password);
            
            if (exito) {
                System.out.println("✅ Contraseña establecida exitosamente para: " + correo);
                // Redirigir al login con mensaje de éxito
                response.sendRedirect("login.jsp?success=registro_exitoso");
            } else {
                System.out.println("❌ Error al establecer contraseña para: " + correo);
                request.setAttribute("error", "Error al establecer la contraseña. Inténtalo nuevamente.");
                request.setAttribute("correoUsuario", correo);
                request.getRequestDispatcher("establecerPassword.jsp").forward(request, response);
            }
        } catch (Exception e) {
            System.err.println("❌ Error en EstablecerPasswordServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error interno del sistema. Inténtalo nuevamente.");
            request.setAttribute("correoUsuario", correo);
            request.getRequestDispatcher("establecerPassword.jsp").forward(request, response);
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
