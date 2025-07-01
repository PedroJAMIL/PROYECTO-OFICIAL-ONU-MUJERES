package com.example.webproyecto.servlets;

import com.example.webproyecto.daos.CredencialDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/testPassword")
public class TestPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html><head><title>Test de Contraseñas</title></head>");
        out.println("<body style='font-family: Arial; padding: 20px;'>");
        out.println("<h1>Test de Contraseñas - Sistema ONU Mujeres</h1>");
        
        CredencialDao credencialDao = new CredencialDao();
        
        try {
            // Mostrar estado actual
            out.println("<h2>Estado Actual:</h2>");
            credencialDao.mostrarContrasenas();
            
            // Arreglar contraseña
            out.println("<h2>Arreglando Contraseña:</h2>");
            boolean resultado = credencialDao.arreglarContrasenaMiCuenta();
            out.println("<p>Resultado actualización: " + (resultado ? "✅ ÉXITO" : "❌ ERROR") + "</p>");
            
            // Mostrar estado después de arreglar
            out.println("<h2>Estado Después del Arreglo:</h2>");
            credencialDao.mostrarContrasenas();
            
            // Test de login
            out.println("<h2>Test de Login:</h2>");
            var usuario = credencialDao.validarLogin("ccccllmc@gmail.com", "Futbol2025!");
            out.println("<p>Login con 'Futbol2025!': " + (usuario != null ? "✅ ÉXITO" : "❌ FALLO") + "</p>");
            
            // Test de actualización manual
            out.println("<h2>Test de Actualización Manual:</h2>");
            boolean actualizacion = credencialDao.actualizarContrasenha("ccccllmc@gmail.com", "NuevaPassword123!");
            out.println("<p>Actualización a 'NuevaPassword123!': " + (actualizacion ? "✅ ÉXITO" : "❌ ERROR") + "</p>");
            
            // Verificar nueva contraseña
            var usuario2 = credencialDao.validarLogin("ccccllmc@gmail.com", "NuevaPassword123!");
            out.println("<p>Login con 'NuevaPassword123!': " + (usuario2 != null ? "✅ ÉXITO" : "❌ FALLO") + "</p>");
            
            // Restaurar contraseña original
            out.println("<h2>Restaurando Contraseña Original:</h2>");
            boolean restauracion = credencialDao.actualizarContrasenha("ccccllmc@gmail.com", "Futbol2025!");
            out.println("<p>Restauración a 'Futbol2025!': " + (restauracion ? "✅ ÉXITO" : "❌ ERROR") + "</p>");
            
        } catch (Exception e) {
            out.println("<p style='color: red;'>ERROR: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
        
        out.println("<br><br>");
        out.println("<a href='login.jsp'>← Volver al Login</a>");
        out.println("</body></html>");
        out.close();
    }
}
