<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
  <title>Dashboard</title>
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

    .dashboard-grid {
      display: grid;
      grid-template-columns: 1fr 2fr;
      grid-template-rows: auto auto;
      gap: 24px;
      margin-top: 32px;
    }

    .dashboard-card {
      background: var(--color-card-inner);
      border-radius: 16px;
      box-shadow: 0 2px 12px rgba(52, 152, 219, 0.08);
      border: 1.5px solid #c8dbff;
      padding: 24px;
      text-align: center;
    }

    .contenedor-principal {
      padding: 32px;
      max-width: 1400px;
      margin: auto;
    }

    .dashboard-card {
      background: #ffffffcc;
      border-radius: 18px;
      padding: 24px;
      box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
      text-align: center;
    }
    .card-title {
      font-weight: bold;
      margin-bottom: 12px;
      font-size: 1.2em;
    }
    canvas {
      width: 100% !important;
      max-height: 500px !important;
      height: auto !important;
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
    .styled-select {
      background: #e6f0ff;
      border: 1.5px solid #3498db;
      border-radius: 8px;
      padding: 6px 12px;
      font-size: 1em;
      color: #333;
      box-shadow: 0 1px 4px rgba(0,0,0,0.08);
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
    .dashboard-grid {
      display: grid;
      grid-template-columns: 1fr 2fr 1fr;
      grid-template-rows: auto;
      gap: 24px;
      width: 100%;
      margin-top: 32px;
    }
    .dashboard-card {
      background: #dbeeff;
      border-radius: 16px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.04);
      padding: 24px 18px;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      font-size: 1.15em;
      font-weight: 500;
      color: #222;
      min-height: 120px;
    }
    /* Ubicación de cada bloque */
    .card-encuestador { grid-column: 1/2; grid-row: 1/2; }
    .card-grafico-distrito { grid-column: 2/3; grid-row: 1/3; }
    .card-dato { grid-column: 3/4; grid-row: 1/2; }
    .card-otros { grid-column: 1/2; grid-row: 2/3; }
    .card-pastel {
      grid-column: 1 / 2;
      grid-row: 1 / 2;
    }
    .card-reporte { grid-column: 1/4; grid-row: 3/4; }
    /* Responsive */
    @media (max-width: 1100px) {
      .dashboard-grid {
        grid-template-columns: 1fr 1fr;
        grid-template-rows: auto;
        gap: 18px;
      }

      .card-encuestador {
        grid-column: 1/2;
        grid-row: 1/2;
      }

      .card-grafico-distrito {
        grid-column: 2 / 3;
        grid-row: 1 / 3;
      }

      @media (max-width: 800px) {
        .dashboard-grid {
          grid-template-columns: 1fr;
          grid-template-rows: auto;
          gap: 16px;
        }

        .dashboard-card {
          min-height: 80px;
        }

        .card-encuestador,
        .card-dato,
        .card-otros,
        .card-linea {
          grid-column: 1 / 2;
          grid-row: 2 / 3;
        }

        .card-pastel,
        .card-reporte {
          grid-column: 1/2 !important;
          grid-row: auto !important;
        }
      }
      /* Select filtro */


    }
    .dashboard-select {
      width: 180px;
      margin-bottom: 20px;
      padding: 6px 12px;
      font-size: 1em;
      border-radius: 8px;
      border: 1.5px solid #3498db;
      background: #e6f0ff;
      color: #333;
      box-shadow: 0 1px 4px rgba(0, 0, 0, 0.08);
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
      <li><a href="InicioCoordinadorServlet"><i class="fa-solid fa-chart-line"></i> Ver Dashboard</a></li>
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
  <h2>Dashboard de Zona: ${sessionScope.nombre}</h2>
  <label for="filtroDistrito" style="font-weight: bold; margin-right: 12px;">Filtrar por distrito:</label>
  <select id="filtroDistrito" class="dashboard-select">
    <option value="todos">Todos</option>
  </select>

  <!-- Gráficos -->
  <div class="dashboard-grid">
    <div class="dashboard-card card-pastel">
      <div class="card-title" id="tituloPastelZona">Encuestadores en la zona (activos vs inactivos)</div>
      <canvas id="graficoPastelZona"></canvas>
    </div>

    <div class="dashboard-card card-grafico-distrito">
      <div class="card-title" id="tituloGraficoDistrito">Distribución por distrito (activos vs inactivos)</div>
      <canvas id="graficoPorDistrito"></canvas>
    </div>

    <div class="dashboard-card card-linea">
      <div class="card-title">Evolución mensual de encuestadores</div>
      <canvas id="graficoLinea"></canvas>
    </div>
  </div>
</main>
<!-- Debug rápido en HTML -->
<div style="display:none">
  ${distritosJson}<br>
  ${activosDistritoJson}<br>
  ${inactivosDistritoJson}<br>
</div>
<script>
  const activosZona = ${activosZona};
  const inactivosZona = ${inactivosZona};
  const distritos = ${distritosJson};
  const activosPorDistrito = ${activosDistritoJson};
  const inactivosPorDistrito = ${inactivosDistritoJson};

  distritos.forEach(d => {
    const option = document.createElement("option");
    option.value = d;
    option.text = d;
    document.getElementById("filtroDistrito").appendChild(option);
  });

  const pastelChart = new Chart(document.getElementById('graficoPastelZona'), {
    type: 'doughnut',
    data: {
      labels: ['Activos', 'Inactivos'],
      datasets: [{
        data: [activosZona, inactivosZona],
        backgroundColor: ['#2ecc71', '#e74c3c']
      }]
    },
    options: {
      cutout: '60%',
      plugins: {
        legend: {
          position: 'bottom'
        },
        tooltip: {
          callbacks: {
            label: function (context) {
              const value = context.parsed;
              return `${context.label}: ${value} encuestadores`;
            }
          }
        }
      }
    }
  });

  const ctxDistrito = document.getElementById('graficoPorDistrito').getContext('2d');
  const graficoDistrito = new Chart(ctxDistrito, {
    type: 'bar',
    data: {
      labels: ['Activos', 'Inactivos'],
      datasets: [{
        label: '',
        data: [0, 0],
        backgroundColor: ['#3498db', '#e67e22']
      }]
    },
    options: {
      responsive: true,
      scales: {
        y: { beginAtZero: true }
      },
      plugins: {
        legend: { display: false }
      }
    }
  });

  document.getElementById('filtroDistrito').addEventListener('change', function () {
    const seleccionado = this.value;
    const idx = distritos.findIndex(d => d.toLowerCase() === seleccionado.toLowerCase());
    const titulo = document.getElementById('tituloGraficoDistrito');
    const tituloPastel = document.getElementById('tituloPastelZona');
    console.log("Seleccionado:", seleccionado);
    console.log("Distritos disponibles:", distritos);
    console.log("Índice encontrado:", distritos.indexOf(seleccionado));
    if (seleccionado === "todos") {
      graficoDistrito.data.datasets[0].data = [0, 0];
      graficoDistrito.data.datasets[0].label = "";
      titulo.innerText = "Distribución por distrito (activos vs inactivos)";

      pastelChart.data.datasets[0].data = [activosZona, inactivosZona];
      tituloPastel.innerText = "Encuestadores en la zona (activos vs inactivos)";
    } else if (idx !== -1) {
      graficoDistrito.data.datasets[0].data = [activosPorDistrito[idx], inactivosPorDistrito[idx]];
      graficoDistrito.data.datasets[0].label = seleccionado;
      titulo.innerText = `Encuestadores en "${seleccionado}"`;

      pastelChart.data.datasets[0].data = [activosPorDistrito[idx], inactivosPorDistrito[idx]];
      tituloPastel.innerText = `Encuestadores en "${seleccionado}" (activos vs inactivos)`;
    }

    graficoDistrito.update();
    pastelChart.update();
  });

  new Chart(document.getElementById('graficoLinea'), {
    type: 'line',
    data: {
      labels: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'],
      datasets: [{
        label: 'Encuestadores activos',
        data: [5, 8, 12, 15, 20, 18],
        borderColor: '#8e44ad',
        fill: false,
        tension: 0.2
      }]
    },
    options: {
      responsive: true,
      scales: {
        y: { beginAtZero: true }
      }
    }
  });
</script>
</body>
</html>