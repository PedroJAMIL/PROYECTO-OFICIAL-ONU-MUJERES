<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.util.*" %>
<%
    // Procesar datos del gráfico de líneas para JavaScript
    List<Map<String, Object>> datosGraficoLineas = (List<Map<String, Object>>) request.getAttribute("datosGraficoLineas");
    Map<String, Map<Integer, Integer>> datosPorZona = new HashMap<>();

    if (datosGraficoLineas != null && !datosGraficoLineas.isEmpty()) {
        for (Map<String, Object> dato : datosGraficoLineas) {
            String zona = (String) dato.get("zona");
            Integer mes = (Integer) dato.get("mes");
            Integer cantidad = (Integer) dato.get("formularios_completados");

            if (!datosPorZona.containsKey(zona)) {
                datosPorZona.put(zona, new HashMap<>());
            }
            datosPorZona.get(zona).put(mes, cantidad);
        }
    }

    // Crear JSON para JavaScript
    StringBuilder jsonDatos = new StringBuilder("{");
    boolean primera = true;
    for (Map.Entry<String, Map<Integer, Integer>> entry : datosPorZona.entrySet()) {
        if (!primera) jsonDatos.append(",");
        jsonDatos.append("'").append(entry.getKey()).append("':[");

        for (int mes = 1; mes <= 12; mes++) {
            if (mes > 1) jsonDatos.append(",");
            Integer valor = entry.getValue().get(mes);
            jsonDatos.append(valor != null ? valor : 0);
        }
        jsonDatos.append("]");
        primera = false;
    }
    jsonDatos.append("}");

    // DEBUG: Agregar logs para ver qué se está generando
    System.out.println("=== DEBUG JSP DASHBOARD ===");
    System.out.println("datosGraficoLineas size: " + (datosGraficoLineas != null ? datosGraficoLineas.size() : "null"));
    System.out.println("datosPorZona size: " + datosPorZona.size());
    System.out.println("JSON generado: " + jsonDatos.toString());
    
    for (Map.Entry<String, Map<Integer, Integer>> entry : datosPorZona.entrySet()) {
        System.out.println("Zona: '" + entry.getKey() + "' -> " + entry.getValue());
    }
    
    request.setAttribute("jsonDatosGrafico", jsonDatos.toString());
%>
<html>
<head>
    <title>Dashboard Administrador</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>    <style>
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
        overflow: hidden; /* Ocultar tanto horizontal como vertical */
        height: 100vh;
    }

    .menu-toggle:checked ~ .sidebar { left: 0; }
    .menu-toggle:checked ~ .overlay { display: block; opacity: 1; }
    .contenedor-principal {
        width: 100%;
        margin: 0;
        padding: 15px 20px 15px 20px; /* Reducir padding */
        box-sizing: border-box;
        height: calc(100vh - 56.8px);
        overflow-y: hidden; /* Ocultar scroll vertical */
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
    }        /* DASHBOARD GRID */        .dashboard-wrapper {
                                             background: rgba(255,255,255,0.95);
                                             border-radius: 24px;
                                             box-shadow: 0 8px 32px rgba(52, 152, 219, 0.12), 0 1.5px 8px rgba(52, 152, 219, 0.10);
                                             border: 2px solid #b3ccff;
                                             padding: 12px 20px 15px 20px; /* Reducir padding */
                                             max-width: 1400px;
                                             margin: 0 auto;
                                             transition: box-shadow 0.2s;
                                             height: calc(100vh - 116.8px); /* Volver a height fijo */
                                         }.dashboard-grid {
                                              display: grid;
                                              grid-template-columns: 0.6fr 1.4fr;
                                              grid-template-rows: 1fr 1fr;
                                              gap: 15px; /* Reducir gap */
                                              padding: 0;
                                              height: calc(100vh - 200px); /* Reducir altura */
                                              align-items: stretch;
                                          }        .main-chart-container {
                                                       background: #ffffff;
                                                       border-radius: 16px;
                                                       box-shadow: 0 4px 20px rgba(52, 152, 219, 0.08);
                                                       border: 1px solid #e1ecf4;
                                                       padding: 10px 12px 12px 12px; /* Reducir padding */
                                                       text-align: center;
                                                       display: flex;
                                                       flex-direction: column;
                                                       align-items: center;
                                                       justify-content: center;
                                                       height: 100%;
                                                       min-height: 220px; /* Reducir altura mínima */
                                                   }.future-chart-container {
                                                        background: #ffffff;
                                                        border-radius: 16px;
                                                        box-shadow: 0 4px 20px rgba(52, 152, 219, 0.08);
                                                        border: 1px solid #e1ecf4;
                                                        padding: 20px;
                                                        text-align: center;
                                                        display: flex;
                                                        align-items: center;
                                                        justify-content: center;
                                                        color: #ccc;
                                                        font-size: 1.1rem;
                                                        min-height: 300px;
                                                    }        .bar-chart-container {
                                                                 background: #ffffff;
                                                                 border-radius: 16px;
                                                                 box-shadow: 0 4px 20px rgba(52, 152, 219, 0.08);
                                                                 border: 1px solid #e1ecf4;
                                                                 padding: 10px 15px 15px 15px; /* Reducir padding */
                                                                 text-align: center;
                                                                 display: flex;
                                                                 flex-direction: column;
                                                                 align-items: center;
                                                                 justify-content: center;
                                                                 height: 100%;
                                                                 min-height: 460px; /* Reducir altura mínima considerablemente */
                                                             }        .chart-title {
                                                                          font-size: 1rem; /* Reducir tamaño de título */
                                                                          font-weight: bold;
                                                                          color: #333;
                                                                          margin: 0 0 2px 0; /* Reducir margen */
                                                                      }        .chart-container {
                                                                                   position: relative;
                                                                                   height: 150px; /* Reducir altura */
                                                                                   width: 100%;
                                                                                   max-width: 180px; /* Reducir ancho máximo */
                                                                                   margin: 0 auto 8px auto; /* Reducir margen */
                                                                                   display: flex;
                                                                                   align-items: center;
                                                                                   justify-content: center;
                                                                               }
    .bar-chart-container .chart-container {
        height: calc(100% - 60px); /* Reducir altura considerando menos espacio */
        max-width: 100%;
        width: 100%;
        margin: 0 auto 10px auto; /* Reducir margen */
    }        .chart-legend {
                 display: flex;
                 justify-content: center;
                 gap: 10px; /* Reducir gap */
                 margin-top: 8px; /* Reducir margen */
                 margin-bottom: 5px; /* Reducir margen */
                 flex-wrap: wrap;
                 padding: 0 8px; /* Reducir padding */
             }        .legend-item {
                          display: flex;
                          align-items: center;
                          gap: 5px; /* Reducir gap */
                          font-size: 0.85rem; /* Reducir tamaño de fuente */
                      }.legend-color {
                           width: 10px; /* Reducir tamaño */
                           height: 10px; /* Reducir tamaño */
                           border-radius: 2px;
                       }@media (max-width: 1100px) {
        .dashboard-grid {
            grid-template-columns: 1fr;
            grid-template-rows: auto auto auto;
            gap: 12px;
            height: auto;
        }
        .dashboard-wrapper {
            padding: 12px 15px 15px 15px;
            height: auto;
        }
        .contenedor-principal {
            padding: 12px 15px 15px 15px;
            overflow-y: auto;
        }
        .bar-chart-container {
            grid-row: auto !important;
            min-height: 320px; /* Reducir altura para móvil */
        }
        .main-chart-container {
            min-height: 200px; /* Reducir altura para móvil */
        }
    }        @media (max-width: 700px) {
        .chart-legend {
            gap: 8px;
            margin-top: 6px;
            margin-bottom: 4px;
        }
        .chart-container {
            height: 140px; /* Reducir más para móvil */
            max-width: 160px;
            margin-bottom: 6px;
        }
        .dashboard-wrapper {
            padding: 10px 12px 15px 12px;
            height: auto;
        }
        .contenedor-principal {
            padding: 8px 10px 12px 10px;
            overflow-y: auto;
        }
        .dashboard-grid {
            grid-template-columns: 1fr;
            grid-template-rows: auto auto auto;
            gap: 10px;
        }
        .bar-chart-container {
            grid-row: auto !important;
            min-height: 280px;
            padding: 10px 8px 15px 8px;
        }
        .main-chart-container {
            min-height: 180px;
            padding: 8px 6px 10px 6px;
        }
        .chart-title {
            font-size: 0.9rem;
        }
        .legend-item {
            font-size: 0.8rem;
            gap: 4px;
        }
        .export-btn {
            padding: 8px 16px;
            font-size: 12px;
        }
    }    /* Estilos para el botón de exportar */
    
    .export-section {
        padding: 8px 0 10px 0;
        border-bottom: 2px solid #e1ecf4;
        margin-bottom: 15px;
        display: flex;
        justify-content: flex-end; /* Volver a flex-end para centrar a la derecha */
        align-items: center;
    }
    
    .export-btn {
        background: linear-gradient(135deg, #27ae60 0%, #2ecc71 100%);
        color: white;
        border: none;
        padding: 10px 20px;
        border-radius: 8px;
        font-size: 13px;
        font-weight: bold;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 4px 15px rgba(39, 174, 96, 0.3);
        display: inline-flex;
        align-items: center;
        gap: 6px;
    }

    .export-btn:hover {
        background: linear-gradient(135deg, #229954 0%, #27ae60 100%);
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(39, 174, 96, 0.4);
    }

    .export-btn:active {
        transform: translateY(0);
        box-shadow: 0 4px 15px rgba(39, 174, 96, 0.3);
    }

    .export-btn:disabled {
        opacity: 0.7;
        cursor: not-allowed;
        transform: none;
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
    <div class="dashboard-wrapper">
        <!-- BARRA SUPERIOR SOLO CON BOTÓN DE EXPORTAR -->
        <div class="export-section" style="margin-bottom: 15px; display: flex; justify-content: flex-end; align-items: center;">
            <!-- Botón de exportar -->
            <button id="exportarReporte" class="export-btn" onclick="exportarReporteDashboard()">
                <i class="fas fa-file-excel"></i>
                Generar Reporte Excel
            </button>
        </div>
        
        <div class="dashboard-grid">
            <!-- Gráfico de Encuestadores -->
            <div class="main-chart-container" style="grid-column: 1; grid-row: 1;">
                <h3 class="chart-title">Encuestadores</h3>
                <div class="chart-container">
                    <canvas id="encuestadoresChart"></canvas>
                </div>
                <div class="chart-legend" id="encuestadoresLegend">
                    <!-- La leyenda se generará dinámicamente con JavaScript -->
                </div>
            </div>

            <!-- Gráfico de Coordinadores -->
            <div class="main-chart-container" style="grid-column: 1; grid-row: 2;">
                <h3 class="chart-title">Coordinadores</h3>
                <div class="chart-container">
                    <canvas id="coordinadoresChart"></canvas>
                </div>
                <div class="chart-legend" id="coordinadoresLegend">
                    <!-- La leyenda se generará dinámicamente con JavaScript -->
                </div>
            </div>

            <!-- Gráfico de líneas para formularios por zona -->
            <div class="bar-chart-container" style="grid-column: 2; grid-row: 1 / -1;">
                <h3 class="chart-title">Formularios por Zona Geográfica</h3>
                <div class="chart-container">
                    <canvas id="barChart"></canvas>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
    // Datos dinámicos desde el backend
    const encuestadores = {
        activos: Number('${encuestadoresActivos}') || 0,
        inactivos: Number('${encuestadoresDesactivos}') || 0
    };
    const coordinadores = {
        activos: Number('${coordinadoresActivos}') || 0,
        inactivos: Number('${coordinadoresDesactivos}') || 0
    };

    // Datos del gráfico
    const datosReales = <c:out value="${jsonDatosGrafico}" escapeXml="false" />;
    const datosAUsar = datosReales;
    
    // Variables globales para los gráficos
    let chartEncuestadores, chartCoordinadores, chartFormularios;

    console.log('=== DATOS INICIALES ===');
    console.log('Encuestadores:', encuestadores);
    console.log('Coordinadores:', coordinadores);
    console.log('Datos gráfico:', datosAUsar);
    console.log('Zonas disponibles:', Object.keys(datosAUsar));

    document.addEventListener("DOMContentLoaded", function() {
        // Crear todos los gráficos
        crearGraficos();
    });

    function crearGraficos() {
        crearGraficoEncuestadores();
        crearGraficoCoordinadores();
        crearGraficoFormularios();
    }

    function crearGraficoEncuestadores() {
        const encCtx = document.getElementById('encuestadoresChart').getContext('2d');
        
        // Destruir gráfico existente
        if (chartEncuestadores) {
            chartEncuestadores.destroy();
        }
        
        if (encuestadores.activos + encuestadores.inactivos === 0) {
            const container = document.querySelector('#encuestadoresChart').parentNode;
            container.innerHTML = '<div style="display: flex; align-items: center; justify-content: center; height: 100%; color: #666; font-size: 0.9rem;">No hay datos de encuestadores</div>';
            return;
        }

        // Plugin para mostrar el número total en el centro
        const centerTextPlugin = {
            id: 'centerText',
            beforeDraw: function(chart) {
                if (chart.config.type === 'doughnut') {
                    const width = chart.width;
                    const height = chart.height;
                    const ctx = chart.ctx;

                    ctx.restore();
                    const fontSize = (height / 114).toFixed(2);
                    ctx.font = fontSize + "em sans-serif";
                    ctx.textBaseline = "middle";
                    ctx.fillStyle = "#333";

                    const total = chart.config.data.datasets[0].data.reduce((a, b) => a + b, 0);
                    const text = total.toString();
                    const textX = Math.round((width - ctx.measureText(text).width) / 2);
                    const textY = height / 2;

                    ctx.fillText(text, textX, textY);
                    ctx.save();
                }
            }
        };

        chartEncuestadores = new Chart(encCtx, {
            type: 'doughnut',
            data: {
                labels: ['Activos', 'Inactivos'],
                datasets: [{
                    data: [encuestadores.activos, encuestadores.inactivos],
                    backgroundColor: ['#27ae60', '#e74c3c'],
                    borderColor: ['#ffffff', '#ffffff'],
                    borderWidth: 3,
                    hoverBorderWidth: 5,
                    hoverBorderColor: '#ffffff'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                cutout: '60%',
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0,0,0,0.9)',
                        titleColor: '#ffffff',
                        bodyColor: '#ffffff',
                        borderColor: '#3498db',
                        borderWidth: 2,
                        cornerRadius: 10,
                        padding: 12,
                        displayColors: true,
                        titleFont: { size: 14, weight: 'bold' },
                        bodyFont: { size: 13 },
                        callbacks: {
                            title: function(context) {
                                return 'Encuestadores ' + context[0].label;
                            },
                            label: function(context) {
                                const value = context.parsed;
                                return 'Cantidad: ' + value + ' usuarios';
                            }
                        }
                    }
                },
                animation: {
                    animateRotate: true,
                    duration: 1000,
                    easing: 'easeInOutQuart'
                },
                hover: { animationDuration: 300 }
            },
            plugins: [centerTextPlugin]
        });

        // Crear leyenda
        crearLeyenda('encuestadoresLegend', 
            [encuestadores.activos, encuestadores.inactivos], 
            ['#27ae60', '#e74c3c'], 
            ['Activos', 'Inactivos']
        );
    }

    function crearGraficoCoordinadores() {
        const coordCtx = document.getElementById('coordinadoresChart').getContext('2d');
        
        // Destruir gráfico existente
        if (chartCoordinadores) {
            chartCoordinadores.destroy();
        }
        
        if (coordinadores.activos + coordinadores.inactivos === 0) {
            const container = document.querySelector('#coordinadoresChart').parentNode;
            container.innerHTML = '<div style="display: flex; align-items: center; justify-content: center; height: 100%; color: #666; font-size: 0.9rem;">No hay datos de coordinadores</div>';
            return;
        }

        // Plugin para mostrar el número total en el centro
        const centerTextPlugin = {
            id: 'centerText',
            beforeDraw: function(chart) {
                if (chart.config.type === 'doughnut') {
                    const width = chart.width;
                    const height = chart.height;
                    const ctx = chart.ctx;

                    ctx.restore();
                    const fontSize = (height / 114).toFixed(2);
                    ctx.font = fontSize + "em sans-serif";
                    ctx.textBaseline = "middle";
                    ctx.fillStyle = "#333";

                    const total = chart.config.data.datasets[0].data.reduce((a, b) => a + b, 0);
                    const text = total.toString();
                    const textX = Math.round((width - ctx.measureText(text).width) / 2);
                    const textY = height / 2;

                    ctx.fillText(text, textX, textY);
                    ctx.save();
                }
            }
        };

        chartCoordinadores = new Chart(coordCtx, {
            type: 'doughnut',
            data: {
                labels: ['Activos', 'Inactivos'],
                datasets: [{
                    data: [coordinadores.activos, coordinadores.inactivos],
                    backgroundColor: ['#3498db', '#f39c12'],
                    borderColor: ['#ffffff', '#ffffff'],
                    borderWidth: 3,
                    hoverBorderWidth: 5,
                    hoverBorderColor: '#ffffff'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                cutout: '60%',
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0,0,0,0.9)',
                        titleColor: '#ffffff',
                        bodyColor: '#ffffff',
                        borderColor: '#3498db',
                        borderWidth: 2,
                        cornerRadius: 10,
                        padding: 12,
                        displayColors: true,
                        titleFont: { size: 14, weight: 'bold' },
                        bodyFont: { size: 13 },
                        callbacks: {
                            title: function(context) {
                                return 'Coordinadores ' + context[0].label;
                            },
                            label: function(context) {
                                const value = context.parsed;
                                return 'Cantidad: ' + value + ' usuarios';
                            }
                        }
                    }
                },
                animation: {
                    animateRotate: true,
                    duration: 1000,
                    easing: 'easeInOutQuart'
                },
                hover: { animationDuration: 300 }
            },
            plugins: [centerTextPlugin]
        });

        // Crear leyenda
        crearLeyenda('coordinadoresLegend', 
            [coordinadores.activos, coordinadores.inactivos], 
            ['#3498db', '#f39c12'], 
            ['Activos', 'Inactivos']
        );
    }

    function crearGraficoFormularios() {
        const barCtx = document.getElementById('barChart').getContext('2d');
        
        // Destruir gráfico existente
        if (chartFormularios) {
            chartFormularios.destroy();
        }

        // Obtener todas las zonas
        const zonasAMostrar = Object.keys(datosAUsar);

        if (zonasAMostrar.length === 0) {
            const chartContainer = document.querySelector('.bar-chart-container .chart-container');
            chartContainer.innerHTML = '<div style="display: flex; align-items: center; justify-content: center; height: 100%; color: #666; font-size: 1.1rem;">No hay datos disponibles para mostrar</div>';
            return;
        }

        const colores = ['#e74c3c', '#27ae60', '#3498db', '#f39c12', '#9b59b6', '#e67e22', '#1abc9c', '#34495e'];

        const datasets = zonasAMostrar.map((zona, index) => ({
            label: zona,
            data: Array.from({length: 12}, (_, mes) => {
                if (datosAUsar[zona] && datosAUsar[zona][mes] !== undefined) {
                    return datosAUsar[zona][mes];
                }
                return 0;
            }),
            borderColor: colores[index % colores.length],
            backgroundColor: colores[index % colores.length].replace('rgb', 'rgba').replace(')', ', 0.1)'),
            borderWidth: 3,
            pointBackgroundColor: colores[index % colores.length],
            pointBorderColor: '#ffffff',
            pointBorderWidth: 2,
            pointRadius: 6,
            pointHoverRadius: 8,
            tension: 0.4
        }));

        chartFormularios = new Chart(barCtx, {
            type: 'line',
            data: {
                labels: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'],
                datasets: datasets
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                interaction: {
                    intersect: false,
                    mode: 'index'
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 80,
                        ticks: {
                            stepSize: 10,
                            color: '#666',
                            font: { size: 11 }
                        },
                        grid: {
                            color: '#e1e1e1',
                            lineWidth: 1
                        },
                        title: {
                            display: true,
                            text: 'Cantidad de Formularios',
                            color: '#666',
                            font: { size: 12, weight: 'bold' }
                        }
                    },
                    x: {
                        ticks: {
                            color: '#666',
                            font: { size: 11 }
                        },
                        grid: {
                            color: '#e1e1e1',
                            lineWidth: 1
                        },
                        title: {
                            display: true,
                            text: 'Meses del Año',
                            color: '#666',
                            font: { size: 12, weight: 'bold' }
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: true,
                        position: 'bottom',
                        labels: {
                            usePointStyle: true,
                            pointStyle: 'circle',
                            padding: 15,
                            font: {
                                size: 12,
                                weight: 'normal'
                            }
                        }
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0,0,0,0.8)',
                        titleColor: '#ffffff',
                        bodyColor: '#ffffff',
                        borderColor: '#3498db',
                        borderWidth: 1,
                        cornerRadius: 8,
                        callbacks: {
                            title: function(context) {
                                return context[0].label;
                            },
                            label: function(context) {
                                return context.dataset.label + ': ' + (context.parsed.y || 'Sin datos') + ' formularios';
                            }
                        }
                    }
                },
                animation: {
                    duration: 1000,
                    easing: 'easeInOutQuart'
                },
                hover: {
                    animationDuration: 300
                }
            }
        });
    }

    function crearLeyenda(containerId, data, colors, labels) {
        const container = document.getElementById(containerId);
        container.innerHTML = '';

        data.forEach((value, index) => {
            const legendItem = document.createElement('div');
            legendItem.className = 'legend-item';

            const colorBox = document.createElement('div');
            colorBox.className = 'legend-color';
            colorBox.style.backgroundColor = colors[index];

            const text = document.createElement('span');
            text.textContent = labels[index] + ': (' + value + ')';

            legendItem.appendChild(colorBox);
            legendItem.appendChild(text);
            container.appendChild(legendItem);
        });
    }

    // Función para exportar el reporte del dashboard
    function exportarReporteDashboard() {
        const btn = document.getElementById('exportarReporte');
        const originalText = btn.innerHTML;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Generando...';
        btn.disabled = true;
        
        console.log('=== INICIANDO EXPORTACIÓN ===');
        console.log('Encuestadores:', encuestadores);
        console.log('Coordinadores:', coordinadores);
        console.log('Datos gráfico disponibles:', datosAUsar);
        
        try {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = 'ExportarReporteDashboardServlet';
            form.target = '_blank';
            form.style.display = 'none';
            
            const campos = {
                'encuestadoresActivos': encuestadores.activos || 0,
                'encuestadoresInactivos': encuestadores.inactivos || 0,
                'coordinadoresActivos': coordinadores.activos || 0,
                'coordinadoresInactivos': coordinadores.inactivos || 0,
                'datosGraficoFormularios': JSON.stringify(datosAUsar || {})
            };
            
            Object.keys(campos).forEach(key => {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = key;
                input.value = campos[key];
                form.appendChild(input);
            });
            
            document.body.appendChild(form);
            form.submit();
            document.body.removeChild(form);
            
            setTimeout(() => {
                btn.innerHTML = '<i class="fas fa-check"></i> ¡Enviado!';
                setTimeout(() => {
                    btn.innerHTML = originalText;
                    btn.disabled = false;
                }, 2000);
            }, 1000);
            
        } catch (error) {
            console.error('Error en JavaScript:', error);
            alert('Error al generar el reporte: ' + error.message);
            btn.innerHTML = originalText;
            btn.disabled = false;
        }
    }
</script>
</body>
</html>