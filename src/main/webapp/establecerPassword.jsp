<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
    // Obtener correo del usuario
    String correoUsuario = (String) request.getAttribute("correoUsuario");
    if (correoUsuario == null) {
        correoUsuario = request.getParameter("correo");
    }
    
    // Redirigir si no hay correo
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
    <title>Establecer Contraseña - ONU Mujeres</title>
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
        .logo-container img {
            height: 50px;
            width: auto;
            border-radius: 5px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .content {
            flex: 1;
            display: flex;
            min-height: calc(100vh - 130px);
        }
        .image-section {
            flex: 1.86;
            background-image: url('imagenes/portada.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            min-height: 100%;
        }
        .form-section {
            flex: 1;
            background-color: white;
            padding: 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            min-width: 400px;
            border-radius: 25px 0 0 25px;
            box-shadow: -10px 0 30px rgba(0, 0, 0, 0.1);
            position: relative;
            z-index: 2;
        }
        .form-section h4 {
            color: #5fa3d3;
            margin-bottom: 20px;
            font-size: 22px;
            text-align: center;
            font-weight: 600;
        }
        .success-info {
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
            text-align: center;
            color: #155724;
        }
        .success-info i {
            font-size: 24px;
            margin-bottom: 10px;
            display: block;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 6px;
            color: #5fa3d3;
            font-weight: 500;
            font-size: 14px;
        }
        .form-group input {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }
        .form-group input:focus {
            outline: none;
            border-color: #5fa3d3;
            box-shadow: 0 0 0 2px rgba(95, 163, 211, 0.2);
        }
        .form-group input.error {
            border-color: #dc3545;
        }
        .form-group input.success {
            border-color: #28a745;
        }
        .password-requirements {
            font-size: 12px;
            color: #666;
            margin-top: 4px;
            line-height: 1.3;
        }
        .password-requirements ul {
            margin: 4px 0;
            padding-left: 18px;
        }
        .password-requirements li {
            margin-bottom: 1px;
        }
        .password-requirements li.valid {
            color: #28a745;
        }
        .password-requirements li.invalid {
            color: #dc3545;
        }
        .password-match {
            font-size: 12px;
            margin-top: 4px;
        }
        .password-match.valid {
            color: #28a745;
        }
        .password-match.invalid {
            color: #dc3545;
        }
        .btn-primary {
            background-color: #5fa3d3;
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 5px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            width: 100%;
            margin-top: 15px;
            transition: background-color 0.3s ease;
        }
        .btn-primary:hover {
            background-color: #4a8db8;
        }
        .btn-primary:disabled {
            background-color: #ccc;
            cursor: not-allowed;
        }
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 10px 12px;
            border: 1px solid #f5c6cb;
            border-radius: 5px;
            margin-bottom: 15px;
            font-size: 13px;
        }
        @media (max-width: 768px) {
            .content {
                flex-direction: column;
            }
            .image-section {
                display: none;
            }
            .form-section {
                border-radius: 0;
                box-shadow: none;
                min-width: auto;
                padding: 30px 20px;
            }
        }
    </style>
</head>
<body>
<div class="main-container">
    <!-- Header -->
    <header class="header-bar">
        <img src="imagenes/logo.jpg" alt="Logo ONU Mujeres">
    </header>

    <!-- Contenido principal -->
    <main class="content">
        <!-- Sección de imagen -->
        <section class="image-section"></section>

        <!-- Sección del formulario -->
        <section class="form-section">
            <h4>¡CUENTA VERIFICADA!</h4>

            <div class="success-info">
                <i class="fas fa-check-circle"></i>
                <strong>¡Felicidades!</strong><br>
                Tu cuenta ha sido verificada exitosamente.<br>
                Ahora establece tu contraseña para completar el registro.
            </div>

            <!-- Mensajes de error -->
            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
                <div class="error-message"><%= error %></div>
            <%
                }
            %>

            <form action="EstablecerPasswordServlet" method="post" id="passwordForm">
                <input type="hidden" name="correo" value="<%= correoUsuario %>">

                <!-- Campo de contraseña -->
                <div class="form-group">
                    <label for="password">Nueva Contraseña *</label>
                    <input type="password" 
                           id="password" 
                           name="password" 
                           placeholder="Ingresa tu contraseña"
                           required>
                    <div class="password-requirements">
                        <strong>La contraseña debe contener:</strong>
                        <ul id="passwordChecklist">
                            <li id="length" class="invalid">• Mínimo 8 caracteres</li>
                            <li id="uppercase" class="invalid">• Al menos 1 letra mayúscula</li>
                            <li id="lowercase" class="invalid">• Al menos 1 letra minúscula</li>
                            <li id="number" class="invalid">• Al menos 1 número</li>
                            <li id="special" class="invalid">• Al menos 1 carácter especial (@$!%*?&)</li>
                        </ul>
                    </div>
                </div>

                <!-- Campo de confirmar contraseña -->
                <div class="form-group">
                    <label for="confirmPassword">Confirmar Contraseña *</label>
                    <input type="password" 
                           id="confirmPassword" 
                           name="confirmPassword" 
                           placeholder="Confirma tu contraseña"
                           required>
                    <div id="passwordMatch" class="password-match"></div>
                </div>

                <button type="submit" class="btn-primary" id="submitBtn" disabled>
                    Crear Mi Cuenta
                </button>
            </form>
        </section>
    </main>

    <!-- Footer -->
    <footer style="background: linear-gradient(135deg, #a8d8ff 0%, #87ceeb 100%); color: #333; text-align: center; padding: 15px 0; margin-top: auto; box-shadow: 0 -2px 10px rgba(135,206,235,0.3);">
        <p style="margin: 0; font-size: 14px; font-weight: 500;">© 2025 ONU Mujeres - Sistema de Encuestas. Todos los derechos reservados.</p>
    </footer>
</div>

<script>
    // Configurar validación en tiempo real
    document.addEventListener('DOMContentLoaded', function() {
        const passwordInput = document.getElementById('password');
        const confirmPasswordInput = document.getElementById('confirmPassword');
        
        passwordInput.addEventListener('input', function() {
            validatePassword();
            validatePasswordMatch();
            validateForm();
        });

        confirmPasswordInput.addEventListener('input', function() {
            validatePasswordMatch();
            validateForm();
        });
    });

    // Validar contraseña
    function validatePassword() {
        const passwordInput = document.getElementById('password');
        const password = passwordInput.value;
        const checks = {
            length: password.length >= 8,
            uppercase: /[A-Z]/.test(password),
            lowercase: /[a-z]/.test(password),
            number: /[0-9]/.test(password),
            special: /[@$!%*?&]/.test(password)
        };

        // Actualizar indicadores visuales
        Object.keys(checks).forEach(check => {
            const element = document.getElementById(check);
            if (element) {
                if (checks[check]) {
                    element.classList.remove('invalid');
                    element.classList.add('valid');
                } else {
                    element.classList.remove('valid');
                    element.classList.add('invalid');
                }
            }
        });

        // Cambiar color del borde
        if (Object.values(checks).every(check => check)) {
            passwordInput.classList.remove('error');
            passwordInput.classList.add('success');
        } else {
            passwordInput.classList.remove('success');
            if (password.length > 0) {
                passwordInput.classList.add('error');
            }
        }

        return Object.values(checks).every(check => check);
    }

    // Validar coincidencia de contraseñas
    function validatePasswordMatch() {
        const passwordInput = document.getElementById('password');
        const confirmPasswordInput = document.getElementById('confirmPassword');
        const passwordMatch = document.getElementById('passwordMatch');
        const password = passwordInput.value;
        const confirmPassword = confirmPasswordInput.value;

        if (confirmPassword.length === 0) {
            passwordMatch.textContent = '';
            confirmPasswordInput.classList.remove('success', 'error');
            return false;
        }

        if (password === confirmPassword) {
            passwordMatch.textContent = '✓ Las contraseñas coinciden';
            passwordMatch.classList.remove('invalid');
            passwordMatch.classList.add('valid');
            confirmPasswordInput.classList.remove('error');
            confirmPasswordInput.classList.add('success');
            return true;
        } else {
            passwordMatch.textContent = '✗ Las contraseñas no coinciden';
            passwordMatch.classList.remove('valid');
            passwordMatch.classList.add('invalid');
            confirmPasswordInput.classList.remove('success');
            confirmPasswordInput.classList.add('error');
            return false;
        }
    }

    // Validar formulario completo
    function validateForm() {
        const submitBtn = document.getElementById('submitBtn');
        const isPasswordValid = validatePassword();
        const isPasswordMatchValid = validatePasswordMatch();

        const isFormValid = isPasswordValid && isPasswordMatchValid;
        submitBtn.disabled = !isFormValid;

        return isFormValid;
    }
</script>
</body>
</html>
