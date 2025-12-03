package com.sgu.cakeshopserive.servlet;

import java.io.*;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "loginServlet", value = "/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // 获取表单参数
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 验证必填字段
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {

            response.sendRedirect("login.jsp?error=required");
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // 使用DBUtils获取数据库连接
            conn = com.sgu.cakeshopserive.utils.DBUtils.getConnection();

            // 查询用户信息
            String sql = "SELECT user_id, username, password, real_name, email, phone, address, is_admin, is_active " +
                        "FROM user WHERE username = ?";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                // 验证密码
                String storedPassword = rs.getString("password");
                boolean isActive = rs.getBoolean("is_active");

                if (!isActive) {
                    // 账户未激活
                    response.sendRedirect("login.jsp?error=account_inactive");
                    rs.close();
                    pstmt.close();
                    return;
                }

                // 使用PasswordUtil验证密码
                if (com.sgu.cakeshopserive.utils.PasswordUtil.verifyPassword(password, storedPassword)) {
                    // 登录成功，创建会话
                    HttpSession session = request.getSession();

                    // 存储用户信息到会话中
                    session.setAttribute("user_id", rs.getInt("user_id"));
                    session.setAttribute("username", rs.getString("username"));
                    session.setAttribute("real_name", rs.getString("real_name"));
                    session.setAttribute("email", rs.getString("email"));
                    session.setAttribute("phone", rs.getString("phone"));
                    session.setAttribute("address", rs.getString("address"));
                    session.setAttribute("is_admin", rs.getBoolean("is_admin"));
                    session.setAttribute("is_logged_in", true);

                    // 设置会话超时时间（30分钟）
                    session.setMaxInactiveInterval(30 * 60);

                    rs.close();
                    pstmt.close();

                    // 登录成功，跳转到首页
                    response.sendRedirect("index.jsp?success=login");
                } else {
                    // 密码错误
                    response.sendRedirect("login.jsp?error=invalid_credentials");
                    rs.close();
                    pstmt.close();
                }
            } else {
                // 用户不存在
                response.sendRedirect("login.jsp?error=not_found");
                rs.close();
                pstmt.close();
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=system");
        } finally {
            // 关闭资源
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // GET请求直接转发到登录页面
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}