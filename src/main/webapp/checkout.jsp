<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.sgu.cakeshopserive.servlet.CartServlet" %>
<%@ page import="com.sgu.cakeshopserive.model.Goods" %>
<!DOCTYPE html>
<html>
<head>
    <title>环创店 - 订单结算</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/main.css">
    <script>
        function validateForm() {
            const receiverName = document.getElementById('receiverName');
            const receiverPhone = document.getElementById('receiverPhone');
            const receiverAddress = document.getElementById('receiverAddress');
            const paymentMethod = document.getElementById('paymentMethod');

            // 姓名验证
            if (!receiverName.value.trim()) {
                showError('receiverName', '请输入收货人姓名');
                return false;
            }
            if (receiverName.value.trim().length < 2) {
                showError('receiverName', '收货人姓名至少2个字符');
                return false;
            }
            clearError('receiverName');

            // 电话验证
            if (!receiverPhone.value.trim()) {
                showError('receiverPhone', '请输入联系电话');
                return false;
            }
            const phoneRegex = /^1[3-9]\d{9}$/;
            if (!phoneRegex.test(receiverPhone.value.trim())) {
                showError('receiverPhone', '请输入正确的手机号码');
                return false;
            }
            clearError('receiverPhone');

            // 地址验证
            if (!receiverAddress.value.trim()) {
                showError('receiverAddress', '请输入收货地址');
                return false;
            }
            if (receiverAddress.value.trim().length < 5) {
                showError('receiverAddress', '收货地址至少5个字符');
                return false;
            }
            clearError('receiverAddress');

            // 支付方式验证
            if (!paymentMethod.value) {
                showError('paymentMethod', '请选择支付方式');
                return false;
            }
            clearError('paymentMethod');

            return true;
        }

        function showError(fieldId, message) {
            const field = document.getElementById(fieldId);
            const errorDiv = document.getElementById(fieldId + 'Error');

            field.classList.add('error');
            errorDiv.textContent = message;
            errorDiv.classList.add('show');
        }

        function clearError(fieldId) {
            const field = document.getElementById(fieldId);
            const errorDiv = document.getElementById(fieldId + 'Error');

            field.classList.remove('error');
            errorDiv.classList.remove('show');
        }

        function submitOrder() {
            if (!validateForm()) {
                return;
            }

            const form = document.getElementById('checkoutForm');
            const formData = new FormData(form);

            // 添加购物车数据
            const cartItems = document.querySelectorAll('.checkout-item');
            cartItems.forEach((item, index) => {
                formData.append(`goodsId${index}`, item.dataset.goodsId);
                formData.append(`quantity${index}`, item.dataset.quantity);
                formData.append(`price${index}`, item.dataset.price);
                formData.append(`subtotal${index}`, item.dataset.subtotal);
            });

            // 发送订单
            fetch('order?action=create', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    window.location.href = 'order-success.jsp?orderId=' + data.data;
                } else {
                    alert('订单创建失败: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('提交订单时发生错误，请重试');
            });
        }

        function backToCart() {
            window.location.href = 'cart';
        }

        function updateTotal() {
            const deliveryFee = parseFloat(document.getElementById('deliveryFee').textContent.replace('¥', ''));
            const totalAmount = parseFloat(document.getElementById('totalAmount').textContent.replace('¥', ''));
            const finalAmount = deliveryFee + totalAmount;
            document.getElementById('finalAmount').textContent = '¥' + finalAmount.toFixed(2);
        }

        // 页面加载时更新总金额
        document.addEventListener('DOMContentLoaded', function() {
            updateTotal();
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
                    <li><a href="#">商品分类 ▼</a></li>
                    <li><a href="#">热销</a></li>
                    <li><a href="#">新品</a></li>
                    <li><a href="cart">购物车</a></li>
                    <li><a href="#" class="active">订单结算</a></li>
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
        <div class="checkout-container">
            <div class="checkout-header">
                <h1 class="checkout-title">📋 订单结算</h1>
                <div class="checkout-steps">
                    <div class="step completed">
                        <span class="step-number">1</span>
                        <span class="step-text">确认购物车</span>
                    </div>
                    <div class="step active">
                        <span class="step-number">2</span>
                        <span class="step-text">填写收货信息</span>
                    </div>
                    <div class="step">
                        <span class="step-number">3</span>
                        <span class="step-text">支付订单</span>
                    </div>
                </div>
            </div>

            <div class="checkout-content">
                <div class="checkout-left">
                    <!-- 收货信息表单 -->
                    <div class="checkout-section">
                        <h2 class="section-title">📍 收货信息</h2>
                        <form id="checkoutForm" class="checkout-form">
                            <div class="form-group">
                                <label for="receiverName" class="form-label">
                                    收货人姓名 <span class="required">*</span>
                                </label>
                                <input type="text"
                                       id="receiverName"
                                       name="receiverName"
                                       class="form-control"
                                       placeholder="请输入收货人姓名"
                                       value="${sessionScope.realName != null ? sessionScope.realName : ''}">
                                <div id="receiverNameError" class="error-message"></div>
                            </div>

                            <div class="form-group">
                                <label for="receiverPhone" class="form-label">
                                    联系电话 <span class="required">*</span>
                                </label>
                                <input type="tel"
                                       id="receiverPhone"
                                       name="receiverPhone"
                                       class="form-control"
                                       placeholder="请输入手机号码"
                                       value="${sessionScope.phone != null ? sessionScope.phone : ''}">
                                <div id="receiverPhoneError" class="error-message"></div>
                            </div>

                            <div class="form-group">
                                <label for="receiverAddress" class="form-label">
                                    收货地址 <span class="required">*</span>
                                </label>
                                <textarea id="receiverAddress"
                                          name="receiverAddress"
                                          class="form-control"
                                          rows="3"
                                          placeholder="请输入详细的收货地址">${sessionScope.address != null ? sessionScope.address : ''}</textarea>
                                <div id="receiverAddressError" class="error-message"></div>
                            </div>

                            <div class="form-group">
                                <label for="deliveryTime" class="form-label">期望送达时间</label>
                                <select id="deliveryTime" name="deliveryTime" class="form-control">
                                    <option value="">尽快送达</option>
                                    <option value="morning">上午 (9:00-12:00)</option>
                                    <option value="afternoon">下午 (14:00-18:00)</option>
                                    <option value="evening">晚上 (18:00-21:00)</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="orderNotes" class="form-label">订单备注</label>
                                <textarea id="orderNotes"
                                          name="orderNotes"
                                          class="form-control"
                                          rows="2"
                                          placeholder="如有特殊要求请在此说明"></textarea>
                            </div>
                        </form>
                    </div>

                    <!-- 支付方式 -->
                    <div class="checkout-section">
                        <h2 class="section-title">💳 支付方式</h2>
                        <div class="payment-methods">
                            <div class="payment-option">
                                <input type="radio" id="wechat" name="paymentMethod" value="wechat" checked>
                                <label for="wechat" class="payment-label">
                                    <span class="payment-icon">💚</span>
                                    <span class="payment-text">微信支付</span>
                                </label>
                            </div>
                            <div class="payment-option">
                                <input type="radio" id="alipay" name="paymentMethod" value="alipay">
                                <label for="alipay" class="payment-label">
                                    <span class="payment-icon">💙</span>
                                    <span class="payment-text">支付宝</span>
                                </label>
                            </div>
                            <div class="payment-option">
                                <input type="radio" id="cod" name="paymentMethod" value="cod">
                                <label for="cod" class="payment-label">
                                    <span class="payment-icon">💵</span>
                                    <span class="payment-text">货到付款</span>
                                </label>
                            </div>
                        </div>
                        <div id="paymentMethodError" class="error-message"></div>
                    </div>
                </div>

                <div class="checkout-right">
                    <!-- 订单商品列表 -->
                    <div class="checkout-section">
                        <h2 class="section-title">🛒 订单商品</h2>
                        <div class="checkout-items">
                            <%
                                List<CartServlet.CartItem> cartItems = (List<CartServlet.CartItem>) request.getAttribute("cartItems");
                                Double totalAmount = (Double) request.getAttribute("totalAmount");
                                Integer totalQuantity = (Integer) request.getAttribute("totalQuantity");

                                if (cartItems != null && !cartItems.isEmpty()) {
                                    for (CartServlet.CartItem item : cartItems) {
                                        Goods goods = item.getGoods();
                            %>
                            <div class="checkout-item"
                                 data-goods-id="<%= goods.getGoodsId() %>"
                                 data-quantity="<%= item.getQuantity() %>"
                                 data-price="<%= goods.getPrice() %>"
                                 data-subtotal="<%= item.getSubtotal() %>">
                                <img src="<%= goods.getCoverImage() != null && !goods.getCoverImage().isEmpty() ? goods.getCoverImage() : "images/default.jpg" %>"
                                     alt="<%= goods.getGoodsName() %>" class="checkout-item-image">
                                <div class="checkout-item-details">
                                    <h4 class="checkout-item-name"><%= goods.getGoodsName() %></h4>
                                    <p class="checkout-item-price">¥<%= String.format("%.2f", goods.getPrice()) %></p>
                                </div>
                                <div class="checkout-item-quantity">× <%= item.getQuantity() %></div>
                            </div>
                            <%
                                    }
                                }
                            %>
                        </div>
                    </div>

                    <!-- 订单汇总 -->
                    <div class="checkout-section">
                        <h2 class="section-title">💰 订单汇总</h2>
                        <div class="order-summary">
                            <div class="summary-item">
                                <span class="summary-label">商品总数：</span>
                                <span class="summary-value"><%= totalQuantity != null ? totalQuantity : 0 %>件</span>
                            </div>
                            <div class="summary-item">
                                <span class="summary-label">商品金额：</span>
                                <span class="summary-value" id="totalAmount">¥<%= totalAmount != null ? String.format("%.2f", totalAmount) : "0.00" %></span>
                            </div>
                            <div class="summary-item">
                                <span class="summary-label">配送费：</span>
                                <span class="summary-value" id="deliveryFee">¥<%= totalAmount != null && totalAmount > 100 ? "0.00" : "8.00" %></span>
                            </div>
                            <% if (totalAmount != null && totalAmount > 100) { %>
                            <div class="summary-item discount">
                                <span class="summary-label">满减优惠：</span>
                                <span class="summary-value">-¥8.00</span>
                            </div>
                            <% } %>
                            <div class="summary-item total">
                                <span class="summary-label">应付总额：</span>
                                <span class="summary-value" id="finalAmount">¥<%= totalAmount != null ? String.format("%.2f", totalAmount > 100 ? totalAmount : totalAmount + 8) : "8.00" %></span>
                            </div>
                        </div>

                        <!-- 提交按钮 -->
                        <div class="checkout-actions">
                            <button class="btn btn-outline" onclick="backToCart()">返回购物车</button>
                            <button class="btn btn-primary btn-submit" onclick="submitOrder()">
                                提交订单
                            </button>
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
        /* 结算页面专用样式 */
        .checkout-container {
            max-width: 1200px;
            margin: 20px auto;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .checkout-header {
            padding: 30px;
            background-color: #f9f9f9;
            border-bottom: 1px solid #E0E0E0;
        }

        .checkout-title {
            color: #5D4037;
            font-size: 28px;
            margin: 0 0 20px 0;
            font-weight: bold;
        }

        .checkout-steps {
            display: flex;
            justify-content: center;
            gap: 40px;
        }

        .step {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
        }

        .step-number {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background-color: #E0E0E0;
            color: #999;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 16px;
        }

        .step.completed .step-number {
            background-color: #4CAF50;
            color: white;
        }

        .step.active .step-number {
            background-color: #FF9800;
            color: white;
            box-shadow: 0 0 0 4px rgba(255,152,0,0.2);
        }

        .step-text {
            font-size: 14px;
            color: #666;
            font-weight: 500;
        }

        .step.completed .step-text,
        .step.active .step-text {
            color: #5D4037;
            font-weight: bold;
        }

        .checkout-content {
            display: flex;
            gap: 40px;
            padding: 30px;
        }

        .checkout-left {
            flex: 3;
        }

        .checkout-right {
            flex: 2;
        }

        .checkout-section {
            margin-bottom: 30px;
        }

        .section-title {
            color: #5D4037;
            font-size: 20px;
            margin-bottom: 20px;
            font-weight: bold;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .checkout-form {
            background-color: #f9f9f9;
            padding: 25px;
            border-radius: 8px;
            border-left: 4px solid #FF9800;
        }

        .form-label {
            color: #333;
            font-weight: 600;
            font-size: 14px;
            margin-bottom: 8px;
            display: block;
        }

        .payment-methods {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }

        .payment-option {
            position: relative;
        }

        .payment-option input[type="radio"] {
            position: absolute;
            opacity: 0;
        }

        .payment-label {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 15px 20px;
            border: 2px solid #E0E0E0;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            background-color: white;
        }

        .payment-label:hover {
            border-color: #FF9800;
            background-color: #FFF8E1;
        }

        .payment-option input[type="radio"]:checked + .payment-label {
            border-color: #FF9800;
            background-color: #FFF8E1;
            box-shadow: 0 0 0 3px rgba(255,152,0,0.1);
        }

        .payment-icon {
            font-size: 24px;
        }

        .payment-text {
            font-size: 16px;
            font-weight: 500;
            color: #333;
        }

        .checkout-items {
            max-height: 400px;
            overflow-y: auto;
            border: 1px solid #E0E0E0;
            border-radius: 8px;
            background-color: white;
        }

        .checkout-item {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 15px;
            border-bottom: 1px solid #f0f0f0;
        }

        .checkout-item:last-child {
            border-bottom: none;
        }

        .checkout-item-image {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 6px;
            border: 1px solid #E0E0E0;
        }

        .checkout-item-details {
            flex: 1;
        }

        .checkout-item-name {
            font-size: 14px;
            font-weight: bold;
            color: #5D4037;
            margin: 0 0 5px 0;
            line-height: 1.3;
        }

        .checkout-item-price {
            font-size: 14px;
            color: #FF5722;
            font-weight: bold;
            margin: 0;
        }

        .checkout-item-quantity {
            font-size: 14px;
            color: #666;
            font-weight: 500;
            white-space: nowrap;
        }

        .order-summary {
            background-color: #f9f9f9;
            padding: 25px;
            border-radius: 8px;
            border-left: 4px solid #4CAF50;
        }

        .summary-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #E0E0E0;
        }

        .summary-item:last-child {
            border-bottom: none;
        }

        .summary-item.total {
            border-top: 2px solid #5D4037;
            margin-top: 10px;
            padding-top: 15px;
        }

        .summary-item.discount .summary-value {
            color: #4CAF50;
            font-weight: bold;
        }

        .summary-label {
            font-size: 14px;
            color: #666;
            font-weight: 500;
        }

        .summary-value {
            font-size: 16px;
            font-weight: bold;
            color: #333;
        }

        .summary-item.total .summary-value {
            color: #FF5722;
            font-size: 20px;
        }

        .checkout-actions {
            display: flex;
            gap: 15px;
            margin-top: 20px;
        }

        .btn-submit {
            flex: 2;
            font-size: 18px;
            padding: 15px 30px;
            background-color: #4CAF50;
        }

        .btn-submit:hover {
            background-color: #45a049;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(76,175,80,0.3);
        }

        /* 结算页面响应式设计 */
        @media (max-width: 992px) {
            .checkout-container {
                margin: 10px;
            }

            .checkout-header {
                padding: 20px;
            }

            .checkout-steps {
                gap: 20px;
            }

            .checkout-content {
                flex-direction: column;
                gap: 30px;
                padding: 20px;
            }

            .checkout-left,
            .checkout-right {
                flex: 1;
            }

            .payment-methods {
                grid-template-columns: 1fr;
            }

            .checkout-actions {
                flex-direction: column;
            }

            .btn-submit {
                order: 2;
            }
        }

        @media (max-width: 768px) {
            .checkout-header {
                padding: 15px;
            }

            .checkout-title {
                font-size: 22px;
                text-align: center;
            }

            .checkout-steps {
                gap: 15px;
            }

            .step-text {
                font-size: 12px;
            }

            .checkout-content {
                padding: 15px;
                gap: 20px;
            }

            .section-title {
                font-size: 18px;
            }

            .checkout-form {
                padding: 20px;
            }

            .payment-label {
                padding: 12px 15px;
            }

            .payment-icon {
                font-size: 20px;
            }

            .payment-text {
                font-size: 14px;
            }

            .checkout-item {
                padding: 12px;
            }

            .checkout-item-image {
                width: 50px;
                height: 50px;
            }

            .checkout-item-name {
                font-size: 13px;
            }

            .checkout-item-price {
                font-size: 13px;
            }

            .checkout-item-quantity {
                font-size: 12px;
            }

            .order-summary {
                padding: 20px;
            }

            .summary-label {
                font-size: 13px;
            }

            .summary-value {
                font-size: 14px;
            }

            .summary-item.total .summary-value {
                font-size: 18px;
            }

            .btn-submit {
                font-size: 16px;
                padding: 12px 20px;
            }
        }

        @media (max-width: 480px) {
            .checkout-container {
                margin: 5px;
                border-radius: 8px;
            }

            .checkout-header {
                padding: 10px;
            }

            .checkout-title {
                font-size: 18px;
            }

            .checkout-steps {
                gap: 10px;
            }

            .step-number {
                width: 28px;
                height: 28px;
                font-size: 14px;
            }

            .step-text {
                font-size: 11px;
            }

            .checkout-content {
                padding: 10px;
                gap: 15px;
            }

            .section-title {
                font-size: 16px;
            }

            .checkout-form {
                padding: 15px;
            }

            .payment-label {
                padding: 10px 12px;
                flex-direction: column;
                text-align: center;
                gap: 8px;
            }

            .payment-icon {
                font-size: 18px;
            }

            .payment-text {
                font-size: 13px;
            }

            .checkout-item {
                padding: 10px;
            }

            .checkout-item-image {
                width: 40px;
                height: 40px;
            }

            .checkout-item-name {
                font-size: 12px;
            }

            .checkout-item-price,
            .checkout-item-quantity {
                font-size: 12px;
            }

            .order-summary {
                padding: 15px;
            }

            .summary-item {
                padding: 10px 0;
            }

            .summary-label {
                font-size: 12px;
            }

            .summary-value {
                font-size: 13px;
            }

            .summary-item.total .summary-value {
                font-size: 16px;
            }

            .btn-submit {
                font-size: 14px;
                padding: 10px 15px;
            }
        }
    </style>
</body>
</html>