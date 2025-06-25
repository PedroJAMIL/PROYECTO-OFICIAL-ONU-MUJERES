<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies
%>

<html>
<head>
    <title>Dashboard Administrador</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --color-primary: #3498db;
            --color-bg: #f5f7fa;
            --color-card: #c8dbff;
            --color-card-inner: #e6f0ff;
            --sidebar-bg: #e6f0ff;
            --header-bg: #dbeeff;
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
        /* DASHBOARD GRID */
        .dashboard-wrapper {
            background: rgba(255,255,255,0.85);
            border-radius: 24px;
            box-shadow: 0 8px 32px rgba(52, 152, 219, 0.12), 0 1.5px 8px rgba(52, 152, 219, 0.10);
            border: 2px solid #b3ccff;
            padding: 36px 32px 32px 32px;
            max-width: 1200px;
            margin: 40px auto 32px auto;
            transition: box-shadow 0.2s;
        }
        .dashboard-grid {
            display: grid;
            grid-template-columns: 320px 1fr;
            grid-template-rows: 1fr 1fr;
            gap: 32px;
            padding: 16px 0;
            margin: 0;
            background: transparent;
            border-radius: 18px;
            box-shadow: none;
        }
        .dashboard-card {
            background: #e6f0ff;
            border-radius: 16px;
            box-shadow: 0 2px 12px rgba(52, 152, 219, 0.08);
            border: 1.5px solid #c8dbff;
            padding: 24px 18px 24px 18px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-start;
            font-size: 1.15em;
            font-weight: 500;
            color: #222;
            min-height: 220px;
            min-width: 0;
            box-sizing: border-box;
            overflow: hidden;
            word-break: break-word;
        }
        .card-title {
            font-size: 1.1em;
            font-weight: bold;
            margin-bottom: 10px;
            text-align: center;
            word-break: break-word;
            line-height: 1.2;
            max-width: 100%;
        }
        .card-number {
            font-size: 2.2em;
            font-weight: bold;
            margin-bottom: 10px;
            color: #3498db;
            word-break: break-word;
        }
        .pie-container {
            width: 100px;
            height: 100px;
            margin: 0 auto 0 auto;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        /* El gráfico ocupa dos filas */
        .card-grafico-usuarios {
            grid-row: 1 / span 2;
            grid-column: 2 / 3;
            display: flex;
            flex-direction: column;
            justify-content: center;
            min-height: 100%;
            height: 100%;
            /* Ajusta el padding para más espacio interno */
            padding: 32px 32px 32px 32px;
        }
        .bar-container {
            width: 100%;
            max-width: 1000px;
            height: 500px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        @media (max-width: 1100px) {
            .dashboard-grid {
                grid-template-columns: 1fr;
                grid-template-rows: auto auto auto;
                gap: 24px;
                padding: 8px 0;
            }
            .dashboard-card {
                min-width: unset;
                min-height: 160px;
                padding: 18px 8px;
            }
        }
        @media (max-width: 700px) {
            .dashboard-grid {
                gap: 14px;
                padding: 4px 0;
            }
            .dashboard-card {
                padding: 12px 4px;
            }
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
    <div class="dashboard-grid">
        <!-- Primer cuadro arriba a la izquierda -->
        <div class="dashboard-card card-encuestadores">
            <div class="card-title">Número de encuestadores activos</div>
            <div class="card-number" id="numEncuestadoresActivos">0</div>
            <div class="pie-container">
                <canvas id="pieEncuestadores"></canvas>
            </div>
        </div>
        <!-- Segundo cuadro abajo a la izquierda -->
        <div class="dashboard-card card-coordinadores">
            <div class="card-title">Número de coordinadores internos activos</div>
            <div class="card-number" id="numCoordinadoresActivos">0</div>
            <div class="pie-container">
                <canvas id="pieCoordinadores"></canvas>
            </div>
        </div>
        <!-- Gráfico a la derecha ocupando dos filas -->
        <div class="dashboard-card card-grafico-usuarios">
            <div class="card-title">Gráfico de usuarios por día en los últimos 7 días</div>
            <div class="bar-container">
                <canvas id="barUsuarios"></canvas>
            </div>
        </div>
    </div>
</main>
<script>
    // Simulación de datos (reemplaza por tus datos reales desde el backend)
    // Puedes pasar estos datos desde el backend usando JSTL o JSON generado en el JSP
    const encuestadores = {
        activos: 35,
        desactivados: 10
    };
    const coordinadores = {
        activos: 8,
        desactivados: 2
    };
    // Simulación de usuarios activos por día (últimos 7 días)
    // Cada elemento es la suma de encuestadores + coordinadores activos ese día
    const usuariosPorDia = {
        labels: [
            "Lun", "Mar", "Mié", "Jue", "Vie", "Sáb", "Dom"
        ],
        data: [38, 40, 41, 39, 42, 43, 40]
    };

    // Mostrar números
    document.addEventListener("DOMContentLoaded", function() {
        document.getElementById("numEncuestadoresActivos").textContent = encuestadores.activos;
        document.getElementById("numCoordinadoresActivos").textContent = coordinadores.activos;

        // Pie Encuestadores
        new Chart(document.getElementById('pieEncuestadores'), {
            type: 'doughnut',
            data: {
                labels: ['Activos', 'Desactivados'],
                datasets: [{
                    data: [encuestadores.activos, encuestadores.desactivados],
                    backgroundColor: ['#2ecc71', '#e74c3c'],
                    borderWidth: 1
                }]
            },
            options: {
                cutout: '70%',
                plugins: {
                    legend: { display: true, position: 'bottom' }
                }
            }
        });

        // Pie Coordinadores
        new Chart(document.getElementById('pieCoordinadores'), {
            type: 'doughnut',
            data: {
                labels: ['Activos', 'Desactivados'],
                datasets: [{
                    data: [coordinadores.activos, coordinadores.desactivados],
                    backgroundColor: ['#2ecc71', '#e74c3c'],
                    borderWidth: 1
                }]
            },
            options: {
                cutout: '70%',
                plugins: {
                    legend: { display: true, position: 'bottom' }
                }
            }
        });

        // Bar Usuarios por día
        new Chart(document.getElementById('barUsuarios'), {
            type: 'bar',
            data: {
                labels: usuariosPorDia.labels,
                datasets: [{
                    label: 'Usuarios activos',
                    data: usuariosPorDia.data,
                    backgroundColor: '#3498db',
                    borderRadius: 8,
                    maxBarThickness: 38
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { display: false }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: { stepSize: 1 }
                    }
                }
            }
        });
    });
</script>
</body>
</html>
