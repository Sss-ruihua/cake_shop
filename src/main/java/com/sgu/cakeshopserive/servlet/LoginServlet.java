package com.sgu.cakeshopserive.servlet;

import com.sgu.cakeshopserive.common.Constants;
import com.sgu.cakeshopserive.common.Result;
import com.sgu.cakeshopserive.model.User;
import com.sgu.cakeshopserive.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * 登录控制器
 * 职责：处理HTTP请求，调用业务服务，返回响应
 */
@WebServlet(name = "loginServlet", value = "/login")
public class LoginServlet extends HttpServlet {

    private UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // 获取表单参数
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 调用业务服务处理登录
        Result<User> result = userService.login(username, password);

        if (result.isSuccess()) {
            // 登录成功，创建会话
            User user = result.getData();
            HttpSession session = request.getSession();

            // 存储用户信息到会话中
            session.setAttribute(Constants.SESSION_USER_ID, user.getUserId());
            session.setAttribute(Constants.SESSION_USERNAME, user.getUsername());
            session.setAttribute(Constants.SESSION_REAL_NAME, user.getRealName());
            session.setAttribute(Constants.SESSION_EMAIL, user.getEmail());
            session.setAttribute(Constants.SESSION_PHONE, user.getPhone());
            session.setAttribute(Constants.SESSION_ADDRESS, user.getAddress());
            session.setAttribute(Constants.SESSION_IS_ADMIN, user.isAdmin());
            session.setAttribute(Constants.SESSION_IS_LOGGED_IN, true);

            // 设置会话超时时间
            session.setMaxInactiveInterval(Constants.SESSION_TIMEOUT * 60);

            // 登录成功，跳转到首页
            response.sendRedirect("index.jsp?success=login");
        } else {
            // 登录失败，根据错误类型重定向
            String errorCode = result.getCode();
            String errorParam = getErrorParameter(errorCode);
            response.sendRedirect("login.jsp?error=" + errorParam);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // GET请求直接转发到登录页面
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    /**
     * 将错误代码转换为JSP页面参数
     * @param errorCode 业务错误代码
     * @return 页面错误参数
     */
    private String getErrorParameter(String errorCode) {
        switch (errorCode) {
            case Constants.CODE_PARAM_ERROR:
                return "required";
            case Constants.CODE_USER_NOT_FOUND:
                return "not_found";
            case Constants.CODE_PASSWORD_ERROR:
                return "invalid_credentials";
            case Constants.CODE_ACCOUNT_INACTIVE:
                return "account_inactive";
            case Constants.CODE_ERROR:
            default:
                return "system";
        }
    }
}