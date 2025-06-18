package com.example.webproyecto.servlets;

import com.example.webproyecto.beans.Distrito;
import com.example.webproyecto.beans.Usuario;
import com.example.webproyecto.beans.Credencial;
import com.example.webproyecto.daos.CredencialDao;
import com.example.webproyecto.daos.DistritoDao;
import com.example.webproyecto.daos.UsuarioDao;
import com.example.webproyecto.daos.CodigoDao;
import com.example.webproyecto.utils.MailSender;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet(name = "CredencialRegistroServlet", urlPatterns = {"/registro"})
public class CredencialRegistroServlet extends HttpServlet {    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DistritoDao distritoDao = new DistritoDao();
        request.setAttribute("distritos", distritoDao.listarDistritos());
        request.getRequestDispatcher("registro.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Recoger parámetros incluyendo contraseña
        String nombre = request.getParameter("nombre");
        String apellidoPaterno = request.getParameter("apellidoPaterno");
        String apellidoMaterno = request.getParameter("apellidoMaterno");
        String dni = request.getParameter("dni");
        String direccion = request.getParameter("direccion");
        int idDistrito = Integer.parseInt(request.getParameter("distrito"));
        String correo = request.getParameter("correo");
        String contrasenha = request.getParameter("contrasenha");
        String confirmarContrasenha = request.getParameter("confirmarContrasenha");

        // Validar que las contraseñas coincidan
        if (!contrasenha.equals(confirmarContrasenha)) {
            request.setAttribute("error", "Las contraseñas no coinciden");
            doGet(request, response);
            return;
        }

        // Validar longitud mínima de contraseña
        if (contrasenha.length() < 8) {
            request.setAttribute("error", "La contraseña debe tener al menos 8 caracteres");
            doGet(request, response);
            return;
        }        // Crear objetos
        Usuario usuario = new Usuario();
        usuario.setNombre(nombre);
        usuario.setApellidopaterno(apellidoPaterno);
        usuario.setApellidomaterno(apellidoMaterno);
        usuario.setDni(dni);
        usuario.setDireccion(direccion);
        usuario.setIdDistrito(idDistrito);
        usuario.setIdRol(3); // Rol encuestador por defecto
        usuario.setIdEstado(1); // Estado activo directamente        usuario.setFoto(""); // Foto vacía por defecto
        usuario.setNombrefoto(""); // Sin nombre de foto
        usuario.setIdDistritoTrabajo(null); // Sin distrito de trabajo asignado
        usuario.setIdZonaTrabajo(null); // Sin zona de trabajo asignada

        Credencial credencial = new Credencial();
        credencial.setCorreo(correo);
        credencial.setContrasenha(contrasenha); // Contraseña proporcionada        // Registrar en BD
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

            // Registro directo con contraseña
            System.out.println("Intentando insertar usuario: " + usuario.getNombre() + " " + usuario.getApellidopaterno());
            if (usuarioDao.insertarUsuario(usuario)) {
                System.out.println("Usuario insertado correctamente");
                Usuario usuarioRegistrado = usuarioDao.obtenerUsuarioPorDni(dni);
                credencial.setIdUsuario(usuarioRegistrado.getIdUsuario());
                
                System.out.println("Intentando insertar credencial para usuario ID: " + usuarioRegistrado.getIdUsuario());
                if (credencialDao.insertarCredencial(credencial)) {
                    System.out.println("Credencial insertada correctamente");
                    // Redirigir al login con mensaje de éxito
                    response.sendRedirect("login.jsp?registro=exito");
                    return;
                } else {
                    System.err.println("Error al insertar credencial");
                    request.setAttribute("error", "Error al crear las credenciales del usuario");
                    doGet(request, response);
                    return;
                }
            } else {
                System.err.println("Error al insertar usuario");
                request.setAttribute("error", "Error al registrar el usuario en la base de datos");
                doGet(request, response);
                return;
            }

            /* ====== CÓDIGO DE VERIFICACIÓN POR CORREO (COMENTADO) ======
            // MODO DESARROLLO: Desactivar verificación por correo temporalmente
            boolean verificacionDesactivada = true; // Cambiar a false para activar verificación
            
            if (verificacionDesactivada) {
                // Registro directo sin verificación por correo
                usuario.setIdEstado(1); // Estado activo directamente
                
                if (usuarioDao.insertarUsuario(usuario)) {
                    Usuario usuarioRegistrado = usuarioDao.obtenerUsuarioPorDni(dni);
                    credencial.setIdUsuario(usuarioRegistrado.getIdUsuario());
                    credencial.setContrasenha(null); // Sin contraseña inicial pero marcado como verificado
                    
                    if (credencialDao.insertarCredencial(credencial)) {
                        // Redirigir directamente al login con mensaje de éxito
                        response.sendRedirect("login.jsp?registro=exito");
                        return;
                    }
                }
            } else {
                // Flujo original con verificación por correo
                usuario.setIdEstado(2); // Estado no verificado
                
                if (usuarioDao.insertarUsuario(usuario)) {
                    // Crear credencial temporal sin contraseña (verificado = false)
                    Usuario usuarioRegistrado = usuarioDao.obtenerUsuarioPorDni(dni);
                    credencial.setIdUsuario(usuarioRegistrado.getIdUsuario());
                    credencial.setContrasenha(null); // Sin contraseña inicial
                    
                    if (credencialDao.insertarCredencial(credencial)) {
                        // Generar y enviar código de verificación
                        try {
                            CodigoDao codigoDao = new CodigoDao();
                            String codigo = codigoDao.generateCodigo(correo);
                            
                            // Enviar correo con enlace de verificación
                            String subject = "Verifica tu cuenta - ONU Mujeres";
                            String body = "Hola " + nombre + ",\n\n" +
                                         "Para completar tu registro, haz clic en el siguiente enlace:\n" +
                                         "http://localhost:8080/establecerContrasena?codigo=" + codigo + "\n\n" +
                                         "Este enlace expirará en 24 horas.\n\n" +
                                         "Saludos,\nEquipo ONU Mujeres";
                            
                            MailSender.sendEmail(correo, subject, body);
                        
                            // Redirigir a página de confirmación
                            response.sendRedirect("verificaTuCorreo.jsp");
                            return;
                        } catch (Exception e) {
                            System.err.println("Error enviando correo: " + e.getMessage());
                            e.printStackTrace();
                            request.setAttribute("error", "Usuario registrado pero error enviando correo de verificación");
                            doGet(request, response);
                            return;
                        }
                    }
                }
            }
            ====== FIN CÓDIGO DE VERIFICACIÓN POR CORREO ====== */        } catch (SQLException e) {
            System.err.println("Error SQL al registrar usuario: " + e.getMessage());
            System.err.println("Código de error SQL: " + e.getErrorCode());
            System.err.println("Estado SQL: " + e.getSQLState());
            e.printStackTrace();
            request.setAttribute("error", "Error en la base de datos: " + e.getMessage());
            doGet(request, response);
        } catch (Exception e) {
            System.err.println("Error general al registrar usuario: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error en el servidor: " + e.getMessage());
            doGet(request, response);
        }
    }
}