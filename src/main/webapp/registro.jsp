<%--
  Created by IntelliJ IDEA.
  User: FABRICIO
  Date: 20/05/2025
  Time: 17:01
  To change this template use File | Settings | File Templates.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Registro de Usuario</title>
  <style>
    /* Reset básico */
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: Arial, sans-serif;
      background-color: #f5f5f5;
    }

    .main-container {
      display: flex;
      flex-direction: column;
      min-height: 100vh;
    }

    .header-bar {
      background-color: #dbeeff;
      height: 50px;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .header-bar img {
      height: 30px;
    }

    .content {
      display: flex;
      flex: 1;
      padding: 1rem;
    }

    .image-section {
      flex: 3;
      background-color: #ccc;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .image-section img {
      max-width: 80%;
      height: auto;
    }

    .login-section {
      flex: 1.2;
      background-color: #ffffff;
      padding: 2rem;
      display: flex;
      flex-direction: column;
      justify-content: center;
    }

    .login-section h4 {
      text-align: center;
      font-weight: bold;
      margin-bottom: 1.5rem;
      font-size: 1.8rem;
    }

    .login-section form {
      display: flex;
      flex-direction: column;
    }

    .login-section input, .login-section select {
      padding: 10px;
      margin-bottom: 10px;
      border: 1.5px solid #000;
      border-radius: 4px;
      font-size: 14px;
    }

    .iniciar-sesion {
      text-align: right;
      margin-bottom: 15px;
      text-align: center;
    }

    .iniciar-sesion a {
      font-size: 14px;
      text-decoration: none;
      color: #0056b3;
    }

    .login-btn {
      padding: 10px;
      background-color: #649CFF;
      color: white;
      font-size: 15px;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      margin-bottom: 10px;
      width: 200px;
      margin: 0 auto;
    }

    .login-btn:hover {
      background-color: #507cd9;
    }

    .comentario {
      margin-top: 10px;
      font-size: 15px;
      margin-bottom: 10px;
      text-align: center;
      color: #0056b3;
    }

    .footer-bar {
      background-color: white;
      height: 40px;
      border-top: 1px solid #ccc;
      display: flex;
      align-items: center;
      padding-left: 1rem;
      font-weight: bold;
    }

    .error-message {
      color: red;
      font-size: 12px;
      margin-bottom: 10px;
      text-align: center;
    }
  </style>
</head>

<!------------------------------------------------------------------------------------------------------------------------------------->

<body>
<div class="main-container">
  <!-- Barra superior -->
  <header class="header-bar">
    <img src="imagenes/logo.jpg" alt="Logo superior">
  </header>

  <!-- Contenido principal -->
  <main class="content">
    <!-- Sección de imagen grande -->
    <section class="image-section">
      <img src="imagenes/portada.jpg" alt="Imagen principal">
    </section>

    <!-- Sección de registro -->
    <section class="login-section">
      <h4>REGISTRO</h4>

      <c:if test="${not empty error}">
        <div class="error-message">${error}</div>
      </c:if>

      <form action="registro" method="POST">
        <input type="text" name="nombre" placeholder="Nombre" required>
        <input type="text" name="apellidoPaterno" placeholder="Apellido Paterno" required>
        <input type="text" name="apellidoMaterno" placeholder="Apellido Materno" required>
        <input type="text" name="dni" placeholder="DNI" required>
        <input type="text" name="direccion" placeholder="Dirección" required>

        <select name="distrito" required>
          <option value="">Seleccione un distrito</option>
          <c:forEach items="${distritos}" var="distrito">
            <option value="${distrito.idDistrito}">${distrito.nombreDistrito}</option>
          </c:forEach>
        </select>        <input type="email" name="correo" placeholder="Correo electrónico" required>
        <input type="password" name="contrasenha" placeholder="Contraseña (mínimo 8 caracteres)" required>
        <input type="password" name="confirmarContrasenha" placeholder="Confirmar contraseña" required>

        <!-- Mensaje informativo sobre el registro directo -->
        <div style="background: #e8f5e8; border: 1px solid #c8e6c9; border-radius: 8px; padding: 15px; margin: 15px 0; text-align: center; color: #2e7d32; font-size: 14px;">
          <i class="fas fa-check-circle" style="margin-right: 8px;"></i>
          <strong>Registro directo:</strong><br>
          Tu cuenta se activará inmediatamente y podrás iniciar sesión.
        </div>

        <!-- CÓDIGO ORIGINAL DE VERIFICACIÓN POR CORREO (COMENTADO)
        <div style="background: #e3f2fd; border: 1px solid #bbdefb; border-radius: 8px; padding: 15px; margin: 15px 0; text-align: center; color: #1976d2; font-size: 14px;">
          <i class="fas fa-info-circle" style="margin-right: 8px;"></i>
          <strong>Proceso de verificación:</strong><br>
          Te enviaremos un correo con un enlace para establecer tu contraseña.
        </div>
        -->

        <button type="submit" class="login-btn">Registrarse</button>

        <div class="comentario">
          <p>¿Ya tienes una cuenta?</p>
        </div>
        <div class="iniciar-sesion">
          <a href="LoginServlet">Iniciar Sesión</a>
        </div>
      </form>
    </section>
  </main>

  <!-- Pie de página -->
  <footer class="footer-bar">
    Defensora mundial de la igualdad de género  </footer>
</div>

<script>
  // Validación de contraseñas en tiempo real
  document.addEventListener('DOMContentLoaded', function() {
    const contrasenhaInput = document.querySelector('input[name="contrasenha"]');
    const confirmarInput = document.querySelector('input[name="confirmarContrasenha"]');
    const form = document.querySelector('form');

    function validarContrasenhas() {
      const contrasenha = contrasenhaInput.value;
      const confirmar = confirmarInput.value;

      // Limpiar estilos previos
      contrasenhaInput.style.borderColor = '#000';
      confirmarInput.style.borderColor = '#000';

      // Validar longitud mínima
      if (contrasenha.length > 0 && contrasenha.length < 8) {
        contrasenhaInput.style.borderColor = '#ff4444';
      }

      // Validar coincidencia
      if (confirmar.length > 0 && contrasenha !== confirmar) {
        confirmarInput.style.borderColor = '#ff4444';
      } else if (confirmar.length > 0 && contrasenha === confirmar && contrasenha.length >= 8) {
        confirmarInput.style.borderColor = '#44aa44';
        contrasenhaInput.style.borderColor = '#44aa44';
      }
    }

    contrasenhaInput.addEventListener('input', validarContrasenhas);
    confirmarInput.addEventListener('input', validarContrasenhas);

    // Validación final al enviar
    form.addEventListener('submit', function(e) {
      const contrasenha = contrasenhaInput.value;
      const confirmar = confirmarInput.value;

      if (contrasenha.length < 8) {
        e.preventDefault();
        alert('La contraseña debe tener al menos 8 caracteres');
        return false;
      }

      if (contrasenha !== confirmar) {
        e.preventDefault();
        alert('Las contraseñas no coinciden');
        return false;
      }
    });
  });
</script>

</body>
</html>