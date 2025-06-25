<%--
  Created by IntelliJ IDEA.
  User: Nilton
  Date: 13/05/2025
  Time: 18:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta http-equiv="Cache-Control" content="no-store, no-cache, must-revalidate, max-age=0">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    <title>Inicio de Sesión</title>
    <link rel="stylesheet" href="estilos/login.css" />
</head>
<body>
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

        <!-- Sección de login -->
        <section class="login-section">
            <h4>INICIO DE SESIÓN</h4>

            <!-- Mostrar mensaje de error si lo hay -->
            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
            <p class="error-message"><%= error %></p>
            <%
                }
            %>

            <form action="LoginServlet" method="post">
                <input type="email" name="correo" placeholder="Correo" required>
                <input type="password" name="contrasenha" placeholder="Contraseña" required>

                <div class="forgot-password">
                    <a href="credencial_reinicioPassword.html">¡Olvidé mi contraseña!</a>
                </div>

                <button type="submit" class="login-btn">Ingresar</button>

                <div class="register-link">
                    <a href="${pageContext.request.contextPath}/registro">Registrarme</a>
                </div>
            </form>
        </section>

    </main>

    <!-- Pie de página -->
    <footer class="footer-bar">
        Defensora mundial de la igualdad de género
    </footer>

</div>

<!-- Popup de registro exitoso -->
<!-- Popup de registro exitoso -->
<div id="popup-exito" style="display:none; position:fixed; top:0; left:0; width:100vw; height:100vh; background:rgba(0,0,0,0.35); z-index:9999; align-items:center; justify-content:center;">
    <div style="background:#fff; padding:2rem 2.5rem; border-radius:10px; box-shadow:0 2px 10px rgba(0,0,0,0.2); text-align:center;">
        <h3 style="color:#28a745; margin-bottom:1rem;">¡Registro exitoso!</h3>
        <p>Se ha registrado exitosamente</p>
        <button onclick="window.location.href='LoginServlet'" style="margin-top:1.5rem; padding:0.5rem 1.5rem; background:#28a745; color:#fff; border:none; border-radius:5px; font-size:1rem; cursor:pointer;">Aceptar</button>
    </div>
</div>


<script>
    window.onload = function () {
        const params = new URLSearchParams(window.location.search);
        if (params.get('popup') === '1') {
            document.getElementById('popup-exito').style.display = 'flex';
            // Limpiar 'popup=1' de la URL
            window.history.replaceState({}, document.title, window.location.pathname);
        }

        // Si el usuario presiona "atrás", forzar recarga
        if (performance.navigation.type === 2) {
            location.reload(true);
        }
    };
</script>

</body>
</html>
