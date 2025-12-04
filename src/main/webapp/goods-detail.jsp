<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sgu.cakeshopserive.model.Goods" %>
<!DOCTYPE html>
<html>
<head>
    <title>商品详情 - 环创店</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/main.css">
    <style>
        .goods-detail-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .goods-detail-content {
            display: flex;
            gap: 40px;
            margin-bottom: 40px;
        }

        .goods-image-section {
            flex: 1;
            max-width: 500px;
        }

        .goods-image {
            width: 100%;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .goods-info-section {
            flex: 1;
            padding: 20px;
        }

        .goods-name {
            font-size: 28px;
            color: #5D4037;
            margin-bottom: 15px;
            font-weight: bold;
        }

        .goods-price {
            font-size: 32px;
            color: #FF5722;
            margin-bottom: 20px;
            font-weight: bold;
        }

        .goods-description {
            color: #666;
            line-height: 1.8;
            margin-bottom: 30px;
            font-size: 16px;
        }

        .goods-meta {
            display: grid;
            grid-template-columns: auto 1fr;
            gap: 15px;
            margin-bottom: 30px;
        }

        .meta-label {
            color: #FF9800;
            font-weight: bold;
        }

        .meta-value {
            color: #333;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .btn-primary {
            background-color: #FF9800;
            color: white;
            padding: 15px 30px;
            border: none;
            border-radius: 6px;
            font-size: 18px;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary:hover {
            background-color: #F57C00;
            transform: translateY(-2px);
        }

        .btn-secondary {
            background-color: #5D4037;
            color: white;
            padding: 15px 30px;
            border: none;
            border-radius: 6px;
            font-size: 18px;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-secondary:hover {
            background-color: #4E342E;
            transform: translateY(-2px);
        }

        .stock-info {
            background-color: #E8F5E8;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            border-left: 4px solid #4CAF50;
        }

        .stock-info.low-stock {
            background-color: #FFF3E0;
            border-left-color: #FF9800;
        }

        .stock-info.out-of-stock {
            background-color: #FFEBEE;
            border-left-color: #F44336;
        }

        @media (max-width: 768px) {
            .goods-detail-content {
                flex-direction: column;
                gap: 20px;
            }

            .goods-image-section {
                max-width: 100%;
            }

            .goods-info-section {
                padding: 10px;
            }

            .goods-name {
                font-size: 24px;
            }

            .goods-price {
                font-size: 28px;
            }

            .action-buttons {
                flex-direction: column;
            }
        }
          /* 购物车角标样式 */
        .cart-icon {
            position: relative;
        }

        .cart-count {
            position: absolute;
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
            line-height: 1;
        }
    </style>
    <script>
        // AJAX添加商品到购物车
        function addToCart(goodsId) {
            const xhr = new XMLHttpRequest();
            xhr.open('POST', 'cart?action=add&goodsId=' + goodsId, true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');

            // 禁用按钮，显示加载状态
            const button = document.querySelector('.btn-primary');
            const originalText = button.textContent;
            button.disabled = true;
            button.textContent = '添加中...';

            // 显示通知
            showNotification('正在添加到购物车...', 'info');

            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    // 恢复按钮状态
                    button.disabled = false;
                    button.textContent = originalText;

                    if (xhr.status === 200) {
                        try {
                            const response = JSON.parse(xhr.responseText);
                            if (response.success) {
                                showNotification(response.message, 'success');

                                // 如果响应中包含购物车数量，直接更新，否则调用updateCartCount
                                if (response.data && typeof response.data.cartCount === 'number') {
                                    const cartCountElement = document.getElementById('cartCount');
                                    if (cartCountElement) {
                                        cartCountElement.textContent = response.data.cartCount;
                                        // 添加动画效果
                                        cartCountElement.style.transform = 'scale(1.3)';
                                        setTimeout(() => {
                                            cartCountElement.style.transform = 'scale(1)';
                                        }, 300);
                                    }
                                } else {
                                    updateCartCount(); // 更新购物车数量
                                }
                            } else {
                                showNotification(response.message, 'error');
                            }
                        } catch (e) {
                            // 如果不是JSON响应，可能是页面跳转
                            console.log('Response:', xhr.responseText);
                            showNotification('商品已添加到购物车', 'success');
                            updateCartCount();
                        }
                    } else {
                        showNotification('添加失败，请重试', 'error');
                    }
                }
            };

            xhr.send();
        }

        // 更新购物车数量显示
        function updateCartCount() {
            const xhr = new XMLHttpRequest();
            xhr.open('GET', 'cart?action=count', true);
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    try {
                        const response = JSON.parse(xhr.responseText);
                        if (response.success) {
                            const cartCountElement = document.getElementById('cartCount');
                            if (cartCountElement) {
                                // 确保response.data是数字
                                const count = typeof response.data === 'number' ? response.data :
                                              (response.data && !isNaN(response.data) ? parseInt(response.data) : 0);
                                cartCountElement.textContent = count;
                                // 添加动画效果
                                cartCountElement.style.transform = 'scale(1.3)';
                                setTimeout(() => {
                                    cartCountElement.style.transform = 'scale(1)';
                                }, 300);
                            }
                        }
                    } catch (e) {
                        console.error('Failed to parse cart count response:', e);
                        // 设置默认值
                        const cartCountElement = document.getElementById('cartCount');
                        if (cartCountElement) {
                            cartCountElement.textContent = '0';
                        }
                    }
                }
            };
            xhr.send();
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

        // 页面加载时更新购物车数量
        document.addEventListener('DOMContentLoaded', function() {
            updateCartCount();
        });
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
                    <li><a href="#" class="active">商品详情</a></li>
                </ul>
            </nav>
            <div class="nav-actions">
                <a href="#" class="search-icon">🔍</a>
                <a href="cart" class="cart-icon">
                    🛒
                    <span class="cart-count" id="cartCount">${cartCount != null ? cartCount : 0}</span>
                </a>
            </div>
        </div>
    </header>

    <!-- 主内容区 -->
    <main class="main-container">
        <div class="goods-detail-container">
            <%
                Goods goods = (Goods) request.getAttribute("goods");
                if (goods == null) {
            %>
                <div class="error-message">
                    商品不存在或已被删除
                </div>
            <% } else { %>
                <div class="goods-detail-content">
                    <!-- 商品图片区域 -->
                    <div class="goods-image-section">
                        <% if (goods.getCoverImage() != null && !goods.getCoverImage().isEmpty()) { %>
                            <img src="<%= goods.getCoverImage() %>" alt="<%= goods.getGoodsName() %>" class="goods-image">
                        <% } else { %>
                            <img src="images/default-goods.jpg" alt="默认商品图片" class="goods-image">
                        <% } %>
                    </div>

                    <!-- 商品信息区域 -->
                    <div class="goods-info-section">
                        <h1 class="goods-name"><%= goods.getGoodsName() %></h1>

                        <div class="goods-price">¥<%= String.format("%.2f", goods.getPrice()) %></div>

                        <!-- 库存信息 -->
                        <%
                            int stock = goods.getStock();
                            String stockClass = "stock-info";
                            String stockText = "库存充足";

                            if (stock <= 0) {
                                stockClass = "stock-info out-of-stock";
                                stockText = "暂时缺货";
                            } else if (stock < 10) {
                                stockClass = "stock-info low-stock";
                                stockText = "库存紧张，仅剩" + stock + "件";
                            } else {
                                stockText = "库存充足，剩余" + stock + "件";
                            }
                        %>
                        <div class="<%= stockClass %>">
                            <%= stockText %>
                        </div>

                        <!-- 商品描述 -->
                        <% if (goods.getDescription() != null && !goods.getDescription().isEmpty()) { %>
                            <div class="goods-description">
                                <%= goods.getDescription() %>
                            </div>
                        <% } %>

                        <!-- 商品详细信息 -->
                        <div class="goods-meta">
                            <div class="meta-label">商品编号：</div>
                            <div class="meta-value">#<%= goods.getGoodsId() %></div>

                            <% if (goods.getTypeName() != null && !goods.getTypeName().isEmpty()) { %>
                                <div class="meta-label">商品分类：</div>
                                <div class="meta-value"><%= goods.getTypeName() %></div>
                            <% } %>

                            <div class="meta-label">上架时间：</div>
                            <div class="meta-value">
                                <%= goods.getCreateTime() != null ? goods.getCreateTime().toString() : "未知" %>
                            </div>
                        </div>

                        <!-- 操作按钮 -->
                        <div class="action-buttons">
                            <% if (stock > 0) { %>
                                <button type="button" class="btn-primary" onclick="addToCart(<%= goods.getGoodsId() %>)">加入购物车</button>
                            <% } else { %>
                                <button class="btn-primary" disabled>暂时缺货</button>
                            <% } %>

                            <a href="index.jsp" class="btn-secondary">返回首页</a>
                        </div>
                    </div>
                </div>

                <!-- 商品详细图片（如果有的话） -->
                <% if (goods.getDetailImage() != null && !goods.getDetailImage().isEmpty()) { %>
                    <div style="margin-top: 40px; padding-top: 30px; border-top: 1px solid #E0E0E0;">
                        <h2 style="color: #5D4037; margin-bottom: 20px;">商品详细图片</h2>
                        <img src="<%= goods.getDetailImage() %>" alt="<%= goods.getGoodsName() %>详细图"
                             style="width: 100%; max-width: 800px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
                    </div>
                <% } %>
            <% } %>
        </div>
    </main>

    <!-- 页脚 -->
    <footer>
        <p>&copy; 2025 环创店. 保留所有权利.</p>
    </footer>
</body>
</html>