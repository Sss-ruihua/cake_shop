<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.sgu.cakeshopserive.model.Goods" %>
<%@ page import="com.sgu.cakeshopserive.servlet.CartServlet" %>
<!DOCTYPE html>
<html>
<head>
    <title>环创店 - 我的购物车</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/main.css">
    <script>
        function updateQuantity(goodsId, change) {
            const input = document.getElementById('quantity-' + goodsId);
            const currentQuantity = parseInt(input.value);
            const newQuantity = currentQuantity + change;

            if (newQuantity > 0) {
                input.value = newQuantity;
                // 通过AJAX更新数量
                updateCartQuantity(goodsId, newQuantity);
            }
        }

        function setQuantity(goodsId, quantity) {
            const newQuantity = parseInt(quantity);
            if (newQuantity > 0) {
                updateCartQuantity(goodsId, newQuantity);
            } else {
                removeFromCart(goodsId);
            }
        }

        function updateCartQuantity(goodsId, quantity) {
            const xhr = new XMLHttpRequest();
            xhr.open('POST', 'cart?action=update&goodsId=' + goodsId + '&quantity=' + quantity, true);
            xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');

            showNotification('正在更新数量...', 'info');

            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    try {
                        const response = JSON.parse(xhr.responseText);
                        if (response.success) {
                            showNotification(response.message, 'success');
                            setTimeout(() => location.reload(), 500); // 延迟刷新以显示提示
                        } else {
                            // 检查是否为未登录错误
                            if (response.code === 'NOT_LOGGED_IN') {
                                showLoginPrompt(response.message);
                            } else {
                                showNotification(response.message, 'error');
                            }
                        }
                    } catch (e) {
                        showNotification('数量更新成功', 'success');
                        setTimeout(() => location.reload(), 500);
                    }
                }
            };
            xhr.send();
        }

        function removeFromCart(goodsId) {
            if (confirm('确定要从购物车中删除这个商品吗？')) {
                const xhr = new XMLHttpRequest();
                xhr.open('POST', 'cart?action=remove&goodsId=' + goodsId, true);
                xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');

                showNotification('正在删除商品...', 'info');

                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        try {
                            const response = JSON.parse(xhr.responseText);
                            if (response.success) {
                                showNotification(response.message, 'success');
                                setTimeout(() => location.reload(), 500);
                            } else {
                                // 检查是否为未登录错误
                                if (response.code === 'NOT_LOGGED_IN') {
                                    showLoginPrompt(response.message);
                                } else {
                                    showNotification(response.message, 'error');
                                }
                            }
                        } catch (e) {
                            showNotification('商品删除成功', 'success');
                            setTimeout(() => location.reload(), 500);
                        }
                    }
                };
                xhr.send();
            }
        }

        function clearCart() {
            if (confirm('确定要清空购物车吗？')) {
                const xhr = new XMLHttpRequest();
                xhr.open('POST', 'cart?action=clear', true);
                xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');

                showNotification('正在清空购物车...', 'info');

                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        try {
                            const response = JSON.parse(xhr.responseText);
                            if (response.success) {
                                showNotification(response.message, 'success');
                                setTimeout(() => location.reload(), 500);
                            } else {
                                // 检查是否为未登录错误
                                if (response.code === 'NOT_LOGGED_IN') {
                                    showLoginPrompt(response.message);
                                } else {
                                    showNotification(response.message, 'error');
                                }
                            }
                        } catch (e) {
                            showNotification('购物车已清空', 'success');
                            setTimeout(() => location.reload(), 500);
                        }
                    }
                };
                xhr.send();
            }
        }

        function checkout() {
            window.location.href = 'checkout.jsp';
        }

        // 显示登录提示弹窗
        function showLoginPrompt(message) {
            // 创建遮罩层
            const overlay = document.createElement('div');
            overlay.style.cssText = `
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.5);
                z-index: 9999;
                display: flex;
                justify-content: center;
                align-items: center;
                animation: fadeIn 0.3s ease;
            `;

            // 创建弹窗容器
            const modal = document.createElement('div');
            modal.style.cssText = `
                background: white;
                border-radius: 12px;
                padding: 30px;
                max-width: 400px;
                width: 90%;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
                text-align: center;
                animation: slideIn 0.3s ease;
                position: relative;
            `;

            modal.innerHTML = `
                <div style="font-size: 48px; color: #FF9800; margin-bottom: 20px;">🔒</div>
                <h3 style="color: #5D4037; margin-bottom: 15px; font-size: 20px;">需要登录</h3>
                <p style="color: #666; line-height: 1.5; margin-bottom: 25px;">${message}</p>
                <div style="display: flex; gap: 15px; justify-content: center;">
                    <button id="gotoLogin" style="background: #FF9800; color: white; border: none; padding: 12px 25px; border-radius: 6px; cursor: pointer; font-size: 14px; font-weight: bold; transition: background 0.3s;">
                        去登录
                    </button>
                    <button id="cancelLogin" style="background: #f5f5f5; color: #666; border: none; padding: 12px 25px; border-radius: 6px; cursor: pointer; font-size: 14px; font-weight: bold; transition: background 0.3s;">
                        取消
                    </button>
                </div>
            `;

            overlay.appendChild(modal);
            document.body.appendChild(overlay);

            // 添加CSS动画
            if (!document.getElementById('modal-styles')) {
                const style = document.createElement('style');
                style.id = 'modal-styles';
                style.textContent = `
                    @keyframes fadeIn {
                        from { opacity: 0; }
                        to { opacity: 1; }
                    }
                    @keyframes slideIn {
                        from { transform: translateY(-50px); opacity: 0; }
                        to { transform: translateY(0); opacity: 1; }
                    }
                `;
                document.head.appendChild(style);
            }

            // 绑定事件
            document.getElementById('gotoLogin').addEventListener('click', function() {
                window.location.href = 'login.jsp';
            });

            document.getElementById('cancelLogin').addEventListener('click', function() {
                closeLoginPrompt();
            });

            // 点击遮罩层关闭弹窗
            overlay.addEventListener('click', function(e) {
                if (e.target === overlay) {
                    closeLoginPrompt();
                }
            });

            // ESC键关闭弹窗
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape') {
                    closeLoginPrompt();
                }
            });

            // 保存弹窗引用以便关闭
            window.currentLoginPrompt = overlay;
        }

        // 关闭登录提示弹窗
        function closeLoginPrompt() {
            if (window.currentLoginPrompt) {
                window.currentLoginPrompt.style.animation = 'fadeOut 0.3s ease';
                setTimeout(() => {
                    if (window.currentLoginPrompt && window.currentLoginPrompt.parentNode) {
                        window.currentLoginPrompt.parentNode.removeChild(window.currentLoginPrompt);
                        window.currentLoginPrompt = null;
                    }
                }, 300);
            }

            // 添加淡出动画
            if (!document.getElementById('modal-fade-out-styles')) {
                const style = document.createElement('style');
                style.id = 'modal-fade-out-styles';
                style.textContent = `
                    @keyframes fadeOut {
                        from { opacity: 1; }
                        to { opacity: 0; }
                    }
                `;
                document.head.appendChild(style);
            }
        }

        // 显示通知消息
        function showNotification(message, type) {
            // 检查是否已有通知，如果有则移除
            const existingNotifications = document.querySelectorAll('.notification');
            existingNotifications.forEach(notif => {
                if (notif.parentNode) {
                    notif.parentNode.removeChild(notif);
                }
            });

            // 创建通知元素
            const notification = document.createElement('div');
            notification.className = 'notification notification-' + type;
            notification.textContent = message;

            // 设置样式
            notification.style.cssText = `
                position: fixed;
                top: 80px;
                right: 20px;
                padding: 14px 24px;
                border-radius: 8px;
                color: white;
                font-weight: 500;
                z-index: 10000;
                box-shadow: 0 4px 20px rgba(0,0,0,0.2);
                opacity: 0;
                transform: translateX(100%) translateY(-10px);
                transition: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
                max-width: 320px;
                font-size: 14px;
                line-height: 1.4;
                display: flex;
                align-items: center;
                gap: 10px;
            `;

            // 根据类型设置背景色和图标
            let icon = '';
            let bgColor = '';
            switch (type) {
                case 'success':
                    bgColor = '#4CAF50';
                    icon = '✓';
                    break;
                case 'error':
                    bgColor = '#F44336';
                    icon = '✗';
                    break;
                case 'info':
                    bgColor = '#FF9800';
                    icon = '⚡';
                    break;
                default:
                    bgColor = '#5D4037';
                    icon = 'ℹ';
            }

            notification.style.backgroundColor = bgColor;

            // 添加图标
            const iconElement = document.createElement('span');
            iconElement.style.cssText = `
                font-size: 18px;
                font-weight: bold;
                display: flex;
                align-items: center;
                justify-content: center;
                min-width: 20px;
            `;
            iconElement.textContent = icon;

            notification.insertBefore(iconElement, notification.firstChild);

            // 添加到页面
            document.body.appendChild(notification);

            // 显示动画
            setTimeout(() => {
                notification.style.opacity = '1';
                notification.style.transform = 'translateX(0) translateY(0)';
            }, 50);

            // 自动隐藏
            setTimeout(() => {
                notification.style.opacity = '0';
                notification.style.transform = 'translateX(100%) translateY(-10px)';
                setTimeout(() => {
                    if (notification.parentNode) {
                        notification.parentNode.removeChild(notification);
                    }
                }, 300);
            }, type === 'info' ? 2000 : 3000); // info类型显示时间更短
        }
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
                    <li><a href="#" class="active">购物车</a></li>
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
        <div class="cart-container">
            <div class="cart-header">
                <h1 class="cart-title">🛒 我的购物车</h1>
                <%
                    Integer cartCount = (Integer) session.getAttribute("cartCount");
                    if (cartCount != null && cartCount > 0) {
                %>
                <button class="btn-clear-cart" onclick="clearCart()">清空购物车</button>
                <%
                    }
                %>
            </div>

            <!-- 显示成功消息 -->
            <%
                String successMessage = (String) request.getAttribute("successMessage");
                if (successMessage != null) {
            %>
            <div class="alert alert-success">
                <%= successMessage %>
            </div>
            <%
                }
            %>

            <!-- 显示错误消息 -->
            <%
                String errorMessage = (String) request.getAttribute("error");
                if (errorMessage != null) {
            %>
            <div class="alert alert-error">
                <%= errorMessage %>
            </div>
            <%
                }
            %>

            <!-- 购物车内容 -->
            <div class="cart-content">
                <%
                    List<CartServlet.CartItem> cartItems = (List<CartServlet.CartItem>) request.getAttribute("cartItems");
                    Double totalAmount = (Double) request.getAttribute("totalAmount");
                    Integer totalQuantity = (Integer) request.getAttribute("totalQuantity");

                    if (cartItems == null || cartItems.isEmpty()) {
                %>
                <!-- 空购物车状态 -->
                <div class="empty-cart">
                    <div class="empty-cart-icon">🛒</div>
                    <h2 class="empty-cart-title">购物车是空的</h2>
                    <p class="empty-cart-message">您还没有添加任何商品到购物车</p>
                    <a href="index.jsp" class="btn btn-primary">去购物</a>
                </div>
                <%
                    } else {
                %>
                <!-- 购物车商品列表 -->
                <div class="cart-items">
                    <div class="cart-items-header">
                        <div class="col-product">商品信息</div>
                        <div class="col-price">单价</div>
                        <div class="col-quantity">数量</div>
                        <div class="col-subtotal">小计</div>
                        <div class="col-action">操作</div>
                    </div>

                    <%
                        for (CartServlet.CartItem item : cartItems) {
                            Goods goods = item.getGoods();
                            int quantity = item.getQuantity();
                            double subtotal = item.getSubtotal();
                    %>
                    <div class="cart-item">
                        <div class="col-product">
                            <div class="cart-product-info">
                                <img src="<%= goods.getCoverImage() != null && !goods.getCoverImage().isEmpty() ? goods.getCoverImage() : "images/default.jpg" %>"
                                     alt="<%= goods.getGoodsName() %>" class="cart-product-image">
                                <div class="cart-product-details">
                                    <h3 class="cart-product-name"><%= goods.getGoodsName() %></h3>
                                    <p class="cart-product-description"><%= goods.getDescription() %></p>
                                    <p class="cart-product-stock">
                                        库存: <span class="<%= goods.getStock() < 5 ? "low-stock" : "" %>"><%= goods.getStock() %></span>
                                        <% if (goods.getStock() < 5) { %>
                                            <span class="low-stock-warning">库存紧张</span>
                                        <% } %>
                                    </p>
                                </div>
                            </div>
                        </div>
                        <div class="col-price">
                            <span class="cart-price">¥<%= String.format("%.2f", goods.getPrice()) %></span>
                        </div>
                        <div class="col-quantity">
                            <div class="cart-quantity-control">
                                <button class="quantity-btn quantity-decrease"
                                        onclick="updateQuantity(<%= goods.getGoodsId() %>, -1)"
                                        <%= quantity <= 1 ? "disabled" : "" %>>-</button>
                                <input type="number"
                                       id="quantity-<%= goods.getGoodsId() %>"
                                       class="quantity-input"
                                       value="<%= quantity %>"
                                       min="1"
                                       max="<%= goods.getStock() %>"
                                       onchange="setQuantity(<%= goods.getGoodsId() %>, this.value)">
                                <button class="quantity-btn quantity-increase"
                                        onclick="updateQuantity(<%= goods.getGoodsId() %>, 1)"
                                        <%= quantity >= goods.getStock() ? "disabled" : "" %>>+</button>
                            </div>
                        </div>
                        <div class="col-subtotal">
                            <span class="cart-subtotal">¥<%= String.format("%.2f", subtotal) %></span>
                        </div>
                        <div class="col-action">
                            <button class="btn-delete" onclick="removeFromCart(<%= goods.getGoodsId() %>)">
                                🗑️ 删除
                            </button>
                        </div>
                    </div>
                    <%
                        }
                    %>
                </div>

                <!-- 购物车汇总 -->
                <div class="cart-summary">
                    <div class="cart-summary-content">
                        <div class="cart-stats">
                            <div class="stat-item">
                                <span class="stat-label">商品总数：</span>
                                <span class="stat-value"><%= totalQuantity %>件</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-label">订单总金额：</span>
                                <span class="stat-value total-amount">¥<%= String.format("%.2f", totalAmount) %></span>
                            </div>
                        </div>
                        <div class="cart-actions">
                            <a href="index.jsp" class="btn btn-outline">继续购物</a>
                            <button class="btn btn-primary btn-checkout" onclick="checkout()">
                                去结算
                            </button>
                        </div>
                    </div>
                </div>
                <%
                    }
                %>
            </div>
        </div>
    </main>

    <!-- 页脚 -->
    <footer>
        <p>&copy; 2025 环创店. 保留所有权利.</p>
    </footer>

    <style>
        /* 购物车页面专用样式 */
        .cart-container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            margin: 20px 0;
            overflow: hidden;
        }

        .cart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 30px;
            border-bottom: 1px solid #E0E0E0;
            background-color: #f9f9f9;
        }

        .cart-title {
            color: #5D4037;
            font-size: 28px;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .btn-clear-cart {
            background-color: #F44336;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 14px;
            font-weight: 500;
        }

        .btn-clear-cart:hover {
            background-color: #D32F2F;
            transform: translateY(-2px);
        }

        /* 空购物车状态 */
        .empty-cart {
            text-align: center;
            padding: 80px 20px;
            color: #666;
        }

        .empty-cart-icon {
            font-size: 80px;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        .empty-cart-title {
            font-size: 24px;
            margin-bottom: 15px;
            color: #5D4037;
        }

        .empty-cart-message {
            font-size: 16px;
            margin-bottom: 30px;
        }

        /* 购物车商品列表 */
        .cart-items {
            margin-bottom: 20px;
        }

        .cart-items-header {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 1fr 0.8fr;
            gap: 15px;
            padding: 15px 30px;
            background-color: #f5f5f5;
            border-bottom: 2px solid #E0E0E0;
            font-weight: bold;
            color: #5D4037;
        }

        .cart-item {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 1fr 0.8fr;
            gap: 15px;
            padding: 20px 30px;
            border-bottom: 1px solid #E0E0E0;
            align-items: center;
            transition: background-color 0.3s ease;
        }

        .cart-item:hover {
            background-color: #f9f9f9;
        }

        /* 商品信息 */
        .cart-product-info {
            display: flex;
            gap: 15px;
            align-items: center;
        }

        .cart-product-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid #E0E0E0;
        }

        .cart-product-details {
            flex: 1;
        }

        .cart-product-name {
            font-size: 16px;
            font-weight: bold;
            color: #5D4037;
            margin: 0 0 8px 0;
            line-height: 1.3;
        }

        .cart-product-description {
            font-size: 14px;
            color: #666;
            margin: 0 0 8px 0;
            line-height: 1.4;
            max-height: 2.8em;
            overflow: hidden;
        }

        .cart-product-stock {
            font-size: 12px;
            color: #999;
            margin: 0;
        }

        .low-stock {
            color: #FF9800;
            font-weight: bold;
        }

        .low-stock-warning {
            color: #F44336;
            font-size: 12px;
            font-weight: bold;
        }

        /* 价格和小计 */
        .cart-price {
            font-size: 16px;
            font-weight: bold;
            color: #FF5722;
        }

        .cart-subtotal {
            font-size: 18px;
            font-weight: bold;
            color: #FF5722;
        }

        /* 数量控制 */
        .cart-quantity-control {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .quantity-btn {
            width: 32px;
            height: 32px;
            border: 1px solid #E0E0E0;
            background-color: white;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .quantity-btn:hover:not(:disabled) {
            background-color: #FF9800;
            color: white;
            border-color: #FF9800;
        }

        .quantity-btn:disabled {
            background-color: #f5f5f5;
            color: #ccc;
            cursor: not-allowed;
        }

        .quantity-decrease {
            color: #F44336;
        }

        .quantity-increase {
            color: #4CAF50;
        }

        .quantity-input {
            width: 60px;
            height: 32px;
            text-align: center;
            border: 1px solid #E0E0E0;
            border-radius: 4px;
            font-size: 14px;
            padding: 0 5px;
        }

        /* 删除按钮 */
        .btn-delete {
            background-color: #F44336;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            transition: all 0.3s ease;
            white-space: nowrap;
        }

        .btn-delete:hover {
            background-color: #D32F2F;
            transform: translateY(-2px);
        }

        /* 购物车汇总 */
        .cart-summary {
            background-color: #f9f9f9;
            border-top: 2px solid #E0E0E0;
            padding: 20px 30px;
        }

        .cart-summary-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
        }

        .cart-stats {
            display: flex;
            gap: 30px;
        }

        .stat-item {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .stat-label {
            font-size: 14px;
            color: #666;
        }

        .stat-value {
            font-size: 18px;
            font-weight: bold;
            color: #333;
        }

        .total-amount {
            color: #FF5722;
            font-size: 24px;
        }

        .cart-actions {
            display: flex;
            gap: 15px;
        }

        .btn-checkout {
            font-size: 18px;
            padding: 12px 30px;
            background-color: #4CAF50;
        }

        .btn-checkout:hover {
            background-color: #45a049;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(76,175,80,0.3);
        }

        /* 响应式设计 */
        @media (max-width: 992px) {
            .cart-items-header,
            .cart-item {
                grid-template-columns: 2fr 1fr 1fr 1fr;
                gap: 10px;
                padding: 15px;
            }

            .col-action {
                grid-column: 4;
            }
        }

        @media (max-width: 768px) {
            .cart-header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }

            .cart-items-header {
                display: none;
            }

            .cart-item {
                grid-template-columns: 1fr;
                gap: 15px;
                padding: 20px 15px;
                border: 1px solid #E0E0E0;
                border-radius: 8px;
                margin-bottom: 15px;
                background-color: white;
            }

            .cart-product-info {
                flex-direction: column;
                text-align: center;
            }

            .cart-product-image {
                width: 120px;
                height: 120px;
            }

            .col-price,
            .col-quantity,
            .col-subtotal,
            .col-action {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 10px 0;
                border-top: 1px solid #f0f0f0;
            }

            .col-price::before,
            .col-quantity::before,
            .col-subtotal::before,
            .col-action::before {
                content: attr(data-label);
                font-weight: bold;
                color: #5D4037;
            }

            .cart-summary-content {
                flex-direction: column;
                gap: 20px;
            }

            .cart-stats {
                flex-direction: column;
                gap: 15px;
            }

            .cart-actions {
                flex-direction: column;
            }

            .btn-checkout {
                order: 2;
            }
        }
    </style>
</body>
</html>