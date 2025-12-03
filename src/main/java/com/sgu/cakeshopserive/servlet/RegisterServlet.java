package com.sgu.cakeshopserive.servlet;

import java.io.*;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "registerServlet", value = "/register")
public class RegisterServlet extends HttpServlet {

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

        // 验证必填字段
        if (username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {

            response.sendRedirect("register.jsp?error=required");
            return;
        }

        // 验证密码长度
        if (password.length() < 6) {
            response.sendRedirect("register.jsp?error=password");
            return;
        }

        // 验证邮箱格式
        if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            response.sendRedirect("register.jsp?error=email");
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // 使用DBUtils获取数据库连接
            conn = com.sgu.cakeshopserive.utils.DBUtils.getConnection();

            // 检查用户名是否已存在
            pstmt = conn.prepareStatement("SELECT user_id FROM user WHERE username = ?");
            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                // 用户名已存在
                response.sendRedirect("register.jsp?error=username_exists");
                rs.close();
                pstmt.close();
                return;
            }
            rs.close();
            pstmt.close();

            // 检查邮箱是否已存在
            pstmt = conn.prepareStatement("SELECT user_id FROM user WHERE email = ?");
            pstmt.setString(1, email);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                // 邮箱已存在
                response.sendRedirect("register.jsp?error=email_exists");
                rs.close();
                pstmt.close();
                return;
            }
            rs.close();
            pstmt.close();

            // 插入新用户
            String sql = "INSERT INTO user (username, password, real_name, email, phone, address, is_admin, is_active, create_time) " +
                        "VALUES (?, ?, ?, ?, ?, ?, 0, 1, NOW())";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, com.sgu.cakeshopserive.utils.PasswordUtil.encryptPassword(password)); // 使用密码加密
            pstmt.setString(3, realName != null ? realName : ""); // receiver对应real_name字段
            pstmt.setString(4, email);
            pstmt.setString(5, phone != null ? phone : "");
            pstmt.setString(6, address != null ? address : "");

            int result = pstmt.executeUpdate();

            if (result > 0) {
                // 注册成功，跳转到登录页面
                response.sendRedirect("login.jsp?success=registered");
            } else {
                response.sendRedirect("register.jsp?error=failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=system");
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
        // GET请求直接转发到注册页面
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }
}