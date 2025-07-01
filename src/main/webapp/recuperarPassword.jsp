<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
    // Obtener mensajes de error y éxito
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recuperar Contraseña - ONU Mujeres</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
            min-height: 100vh;
            color: #333;
            margin: 0;
            padding: 0;
        }
        .main-container {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .content {
            flex: 1;
            display: flex;
            min-height: calc(100vh - 130px);
        }
        .image-section {
            flex: 1;
            background-image: url('imagenes/portada.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            min-height: 100%;
        }
        .header-bar {
            background: linear-gradient(135deg, #a8d8ff 0%, #87ceeb 100%);
            height: 70px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 2px 10px rgba(135,206,235,0.3);
            position: relative;
            overflow: hidden;
        }
        .header-bar::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
            animation: shine 3s infinite;
        }
        @keyframes shine {
            0% { left: -100%; }
            100% { left: 100%; }
        }
        .logo-container {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .logo-container img {
            height: 50px;
            width: auto;
            border-radius: 5px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .recovery-section {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 450px;
            text-align: center;
        }
        .recovery-section h4 {
            font-size: 1.8em;
            font-weight: 700;
            color: #5fa3d3;
            margin-bottom: 10px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .welcome-message {
            background: linear-gradient(135deg, #e8f4f8 0%, #d4edda 100%);
            border: 2px solid #b8dacc;
            border-radius: 12px;
            padding: 20px;
            margin: 20px 0;
            color: #155724;
        }
        .welcome-message h5 {
            font-size: 1.2em;
            font-weight: 600;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        .welcome-message p {
            margin: 8px 0;
            line-height: 1.6;
        }
        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #5fa3d3;
            font-size: 0.95em;
        }
        .form-group input[type="email"] {
            width: 100%;
            padding: 15px;
            border: 2px solid #e1e5e9;
            border-radius: 10px;
            font-size: 1em;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }
        .form-group input[type="email"]:focus {
            outline: none;
            border-color: #87ceeb;
            background: white;
            box-shadow: 0 0 0 3px rgba(135,206,235,0.2);
        }
        .info-message {
            background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%);
            border: 2px solid #ffc107;
            border-radius: 12px;
            padding: 15px;
            margin: 15px 0;
            color: #856404;
            font-weight: 500;
            font-size: 0.95em;
        }
        .error-message {
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            color: #721c24;
            padding: 15px;
            border-radius: 10px;
            margin: 15px 0;
            border: 2px solid #f1aeb5;
            font-weight: 600;
            text-align: center;
        }
        .success-message {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            color: #155724;
            padding: 15px;
            border-radius: 10px;
            margin: 15px 0;
            border: 2px solid #b8dacc;
            font-weight: 600;
            text-align: center;
        }
        .form-actions {
            display: flex;
            flex-direction: column;
            gap: 15px;
            margin-top: 25px;
        }
        .btn-primary {
            background: linear-gradient(135deg, #87ceeb 0%, #5fa3d3 100%);
            color: white;
            border: none;
            padding: 15px 30px;
            border-radius: 50px;
            font-size: 1.05em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 6px 20px rgba(135,206,235,0.4);
            width: 100%;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(135,206,235,0.5);
        }
        .link-container {
            margin-top: 20px;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .link-container a {
            color: #5fa3d3;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.95em;
            transition: color 0.3s ease;
        }
        .link-container a:hover {
            color: #87ceeb;
            text-decoration: underline;
        }
        .footer {
            background: linear-gradient(135deg, #a8d8ff 0%, #87ceeb 100%);
            padding: 15px;
            text-align: center;
            color: white;
            margin-top: auto;
        }
        .footer p {
            margin: 0;
            font-size: 0.9rem;
        }
        
        @media (max-width: 768px) {
            .content {
                flex-direction: column;
            }
            .image-section {
                display: none;
            }
            .form-section {
                padding: 20px 10px;
            }
        }
        
        @media (max-width: 600px) {
            .recovery-section {
                margin: 0;
                padding: 25px 15px;
                border-radius: 15px;
                max-width: none;
                display: flex;
                flex-direction: column;
                justify-content: center;
            }
            .recovery-section h4 {
                font-size: 1.6em;
                margin-bottom: 10px;
            }
            .welcome-message {
                margin: 15px 0;
                padding: 15px;
            }
            }
            .form-group input[type="email"] {
                padding: 12px;
                font-size: 16px; /* Evita zoom en iOS */
            }
            .header-bar {
                height: 60px;
            }
            .logo-container img {
                height: 40px;
            }
        }
        
        @media (max-width: 480px) {
            .recovery-section {
                padding: 20px 10px;
            }
            .welcome-message {
                padding: 12px;
                margin: 10px 0;
            }
            .recovery-section h4 {
                font-size: 1.4em;
            }
            .form-group {
                margin-bottom: 15px;
            }
            .btn-primary {
                padding: 12px 20px;
                font-size: 1em;
            }
        }
        
        /* Mejoras adicionales para dispositivos móviles */
        @media (max-width: 768px) {
            body {
                font-size: 14px;
            }
            .main-container {
                min-height: 100vh;
            }
            .content {
                width: 100%;
                box-sizing: border-box;
            }
            .recovery-section {
                box-shadow: none;
                border-radius: 0;
                width: 100vw;
                max-width: 100vw;
                margin: 0;
                padding: 20px;
            }
            .footer-bar {
                padding: 10px;
                font-size: 0.8em;
            }
        }
    </style>
</head>
<body>
<div class="main-container">
    <!-- Header -->
    <header class="header-bar">
        <div class="logo-container">
            <img src="${pageContext.request.contextPath}/imagenes/logo.jpg" alt="Logo ONU Mujeres" />
        </div>
    </header>

    <!-- Contenido principal -->
    <main class="content">
        <!-- Sección de Imagen -->
        <div class="image-section"></div>
        
        <!-- Sección del Formulario -->
        <div class="form-section">
            <section class="recovery-section">
            <h4>RECUPERAR CONTRASEÑA</h4>
            
            <p style="color: #666; margin-bottom: 20px; text-align: center;">
                Ingresa tu correo electrónico para recibir un código de recuperación de contraseña.
            </p>
            
            <!-- Mensajes de error y éxito -->
            <% if (error != null) { %>
                <div class="error-message">
                    <i class="fas fa-exclamation-triangle"></i>
                    <% if ("usuario_no_encontrado".equals(error)) { %>
                        No se encontró una cuenta con ese correo electrónico.
                    <% } else if ("email_error".equals(error)) { %>
                        Error al enviar el correo. Inténtalo nuevamente.
                    <% } else { %>
                        <%= error %>
                    <% } %>
                </div>
            <% } %>

            <% if (success != null) { %>
                <div class="success-message">
                    <i class="fas fa-check-circle"></i> <%= success %>
                </div>
            <% } %>

            <form action="enviarCodigoRecuperacion" method="post">
                <!-- Campo de correo -->
                <div class="form-group">
                    <label for="correo"><i class="fas fa-envelope"></i> Correo Electrónico</label>
                    <input type="email"
                           id="correo"
                           name="correo"
                           placeholder="Ingresa tu correo electrónico"
                           value="${param.correo}"
                           required>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-primary">
                        <i class="fas fa-paper-plane"></i> Enviar código de recuperación
                    </button>
                </div>
            </form>

            <div class="link-container">
                <a href="login.jsp">
                    <i class="fas fa-arrow-left"></i> Volver al inicio de sesión
                </a>
                <a href="registro">
                    <i class="fas fa-user-plus"></i> ¿No tienes cuenta? Regístrate aquí
                </a>
            </div>
        </section>
        </div>
    </main>

    <!-- Footer -->
    <div class="footer">
        <p>&copy; 2025 ONU Mujeres. Todos los derechos reservados.</p>
    </div>
</div>
</body>
</html>
