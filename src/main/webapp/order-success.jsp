<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    String orderId = request.getParameter("orderId");
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    String currentTime = dateFormat.format(new Date());
%>
<!DOCTYPE html>
<html>
<head>
    <title>环创店 - 订单成功</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/style.css">
    <script>
        function continueShopping() {
            window.location.href = 'index.jsp';
        }

        function viewOrders() {
            window.location.href = 'order?action=list';
        }

        function trackOrder() {
            window.location.href = 'order?action=detail&orderId=${orderId}';
        }

        function shareOrder() {
            if (navigator.share) {
                navigator.share({
                    title: '环创店订单',
                    text: '我在环创店下了一个订单，订单号：${orderId}',
                    url: window.location.href
                });
            } else {
                // 复制链接到剪贴板
                const url = window.location.href;
                navigator.clipboard.writeText(url).then(function() {
                    alert('订单链接已复制到剪贴板');
                });
            }
        }

        // 5秒后自动跳转到首页
        setTimeout(function() {
            continueShopping();
        }, 10000);

        // 显示倒计时
        let countdown = 10;
        setInterval(function() {
            countdown--;
            document.getElementById('countdown').textContent = countdown;
            if (countdown <= 0) {
                clearInterval(this);
            }
        }, 1000);
    </script>
</head>
<body>
    <!-- 顶部导航栏 -->
    <header class="header">
        <div class="nav-container">
            <a href="index.jsp" class="logo">环创店</a>
            <nav>
                <ul class="nav-menu">
                    <li><a href="index.jsp">首页</a></li>
                    <li><a href="#">商品分类 ▼</a></li>
                    <li><a href="#">热销</a></li>
                    <li><a href="#">新品</a></li>
                    <li><a href="cart">购物车</a></li>
                    <li><a href="#">我的订单</a></li>
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
                <a href="cart" class="cart-icon">
                    🛒
                    <span class="cart-count">${cartCount != null ? cartCount : 0}</span>
                </a>
            </div>
        </div>
    </header>

    <!-- 主内容区 -->
    <main class="main-container">
        <div class="order-success-container">
            <!-- 成功图标和消息 -->
            <div class="success-section">
                <div class="success-icon">✅</div>
                <h1 class="success-title">订单提交成功！</h1>
                <p class="success-message">
                    恭喜您！您的订单已经成功提交，我们会尽快为您准备商品。
                </p>
            </div>

            <!-- 订单信息 -->
            <div class="order-info-section">
                <h2 class="section-title">📋 订单信息</h2>
                <div class="order-info">
                    <div class="info-item">
                        <span class="info-label">订单号：</span>
                        <span class="info-value order-number"><%= orderId != null ? orderId : "未知" %></span>
                        <button class="btn-copy" onclick="shareOrder()">📋 分享</button>
                    </div>
                    <div class="info-item">
                        <span class="info-label">下单时间：</span>
                        <span class="info-value"><%= currentTime %></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">订单状态：</span>
                        <span class="info-value status-processing">处理中</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">预计送达：</span>
                        <span class="info-value">2-3个工作日</span>
                    </div>
                </div>
            </div>

            <!-- 后续操作 -->
            <div class="actions-section">
                <h2 class="section-title">🎯 接下来您可以</h2>
                <div class="action-buttons">
                    <button class="btn btn-primary btn-large" onclick="continueShopping()">
                        🛍️ 继续购物
                    </button>
                    <button class="btn btn-secondary btn-large" onclick="viewOrders()">
                        📦 查看订单
                    </button>
                    <button class="btn btn-outline btn-large" onclick="trackOrder()">
                        🔍 物流跟踪
                    </button>
                </div>
                <div class="auto-redirect">
                    <p>
                        <span class="countdown-text">
                            <span id="countdown">10</span>秒后自动跳转到首页
                        </span>
                    </p>
                </div>
            </div>

            <!-- 温馨提示 -->
            <div class="tips-section">
                <h2 class="section-title">💡 温馨提示</h2>
                <div class="tips-list">
                    <div class="tip-item">
                        <span class="tip-icon">📱</span>
                        <div class="tip-content">
                            <h4>保存订单号</h4>
                            <p>请妥善保存您的订单号，以便查询订单状态和联系客服。</p>
                        </div>
                    </div>
                    <div class="tip-item">
                        <span class="tip-icon">💬</span>
                        <div class="tip-content">
                            <h4>联系客服</h4>
                            <p>如有任何问题，请随时联系我们的客服团队。</p>
                        </div>
                    </div>
                    <div class="tip-item">
                        <span class="tip-icon">🚚</span>
                        <div class="tip-content">
                            <h4>配送说明</h4>
                            <p>我们会在确认订单后尽快安排配送，请保持手机畅通。</p>
                        </div>
                    </div>
                    <div class="tip-item">
                        <span class="tip-icon">💳</span>
                        <div class="tip-content">
                            <h4>支付说明</h4>
                            <p>请及时完成支付，订单将在支付成功后开始处理。</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- 页脚 -->
    <footer>
        <p>&copy; 2025 环创店. 保留所有权利.</p>
    </footer>

    <style>
        /* 订单成功页面专用样式 */
        .order-success-container {
            max-width: 800px;
            margin: 20px auto;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .success-section {
            background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
            color: white;
            text-align: center;
            padding: 60px 40px;
        }

        .success-icon {
            font-size: 80px;
            margin-bottom: 20px;
            animation: successPulse 1.5s ease-in-out;
        }

        .success-title {
            font-size: 32px;
            font-weight: bold;
            margin: 0 0 15px 0;
            text-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }

        .success-message {
            font-size: 18px;
            margin: 0;
            line-height: 1.6;
            opacity: 0.95;
        }

        .order-info-section {
            padding: 40px 30px;
            background-color: #f9f9f9;
        }

        .section-title {
            color: #5D4037;
            font-size: 24px;
            margin-bottom: 25px;
            font-weight: bold;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .order-info {
            background-color: white;
            border-radius: 8px;
            padding: 25px;
            border-left: 4px solid #4CAF50;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .info-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #E0E0E0;
        }

        .info-item:last-child {
            border-bottom: none;
        }

        .info-label {
            font-size: 16px;
            color: #666;
            font-weight: 500;
        }

        .info-value {
            font-size: 16px;
            color: #333;
            font-weight: bold;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .order-number {
            color: #4CAF50;
            font-size: 18px;
            font-weight: bold;
            letter-spacing: 1px;
        }

        .status-processing {
            background-color: #FF9800;
            color: white;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
        }

        .btn-copy {
            background-color: #5D4037;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 500;
            transition: all 0.3s ease;
            white-space: nowrap;
        }

        .btn-copy:hover {
            background-color: #4E342E;
            transform: translateY(-2px);
        }

        .actions-section {
            padding: 40px 30px;
            text-align: center;
            background-color: white;
        }

        .action-buttons {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .btn-large {
            padding: 15px 30px;
            font-size: 18px;
            font-weight: bold;
        }

        .auto-redirect {
            background-color: #f9f9f9;
            border-radius: 8px;
            padding: 20px;
            border: 1px solid #E0E0E0;
        }

        .countdown-text {
            color: #666;
            font-size: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        #countdown {
            color: #FF9800;
            font-weight: bold;
            font-size: 20px;
            min-width: 30px;
            text-align: center;
        }

        .tips-section {
            padding: 30px;
            background-color: #f9f9f9;
            border-top: 1px solid #E0E0E0;
        }

        .tips-list {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            margin-top: 20px;
        }

        .tip-item {
            display: flex;
            gap: 15px;
            align-items: flex-start;
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            transition: transform 0.3s ease;
        }

        .tip-item:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .tip-icon {
            font-size: 24px;
            color: #FF9800;
            flex-shrink: 0;
        }

        .tip-content {
            flex: 1;
        }

        .tip-content h4 {
            color: #5D4037;
            font-size: 16px;
            margin: 0 0 8px 0;
            font-weight: bold;
        }

        .tip-content p {
            color: #666;
            font-size: 14px;
            margin: 0;
            line-height: 1.5;
        }

        /* 成功动画 */
        @keyframes successPulse {
            0% {
                transform: scale(0.5);
                opacity: 0;
            }
            50% {
                transform: scale(1.1);
                opacity: 1;
            }
            100% {
                transform: scale(1);
                opacity: 1;
            }
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .order-success-container {
                margin: 10px;
                border-radius: 8px;
            }

            .success-section {
                padding: 40px 20px;
            }

            .success-icon {
                font-size: 60px;
            }

            .success-title {
                font-size: 24px;
            }

            .success-message {
                font-size: 16px;
            }

            .order-info-section {
                padding: 30px 20px;
            }

            .section-title {
                font-size: 20px;
                justify-content: center;
            }

            .order-info {
                padding: 20px;
            }

            .info-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 8px;
                padding: 20px 0;
            }

            .info-value {
                align-items: center;
            }

            .order-number {
                font-size: 16px;
            }

            .btn-copy {
                margin-top: 8px;
                align-self: center;
            }

            .actions-section {
                padding: 30px 20px;
            }

            .action-buttons {
                grid-template-columns: 1fr;
                gap: 15px;
            }

            .btn-large {
                padding: 12px 20px;
                font-size: 16px;
            }

            .countdown-text {
                font-size: 14px;
            }

            #countdown {
                font-size: 18px;
            }

            .tips-section {
                padding: 20px;
            }

            .tips-list {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .tip-item {
                padding: 15px;
            }

            .tip-icon {
                font-size: 20px;
            }

            .tip-content h4 {
                font-size: 15px;
            }

            .tip-content p {
                font-size: 13px;
            }
        }

        @media (max-width: 480px) {
            .order-success-container {
                margin: 5px;
            }

            .success-section {
                padding: 30px 15px;
            }

            .success-icon {
                font-size: 50px;
            }

            .success-title {
                font-size: 20px;
            }

            .success-message {
                font-size: 14px;
            }

            .order-info-section {
                padding: 20px 15px;
            }

            .section-title {
                font-size: 18px;
            }

            .order-info {
                padding: 15px;
            }

            .info-label {
                font-size: 14px;
            }

            .info-value {
                font-size: 14px;
            }

            .order-number {
                font-size: 15px;
            }

            .btn-large {
                padding: 10px 15px;
                font-size: 14px;
            }

            .countdown-text {
                font-size: 12px;
            }

            #countdown {
                font-size: 16px;
                min-width: 20px;
            }

            .tips-section {
                padding: 15px;
            }

            .tip-item {
                padding: 12px;
                gap: 12px;
            }

            .tip-icon {
                font-size: 18px;
            }

            .tip-content h4 {
                font-size: 14px;
            }

            .tip-content p {
                font-size: 12px;
            }
        }
    </style>
</body>
</html>