package com.example.webproyecto.servlets.coordinador;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import com.example.webproyecto.daos.ArchivoCargadoDao; // ¡Asegúrate de que esta ruta sea correcta!
import com.example.webproyecto.beans.ArchivoCargado; // ¡Asegúrate de que esta ruta sea correcta!
// import com.example.webproyecto.daos.encuestador.FormularioDao; // Comenta o elimina esta línea si ya no la usas aquí
// import com.example.webproyecto.beans.Formulario; // Comenta o elimina esta línea si ya no la usas aquí
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
            // Utiliza tu ArchivoCargadoDao
            ArchivoCargadoDao archivoCargadoDao = new ArchivoCargadoDao();
            // Llama al método que obtiene todos los archivos (el que ya tienes en tu DAO)
            List<ArchivoCargado> archivosCargados = archivoCargadoDao.obtenerTodosLosArchivosCargados();
            request.setAttribute("archivosCargados", archivosCargados); // Pasa la lista al JSP
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("archivosCargados", null);
        }

        request.setAttribute("nombre", session.getAttribute("nombre"));
        request.setAttribute("idUsuario", session.getAttribute("idUsuario"));
        request.setAttribute("idrol", session.getAttribute("idrol"));

        request.getRequestDispatcher("coordinador/jsp/GestionarFormularios.jsp").forward(request, response);
    }
}