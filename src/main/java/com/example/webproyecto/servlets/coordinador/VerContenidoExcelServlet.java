package com.example.webproyecto.servlets.coordinador;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import com.example.webproyecto.daos.ArchivoCargadoDao;
import com.example.webproyecto.beans.ArchivoCargado;
import com.example.webproyecto.beans.CeldaExcel;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.ss.util.CellRangeAddress;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;

@WebServlet(name = "VerContenidoExcelServlet", value = "/VerContenidoExcelServlet")
public class VerContenidoExcelServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("idUsuario") == null ||
                (int) session.getAttribute("idrol") != 2) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String idArchivoStr = request.getParameter("idArchivoCargado");
        if (idArchivoStr == null) {
            request.setAttribute("mensajeError", "No se especificó el archivo.");
            request.getRequestDispatcher("/coordinador/jsp/VerContenidoExcel.jsp").forward(request, response);
            return;
        }

        int idArchivo;
        try {
            idArchivo = Integer.parseInt(idArchivoStr);
        } catch (NumberFormatException e) {
            request.setAttribute("mensajeError", "ID de archivo inválido.");
            request.getRequestDispatcher("/coordinador/jsp/VerContenidoExcel.jsp").forward(request, response);
            return;
        }

        ArchivoCargadoDao archivoCargadoDao = new ArchivoCargadoDao();
        ArchivoCargado archivo = archivoCargadoDao.obtenerArchivoPorId(idArchivo);

        if (archivo == null) {
            request.setAttribute("mensajeError", "Archivo no encontrado.");
            request.getRequestDispatcher("/coordinador/jsp/VerContenidoExcel.jsp").forward(request, response);
            return;
        }

        String rutaArchivo = archivo.getRutaGuardado();
        if (!Paths.get(rutaArchivo).isAbsolute()) {
            rutaArchivo = getServletContext().getRealPath("/") + rutaArchivo;
        }
        List<List<CeldaExcel>> filasExcel = new ArrayList<>();

        // Leer el archivo Excel (.xlsx)
        try (InputStream is = Files.newInputStream(Paths.get(rutaArchivo));
             Workbook workbook = new XSSFWorkbook(is)) {
            Sheet sheet = workbook.getSheetAt(0);
            List<CellRangeAddress> mergedRegions = sheet.getMergedRegions();
            Set<String> celdasSaltadas = new HashSet<>();

            for (int rowNum = 0; rowNum <= sheet.getLastRowNum(); rowNum++) {
                Row row = sheet.getRow(rowNum);
                if (row == null) continue;
                List<CeldaExcel> fila = new ArrayList<>();
                for (int colNum = 0; colNum < row.getLastCellNum(); colNum++) {
                    // Saltar celdas que ya están cubiertas por un merge
                    String key = rowNum + "-" + colNum;
                    if (celdasSaltadas.contains(key)) continue;

                    Cell cell = row.getCell(colNum);
                    String valor = (cell != null) ? cell.toString() : "";

                    int rowspan = 1, colspan = 1;
                    boolean esPrincipal = true;
                    for (CellRangeAddress region : mergedRegions) {
                        if (region.isInRange(rowNum, colNum)) {
                            if (region.getFirstRow() == rowNum && region.getFirstColumn() == colNum) {
                                rowspan = region.getLastRow() - region.getFirstRow() + 1;
                                colspan = region.getLastColumn() - region.getFirstColumn() + 1;
                                // Marcar celdas cubiertas por este merge para no mostrarlas de nuevo
                                for (int r = region.getFirstRow(); r <= region.getLastRow(); r++) {
                                    for (int c = region.getFirstColumn(); c <= region.getLastColumn(); c++) {
                                        if (!(r == rowNum && c == colNum)) {
                                            celdasSaltadas.add(r + "-" + c);
                                        }
                                    }
                                }
                            } else {
                                esPrincipal = false;
                            }
                        }
                    }
                    if (esPrincipal) {
                        fila.add(new CeldaExcel(valor, rowspan, colspan));
                    }
                }
                filasExcel.add(fila);
            }
        } catch (Exception e) {
            e.printStackTrace(); // Esto imprime el error en la consola del servidor
            request.setAttribute("mensajeError", "No se pudo leer el archivo Excel: " + e.getMessage());
            request.getRequestDispatcher("/coordinador/jsp/VerContenidoExcel.jsp").forward(request, response);
            return;
        }

        request.setAttribute("nombreArchivo", archivo.getNombreArchivoOriginal());
        request.setAttribute("filasExcel", filasExcel);
        request.getRequestDispatcher("/coordinador/jsp/VerContenidoExcel.jsp").forward(request, response);
    }
}