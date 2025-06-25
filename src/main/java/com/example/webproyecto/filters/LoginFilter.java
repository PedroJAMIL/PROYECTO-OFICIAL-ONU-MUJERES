package com.example.webproyecto.filters;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*") // Se aplica a todo
public class LoginFilter implements Filter {

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        String uri = request.getRequestURI();
        HttpSession session = request.getSession(false);
        boolean loggedIn = session != null && session.getAttribute("idUsuario") != null;

        boolean isLoginPage = uri.contains("login.jsp");
        boolean isLoginServlet = uri.endsWith("LoginServlet");
        boolean isRoot = uri.equals(request.getContextPath() + "/");

        if (loggedIn && (isLoginPage || isLoginServlet || isRoot)) {

            String rol = (String) session.getAttribute("rol");
            switch (rol) {
                case "administrador" -> response.sendRedirect("InicioAdminServlet");
                case "coordinador" -> response.sendRedirect("InicioCoordinadorServlet");
                case "encuestador" -> response.sendRedirect("InicioEncuestadorServlet");
                default -> {
                    session.invalidate();
                    response.sendRedirect("login.jsp?error=rol");
                }
            }
            return;
        }

        // Si no está logueado y trata de entrar a algo privado
        boolean recursoProtegido =
                uri.contains("/Inicio") ||
                        uri.contains("/formularioRespuesta") ||
                        uri.contains("/verPerfil") ||
                        uri.contains("/FormulariosAsignados") ||
                        uri.contains("/historialFormularios");

        if (!loggedIn && recursoProtegido) {
            response.sendRedirect("LoginServlet");
            return;
        }

        // Dejar pasar la petición
        chain.doFilter(request, response);
    }
}
