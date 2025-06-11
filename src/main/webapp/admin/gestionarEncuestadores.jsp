<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
  <title>Gestión de Encuestadores</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <style>
    :root {
      --color-primary: #3498db;
      --color-bg: #f5f7fa;
      --color-card: #c8dbff;
      --color-card-inner: #e6f0ff;
      --sidebar-bg: #e6f0ff;
      --header-bg: #dbeeff;
      --color-btn: #f5b7b1;
      --color-btn-hover: #f1948a;
      --color-success: #2ecc71;
      --color-danger: #e74c3c;
      --color-gray: #95a5a6;
    }
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: linear-gradient(135deg, #e6f0ff 0%, #b3ccff 100%);
      margin: 0;
      padding: 0;
      color: #333;
    }
    .menu-toggle:checked ~ .sidebar { left: 0; }
    .menu-toggle:checked ~ .overlay { display: block; opacity: 1; }
    /* Fix: NO empujar el contenido al abrir sidebar */
    /* .menu-toggle:checked ~ .contenedor-principal { margin-left: 280px; } */
    .contenedor-principal {
      width: 100%;
      margin: 0;
      padding: 30px 30px 0 30px;
      box-sizing: border-box;
      min-height: calc(100vh - 70px);
    }
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
    .sidebar-content .menu-links li { margin-bottom: 15px; }
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
      background-color: var(--header-bg);
      height: 56.8px;
      display: flex;
      align-items: center;
      justify-content: center;
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
      padding: 0 20px;
      box-sizing: border-box;
    }
    .header-left {
      display: flex;
      align-items: center;
      gap: 0.5rem;
      margin-left: 0;
    }
    .menu-icon {
      font-size: 26px;
      cursor: pointer;
      color: #333;
      display: inline-block;
      margin-left: 0;
    }
    .logo-section {
      display: flex;
      flex-direction: column;
      gap: 0.2rem;
      margin-left: 10px;
    }
    .logo-large img {
      height: 40px;
      object-fit: contain;
    }
    .header-right {
      display: flex;
      gap: 2.5rem;
      margin-left: auto;
    }
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
      width: 28px;
      height: 28px;
      object-fit: cover;
    }
    .nav-item#btn-inicio span {
      display: none;
    }
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
    .nav-item.dropdown {
      position: relative;
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
    /* ----------- Tabla y botones ----------- */
    .contenedor {
      background-color: #fff;
      border-radius: 10px;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
      padding: 25px;
      max-width: 1200px;
      margin: 20px auto;
    }
    .contenedor-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 18px;
    }
    .contenedor-header h2 {
      margin: 0;
      font-size: 1.25em;
      font-weight: bold;
    }
    .btn-agregar {
      background: #f5b7b1;
      color: #333;
      border: none;
      border-radius: 18px;
      padding: 10px 28px;
      font-size: 1em;
      font-weight: bold;
      cursor: pointer;
      display: flex;
      align-items: center;
      gap: 8px;
      box-shadow: 0 2px 8px rgba(52, 152, 219, 0.10);
      transition: background 0.2s;
    }
    .btn-agregar:hover {
      background: #f1948a;
    }
    .tabla-container {
      overflow-x: auto;
      margin-top: 10px;
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
      padding: 13px 10px;
      text-align: left;
      border-bottom: 1px solid #e0e0e0;
      border-right: 1px solid #f5b7b1;
    }
    th:last-child, td:last-child {
      border-right: none;
    }
    th {
      background-color: #f8f9fa;
      color: #2c3e50;
      font-weight: 600;
      text-transform: uppercase;
      font-size: 0.95em;
      letter-spacing: 0.5px;
      border-top: 2px solid #f5b7b1;
    }
    tr {
      border: 1.5px solid #f5b7b1;
    }
    tr:hover {
      background-color: #f8f9fa;
    }
    /* Estado switch */
    .estado-switch {
      display: flex;
      align-items: center;
      gap: 8px;
    }
    .switch {
      position: relative;
      display: inline-block;
      width: 44px;
      height: 24px;
    }
    .switch input {
      opacity: 0;
      width: 0;
      height: 0;
    }
    .slider {
      position: absolute;
      cursor: pointer;
      top: 0; left: 0; right: 0; bottom: 0;
      background-color: #ccc;
      border-radius: 24px;
      transition: .4s;
    }
    .switch input:checked + .slider {
      background-color: #2ecc71;
    }
    .slider:before {
      position: absolute;
      content: "";
      height: 18px;
      width: 18px;
      left: 3px;
      bottom: 3px;
      background-color: white;
      border-radius: 50%;
      transition: .4s;
    }
    .switch input:checked + .slider:before {
      transform: translateX(20px);
    }
    .estado-activo {
      color: #2ecc71;
      font-size: 0.95em;
      font-weight: 500;
      margin-left: 6px;
    }
    .estado-inactivo {
      color: #aaa;
      font-size: 0.95em;
      font-weight: 500;
      margin-left: 6px;
    }
    /* Paginación */
    .paginacion {
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 10px;
      margin-top: 18px;
    }
    .paginacion a {
      color: #3498db;
      font-weight: bold;
      text-decoration: none;
      padding: 2px 8px;
      border-radius: 4px;
      transition: background 0.2s;
    }
    .paginacion a.active, .paginacion a:hover {
      background: #e6f0ff;
    }
  </style>
</head>
<body>
<!-- Checkbox oculto para controlar el sidebar -->
<input type="checkbox" id="menu-toggle" class="menu-toggle" style="display:none;" />

<!-- Sidebar -->
<div class="sidebar">
  <div class="sidebar-content">
    <div class="sidebar-separator"></div>
    <ul class="menu-links">
      <li><a href="InicioAdminServlet"><i class="fa-solid fa-chart-line"></i> Dashboard</a></li>
      <li><a href="CrearUsuarioServlet"><i class="fa-solid fa-user-plus"></i> Crear nuevo usuario</a></li>
      <li><a href="GestionarCoordinadoresServlet"><i class="fa-solid fa-user-tie"></i> Gestionar Coordinadores</a></li>
      <li><a href="GestionarEncuestadoresServlet"><i class="fa-solid fa-user"></i> Gestionar Encuestadores</a></li>
      <li><a href="GenerarReportesServlet"><i class="fa-solid fa-file-lines"></i> Generar reportes</a></li>
      <li><a href="CerrarSesionServlet"><i class="fa-solid fa-sign-out-alt"></i> Cerrar sesión</a></li>
    </ul>
  </div>
</div>

<!-- Overlay para cerrar el sidebar al hacer clic fuera -->
<label for="menu-toggle" class="overlay"></label>

<!-- Header -->
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
            <c:when test="${not empty sessionScope.nombre}">
              ${sessionScope.nombre}
            </c:when>
            <c:otherwise>
              Administrador
            </c:otherwise>
          </c:choose>
        </span>
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

<!-- Contenido principal -->
<main class="contenedor-principal">
  <div class="contenedor">
    <div class="contenedor-header">
      <h2>Gestión de Encuestadores</h2>
      <button class="btn-agregar"><i class="fa-solid fa-plus"></i> Agregar encuestador</button>
    </div>
    <div class="tabla-container">
      <table>
        <thead>
        <tr>
          <th>Nombre</th>
          <th>DNI</th>
          <th>Correo electrónico</th>
          <th>Zona</th>
          <th>Estado</th>
          <th>Último acceso</th>
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
                <div class="estado-switch">
                  <label class="switch">
                    <input type="checkbox" <c:if test="${encuestador.usuario.idEstado == 2}">checked</c:if>>
                    <span class="slider"></span>
                  </label>
                  <span class="${encuestador.usuario.idEstado == 2 ? 'estado-activo' : 'estado-inactivo'}">
                    ${encuestador.usuario.idEstado == 2 ? 'Activo' : 'Inactivo'}
                  </span>
                </div>
              </td>
              <td><!-- Aquí puedes poner la fecha de último acceso si la tienes --></td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
    <div class="paginacion">
      <a href="#">&#60;</a>
      <a href="#" class="active">2</a>
      <a href="#">3</a>
      <a href="#">4</a>
      <a href="#">&#62;</a>
    </div>
  </div>
</main>
</body>
</html>