package com.example.webproyecto.servlets.administrador;
import com.example.webproyecto.dtos.CoordinadorDTO;
import com.example.webproyecto.daos.UsuarioDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "GestionarEncuestadoresServlet", value = "/GestionarEncuestadoresServlet")
public class GestionarEncuestadoresServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Solo permite acceso a coordinadores (rolId == 2)
        if (session == null || session.getAttribute("idUsuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        Object idrolObj = session.getAttribute("idrol");
        int idrol = (idrolObj instanceof Integer) ? (Integer) idrolObj : (idrolObj != null ? Integer.parseInt(idrolObj.toString()) : -1);
        if (idrol != 1) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        UsuarioDao usuarioDao = new UsuarioDao();
        List<CoordinadorDTO> encuestadores = usuarioDao.listarEncuestadoresConCorreo();
        request.setAttribute("encuestadores", encuestadores);

        request.getRequestDispatcher("admin/gestionarEncuestadores.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}