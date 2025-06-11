package com.example.webproyecto.servlets.coordinador;
    

import com.example.webproyecto.daos.encuestador.AsignacionFormularioDao;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AsignarFormularioServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int idEncuestador = Integer.parseInt(request.getParameter("idEncuestador"));
        int idFormulario = Integer.parseInt(request.getParameter("idFormulario"));

        AsignacionFormularioDao asignacionDAO = new AsignacionFormularioDao();
        asignacionDAO.asignarFormulario(idEncuestador, idFormulario);

        response.sendRedirect("verFormularios.jsp?mensaje=asignacion_exitosa");
    }
}
