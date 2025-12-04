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
                    <div class="empty-state" style="grid-column: 1 / -1;">
                        <div class="empty-state-icon">📦</div>
                        <h3 class="empty-state-title">未找到相关商品</h3>
                        <p>没有找到与 "<strong>${keyword}</strong>" 相关的商品</p>
                        <div style="margin-top: 20px;">
                            <a href="index.jsp" class="btn-view-detail">返回首页</a>
                            <button class="btn-detail" onclick="history.back()" style="margin-left: 10px;">返回上页</button>
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
                    <div class="empty-state" style="grid-column: 1 / -1;">
                        <div class="empty-state-icon">❌</div>
                        <h3 class="empty-state-title">搜索出错</h3>
                        <p>搜索 "<strong>${keyword}</strong>" 时出现问题，请稍后重试</p>
                        <div style="margin-top: 20px;">
                            <button class="btn-detail" onclick="location.reload()">重新搜索</button>
                            <a href="index.jsp" class="btn-view-detail" style="margin-left: 10px;">返回首页</a>
                        </div>
                    </div>
                `;
            }
        }
    </script>
</head>
<body>
    <header>
        <div class="header-container">
            <div class="logo">
                <a href="index.jsp">
                    <img src="images/logo.png" alt="环创店" class="logo-img">
                    <span class="logo-text">环创店</span>
                </a>
            </div>
            <nav class="main-nav">
                <ul>
                    <li><a href="index.jsp" class="nav-link active">首页</a></li>
                    <li class="dropdown">
                        <a href="#" class="nav-link dropdown-toggle" id="categoryDropdown">
                            商品分类 <span class="arrow">▼</span>
                        </a>
                    </li>
                    <li><a href="about.jsp" class="nav-link">关于我们</a></li>
                    <li><a href="contact.jsp" class="nav-link">联系我们</a></li>
                </ul>
            </nav>
            <div class="header-actions">
                <div class="search-container">
                    <form action="goods" method="get" class="search-form">
                        <input type="hidden" name="action" value="search">
                        <input type="text" name="keyword" class="search-input" placeholder="搜索商品..."
                               value="<%= request.getAttribute("keyword") != null ? request.getAttribute("keyword") : "" %>">
                        <button type="submit" class="search-btn">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="11" cy="11" r="8"></circle>
                                <path d="m21 21-4.35-4.35"></path>
                            </svg>
                        </button>
                    </form>
                </div>
                <a href="cart.jsp" class="cart-link">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M9 2L6 9H3l3 7h12l3-7h-3l-3-7z"></path>
                        <path d="M9 2L6 9h12l-3-7z"></path>
                        <circle cx="9" cy="21" r="1"></circle>
                        <circle cx="20" cy="21" r="1"></circle>
                    </svg>
                    <span id="cartCount" class="cart-count">${request.getAttribute("cartCount") != null ? request.getAttribute("cartCount") : "0"}</span>
                </a>
                <a href="login.jsp" class="login-btn">登录</a>
                <a href="register.jsp" class="register-btn">注册</a>
            </div>
        </div>
    </header>

    <main>
        <div class="container">
            <!-- 面包屑导航 -->
            <nav class="breadcrumb">
                <a href="index.jsp">首页</a>
                <span class="separator">›</span>
                <span id="search-title">搜索结果</span>
            </nav>

            <!-- 搜索结果展示区域 -->
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
        </div>
    </main>

    <footer>
        <p>&copy; 2025 环创店. 保留所有权利.</p>
    </footer>

    <!-- 引入懒加载脚本 -->
    <script src="js/lazy-load.js"></script>
</body>
</html>