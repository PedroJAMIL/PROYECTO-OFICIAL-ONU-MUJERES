<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
  <title>Gestión de Coordinadores</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <!-- Incluye tu CSS existente (ajusta la ruta) -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/estilos/encuestador.css">
  <style>
    :root {
      --color-primary: #3498db;
      --color-success: #2ecc71;
      --color-danger: #e74c3c;
      --color-gray: #95a5a6;
    }

    /* ---- Estilos para el contenido principal (ajustados por el sidebar) ---- */
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background-color: #f5f7fa;
      margin: 0;
      padding: 0;
      color: #333;
      transition: margin-left 0.3s;
    }
    .menu-toggle {
      display: none !important;
    }
    /* Ajuste cuando el sidebar está abierto */
    .menu-toggle:checked ~ .sidebar {
      left: 0;
    }
    .menu-toggle:checked ~ .overlay {
      display: block;
      opacity: 1;
    }
    /* Fix: NO empujar el contenido al abrir sidebar */
    /* .menu-toggle:checked ~ .contenedor-principal { margin-left: 280px; } */

    /* Contenedor principal (empujado por el sidebar) */
    .contenedor-principal, .main-content {
      width: 100%;
      margin: 0;
      padding: 30px 0 0 0;
      box-sizing: border-box;
    }

    /* ---- Estilos específicos para la tabla (como antes) ---- */
    .contenedor {
      background-color: #fff;
      border-radius: 10px;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
      padding: 25px;
      max-width: 1200px;
      margin: 20px auto;
    }

    .tabla-container {
      overflow-x: auto;
      margin-top: 20px;
    }

    table {
      width: 100%;
      border-collapse: separate;
      border-spacing: 0;
      background: #fff;
      border-radius: 8px;
      overflow: hidden;
      box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
    }

    th, td {
      padding: 15px;
      text-align: left;
      border-bottom: 1px solid #e0e0e0;
    }

    th {
      background-color: #f8f9fa;
      color: #2c3e50;
      font-weight: 600;
      text-transform: uppercase;
      font-size: 0.85em;
      letter-spacing: 0.5px;
    }

    tr:hover {
      background-color: #f8f9fa;
    }

    .estado-activo, .estado-inactivo {
      display: inline-flex;
      align-items: center;
      gap: 5px;
      padding: 5px 10px;
      border-radius: 20px;
      font-size: 0.85em;
      font-weight: 500;
    }

    .estado-activo {
      background-color: rgba(46, 204, 113, 0.1);
      color: var(--color-success);
    }

    .estado-inactivo {
      background-color: rgba(231, 76, 60, 0.1);
      color: var(--color-danger);
    }
    /* Sidebar estilo unificado (igual que admin) */
    .sidebar {
      position: fixed;
      top: 0;
      left: -280px;
      width: 280px;
      height: 100%;
      background: linear-gradient(135deg, #dbeeff 60%, #b3ccff 100%);
      box-shadow: 8px 0 32px rgba(52, 152, 219, 0.13), 2px 0 8px rgba(52, 152, 219, 0.10);
      border-right: 3px solid #3498db;
      border-radius: 0 28px 0 0;
      transition: left 0.3s ease, box-shadow 0.2s;
      z-index: 2001;
      overflow-y: auto;
      padding: 24px 0 20px 0;
      backdrop-filter: blur(6px);
    }
    .menu-toggle:checked ~ .sidebar { left: 0; }
    /* Fix: NO empujar el contenido al abrir sidebar */
    /* .menu-toggle:checked ~ .contenedor-principal { margin-left: 280px; } */

    .sidebar-content {
      height: 100%;
      display: flex;
      flex-direction: column;
      gap: 18px;
    }
    .sidebar-separator {
      width: 80%;
      height: 2px;
      background: linear-gradient(90deg, #b3ccff 0%, #3498db 100%);
      border-radius: 2px;
      margin: 18px auto 18px auto;
      opacity: 0.7;
    }
    .sidebar-content .menu-links {
      list-style: none;
      padding: 0;
      margin: 0;
    }

    .sidebar-content .menu-links li {
      margin-bottom: 15px;
    }

    .sidebar-content .menu-links a {
      display: flex;
      align-items: center;
      padding: 12px 20px;
      margin: 0 15px;
      border-radius: 8px;
      color: #1a1a1a;
      text-decoration: none;
      background-color: transparent;
      transition: all 0.3s ease;
      font-size: 16px;
      font-weight: bold;
    }

    .sidebar-content .menu-links a i {
      margin-right: 10px;
      font-size: 18px;
    }

    .sidebar-content .menu-links a:hover {
      background-color: #b3ccff;
      transform: scale(1.05);
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.12);
      color: #003366;
    }
    .menu-toggle:checked ~ .sidebar {
      left: 0;
    }
    .overlay {
      position: fixed;
      top: 0;
      left: 0;
      width: 100vw;
      height: 100vh;
      background: rgba(0,0,0,0.5);
      opacity: 0;
      visibility: hidden;
      transition: opacity 0.3s ease;
      z-index: 2000;
    }
    .menu-toggle:checked ~ .overlay {
      opacity: 1;
      visibility: visible;
    }
    
    .header-bar {
        background-color: #dbeeff;
        height: 56.8px;
        display: flex;
        align-items: center;
        justify-content: flex-start; /* <--- Cambia center por flex-start */
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        position: relative;
        z-index: 800;
        width: 100%;
        padding: 0;
    }
    .header-content {
        width: 100%;
        display: flex;
        align-items: center;
        justify-content: flex-start;
        gap: 1rem;
        margin: 0;
        padding: 0 20px; /* opcional, para no pegar todo al borde */
        box-sizing: border-box;
    }
    /* Cuando el sidebar está abierto, desplaza el header-content */

    .header-left {
      display: flex;
      align-items: center;
      gap: 0.5rem; /* reducir espacio entre las 3 rayas y el logo */
      margin-left: 0; /* sin margen extra */
    }
    .menu-icon {
      font-size: 26px; /* ligeramente más grande para que sea visible */
      cursor: pointer;
      color: #333;
      display: inline-block;
      margin-left: 0; /* pegado a la izquierda */
    }
    .logo-section {
      display: flex;
      flex-direction: column;
      gap: 0.2rem;
      margin-left: 10px; /* separación del logo respecto a las rayas */
    }
    .logo-large img {
      height: 40px; /* más pequeño para que quede estético */
      object-fit: contain;
    }
    .header-right {
      display: flex;
      gap: 2.5rem; /* mayor separación entre iconos para estética */
      margin-left: auto; /* para empujar a la derecha */
    }
    /* Iconos de Inicio y Encuestador más pequeños */
    .nav-item {
      display: flex;
      align-items: center;
      gap: 6px;
      cursor: pointer;
      font-weight: bold;
      color: #333;
      text-transform: uppercase;
      font-size: 0.9rem;
      user-select: none;
      position: relative;
    }
    .nav-icon {
      width: 28px; /* más pequeño */
      height: 28px;
      object-fit: cover;
    }
    /* Texto debajo de inicio quitado */
    .nav-item#btn-inicio span {
      display: none;
    }
    /* Texto a la izquierda del ícono encuestador */
    .nav-item#btn-encuestador {
      flex-direction: row;
      justify-content: flex-start;
      gap: 8px;
      color: #007bff;
      font-weight: bold;
    }
    .nav-item#btn-encuestador span {
      display: inline-block;
    }
    .dropdown-menu {
      display: none;
      position: absolute;
      top: 110%;
      left: 0;
      background: #fff;
      border-radius: 8px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      min-width: 140px;
      z-index: 1001;
      padding: 8px 0;
    }
    .nav-item.dropdown:focus-within .dropdown-menu,
    .nav-item.dropdown:hover .dropdown-menu {
      display: block;
    }
    .dropdown-menu a {
      display: block;
      padding: 8px 18px;
      color: #333;
      text-decoration: none;
      font-size: 0.95em;
      transition: background 0.2s;
    }
    .dropdown-menu a:hover {
      background: #e6f0ff;
      color: #007bff;
    }
    .dropdown-estado {
        position: relative;
        display: inline-block;
    }
    .btn-estado {
        cursor: pointer;
        background: none;
        border: none;
        outline: none;
        padding: 0;
        font: inherit;
        display: flex;
        align-items: center;
        gap: 4px;
    }
    .dropdown-menu-estado {
        position: absolute;
        top: 110%;
        left: 0;
        min-width: 120px;
        background: #fff;
        border: 1px solid #e0e0e0;
        border-radius: 8px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        z-index: 10;
        padding: 4px 0;
    }
    .dropdown-option {
        padding: 8px 16px;
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 6px;
        transition: background 0.2s;
    }
    .dropdown-option:hover {
        background: #f0f4fa;
    }
    .busqueda-form {
        margin-bottom: 20px;
        text-align: left;
    }
    .filtros-container {
        display: flex;
        flex-wrap: wrap;
        justify-content: flex-start;
        gap: 10px;
        align-items: center;
    }
    .input-filtro {
        padding: 8px 12px;
        border: 1px solid #ccc;
        border-radius: 8px;
        font-size: 14px;
        min-width: 180px;
    }
    .btn-filtrar {
        background-color: #3498db;
        color: white;
        border: none;
        padding: 8px 14px;
        border-radius: 8px;
        font-weight: bold;
        font-size: 14px;
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 6px;
    }
    .btn-filtrar:hover {
        background-color: #2980b9;
    }
  </style>
</head>
<script>
    let cambiosPendientes = {};
    document.addEventListener('DOMContentLoaded', function () {
        document.querySelectorAll('.dropdown-estado').forEach(function(drop) {
            const btn = drop.querySelector('.btn-estado');
            const menu = drop.querySelector('.dropdown-menu-estado');
            const options = menu.querySelectorAll('.dropdown-option');

            btn.addEventListener('click', function(e) {
                e.stopPropagation();
                menu.style.display = menu.style.display === 'block' ? 'none' : 'block';
            });

            options.forEach(function(opt) {
                opt.addEventListener('click', function(e) {
                    e.stopPropagation();
                    const nuevoEstado = this.getAttribute('data-value');
                    const idUsuario = btn.getAttribute('data-id');
                    const estadoActual = btn.getAttribute('data-estado');
                    if (nuevoEstado === estadoActual) {
                        menu.style.display = 'none';
                        return;
                    }

                    // Actualizamos visual
                    btn.setAttribute('data-estado', nuevoEstado);
                    btn.innerHTML =
                        (nuevoEstado === '2'
                            ? '<span class="estado-activo"><i class="fas fa-circle"></i> Activo</span>'
                            : '<span class="estado-inactivo"><i class="fas fa-circle"></i> Inactivo</span>')
                        + '<i class="fa fa-caret-down" style="margin-left:6px;"></i>';

                    cambiosPendientes[idUsuario] = nuevoEstado;
                    menu.style.display = 'none';
                });
            });

            document.addEventListener('click', function() {
                menu.style.display = 'none';
            });

            menu.addEventListener('click', function(e) {
                e.stopPropagation();
            });
        });

        document.getElementById('btn-guardar-cambios').addEventListener('click', function () {
            if (Object.keys(cambiosPendientes).length === 0) {
                mostrarToast("No hay cambios por guardar", false);
                return;
            }

            const params = new URLSearchParams();
            params.append("accion", "guardarCambiosMasivos");
            params.append("cambios", JSON.stringify(cambiosPendientes));

            fetch('${pageContext.request.contextPath}/GestionEncuestadoresServlet', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params.toString()
            })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        mostrarToast("¡Cambios guardados con éxito!", true);
                        cambiosPendientes = {};
                    } else {
                        mostrarToast("Error al guardar cambios", false);
                    }
                })
                .catch(() => {
                    mostrarToast("Error de red al guardar", false);
                });
        });
    });



    function mostrarToast(mensaje, exito) {
        const toast = document.getElementById("toast");
        toast.innerText = mensaje;
        toast.style.backgroundColor = exito ? '#2ecc71' : '#e74c3c';
        toast.style.visibility = "visible";
        toast.style.opacity = "1";
        toast.style.top = "20px";
        setTimeout(() => {
            toast.style.opacity = "0";
            toast.style.top = "0px";
            setTimeout(() => {
                toast.style.visibility = "hidden";
            }, 500);
        }, 3000);
    }

</script>


<body>


<!-- Checkbox oculto para controlar el sidebar -->
<input type="checkbox" id="menu-toggle" class="menu-toggle" style="display:none;" />

<!-- Sidebar (copiado de tu código) -->
<!-- Sidebar (actualizado con nuevos apartados) -->
<!-- Sidebar con íconos FontAwesome actualizados -->
<div id="toast" style="
  visibility: hidden;
  position: fixed;
  top: 20px;
  right: 20px;
  background-color: #2ecc71;
  color: white;
  text-align: left;
  border-radius: 10px;
  padding: 20px 25px;
  font-size: 1.1rem;
  font-weight: bold;
  z-index: 9999;
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
  opacity: 0;
  transition: opacity 0.5s ease, top 0.5s ease;
">
    Mensaje
</div>

<div class="sidebar">
  <div class="sidebar-content">
    <div class="sidebar-separator"></div>
    <ul class="menu-links">
      <li><a href="DashboardServlet"><i class="fa-solid fa-chart-line"></i> Ver Dashboard</a></li>
      <li><a href="GestionEncuestadoresServlet"><i class="fa-solid fa-users"></i> Gestionar Encuestadores</a></li>
      <li><a href="GestionarFormulariosServlet"><i class="fa-solid fa-file-alt"></i> Gestionar Formularios</a></li>
      <li><a href="CargarArchivosServlet"><i class="fa-solid fa-upload"></i> Cargar Archivos</a></li>
      <li><a href="CerrarSesionServlet"><i class="fa-solid fa-sign-out-alt"></i> Cerrar sesión</a></li>
    </ul>
  </div>
</div>
<!-- ...resto del código... -->
<!-- ...resto del código... -->

<!-- Overlay para cerrar el sidebar al hacer clic fuera -->
<label for="menu-toggle" class="overlay"></label>

<!-- Header (copiado de tu código) -->
<header class="header-bar">
    <div class="header-content">
        <div class="header-left">
            <label for="menu-toggle" class="menu-icon">&#9776;</label>
            <div class="logo-section">
                <div class="logo-large">
                    <img src="${pageContext.request.contextPath}/imagenes/logo.jpg" alt="Logo Combinado" />
                </div>
            </div>
        </div>
        <nav class="header-right">
            <div class="nav-item dropdown" id="btn-encuestador" tabindex="0">
                <img src="${pageContext.request.contextPath}/imagenes/usuario.png" alt="Icono Usuario" class="nav-icon">
                <span>
                        <c:choose>
                            <c:when test="${not empty datosPerfil.usuario.nombre && not empty datosPerfil.usuario.apellidopaterno}">
                                ${fn:substring(datosPerfil.usuario.nombre, 0, 1)}. ${datosPerfil.usuario.apellidopaterno}
                            </c:when>
                            <c:otherwise>
                                ${sessionScope.nombre}
                            </c:otherwise>
                        </c:choose>
                    </span>
                <div class="dropdown-menu">
                    <a href="VerPerfilServlet">Ver perfil</a>
                    <a href="CerrarSesionServlet">Cerrar sesión</a>
                </div>
            </div>
            <a href="InicioEncuestadorServlet" class="nav-item" id="btn-inicio">
                <img src="${pageContext.request.contextPath}/imagenes/inicio.png" alt="Icono de perfil" class="nav-icon" />
            </a>
        </nav>
    </div>
</header>

<!-- Contenido principal (ajustado por el sidebar) -->
<main class="contenedor-principal">
  <div class="contenedor">
      <div style="display: flex; justify-content: space-between; align-items: center;">
          <h2 style="margin: 0;">Gestión de Encuestadores</h2>
          <button id="btn-guardar-cambios" class="btn-filtrar" style="background-color: #2ecc71; margin-left: auto;">
              <i class="fas fa-save"></i> Guardar Cambios
          </button>
      </div>

      <form method="get" action="GestionEncuestadoresServlet" class="busqueda-form">
          <div class="filtros-container">
              <input type="text" name="nombre" placeholder="Buscar por nombre o DNI" class="input-filtro" value="${param.nombre}"/>
              <select name="estado" class="input-filtro">
                  <option value="">Todos</option>
                  <option value="2" ${param.estado == '2' ? 'selected' : ''}>Activos</option>
                  <option value="1" ${param.estado == '1' ? 'selected' : ''}>Inactivos</option>
              </select>
              <button type="submit" class="btn-filtrar"><i class="fas fa-search"></i> Filtrar</button>
          </div>
      </form>

      <div class="tabla-container">
      <table>
        <thead>
        <tr>
          <th>Nombre</th>
          <th>DNI</th>
          <th>Correo electrónico</th> 
          <th>Zona</th>
          <th>Estado</th>
        </tr>
        </thead>
        <tbody>
          <c:forEach var="encuestador" items="${encuestadores}">
            <tr>
                <td>${encuestador.usuario.nombre} ${encuestador.usuario.apellidopaterno} ${encuestador.usuario.apellidomaterno}</td>
                <td>${encuestador.usuario.dni}</td>
                <td>${encuestador.credencial.correo}</td>
                <td>${encuestador.usuario.idDistrito}</td>
                <td>
                    <div class="dropdown-estado">
                        <button
                                class="btn-estado"
                                data-id="${encuestador.usuario.idUsuario}"
                                data-estado="${encuestador.usuario.idEstado != null ? encuestador.usuario.idEstado : 2}">
          <span class="${encuestador.usuario.idEstado == 2 ? 'estado-activo' : 'estado-inactivo'}">
            <i class="fas fa-circle"></i>
            ${encuestador.usuario.idEstado == 2 ? 'Activo' : 'Inactivo'}
          </span>
                            <i class="fa fa-caret-down" style="margin-left:6px;"></i>
                        </button>
                        <div class="dropdown-menu-estado" style="display:none;">
                            <div class="dropdown-option" data-value="2">
                                <span class="estado-activo"><i class="fas fa-circle"></i> Activo</span>
                            </div>
                            <div class="dropdown-option" data-value="1">
                                <span class="estado-inactivo"><i class="fas fa-circle"></i> Inactivo</span>
                            </div>
                        </div>
                    </div>
                </td>

              <td><!-- Aquí puedes poner la fecha de último acceso si la tienes --></td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </div>


</main>
</body>
</html>