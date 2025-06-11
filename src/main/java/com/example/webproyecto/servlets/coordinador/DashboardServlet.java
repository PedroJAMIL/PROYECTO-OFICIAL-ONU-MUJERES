package com.example.webproyecto.servlets.coordinador;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "DashboardServlet", value = "/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Solo permite acceso a coordinadores (idrol == 2)
        if (session == null || session.getAttribute("idUsuario") == null ||
                (int) session.getAttribute("idrol") != 2) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Aquí puedes agregar lógica para obtener datos del dashboard si lo necesitas
        // Por ejemplo:
        // List<Estadistica> estadisticas = dashboardDao.obtenerEstadisticas();
        // request.setAttribute("estadisticas", estadisticas);

        request.setAttribute("nombre", session.getAttribute("nombre"));
        request.setAttribute("idUsuario", session.getAttribute("idUsuario"));
        request.setAttribute("idrol", session.getAttribute("idrol"));

        request.getRequestDispatcher("coordinador/jsp/VerDashboard.jsp").forward(request, response);
    }
}