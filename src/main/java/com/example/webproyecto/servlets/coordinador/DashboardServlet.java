package com.example.webproyecto.servlets.coordinador;

import com.example.webproyecto.daos.SesionRespuestaDao;
import com.example.webproyecto.daos.UsuarioDao;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(name = "DashboardServlet", value = "/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("idUsuario") == null ||
                (int) session.getAttribute("idrol") != 2) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int idUsuarioCoordinador = (int) session.getAttribute("idUsuario");
        UsuarioDao usuarioDao = new UsuarioDao();
        SesionRespuestaDao sesionRespuestaDao = new SesionRespuestaDao();

        // Datos para gráficos
        int encuestadoresActivos = usuarioDao.contarEncuestadoresPorZona(idUsuarioCoordinador, true);
        int encuestadoresInactivos = usuarioDao.contarEncuestadoresPorZona(idUsuarioCoordinador, false);

        Map<String, int[]> distritos = usuarioDao.contarEncuestadoresPorDistritoEnZona(idUsuarioCoordinador);
        List<String> nombresDistritos = distritos.keySet().stream().toList();
        List<Integer> activos = distritos.values().stream().map(v -> v[0]).toList();
        List<Integer> inactivos = distritos.values().stream().map(v -> v[1]).toList();

        // Datos para gráfico de formularios por mes
        List<Map<String, Object>> datosGraficoLineas = sesionRespuestaDao.obtenerFormulariosCompletadosPorEncuestadorYMes(idUsuarioCoordinador);

        // Pasar atributos a la vista
        request.setAttribute("encuestadoresActivos", encuestadoresActivos);
        request.setAttribute("encuestadoresInactivos", encuestadoresInactivos);
        request.setAttribute("datosGraficoLineas", datosGraficoLineas);

        Gson gson = new Gson();
        request.setAttribute("distritosJson", gson.toJson(nombresDistritos));
        request.setAttribute("activosDistritoJson", gson.toJson(activos));
        request.setAttribute("inactivosDistritoJson", gson.toJson(inactivos));

        request.setAttribute("nombre", session.getAttribute("nombre"));
        request.setAttribute("idUsuario", idUsuarioCoordinador);
        request.setAttribute("idrol", session.getAttribute("idrol"));

        request.getRequestDispatcher("coordinador/jsp/VerDashboard.jsp").forward(request, response);
    }
}