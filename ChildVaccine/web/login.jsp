<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Login - Vaccine Management System</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Poppins', sans-serif;
            }

            body {
                background-color: #f0f2f5;
                color: #333;
                line-height: 1.6;
            }

            .hero-section {
                background: linear-gradient(135deg, rgba(30,136,229,0.95), rgba(30,136,229,0.8)),
                            url('https://img.freepik.com/free-photo/doctor-getting-patient-ready-covid-vaccination_23-2149850142.jpg?w=2000');
                background-size: cover;
                background-position: center;
                padding: 120px 0;
                text-align: center;
                color: white;
                position: relative;
                overflow: hidden;
            }

            .hero-section::before {
                content: '';
                position: absolute;
                bottom: 0;
                left: 0;
                right: 0;
                height: 100px;
                background: linear-gradient(to bottom, transparent, #f0f2f5);
            }

            .hero-content {
                max-width: 800px;
                margin: 0 auto;
                padding: 0 20px;
                position: relative;
                z-index: 1;
            }

            .hero-title {
                font-size: 3.5em;
                margin-bottom: 20px;
                font-weight: 700;
                text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
                letter-spacing: -1px;
            }

            .hero-subtitle {
                font-size: 1.3em;
                margin-bottom: 30px;
                text-shadow: 1px 1px 2px rgba(0,0,0,0.2);
                font-weight: 300;
            }

            .login-container {
                max-width: 1200px;
                margin: -80px auto 40px;
                padding: 0 20px;
                position: relative;
                z-index: 2;
            }

            .login-box {
                background: white;
                padding: 50px;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                width: 100%;
                max-width: 500px;
                margin: 0 auto;
                position: relative;
                overflow: hidden;
            }

            .login-box::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 5px;
                background: linear-gradient(90deg, #1e88e5, #64b5f6);
            }

            .form-title {
                text-align: center;
                color: #1e88e5;
                margin-bottom: 40px;
                font-size: 2.2em;
                font-weight: 600;
            }

            .form-title i {
                font-size: 0.9em;
                margin-right: 10px;
                background: linear-gradient(45deg, #1e88e5, #64b5f6);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
            }

            .form-group {
                margin-bottom: 25px;
                position: relative;
            }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                color: #333;
                font-weight: 500;
                font-size: 1.1em;
            }

            .form-group input {
                width: 100%;
                padding: 15px 20px;
                border: 2px solid #e0e0e0;
                border-radius: 12px;
                font-size: 1.1em;
                transition: all 0.3s ease;
                background: #f8f9fa;
            }

            .form-group input:focus {
                border-color: #1e88e5;
                background: white;
                box-shadow: 0 0 0 4px rgba(30,136,229,0.1);
                outline: none;
            }

            .form-group i {
                position: absolute;
                right: 15px;
                top: 50%;
                transform: translateY(-50%);
                color: #1e88e5;
                font-size: 1.2em;
            }

            .btn {
                width: 100%;
                padding: 15px;
                border: none;
                border-radius: 12px;
                font-size: 1.1em;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            .btn-primary {
                background: linear-gradient(45deg, #1e88e5, #64b5f6);
                color: white;
                margin-bottom: 15px;
            }

            .btn-secondary {
                background: #f8f9fa;
                color: #333;
                border: 2px solid #e0e0e0;
            }

            .btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 15px rgba(0,0,0,0.1);
            }

            .btn-primary:hover {
                background: linear-gradient(45deg, #1976d2, #42a5f5);
            }

            .error-message {
                background: #fee;
                color: #e53935;
                padding: 15px;
                border-radius: 12px;
                margin-bottom: 25px;
                font-size: 0.95em;
                display: flex;
                align-items: center;
                gap: 10px;
                border-left: 4px solid #e53935;
            }

            .divider {
                text-align: center;
                margin: 30px 0;
                position: relative;
            }

            .divider::before,
            .divider::after {
                content: '';
                position: absolute;
                top: 50%;
                width: 45%;
                height: 1px;
                background: #e0e0e0;
            }

            .divider::before { left: 0; }
            .divider::after { right: 0; }

            .divider span {
                background: white;
                padding: 0 15px;
                color: #666;
                font-size: 0.9em;
                font-weight: 500;
            }

            .register-link {
                text-align: center;
                margin-top: 25px;
            }

            .register-link a {
                color: #1e88e5;
                text-decoration: none;
                font-weight: 500;
                font-size: 1.1em;
                transition: all 0.3s ease;
            }

            .register-link a:hover {
                color: #1565c0;
                text-decoration: underline;
            }

            @media (max-width: 768px) {
                .hero-title {
                    font-size: 2.5em;
                }
                
                .login-box {
                    padding: 30px;
                    margin: 0 15px;
                }
                
                .form-title {
                    font-size: 1.8em;
                }
                
                .btn {
                    padding: 12px;
                }
            }
        </style>
    </head>
    <body>
        <% String previousUrl = request.getParameter("previousUrl");
           if (previousUrl == null) previousUrl = "vaccinationSchedule.jsp"; %>

        <div class="hero-section">
            <div class="hero-content">
                <h1 class="hero-title">Welcome Back!</h1>
                <p class="hero-subtitle">Sign in to continue your baby's health journey</p>
            </div>
        </div>

        <div class="login-container">
            <div class="login-box">
                <h2 class="form-title">
                    <i class="fas fa-user-circle"></i>
                    Login
                </h2>
                
                <form action="MainController" method="POST">
                    <input type="hidden" name="previousUrl" value="<%= previousUrl %>">
                    
                    <div class="form-group">
                        <label for="userID">Username</label>
                        <input type="text" 
                               id="userID" 
                               name="userID" 
                               placeholder="Nhập tài khoản của bạn" 
                               required>
                        <i class="fas fa-user"></i>
                    </div>
                    
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" 
                               id="password" 
                               name="password" 
                               placeholder="Nhập mật khẩu của bạn" 
                               required>
                        <i class="fas fa-lock"></i>
                    </div>

                    <% String error = (String) request.getAttribute("ERROR");
                       if (error != null && !error.isEmpty()) { %>
                    <div class="error-message">
                        <i class="fas fa-exclamation-circle"></i>
                        <%= error %>
                    </div>
                    <% } %>

                    <button type="submit" name="action" value="Login" class="btn btn-primary">
                        <i class="fas fa-sign-in-alt"></i> Login
                    </button>
                    
                    <button type="reset" class="btn btn-secondary">
                        <i class="fas fa-redo"></i> Refresh
                    </button>

                    <div class="divider">
                        <span>OR</span>
                    </div>

                    <div class="register-link">
                        <a href="createUser.jsp">
                            <i class="fas fa-user-plus"></i> Don't have an account? Sign up now
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>