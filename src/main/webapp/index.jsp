<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.sgu.cakeshopserive.model.Goods" %>
<!DOCTYPE html>
<html>
<head>
    <title>环创店 - 首页</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/main.css">
    <link rel="stylesheet" href="css/lazy-load.css">
    <script>
        function goToDetail(event, goodsId) {
            if (goodsId && goodsId !== 'null') {
                window.location.href = 'goods?action=detail&goodsId=' + goodsId;
            }
        }

        function showDemoMessage(goodsName) {
            alert('您点击的是示例商品：' + goodsName + '\n\n实际使用时，这里会跳转到真实的商品详情页面。');
        }

        // 加载分类数据
        function loadCategories() {
            const xhr = new XMLHttpRequest();
            xhr.open('GET', 'type?action=ajax', true);
            xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');

            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    const categoryDropdown = document.getElementById('categoryDropdown');

                    if (xhr.status === 200) {
                        try {
                            const response = JSON.parse(xhr.responseText);
                            console.log('Categories response:', response); // 调试信息

                            if (response.success && response.data) {
                                renderCategories(response.data);
                            } else {
                                console.error('Categories API returned error:', response.message);
                                if (categoryDropdown) {
                                    categoryDropdown.innerHTML = '<a href="#">加载失败</a>';
                                }
                            }
                        } catch (e) {
                            console.error('Failed to parse categories response:', e);
                            console.error('Raw response:', xhr.responseText);
                            if (categoryDropdown) {
                                categoryDropdown.innerHTML = '<a href="#">解析失败</a>';
                            }
                        }
                    } else {
                        console.error('Failed to load categories. Status:', xhr.status);
                        console.error('Response:', xhr.responseText);
                        if (categoryDropdown) {
                            categoryDropdown.innerHTML = '<a href="#">请求失败</a>';
                        }
                    }
                }
            };

            xhr.send();
        }

        // 渲染分类菜单
        function renderCategories(categories) {
            const categoryDropdown = document.getElementById('categoryDropdown');
            if (!categoryDropdown) {
                console.error('Category dropdown element not found');
                return;
            }

            if (!categories || categories.length === 0) {
                categoryDropdown.innerHTML = '<a href="#">暂无分类</a>';
                console.warn('No categories data available');
                return;
            }

            let html = '';
            categories.forEach(category => {
                console.log('Processing category:', category); // 调试信息
                if (category.typeId && category.typeName) {
                    var typeIdStr1 = "<a href=\"goods?action=type&typeId="+category.typeId+"\">"
                    var typeName = category.typeName;
                    html += typeIdStr1 + typeName + "</a>";
                } else {
                    console.warn('Invalid category data:', category);
                }
            });

            if (html === '') {
                html = '<a href="#">无有效分类</a>';
            }

            categoryDropdown.innerHTML = html;
            console.log('Categories rendered successfully');
        }

        // 页面加载时初始化
        document.addEventListener('DOMContentLoaded', function() {
            updateCartCount();
            loadCategories(); // 加载分类数据
            initLazyLoader(); // 初始化懒加载
        });

        // 初始化懒加载
        function initLazyLoader() {
            const goodsContainer = document.getElementById('goods-container');
            if (goodsContainer) {
                // 创建懒加载实例
                window.lazyLoader = initGoodsLazyLoader(goodsContainer, 'list', {});

                // 监听懒加载事件
                document.addEventListener('lazyload:loaded', function(e) {
                    console.log('懒加载完成:', e.detail);
                });

                document.addEventListener('lazyload:error', function(e) {
                    console.error('懒加载错误:', e.detail);
                });

                // 加载第一页商品
                window.lazyLoader.loadMore();
            }
        }

        // AJAX添加商品到购物车
        function addToCart(goodsId, goodsName, price, stock) {
            // 检查库存
            if (stock <= 0) {
                showNotification('商品暂时缺货，无法加入购物车', 'error');
                return;
            }

            const xhr = new XMLHttpRequest();
            xhr.open('POST', 'cart?action=add&goodsId=' + goodsId, true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');

            // 显示加载状态
            showNotification('正在添加到购物车...', 'info');

            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
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
                                // 检查是否为未登录错误
                                if (response.code === 'NOT_LOGGED_IN') {
                                    showLoginPrompt(response.message);
                                } else {
                                    showNotification(response.message, 'error');
                                }
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

        .nav-menu li {
            position: relative;
        }

        .nav-menu a {
            color: white;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 4px;
            transition: background-color 0.3s;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .nav-menu a:hover {
            background-color: #6D4C41;
        }

        .nav-menu a.active {
            background-color: #FF9800;
            color: white;
        }

        /* 分类下拉菜单 */
        .category-dropdown {
            position: absolute;
            top: 100%;
            left: 0;
            background-color: white;
            min-width: 180px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            border-radius: 8px;
            z-index: 1000;
            opacity: 0;
            visibility: hidden;
            transform: translateY(-10px);
            transition: all 0.3s ease;
        }

        .nav-menu li:hover .category-dropdown {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }

        .category-dropdown a {
            color: #333;
            padding: 12px 20px;
            display: block;
            border-radius: 0;
            transition: all 0.2s ease;
            font-size: 14px;
        }

        .category-dropdown a:hover {
            background-color: #f5f5f5;
            color: #FF9800;
            transform: translateX(5px);
        }

        .category-dropdown a:first-child {
            border-radius: 8px 8px 0 0;
        }

        .category-dropdown a:last-child {
            border-radius: 0 0 8px 8px;
        }

        /* 加载动画 */
        .loading-spinner {
            display: inline-block;
            width: 14px;
            height: 14px;
            border: 2px solid #ffffff;
            border-radius: 50%;
            border-top-color: transparent;
            animation: spin 1s ease-in-out infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
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
                    <li>
                        <a href="#">商品分类 <span class="category-arrow">▼</span></a>
                        <div class="category-dropdown" id="categoryDropdown">
                            <a href="#">加载中...</a>
                        </div>
                    </li>
                    <li><a href="goods?action=search&keyword=热销">热销</a></li>
                    <li><a href="goods?action=search&keyword=新品">新品</a></li>
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
                <div class="search-wrapper">
                    <a href="#" class="search-icon">🔍</a>
                    <div class="search-dropdown">
                        <div class="search-input-container">
                            <form action="goods" method="get" class="search-form" onsubmit="return performSearch(this);">
                                <input type="hidden" name="action" value="search">
                                <input type="text"
                                       name="keyword"
                                       class="search-input"
                                       placeholder="搜索商品..."
                                       id="searchInput"
                                       autocomplete="off">
                                <button type="submit" class="search-btn">🔍</button>
                            </form>
                        </div>
                        <div class="search-content">
                            <div class="search-suggestions" id="searchSuggestions" style="display: none;">
                                <!-- 搜索建议将动态插入这里 -->
                            </div>
                            <div class="search-history" id="searchHistory">
                                <div class="search-history-title">
                                    <span>搜索历史</span>
                                    <span class="clear-history" onclick="clearSearchHistory()">清除</span>
                                </div>
                                <div class="search-history-items" id="historyItems">
                                    <!-- 搜索历史项将动态插入这里 -->
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <a href="cart" class="cart-icon">
                    🛒
                    <span class="cart-count" id="cartCount">${cartCount != null ? cartCount : 0}</span>
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
            <div id="goods-container" class="products-grid">
                <!-- 商品将通过懒加载动态插入这里 -->
                <div class="skeleton-container">
                    <!-- 骨架屏，提升用户体验 -->
                    <div class="skeleton-item">
                        <div class="skeleton skeleton-image"></div>
                        <div class="skeleton-content">
                            <div class="skeleton skeleton-title"></div>
                            <div class="skeleton skeleton-text"></div>
                            <div class="skeleton skeleton-text"></div>
                        </div>
                    </div>
                    <div class="skeleton-item">
                        <div class="skeleton skeleton-image"></div>
                        <div class="skeleton-content">
                            <div class="skeleton skeleton-title"></div>
                            <div class="skeleton skeleton-text"></div>
                            <div class="skeleton skeleton-text"></div>
                        </div>
                    </div>
                    <div class="skeleton-item">
                        <div class="skeleton skeleton-image"></div>
                        <div class="skeleton-content">
                            <div class="skeleton skeleton-title"></div>
                            <div class="skeleton skeleton-text"></div>
                            <div class="skeleton skeleton-text"></div>
                        </div>
                    </div>
                    <div class="skeleton-item">
                        <div class="skeleton skeleton-image"></div>
                        <div class="skeleton-content">
                            <div class="skeleton skeleton-title"></div>
                            <div class="skeleton skeleton-text"></div>
                            <div class="skeleton skeleton-text"></div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <footer>
        <p>&copy; 2025 环创店. 保留所有权利.</p>
    </footer>

    <!-- 引入搜索脚本 -->
    <script src="js/search-new.js"></script>
    <!-- 引入懒加载脚本 -->
    <script src="js/lazy-load.js"></script>
</body>
</html>