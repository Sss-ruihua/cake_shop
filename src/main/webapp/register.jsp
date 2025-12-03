<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>环创店 - 注册新用户</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/style.css">
    <script>
        // 验证规则定义
        const validationRules = {
            username: {
                required: true,
                minLength: 2,
                maxLength: 20,
                pattern: /^[a-zA-Z0-9_\u4e00-\u9fa5]+$/,
                messages: {
                    required: '用户名不能为空',
                    minLength: '用户名至少需要2个字符',
                    maxLength: '用户名不能超过20个字符',
                    pattern: '用户名只能包含字母、数字、下划线和中文'
                }
            },
            email: {
                required: true,
                pattern: /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/,
                messages: {
                    required: '邮箱不能为空',
                    pattern: '请输入有效的邮箱地址'
                }
            },
            password: {
                required: true,
                minLength: 6,
                maxLength: 20,
                pattern: /^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]*$/,
                messages: {
                    required: '密码不能为空',
                    minLength: '密码至少需要6位字符',
                    maxLength: '密码不能超过20位字符',
                    pattern: '密码需要包含至少一个字母和一个数字'
                }
            }
        };

        // 显示错误信息
        function showError(fieldId, message) {
            const errorElement = document.getElementById(fieldId + '-error');
            const inputElement = document.getElementById(fieldId);

            if (errorElement) {
                errorElement.textContent = message;
                errorElement.style.display = 'block';
                errorElement.className = 'error-message show';
            }

            if (inputElement) {
                inputElement.classList.add('error');
                inputElement.classList.remove('success');
            }
        }

        // 显示成功信息
        function showSuccess(fieldId) {
            const errorElement = document.getElementById(fieldId + '-error');
            const inputElement = document.getElementById(fieldId);

            if (errorElement) {
                errorElement.style.display = 'none';
                errorElement.classList.remove('show');
            }

            if (inputElement) {
                inputElement.classList.remove('error');
                inputElement.classList.add('success');
            }
        }

        // 清除验证状态
        function clearValidation(fieldId) {
            const errorElement = document.getElementById(fieldId + '-error');
            const inputElement = document.getElementById(fieldId);

            if (errorElement) {
                errorElement.style.display = 'none';
                errorElement.classList.remove('show');
            }

            if (inputElement) {
                inputElement.classList.remove('error', 'success');
            }
        }

        // 验证单个字段
        function validateField(fieldId) {
            const field = document.getElementById(fieldId);
            const value = field.value.trim();
            const rules = validationRules[fieldId];

            if (!rules) return true;

            // 检查必填项
            if (rules.required && !value) {
                showError(fieldId, rules.messages.required);
                return false;
            }

            // 如果字段为空且不是必填项，跳过其他验证
            if (!value) {
                showSuccess(fieldId);
                return true;
            }

            // 检查最小长度
            if (rules.minLength && value.length < rules.minLength) {
                showError(fieldId, rules.messages.minLength);
                return false;
            }

            // 检查最大长度
            if (rules.maxLength && value.length > rules.maxLength) {
                showError(fieldId, rules.messages.maxLength);
                return false;
            }

            // 检查正则表达式
            if (rules.pattern && !rules.pattern.test(value)) {
                showError(fieldId, rules.messages.pattern);
                return false;
            }

            // 所有验证通过
            showSuccess(fieldId);
            return true;
        }

        // 实时验证函数
        function setupFieldValidation(fieldId) {
            const field = document.getElementById(fieldId);

            if (field) {
                // 失去焦点时验证
                field.addEventListener('blur', function() {
                    validateField(fieldId);
                });

                // 输入时清除错误状态
                field.addEventListener('input', function() {
                    if (this.classList.contains('error')) {
                        clearValidation(fieldId);
                    }
                });
            }
        }

        // 表单提交验证
        function validateForm() {
            let isValid = true;
            const requiredFields = ['username', 'email', 'password'];

            // 只验证必填字段
            requiredFields.forEach(fieldId => {
                if (!validateField(fieldId)) {
                    isValid = false;
                }
            });

            return isValid;
        }

        // 页面加载完成后设置验证
        document.addEventListener('DOMContentLoaded', function() {
            // 只为必填字段设置验证
            const requiredFields = ['username', 'email', 'password'];
            requiredFields.forEach(fieldId => {
                setupFieldValidation(fieldId);
            });

            // 为表单添加提交验证
            const form = document.querySelector('form');
            if (form) {
                form.addEventListener('submit', function(e) {
                    if (!validateForm()) {
                        e.preventDefault();
                        // 滚动到第一个错误字段
                        const firstError = document.querySelector('.error');
                        if (firstError) {
                            firstError.focus();
                            firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                        }
                    }
                });
            }
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
                    <li><a href="register.jsp" class="active">注册</a></li>
                    <li><a href="login.jsp">登录</a></li>
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

    <!-- 注册内容区 -->
    <main class="register-container">
        <h1 class="register-title">注册新用户</h1>

        <!-- 错误消息显示 -->
        <%
            String error = request.getParameter("error");
            if (error != null) {
        %>
            <% if ("required".equals(error)) { %>
                <div class="alert alert-error">请填写所有必填字段！</div>
            <% } else if ("username_exists".equals(error)) { %>
                <div class="alert alert-error">用户名已存在，请选择其他用户名！</div>
            <% } else if ("email_exists".equals(error)) { %>
                <div class="alert alert-error">邮箱已被注册，请使用其他邮箱！</div>
            <% } else if ("email".equals(error)) { %>
                <div class="alert alert-error">请输入有效的邮箱地址！</div>
            <% } else if ("password".equals(error)) { %>
                <div class="alert alert-error">密码至少需要6位字符！</div>
            <% } else if ("failed".equals(error)) { %>
                <div class="alert alert-error">注册失败，请重试！</div>
            <% } else if ("system".equals(error)) { %>
                <div class="alert alert-error">系统错误，请稍后重试！</div>
            <% } %>
        <% } %>

        <form action="register" method="post" onsubmit="return validateForm()">
            <div class="form-group">
                <label for="username">
                    用户名 <span class="required">*</span>
                </label>
                <input type="text" id="username" name="username" class="form-control" placeholder="请输入用户名">
                <div id="username-error" class="error-message"></div>
            </div>

            <div class="form-group">
                <label for="email">
                    邮箱 <span class="required">*</span>
                </label>
                <input type="email" id="email" name="email" class="form-control" placeholder="请输入邮箱地址">
                <div id="email-error" class="error-message"></div>
            </div>

            <div class="form-group">
                <label for="password">
                    密码 <span class="required">*</span>
                </label>
                <input type="password" id="password" name="password" class="form-control" placeholder="请输入密码">
                <div id="password-error" class="error-message"></div>
            </div>

            <div class="form-group">
                <label for="receiver">
                    收货人
                </label>
                <input type="text" id="receiver" name="receiver" class="form-control" placeholder="请输入收货人姓名（可选）">
            </div>

            <div class="form-group">
                <label for="phone">
                    收货电话
                </label>
                <input type="tel" id="phone" name="phone" class="form-control" placeholder="请输入联系电话（可选）">
            </div>

            <div class="form-group">
                <label for="address">
                    收货地址
                </label>
                <input type="text" id="address" name="address" class="form-control" placeholder="请输入详细收货地址（可选）">
            </div>

            <button type="submit" class="submit-btn">立即注册</button>
        </form>
    </main>
</body>
</html>