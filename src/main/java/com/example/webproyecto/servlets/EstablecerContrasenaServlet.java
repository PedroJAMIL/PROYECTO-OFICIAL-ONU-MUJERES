package com.example.webproyecto.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import com.example.webproyecto.daos.CodigoDao;
import com.example.webproyecto.utils.PasswordUtil;

@WebServlet("/establecerContrasena")
public class EstablecerContrasenaServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String codigo = request.getParameter("codigo");
        String contrasena = request.getParameter("contrasena");
        String confirmarContrasena = request.getParameter("confirmarContrasena");

        if (contrasena == null || !contrasena.equals(confirmarContrasena)) {
            request.setAttribute("error", "Las contraseñas no coinciden.");
            request.getRequestDispatcher("establecerContrasena.jsp?codigo=" + codigo).forward(request, response);
            return;
        }

        if (!PasswordUtil.validarPassword(contrasena)) {
            request.setAttribute("error", "La contraseña debe tener al menos 8 caracteres, una mayúscula, una minúscula y un número.");
            request.getRequestDispatcher("establecerContrasena.jsp?codigo=" + codigo).forward(request, response);
            return;
        }

        CodigoDao codigoDao = new CodigoDao();
        int usuarioId = codigoDao.getUsuarioIdByCodigo(codigo);

        if (usuarioId == -1) {
            request.setAttribute("error", "Código inválido o expirado.");
            request.getRequestDispatcher("establecerContrasena.jsp").forward(request, response);
            return;
        }

        // Aquí deberías hashear la contraseña antes de guardarla
        codigoDao.actualizarContrasena(usuarioId, contrasena);
        codigoDao.deleteCodigo(codigo);
        codigoDao.marcarUsuarioComoVerificado(usuarioId);

        response.sendRedirect("verificacionExitosa.jsp");
    }
}