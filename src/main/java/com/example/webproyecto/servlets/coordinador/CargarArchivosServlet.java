package com.example.webproyecto.servlets.coordinador;

// Importaciones existentes
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.io.InputStream; // Para leer el archivo subido
import java.nio.file.Files; // Para escribir el archivo en el sistema de ficheros
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption; // Para copiar el InputStream a un archivo

// Nuevas importaciones para el manejo del archivo cargado y el DAO
import com.example.webproyecto.beans.ArchivoCargado; // Tu bean de archivo cargado
import com.example.webproyecto.daos.ArchivoCargadoDao; // Tu DAO de archivo cargado
import java.time.LocalDateTime; // Para la fecha de carga
import java.util.List; // Para listar los archivos cargados

@WebServlet(name = "CargarArchivosServlet", value = "/CargarArchivosServlet")
@MultipartConfig( // ¡Importante para manejar la subida de archivos!
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class CargarArchivosServlet extends HttpServlet {

    // Instancia del DAO para interactuar con la base de datos
    private ArchivoCargadoDao archivoCargadoDao = new ArchivoCargadoDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("idUsuario") == null ||
                (int) session.getAttribute("idrol") != 2) { // Asumiendo rol 2 para coordinador
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // --- Lógica para mostrar archivos ya cargados (historial) ---
        // Obtener el historial de archivos cargados por este coordinador
        int idCoordinador = (int) session.getAttribute("idUsuario");
        List<ArchivoCargado> historialArchivos = archivoCargadoDao.obtenerArchivosCargados(idCoordinador);
        request.setAttribute("historialArchivos", historialArchivos);


        request.setAttribute("nombre", session.getAttribute("nombre"));
        request.setAttribute("idUsuario", session.getAttribute("idUsuario"));
        request.setAttribute("idrol", session.getAttribute("idrol"));

        // Redirige a la página JSP para mostrar el formulario y el historial
        request.getRequestDispatcher("coordinador/jsp/CargarArchivos.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("idUsuario") == null ||
                (int) session.getAttribute("idrol") != 2) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int idUsuarioQueCargo = (int) session.getAttribute("idUsuario");

        // --- Procesamiento de la subida del archivo ---
        try {
            Part filePart = request.getPart("archivo"); // "archivo" es el 'name' del input file en tu formulario HTML
            String nombreArchivoOriginal = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            // Evitar problemas con nombres de archivo que contengan barras o caracteres especiales
            nombreArchivoOriginal = nombreArchivoOriginal.replaceAll("[^a-zA-Z0-9.\\-_]", "_");

            String uploadDir = getServletContext().getRealPath("/uploads"); // Ruta donde se guardarán los archivos
            // Asegurarse de que el directorio de subida exista
            Path uploadPath = Paths.get(uploadDir);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            // Generar un nombre único para el archivo para evitar sobrescribir y tener nombres válidos
            String nombreArchivoGuardado = System.currentTimeMillis() + "_" + nombreArchivoOriginal;
            Path filePath = Paths.get(uploadDir, nombreArchivoGuardado);

            // Guardar el archivo en el sistema de ficheros del servidor
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
            }

            // --- Guardar la información del archivo en la base de datos ---
            ArchivoCargado archivoCargado = new ArchivoCargado();
            archivoCargado.setNombreArchivoOriginal(nombreArchivoOriginal);
            archivoCargado.setRutaGuardado("uploads/" + nombreArchivoGuardado); // Ruta relativa para guardar
            archivoCargado.setFechaCarga(LocalDateTime.now()); // Fecha y hora actual
            archivoCargado.setIdUsuarioQueCargo(idUsuarioQueCargo);
            archivoCargado.setEstadoProcesamiento("PENDIENTE"); // Estado inicial
            archivoCargado.setMensajeProcesamiento(null); // Sin mensaje inicial
            archivoCargado.setIdFormularioAsociado(null); // Por ahora, no asociado a un formulario específico

            boolean guardadoExitoso = archivoCargadoDao.guardarArchivoCargado(archivoCargado);

            if (guardadoExitoso) {
                request.getSession().setAttribute("mensajeExito", "Archivo '" + nombreArchivoOriginal + "' cargado y registrado con éxito.");
            } else {
                request.getSession().setAttribute("mensajeError", "Error al registrar el archivo en la base de datos.");
            }

        } catch (IOException | ServletException e) {
            System.err.println("Error al cargar el archivo: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("mensajeError", "Error al cargar el archivo: " + e.getMessage());
        }

        // Redirigir de vuelta al doGet para que se muestre el historial actualizado y los mensajes
        response.sendRedirect(request.getContextPath() + "/CargarArchivosServlet");
    }
}