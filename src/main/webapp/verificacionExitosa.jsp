<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Verificación Exitosa - ONU Mujeres</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: Arial, sans-serif; background-color: #f5f5f5; }
    .main-container { display: flex; flex-direction: column; min-height: 100vh; }
    .header-bar { background-color: #dbeeff; height: 50px; display: flex; align-items: center; justify-content: center; }
    .header-bar img { height: 30px; }
    .content-container { display: flex; flex: 1; }
    .success-section { 
      flex: 1; 
      display: flex; 
      align-items: center; 
      justify-content: center; 
      padding: 40px; 
      background-color: #fff;
    }
    .success-box {
      text-align: center;
      max-width: 500px;
      padding: 40px;
      border-radius: 15px;
      box-shadow: 0 8px 32px rgba(0,0,0,0.1);
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
    }
    .success-icon {
      font-size: 64px;
      color: #4CAF50;
      margin-bottom: 20px;
      background: white;
      border-radius: 50%;
      width: 100px;
      height: 100px;
      display: flex;
      align-items: center;
      justify-content: center;
      margin: 0 auto 20px auto;
    }
    .success-box h2 {
      font-size: 28px;
      margin-bottom: 15px;
      font-weight: bold;
    }
    .success-box p {
      font-size: 16px;
      margin-bottom: 30px;
      line-height: 1.6;
      opacity: 0.9;
    }
    .login-btn {
      background: #4CAF50;
      color: white;
      border: none;
      padding: 12px 30px;
      border-radius: 8px;
      font-size: 16px;
      cursor: pointer;
      transition: background 0.3s;
      text-decoration: none;
      display: inline-block;
      font-weight: 500;
    }
    .login-btn:hover {
      background: #45a049;
      text-decoration: none;
      color: white;
    }
    .footer-bar {
      background-color: #333;
      color: white;
      text-align: center;
      padding: 15px;
      font-size: 14px;
    }
    .image-section {
      flex: 1;
      background: url('imagenes/portada.jpg') center/cover;
      min-height: 400px;
    }
  </style>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
<div class="main-container">
  <!-- Barra superior -->
  <header class="header-bar">
    <img src="imagenes/logo.jpg" alt="Logo ONU Mujeres">
  </header>

  <!-- Contenido principal -->
  <main class="content-container">
    <!-- Sección de imagen -->
    <section class="image-section">
      <img src="imagenes/portada.jpg" alt="Imagen principal" style="width: 100%; height: 100%; object-fit: cover;">
    </section>

    <!-- Sección de verificación exitosa -->
    <section class="success-section">
      <div class="success-box">
        <div class="success-icon">
          <i class="fas fa-check"></i>
        </div>
        <h2>¡Verificación Exitosa!</h2>
        <p>
          Tu cuenta ha sido verificada correctamente y tu contraseña ha sido establecida. 
          Ya puedes iniciar sesión con tus credenciales.
        </p>
        <a href="login.jsp" class="login-btn">
          <i class="fas fa-sign-in-alt"></i> Iniciar Sesión
        </a>
      </div>
    </section>
  </main>

  <!-- Pie de página -->
  <footer class="footer-bar">
    Defensora mundial de la igualdad de género
  </footer>
</div>
</body>
</html>
