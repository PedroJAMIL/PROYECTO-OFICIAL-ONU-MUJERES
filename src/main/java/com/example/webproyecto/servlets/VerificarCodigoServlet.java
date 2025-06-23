package com.example.webproyecto.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import com.example.webproyecto.daos.CodigoDao;

@WebServlet("/verificarCodigo")
public class VerificarCodigoServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String codigoIngresado = request.getParameter("codigo");
        CodigoDao codigoDao = new CodigoDao();

        if (codigoDao.findCodigo(codigoIngresado)) {
            int usuarioId = codigoDao.getUsuarioIdByCodigo(codigoIngresado);
            if (usuarioId != -1) {
                codigoDao.marcarUsuarioComoVerificado(usuarioId);
            }
            codigoDao.deleteCodigo(codigoIngresado);
            response.sendRedirect("verificacionExitosa.jsp");
        } else {
            response.sendRedirect("verificacionFallida.jsp");
        }
    }
}