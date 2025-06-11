package com.example.webproyecto.servlets.coordinador;

import com.example.webproyecto.daos.UsuarioDao;
import com.example.webproyecto.dtos.CoordinadorDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.json.JSONObject;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "GestionEncuestadoresServlet", value = "/GestionEncuestadoresServlet")
public class GestionEncuestadoresServlet extends HttpServlet {
    @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        System.out.println("idUsuario: " + session.getAttribute("idUsuario"));
        System.out.println("idrol: " + session.getAttribute("idrol"));

        if (session.getAttribute("idUsuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        Object idrolObj = session.getAttribute("idrol");
        if (idrolObj == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        int idrol = (idrolObj instanceof Integer) ? (Integer) idrolObj : Integer.parseInt(idrolObj.toString());
        if (idrol != 2) { // 2 para coordinador
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        UsuarioDao usuarioDao = new UsuarioDao();
        String nombreFiltro = request.getParameter("nombre");
        String estadoFiltro = request.getParameter("estado");

        List<CoordinadorDTO> encuestadores = usuarioDao.listarEncuestadoresConCorreo();

        if (nombreFiltro != null && !nombreFiltro.trim().isEmpty()) {
            String filtroLower = nombreFiltro.trim().toLowerCase();
            encuestadores.removeIf(e ->
                    !(e.getUsuario().getNombre() + " " + e.getUsuario().getApellidopaterno() + " " + e.getUsuario().getApellidomaterno()).toLowerCase().contains(filtroLower)
                            && !e.getUsuario().getDni().contains(filtroLower)
            );
        }

        if (estadoFiltro != null && !estadoFiltro.isEmpty()) {
            try {
                int estadoInt = Integer.parseInt(estadoFiltro);
                encuestadores.removeIf(e -> e.getUsuario().getIdEstado() != estadoInt);
            } catch (NumberFormatException ex) {
                System.out.println("Estado inválido recibido: " + estadoFiltro);
            }
        }
        request.setAttribute("encuestadores", encuestadores);

        request.getRequestDispatcher("coordinador/jsp/VerFormularios.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");

        String accion = request.getParameter("accion");
        System.out.println("ACCION: " + accion);  // <--- NUEVO

        if ("cambiarEstado".equals(accion)) {
            try {
                int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
                String estadoParam = request.getParameter("nuevoEstado");
                int nuevoEstado;

                try {
                    nuevoEstado = Integer.parseInt(estadoParam);
                    if (nuevoEstado != 1 && nuevoEstado != 2) {
                        throw new NumberFormatException("Valor fuera de rango esperado");
                    }
                } catch (NumberFormatException e) {
                    response.getWriter().write("{\"success\": false, \"message\": \"Estado inválido\"}");
                    System.out.println("ERROR: nuevoEstado inválido -> " + estadoParam);
                    return;
                }


                System.out.println("Cambiar estado de usuario ID " + idUsuario + " a estado " + nuevoEstado); // <--- NUEVO

                UsuarioDao usuarioDao = new UsuarioDao();
                boolean actualizado = usuarioDao.cambiarEstadoUsuario(idUsuario, nuevoEstado);

                System.out.println("¿Actualizado en BD?: " + actualizado); // <--- NUEVO
                System.out.println("Cambio de estado exitoso en la base de datos: " + actualizado);

                if (actualizado) {
                    response.getWriter().write("{\"success\": true}");
                } else {
                    response.getWriter().write("{\"success\": false, \"message\": \"No se pudo actualizar en BD\"}");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().write("{\"success\": false, \"message\": \"Error en servidor\"}");
            }
        }
        if ("guardarCambiosMasivos".equals(accion)) {
            String cambiosJson = request.getParameter("cambios");
            if (cambiosJson == null || cambiosJson.isEmpty()) {
                response.getWriter().write("{\"success\": false, \"message\": \"Sin datos\"}");
                return;
            }

            try {
                UsuarioDao usuarioDao = new UsuarioDao();
                org.json.JSONObject obj = new org.json.JSONObject(cambiosJson);

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

        System.out.println("=== PETICIÓN POST RECIBIDA ===");

        accion = request.getParameter("accion");
        System.out.println("Acción: " + accion);

        String idUsuarioStr = request.getParameter("idUsuario");
        String nuevoEstadoStr = request.getParameter("nuevoEstado");
        System.out.println("idUsuario: " + idUsuarioStr);
        System.out.println("nuevoEstado: " + nuevoEstadoStr);
        System.out.println("idUsuario: " + request.getParameter("idUsuario"));
        System.out.println("nuevoEstado: " + request.getParameter("nuevoEstado"));

    }


}