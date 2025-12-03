package com.sgu.cakeshopserive.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "logoutServlet", value = "/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 获取当前会话
        HttpSession session = request.getSession(false);

        if (session != null) {
            // 使会话失效，删除所有session属性
            session.invalidate();
        }

        // 清除可能的cookie
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                // 删除与登录相关的cookie
                if (cookie.getName().equals("JSESSIONID") ||
                    cookie.getName().equals("username") ||
                    cookie.getName().equals("rememberMe")) {
                    cookie.setValue("");
                    cookie.setMaxAge(0);
                    cookie.setPath("/");
                    response.addCookie(cookie);
                }
            }
    }

        // 设置响应内容类型
        response.setContentType("text/html;charset=UTF-8");

        // 重定向到登录页面，并添加退出成功参数
        response.sendRedirect("login.jsp?success=logout");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 对于退出功能，GET和POST处理相同
        doGet(request, response);
    }
}