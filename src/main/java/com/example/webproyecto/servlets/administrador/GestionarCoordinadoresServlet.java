package com.example.webproyecto.servlets.administrador;

import com.example.webproyecto.dtos.CoordinadorDTO;
import com.example.webproyecto.daos.UsuarioDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "GestionarCoordinadoresServlet", value = "/GestionarCoordinadoresServlet")
public class GestionarCoordinadoresServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UsuarioDao usuarioDao = new UsuarioDao();
        List<CoordinadorDTO> coordinadores = usuarioDao.listarCoordinadoresConCorreo();
        request.setAttribute("coordinadores", coordinadores);
        request.getRequestDispatcher("admin/gestionarCoordinadores.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}