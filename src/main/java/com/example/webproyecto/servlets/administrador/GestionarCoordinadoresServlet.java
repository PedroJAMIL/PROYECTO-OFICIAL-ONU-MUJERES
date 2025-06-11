package com.example.webproyecto.servlets.administrador;

import com.example.webproyecto.dtos.CoordinadorDTO;
import com.example.webproyecto.daos.UsuarioDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.json.JSONObject;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "GestionarCoordinadoresServlet", value = "/GestionarCoordinadoresServlet")
public class GestionarCoordinadoresServlet extends HttpServlet {
    private static final int COORDINADORES_POR_PAGINA = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("idUsuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Object idrolObj = session.getAttribute("idrol");
        int idrol = (idrolObj instanceof Integer) ? (Integer) idrolObj : Integer.parseInt(idrolObj.toString());
        if (idrol != 1) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        UsuarioDao usuarioDao = new UsuarioDao();
        String nombreFiltro = request.getParameter("nombre");
        String estadoFiltro = request.getParameter("estado");
        int paginaActual = 1;
        try {
            paginaActual = Integer.parseInt(request.getParameter("pagina"));
        } catch (Exception ignored) {}

        List<CoordinadorDTO> coordinadores = usuarioDao.listarCoordinadoresConCorreo();

        if (nombreFiltro != null && !nombreFiltro.trim().isEmpty()) {
            String filtroLower = nombreFiltro.trim().toLowerCase();
            coordinadores.removeIf(e ->
                    !(e.getUsuario().getNombre() + " " + e.getUsuario().getApellidopaterno() + " " + e.getUsuario().getApellidomaterno()).toLowerCase().contains(filtroLower)
                            && !e.getUsuario().getDni().contains(filtroLower)
            );
        }

        if (estadoFiltro != null && !estadoFiltro.isEmpty()) {
            try {
                int estadoInt = Integer.parseInt(estadoFiltro);
                coordinadores.removeIf(e -> e.getUsuario().getIdEstado() != estadoInt);
            } catch (NumberFormatException ignored) {}
        }

        int totalCoordinadores = coordinadores.size();
        int totalPaginas = (int) Math.ceil((double) totalCoordinadores / COORDINADORES_POR_PAGINA);
        if (paginaActual < 1) paginaActual = 1;
        if (paginaActual > totalPaginas) paginaActual = totalPaginas;

        int desde = (paginaActual - 1) * COORDINADORES_POR_PAGINA;
        int hasta = Math.min(desde + COORDINADORES_POR_PAGINA, totalCoordinadores);

        request.setAttribute("coordinadores", coordinadores.subList(desde, hasta));
        request.setAttribute("paginaActual", paginaActual);
        request.setAttribute("totalPaginas", totalPaginas);

        request.getRequestDispatcher("admin/gestionarCoordinadores.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        String accion = request.getParameter("accion");

        if ("guardarCambiosMasivos".equals(accion)) {
            String cambiosJson = request.getParameter("cambios");
            if (cambiosJson == null || cambiosJson.isEmpty()) {
                response.getWriter().write("{\"success\": false, \"message\": \"Sin datos\"}");
                return;
            }

            try {
                UsuarioDao usuarioDao = new UsuarioDao();
                JSONObject obj = new JSONObject(cambiosJson);
                boolean exito = true;

                for (String key : obj.keySet()) {
                    int idUsuario = Integer.parseInt(key);
                    int nuevoEstado = obj.getInt(key);
                    boolean actualizado = usuarioDao.cambiarEstadoUsuario(idUsuario, nuevoEstado);
                    if (!actualizado) exito = false;
                }

                if (exito) {
                    response.getWriter().write("{\"success\": true}");
                } else {
                    response.getWriter().write("{\"success\": false, \"message\": \"Algunos cambios no se guardaron\"}");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().write("{\"success\": false, \"message\": \"Error al procesar cambios\"}");
            }
            return;
        }

        response.getWriter().write("{\"success\": false, \"message\": \"Acción no reconocida\"}");
    }
}
