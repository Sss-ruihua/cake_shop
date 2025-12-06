<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.sgu.cakeshopserive.model.Type" %>
<!DOCTYPE html>
<html>
<head>
    <title>环创店 - 搜索结果</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/main.css">
    <link rel="stylesheet" href="css/lazy-load.css">
    <style>
        /* 页面级别样式 */
        body.search-page {
            background-color: #f8f9fa;
        }

        /* 确保容器样式正确应用 */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        /* 确保搜索结果容器正确显示 */
        .search-results {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        /* 确保商品卡片样式正确应用 */
        .product-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        /* 防止lazy-load样式冲突 */
        .goods-item {
            opacity: 1 !important;
            animation: none !important;
            transform: none !important;
        }

        .goods-item.product-card {
            opacity: 1 !important;
        }

        /* 确保图片容器正确 */
        .product-image-container {
            position: relative;
            width: 100%;
            height: 200px;
            overflow: hidden;
            background: #f8f9fa;
        }

        .product-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .product-card:hover .product-image {
            transform: scale(1.05);
        }

        /* 确保商品信息区域正确 */
        .product-info {
            padding: 20px;
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .product-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin: 0 0 10px 0;
            line-height: 1.4;
            cursor: pointer;
            transition: color 0.2s;
        }

        .product-title:hover {
            color: #FF9800;
        }

        .product-description {
            color: #666;
            font-size: 14px;
            line-height: 1.5;
            margin: 0 0 15px 0;
            flex: 1;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .product-price-section {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 15px;
        }

        .product-price {
            font-size: 24px;
            font-weight: 700;
            color: #f44336;
        }

        .product-actions {
            display: flex;
            gap: 10px;
        }

        .btn-add-cart, .btn-view-detail {
            flex: 1;
            padding: 10px 16px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
            text-align: center;
            text-decoration: none;
            outline: none;
        }

        .btn-add-cart {
            background: #FF9800;
            color: white;
        }

        .btn-add-cart:hover:not(:disabled) {
            background: #F57C00;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(255, 152, 0, 0.3);
        }

        .btn-add-cart:disabled {
            background: #ccc;
            cursor: not-allowed;
            color: #999;
        }

        .btn-view-detail {
            background: #5D4037;
            color: white;
        }

        .btn-view-detail:hover {
            background: #4E342E;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(93, 64, 55, 0.3);
        }

        /* 缺货状态 */
        .out-of-stock-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.7);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 18px;
            font-weight: 500;
        }

        /* 类别标签 */
        .product-category {
            position: absolute;
            top: 12px;
            left: 12px;
            background: rgba(255, 152, 0, 0.9);
            color: white;
            padding: 6px 12px;
            border-radius: 16px;
            font-size: 12px;
            font-weight: 500;
            backdrop-filter: blur(4px);
        }
    </style>
    <script>
        function goToDetail(event, goodsId) {
            if (goodsId && goodsId !== 'null') {
                window.location.href = 'goods?action=detail&goodsId=' + goodsId;
            }
        }

        // AJAX添加商品到购物车
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

        // 页面加载时初始化懒加载
        document.addEventListener('DOMContentLoaded', function() {
            initSearchLazyLoader();
            updateCartCount();
        });

        // 初始化搜索页面懒加载
        function initSearchLazyLoader() {
            const goodsContainer = document.getElementById('goods-container');
            if (goodsContainer) {
                // 获取搜索关键词
                const urlParams = new URLSearchParams(window.location.search);
                const keyword = urlParams.get('keyword');

                if (keyword) {
                    // 更新搜索结果标题
                    const searchTitle = document.getElementById('search-title');
                    if (searchTitle) {
                        searchTitle.textContent = `搜索结果："${keyword}"`;
                    }

                    // 创建懒加载实例
                    window.lazyLoader = initGoodsLazyLoader(goodsContainer, 'search', {
                        keyword: keyword
                    });

                    // 监听懒加载事件
                    document.addEventListener('lazyload:loaded', function(e) {
                        console.log('搜索懒加载完成:', e.detail);
                        // 如果没有加载到任何商品，显示空状态
                        if (e.detail.page === 1 && e.detail.goods.length === 0) {
                            showEmptySearchState(keyword);
                        }
                    });

                    document.addEventListener('lazyload:error', function(e) {
                        console.error('搜索懒加载错误:', e.detail);
                        if (e.detail.page === 1) {
                            showSearchErrorState(keyword);
                        }
                    });

                    // 加载第一页商品
                    window.lazyLoader.loadMore();
                } else {
                    // 如果没有关键词参数，显示错误
                    goodsContainer.innerHTML = `
                        <div class="empty-state" style="grid-column: 1 / -1;">
                            <div class="empty-state-icon">🔍</div>
                            <h3 class="empty-state-title">请输入搜索关键词</h3>
                            <p>请使用搜索框输入您要查找的商品</p>
                            <a href="index.jsp" class="btn-view-detail">返回首页</a>
                        </div>
                    `;
                }
            }
        }

        // 显示空搜索状态
        function showEmptySearchState(keyword) {
            const goodsContainer = document.getElementById('goods-container');
            if (goodsContainer) {
                goodsContainer.innerHTML = `
                    <div class="empty-state">
                        <div class="empty-state-icon">📦</div>
                        <h3 class="empty-state-title">未找到相关商品</h3>
                        <p class="empty-state-description">没有找到与 "<strong>${keyword}</strong>" 相关的商品</p>
                        <div class="empty-state-actions">
                            <a href="index.jsp" class="btn-view-detail">返回首页</a>
                            <button class="btn-view-detail" onclick="history.back()">返回上页</button>
                        </div>
                    </div>
                `;
            }
        }

        // 显示搜索错误状态
        function showSearchErrorState(keyword) {
            const goodsContainer = document.getElementById('goods-container');
            if (goodsContainer) {
                goodsContainer.innerHTML = `
                    <div class="empty-state">
                        <div class="empty-state-icon">❌</div>
                        <h3 class="empty-state-title">搜索出错</h3>
                        <p class="empty-state-description">搜索 "<strong>${keyword}</strong>" 时出现问题，请稍后重试</p>
                        <div class="empty-state-actions">
                            <button class="btn-view-detail" onclick="location.reload()">重新搜索</button>
                            <a href="index.jsp" class="btn-view-detail">返回首页</a>
                        </div>
                    </div>
                `;
            }
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
        // 延迟执行，避免与search-new.js冲突
        setTimeout(() => {
            initSearchLazyLoader();
            updateCartCount();
            loadCategories(); // 加载分类数据
        }, 100);
    });

    </script>

    <!-- 引入搜索脚本 -->
    <script src="js/search-new.js"></script>
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
                                       autocomplete="off"
                                       value="<%= request.getAttribute("keyword") != null ? request.getAttribute("keyword") : "" %>">
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
                    <span class="cart-count" id="cartCount">${request.getAttribute("cartCount") != null ? request.getAttribute("cartCount") : 0}</span>
                </a>
            </div>
        </div>
    </header>

    <main class="search-page">
        <div class="container">
            <!-- 面包屑导航 -->
            <nav class="breadcrumb">
                <a href="index.jsp">首页</a>
                <span class="separator">›</span>
                <span class="current" id="search-title">搜索结果</span>
            </nav>

            <!-- 搜索结果展示区域 -->
            <section class="search-results-section">
                <div id="goods-container" class="search-results">
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
        </div>
    </main>

    <footer>
        <p>&copy; 2025 环创店. 保留所有权利.</p>
    </footer>

    <!-- 引入搜索脚本 -->
    <script src="js/search-enhance.js"></script>
    <!-- 引入懒加载脚本 -->
    <script src="js/lazy-load.js"></script>
</body>
</html>