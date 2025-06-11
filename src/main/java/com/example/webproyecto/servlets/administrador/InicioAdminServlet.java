package com.example.webproyecto.servlets.administrador;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "InicioAdminServlet", value = "/InicioAdminServlet")
public class InicioAdminServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Solo permite acceso a usuarios con rol de administrador (por ejemplo, rolId == 1)
        if (session == null || session.getAttribute("idUsuario") == null || session.getAttribute("idrol") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        int idrol = (session.getAttribute("idrol") instanceof Integer)
                ? (Integer) session.getAttribute("idrol")
                : Integer.parseInt(session.getAttribute("idrol").toString());
        if (idrol != 1) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Aquí puedes agregar lógica para obtener datos del dashboard, por ejemplo:
        // int encuestadoresActivos = ...;
        // request.setAttribute("encuestadoresActivos", encuestadoresActivos);

        request.setAttribute("nombre", session.getAttribute("nombre"));
        request.setAttribute("idUsuario", session.getAttribute("idUsuario"));
        request.setAttribute("idrol", session.getAttribute("idrol"));

        request.getRequestDispatcher("admin/dashboardAdmin.jsp").forward(request, response);
    }
}