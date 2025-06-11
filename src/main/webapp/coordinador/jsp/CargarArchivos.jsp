<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.webproyecto.beans.ArchivoCargado" %>

<html>
<head>
    <title>Cargar Archivos</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
        .menu-toggle:checked ~ .sidebar { left: 0; }
        .menu-toggle:checked ~ .overlay { display: block; opacity: 1; }
        .contenedor-principal {
            margin-left: 80px;
            padding: 30px 0 0 0;
            min-height: calc(100vh - 70px);
            transition: margin-left 0.3s;
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
        /* HEADER CONSISTENTE CON VerFormularios.jsp */
        .header-bar {
            background-color: #dbeeff;
            height: 56.8px;
            display: flex;
            align-items: center;
            justify-content: flex-start;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            position: relative;
            z-index: 800;
            width: 100%;
            padding: 0; /* quita padding si hay */
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
        /* Dropdown menú si lo usas */
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
        .upload-dropzone.drag-active {
            border-color: var(--color-primary); /* Cambia el color del borde al arrastrar */
            background-color: #eaf6ff; /* Cambia el fondo para feedback visual */
        }
        /* Responsive igual que VerFormularios.jsp */
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
        /* Drag & Drop */
        .upload-container {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            padding: 20px 25px 30px 25px;
            margin-bottom: 30px;
            border: 2px solid #333;
            max-width: 900px;
            margin-left: auto;
            margin-right: auto;
        }
        .upload-header {
            font-weight: bold;
            margin-bottom: 8px;
        }
        .upload-maxsize {
            float: right;
            font-size: 0.85em;
            color: #888;
        }
        .upload-dropzone {
            border: 2px dashed #95a5a6;
            border-radius: 8px;
            background: #f8fbff;
            min-height: 120px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            margin-top: 10px;
            margin-bottom: 10px;
            position: relative;
        }
        .upload-dropzone i {
            font-size: 2.5em;
            color: #3498db;
            margin-bottom: 8px;
        }
        .upload-actions {
            margin-bottom: 8px;
        }
        .upload-actions button {
            background: #3498db;
            color: #fff;
            border: none;
            border-radius: 5px;
            padding: 7px 14px;
            margin-right: 8px;
            font-size: 1em;
            cursor: pointer;
            transition: background 0.2s;
        }
        .upload-actions button:hover {
            background: #217dbb;
        }
        /* Historial de archivos */
        .historial-container {
            max-width: 900px;
            margin: 0 auto;
        }
        .historial-title {
            font-weight: bold;
            margin-bottom: 10px;
            margin-left: 5px;
        }
        .historial-list {
            background: #b3ccff;
            border-radius: 16px;
            padding: 20px 0 10px 0;
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        .historial-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: #e6f0ff;
            border-radius: 12px;
            padding: 10px 22px;
            font-size: 1.08em;
            font-weight: bold;
            color: #1a1a1a;
            margin: 0 20px;
        }
        .historial-item .progress-bar {
            flex: 1;
            height: 6px;
            background: #dbeeff;
            border-radius: 4px;
            margin: 0 18px;
            position: relative;
            overflow: hidden;
        }
        .historial-item .progress-bar-inner {
            height: 100%;
            background: #3498db;
            border-radius: 4px;
            /* width: 60%; /* Cambia según progreso - este se setea dinámicamente */
        }
        .historial-item .btn-modificar {
            background: #3498db;
            color: #fff;
            border: none;
            border-radius: 5px;
            padding: 5px 14px;
            margin-right: 10px;
            font-size: 0.98em;
            cursor: pointer;
            transition: background 0.2s;
        }
        .historial-item .btn-modificar:hover {
            background: #217dbb;
        }
        .historial-item .btn-descargar {
            background: transparent;
            border: none;
            color: #3498db;
            font-size: 1.3em;
            cursor: pointer;
            margin-left: 5px;
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
        /* Responsive */
        @media (max-width: 900px) {
            .contenedor-principal, .upload-container, .historial-container {
                max-width: 100%;
                padding: 0 5px;
            }
        }
        .contenedor-principal, .upload-container, .historial-container {
            max-width: 100%;
            width: 100%;
            margin: 0;
            padding: 30px 30px 0 30px;
            box-sizing: border-box;
        }
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
            .contenedor-principal {
                margin-left: 0 !important;
                padding: 20px 0 0 0;
            }
            .sidebar {
                width: 90vw;
                left: -90vw;
            }
            .menu-toggle:checked ~ .sidebar {
                left: 0;
            }
        }
    </style>
</head>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const dropzone = document.querySelector('.upload-dropzone');
        const fileInput = document.getElementById('fileInput');
        const uploadForm = document.getElementById('uploadForm');

        // Prevenir comportamiento por defecto para todos los eventos de arrastre
        ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
            dropzone.addEventListener(eventName, preventDefaults, false);
            document.body.addEventListener(eventName, preventDefaults, false); // También en el body para evitar que el navegador abra el archivo
        });

        function preventDefaults (e) {
            e.preventDefault();
            e.stopPropagation();
        }

        // Resaltar la zona al arrastrar (feedback visual)
        dropzone.addEventListener('dragenter', highlight, false);
        dropzone.addEventListener('dragover', highlight, false);
        dropzone.addEventListener('dragleave', unhighlight, false);
        dropzone.addEventListener('drop', unhighlight, false);

        function highlight(e) {
            dropzone.classList.add('drag-active');
        }

        function unhighlight(e) {
            dropzone.classList.remove('drag-active');
        }

        // Manejar los archivos soltados
        dropzone.addEventListener('drop', handleDrop, false);

        function handleDrop(e) {
            const dt = e.dataTransfer;
            const files = dt.files; // Obtener la lista de archivos

            if (files.length > 0) {
                // Asignar los archivos al input de tipo file
                fileInput.files = files;
                // Enviar el formulario
                uploadForm.submit();
            }
        }

        // La funcionalidad del botón "Subir archivo" ya está conectada al input file
        // a través del atributo onclick en los botones en el HTML.
    });
</script>
<body>
<input type="checkbox" id="menu-toggle" class="menu-toggle" style="display:none;" />

<div class="sidebar">
    <div class="sidebar-content">
        <div class="sidebar-separator"></div>
        <ul class="menu-links">
            <li><a href="${pageContext.request.contextPath}/DashboardServlet"><i class="fa-solid fa-chart-line"></i> Ver Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/GestionEncuestadoresServlet"><i class="fa-solid fa-users"></i> Gestionar Encuestadores</a></li>
            <li><a href="${pageContext.request.contextPath}/GestionarFormulariosServlet"><i class="fa-solid fa-file-alt"></i> Gestionar Formularios</a></li>
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
                    ${sessionScope.nombre}
                </span>
                <div class="dropdown-menu">
                    <a href="${pageContext.request.contextPath}/VerPerfilServlet">Ver perfil</a>
                    <a href="${pageContext.request.contextPath}/CerrarSesionServlet">Cerrar sesión</a>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/InicioEncuestadorServlet" class="nav-item" id="btn-inicio">
                <img src="${pageContext.request.contextPath}/imagenes/inicio.png" alt="Icono de inicio" class="nav-icon" />
            </a>
        </nav>
    </div>
</header>

<main class="contenedor-principal">
    <c:if test="${not empty sessionScope.mensajeExito}">
        <script>
            Swal.fire({
                icon: 'success',
                title: '¡Éxito!',
                text: '${sessionScope.mensajeExito}',
                confirmButtonText: 'Aceptar'
            });
        </script>
        <c:remove var="mensajeExito" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.mensajeError}">
        <script>
            Swal.fire({
                icon: 'error',
                title: '¡Error!',
                text: '${sessionScope.mensajeError}',
                confirmButtonText: 'Aceptar'
            });
        </script>
        <c:remove var="mensajeError" scope="session"/>
    </c:if>

    <form action="${pageContext.request.contextPath}/CargarArchivosServlet" method="post" enctype="multipart/form-data" id="uploadForm">
        <input type="file" id="fileInput" name="archivo" style="display: none;" onchange="this.form.submit();" />
        <div class="upload-container">
            <div class="upload-header">
                Archivos
                <span class="upload-maxsize">Tamaño máximo de archivo: 10MB</span>
            </div>
            <div class="upload-actions">
                <button type="button" title="Nuevo archivo" onclick="document.getElementById('fileInput').click();"><i class="fa-solid fa-file"></i></button>
                <button type="button" title="Subir archivo" onclick="document.getElementById('fileInput').click();"><i class="fa-solid fa-upload"></i></button>
            </div>
            <div class="upload-dropzone">
                <i class="fa-solid fa-arrow-down"></i>
                <div>Puedes arrastrar y soltar archivos aquí para añadirlos</div>
                <p style="margin-top: 10px; font-size: 0.9em; color: #666;">O haz clic en "Subir archivo" para seleccionar</p>
            </div>
        </div>
    </form>

    <div class="historial-container">
        <div class="historial-title">HISTORIAL DE ARCHIVOS</div>
        <c:if test="${empty historialArchivos}">
            <p style="text-align: center; color: #555;">No hay archivos cargados aún.</p>
        </c:if>
        <c:if test="${not empty historialArchivos}">
            <div class="historial-list">
                <c:forEach var="archivo" items="${historialArchivos}">
                    <div class="historial-item">
                        <span>
                            ${archivo.nombreArchivoOriginal}
                            <small style="display: block; font-size: 0.7em; color: #555; font-weight: normal;">
                                Cargado: ${archivo.fechaCarga} - Estado: ${archivo.estadoProcesamiento}
                            </small>
                        </span>
                        <div class="progress-bar">
                            <div class="progress-bar-inner" style="width: <c:choose>
                            <c:when test="${archivo.estadoProcesamiento == 'COMPLETADO'}">100%</c:when>
                            <c:when test="${archivo.estadoProcesamiento == 'EN_PROCESO'}">60%</c:when>
                            <c:when test="${archivo.estadoProcesamiento == 'PENDIENTE'}">30%</c:when>
                            <c:otherwise>0%</c:otherwise>
                                    </c:choose>"></div>
                        </div>
                        <button class="btn-modificar">Modificar</button>
                        <a href="${pageContext.request.contextPath}/DownloadServlet?file=${archivo.rutaGuardado}" class="btn-descargar" title="Descargar"><i class="fa-solid fa-download"></i></a>
                    </div>
                </c:forEach>
            </div>
        </c:if>
        <div class="pagination">
            <span>&lt;</span>
            <span class="active">1</span> <%-- Asumiendo una paginación simple, puedes expandir esto --%>
            <span>2</span>
            <span>3</span>
            <span>4</span>
            <span>&gt;</span>
        </div>
    </div>
</main>
</body>
</html>