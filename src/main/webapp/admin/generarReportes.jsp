<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>Generar Reporte de Encuestadores</title>
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
        }
        body {
            min-height: 100vh;
            height: 100%;
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
            padding: 10px 10px 0 32px; /* Aumenta el padding izquierdo */
            box-sizing: border-box;
            min-height: calc(100vh - 56.8px);
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
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
            height: 56.8px; /* Igual que los demás headers */
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
        /* Quitar centrado vertical y fondo azul del filtro */
        .reportes-form-row {
            display: flex;
            align-items: center;
            justify-content: flex-start;
            gap: 18px;
            margin-top: 32px;
            margin-bottom: 18px;
            flex-wrap: wrap;
            background: none;
            box-shadow: none;
            border-radius: 0;
        }
        form[style] {
            flex: 1 1 auto;
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
            min-height: 0;
        }
        .select-fechas {
            background: #c8dbff;
            border: none;
            border-radius: 12px;
            padding: 14px 22px 14px 18px;
            font-size: 1.1em;
            color: #222;
            min-width: 260px;
            outline: none;
            box-shadow: 0 2px 8px rgba(52, 152, 219, 0.08);
            appearance: none;
            position: relative;
        }
        .select-fechas:after {
            content: '';
            position: absolute;
            right: 18px;
            top: 50%;
            transform: translateY(-50%);
            border: 6px solid transparent;
            border-top: 7px solid #333;
        }
        .btn-reporte {
            background: linear-gradient(90deg, #5a9cf8 60%, #357ae8 100%);
            color: #fff;
            border: none;
            border-radius: 8px;
            padding: 8px 18px;
            font-size: 1em;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 7px;
            box-shadow: 0 2px 8px rgba(52, 152, 219, 0.13);
            transition: background 0.2s, box-shadow 0.2s;
            cursor: pointer;
        }
        .btn-reporte:hover {
            background: #357ae8;
            color: #fff;
            box-shadow: 0 4px 16px rgba(52, 152, 219, 0.18);
        }
        .reporte-preview {
            flex: 1 1 auto !important;
            min-height: 340px;
            margin-top: 24px;
            margin-bottom: 0;
            background: #b3ccff;
            border-radius: 18px;
            max-width: 100%;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.15em;
            color: #222;
            box-shadow: 0 2px 12px rgba(52, 152, 219, 0.08);
            transition: min-height 0.2s;
          }
        .btn-descargar {
            background: var(--color-btn);
            color: #fff;
            border: none;
            border-radius: 8px;
            padding: 14px 38px;
            font-size: 1.1em;
            font-weight: 500;
            cursor: pointer;
            float: right;
            margin-top: 10px;
            transition: background 0.2s, box-shadow 0.2s;
            box-shadow: 0 2px 8px rgba(52, 152, 219, 0.10);
        }
        .btn-descargar:hover {
            background: var(--color-btn-hover);
        }
        .btn-descargar.btn-descargar-mini {
            padding: 7px 14px;
            font-size: 18px;
            border-radius: 50%;
            min-width: 0;
            width: 44px;
            height: 44px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #43e97b 60%, #38f9d7 100%);
            color: #fff;
            border: none;
            box-shadow: 0 2px 8px rgba(67, 233, 123, 0.13);
            transition: background 0.2s, box-shadow 0.2s, transform 0.15s;
            cursor: pointer;
        }
        .btn-descargar.btn-descargar-mini:hover {
            background: linear-gradient(135deg, #38f9d7 60%, #43e97b 100%);
            color: #fff;
            box-shadow: 0 4px 16px rgba(67, 233, 123, 0.18);
            transform: scale(1.08) rotate(-8deg);
        }
        .contenedor {
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
            padding: 18px 18px 10px 18px;
            max-width: 98vw;
            width: 100%;
            margin: 0 auto 18px auto; /* Sin separación arriba, solo abajo */
            box-sizing: border-box;
            position: relative;
            left: 50%;
            transform: translateX(-50%);
        }
        .tabla-container {
            overflow-x: auto;
            margin-top: 0;
        }
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background: #f8faff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.04);
        }
        th, td {
            padding: 12px 10px;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
        }
        th {
            background-color: #eaf1fb;
            color: #2c3e50;
            font-weight: 700;
            text-transform: uppercase;
            font-size: 0.93em;
            letter-spacing: 0.5px;
        }
        .estado-activo {
            background-color: rgba(46, 204, 113, 0.13);
            color: #2ecc71;
            border-radius: 20px;
            padding: 5px 14px;
            font-weight: 600;
        }
        .estado-inactivo {
            background-color: rgba(231, 76, 60, 0.13);
            color: #e74c3c;
            border-radius: 20px;
            padding: 5px 14px;
            font-weight: 600;
        }
        .selector-reporte {
            margin-bottom: 10px;
        }
        .btn-reporte, .btn-descargar {
            margin-top: 0;
        }
        .filtro-centrado-vertical {
            display: flex;
            flex-direction: row;
            justify-content: flex-start;
            align-items: center;
            min-height: unset;
            margin: 0;
            background: none;
            box-shadow: none;
        }
        .dropdown-select {
            position: absolute;
            top: 110%;
            left: 0;
            z-index: 3000;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 16px rgba(52, 152, 219, 0.13);
            padding: 10px 12px 10px 12px;
            animation: fadeIn 0.18s;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        @media (max-width: 900px) {
            .contenedor-principal { padding: 8px 1vw 0 1vw; }
            .contenedor { padding: 10px 2vw 6px 2vw; }
        }
        @media (max-width: 600px) {
            .reportes-form-row { flex-direction: column; gap: 10px; align-items: stretch; }
            .btn-reporte, .btn-descargar { width: 100%; }
        }
        .btn-filtro {
            background: linear-gradient(90deg, #e6f0ff 60%, #b3ccff 100%);
            color: #357ae8;
            border: 1.5px solid #b3ccff;
            border-radius: 8px;
            padding: 8px 18px;
            font-size: 1em;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 7px;
            box-shadow: 0 2px 8px rgba(52, 152, 219, 0.08);
            transition: background 0.2s, color 0.2s, box-shadow 0.2s;
            cursor: pointer;
        }
        .btn-filtro:hover {
            background: #dbeeff;
            color: #003366;
            box-shadow: 0 4px 16px rgba(52, 152, 219, 0.13);
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
            <li><a href="CrearCoordinadorServlet"><i class="fa-solid fa-user-plus"></i> Crear nuevo usuario</a></li>
            <li><a href="GestionarCoordinadoresServlet"><i class="fa-solid fa-user-tie"></i> Gestionar Coordinadores</a></li>
            <li><a href="GestionarEncuestadoresServlet"><i class="fa-solid fa-user"></i> Gestionar Encuestadores</a></li>
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
    <div class="contenedor" style="margin-top: 0; position: relative;">
        <form method="get" action="GenerarReportesServlet" style="position: absolute; top: 18px; right: 18px; z-index: 10; margin:0;">
            <button type="submit" class="btn-descargar btn-descargar-mini" name="action" value="excel" title="Descargar Excel">
                <i class="fa-solid fa-file-excel"></i>
            </button>
        </form>
        <h2>Vista previa de Reporte de Encuestadores</h2>
        <div class="tabla-container">
            <table>
                <thead>
                    <tr>
                        <th>Nombre</th>
                        <th>Apellido Paterno</th>
                        <th>Apellido Materno</th>
                        <th>DNI</th>
                        <th>Correo electrónico</th>
                        <th>Zona</th>
                        <th>Estado</th>
                        <th>Fecha Registro</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty encuestadores}">
                            <tr>
                                <td colspan="8" style="text-align:center; color:#888; font-style:italic; background:#f5f7fa;">No se encontró información para los filtros seleccionados.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="encuestador" items="${encuestadores}">
                                <tr>
                                    <td>${encuestador.usuario.nombre}</td>
                                    <td>${encuestador.usuario.apellidopaterno}</td>
                                    <td>${encuestador.usuario.apellidomaterno}</td>
                                    <td>${encuestador.usuario.dni}</td>
                                    <td>${encuestador.credencial.correo}</td>
                                    <td>${encuestador.zonaTrabajoNombre}</td>
                                    <td>
                                        <span class="${encuestador.usuario.idEstado == 2 ? 'estado-activo' : 'estado-inactivo'}">
                                            ${encuestador.usuario.idEstado == 2 ? 'Activado' : 'Desactivado'}
                                        </span>
                                    </td>
                                    <td>${encuestador.usuario.fechaRegistro}</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</main>
</body>
</html>