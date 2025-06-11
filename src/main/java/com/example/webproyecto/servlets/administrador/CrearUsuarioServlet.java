package com.example.webproyecto.servlets.administrador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "CrearUsuarioServlet", value = "/CrearUsuarioServlet")
public class CrearUsuarioServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Muestra el formulario para seleccionar tipo de usuario
        request.getRequestDispatcher("admin/crearUsuario.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Recibe la selección del tipo de usuario
        String tipoUsuario = request.getParameter("tipoUsuario");
        if ("coordinador".equals(tipoUsuario)) {
            response.sendRedirect("CrearCoordinadorServlet");
        } else if ("encuestador".equals(tipoUsuario)) {
            response.sendRedirect("CrearEncuestadorServlet");
        } else {
            // Si no se seleccionó nada o es inválido, vuelve al inicio
            response.sendRedirect("InicioAdminServlet");
        }
    }
}