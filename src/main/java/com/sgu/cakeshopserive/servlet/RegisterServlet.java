package com.sgu.cakeshopserive.servlet;

import com.sgu.cakeshopserive.common.Constants;
import com.sgu.cakeshopserive.common.Result;
import com.sgu.cakeshopserive.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * 注册控制器
 * 职责：处理HTTP请求，调用业务服务，返回响应
 */
@WebServlet(name = "registerServlet", value = "/register")
public class RegisterServlet extends HttpServlet {

    private UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // 获取表单参数
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String realName = request.getParameter("receiver"); // receiver对应real_name
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // 调用业务服务处理注册
        Result<String> result = userService.register(username, email, password, realName, phone, address);

        if (result.isSuccess()) {
            // 注册成功，跳转到登录页面
            response.sendRedirect("login.jsp?success=registered");
        } else {
            // 注册失败，根据错误类型重定向
            String errorCode = result.getCode();
            String errorParam = getErrorParameter(errorCode);
            response.sendRedirect("register.jsp?error=" + errorParam);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // GET请求直接转发到注册页面
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    /**
     * 将错误代码转换为JSP页面参数
     * @param errorCode 业务错误代码
     * @return 页面错误参数
     */
    private String getErrorParameter(String errorCode) {
        switch (errorCode) {
            case Constants.CODE_PARAM_ERROR:
                if (userService.login("", "").getCode().equals(Constants.CODE_PARAM_ERROR)) {
                    return "required";
                }
                return "password";
            case Constants.CODE_USER_EXISTS:
                return "username_exists";
            case Constants.CODE_EMAIL_EXISTS:
                return "email_exists";
            case Constants.CODE_ERROR:
            default:
                return "system";
        }
    }
}