package com.example.webproyecto.servlets.coordinador;

import com.example.webproyecto.daos.encuestador.RespuestaDao;
import com.example.webproyecto.daos.UsuarioDao;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;

public class DashboardCoordinadorServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RespuestaDao respuestaDAO = new RespuestaDao();
        UsuarioDao usuarioDAO = new UsuarioDao();

        Map<String, Integer> respuestasPorEncuestador = respuestaDAO.obtenerResumenPorEncuestador();
        Map<String, Integer> respuestasPorDistrito = respuestaDAO.obtenerResumenPorDistrito();

        request.setAttribute("respuestasPorEncuestador", respuestasPorEncuestador);
        request.setAttribute("respuestasPorDistrito", respuestasPorDistrito);

        RequestDispatcher dispatcher = request.getRequestDispatcher("jsp/coordinadorinterno/dashboard.jsp");
        dispatcher.forward(request, response);
    }
}

