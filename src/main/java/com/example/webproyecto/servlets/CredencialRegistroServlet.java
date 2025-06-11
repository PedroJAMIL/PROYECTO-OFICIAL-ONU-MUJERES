package com.example.webproyecto.servlets;

import com.example.webproyecto.beans.Usuario;
import com.example.webproyecto.daos.CredencialDao;
import com.example.webproyecto.daos.DistritoDao;
import com.example.webproyecto.daos.UsuarioDao;
import com.example.webproyecto.daos.CodigoDao;
import com.example.webproyecto.utils.MailSender;
import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet(name = "CredencialRegistroServlet", urlPatterns = {"/registro"})
public class CredencialRegistroServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DistritoDao distritoDao = new DistritoDao();
        request.setAttribute("distritos", distritoDao.listarDistritos());
        request.getRequestDispatcher("registro.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Recoger parámetros
        String nombre = request.getParameter("nombre");
        String apellidoPaterno = request.getParameter("apellidoPaterno");
        String apellidoMaterno = request.getParameter("apellidoMaterno");
        String dni = request.getParameter("dni");
        String direccion = request.getParameter("direccion");
        int idDistrito = Integer.parseInt(request.getParameter("distrito"));
        String correo = request.getParameter("correo");

        // Crear objeto usuario
        Usuario usuario = new Usuario();
        usuario.setNombre(nombre);
        usuario.setApellidopaterno(apellidoPaterno);
        usuario.setApellidomaterno(apellidoMaterno);
        usuario.setDni(dni);
        usuario.setDireccion(direccion);
        usuario.setIdDistrito(idDistrito);
        usuario.setIdRol(3); // Rol por defecto
        usuario.setIdEstado(2); // Estado pendiente de verificación

        UsuarioDao usuarioDao = new UsuarioDao();
        CredencialDao credencialDao = new CredencialDao();

        try {
            // Verificar si el correo ya existe
            if (credencialDao.existeCorreo(correo)) {
                request.setAttribute("error", "El correo ya está registrado");
                doGet(request, response);
                return;
            }

            // Verificar si el DNI ya existe
            if (usuarioDao.existeDni(dni)) {
                request.setAttribute("error", "El DNI ya está registrado");
                doGet(request, response);
                return;
            }

            // Insertar usuario
            if (usuarioDao.insertarUsuario(usuario)) {
                // Generar y guardar código de verificación
                CodigoDao codigoDao = new CodigoDao();
                String codigo = codigoDao.generateCodigo(correo);

                // Enviar correo de verificación
                String subject = "Verifica tu cuenta";
                String body = "Tu código de verificación es: " + codigo +
                        "\nO haz clic en el siguiente enlace para establecer tu contraseña:\n" +
                        "http://localhost:8080/PROYECTO-OFICIAL-ONU-MUJERES/establecerContrasena.jsp?codigo=" + codigo;
                MailSender.sendEmail(correo, subject, body);

                // Redirigir a página de aviso
                response.sendRedirect("verificaTuCorreo.jsp");
                return;
            }

            request.setAttribute("error", "Error en el registro. Intente nuevamente.");
            doGet(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error en el servidor: " + e.getMessage());
            doGet(request, response);
        }
    }
}