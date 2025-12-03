<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.sgu.cakeshopserive.model.Goods" %>
<!DOCTYPE html>
<html>
<head>
    <title>环创店 - 首页</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/style.css">
    <script>
        function goToDetail(event, goodsId) {
            if (goodsId && goodsId !== 'null') {
                window.location.href = 'goods?action=detail&goodsId=' + goodsId;
            }
        }

        function showDemoMessage(goodsName) {
            alert('您点击的是示例商品：' + goodsName + '\n\n实际使用时，这里会跳转到真实的商品详情页面。');
        }
    </script>
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
            margin-bottom: 0;
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

        /* 商品展示区域 */
        .products-section {
            margin-top: 40px;
        }

        .section-title {
            text-align: center;
            color: #5D4037;
            font-size: 32px;
            margin-bottom: 40px;
            font-weight: bold;
        }

        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 30px;
            margin-bottom: 40px;
        }

        .product-card {
            background-color: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .product-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .product-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .product-card:hover .product-image {
            transform: scale(1.05);
        }

        .product-info {
            padding: 20px;
        }

        .product-category {
            color: #FF9800;
            font-size: 14px;
            font-weight: bold;
            margin-bottom: 8px;
            text-transform: uppercase;
        }

        .product-name {
            color: #5D4037;
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .product-description {
            color: #666;
            font-size: 14px;
            line-height: 1.5;
            margin-bottom: 15px;
        }

        .product-price {
            color: #FF5722;
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 15px;
        }

        .product-actions {
            display: flex;
            gap: 10px;
        }

        .btn-add-cart, .btn-view-detail {
            flex: 1;
            padding: 10px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            text-align: center;
        }

        .btn-add-cart {
            background-color: #FF9800;
            color: white;
        }

        .btn-add-cart:hover {
            background-color: #F57C00;
        }

        .btn-view-detail {
            background-color: #5D4037;
            color: white;
        }

        .btn-view-detail:hover {
            background-color: #4E342E;
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
            <a href="index.jsp" class="logo">环创店</a>
            <nav>
                <ul class="nav-menu">
                    <li><a href="index.jsp" class="active">首页</a></li>
                    <li><a href="#">商品分类 ▼</a></li>
                    <li><a href="#">热销</a></li>
                    <li><a href="#">新品</a></li>
                    <%
                        String username = (String) session.getAttribute("username");
                        if (username == null) {
                    %>
                    <li><a href="register.jsp">注册</a></li>
                    <li><a href="login.jsp">登录</a></li>
                    <%
                        } else {
                    %>
                    <li><a href="#">欢迎，<%= username %></a></li>
                    <li><a href="logout">退出</a></li>
                    <%
                        }
                    %>
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
            <h1 class="welcome-title">欢迎来到环创店</h1>
            <p class="welcome-subtitle">发现美味蛋糕，享受甜蜜生活</p>
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

        <!-- 商品展示区域 -->
        <section class="products-section">
            <h2 class="section-title">精选商品</h2>
            <div class="products-grid">
                <%
                    // 从request中获取动态加载的商品数据
                    List<Goods> goodsList = (List<Goods>) request.getAttribute("goodsList");
                    Map<Integer, String> typeMap = (Map<Integer, String>) request.getAttribute("typeMap");

                    if (goodsList != null && !goodsList.isEmpty()) {
                        for (Goods goods : goodsList) {
                            String typeName = typeMap != null ? typeMap.get(goods.getTypeId()) : "未分类";
                            String imageUrl = goods.getCoverImage() != null && !goods.getCoverImage().isEmpty() ? goods.getCoverImage() : "images/default.jpg";
                %>
                <div class="product-card" onclick="goToDetail(event, '<%= goods.getGoodsId() %>')" style="cursor: pointer;">
                    <img src="<%= imageUrl %>" alt="<%= goods.getGoodsName() %>" class="product-image">
                    <div class="product-info">
                        <div class="product-category"><%= typeName %></div>
                        <h3 class="product-name"><%= goods.getGoodsName() %></h3>
                        <p class="product-description"><%= goods.getDescription() %></p>
                        <div class="product-price">¥<%= String.format("%.2f", goods.getPrice()) %></div>
                        <div class="product-actions">
                            <a href="cart?action=add&goodsId=<%= goods.getGoodsId() %>" class="btn-add-cart" onclick="event.stopPropagation()">加入购物车</a>
                            <a href="goods?action=detail&goodsId=<%= goods.getGoodsId() %>" class="btn-view-detail" onclick="event.stopPropagation()">查看详情</a>
                        </div>
                    </div>
                </div>
                <%
                        }
                    } else {
                        // 如果没有动态数据，跳转到错误页面
                        request.setAttribute("error", "暂无商品数据，请稍后再试或联系管理员");
                        request.getRequestDispatcher("/error.jsp").forward(request, response);
                        return;
                    }
                    %>
            </div>
        </section>
    </main>

    <footer>
        <p>&copy; 2025 环创店. 保留所有权利.</p>
    </footer>
</body>
</html>