package com.example.webproyecto.servlets.coordinador;
import com.google.gson.Gson;

import com.example.webproyecto.daos.UsuarioDao;
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

        // Datos para gráficos
        int activosZona = usuarioDao.contarEncuestadoresPorZona(idUsuarioCoordinador, true);
        int inactivosZona = usuarioDao.contarEncuestadoresPorZona(idUsuarioCoordinador, false);

        // Map<String, int[]> distritos = usuarioDao.contarEncuestadoresPorDistritoEnZona(idUsuarioCoordinador);
        Map<String, int[]> distritos = usuarioDao.contarEncuestadoresPorDistritoEnZonaConEstados(idUsuarioCoordinador);
        // distritos -> nombreDistrito : [activos, inactivos]

        List<String> nombresDistritos = distritos.keySet().stream().toList();
        List<Integer> activos = distritos.values().stream().map(v -> v[0]).toList();
        List<Integer> inactivos = distritos.values().stream().map(v -> v[1]).toList();

        // Pasar como JSON Strings
        request.setAttribute("activosZona", activosZona);
        request.setAttribute("inactivosZona", inactivosZona);

        Gson gson = new Gson();
        request.setAttribute("distritosJson", gson.toJson(nombresDistritos));
        request.setAttribute("activosDistritoJson", gson.toJson(activos));
        request.setAttribute("inactivosDistritoJson", gson.toJson(inactivos));
        System.out.println("Distritos JSON: " + gson.toJson(nombresDistritos));

        request.setAttribute("nombre", session.getAttribute("nombre"));
        request.setAttribute("idUsuario", idUsuarioCoordinador);
        request.setAttribute("idrol", session.getAttribute("idrol"));

        System.out.println("Distritos: " + new Gson().toJson(nombresDistritos));

        request.getRequestDispatcher("coordinador/jsp/VerDashboard.jsp").forward(request, response);
    }

    private String toJsonArray(List<?> list) {
        return "[" + list.stream()
                .map(item -> item instanceof String ? "\"" + item + "\"" : item.toString())
                .collect(Collectors.joining(", ")) + "]";
    }
}
