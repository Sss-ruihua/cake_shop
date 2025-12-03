<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    response.setStatus(200); // 重置状态码，避免循环重定向
%>
<!DOCTYPE html>
<html>
<head>
    <title>环创店 - 错误页面</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .error-container {
            max-width: 600px;
            margin: 100px auto;
            padding: 40px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            text-align: center;
        }

        .error-code {
            font-size: 72px;
            color: #FF5722;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .error-title {
            font-size: 28px;
            color: #5D4037;
            margin-bottom: 20px;
        }

        .error-description {
            color: #666;
            font-size: 16px;
            line-height: 1.6;
            margin-bottom: 30px;
        }

        .back-btn {
            background-color: #5D4037;
            color: white;
            padding: 12px 30px;
            text-decoration: none;
            border-radius: 6px;
            font-weight: bold;
            display: inline-block;
            transition: background-color 0.3s;
        }

        .back-btn:hover {
            background-color: #FF9800;
        }
    </style>
</head>
<body>
    <!-- 错误内容区 -->
    <main class="error-container">
        <div class="error-code">555</div>
        <h1 class="error-title">页面错误</h1>
        <p class="error-description">
            抱歉，您访问的页面不存在或已被删除。<br>
            请检查网址是否正确，或返回首页继续浏览。
        </p>
        <a href="index.jsp" class="back-btn">返回首页</a>
    </main>
</body>
</html>