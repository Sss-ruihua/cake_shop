<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>环创店 - 用户登录</title>
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
            password: {
                required: true,
                minLength: 1,
                maxLength: 20,
                messages: {
                    required: '密码不能为空',
                    minLength: '密码不能为空',
                    maxLength: '密码不能超过20位字符'
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
            const requiredFields = ['username', 'password'];

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
            const requiredFields = ['username', 'password'];
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
                    <li><a href="register.jsp">注册</a></li>
                    <li><a href="login.jsp" class="active">登录</a></li>
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

    <!-- 登录内容区 -->
    <main class="login-container">
        <h1 class="login-title">用户登录</h1>

        <!-- 错误消息显示 -->
        <%
            String error = request.getParameter("error");
            if (error != null) {
        %>
            <% if ("required".equals(error)) { %>
                <div class="alert alert-error">请填写所有必填字段！</div>
            <% } else if ("invalid_credentials".equals(error)) { %>
                <div class="alert alert-error">用户名或密码错误！</div>
            <% } else if ("not_found".equals(error)) { %>
                <div class="alert alert-error">用户不存在，请先注册！</div>
            <% } else if ("failed".equals(error)) { %>
                <div class="alert alert-error">登录失败，请重试！</div>
            <% } else if ("system".equals(error)) { %>
                <div class="alert alert-error">系统错误，请稍后重试！</div>
            <% } %>
        <% } %>

        <!-- 成功消息显示 -->
        <%
            String success = request.getParameter("success");
            if (success != null) {
        %>
            <% if ("registered".equals(success)) { %>
                <div class="alert alert-success">注册成功！请登录。</div>
            <% } else if ("logout".equals(success)) { %>
                <div class="alert alert-success">您已成功退出登录！</div>
            <% } else if ("register".equals(success)) { %>
                <div class="alert alert-success">注册成功！请登录。</div>
            <% } %>
        <% } %>

        <form action="login" method="post" onsubmit="return validateForm()">
            <div class="form-group">
                <label for="username">
                    用户名 <span class="required">*</span>
                </label>
                <input type="text" id="username" name="username" class="form-control" placeholder="请输入用户名">
                <div id="username-error" class="error-message"></div>
            </div>

            <div class="form-group">
                <label for="password">
                    密码 <span class="required">*</span>
                </label>
                <input type="password" id="password" name="password" class="form-control" placeholder="请输入密码">
                <div id="password-error" class="error-message"></div>
            </div>

            <button type="submit" class="submit-btn">立即登录</button>
        </form>

        <div style="text-align: center; margin-top: 20px;">
            <p style="color: #666; font-size: 14px;">
                还没有账号？<a href="register.jsp" style="color: #FF9800; text-decoration: none; font-weight: bold;">立即注册</a>
            </p>
        </div>
    </main>
</body>
</html>