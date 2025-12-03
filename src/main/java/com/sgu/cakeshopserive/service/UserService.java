package com.sgu.cakeshopserive.service;

import com.sgu.cakeshopserive.common.Constants;
import com.sgu.cakeshopserive.common.Result;
import com.sgu.cakeshopserive.model.User;
import com.sgu.cakeshopserive.utils.DBUtils;
import com.sgu.cakeshopserive.utils.PasswordUtil;

import java.sql.*;
import java.time.LocalDateTime;

/**
 * 用户业务逻辑服务类
 */
public class UserService {

    /**
     * 用户登录
     * @param username 用户名
     * @param password 密码
     * @return 登录结果
     */
    public Result<User> login(String username, String password) {
        // 参数验证
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            return Result.error("用户名和密码不能为空", Constants.CODE_PARAM_ERROR);
        }

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtils.getConnection();
            String sql = "SELECT user_id, username, password, real_name, email, phone, address, is_admin, is_active, create_time " +
                        "FROM user WHERE username = ?";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username.trim());
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setRealName(rs.getString("real_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setAddress(rs.getString("address"));
                user.setAdmin(rs.getBoolean("is_admin"));
                user.setActive(rs.getBoolean("is_active"));
                user.setCreateTime(rs.getTimestamp("create_time").toLocalDateTime());

                // 检查账户是否激活
                if (!user.isActive()) {
                    return Result.error("账户未激活", Constants.CODE_ACCOUNT_INACTIVE);
                }

                // 验证密码
                if (PasswordUtil.verifyPassword(password, user.getPassword())) {
                    // 清除密码信息，不返回给前端
                    user.setPassword("");
                    return Result.success("登录成功", user);
                } else {
                    return Result.error("密码错误", Constants.CODE_PASSWORD_ERROR);
                }
            } else {
                return Result.error("用户不存在", Constants.CODE_USER_NOT_FOUND);
            }

        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("系统错误：" + e.getMessage(), Constants.CODE_ERROR);
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 用户注册
     * @param username 用户名
     * @param email 邮箱
     * @param password 密码
     * @param realName 真实姓名
     * @param phone 电话
     * @param address 地址
     * @return 注册结果
     */
    public Result<String> register(String username, String email, String password,
                                  String realName, String phone, String address) {
        // 参数验证
        if (username == null || username.trim().isEmpty()) {
            return Result.error("用户名不能为空", Constants.CODE_PARAM_ERROR);
        }
        if (email == null || email.trim().isEmpty()) {
            return Result.error("邮箱不能为空", Constants.CODE_PARAM_ERROR);
        }
        if (password == null || password.trim().isEmpty()) {
            return Result.error("密码不能为空", Constants.CODE_PARAM_ERROR);
        }

        // 密码长度验证
        if (password.length() < Constants.PASSWORD_MIN_LENGTH) {
            return Result.error("密码长度至少" + Constants.PASSWORD_MIN_LENGTH + "位", Constants.CODE_PARAM_ERROR);
        }

        // 邮箱格式验证
        if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            return Result.error("邮箱格式不正确", Constants.CODE_PARAM_ERROR);
        }

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtils.getConnection();

            // 检查用户名是否已存在
            pstmt = conn.prepareStatement("SELECT user_id FROM user WHERE username = ?");
            pstmt.setString(1, username.trim());
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                rs.close();
                pstmt.close();
                return Result.error("用户名已存在", Constants.CODE_USER_EXISTS);
            }
            rs.close();
            pstmt.close();

            // 检查邮箱是否已存在
            pstmt = conn.prepareStatement("SELECT user_id FROM user WHERE email = ?");
            pstmt.setString(1, email.trim());
            rs = pstmt.executeQuery();

            if (rs.next()) {
                rs.close();
                pstmt.close();
                return Result.error("邮箱已存在", Constants.CODE_EMAIL_EXISTS);
            }
            rs.close();
            pstmt.close();

            // 插入新用户
            String sql = "INSERT INTO user (username, password, real_name, email, phone, address, is_admin, is_active, create_time) " +
                        "VALUES (?, ?, ?, ?, ?, ?, 0, 1, NOW())";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username.trim());
            pstmt.setString(2, PasswordUtil.encryptPassword(password));
            pstmt.setString(3, realName != null ? realName.trim() : "");
            pstmt.setString(4, email.trim());
            pstmt.setString(5, phone != null ? phone.trim() : "");
            pstmt.setString(6, address != null ? address.trim() : "");

            int result = pstmt.executeUpdate();

            if (result > 0) {
                return Result.success("注册成功", "registered", "REGISTER_SUCCESS");
            } else {
                return Result.error("注册失败，请稍后重试", Constants.CODE_ERROR);
            }

        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("系统错误：" + e.getMessage(), Constants.CODE_ERROR);
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 根据用户ID获取用户信息
     * @param userId 用户ID
     * @return 用户信息
     */
    public Result<User> getUserById(int userId) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtils.getConnection();
            String sql = "SELECT user_id, username, real_name, email, phone, address, is_admin, is_active, create_time " +
                        "FROM user WHERE user_id = ?";

            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setRealName(rs.getString("real_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setAddress(rs.getString("address"));
                user.setAdmin(rs.getBoolean("is_admin"));
                user.setActive(rs.getBoolean("is_active"));
                user.setCreateTime(rs.getTimestamp("create_time").toLocalDateTime());

                return Result.success("获取用户信息成功", user);
            } else {
                return Result.error("用户不存在", Constants.CODE_USER_NOT_FOUND);
            }

        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("系统错误：" + e.getMessage(), Constants.CODE_ERROR);
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 更新用户信息
     * @param user 用户信息
     * @return 更新结果
     */
    public Result<String> updateUser(User user) {
        if (user == null || user.getUserId() <= 0) {
            return Result.error("用户信息无效", Constants.CODE_PARAM_ERROR);
        }

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtils.getConnection();
            String sql = "UPDATE user SET real_name = ?, email = ?, phone = ?, address = ?, update_time = NOW() " +
                        "WHERE user_id = ?";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, user.getRealName());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getPhone());
            pstmt.setString(4, user.getAddress());
            pstmt.setInt(5, user.getUserId());

            int result = pstmt.executeUpdate();

            if (result > 0) {
                return Result.success("更新用户信息成功", "updated", "UPDATE_SUCCESS");
            } else {
                return Result.error("更新用户信息失败", Constants.CODE_ERROR);
            }

        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("系统错误：" + e.getMessage(), Constants.CODE_ERROR);
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}