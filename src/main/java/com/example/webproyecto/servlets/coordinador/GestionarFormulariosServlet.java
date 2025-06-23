package com.example.webproyecto.servlets.coordinador;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import com.example.webproyecto.daos.FormularioDao; // Importa tu FormularioDao
import com.example.webproyecto.beans.Formulario;   // Importa tu bean Formulario
import java.util.List;
import java.io.IOException;

@WebServlet(name = "GestionarFormulariosServlet", value = "/GestionarFormulariosServlet")
public class GestionarFormulariosServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("idUsuario") == null ||
                (int) session.getAttribute("idrol") != 2) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            // NUEVO: Obtener todos los formularios
            FormularioDao formularioDao = new FormularioDao();
            List<Formulario> listaFormularios = formularioDao.obtenerTodosLosFormularios();
            request.setAttribute("listaFormularios", listaFormularios); // Pasa la lista al JSP
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("listaFormularios", null);
        }

        request.setAttribute("nombre", session.getAttribute("nombre"));
        request.setAttribute("idUsuario", session.getAttribute("idUsuario"));
        request.setAttribute("idrol", session.getAttribute("idrol"));

        request.getRequestDispatcher("coordinador/jsp/GestionarFormularios.jsp").forward(request, response);
    }
}