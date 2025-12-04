<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.sgu.cakeshopserive.model.Goods" %>
<%@ page import="com.sgu.cakeshopserive.model.Type" %>
<!DOCTYPE html>
<html>
<head>
    <title>环创店 - 商品分类</title>
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

        // AJAX添加商品到购物车
        function addToCart(goodsId) {
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

        // 加载分类数据
        function loadCategories() {
            const xhr = new XMLHttpRequest();
            xhr.open('GET', 'type?action=ajax', true);
            xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');

            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        try {
                            const response = JSON.parse(xhr.responseText);
                            if (response.success && response.data) {
                                renderCategories(response.data);
                            }
                        } catch (e) {
                            console.error('Failed to parse categories response:', e);
                        }
                    } else {
                        console.error('Failed to load categories:', xhr.status);
                    }
                }
            };

            xhr.send();
        }

        // 渲染分类菜单
        function renderCategories(categories) {
            const categoryDropdown = document.getElementById('categoryDropdown');
            if (!categoryDropdown || !categories || categories.length === 0) {
                return;
            }

            let html = '';
            categories.forEach(category => {
                const isActive = (currentTypeId && currentTypeId === category.typeId) ? 'active' : '';

                var typeIdStr1 = "<a href=\"goods?action=type&typeId="+category.typeId+"\"" + "class\"=" + isActive +"\">"
                var typeName = category.typeName;
                html += typeIdStr1 + typeName + "</a>";

                //html += `<a href="goods?action=type&typeId=${category.typeId}" class="${isActive}">${category.typeName}</a>`;
            });

            categoryDropdown.innerHTML = html;
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
            }, type === 'info' ? 2000 : 3000);
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

        // 页面加载时初始化
        document.addEventListener('DOMContentLoaded', function() {
            updateCartCount();
            loadCategories(); // 加载分类数据
        });

        // 当前分类ID（从JSP变量传递）
        const currentTypeId = <%= request.getParameter("typeId") != null ? request.getParameter("typeId") : "null" %>;
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

        .category-dropdown a.active {
            background-color: #FFF3E0;
            color: #FF9800;
        }

        .category-dropdown a:first-child {
            border-radius: 8px 8px 0 0;
        }

        .category-dropdown a:last-child {
            border-radius: 0 0 8px 8px;
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
            margin: 30px auto;
            padding: 0 20px;
        }

        .category-header {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            text-align: center;
        }

        .category-title {
            color: #5D4037;
            font-size: 32px;
            margin-bottom: 15px;
            font-weight: bold;
        }

        .breadcrumb {
            color: #666;
            font-size: 14px;
        }

        .breadcrumb a {
            color: #FF9800;
            text-decoration: none;
        }

        .breadcrumb a:hover {
            text-decoration: underline;
        }

        /* 商品展示区域 */
        .products-section {
            margin-top: 20px;
        }

        .section-title {
            text-align: center;
            color: #5D4037;
            font-size: 28px;
            margin-bottom: 30px;
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

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }

        .empty-state-icon {
            font-size: 64px;
            color: #ccc;
            margin-bottom: 20px;
        }

        .empty-state-title {
            font-size: 24px;
            margin-bottom: 10px;
            color: #5D4037;
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
                    <li><a href="index.jsp">首页</a></li>
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
        <div class="category-header">
            <h1 class="category-title">
                <%
                    Type currentType = (Type) request.getAttribute("currentType");
                    if (currentType != null) {
                        out.print(currentType.getTypeName());
                    } else {
                        out.print("商品分类");
                    }
                %>
            </h1>
            <div class="breadcrumb">
                <a href="index.jsp">首页</a> >
                <span>
                    <%
                        if (currentType != null) {
                            out.print(currentType.getTypeName());
                        } else {
                            out.print("全部分类");
                        }
                    %>
                </span>
            </div>
        </div>

        <!-- 商品展示区域 -->
        <section class="products-section">
            <div id="goods-container" class="products-grid">
                <!-- 商品将通过懒加载动态插入这里 -->
                <div class="skeleton-container">
                    <!-- 骨架屏 -->
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

    <!-- 引入懒加载脚本 -->
    <script src="js/lazy-load.js"></script>
    <script>
        // 页面加载时初始化懒加载
        document.addEventListener('DOMContentLoaded', function() {
            initCategoryLazyLoader();
        });

        // 初始化分类页面懒加载
        function initCategoryLazyLoader() {
            const goodsContainer = document.getElementById('goods-container');
            if (goodsContainer) {
                // 获取当前分类ID
                const urlParams = new URLSearchParams(window.location.search);
                const typeId = urlParams.get('typeId');

                if (typeId) {
                    // 创建懒加载实例
                    window.lazyLoader = initGoodsLazyLoader(goodsContainer, 'type', {
                        typeId: typeId
                    });

                    // 监听懒加载事件
                    document.addEventListener('lazyload:loaded', function(e) {
                        console.log('分类懒加载完成:', e.detail);
                    });

                    document.addEventListener('lazyload:error', function(e) {
                        console.error('分类懒加载错误:', e.detail);
                    });

                    // 加载第一页商品
                    window.lazyLoader.loadMore();
                } else {
                    // 如果没有typeId参数，显示错误
                    goodsContainer.innerHTML = `
                        <div class="empty-state" style="grid-column: 1 / -1;">
                            <div class="empty-state-icon">❌</div>
                            <h3 class="empty-state-title">参数错误</h3>
                            <p>缺少分类ID参数，请重新选择分类</p>
                            <a href="index.jsp" class="btn-view-detail">返回首页</a>
                        </div>
                    `;
                }
            }
        }

        // 重写addToCart函数以支持库存检查
        function addToCart(goodsId, goodsName, price, stock) {
            if (stock <= 0) {
                showNotification('商品暂时缺货，无法加入购物车', 'error');
                return;
            }

            const xhr = new XMLHttpRequest();
            xhr.open('POST', 'cart?action=add&goodsId=' + goodsId, true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');

            showNotification('正在添加到购物车...', 'info');

            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        try {
                            const response = JSON.parse(xhr.responseText);
                            if (response.success) {
                                showNotification(response.message, 'success');
                                updateCartCount();
                            } else {
                                if (response.code === 'NOT_LOGGED_IN') {
                                    showLoginPrompt(response.message);
                                } else {
                                    showNotification(response.message, 'error');
                                }
                            }
                        } catch (e) {
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

        // 更新购物车数量
        function updateCartCount() {
            const cartCountElement = document.getElementById('cartCount');
            if (cartCountElement) {
                const xhr = new XMLHttpRequest();
                xhr.open('GET', 'cart?action=count', true);
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        try {
                            const response = JSON.parse(xhr.responseText);
                            if (response.success) {
                                const count = typeof response.data === 'number' ? response.data :
                                              (response.data && !isNaN(response.data) ? parseInt(response.data) : 0);
                                cartCountElement.textContent = count;
                                cartCountElement.style.transform = 'scale(1.3)';
                                setTimeout(() => {
                                    cartCountElement.style.transform = 'scale(1)';
                                }, 300);
                            }
                        } catch (e) {
                            console.error('Failed to parse cart count response:', e);
                            cartCountElement.textContent = '0';
                        }
                    }
                };
                xhr.send();
            }
        }

        // 显示通知消息
        function showNotification(message, type) {
            const existingNotifications = document.querySelectorAll('.notification');
            existingNotifications.forEach(notif => {
                if (notif.parentNode) {
                    notif.parentNode.removeChild(notif);
                }
            });

            const notification = document.createElement('div');
            notification.className = 'notification ' + type;
            notification.textContent = message;
            notification.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                padding: 12px 20px;
                border-radius: 4px;
                color: white;
                font-weight: bold;
                z-index: 10000;
                max-width: 300px;
                opacity: 0;
                transform: translateX(100%);
                transition: all 0.3s ease;
            `;

            if (type === 'success') {
                notification.style.background = '#28a745';
            } else if (type === 'error') {
                notification.style.background = '#dc3545';
            } else {
                notification.style.background = '#007bff';
            }

            document.body.appendChild(notification);

            setTimeout(() => {
                notification.style.opacity = '1';
                notification.style.transform = 'translateX(0)';
            }, 100);

            setTimeout(() => {
                notification.style.opacity = '0';
                notification.style.transform = 'translateX(100%)';
                setTimeout(() => {
                    if (notification.parentNode) {
                        notification.parentNode.removeChild(notification);
                    }
                }, 300);
            }, 3000);
        }

        // 显示登录提示
        function showLoginPrompt(message) {
            if (confirm(message + '\n\n是否前往登录页面？')) {
                window.location.href = 'login.jsp';
            }
        }
    </script>
</body>
</html>