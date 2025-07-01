<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro de Usuario - ONU Mujeres</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f0f8ff 0%, #e6f3ff 50%, #ddeeff 100%);
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
            background: linear-gradient(135deg, #87ceeb 0%, #5fa3d3 100%);
            height: 70px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 15px rgba(135,206,235,0.3);
            position: relative;
            z-index: 1000;
        }
        .logo-container {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .logo-container img {
            height: 50px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }
        .content {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }
        .registration-section {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 600px;
            text-align: center;
        }
        .registration-section h4 {
            font-size: 1.8em;
            font-weight: 700;
            color: #333;
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
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin: 25px 0;
        }
        .form-group {
            text-align: left;
        }
        .form-group.full-width {
            grid-column: 1 / -1;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
            font-size: 0.95em;
        }
        .form-group input[type="text"],
        .form-group input[type="email"],
        .form-group input[type="password"],
        .form-group select {
            width: 100%;
            padding: 15px;
            border: 2px solid #e1e5e9;
            border-radius: 10px;
            font-size: 1em;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }
        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #87ceeb;
            background: white;
            box-shadow: 0 0 0 3px rgba(135,206,235,0.2);
        }
        .password-requirements {
            margin-top: 8px;
            padding: 12px;
            background: #f8f9fa;
            border-radius: 8px;
            font-size: 0.85em;
        }
        .password-requirements ul {
            margin: 8px 0 0 20px;
            padding: 0;
        }
        .password-requirements li {
            margin: 4px 0;
            transition: color 0.3s ease;
        }
        .password-requirements li.valid {
            color: #28a745;
            font-weight: 600;
        }
        .password-requirements li.invalid {
            color: #dc3545;
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
            gap: 15px;
            justify-content: center;
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
            min-width: 160px;
        }
        .btn-primary:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(135,206,235,0.5);
        }
        .btn-primary:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
            box-shadow: 0 6px 20px rgba(135,206,235,0.2);
        }
        .btn-secondary {
            background: linear-gradient(135deg, #6c757d 0%, #5a6268 100%);
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 50px;
            font-size: 0.95em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(108,117,125,0.3);
        }
        .btn-secondary:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(108,117,125,0.4);
        }
        .login-link {
            text-align: center;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 2px solid #e9ecef;
        }
        .login-link a {
            color: #6c757d;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.95em;
            transition: color 0.3s ease;
        }
        .login-link a:hover {
            color: #5fa3d3;
        }
        .footer-bar {
            background: #343a40;
            color: white;
            text-align: center;
            padding: 15px;
            font-size: 0.9em;
            font-weight: 500;
        }
        
        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
                gap: 15px;
            }
            .content {
                padding: 20px 15px;
            }
            .registration-section {
                padding: 30px 25px;
                border-radius: 15px;
            }
            .registration-section h4 {
                font-size: 1.5em;
            }
            .form-actions {
                flex-direction: column;
                align-items: center;
            }
            .btn-primary, .btn-secondary {
                width: 100%;
                max-width: 300px;
                margin-bottom: 10px;
            }
        }
        
        @media (max-width: 600px) {
            .header-bar {
                height: 60px;
            }
            .logo-container img {
                height: 40px;
            }
            .form-group input,
            .form-group select {
                padding: 12px;
                font-size: 16px; /* Evita zoom en iOS */
            }
        }
        
        @media (max-width: 480px) {
            .registration-section {
                padding: 25px 20px;
            }
            .welcome-message {
                padding: 15px;
                margin: 15px 0;
            }
            .password-requirements {
                font-size: 0.8em;
                padding: 10px;
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
        <section class="registration-section">
            <h4>REGISTRO DE USUARIO</h4>
            
            <div class="welcome-message">
                <h5><i class="fas fa-user-plus"></i> Únete a nosotros</h5>
                <p>Regístrate como <strong>Encuestador</strong> en la plataforma de ONU Mujeres.</p>
                <p>Forma parte del cambio hacia la igualdad de género.</p>
            </div>

            <!-- Mostrar errores si existen -->
            <c:if test="${not empty errorMessages}">
                <div class="error-message">
                    <i class="fas fa-exclamation-triangle"></i>
                    <c:forEach var="error" items="${errorMessages}">
                        ${error}<br>
                    </c:forEach>
                </div>
            </c:if>

            <!-- Mostrar errores específicos por parámetros -->
            <c:if test="${param.error == 'dni'}">
                <div class="error-message">
                    <i class="fas fa-exclamation-triangle"></i> El DNI ingresado ya se encuentra registrado.
                </div>
            </c:if>
            <c:if test="${param.error == 'correo'}">
                <div class="error-message">
                    <i class="fas fa-exclamation-triangle"></i> El correo ingresado ya se encuentra registrado.
                </div>
            </c:if>
            <c:if test="${param.error == 'ambos'}">
                <div class="error-message">
                    <i class="fas fa-exclamation-triangle"></i> El DNI y el correo ingresados ya se encuentran registrados.
                </div>
            </c:if>

            <form id="registrationForm" action="registro" method="post" enctype="multipart/form-data">
                <div class="form-grid">
                    <!-- Información Personal -->
                    <div class="form-group">
                        <label for="nombre"><i class="fas fa-user"></i> Nombre *</label>
                        <input type="text" id="nombre" name="nombre" placeholder="Ingresa tu nombre" 
                               value="${param.nombre}" required>
                    </div>

                    <div class="form-group">
                        <label for="apellidopaterno"><i class="fas fa-user"></i> Apellido Paterno *</label>
                        <input type="text" id="apellidopaterno" name="apellidopaterno" 
                               placeholder="Ingresa tu apellido paterno" value="${param.apellidopaterno}" required>
                    </div>

                    <div class="form-group">
                        <label for="apellidomaterno"><i class="fas fa-user"></i> Apellido Materno *</label>
                        <input type="text" id="apellidomaterno" name="apellidomaterno" 
                               placeholder="Ingresa tu apellido materno" value="${param.apellidomaterno}" required>
                    </div>

                    <div class="form-group">
                        <label for="dni"><i class="fas fa-id-card"></i> DNI *</label>
                        <input type="text" id="dni" name="dni" placeholder="Ingresa tu DNI (8 dígitos)" 
                               pattern="[0-9]{8}" maxlength="8" 
                               value="${(param.error == 'dni' || param.error == 'ambos') ? '' : param.dni}" required>
                    </div>

                    <div class="form-group full-width">
                        <label for="direccion"><i class="fas fa-map-marker-alt"></i> Dirección *</label>
                        <input type="text" id="direccion" name="direccion" placeholder="Ingresa tu dirección completa" 
                               value="${param.direccion}" required>
                    </div>

                    <div class="form-group">
                        <label for="idDistrito"><i class="fas fa-city"></i> Distrito de Residencia *</label>
                        <select id="idDistrito" name="idDistrito" required>
                            <option value="">Selecciona tu distrito</option>
                            <c:forEach var="distrito" items="${distritos}">
                                <option value="${distrito.idDistrito}" 
                                        ${param.idDistrito == distrito.idDistrito ? 'selected' : ''}>
                                    ${distrito.nombreDistrito}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="correo"><i class="fas fa-envelope"></i> Correo Electrónico *</label>
                        <input type="email" id="correo" name="correo" placeholder="ejemplo@correo.com" 
                               value="${(param.error == 'correo' || param.error == 'ambos') ? '' : param.correo}" required>
                    </div>

                    <!-- Contraseñas -->
                    <div class="form-group">
                        <label for="contrasenha"><i class="fas fa-lock"></i> Contraseña *</label>
                        <input type="password" id="contrasenha" name="contrasenha" 
                               placeholder="Crea tu contraseña" required>
                        <div class="password-requirements">
                            <strong>La contraseña debe contener:</strong>
                            <ul id="passwordChecklist">
                                <li id="length" class="invalid">• Mínimo 8 caracteres</li>
                                <li id="uppercase" class="invalid">• Al menos una letra mayúscula</li>
                                <li id="lowercase" class="invalid">• Al menos una letra minúscula</li>
                                <li id="number" class="invalid">• Al menos un número</li>
                                <li id="special" class="invalid">• Al menos un carácter especial (!@#$%^&*)</li>
                            </ul>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="confirmarContrasenha"><i class="fas fa-check-double"></i> Confirmar Contraseña *</label>
                        <input type="password" id="confirmarContrasenha" name="confirmarContrasenha" 
                               placeholder="Confirma tu contraseña" required>
                    </div>

                    <!-- Foto de perfil -->
                    <div class="form-group full-width">
                        <label for="foto"><i class="fas fa-camera"></i> Foto de Perfil (Opcional)</label>
                        <input type="file" id="foto" name="foto" accept="image/*">
                    </div>
                </div>

                <div class="form-actions">
                    <button type="button" class="btn-secondary" onclick="window.location.href='login.jsp'">
                        <i class="fas fa-arrow-left"></i> Volver al Login
                    </button>
                    <button type="submit" class="btn-primary" id="submitBtn" disabled>
                        <i class="fas fa-user-plus"></i> Registrarse
                    </button>
                </div>
            </form>

            <div class="login-link">
                <a href="login.jsp"><i class="fas fa-sign-in-alt"></i> ¿Ya tienes cuenta? Inicia sesión aquí</a>
            </div>
        </section>
    </main>

    <!-- Pie de página -->
    <footer class="footer-bar">
        <i class="fas fa-heart"></i> Defensora mundial de la igualdad de género
    </footer>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const passwordInput = document.getElementById('contrasenha');
        const confirmPasswordInput = document.getElementById('confirmarContrasenha');
        const submitBtn = document.getElementById('submitBtn');
        const dniInput = document.getElementById('dni');

        // Validación en tiempo real de contraseña
        passwordInput.addEventListener('input', validarPassword);
        confirmPasswordInput.addEventListener('input', validarFormulario);
        dniInput.addEventListener('input', validarFormulario);

        function validarPassword() {
            const password = passwordInput.value;
            const requirements = {
                length: password.length >= 8,
                uppercase: /[A-Z]/.test(password),
                lowercase: /[a-z]/.test(password),
                number: /\d/.test(password),
                special: /[!@#$%^&*(),.?":{}|<>]/.test(password)
            };

            // Actualizar lista visual
            Object.keys(requirements).forEach(req => {
                const element = document.getElementById(req);
                if (element) {
                    element.className = requirements[req] ? 'valid' : 'invalid';
                }
            });

            validarFormulario();
        }

        function validarFormulario() {
            const password = passwordInput.value;
            const confirmPassword = confirmPasswordInput.value;
            const dni = dniInput.value;

            const passwordValido = password.length >= 8 && 
                                 /[A-Z]/.test(password) && 
                                 /[a-z]/.test(password) && 
                                 /\d/.test(password) && 
                                 /[!@#$%^&*(),.?":{}|<>]/.test(password);
            const passwordsCoinciden = password === confirmPassword && password.length > 0;
            const dniValido = /^\d{8}$/.test(dni);

            submitBtn.disabled = !(passwordValido && passwordsCoinciden && dniValido);
        }

        // Validación del formulario al enviar
        document.getElementById('registrationForm').addEventListener('submit', function(e) {
            const password = passwordInput.value;
            const confirmPassword = confirmPasswordInput.value;
            const dni = dniInput.value;

            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Las contraseñas no coinciden.');
                return false;
            }

            if (!/^\d{8}$/.test(dni)) {
                e.preventDefault();
                alert('El DNI debe contener exactamente 8 números.');
                return false;
            }

            return true;
        });

        // Validar formulario inicialmente
        validarFormulario();
    });
</script>

</body>
</html>
