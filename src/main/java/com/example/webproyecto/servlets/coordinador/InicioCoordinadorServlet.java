package com.example.webproyecto.servlets.coordinador;

import com.example.webproyecto.daos.UsuarioDao;
import com.example.webproyecto.daos.encuestador.SesionRespuestaDao;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "InicioCoordinadorServlet", value = "/InicioCoordinadorServlet")
public class InicioCoordinadorServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("idUsuario") == null || session.getAttribute("idrol") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int idrol = (session.getAttribute("idrol") instanceof Integer)
                ? (Integer) session.getAttribute("idrol")
                : Integer.parseInt(session.getAttribute("idrol").toString());

        if (idrol != 2) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int idUsuarioCoordinador = (int) session.getAttribute("idUsuario");

        // Obtener datos dinámicos para el dashboard
        UsuarioDao usuarioDao = new UsuarioDao();
        int encuestadoresActivos = usuarioDao.contarEncuestadoresPorZona(idUsuarioCoordinador, true);
        int encuestadoresDesactivos = usuarioDao.contarEncuestadoresPorZona(idUsuarioCoordinador, false);

        // Obtener datos para el gráfico de distritos
        Map<String, int[]> encuestadoresPorDistrito = usuarioDao.contarEncuestadoresPorDistritoEnZona(idUsuarioCoordinador);

        // Obtener datos para el gráfico de líneas (respuestas por mes)
        SesionRespuestaDao sesionRespuestaDao = new SesionRespuestaDao();
        List<Map<String, Object>> datosGraficoLineas = sesionRespuestaDao.obtenerFormulariosCompletadosPorZonaYMes();

        // Convertir datos a JSON para JavaScript
        Gson gson = new Gson();
        request.setAttribute("encuestadoresActivos", encuestadoresActivos);
        request.setAttribute("encuestadoresDesactivos", encuestadoresDesactivos);
        request.setAttribute("datosGraficoLineas", datosGraficoLineas);
        request.setAttribute("encuestadoresPorDistrito", gson.toJson(encuestadoresPorDistrito));
        request.setAttribute("distritosJson", gson.toJson(encuestadoresPorDistrito.keySet()));

        request.setAttribute("nombre", session.getAttribute("nombre"));
        request.setAttribute("idUsuario", session.getAttribute("idUsuario"));
        request.setAttribute("idrol", session.getAttribute("idrol"));

        request.getRequestDispatcher("coordinador/jsp/VerDashboard.jsp").forward(request, response);
    }
}