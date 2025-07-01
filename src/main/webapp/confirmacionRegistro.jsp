<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
    // Verificar si el usuario acaba de completar el registro
    Boolean registroCompletado = (Boolean) session.getAttribute("registroCompletado");
    String nombreUsuario = (String) session.getAttribute("nombreUsuario");
    
    // Si no hay sesión de registro completado, redirigir al login
    if (registroCompletado == null || !registroCompletado) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Limpiar los atributos de sesión para que no se vuelvan a mostrar
    session.removeAttribute("registroCompletado");
    session.removeAttribute("nombreUsuario");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro Exitoso - ONU Mujeres</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #a8d8ff 0%, #87ceeb 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #333;
        }
        
        .confirmation-container {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            text-align: center;
            max-width: 500px;
            width: 90%;
            position: relative;
            overflow: hidden;
        }
        
        .confirmation-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(90deg, #87ceeb, #5fa3d3, #87ceeb);
        }
        
        .success-icon {
            font-size: 4rem;
            color: #28a745;
            margin-bottom: 20px;
            animation: bounceIn 0.8s ease-out;
        }
        
        @keyframes bounceIn {
            0% {
                transform: scale(0.3);
                opacity: 0;
            }
            50% {
                transform: scale(1.05);
            }
            70% {
                transform: scale(0.9);
            }
            100% {
                transform: scale(1);
                opacity: 1;
            }
        }
        
        .confirmation-title {
            font-size: 2rem;
            font-weight: 700;
            color: #5fa3d3;
            margin-bottom: 15px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .confirmation-message {
            font-size: 1.1rem;
            color: #666;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        
        .user-info {
            background: linear-gradient(135deg, #e8f4f8 0%, #d4edda 100%);
            border: 2px solid #b8dacc;
            border-radius: 12px;
            padding: 20px;
            margin: 20px 0;
            color: #155724;
        }
        
        .user-info i {
            color: #5fa3d3;
            margin-right: 8px;
        }
        
        .continue-btn {
            background: linear-gradient(135deg, #87ceeb 0%, #5fa3d3 100%);
            color: white;
            border: none;
            padding: 15px 40px;
            border-radius: 50px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 6px 20px rgba(135,206,235,0.4);
            text-decoration: none;
            display: inline-block;
        }
        
        .continue-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(135,206,235,0.5);
        }
        
        .footer-text {
            margin-top: 25px;
            font-size: 0.9rem;
            color: #888;
        }
        
        @media (max-width: 600px) {
            .confirmation-container {
                padding: 30px 20px;
                margin: 20px;
            }
            
            .confirmation-title {
                font-size: 1.6rem;
            }
            
            .success-icon {
                font-size: 3rem;
            }
        }
    </style>
</head>
<body>
    <div class="confirmation-container">
        <div class="success-icon">
            <i class="fas fa-check-circle"></i>
        </div>
        
        <h1 class="confirmation-title">¡Registro Exitoso!</h1>
        
        <p class="confirmation-message">
            Tu cuenta ha sido verificada correctamente y ya está activa.
        </p>
        
        <div class="user-info">
            <p><i class="fas fa-envelope"></i> <strong>Correo:</strong> <%= nombreUsuario %></p>
            <p><i class="fas fa-check"></i> <strong>Estado:</strong> Cuenta verificada y activa</p>
        </div>
        
        <p class="confirmation-message">
            Ahora puedes iniciar sesión con tu correo electrónico y la contraseña que estableciste.
        </p>
        
        <a href="login.jsp" class="continue-btn">
            <i class="fas fa-sign-in-alt"></i> Ir al Login
        </a>
        
        <p class="footer-text">
            ¡Bienvenido/a a la plataforma de ONU Mujeres!
        </p>
    </div>

    <script>
        // Prevenir que el usuario vuelva atrás
        history.pushState(null, null, location.href);
        window.onpopstate = function () {
            history.go(1);
        };
        
        // Auto-redirigir después de 10 segundos si no hace clic
        setTimeout(function() {
            window.location.href = 'login.jsp';
        }, 10000);
    </script>
</body>
</html>
