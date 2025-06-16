<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Crear Coordinador Interno</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root {
            --color-primary: #3498db;
            --color-bg: #f5f7fa;
            --color-card: #c8dbff;
            --color-card-inner: #e6f0ff;
            --sidebar-bg: #e6f0ff;
            --header-bg: #dbeeff;
            --color-btn: #5a9cf8;
            --color-btn-hover: #357ae8;
        }
        html, body {
            height: 100%;
            min-height: 100vh;
            background: #fff !important;
            margin: 0;
            padding: 0;
            color: #333;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .menu-toggle:checked ~ .sidebar { left: 0; }
        .menu-toggle:checked ~ .overlay { display: block; opacity: 1; }
        /* Fix: NO empujar el contenido al abrir sidebar */
        /* .menu-toggle:checked ~ .contenedor-principal { margin-left: 280px; } */
        .contenedor-principal {
            width: 100vw;
            min-height: 100vh;
            margin: 0;
            padding: 0;
            background: #fff;
            box-sizing: border-box;
            display: flex;
            align-items: center; /* Centra verticalmente */
            justify-content: center;
        }
        /* Sidebar y header igual que dashboardAdmin.jsp */
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
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            letter-spacing: 0.01em;
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
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            font-weight: bold;
            letter-spacing: 0.01em;
            z-index: 9999;
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
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
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
        /* ----------- Formulario Mejorado: más grande, sin scroll ----------- */
        .crear-coordinador-wrapper {
            background: #fff;
            border-radius: 0;
            box-shadow: none;
            border: none;
            width: 100vw;
            max-width: 100vw;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            display: flex;
            align-items: center; /* Centra verticalmente */
            justify-content: center;
        }
        .crear-coordinador-form {
            background: #fff;
            box-shadow: none;
            border-radius: 0;
            border: none;
            width: 100%;
            max-width: 1100px;
            margin: 0 auto;
            padding: 36px 48px 36px 48px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 26px 36px;
            align-items: start;
            min-height: unset;
            margin-top: 38px;
        }
        .form-section {
            display: contents;
        }
        .section-title {
            grid-column: 1 / -1;
            margin-bottom: 12px;
            font-size: 1.1em;
            font-weight: bold;
            color: #222;
            letter-spacing: 0.5px;
            text-align: left;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .section-title i {
            color: #888;
            font-size: 1.1em;
            margin-right: 4px;
        }
        .form-group {
            margin-bottom: 12px;
            width: 100%;
            position: relative;
        }
        .form-btns {
            grid-column: 1 / -1;
            display: flex;
            gap: 18px;
            margin-top: 32px;
            justify-content: center;
        }
        .form-group i {
            position: absolute;
            left: 10px;
            top: 50%;
            transform: translateY(-50%);
            color: #bbb;
            font-size: 1em;
            pointer-events: none;
        }
        .form-input {
            width: 100%;
            padding: 16px 16px 16px 44px;
            border: 2.2px solid #b3ccff;
            border-radius: 8px;
            font-size: 1.11em;
            background: #fff;
            color: #333;
            font-weight: normal;
            transition: border 0.2s;
            box-sizing: border-box;
        }
        .form-input:focus {
            border: 2.5px solid #3498db;
            outline: none;
        }
        .form-input::placeholder {
            color: #aaa;
            opacity: 1;
            font-weight: normal;
        }
        .form-btns {
            display: flex;
            gap: 18px;
            margin-top: 32px;
            justify-content: center;
        }
        .btn {
            background: #3498db;
            color: #fff;
            border: none;
            border-radius: 6px;
            padding: 12px 32px;
            font-size: 1em;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s, box-shadow 0.2s;
            box-shadow: none;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .btn:hover {
            background: #2166c1;
        }
        .btn i {
            color: #fff;
            font-size: 1em;
            margin-right: 2px;
        }
        .crear-coordinador-title, .section-separator {
            display: none;
        }
        @media (max-width: 1200px) {
            .crear-coordinador-form {
                max-width: 98vw;
                padding: 24px 2vw 24px 2vw;
                gap: 18px 18px;
            }
        }
        @media (max-width: 900px) {
            .crear-coordinador-form {
                margin-top: 18px;
                grid-template-columns: 1fr;
                gap: 10px;
                padding: 0 4vw 32px 4vw;
            }
            .form-group {
                margin-bottom: 8px;
            }
        }
    </style>
</head>
<body>
<c:if test="${param.error == 'existe'}">
  <script>
    alert('Ya existe un usuario con el mismo DNI o correo. No se puede repetir la información.');
  </script>
</c:if>
<script>
  document.addEventListener('DOMContentLoaded', function() {
    var forms = document.querySelectorAll('form');
    forms.forEach(function(form) {
      var dniInput = form.querySelector('input[name="dni"]');
      if (dniInput) {
        form.addEventListener('submit', function(e) {
          var dniValue = dniInput.value.trim();
          if (!/^\d{8}$/.test(dniValue)) {
            alert('El DNI debe contener exactamente 8 números.');
            dniInput.focus();
            e.preventDefault();
          }
        });
      }
    });
  });
</script>
<!-- Checkbox oculto para controlar el sidebar -->
<input type="checkbox" id="menu-toggle" class="menu-toggle" style="display:none;" />

<!-- Sidebar -->
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
    <div class="crear-coordinador-wrapper">
        <form class="crear-coordinador-form" action="${pageContext.request.contextPath}/CrearCoordinadorServlet" method="post">
            <div class="section-title"><i class="fa-solid fa-user"></i>Datos Personales</div>
            <div class="form-group">
                <i class="fa-solid fa-user"></i>
                <input type="text" name="nombre" class="form-input" placeholder="Nombre" required>
            </div>
            <div class="form-group">
                <i class="fa-solid fa-user"></i>
                <input type="text" name="apellidopaterno" class="form-input" placeholder="Apellido Paterno" required>
            </div>
            <div class="form-group">
                <i class="fa-solid fa-user"></i>
                <input type="text" name="apellidomaterno" class="form-input" placeholder="Apellido Materno" required>
            </div>
            <div class="form-group">
                <i class="fa-solid fa-id-card"></i>
                <input type="text" name="dni" class="form-input" placeholder="DNI" required>
            </div>
            <div class="form-group">
                <i class="fa-solid fa-location-dot"></i>
                <input type="text" name="direccion" class="form-input" placeholder="Dirección" required>
            </div>
            <div class="form-group">
                <i class="fa-solid fa-city"></i>
                <select id="idDistritoResidencia" name="idDistrito" class="form-input" required>
                    <option value="">Distrito de Residencia</option>
                    <c:forEach var="distrito" items="${distritos}">
                        <option value="${distrito.idDistrito}">${distrito.nombreDistrito}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <i class="fa-solid fa-envelope"></i>
                <input type="email" name="correo" class="form-input" placeholder="Correo" required>
            </div>
            <div class="form-group">
                <i class="fa-solid fa-lock"></i>
                <input type="password" name="contrasenha" class="form-input" placeholder="Contraseña" required>
            </div>
            <div class="section-title"><i class="fa-solid fa-briefcase"></i>Datos de Trabajo</div>
            <div class="form-group">
                <i class="fa-solid fa-map-marker-alt"></i>
                <select id="idZonaTrabajo" name="idZonaTrabajo" class="form-input" required>
                    <option value="">Seleccion zona de trabajo:</option>
                    <c:forEach var="zona" items="${zonas}">
                        <option value="${zona.idZona}">${zona.nombreZona}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <i class="fa-solid fa-file-alt"></i>
                <select id="idFormularioAsignado" name="idFormularioAsignado" class="form-input" required>
                    <option value="">Selecciones formulario a asignar</option>
                    <c:forEach var="formulario" items="${formularios}">
                        <option value="${formulario.idFormulario}">${formulario.titulo}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-btns">
                <button type="button" class="btn" onclick="window.history.back()"><i class="fa-solid fa-arrow-left"></i> Volver</button>
                <button type="submit" class="btn"><i class="fa-solid fa-floppy-disk"></i> Guardar</button>
            </div>
        </form>
    </div>
</main>
</body>
</html>