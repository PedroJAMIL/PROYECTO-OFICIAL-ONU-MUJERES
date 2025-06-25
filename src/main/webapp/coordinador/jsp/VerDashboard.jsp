<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.util.*" %>
<%
  // Procesar datos del gráfico de líneas para JavaScript
  List<Map<String, Object>> datosGraficoLineas = (List<Map<String, Object>>) request.getAttribute("datosGraficoLineas");
  Map<String, Map<Integer, Integer>> datosPorEncuestador = new HashMap<>();

  if (datosGraficoLineas != null && !datosGraficoLineas.isEmpty()) {
    for (Map<String, Object> dato : datosGraficoLineas) {
      String encuestador = (String) dato.get("encuestador");
      Integer mes = (Integer) dato.get("mes");
      Integer cantidad = (Integer) dato.get("formularios_completados");

      if (!datosPorEncuestador.containsKey(encuestador)) {
        datosPorEncuestador.put(encuestador, new HashMap<>());
      }
      datosPorEncuestador.get(encuestador).put(mes, cantidad);
    }
  }

  // Crear JSON para JavaScript
  StringBuilder jsonDatos = new StringBuilder("{");
  boolean primera = true;
  for (Map.Entry<String, Map<Integer, Integer>> entry : datosPorEncuestador.entrySet()) {
    if (!primera) jsonDatos.append(",");
    jsonDatos.append("\"").append(entry.getKey()).append("\":[");

    for (int mes = 1; mes <= 12; mes++) {
      if (mes > 1) jsonDatos.append(",");
      Integer valor = entry.getValue().get(mes);
      jsonDatos.append(valor != null ? valor : 0);
    }
    jsonDatos.append("]");
    primera = false;
  }
  jsonDatos.append("}");

  request.setAttribute("jsonDatosGrafico", jsonDatos.toString());
%>
<html>
<head>
  <title>Dashboard Coordinador</title>
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
      overflow: hidden;
      height: 100vh;
    }
    .menu-toggle:checked ~ .sidebar { left: 0; }
    .menu-toggle:checked ~ .overlay { display: block; opacity: 1; }
    .contenedor-principal {
      width: 100%;
      margin: 0;
      padding: 20px 20px 10px 20px;
      box-sizing: border-box;
      height: calc(100vh - 56.8px);
      overflow: hidden;
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
    }
    /* DASHBOARD GRID */
    .dashboard-wrapper {
      background: rgba(255,255,255,0.95);
      border-radius: 24px;
      box-shadow: 0 8px 32px rgba(52, 152, 219, 0.12), 0 1.5px 8px rgba(52, 152, 219, 0.10);
      border: 2px solid #b3ccff;
      padding: 10px 15px;
      max-width: 1400px;
      margin: 0 auto;
      transition: box-shadow 0.2s;
      height: 100%;
      overflow: hidden;
    }
    .dashboard-grid {
      display: grid;
      grid-template-columns: 0.6fr 1.4fr;
      grid-template-rows: 1fr 1fr;
      gap: 15px;
      padding: 0;
      height: 100%;
      align-items: stretch;
    }
    .main-chart-container {
      background: #ffffff;
      border-radius: 16px;
      box-shadow: 0 4px 20px rgba(52, 152, 219, 0.08);
      border: 1px solid #e1ecf4;
      padding: 12px;
      text-align: center;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      height: 100%;
    }
    .future-chart-container {
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
    }
    .bar-chart-container {
      background: #ffffff;
      border-radius: 16px;
      box-shadow: 0 4px 20px rgba(52, 152, 219, 0.08);
      border: 1px solid #e1ecf4;
      padding: 10px;
      text-align: center;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      height: 100%;
    }
    .chart-title {
      font-size: 1.1rem;
      font-weight: bold;
      color: #333;
      margin: 0 0 3px 0;
    }
    .chart-container {
      position: relative;
      height: 190px;
      width: 100%;
      max-width: 210px;
      margin: 0 auto;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .bar-chart-container .chart-container {
      height: calc(100% - 60px);
      max-width: 100%;
      width: 100%;
    }
    .chart-legend {
      display: flex;
      justify-content: center;
      gap: 12px;
      margin-top: 8px;
      flex-wrap: wrap;
    }
    .legend-item {
      display: flex;
      align-items: center;
      gap: 6px;
      font-size: 0.9rem;
    }
    .legend-color {
      width: 12px;
      height: 12px;
      border-radius: 3px;
    }
    @media (max-width: 1100px) {
      .dashboard-grid {
        grid-template-columns: 1fr;
        grid-template-rows: auto auto auto;
        gap: 10px;
      }
      .dashboard-wrapper {
        padding: 10px;
        margin: 0 auto;
        height: 100%;
      }
      .contenedor-principal {
        padding: 15px 15px 10px 15px;
      }
      .bar-chart-container {
        grid-row: auto !important;
      }
    }
    @media (max-width: 700px) {
      .chart-legend {
        gap: 10px;
      }
      .chart-container {
        height: 180px;
        max-width: 200px;
      }
      .dashboard-wrapper {
        padding: 8px;
        margin: 0 auto;
        height: 100%;
      }
      .contenedor-principal {
        padding: 10px 10px 5px 10px;
      }
      .dashboard-grid {
        grid-template-columns: 1fr;
        grid-template-rows: auto auto auto;
        gap: 8px;
      }
      .bar-chart-container {
        grid-row: auto !important;
      }
    }
    .styled-select {
      background: #e6f0ff;
      border: 1.5px solid #3498db;
      border-radius: 8px;
      padding: 6px 12px;
      font-size: 1em;
      color: #333;
      box-shadow: 0 1px 4px rgba(0, 0, 0, 0.08);
      margin-bottom: 15px;
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
      <li><a href="DashboardServlet"><i class="fa-solid fa-chart-line"></i> Dashboard</a></li>
      <li><a href="GestionEncuestadoresServlet"><i class="fa-solid fa-users"></i> Gestionar Encuestadores</a></li>
      <li><a href="GestionarFormulariosServlet"><i class="fa-solid fa-file-alt"></i> Gestionar Formularios</a></li>
      <li><a href="CargarArchivosServlet"><i class="fa-solid fa-upload"></i> Cargar Archivos</a></li>
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
                        Coordinador
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

<!-- Contenido principal -->
<main class="contenedor-principal">
  <div class="dashboard-wrapper">
    <h2 style="margin-bottom: 15px;">Dashboard de Zona</h2>

    <!-- Filtro por distrito -->
    <select id="filtroDistrito" class="styled-select">
      <option value="todos">Todos los distritos</option>
      <c:forEach items="${distritosJson}" var="distrito">
        <option value="${distrito}">${distrito}</option>
      </c:forEach>
    </select>

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

      <!-- Gráfico de distribución por distrito -->
      <div class="main-chart-container" style="grid-column: 1; grid-row: 2;">
        <h3 class="chart-title">Distribución por Distrito</h3>
        <div class="chart-container">
          <canvas id="distritosChart"></canvas>
        </div>
        <div class="chart-legend" id="distritosLegend">
          <!-- La leyenda se generará dinámicamente con JavaScript -->
        </div>
      </div>

      <!-- Gráfico de líneas para formularios por encuestador -->
      <div class="bar-chart-container" style="grid-column: 2; grid-row: 1 / -1;">
        <h3 class="chart-title">Formularios Completados por Mes</h3>
        <div class="chart-container">
          <canvas id="barChart"></canvas>
        </div>
      </div>
    </div>
  </div>
</main>

<script>
  // Obtener datos dinámicos desde el backend o usar datos de ejemplo si no hay datos
  const distritos = <c:out value='${distritosJson}' escapeXml='false'/>;
  const activosPorDistrito = <c:out value='${activosDistritoJson}' escapeXml='false'/>;
  const inactivosPorDistrito = <c:out value='${inactivosDistritoJson}' escapeXml='false'/>;

  // Filtro de distrito
  const filtroDistrito = document.getElementById('filtroDistrito');
  let distritoSeleccionado = filtroDistrito.value;

  // Datos de ejemplo para fallback
  const datosEjemploEncuestadores = {
    activos: 5,
    inactivos: 2
  };
  const datosEjemploDistritos = ['Cercado de Lima', 'Rimac'];
  const datosEjemploActivos = [2, 3];
  const datosEjemploInactivos = [1, 1];

  // Función para obtener datos según distrito seleccionado
  function getDatosEncuestadoresDistrito() {
    if (distritos && distritos.length > 0 && distritoSeleccionado !== 'todos') {
      const idx = distritos.indexOf(distritoSeleccionado);
      return {
        activos: activosPorDistrito[idx] || 0,
        inactivos: inactivosPorDistrito[idx] || 0
      };
    } else if (distritos && distritos.length > 0) {
      // Sumar todos los distritos
      return {
        activos: activosPorDistrito.reduce((a, b) => a + b, 0),
        inactivos: inactivosPorDistrito.reduce((a, b) => a + b, 0)
      };
    } else {
      return datosEjemploEncuestadores;
    }
  }

  // Inicializar gráfico pastel de encuestadores
  let pastelChart;
  function renderEncuestadoresChart() {
    const datos = getDatosEncuestadoresDistrito();
    const ctx = document.getElementById('encuestadoresChart').getContext('2d');
    if (pastelChart) pastelChart.destroy();
    pastelChart = new Chart(ctx, {
      type: 'doughnut',
      data: {
        labels: ['Activos', 'Inactivos'],
        datasets: [{
          data: [datos.activos, datos.inactivos],
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
          legend: { display: false },
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
          duration: 1500,
          easing: 'easeInOutQuart'
        },
        hover: { animationDuration: 300 }
      },
      plugins: [{
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
      }]
    });
    // Leyenda
    document.getElementById('encuestadoresLegend').innerHTML =
      `<span class='legend-item'><span class='legend-color' style='background:#27ae60'></span> Activos: ${datos.activos}</span>` +
      `<span class='legend-item'><span class='legend-color' style='background:#e74c3c'></span> Inactivos: ${datos.inactivos}</span>`;
  }

  // Filtro de distrito
  filtroDistrito.addEventListener('change', function() {
    distritoSeleccionado = this.value;
    renderEncuestadoresChart();
  });

  // Inicializar gráfico al cargar
  renderEncuestadoresChart();

  // Gráfico de líneas de formularios por encuestador
  const datosReales = <c:out value='${jsonDatosGrafico}' escapeXml='false'/>;
  const datosEjemploLineas = {
    'Encuestador 1': [4, 6, 8, 10, 12, 14, 16, 14, 12, 10, 8, 6],
    'Encuestador 2': [2, 4, 6, 8, 10, 12, 14, 12, 10, 8, 6, 4],
    'Encuestador 3': [3, 5, 7, 9, 11, 13, 15, 13, 11, 9, 7, 5]
  };
  const datosLineas = Object.keys(datosReales).length > 0 ? datosReales : datosEjemploLineas;
  const encuestadoresNombres = Object.keys(datosLineas);
  const colores = ['#e74c3c', '#27ae60', '#3498db', '#f39c12', '#9b59b6', '#e67e22', '#1abc9c', '#34495e'];
  const datasets = encuestadoresNombres.map((nombre, idx) => ({
    label: nombre,
    data: datosLineas[nombre],
    borderColor: colores[idx % colores.length],
    backgroundColor: colores[idx % colores.length].replace('rgb', 'rgba').replace(')', ', 0.1)'),
    borderWidth: 3,
    pointBackgroundColor: colores[idx % colores.length],
    pointBorderColor: '#ffffff',
    pointBorderWidth: 2,
    pointRadius: 6,
    pointHoverRadius: 8,
    tension: 0.4
  }));
  const barCtx = document.getElementById('barChart').getContext('2d');
  new Chart(barCtx, {
    type: 'line',
    data: {
      labels: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'],
      datasets: datasets
    },
    options: {
      responsive: true,
      maintainAspectRatio: true,
      interaction: { intersect: false, mode: 'index' },
      scales: {
        y: {
          beginAtZero: true,
          ticks: { color: '#666', font: { size: 11 } },
          grid: { color: '#e1e1e1', lineWidth: 1 },
          title: { display: true, text: 'Cantidad de Formularios', color: '#666', font: { size: 12, weight: 'bold' } }
        },
        x: {
          ticks: { color: '#666', font: { size: 11 } },
          grid: { color: '#e1e1e1', lineWidth: 1 },
          title: { display: true, text: 'Meses del Año', color: '#666', font: { size: 12, weight: 'bold' } }
        }
      },
      plugins: {
        legend: { display: true, position: 'bottom', labels: { usePointStyle: true, pointStyle: 'circle', padding: 15, font: { size: 12 } } },
        tooltip: {
          backgroundColor: 'rgba(0,0,0,0.8)',
          titleColor: '#ffffff',
          bodyColor: '#ffffff',
          borderColor: '#3498db',
          borderWidth: 1,
          cornerRadius: 8,
          callbacks: {
            title: function(context) { return context[0].label; },
            label: function(context) { return context.dataset.label + ': ' + (context.parsed.y || 'Sin datos') + ' formularios'; }
          }
        }
      },
      animation: { duration: 1500, easing: 'easeInOutQuart' },
      hover: { animationDuration: 300 }
    }
  });
</script>
</body>
</html>
