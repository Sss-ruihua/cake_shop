<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sgu.cakeshopserive.model.Goods" %>
<!DOCTYPE html>
<html>
<head>
    <title>商品详情 - 环创店</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/style.css">
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
                    <li><a href="#" class="active">商品详情</a></li>
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
                                <form action="cart" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="goodsId" value="<%= goods.getGoodsId() %>">
                                    <input type="hidden" name="quantity" value="1">
                                    <button type="submit" class="btn-primary">加入购物车</button>
                                </form>
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