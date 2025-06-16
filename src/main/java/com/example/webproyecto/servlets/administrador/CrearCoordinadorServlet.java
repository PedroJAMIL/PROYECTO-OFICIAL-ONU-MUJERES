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
import com.example.webproyecto.beans.Zona;
import com.example.webproyecto.daos.encuestador.ZonaDao;
import com.example.webproyecto.beans.Formulario; // <--- ¡NUEVO! Importar el bean Formulario
import com.example.webproyecto.daos.encuestador.FormularioDao; // <--- ¡NUEVO! Importar FormularioDao (desde su paquete correcto)

import java.sql.SQLException;

@WebServlet(name = "CrearCoordinadorServlet", value = "/CrearCoordinadorServlet")
public class CrearCoordinadorServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DistritoDao distritoDao = new DistritoDao();
        ZonaDao zonaDao = new ZonaDao();
        FormularioDao formularioDao = new FormularioDao(); // <--- ¡NUEVO! Instancia FormularioDao

        List<Distrito> listaDistritos = null;
        List<Zona> listaZonas = null;
        List<Formulario> listaFormularios = null; // <--- ¡NUEVO! Variable para formularios

        try {
            listaDistritos = distritoDao.listarDistritos();
            listaZonas = zonaDao.listarZonas();
            listaFormularios = formularioDao.listarFormularios(); // <--- ¡NUEVO! Carga los formularios


        } catch (SQLException e) {
            e.printStackTrace(); // Imprime el error de SQL
            request.setAttribute("errorCarga", "Error al cargar datos de distritos, zonas o formularios.");
            // Si hay un error, puedes considerar redirigir a una página de error
            // o simplemente continuar y que los combobox queden vacíos (pero con el mensaje de error).
        } catch (Exception e) { // Captura cualquier otra excepción
            e.printStackTrace();
            request.setAttribute("errorCarga", "Ocurrió un error inesperado al cargar datos.");
        }


        request.setAttribute("distritos", listaDistritos);
        request.setAttribute("zonas", listaZonas);
        request.setAttribute("formularios", listaFormularios); // <--- ¡NUEVO! Establece el atributo 'formularios'

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
        String correo = request.getParameter("correo");
        String password = request.getParameter("contrasenha");
        int idEstado = 2; // Activo

        String fotoBase64 = null;
        String nombrefoto = null;

        UsuarioDao usuarioDao = new UsuarioDao();
        CredencialDao credencialDao = new CredencialDao();
        DistritoDao distritoDao = new DistritoDao();
        ZonaDao zonaDao = new ZonaDao();
        FormularioDao formularioDao = new FormularioDao(); // <--- ¡NUEVO! Instancia para el doPost

        try {
            int idDistrito = Integer.parseInt(request.getParameter("idDistrito"));
            Integer idDistritoTrabajo = null;
            String idDistritoTrabajoParam = request.getParameter("idDistritoTrabajo");
            if (idDistritoTrabajoParam != null && !idDistritoTrabajoParam.isEmpty()) {
                idDistritoTrabajo = Integer.parseInt(idDistritoTrabajoParam);
            }

            Integer idZonaTrabajo = null;
            String idZonaTrabajoParam = request.getParameter("idZonaTrabajo");
            if (idZonaTrabajoParam != null && !idZonaTrabajoParam.isEmpty()) {
                idZonaTrabajo = Integer.parseInt(idZonaTrabajoParam);
            }

            // <--- ¡NUEVO! Obtener el ID del formulario asignado desde el request
            Integer idFormularioAsignado = null;
            String idFormularioAsignadoParam = request.getParameter("idFormularioAsignado");
            if (idFormularioAsignadoParam != null && !idFormularioAsignadoParam.isEmpty()) {
                idFormularioAsignado = Integer.parseInt(idFormularioAsignadoParam);
            }


            boolean existeDni = usuarioDao.existeDni(dni);
            boolean existeCorreo = credencialDao.existeCorreo(correo);

            if (existeDni || existeCorreo) {
                request.setAttribute("error", "Ya existe un usuario con ese DNI o correo.");
                // Recargar listas para que el formulario no se vea vacío al regresar
                request.setAttribute("distritos", distritoDao.listarDistritos());
                request.setAttribute("zonas", zonaDao.listarZonas());
                try { // <--- ¡NUEVO! Recarga de formularios en caso de error
                    request.setAttribute("formularios", formularioDao.listarFormularios());
                } catch (SQLException ex) {
                    ex.printStackTrace();
                    request.setAttribute("errorFormularios", "Error al recargar formularios.");
                }
                request.getRequestDispatcher("admin/crearCoordinador.jsp").forward(request, response);
                return;
            }

            Usuario usuario = new Usuario();
            usuario.setNombre(nombre);
            usuario.setApellidopaterno(apellidopaterno);
            usuario.setApellidomaterno(apellidomaterno);
            usuario.setDni(dni);
            usuario.setDireccion(direccion);
            usuario.setIdDistrito(idDistrito);
            usuario.setIdDistritoTrabajo(idDistritoTrabajo);

            usuario.setIdRol(2); // Rol para Coordinador
            usuario.setIdEstado(idEstado);

            usuario.setIdZonaTrabajo(idZonaTrabajo);
            // Si deseas almacenar el formulario asignado directamente en Usuario,
            // debes añadir la propiedad idFormularioAsignado a tu bean Usuario.java
            // y a tu tabla de base de datos 'usuario'.
            // usuario.setIdFormularioAsignado(idFormularioAsignado); // Descomenta si aplica

            usuario.setFoto(fotoBase64); // Considera si 'fotoBase64' y 'nombrefoto' siempre serán null aquí
            usuario.setNombrefoto(nombrefoto);

            boolean usuarioCreado = usuarioDao.insertarUsuario(usuario);

            if (usuarioCreado) {
                Credencial credencial = new Credencial();
                credencial.setCorreo(correo);
                credencial.setContrasenha(password);
                credencial.setIdUsuario(usuario.getIdUsuario()); // Asegúrate de que este ID se obtenga después de insertar el usuario

                boolean credOk = credencialDao.insertarCredencial(credencial);

                if (credOk) {
                    // Si el formulario asignado se guarda en otra tabla de relación, hazlo aquí
                    // Ejemplo: asignarFormularioACoordinadorDao.insertarAsignacion(usuario.getIdUsuario(), idFormularioAsignado);
                    response.sendRedirect("GestionarCoordinadoresServlet"); // Redirige al éxito
                } else {
                    request.setAttribute("error", "Error al guardar la credencial.");
                    // Recargar listas en caso de error
                    request.setAttribute("distritos", distritoDao.listarDistritos());
                    request.setAttribute("zonas", zonaDao.listarZonas());
                    try { // <--- ¡NUEVO! Recarga de formularios en caso de error
                        request.setAttribute("formularios", formularioDao.listarFormularios());
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                        request.setAttribute("errorFormularios", "Error al recargar formularios.");
                    }
                    request.getRequestDispatcher("admin/crearCoordinador.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Error al guardar el coordinador.");
                // Recargar listas en caso de error
                request.setAttribute("distritos", distritoDao.listarDistritos());
                request.setAttribute("zonas", zonaDao.listarZonas());
                try { // <--- ¡NUEVO! Recarga de formularios en caso de error
                    request.setAttribute("formularios", formularioDao.listarFormularios());
                } catch (SQLException ex) {
                    ex.printStackTrace();
                    request.setAttribute("errorFormularios", "Error al recargar formularios.");
                }
                request.getRequestDispatcher("admin/crearCoordinador.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error de base de datos durante la creación del coordinador: " + e.getMessage());
            try {
                request.setAttribute("distritos", distritoDao.listarDistritos());
                request.setAttribute("zonas", zonaDao.listarZonas());
                try { // <--- ¡NUEVO! Recarga de formularios en caso de error
                    request.setAttribute("formularios", formularioDao.listarFormularios());
                } catch (SQLException ex) {
                    ex.printStackTrace();
                    request.setAttribute("errorFormularios", "Error al recargar formularios.");
                }
            } catch (Exception ex) {
                ex.printStackTrace();
                request.setAttribute("error", request.getAttribute("error") + " Además, error al cargar datos de soporte.");
            }
            request.getRequestDispatcher("admin/crearCoordinador.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: Un ID numérico no es válido. Por favor, revise los campos de selección.");
            try {
                request.setAttribute("distritos", distritoDao.listarDistritos());
                request.setAttribute("zonas", zonaDao.listarZonas());
                try { // <--- ¡NUEVO! Recarga de formularios en caso de error
                    request.setAttribute("formularios", formularioDao.listarFormularios());
                } catch (SQLException ex) {
                    ex.printStackTrace();
                    request.setAttribute("errorFormularios", "Error al recargar formularios.");
                }
            } catch (Exception ex) {
                ex.printStackTrace();
                request.setAttribute("error", request.getAttribute("error") + " Además, error al cargar datos de soporte.");
            }
            request.getRequestDispatcher("admin/crearCoordinador.jsp").forward(request, response);
        }
    }
}