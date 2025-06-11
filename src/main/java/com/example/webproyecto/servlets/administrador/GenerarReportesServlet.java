package com.example.webproyecto.servlets.administrador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "GenerarReportesServlet", value = "/GenerarReportesServlet")
public class GenerarReportesServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Puedes agregar aquí lógica para cargar datos de reportes si lo necesitas
        request.getRequestDispatcher("admin/generarReportes.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Aquí irá la lógica para generar reportes cuando implementes la funcionalidad
        doGet(request, response);
    }
}