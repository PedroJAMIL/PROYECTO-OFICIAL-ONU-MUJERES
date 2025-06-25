package com.example.webproyecto.servlets.coordinador;
import com.example.webproyecto.daos.UsuarioDao;
import com.google.gson.Gson;

import com.example.webproyecto.daos.encuestador.SesionRespuestaDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "InicioCoordinadorServlet", value = "/InicioCoordinadorServlet")

public class InicioCoordinadorServlet extends HttpServlet {
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

        int idUsuarioCoordinador = (int) session.getAttribute("idUsuario");

        // Datos del dashboard
        UsuarioDao usuarioDao = new UsuarioDao();

        int activosZona = usuarioDao.contarEncuestadoresPorZona(idUsuarioCoordinador, true);
        int inactivosZona = usuarioDao.contarEncuestadoresPorZona(idUsuarioCoordinador, false);

        // Map<String, int[]> distritos = usuarioDao.contarEncuestadoresPorDistritoEnZona(idUsuarioCoordinador);
        Map<String, int[]> distritos = usuarioDao.contarEncuestadoresPorDistritoEnZonaConEstados(idUsuarioCoordinador);

        List<String> nombresDistritos = distritos.keySet().stream().toList();
        List<Integer> activos = distritos.values().stream().map(v -> v[0]).toList();
        List<Integer> inactivos = distritos.values().stream().map(v -> v[1]).toList();

        Gson gson = new Gson();
        request.setAttribute("activosZona", activosZona);
        request.setAttribute("inactivosZona", inactivosZona);
        request.setAttribute("distritosJson", gson.toJson(nombresDistritos));
        request.setAttribute("activosDistritoJson", gson.toJson(activos));
        request.setAttribute("inactivosDistritoJson", gson.toJson(inactivos));

        // Otros datos (como resumen de sesiones)
        SesionRespuestaDao srDao = new SesionRespuestaDao();
        List<Map<String, Object>> resumenSesiones = srDao.obtenerResumenSesionesPorEncuestador(idUsuarioCoordinador);
        request.setAttribute("resumenSesiones", resumenSesiones);

        request.setAttribute("nombre", session.getAttribute("nombre"));
        request.setAttribute("idUsuario", session.getAttribute("idUsuario"));
        request.setAttribute("idrol", session.getAttribute("idrol"));

        // Renderiza el dashboard
        request.getRequestDispatcher("coordinador/jsp/VerDashboard.jsp").forward(request, response);
    }
}
