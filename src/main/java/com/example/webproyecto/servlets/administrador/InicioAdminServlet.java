package com.example.webproyecto.servlets.administrador;

import com.example.webproyecto.daos.UsuarioDao;
import com.example.webproyecto.daos.encuestador.SesionRespuestaDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "InicioAdminServlet", value = "/InicioAdminServlet")
public class InicioAdminServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Solo permite acceso a usuarios con rol de administrador (por ejemplo, rolId == 1)
        if (session == null || session.getAttribute("idUsuario") == null || session.getAttribute("idrol") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        int idrol = (session.getAttribute("idrol") instanceof Integer)
                ? (Integer) session.getAttribute("idrol")
                : Integer.parseInt(session.getAttribute("idrol").toString());
        if (idrol != 1) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }        // Obtener datos dinámicos para el dashboard
        UsuarioDao usuarioDao = new UsuarioDao();
        int encuestadoresActivos = usuarioDao.contarEncuestadoresActivos();
        int encuestadoresDesactivos = usuarioDao.contarEncuestadoresDesactivos();
        int coordinadoresActivos = usuarioDao.contarCoordinadoresActivos();
        int coordinadoresDesactivos = usuarioDao.contarCoordinadoresDesactivos();
        
        // Obtener datos para el gráfico de líneas
        SesionRespuestaDao sesionRespuestaDao = new SesionRespuestaDao();
        List<Map<String, Object>> datosGraficoLineas = sesionRespuestaDao.obtenerFormulariosCompletadosPorZonaYMes();
        
        request.setAttribute("encuestadoresActivos", encuestadoresActivos);
        request.setAttribute("encuestadoresDesactivos", encuestadoresDesactivos);
        request.setAttribute("coordinadoresActivos", coordinadoresActivos);
        request.setAttribute("coordinadoresDesactivos", coordinadoresDesactivos);
        request.setAttribute("datosGraficoLineas", datosGraficoLineas);

        request.setAttribute("nombre", session.getAttribute("nombre"));
        request.setAttribute("idUsuario", session.getAttribute("idUsuario"));
        request.setAttribute("idrol", session.getAttribute("idrol"));

        request.getRequestDispatcher("admin/dashboardAdmin.jsp").forward(request, response);
    }
}