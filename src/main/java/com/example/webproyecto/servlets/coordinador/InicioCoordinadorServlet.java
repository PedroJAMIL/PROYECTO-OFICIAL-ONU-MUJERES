package com.example.webproyecto.servlets.coordinador;

import com.example.webproyecto.daos.encuestador.SesionRespuestaDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "InicioCoordinadorServlet", value = "/InicioCoordinadorServlet")

public class InicioCoordinadorServlet extends HttpServlet{
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("idUsuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        Object idrolObj = session.getAttribute("idrol");
        if (idrolObj == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        int idrol = (idrolObj instanceof Integer) ? (Integer) idrolObj : Integer.parseInt(idrolObj.toString());
        if (idrol != 2) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int idEncuestador = (int) session.getAttribute("idUsuario");

        SesionRespuestaDao srDao = new SesionRespuestaDao();
        List<Map<String, Object>> resumenSesiones = srDao.obtenerResumenSesionesPorEncuestador(idEncuestador);

        request.setAttribute("resumenSesiones", resumenSesiones);
        request.setAttribute("nombre", session.getAttribute("nombre"));
        request.setAttribute("idUsuario", session.getAttribute("idUsuario"));
        request.setAttribute("idrol", session.getAttribute("idrol"));

        request.getRequestDispatcher("coordinador/jsp/VerDashboard.jsp").forward(request, response);
    }
}
