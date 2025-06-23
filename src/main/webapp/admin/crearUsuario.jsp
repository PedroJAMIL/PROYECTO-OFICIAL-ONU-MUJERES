<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Crear Usuario</title>
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
            --color-card-select: #ffe0e0;
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
        /* Sidebar y header: igual que dashboardAdmin.jsp */
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
        /* Selección de tipo de usuario */
        .crear-usuario-wrapper {
            background: rgba(255,255,255,0.92);
            border-radius: 24px;
            box-shadow: 0 8px 32px rgba(52, 152, 219, 0.12), 0 1.5px 8px rgba(52, 152, 219, 0.10);
            border: 2px solid #b3ccff;
            max-width: 700px;
            margin: 40px auto 32px auto;
            padding: 36px 32px 32px 32px;
            text-align: center;
        }
        .crear-usuario-title {
            font-size: 1.3em;
            font-weight: bold;
            margin-bottom: 32px;
            letter-spacing: 1px;
        }
        .tipo-usuario-grid {
            display: flex;
            justify-content: center; /* Esto centrará el único elemento que quede */
            gap: 48px;
            margin-bottom: 36px;
        }
        .tipo-usuario-card {
            background: var(--color-card-select);
            border-radius: 18px;
            padding: 28px 38px 18px 38px;
            display: flex;
            flex-direction: column;
            align-items: center;
            cursor: pointer;
            border: 3px solid transparent;
            transition: border 0.2s, box-shadow 0.2s;
            min-width: 180px;
            min-height: 180px;
            box-shadow: 0 2px 12px rgba(52, 152, 219, 0.08);
        }
        .tipo-usuario-card.selected {
            border: 3px solid var(--color-primary);
            box-shadow: 0 8px 24px rgba(52, 152, 219, 0.18);
            background: #ffeaea;
        }
        .tipo-usuario-card i {
            font-size: 3.5em;
            color: #333;
            margin-bottom: 8px; /* Reducido para acercar el label */
        }
        .tipo-usuario-label {
            font-size: 1.1em;
            font-weight: bold;
            margin-top: 0;      /* Quitado el espacio superior */
            margin-bottom: 0;   /* Quitado el espacio inferior */
            letter-spacing: 0.5px;
        }
        .crear-usuario-btns {
            display: flex;
            justify-content: center; /* Volvemos a centrar los ítems dentro del contenedor */
            gap: 250px; /* Ajusta este valor (ej. 40px, 80px, etc.) */
            margin-top: 24px;
        }
        .btn {
            background: var(--color-btn);
            color: #fff;
            border: none;
            border-radius: 8px;
            padding: 12px 38px;
            font-size: 1em;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.2s, box-shadow 0.2s;
            box-shadow: 0 2px 8px rgba(52, 152, 219, 0.10);
        }
        .btn:hover {
            background: var(--color-btn-hover);
        }
        @media (max-width: 700px) {
            .tipo-usuario-grid {
                flex-direction: column;
                gap: 24px;
            }
            .crear-usuario-wrapper {
                padding: 18px 8px;
            }
        }
    </style>
</head>
<body>
<input type="checkbox" id="menu-toggle" class="menu-toggle" style="display:none;" />

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

<main class="contenedor-principal">
    <div class="crear-usuario-wrapper">
        <div class="crear-usuario-title">SELECCIONE EL TIPO DE USUARIO</div>
        <form action="CrearCoordinadorServlet" method="post" id="formSeleccionUsuario">
            <input type="hidden" name="tipoUsuario" id="tipoUsuario" value="">
            <div class="tipo-usuario-grid">
                <div class="tipo-usuario-card" id="card-coordinador" onclick="selectTipo('coordinador')">
                    <i class="fa-solid fa-user"></i>
                    <div class="tipo-usuario-label">COORDINADOR INTERNO</div>
                </div>
                <%-- Eliminado: Contenedor para el Encuestador --%>
                <%--
                <div class="tipo-usuario-card" id="card-encuestador" onclick="selectTipo('encuestador')">
                    <i class="fa-solid fa-user"></i>
                    <div class="tipo-usuario-label">ENCUESTADOR</div>
                </div>
                --%>
            </div>
            <div class="crear-usuario-btns">
                <button type="button" class="btn" onclick="window.history.back()">Volver</button>
                <button type="submit" class="btn" id="btnContinuar" disabled>Continuar</button>
            </div>
        </form>
        <script>
            function selectTipo(tipo) {
                document.getElementById('tipoUsuario').value = tipo;
                document.getElementById('card-coordinador').classList.remove('selected');
                // No hay necesidad de remover 'selected' de 'card-encuestador' ya que fue eliminada
                if(tipo === 'coordinador') {
                    document.getElementById('card-coordinador').classList.add('selected');
                }
                // No hay 'else' para 'encuestador'
                document.getElementById('btnContinuar').disabled = false;
            }
            window.onload = function() {
                // Por defecto ninguno seleccionado
                document.getElementById('tipoUsuario').value = '';
                document.getElementById('btnContinuar').disabled = true;
                document.getElementById('card-coordinador').classList.remove('selected');
                // No hay necesidad de remover 'selected' de 'card-encuestador' ya que fue eliminada
            }
            document.querySelectorAll('.card-usuario').forEach(card => {
                card.addEventListener('click', function() {
                    document.getElementById('tipoUsuario').value = this.dataset.tipo;
                });
            });
        </script>
    </div>
</main>
</body>
</html>