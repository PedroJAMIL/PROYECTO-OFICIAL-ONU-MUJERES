<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>Lista de Respuestas</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root {
            --color-primary: #3498db;
            --color-success: #2ecc71;
            --color-danger: #e74c3c;
            --color-gray: #95a5a6;
            --sidebar-bg: #e6f0ff;
            --sidebar-width: 280px;
            --sidebar-width-collapsed: 80px;
            --header-bg: #dbeeff;
            --card-bg: #b3ccff;
            --card-inner-bg: #e6f0ff;
        }
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

        .menu-toggle:checked ~ .sidebar { left: 0; }
        .menu-toggle:checked ~ .overlay { display: block; opacity: 1; }
        .contenedor-principal, .main-content {
            width: 100%;
            margin: 0;
            padding: 30px 0 0 0;
            box-sizing: border-box;
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
        /* Overlay para sidebar */
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
        /* HEADER CONSISTENTE CON CargarArchivos.jsp */
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
            padding: 0 30px; /* igual que en CargarArchivos.jsp */
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
            background: none;
            border: none;
            outline: none;
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
        /* Responsive igual que CargarArchivos.jsp */
        @media (max-width: 600px) {
            .header-bar {
                flex-direction: column;
                height: auto;
                padding: 10px;
            }
            .header-content {
                flex-direction: column;
                align-items: flex-start;
            }
            .header-right {
                margin-left: 0;
                gap: 1.2rem;
            }
        }
        /* CONTENIDO PRINCIPAL */
        .main-content {
            width: 100%;
            max-width: 100%;
            margin: 0;
            padding: 30px 30px 0 30px; /* espacio lateral igual que otros archivos */
            box-sizing: border-box;
        }
        .select-filtros {
            margin-bottom: 20px;
        }
        .select-filtros select {
            padding: 7px 12px;
            border-radius: 6px;
            border: 1px solid #b3ccff;
            font-size: 1em;
            background: #fff;
            min-width: 180px;
        }
        .encuestas-list {
            width: 100%;
            background: #b3ccff;
            border-radius: 16px;
            padding: 25px 0 18px 0;
            display: flex;
            flex-direction: column;
            gap: 18px;
            box-sizing: border-box;
        }
        .encuesta-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: #e6f0ff;
            border-radius: 12px;
            padding: 16px 22px;
            font-size: 1.1em;
            font-weight: bold;
            color: #1a1a1a;
        }
        .encuesta-nombre {
            flex: 1;
        }
        /* Switch */
        .switch {
            position: relative;
            display: inline-block;
            width: 46px;
            height: 24px;
            margin-right: 18px;
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
            transition: .4s;
            border-radius: 24px;
        }
        .slider:before {
            position: absolute;
            content: "";
            height: 18px;
            width: 18px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            transition: .4s;
            border-radius: 50%;
        }
        .switch input:checked + .slider {
            background-color: #2ecc71;
        }
        .switch input:checked + .slider:before {
            transform: translateX(22px);
        }
        /* Botón Ver Respuesta */
        .btn-respuesta {
            text-decoration: none;
            display: inline-block;
            padding: 0.5rem 1rem;
            background-color: #5e81ac;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s;
            font-size: 13.3px;
        }
        .btn-respuesta:hover {
            background-color: #4c669f;
        }
        /* Botón Ingresar Respuesta */
        .btn-ingresar {
            background: #3b5fc0;
            color: #fff;
            border: none;
            border-radius: 6px;
            padding: 7px 18px;
            font-size: 1em;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-ingresar:disabled,
        .btn-ingresar[disabled] {
            background: #f4f4f4;
            color: #888;
            cursor: not-allowed;
            border: 1px solid #ccc;
        }
        /* Paginación */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 18px 0 0 0;
            gap: 8px;
        }
        .pagination span, .pagination a {
            color: #3498db;
            font-size: 1.2em;
            margin: 0 2px;
            cursor: pointer;
            user-select: none;
        }
        .pagination .active {
            font-weight: bold;
            text-decoration: underline;
        }
        @media (max-width: 900px) {
            .main-content {
                max-width: 100%;
                padding: 0 5px;
            }
        }
    </style>
</head>
<body>
<input type="checkbox" id="menu-toggle" class="menu-toggle" hidden>

<div class="sidebar">
    <div class="sidebar-content">
        <div class="sidebar-separator"></div>
        <ul class="menu-links">
            <li><a href="${pageContext.request.contextPath}/DashboardServlet"><i class="fa-solid fa-chart-line"></i> Ver Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/GestionEncuestadoresServlet"><i class="fa-solid fa-users"></i> Gestionar Encuestadores</a></li>
            <li><a href="${pageContext.request.contextPath}/GestionarFormulariosServlet"><i class="fa-solid fa-file-alt"></i> Gestionar Formularios</a></li> <%-- Puedes cambiar el texto si quieres --%>
            <li><a href="${pageContext.request.contextPath}/CargarArchivosServlet"><i class="fa-solid fa-upload"></i> Cargar Archivos</a></li>
            <li><a href="${pageContext.request.contextPath}/CerrarSesionServlet"><i class="fa-solid fa-sign-out-alt"></i> Cerrar sesión</a></li>
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

<main class="contenedor-principal">
    <div class="main-content">
        <h2>Archivos Cargados</h2> <%-- Nuevo título para la sección --%>

        <div class="select-filtros">
            <select>
                <option value="">Filtrar por usuario (funcionalidad pendiente)</option>
                <%-- Si quisieras filtrar por usuario, necesitarías pasar una lista de usuarios desde el servlet --%>
                <%-- y ajustar el DAO para que el método obtenerArchivosCargados(int idUsuario) sea llamado con el ID seleccionado --%>
            </select>
        </div>

        <div class="encuestas-list">
            <c:choose>
                <c:when test="${not empty archivosCargados}">
                    <table style="width:100%; background:#e6f0ff; border-radius:12px;">
                        <thead>
                            <tr style="background:#b3ccff;">
                                <th style="padding:8px;">Nombre del archivo</th>
                                <th style="padding:8px;">Subido por</th>
                                <th style="padding:8px;">Fecha de subida</th>
                                <th style="padding:8px;">Ver respuestas</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="archivo" items="${archivosCargados}">
                                <tr>
                                    <td style="padding:8px;">${archivo.nombreArchivoOriginal}</td>
                                    <td style="padding:8px;">${archivo.nombreUsuarioQueCargo}</td>
                                    <td style="padding:8px;">
                                        <c:choose>
                                            <c:when test="${not empty archivo.fechaCarga}">
                                                ${fn:replace(archivo.fechaCarga, 'T', ' ')}
                                            </c:when>
                                            <c:otherwise>
                                                -
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="padding:8px; text-align:center;">
                                        <form action="${pageContext.request.contextPath}/VerContenidoExcelServlet" method="get" target="_blank" style="margin:0; display:inline-block;">
                                            <input type="hidden" name="idArchivoCargado" value="${archivo.idArchivoCargado}" />
                                            <button type="submit" class="btn-respuesta">Ver respuestas</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <p style="padding: 15px; text-align: center; color: #555;">No hay archivos cargados disponibles.</p>
                </c:otherwise>
            </c:choose>
        </div>
        <%-- La paginación necesitaría lógica adicional en el servlet y en el DAO --%>
        <div class="pagination">
            <span>&lt;</span>
            <span>2</span>
            <span class="active">3</span>
            <span>4</span>
            <span>&gt;</span>
        </div>
    </div>
</main>
</body>
</html>
