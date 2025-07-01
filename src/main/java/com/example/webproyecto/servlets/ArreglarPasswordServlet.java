package com.example.webproyecto.servlets;

import com.example.webproyecto.daos.CredencialDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/arreglarPassword")
public class ArreglarPasswordServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            CredencialDao credencialDao = new CredencialDao();
            boolean exito = credencialDao.arreglarContrasenaMiCuenta();
            
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Arreglar Contraseña</title>");
            out.println("</head>");
            out.println("<body>");
            
            if (exito) {
                out.println("<h2 style='color: green;'>✅ Contraseña arreglada exitosamente!</h2>");
                out.println("<p>Ahora puedes hacer login con:</p>");
                out.println("<ul>");
                out.println("<li><strong>Correo:</strong> ccccllmc@gmail.com</li>");
                out.println("<li><strong>Contraseña:</strong> Futbol2025!</li>");
                out.println("</ul>");
                out.println("<a href='login.jsp'>Ir al Login</a>");
            } else {
                out.println("<h2 style='color: red;'>❌ Error al arreglar la contraseña</h2>");
                out.println("<p>Revisa los logs del servidor para más detalles.</p>");
            }
            
            out.println("</body>");
            out.println("</html>");
            
        } catch (Exception e) {
            out.println("<h2 style='color: red;'>Error: " + e.getMessage() + "</h2>");
            e.printStackTrace();
        }
    }
}
