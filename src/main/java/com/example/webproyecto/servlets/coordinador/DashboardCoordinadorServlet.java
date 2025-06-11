package com.example.webproyecto.servlets.coordinador;

import com.example.webproyecto.beans.Usuario;
import com.example.webproyecto.daos.encuestador.SesionRespuestaDao;
import com.example.webproyecto.dtos.EstadoFormularioDTO;
import com.example.webproyecto.dtos.ResumenEncuestadorDTO;
import com.example.webproyecto.dtos.ResumenZonaDTO;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "DashboardCoordinadorServlet", value = "/DashboardCoordinadorServlet")
public class DashboardCoordinadorServlet extends HttpServlet {
    private SesionRespuestaDao sesionRespuestaDao;

    @Override
    public void init() throws ServletException {
        sesionRespuestaDao = new SesionRespuestaDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Usuario coordinador = (Usuario) session.getAttribute("usuario");

        if (coordinador == null || coordinador.getIdZonaTrabajo() == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "No autorizado o sin zona asignada.");
            return;
        }

        int idZonaTrabajo = coordinador.getIdZonaTrabajo();

        // Obtener los datos filtrados por zona
        List<ResumenEncuestadorDTO> listaResumenEncuestador = sesionRespuestaDao.obtenerResumenPorEncuestador(idZonaTrabajo);
        List<ResumenZonaDTO> listaResumenZona = sesionRespuestaDao.obtenerResumenPorZona(idZonaTrabajo);
        EstadoFormularioDTO estadoFormularioDTO = sesionRespuestaDao.obtenerResumenEstadoFormularios(idZonaTrabajo);

        // Enviar al JSP como atributos de request
        request.setAttribute("resumenEncuestadores", listaResumenEncuestador);
        request.setAttribute("resumenZonas", listaResumenZona);
        request.setAttribute("estadoFormularios", estadoFormularioDTO);

        // Redirigir al JSP de dashboard
        request.getRequestDispatcher("/coordinador/jsp/VerDashboard.jsp").forward(request, response);
    }
}
