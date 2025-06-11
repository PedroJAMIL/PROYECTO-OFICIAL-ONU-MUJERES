<%--
  Created by IntelliJ IDEA.
  User: cs
  Date: 6/06/2025
  Time: 16:06
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
  <title>Dashboard</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
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
      background-color: var(--color-bg);
      margin: 0;
      padding: 0;
      color: #333;
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
      grid-template-rows: 1fr 1fr 0.7fr;
      gap: 24px;
      width: 100%;
      height: 70vh;
      min-height: 500px;
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
    .card-pastel { grid-column: 3/4; grid-row: 2/3; }
    .card-reporte { grid-column: 1/4; grid-row: 3/4; }
    /* Responsive */
    @media (max-width: 1100px) {
      .dashboard-grid {
        grid-template-columns: 1fr 1fr;
        grid-template-rows: auto;
        gap: 18px;
      }
      .card-encuestador { grid-column: 1/2; grid-row: 1/2; }
      .card-grafico-distrito { grid-column: 2/3; grid-row: 1/3; }
      .card-dato { grid-column: 1/2; grid-row: 2/3; }
      .card-otros { grid-column: 2/3; grid-row: 3/4; }
      .card-pastel { grid-column: 1/2; grid-row: 3/4; }
      .card-reporte { grid-column: 1/3; grid-row: 4/5; }
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
      .card-grafico-distrito,
      .card-dato,
      .card-otros,
      .card-pastel,
      .card-reporte {
        grid-column: 1/2 !important;
        grid-row: auto !important;
      }
    }
    /* Select filtro */
    .dashboard-select {
      width: 160px;
      margin-bottom: 12px;
      align-self: flex-start;
    }
    /* Ejemplo de gráfico de barras y pastel (puedes reemplazar por Chart.js) */
    .fake-bar-chart {
      width: 90%;
      height: 120px;
      background: linear-gradient(90deg, #b3ccff 60%, #e6f0ff 100%);
      border-radius: 8px;
      margin: 18px auto 0 auto;
      display: flex;
      align-items: flex-end;
      gap: 8px;
      padding: 10px;
    }
    .fake-bar {
      width: 18px;
      background: #3498db;
      border-radius: 4px 4px 0 0;
      display: inline-block;
    }
    .fake-bar1 { height: 60px; }
    .fake-bar2 { height: 90px; }
    .fake-bar3 { height: 40px; }
    .fake-bar4 { height: 100px; }
    .fake-bar5 { height: 70px; }
    .fake-pie {
      width: 90px;
      height: 90px;
      border-radius: 50%;
      background: conic-gradient(#3498db 0 40%, #2ecc71 40% 70%, #f1c40f 70% 100%);
      margin: 18px auto 0 auto;
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
      <li><a href="DashboardServlet"><i class="fa-solid fa-chart-line"></i> Ver Dashboard</a></li>
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

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<main class="container py-5">
  <h2 class="mb-4 text-center">Dashboard del Coordinador</h2>

  <!-- Tarjetas resumen -->
  <div class="row mb-4">
    <div class="col-md-4">
      <div class="card text-white bg-primary mb-3">
        <div class="card-body">
          <h5 class="card-title">Total Completados</h5>
          <p class="card-text fs-3">${estadoFormularios.totalCompletados}</p>
        </div>
      </div>
    </div>
    <div class="col-md-4">
      <div class="card text-white bg-secondary mb-3">
        <div class="card-body">
          <h5 class="card-title">Total Borradores</h5>
          <p class="card-text fs-3">${estadoFormularios.totalBorradores}</p>
        </div>
      </div>
    </div>
    <div class="col-md-4">
      <div class="card text-white bg-success mb-3">
        <div class="card-body">
          <h5 class="card-title">Total General</h5>
          <p class="card-text fs-3">
            ${estadoFormularios.totalCompletados + estadoFormularios.totalBorradores}
          </p>
        </div>
      </div>
    </div>
  </div>

  <!-- Gráficos -->
  <div class="row">
    <!-- Gráfico de barras: respuestas por encuestador -->
    <div class="col-md-6 mb-4">
      <div class="card">
        <div class="card-header bg-info text-white">Respuestas por Encuestador</div>
        <div class="card-body">
          <canvas id="graficoEncuestadores"></canvas>
        </div>
      </div>
    </div>

    <!-- Gráfico de torta: respuestas por zona -->
    <div class="col-md-6 mb-4">
      <div class="card">
        <div class="card-header bg-warning text-dark">Respuestas por Zona</div>
        <div class="card-body">
          <canvas id="graficoZonas"></canvas>
        </div>
      </div>
    </div>
  </div>

  <!-- Gráfico Doughnut: Completados vs Borradores -->
  <div class="row">
    <div class="col-md-6 offset-md-3">
      <div class="card">
        <div class="card-header bg-dark text-white">Completados vs Borradores</div>
        <div class="card-body">
          <canvas id="graficoEstado"></canvas>
        </div>
      </div>
    </div>
  </div>
</main>

<script>
  // === Encuestadores ===
  const labelsEncuestador = [
    <c:forEach var="dto" items="${resumenEncuestadores}" varStatus="loop">
    "${dto.nombreEncuestador}"<c:if test="${!loop.last}">,</c:if>
    </c:forEach>
  ];
  const dataEncuestador = [
    <c:forEach var="dto" items="${resumenEncuestadores}" varStatus="loop">
    ${dto.cantidadRespuestas}<c:if test="${!loop.last}">,</c:if>
    </c:forEach>
  ];

  if (labelsEncuestador.length > 0) {
    new Chart(document.getElementById("graficoEncuestadores"), {
      type: "bar",
      data: {
        labels: labelsEncuestador,
        datasets: [{
          label: "Cantidad de respuestas",
          data: dataEncuestador,
          backgroundColor: "#0d6efd"
        }]
      },
      options: {
        responsive: true,
        scales: { y: { beginAtZero: true } }
      }
    });
  }

  // === Zonas ===
  const labelsZonas = [
    <c:forEach var="dto" items="${resumenZonas}" varStatus="loop">
    "${dto.nombreZona}"<c:if test="${!loop.last}">,</c:if>
    </c:forEach>
  ];
  const dataZonas = [
    <c:forEach var="dto" items="${resumenZonas}" varStatus="loop">
    ${dto.totalRespuestas}<c:if test="${!loop.last}">,</c:if>
    </c:forEach>
  ];

  if (labelsZonas.length > 0) {
    new Chart(document.getElementById("graficoZonas"), {
      type: "pie",
      data: {
        labels: labelsZonas,
        datasets: [{
          data: dataZonas,
          backgroundColor: ["#f39c12", "#e67e22", "#d35400", "#f1c40f", "#f7dc6f"]
        }]
      },
      options: { responsive: true }
    });
  }

  // === Estado completado vs borrador ===
  const completados = ${estadoFormularios.totalCompletados};
  const borradores = ${estadoFormularios.totalBorradores};

  if (completados + borradores > 0) {
    new Chart(document.getElementById("graficoEstado"), {
      type: "doughnut",
      data: {
        labels: ["Completados", "Borradores"],
        datasets: [{
          data: [completados, borradores],
          backgroundColor: ["#28a745", "#6c757d"]
        }]
      },
      options: { responsive: true }
    });
  }
</script>

</body>
</html>