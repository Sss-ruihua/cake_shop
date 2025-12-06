<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, com.sgu.cakeshopserive.model.Type" %>
<!DOCTYPE html>
<html>
<head>
    <title>${pageTitle} - 环创店</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/main.css">
    <link rel="stylesheet" href="css/lazy-load.css">
    <script src="js/lazy-load.js"></script>
    <script src="js/search-enhance.js"></script>
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
                            console.log('Categories response:', response);

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
                        console.error('HTTP error:', xhr.status);
                        if (categoryDropdown) {
                            categoryDropdown.innerHTML = '<a href="#">加载失败</a>';
                        }
                    }
                }
            };

            xhr.send();
        }

        function renderCategories(categories) {
            const categoryDropdown = document.getElementById('categoryDropdown');
            if (!categoryDropdown) return;

            let html = '';
            categories.forEach(function(category) {
                html += '<a href="goods?action=type&typeId=' + category.typeId + '">' + category.typeName + '</a>';
            });

            categoryDropdown.innerHTML = html;
        }

        document.addEventListener('DOMContentLoaded', function() {
            updateCartCount();
            loadCategories();
            initLazyLoader();
            // 初始化搜索增强功能
            if (typeof SearchEnhancer !== 'undefined') {
                window.searchEnhancer = new SearchEnhancer();
            }
        });

        // 搜索相关函数
        function performSearch(form) {
            const keyword = form.keyword.value.trim();
            if (keyword) {
                // 保存到搜索历史
                saveSearchHistory(keyword);
                // 提交表单
                return true;
            }
            return false;
        }

        function saveSearchHistory(keyword) {
            let history = JSON.parse(localStorage.getItem('searchHistory') || '[]');
            // 移除重复项
            history = history.filter(item => item !== keyword);
            // 添加到开头
            history.unshift(keyword);
            // 最多保存10条
            history = history.slice(0, 10);
            localStorage.setItem('searchHistory', JSON.stringify(history));
        }

        function clearSearchHistory() {
            localStorage.removeItem('searchHistory');
            const historyItems = document.getElementById('historyItems');
            if (historyItems) {
                historyItems.innerHTML = '';
            }
        }

        // 初始化懒加载
        function initLazyLoader() {
            const goodsContainer = document.getElementById('goods-container');

            if (goodsContainer) {
                // 获取页面配置
                const config = getLazyLoadConfig();

                // 创建懒加载实例并使用页面配置
                window.lazyLoader = new GoodsLazyLoader({
                    pageSize: 12,
                    loadingText: '正在加载热销商品...',
                    noMoreText: '没有更多热销商品了',
                    errorText: '加载失败，点击重试',
                    retryText: '点击重试'
                });

                // 使用页面配置的模板
                window.lazyLoader.goodsCardTemplate = config.goodsCardTemplate;

                // 设置懒加载容器和类型
                window.lazyLoader.setup(goodsContainer, 'hot', {});

                // 设置初始内容
                goodsContainer.innerHTML = config.loadingHtml;

                // 监听懒加载事件
                document.addEventListener('lazyload:loaded', function(e) {
                    // 第一次加载完成后，确保清除初始loading状态
                    if (e.detail.page === 1) {
                        // 如果有商品数据，清除容器的初始loading内容
                        if (e.detail.goods && e.detail.goods.length > 0) {
                            // 移除初始的loading状态显示
                            const initialLoading = goodsContainer.querySelector('.loading-state');
                            if (initialLoading) {
                                initialLoading.remove();
                            }
                        }
                    }
                });

                document.addEventListener('lazyload:error', function(e) {
                    console.error('热销商品加载错误:', e.detail);
                    // 显示错误状态
                    goodsContainer.innerHTML = config.errorHtml;
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
                                    updateCartCount();
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
                                const count = parseInt(response.data) || 0;
                                cartCountElement.textContent = count;

                                // 添加更新动画
                                cartCountElement.style.transform = 'scale(1.3)';
                                setTimeout(() => {
                                    cartCountElement.style.transform = 'scale(1)';
                                }, 300);
                            }
                        }
                    } catch (e) {
                        console.error('Failed to parse cart count response:', e);
                    }
                }
            };
            xhr.send();
        }

        // 显示通知消息
        function showNotification(message, type) {
            // 创建通知元素
            const notification = document.createElement('div');
            notification.style.cssText = `
                position: fixed;
                top: 80px;
                right: 20px;
                z-index: 10000;
                padding: 15px 20px;
                border-radius: 8px;
                color: white;
                font-weight: 500;
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
                <h3 style="margin: 0 0 15px 0; color: #5D4037; font-size: 20px;">需要登录</h3>
                <p style="margin: 0 0 25px 0; color: #666; line-height: 1.5;">${message}</p>
                <div style="display: flex; gap: 15px; justify-content: center;">
                    <button onclick="closeLoginPrompt()" style="flex: 1; padding: 12px 20px; border: none; border-radius: 6px; background: #f0f0f0; color: #666; cursor: pointer; font-size: 14px;">取消</button>
                    <button onclick="goToLogin()" style="flex: 1; padding: 12px 20px; border: none; border-radius: 6px; background: #FF9800; color: white; cursor: pointer; font-size: 14px; font-weight: 500;">去登录</button>
                </div>
            `;

            // 添加CSS动画
            const style = document.createElement('style');
            style.textContent = `
                @keyframes fadeIn {
                    from { opacity: 0; }
                    to { opacity: 1; }
                }
                @keyframes slideIn {
                    from { transform: translateY(-20px); opacity: 0; }
                    to { transform: translateY(0); opacity: 1; }
                }
            `;
            document.head.appendChild(style);

            overlay.appendChild(modal);
            document.body.appendChild(overlay);

            // 点击遮罩层关闭
            overlay.addEventListener('click', function(e) {
                if (e.target === overlay) {
                    closeLoginPrompt();
                }
            });
        }

        function closeLoginPrompt() {
            const overlay = document.querySelector('[style*="position: fixed"][style*="background-color: rgba(0, 0, 0, 0.5)"]');
            if (overlay) {
                overlay.remove();
            }
        }

        function goToLogin() {
            window.location.href = 'login.jsp';
        }

        // 获取懒加载配置
        function getLazyLoadConfig() {
            return {
                container: '#goods-container',
                loadingHtml: '<div class="loading-state"><div class="loading-spinner"></div><p>正在加载热销商品...</p></div>',
                emptyHtml: '<div class="empty-state"><div class="empty-state-icon">🔥</div><h3 class="empty-state-title">暂无热销商品</h3><p class="empty-state-description">目前没有热销商品，请查看其他商品分类</p><div class="empty-state-actions"><a href="index.jsp" class="btn-view-detail">返回首页</a></div></div>',
                errorHtml: '<div class="empty-state"><div class="empty-state-icon">⚠️</div><h3 class="empty-state-title">加载失败</h3><p class="empty-state-description">加载热销商品失败，请重试</p><div class="empty-state-actions"><button onclick="location.reload()" class="btn-add-cart">重新加载</button></div></div>',
                goodsCardTemplate: function(goods) {
                    const imageUrl = goods.coverImage && goods.coverImage !== 'null' ? goods.coverImage : 'images/apple_pie_1.jpg';
                    const isOutOfStock = goods.stock <= 0;
                    const goodsName = goods.goodsName || '商品名称';
                    const description = goods.description || '暂无描述';
                    const price = goods.price || 0;
                    const goodsId = goods.goodsId || 0;
                    const stock = goods.stock || 0;

                    let cardHtml = '<div class="product-card">';
                    cardHtml += '<div class="product-image-container" onclick="goToDetail(event, ' + goodsId + ')">';
                    cardHtml += '<img src="' + imageUrl + '" alt="' + goodsName + '" class="product-image"';
                    cardHtml += ' onerror="this.src=\'images/apple_pie_1.jpg\'" loading="lazy">';
                    cardHtml += '<div class="product-category">热销推荐</div>';
                    if (isOutOfStock) {
                        cardHtml += '<div class="out-of-stock-overlay">暂时缺货</div>';
                    }
                    cardHtml += '</div>';
                    cardHtml += '<div class="product-info">';
                    cardHtml += '<h3 class="product-title" onclick="goToDetail(event, ' + goodsId + ')">' + goodsName + '</h3>';
                    cardHtml += '<p class="product-description">' + description + '</p>';
                    cardHtml += '<div class="product-price-section">';
                    cardHtml += '<span class="product-price">¥' + price + '</span>';
                    cardHtml += '</div>';
                    cardHtml += '<div class="product-actions">';
                    cardHtml += '<button class="btn-view-detail" onclick="goToDetail(event, ' + goodsId + ')">查看详情</button>';
                    const disabledAttr = isOutOfStock ? ' disabled' : '';
                    const buttonText = isOutOfStock ? '暂时缺货' : '加入购物车';
                    cardHtml += '<button class="btn-add-cart" onclick="addToCart(' + goodsId + ', \'' + goodsName.replace(/'/g, "\\'") + '\', ' + price + ', ' + stock + ')"' + disabledAttr + '>' + buttonText + '</button>';
                    cardHtml += '</div>';
                    cardHtml += '</div>';
                    cardHtml += '</div>';

                    return cardHtml;
                }
            };
        }
    </script>
</head>
<body class="recommend-page">
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
                    <li><a href="goods?action=hot" class="active">热销</a></li>
                    <li><a href="goods?action=new">新品</a></li>
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
                        <div class="search-suggestions" id="searchSuggestions">
                            <!-- 搜索建议将通过JavaScript动态填充 -->
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
                <a href="cart" class="cart-icon">
                    🛒
                    <span class="cart-count" id="cartCount">0</span>
                </a>
            </div>
        </div>
    </header>

    <!-- 面包屑导航 -->
    <div class="container">
        <div class="breadcrumb">
            <a href="index.jsp">首页</a>
            <span class="separator">></span>
            <span class="current">${pageTitle}</span>
        </div>

        <!-- 页面标题 -->
        <div class="page-header">
            <div class="page-icon">🔥</div>
            <div class="page-title-section">
                <h1 class="page-title">${pageTitle}</h1>
                <p class="page-subtitle">精选最受欢迎的热销蛋糕，每一款都是经典之作</p>
            </div>
        </div>

        <!-- 商品列表容器 -->
        <div id="goods-container" class="recommend-results">
            <!-- 商品将通过JavaScript动态加载 -->
        </div>
    </div>

    <!-- 底部 -->
    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h3>环创店</h3>
                    <p>专注于为您提供最优质的蛋糕和烘焙产品</p>
                </div>
                <div class="footer-section">
                    <h4>快速链接</h4>
                    <ul>
                        <li><a href="index.jsp">首页</a></li>
                        <li><a href="goods?action=hot">热销商品</a></li>
                        <li><a href="goods?action=new">新品上市</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h4>购物指南</h4>
                    <ul>
                        <li><a href="#">购物流程</a></li>
                        <li><a href="#">支付方式</a></li>
                        <li><a href="#">配送说明</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h4>联系我们</h4>
                    <p>电话：400-123-4567</p>
                    <p>邮箱：service@huachuangdian.com</p>
                    <p>地址：北京市朝阳区某某街道123号</p>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2025 环创店. 版权所有.</p>
            </div>
        </div>
    </footer>
</body>
</html>