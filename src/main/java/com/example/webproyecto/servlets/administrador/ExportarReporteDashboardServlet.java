// filepath: c:\Users\FABRICIO\Documents\6to_ciclo\iweb\proyecto_actualizado_25_06_25\PROYECTO-OFICIAL-ONU-MUJERES\PROYECTO-OFICIAL-ONU-MUJERES\src\main\java\com\example\webproyecto\servlets\administrador\ExportarReporteDashboardServlet.java
package com.example.webproyecto.servlets.administrador;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.IOException;
import java.lang.reflect.Type;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Map;

@WebServlet(name = "ExportarReporteDashboardServlet", value = "/ExportarReporteDashboardServlet")
public class ExportarReporteDashboardServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Log para debug
        System.out.println("=== INICIANDO EXPORTAR REPORTE ===");
        
        // Verificar sesión
        Object idRol = request.getSession().getAttribute("idrol");
        System.out.println("ID Rol de sesión: " + idRol);
        
        if (idRol == null || !idRol.toString().equals("1")) {
            System.out.println("Usuario no autorizado");
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "No autorizado");
            return;
        }
        
        try {
            // Obtener parámetros con logs
            String encActivosStr = request.getParameter("encuestadoresActivos");
            String encInactivosStr = request.getParameter("encuestadoresInactivos");
            String coordActivosStr = request.getParameter("coordinadoresActivos");
            String coordInactivosStr = request.getParameter("coordinadoresInactivos");
            String datosJson = request.getParameter("datosGraficoFormularios");
            
            System.out.println("Parámetros recibidos:");
            System.out.println("- Enc Activos: " + encActivosStr);
            System.out.println("- Enc Inactivos: " + encInactivosStr);
            System.out.println("- Coord Activos: " + coordActivosStr);
            System.out.println("- Coord Inactivos: " + coordInactivosStr);
            System.out.println("- Datos JSON: " + (datosJson != null ? datosJson.substring(0, Math.min(100, datosJson.length())) + "..." : "null"));
            
            // Validar parámetros
            if (encActivosStr == null || encInactivosStr == null || 
                coordActivosStr == null || coordInactivosStr == null) {
                System.out.println("ERROR: Parámetros faltantes");
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parámetros faltantes");
                return;
            }
            
            // Convertir a números
            int encActivos = Integer.parseInt(encActivosStr);
            int encInactivos = Integer.parseInt(encInactivosStr);
            int coordActivos = Integer.parseInt(coordActivosStr);
            int coordInactivos = Integer.parseInt(coordInactivosStr);
            
            System.out.println("Números convertidos correctamente");
            
            // Parsear JSON (puede ser null o vacío)
            Map<String, int[]> datosGrafico = null;
            if (datosJson != null && !datosJson.trim().isEmpty() && !datosJson.equals("{}")) {
                try {
                    Gson gson = new Gson();
                    Type type = new TypeToken<Map<String, int[]>>(){}.getType();
                    datosGrafico = gson.fromJson(datosJson, type);
                    System.out.println("JSON parseado correctamente: " + datosGrafico.size() + " zonas");
                } catch (Exception e) {
                    System.out.println("Error al parsear JSON, continuando sin datos de gráfico: " + e.getMessage());
                }
            }
            
            // Generar Excel
            System.out.println("Iniciando generación de Excel...");
            generarYDescargarExcel(response, encActivos, encInactivos, coordActivos, coordInactivos, datosGrafico);
            System.out.println("Excel generado exitosamente");
            
        } catch (NumberFormatException e) {
            System.out.println("ERROR: Error de formato de número: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Error en formato de números");
        } catch (Exception e) {
            System.out.println("ERROR: Error general: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error interno del servidor");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
    
    private void generarYDescargarExcel(HttpServletResponse response, int encActivos, int encInactivos,
                                       int coordActivos, int coordInactivos, Map<String, int[]> datosGrafico) 
            throws IOException {
        
        System.out.println("Creando workbook...");
        XSSFWorkbook workbook = new XSSFWorkbook();
        
        try {
            // Crear estilos básicos
            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerStyle.setFont(headerFont);
            headerStyle.setAlignment(HorizontalAlignment.CENTER);
            
            CellStyle dataStyle = workbook.createCellStyle();
            dataStyle.setAlignment(HorizontalAlignment.CENTER);
            
            // Crear hoja de resumen
            System.out.println("Creando hoja de resumen...");
            Sheet resumenSheet = workbook.createSheet("Resumen Dashboard");
            crearHojaResumen(resumenSheet, encActivos, encInactivos, coordActivos, coordInactivos, headerStyle, dataStyle);
            
            // Crear hoja de formularios si hay datos
            if (datosGrafico != null && !datosGrafico.isEmpty()) {
                System.out.println("Creando hoja de formularios...");
                Sheet formulariosSheet = workbook.createSheet("Formularios por Zona");
                crearHojaFormularios(formulariosSheet, datosGrafico, headerStyle, dataStyle);
            } else {
                System.out.println("No hay datos de formularios, omitiendo hoja...");
            }
            
            // Configurar respuesta
            String fileName = "Reporte_Dashboard_" + 
                LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss")) + ".xlsx";
            
            System.out.println("Configurando respuesta HTTP para archivo: " + fileName);
            
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
            response.setHeader("Cache-Control", "no-cache");
            response.setHeader("Pragma", "no-cache");
            
            // Escribir al output stream
            System.out.println("Escribiendo archivo...");
            workbook.write(response.getOutputStream());
            response.getOutputStream().flush();
            System.out.println("Archivo escrito exitosamente");
            
        } finally {
            workbook.close();
            System.out.println("Workbook cerrado");
        }
    }
    
    private void crearHojaResumen(Sheet sheet, int encActivos, int encInactivos, 
                                 int coordActivos, int coordInactivos, 
                                 CellStyle headerStyle, CellStyle dataStyle) {
        
        int rowNum = 0;
        
        // Título
        Row titleRow = sheet.createRow(rowNum++);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("REPORTE DASHBOARD ADMINISTRADOR");
        titleCell.setCellStyle(headerStyle);
        
        // Fecha
        Row fechaRow = sheet.createRow(rowNum++);
        fechaRow.createCell(0).setCellValue("Fecha de generación: " + 
            LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")));
        
        rowNum++; // Línea en blanco
        
        // Encuestadores
        Row encTitleRow = sheet.createRow(rowNum++);
        encTitleRow.createCell(0).setCellValue("=== ENCUESTADORES ===");
        encTitleRow.getCell(0).setCellStyle(headerStyle);
        
        Row encHeaderRow = sheet.createRow(rowNum++);
        encHeaderRow.createCell(0).setCellValue("Estado");
        encHeaderRow.createCell(1).setCellValue("Cantidad");
        encHeaderRow.getCell(0).setCellStyle(headerStyle);
        encHeaderRow.getCell(1).setCellStyle(headerStyle);
        
        Row encActivosRow = sheet.createRow(rowNum++);
        encActivosRow.createCell(0).setCellValue("Activos");
        encActivosRow.createCell(1).setCellValue(encActivos);
        encActivosRow.getCell(0).setCellStyle(dataStyle);
        encActivosRow.getCell(1).setCellStyle(dataStyle);
        
        Row encInactivosRow = sheet.createRow(rowNum++);
        encInactivosRow.createCell(0).setCellValue("Inactivos");
        encInactivosRow.createCell(1).setCellValue(encInactivos);
        encInactivosRow.getCell(0).setCellStyle(dataStyle);
        encInactivosRow.getCell(1).setCellStyle(dataStyle);
        
        Row encTotalRow = sheet.createRow(rowNum++);
        encTotalRow.createCell(0).setCellValue("TOTAL ENCUESTADORES");
        encTotalRow.createCell(1).setCellValue(encActivos + encInactivos);
        encTotalRow.getCell(0).setCellStyle(headerStyle);
        encTotalRow.getCell(1).setCellStyle(headerStyle);
        
        rowNum++; // Línea en blanco
        
        // Coordinadores
        Row coordTitleRow = sheet.createRow(rowNum++);
        coordTitleRow.createCell(0).setCellValue("=== COORDINADORES ===");
        coordTitleRow.getCell(0).setCellStyle(headerStyle);
        
        Row coordHeaderRow = sheet.createRow(rowNum++);
        coordHeaderRow.createCell(0).setCellValue("Estado");
        coordHeaderRow.createCell(1).setCellValue("Cantidad");
        coordHeaderRow.getCell(0).setCellStyle(headerStyle);
        coordHeaderRow.getCell(1).setCellStyle(headerStyle);
        
        Row coordActivosRow = sheet.createRow(rowNum++);
        coordActivosRow.createCell(0).setCellValue("Activos");
        coordActivosRow.createCell(1).setCellValue(coordActivos);
        coordActivosRow.getCell(0).setCellStyle(dataStyle);
        coordActivosRow.getCell(1).setCellStyle(dataStyle);
        
        Row coordInactivosRow = sheet.createRow(rowNum++);
        coordInactivosRow.createCell(0).setCellValue("Inactivos");
        coordInactivosRow.createCell(1).setCellValue(coordInactivos);
        coordInactivosRow.getCell(0).setCellStyle(dataStyle);
        coordInactivosRow.getCell(1).setCellStyle(dataStyle);
        
        Row coordTotalRow = sheet.createRow(rowNum++);
        coordTotalRow.createCell(0).setCellValue("TOTAL COORDINADORES");
        coordTotalRow.createCell(1).setCellValue(coordActivos + coordInactivos);
        coordTotalRow.getCell(0).setCellStyle(headerStyle);
        coordTotalRow.getCell(1).setCellStyle(headerStyle);
        
        // Ajustar columnas
        sheet.autoSizeColumn(0);
        sheet.autoSizeColumn(1);
    }
    
    private void crearHojaFormularios(Sheet sheet, Map<String, int[]> datosGrafico, 
                                     CellStyle headerStyle, CellStyle dataStyle) {
        
        String[] meses = {"Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", 
                         "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"};
        
        // Título
        Row titleRow = sheet.createRow(0);
        titleRow.createCell(0).setCellValue("FORMULARIOS POR ZONA GEOGRÁFICA");
        titleRow.getCell(0).setCellStyle(headerStyle);
        
        // Encabezados
        Row headerRow = sheet.createRow(2);
        headerRow.createCell(0).setCellValue("Zona Geográfica");
        headerRow.getCell(0).setCellStyle(headerStyle);
        
        for (int i = 0; i < meses.length; i++) {
            headerRow.createCell(i + 1).setCellValue(meses[i]);
            headerRow.getCell(i + 1).setCellStyle(headerStyle);
        }
        headerRow.createCell(13).setCellValue("Total Año");
        headerRow.getCell(13).setCellStyle(headerStyle);
        
        // Datos por zona
        int rowNum = 3;
        int[] totalesPorMes = new int[12];
        
        for (Map.Entry<String, int[]> entry : datosGrafico.entrySet()) {
            Row dataRow = sheet.createRow(rowNum++);
            dataRow.createCell(0).setCellValue(entry.getKey());
            dataRow.getCell(0).setCellStyle(dataStyle);
            
            int[] datos = entry.getValue();
            int totalZona = 0;
            
            for (int i = 0; i < 12; i++) {
                int valor = (i < datos.length) ? datos[i] : 0;
                dataRow.createCell(i + 1).setCellValue(valor);
                dataRow.getCell(i + 1).setCellStyle(dataStyle);
                totalZona += valor;
                totalesPorMes[i] += valor;
            }
            
            dataRow.createCell(13).setCellValue(totalZona);
            dataRow.getCell(13).setCellStyle(headerStyle);
        }
        
        // Fila de totales
        Row totalRow = sheet.createRow(rowNum);
        totalRow.createCell(0).setCellValue("=== TOTALES ===");
        totalRow.getCell(0).setCellStyle(headerStyle);
        
        int granTotal = 0;
        for (int i = 0; i < 12; i++) {
            totalRow.createCell(i + 1).setCellValue(totalesPorMes[i]);
            totalRow.getCell(i + 1).setCellStyle(headerStyle);
            granTotal += totalesPorMes[i];
        }
        
        totalRow.createCell(13).setCellValue(granTotal);
        totalRow.getCell(13).setCellStyle(headerStyle);
        
        // Ajustar columnas
        for (int i = 0; i < 14; i++) {
            sheet.autoSizeColumn(i);
        }
    }
}