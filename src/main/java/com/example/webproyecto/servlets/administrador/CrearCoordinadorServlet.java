package com.example.webproyecto.servlets.administrador;

import com.example.webproyecto.beans.Usuario;
import com.example.webproyecto.beans.Credencial;
import com.example.webproyecto.daos.UsuarioDao;
import com.example.webproyecto.daos.CredencialDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import com.example.webproyecto.beans.Distrito;
import com.example.webproyecto.daos.DistritoDao;

@WebServlet(name = "CrearCoordinadorServlet", value = "/CrearCoordinadorServlet")
public class CrearCoordinadorServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Muestra el formulario para crear un coordinador
        // Cargar lista de distritos
        DistritoDao distritoDao = new DistritoDao();
        List<Distrito> listaDistritos = distritoDao.listarDistritos();
        request.setAttribute("distritos", listaDistritos);
        
        request.getRequestDispatcher("admin/crearCoordinador.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String nombre = request.getParameter("nombre");
        String apellidopaterno = request.getParameter("apellidopaterno");
        String apellidomaterno = request.getParameter("apellidomaterno");
        String dni = request.getParameter("dni");
        String direccion = request.getParameter("direccion");
        int idDistrito = Integer.parseInt(request.getParameter("idDistrito"));
        String correo = request.getParameter("correo");
        String password = request.getParameter("contrasenha");
        int idEstado = 2; // Activo
        String foto = null;

        UsuarioDao usuarioDao = new UsuarioDao();
        CredencialDao credencialDao = new CredencialDao();

        // Validación: ¿Ya existe usuario con ese DNI o correo?
        boolean existeDni = usuarioDao.existeDni(dni);
        boolean existeCorreo = credencialDao.existeCorreo(correo);

        if (existeDni || existeCorreo) {
            response.sendRedirect("admin/crearCoordinador.jsp?error=existe");
            return;
        }

        Usuario usuario = new Usuario();
        usuario.setNombre(nombre);
        usuario.setApellidopaterno(apellidopaterno);
        usuario.setApellidomaterno(apellidomaterno);
        usuario.setDni(dni);
        usuario.setDireccion(direccion);
        usuario.setIdDistrito(idDistrito);
        usuario.setIdRol(2); // Coordinador
        usuario.setIdEstado(idEstado);
        usuario.setFoto(foto);

        boolean usuarioCreado = usuarioDao.insertarUsuario(usuario);

        if (usuarioCreado) {
            Credencial credencial = new Credencial();
            credencial.setCorreo(correo);
            credencial.setContrasenha(password);
            credencial.setIdUsuario(usuario.getIdUsuario());

            boolean credOk = credencialDao.insertarCredencial(credencial);

            if (credOk) {
                response.sendRedirect("GestionarCoordinadoresServlet");
            } else {
                request.setAttribute("error", "Error al guardar la credencial.");
                request.getRequestDispatcher("admin/crearCoordinador.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Error al guardar el coordinador.");
            request.getRequestDispatcher("admin/crearCoordinador.jsp").forward(request, response);
        }
    }
}