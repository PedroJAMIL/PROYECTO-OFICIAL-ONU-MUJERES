<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
    // Obtener datos del usuario y mensajes
    String correoUsuario = (String) request.getAttribute("correoUsuario");
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
    Boolean iniciarTimer = (Boolean) request.getAttribute("iniciarTimer");
    
    if (correoUsuario == null) {
        correoUsuario = request.getParameter("correoUsuario");
    }
    
    if (correoUsuario == null || correoUsuario.trim().isEmpty()) {
        response.sendRedirect("registro");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verificar Código - ONU Mujeres</title>
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
        .form-section {
            background: rgba(255, 255, 255, 0.95);
            min-width: 450px;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
            backdrop-filter: blur(10px);
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
        .verification-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(135,206,235,0.2);
            padding: 40px;
            width: 100%;
            max-width: 450px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.2);
        }
        .verification-container h4 {
            font-size: 1.8em;
            font-weight: 700;
            color: #5fa3d3;
            margin-bottom: 10px;
            text-align: center;
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
            text-align: center;
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
        .email-display {
            background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%);
            border: 2px solid #ffc107;
            border-radius: 10px;
            padding: 15px;
            margin: 15px 0;
            text-align: center;
            color: #856404;
            font-weight: 600;
        }
        .timer-container {
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            border: 2px solid #f1aeb5;
            border-radius: 10px;
            padding: 15px;
            margin: 15px 0;
            text-align: center;
            color: #721c24;
            font-weight: 600;
        }
        .timer-display {
            font-size: 1.2em;
            font-weight: bold;
            color: #dc3545;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #5fa3d3;
            font-size: 0.95em;
        }
        .form-group input[type="text"] {
            width: 100%;
            padding: 15px;
            border: 2px solid #e1e5e9;
            border-radius: 10px;
            font-size: 1.1em;
            text-align: center;
            font-weight: 600;
            letter-spacing: 2px;
            text-transform: uppercase;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }
        .form-group input[type="text"]:focus {
            outline: none;
            border-color: #87ceeb;
            background: white;
            box-shadow: 0 0 0 3px rgba(135,206,235,0.2);
        }
        .info-message {
            background: linear-gradient(135deg, #d1ecf1 0%, #bee5eb 100%);
            border: 2px solid #5fa3d3;
            border-radius: 12px;
            padding: 15px;
            margin: 15px 0;
            color: #0c5460;
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
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(135,206,235,0.5);
        }
        .btn-secondary {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 50px;
            font-size: 0.95em;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(108,117,125,0.3);
        }
        .btn-secondary:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(108,117,125,0.4);
        }
        .link-container {
            margin-top: 20px;
            display: flex;
            flex-direction: column;
            gap: 10px;
            text-align: center;
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
                min-width: 100%;
            }
            .verification-container {
                margin: 0;
                padding: 25px 15px;
                border-radius: 15px;
                max-width: none;
            }
            .verification-container h4 {
                font-size: 1.6em;
            }
        }
        
        @media (max-width: 480px) {
            .verification-container {
                padding: 20px 10px;
            }
            .verification-container h4 {
                font-size: 1.4em;
            }
            .form-group input[type="text"] {
                padding: 12px;
                font-size: 1em;
            }
            .btn-primary {
                padding: 12px 20px;
                font-size: 1em;
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
            <div class="verification-container">
                <h4>VERIFICAR CÓDIGO</h4>
                
                <div class="welcome-message">
                    <h5><i class="fas fa-envelope-open-text"></i> ¡Código Enviado!</h5>
                    <p>Hemos enviado un código de verificación a tu correo electrónico.</p>
                    <p>Revisa tu bandeja de entrada y la carpeta de spam.</p>
                </div>
                
                <div class="email-display">
                    <i class="fas fa-envelope"></i>
                    <strong>Correo:</strong> <%= correoUsuario %>
                </div>
                
                <!-- Timer para reenvío -->
                <div class="timer-container" id="timerContainer">
                    <i class="fas fa-clock"></i>
                    <span>Puedes solicitar un nuevo código en: </span>
                    <span class="timer-display" id="countdown">05:00</span>
                </div>
                
                <div class="info-message">
                    <i class="fas fa-info-circle"></i>
                    <strong>Importante:</strong> El código contiene números y letras (ejemplo: A1B2C3).
                    Es válido por 5 minutos.
                </div>
                
                <!-- Mensajes de error y éxito -->
                <% if (error != null) { %>
                    <div class="error-message">
                        <i class="fas fa-exclamation-triangle"></i>
                        <% if ("codigo_incorrecto".equals(error)) { %>
                            El código ingresado es incorrecto. Verifica e inténtalo nuevamente.
                        <% } else if ("codigo_expirado".equals(error)) { %>
                            El código ha expirado. Solicita un nuevo código.
                        <% } else if ("usuario_no_encontrado".equals(error)) { %>
                            No se encontró el usuario. Verifica tu correo electrónico.
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

                <form action="verificarCodigo" method="post">
                    <input type="hidden" name="correoUsuario" value="<%= correoUsuario %>">
                    
                    <!-- Campo de código -->
                    <div class="form-group">
                        <label for="codigo"><i class="fas fa-key"></i> Código de Verificación</label>
                        <input type="text"
                               id="codigo"
                               name="codigo"
                               placeholder="Ej: A1B2C3"
                               maxlength="6"
                               required
                               autocomplete="off">
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn-primary">
                            <i class="fas fa-check"></i> Verificar Código
                        </button>
                        
                        <button type="button" id="reenviarBtn" class="btn-secondary" disabled>
                            <i class="fas fa-redo"></i> Reenviar Código
                        </button>
                    </div>
                </form>

                <div class="link-container">
                    <a href="registro">
                        <i class="fas fa-arrow-left"></i> Volver al registro
                    </a>
                    <a href="login.jsp">
                        <i class="fas fa-sign-in-alt"></i> ¿Ya tienes cuenta? Inicia sesión
                    </a>
                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <div class="footer">
        <p>&copy; 2025 ONU Mujeres. Todos los derechos reservados.</p>
    </div>
</div>

<script>
    // Timer de cuenta regresiva
    let timeLeft = 300; // 5 minutos en segundos
    const countdown = document.getElementById('countdown');
    const reenviarBtn = document.getElementById('reenviarBtn');
    const timerContainer = document.getElementById('timerContainer');
    
    // Iniciar timer siempre por defecto - el servlet controla cuando mostrar esta página
    const timer = setInterval(function() {
        const minutes = Math.floor(timeLeft / 60);
        const seconds = timeLeft % 60;
        
        countdown.textContent = 
            (minutes < 10 ? '0' : '') + minutes + ':' + 
            (seconds < 10 ? '0' : '') + seconds;
        
        if (timeLeft <= 0) {
            clearInterval(timer);
            timerContainer.style.display = 'none';
            reenviarBtn.disabled = false;
            reenviarBtn.textContent = 'Reenviar Código';
        }
        
        timeLeft--;
    }, 1000);
    
    // Funcionalidad del botón reenviar
    reenviarBtn.addEventListener('click', function() {
        this.disabled = true;
        this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Enviando...';
        
        // Reenviar código
        window.location.href = 'registro?reenviar=true&correo=<%= correoUsuario %>';
    });
    
    // Auto-formatear el código mientras se escribe
    const codigoInput = document.getElementById('codigo');
    codigoInput.addEventListener('input', function(e) {
        let value = e.target.value.toUpperCase();
        // Eliminar caracteres no alfanuméricos
        value = value.replace(/[^A-Z0-9]/g, '');
        // Limitar a 6 caracteres
        if (value.length > 6) {
            value = value.substring(0, 6);
        }
        e.target.value = value;
    });
    
    // Focus automático en el campo de código
    document.addEventListener('DOMContentLoaded', function() {
        codigoInput.focus();
    });
</script>
</body>
</html>
