<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
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
    max-width: 98vw;
    width: 98vw;
    margin: 20px auto;
    box-sizing: border-box;
    /* Centrado perfecto y margen igual a ambos lados */
    position: relative;
    left: 50%;
    transform: translateX(-50%);
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

  th.estado-col {
    text-align: center;
  }

  td.estado-col {
    text-align: center;
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
    margin-top: 18px;
    margin-bottom: 18px;
  }
  .input-filtro {
    padding: 8px 12px;
    border: 1px solid #ccc;
    border-radius: 6px;
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
  .paginacion {
    margin-top: 24px;
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 8px;
    font-family: inherit;
  }
  .paginacion a {
    color: #3498db;
    font-weight: bold;
    text-decoration: none;
    padding: 6px 12px;
    border-radius: 6px;
    transition: background 0.2s;
    font-size: 0.95rem;
  }
  .paginacion a.active,
  .paginacion a:hover {
    background-color: #e6f0ff;
  }
  .btn-cambiar-estado {
    color: white;
    border: none;
    border-radius: 20px;
    padding: 8px 0;
    font-weight: bold;
    cursor: pointer;
    min-width: 140px;
    width: 140px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    font-size: 1rem;
    transition: background 0.2s, box-shadow 0.2s;
    box-shadow: 0 2px 8px rgba(44,62,80,0.04);
    text-align: center;
  }
  .btn-estado-activo {
    background-color: #2ecc71;
  }
  .btn-estado-inactivo {
    background-color: #e74c3c;
  }
  .filtros-superior {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-top: 18px;
    margin-bottom: 18px;
  }
</style>
<head>
  <title>Gestión de Encuestadores</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/estilos/encuestador.css">
  <!-- Incluye todos los estilos de VerFormularios.jsp aquí (omitidos por brevedad) -->
</head>
<body>
<input type="checkbox" id="menu-toggle" class="menu-toggle" style="display:none;" />
<div id="toast" style="
  visibility: hidden;
  position: fixed;
  top: 32px;
  left: 50%;
  transform: translateX(-50%);
  background-color: #2ecc71;
  color: white;
  text-align: center;
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
      <li><a href="InicioAdminServlet"><i class="fa-solid fa-chart-line"></i> Dashboard</a></li>
      <li><a href="CrearCoordinadorServlet"><i class="fa-solid fa-user-plus"></i> Crear nuevo usuario</a></li>
      <li><a href="GestionarCoordinadoresServlet"><i class="fa-solid fa-user-tie"></i> Gestionar Coordinadores</a></li>
      <li><a href="GestionarEncuestadoresServlet"><i class="fa-solid fa-user"></i> Gestionar Encuestadores</a></li>
      <li><a href="GenerarReportesServlet"><i class="fa-solid fa-file-lines"></i> Generar reportes</a></li>
      <li><a href="CerrarSesionServlet"><i class="fa-solid fa-sign-out-alt"></i> Cerrar sesión</a></li>
    </ul>
  </div>
</div>
<label for="menu-toggle" class="overlay"></label>
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
        <span>${sessionScope.nombre}</span>
        <div class="dropdown-menu">
          <a href="VerPerfilServlet">Ver perfil</a>
          <a href="CerrarSesionServlet">Cerrar sesión</a>
        </div>
      </div>
      <a href="InicioAdminServlet" class="nav-item" id="btn-inicio">
        <img src="${pageContext.request.contextPath}/imagenes/inicio.png" alt="Icono de perfil" class="nav-icon" />
      </a>
    </nav>
  </div>
</header>
<main class="contenedor-principal">
  <div class="contenedor">
    <div style="display: flex; justify-content: space-between; align-items: center;">
      <h2 style="margin-bottom: 0.5em;">Gestión de Encuestadores</h2>
    </div>
    <div class="filtros-superior">
        <form method="get" action="GestionarEncuestadoresServlet" style="display: flex; align-items: center; gap: 10px;">
            <input type="text" name="nombre" placeholder="Buscar por nombre o DNI" value="${param.nombre}" style="padding: 8px 12px; border-radius: 6px; border: 1px solid #ccc;">
            <select name="estado" style="padding: 8px 12px; border-radius: 6px; border: 1px solid #ccc;">
                <option value="">Todos</option>
                <option value="2" ${param.estado == '2' ? 'selected' : ''}>Activado</option>
                <option value="1" ${param.estado == '1' ? 'selected' : ''}>Desactivado</option>
            </select>
            <button type="submit" class="btn-filtrar"><i class="fas fa-search"></i> Filtrar</button>
        </form>
    </div>
    <div class="tabla-container">
      <table>
        <thead>
        <tr>
          <th>Nombre</th>
          <th>DNI</th>
          <th>Correo electrónico</th>
          <th>Zona</th>
          <th class="estado-col">Estado</th>
        </tr>
        </thead>
        <tbody>
        <c:choose>
          <c:when test="${empty encuestadores}">
            <tr>
              <td colspan="5" style="text-align:center; color:#e74c3c; font-weight:bold; font-size:1.1em; padding:32px 0;">No se encontraron resultados.</td>
            </tr>
          </c:when>
          <c:otherwise>
            <c:forEach var="encuestador" items="${encuestadores}">
              <tr data-id="${encuestador.usuario.idUsuario}">
                <td>${encuestador.usuario.nombre} ${encuestador.usuario.apellidopaterno} ${encuestador.usuario.apellidomaterno}</td>
                <td>${encuestador.usuario.dni}</td>
                <td>${encuestador.credencial.correo}</td>
                <td>${encuestador.zonaTrabajoNombre}</td>
                <td class="estado-col">
                  <button class="btn-cambiar-estado ${encuestador.usuario.idEstado == 2 ? 'btn-estado-activo' : 'btn-estado-inactivo'}"
                          data-id="${encuestador.usuario.idUsuario}"
                          data-estado="${encuestador.usuario.idEstado != null ? encuestador.usuario.idEstado : 2}">
                    <i class="fas fa-power-off"></i>
                    ${encuestador.usuario.idEstado == 2 ? 'Activado' : 'Desactivado'}
                  </button>
                </td>
              </tr>
            </c:forEach>
          </c:otherwise>
        </c:choose>
        </tbody>
      </table>
    </div>
    <div class="paginacion">
      <c:if test="${paginaActual > 1}">
        <a href="GestionarEncuestadoresServlet?pagina=${paginaActual - 1}">&lt;</a>
      </c:if>
      <c:forEach var="i" begin="1" end="${totalPaginas}">
        <a href="GestionarEncuestadoresServlet?pagina=${i}" class="${i == paginaActual ? 'active' : ''}">${i}</a>
      </c:forEach>
      <c:if test="${paginaActual < totalPaginas}">
        <a href="GestionarEncuestadoresServlet?pagina=${paginaActual + 1}">&gt;</a>
      </c:if>
    </div>
  </div>
</main>
<div id="modal-confirm" style="display:none; position:fixed; top:0; left:0; width:100vw; height:100vh; background:rgba(0,0,0,0.35); z-index:9999; align-items:center; justify-content:center;">
  <div style="background:#fff; padding:32px 28px; border-radius:12px; box-shadow:0 8px 32px rgba(0,0,0,0.18); min-width:320px; max-width:90vw; text-align:center;">
    <div id="modal-msg" style="font-size:1.1rem; margin-bottom:18px;"></div>
    <button id="modal-confirm-btn" style="background:#2ecc71; color:#fff; border:none; border-radius:8px; padding:8px 22px; font-weight:bold; margin-right:12px; cursor:pointer;">Confirmar</button>
    <button id="modal-cancel-btn" style="background:#e74c3c; color:#fff; border:none; border-radius:8px; padding:8px 22px; font-weight:bold; cursor:pointer;">Cancelar</button>
  </div>
</div>
<script>
  let cambiosPendientes = {};
  let idPendiente = null, nuevoEstadoPendiente = null;
  document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.btn-cambiar-estado').forEach(function(btn) {
      btn.addEventListener('click', function(e) {
        e.preventDefault();
        idPendiente = btn.getAttribute('data-id');
        const estadoActual = btn.getAttribute('data-estado');
        nuevoEstadoPendiente = (estadoActual === '2') ? '1' : '2';
        document.getElementById('modal-msg').innerText = (nuevoEstadoPendiente === '2') ?
          '¿Está seguro que desea ACTIVAR a este encuestador?' :
          '¿Está seguro que desea DESACTIVAR a este encuestador?';
        document.getElementById('modal-confirm').style.display = 'flex';
      });
    });
    document.getElementById('modal-cancel-btn').onclick = function() {
      document.getElementById('modal-confirm').style.display = 'none';
      idPendiente = null; nuevoEstadoPendiente = null;
    };
    document.getElementById('modal-confirm-btn').onclick = function() {
      if (!idPendiente || !nuevoEstadoPendiente) return;
      const idUsuarioLocal = idPendiente;
      const nuevoEstadoLocal = nuevoEstadoPendiente;
      fetch('${pageContext.request.contextPath}/GestionarEncuestadoresServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'accion=cambiarEstado&idUsuario=' + encodeURIComponent(idUsuarioLocal) + '&nuevoEstado=' + encodeURIComponent(nuevoEstadoLocal)
      })
      .then((res) => {
        if (!res.ok) throw new Error('HTTP error ' + res.status);
        return res.json().catch(async () => {
          const text = await res.text();
          mostrarToast('Respuesta inesperada: ' + text.substring(0, 100), false);
          throw new Error('Respuesta no JSON: ' + text);
        });
      })
      .then((data) => {
        if (data.success) {
          // Buscar el botón por data-id en el DOM
          const allBtns = document.querySelectorAll('.btn-cambiar-estado');
          const btn = Array.from(allBtns).find(b => b.getAttribute('data-id') == idUsuarioLocal);
          if (!btn) {
            mostrarToast('Error: botón no encontrado en DOM (id=' + idUsuarioLocal + ')', false);
            return;
          }
          btn.setAttribute('data-estado', nuevoEstadoLocal);
          btn.innerHTML = '<i class="fas fa-power-off"></i> ' + (nuevoEstadoLocal === '2' ? 'Activado' : 'Desactivado');
          btn.classList.toggle('btn-estado-activo', nuevoEstadoLocal === '2');
          btn.classList.toggle('btn-estado-inactivo', nuevoEstadoLocal !== '2');
          mostrarToast('¡Estado actualizado con éxito!', true);
        } else {
          mostrarToast('Error al cambiar estado', false);
        }
      })
      .catch((err) => {
        console.error("Error en fetch:", err);
        mostrarToast('Error de red al cambiar estado', false);
      });
      document.getElementById('modal-confirm').style.display = 'none';
      idPendiente = null; nuevoEstadoPendiente = null;
    };
  });
  function mostrarToast(mensaje, exito) {
    const toast = document.getElementById("toast");
    toast.innerText = mensaje;
    toast.style.backgroundColor = exito ? '#2ecc71' : '#e74c3c';
    toast.style.visibility = "visible";
    toast.style.opacity = "1";
    toast.style.top = "32px";
    toast.style.left = "50%";
    toast.style.transform = "translateX(-50%)";
    setTimeout(() => {
      toast.style.opacity = "0";
      toast.style.top = "0px";
      setTimeout(() => {
        toast.style.visibility = "hidden";
      }, 500);
    }, 3000);
  }
</script>
</body>
</html>