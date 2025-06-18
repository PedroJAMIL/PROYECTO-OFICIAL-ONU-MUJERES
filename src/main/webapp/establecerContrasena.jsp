<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Establecer Contraseña</title>
  <style>
    /* Copia los estilos principales de registro.jsp */
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: Arial, sans-serif; background-color: #f5f5f5; }
    .main-container { display: flex; flex-direction: column; min-height: 100vh; }
    .header-bar { background-color: #dbeeff; height: 50px; display: flex; align-items: center; justify-content: center; }
    .header-bar img { height: 30px; }
    .content { display: flex; flex: 1; padding: 1rem; }
    .image-section { flex: 3; background-color: #ccc; display: flex; align-items: center; justify-content: center; }
    .image-section img { max-width: 80%; height: auto; }
    .login-section { flex: 1.2; background-color: #ffffff; padding: 2rem; display: flex; flex-direction: column; justify-content: center; }
    .login-section h4 { text-align: center; font-weight: bold; margin-bottom: 1.5rem; font-size: 1.8rem; }
    .login-section form { display: flex; flex-direction: column; }
    .login-section input { padding: 10px; margin-bottom: 10px; border: 1.5px solid #000; border-radius: 4px; font-size: 14px; }
    .login-btn { padding: 10px; background-color: #649CFF; color: white; font-size: 15px; border: none; border-radius: 5px; cursor: pointer; margin-bottom: 10px; width: 200px; margin: 0 auto; }
    .login-btn:hover { background-color: #507cd9; }
    .footer-bar { background-color: white; height: 40px; border-top: 1px solid #ccc; display: flex; align-items: center; padding-left: 1rem; font-weight: bold; }
    .error-message { color: red; font-size: 12px; margin-bottom: 10px; text-align: center; }
  </style>
</head>
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

    <!-- Sección para establecer contraseña -->
    <section class="login-section">
      <h4>Establecer Contraseña</h4>      <c:if test="${not empty error}">
        <div class="error-message">${error}</div>
      </c:if>

      <form action="establecerContrasena" method="POST" id="passwordForm">
        <input type="hidden" name="codigo" value="${param.codigo}${codigo}" />
        
        <div class="password-requirements">
          <h5>Requisitos de la contraseña:</h5>
          <ul>
            <li id="length">Al menos 8 caracteres</li>
            <li id="uppercase">Una letra mayúscula</li>
            <li id="lowercase">Una letra minúscula</li>
            <li id="number">Un número</li>
          </ul>
        </div>
        
        <input type="password" name="contrasena" id="password" placeholder="Nueva contraseña" required>
        <input type="password" name="confirmarContrasena" id="confirmPassword" placeholder="Confirmar contraseña" required>
        <div id="password-match" class="password-feedback"></div>
        
        <button type="submit" class="login-btn" id="submitBtn" disabled>Guardar Contraseña</button>
      </form>
      
      <style>
        .password-requirements {
          background: #f8f9fa;
          border: 1px solid #dee2e6;
          border-radius: 8px;
          padding: 15px;
          margin: 15px 0;
          font-size: 14px;
        }
        .password-requirements h5 {
          margin: 0 0 10px 0;
          color: #495057;
        }
        .password-requirements ul {
          margin: 0;
          padding-left: 20px;
        }
        .password-requirements li {
          margin: 5px 0;
          color: #dc3545;
        }
        .password-requirements li.valid {
          color: #28a745;
        }
        .password-feedback {
          margin-top: 10px;
          font-size: 14px;
          font-weight: 500;
        }
        .password-feedback.match {
          color: #28a745;
        }
        .password-feedback.no-match {
          color: #dc3545;
        }
        .login-btn:disabled {
          background: #6c757d;
          cursor: not-allowed;
        }
      </style>
      
      <script>
        const password = document.getElementById('password');
        const confirmPassword = document.getElementById('confirmPassword');
        const submitBtn = document.getElementById('submitBtn');
        const matchDiv = document.getElementById('password-match');
        
        function validatePassword() {
          const pwd = password.value;
          const requirements = {
            length: pwd.length >= 8,
            uppercase: /[A-Z]/.test(pwd),
            lowercase: /[a-z]/.test(pwd),
            number: /\d/.test(pwd)
          };
          
          // Actualizar indicadores visuales
          Object.keys(requirements).forEach(req => {
            const element = document.getElementById(req);
            if (requirements[req]) {
              element.classList.add('valid');
            } else {
              element.classList.remove('valid');
            }
          });
          
          return Object.values(requirements).every(Boolean);
        }
        
        function validateConfirm() {
          const match = password.value === confirmPassword.value && password.value.length > 0;
          
          if (confirmPassword.value.length > 0) {
            if (match) {
              matchDiv.textContent = '✓ Las contraseñas coinciden';
              matchDiv.className = 'password-feedback match';
            } else {
              matchDiv.textContent = '✗ Las contraseñas no coinciden';
              matchDiv.className = 'password-feedback no-match';
            }
          } else {
            matchDiv.textContent = '';
            matchDiv.className = 'password-feedback';
          }
          
          return match;
        }
        
        function updateSubmitButton() {
          const passwordValid = validatePassword();
          const confirmValid = validateConfirm();
          submitBtn.disabled = !(passwordValid && confirmValid);
        }
        
        password.addEventListener('input', updateSubmitButton);
        confirmPassword.addEventListener('input', updateSubmitButton);
        
        document.getElementById('passwordForm').addEventListener('submit', function(e) {
          if (!validatePassword() || !validateConfirm()) {
            e.preventDefault();
            alert('Por favor, completa todos los requisitos de contraseña.');
          }
        });
      </script>
    </section>
  </main>

  <!-- Pie de página -->
  <footer class="footer-bar">
    Defensora mundial de la igualdad de género
  </footer>
</div>
</body>
</html>