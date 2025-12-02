<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>传智店 - 首页</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/style.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
        }

        /* 顶部导航栏 */
        .header {
            background-color: #5D4037;
            color: white;
            padding: 15px 0;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
        }

        .logo {
            font-size: 24px;
            font-weight: bold;
            color: white;
            text-decoration: none;
            transition: color 0.3s;
        }

        .logo:hover {
            color: #FF9800;
        }

        .nav-menu {
            display: flex;
            list-style: none;
            gap: 30px;
        }

        .nav-menu a {
            color: white;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 4px;
            transition: background-color 0.3s;
            font-size: 16px;
        }

        .nav-menu a:hover {
            background-color: #6D4C41;
        }

        .nav-menu a.active {
            background-color: #FF9800;
            color: white;
        }

        .nav-actions {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .search-icon, .cart-icon {
            color: white;
            text-decoration: none;
            font-size: 18px;
            transition: color 0.3s;
        }

        .search-icon:hover, .cart-icon:hover {
            color: #FF9800;
        }

        .cart-count {
            position: relative;
            top: -8px;
            right: -8px;
            background-color: #FF9800;
            color: white;
            border-radius: 50%;
            width: 16px;
            height: 16px;
            font-size: 10px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        /* 主内容区 */
        .main-container {
            max-width: 1200px;
            margin: 50px auto;
            padding: 0 20px;
        }

        .welcome-section {
            text-align: center;
            background-color: white;
            padding: 60px 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 40px;
        }

        .welcome-title {
            color: #5D4037;
            font-size: 36px;
            margin-bottom: 20px;
            font-weight: bold;
        }

        .welcome-subtitle {
            color: #666;
            font-size: 18px;
            margin-bottom: 30px;
        }

        .cta-buttons {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 30px;
        }

        .btn-primary, .btn-secondary {
            padding: 15px 30px;
            border-radius: 4px;
            text-decoration: none;
            font-size: 16px;
            font-weight: bold;
            transition: all 0.3s;
        }

        .btn-primary {
            background-color: #FF9800;
            color: white;
        }

        .btn-primary:hover {
            background-color: #F57C00;
            transform: translateY(-2px);
        }

        .btn-secondary {
            background-color: #5D4037;
            color: white;
        }

        .btn-secondary:hover {
            background-color: #4E342E;
            transform: translateY(-2px);
        }

        .features-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin-top: 40px;
        }

        .feature-card {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
            transition: transform 0.3s;
        }

        .feature-card:hover {
            transform: translateY(-5px);
        }

        .feature-icon {
            font-size: 48px;
            margin-bottom: 20px;
            color: #FF9800;
        }

        .feature-title {
            color: #5D4037;
            font-size: 20px;
            margin-bottom: 15px;
            font-weight: bold;
        }

        .feature-description {
            color: #666;
            line-height: 1.6;
        }

        footer {
            background-color: #5D4037;
            color: white;
            text-align: center;
            padding: 20px 0;
            margin-top: 50px;
        }
    </style>
</head>
<body>
    <!-- 顶部导航栏 -->
    <header class="header">
        <div class="nav-container">
            <a href="index.jsp" class="logo">传智店</a>
            <nav>
                <ul class="nav-menu">
                    <li><a href="index.jsp" class="active">首页</a></li>
                    <li><a href="#">商品分类 ▼</a></li>
                    <li><a href="#">热销</a></li>
                    <li><a href="#">新品</a></li>
                    <li><a href="register.jsp">注册</a></li>
                    <li><a href="login.jsp">登录</a></li>
                </ul>
            </nav>
            <div class="nav-actions">
                <a href="#" class="search-icon">🔍</a>
                <a href="#" class="cart-icon">
                    🛒
                    <span class="cart-count">0</span>
                </a>
            </div>
        </div>
    </header>

    <!-- 主内容区 -->
    <main class="main-container">
        <section class="welcome-section">
            <h1 class="welcome-title">欢迎来到传智店</h1>
            <p class="welcome-subtitle">发现美味蛋糕，享受甜蜜生活</p>

            <div class="cta-buttons">
                <a href="register.jsp" class="btn-primary">立即注册</a>
                <a href="#" class="btn-secondary">浏览商品</a>
            </div>
        </section>

        <section class="features-section">
            <div class="feature-card">
                <div class="feature-icon">🎂</div>
                <h3 class="feature-title">精美蛋糕</h3>
                <p class="feature-description">手工制作的新鲜蛋糕，多种口味选择，满足您的味蕾需求</p>
            </div>

            <div class="feature-card">
                <div class="feature-icon">🚚</div>
                <h3 class="feature-title">快速配送</h3>
                <p class="feature-description">同城快速配送，保证蛋糕新鲜送达，准时送达您的手中</p>
            </div>

            <div class="feature-card">
                <div class="feature-icon">💯</div>
                <h3 class="feature-title">品质保证</h3>
                <p class="feature-description">选用优质原料，严格品控，为您带来最佳的味觉体验</p>
            </div>
        </section>
    </main>

    <footer>
        <p>&copy; 2024 传智店. 保留所有权利.</p>
    </footer>
</body>
</html>