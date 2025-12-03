package com.sgu.cakeshopserive.utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.io.IOException;

/**
 * 密码加密工具类
 * 提供密码加密和验证功能
 */
public class PasswordUtil {

    /**
     * 密码加密方法（使用MD5）
     * @param password 原始密码
     * @return 加密后的密码字符串
     */
    public static String encryptPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] bytes = md.digest(password.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : bytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException | IOException e) {
            throw new RuntimeException("密码加密失败", e);
        }
    }

    /**
     * 验证密码是否正确
     * @param inputPassword 用户输入的密码
     * @param encryptedPassword 数据库存储的加密密码
     * @return 密码是否匹配
     */
    public static boolean verifyPassword(String inputPassword, String encryptedPassword) {
        return encryptPassword(inputPassword).equals(encryptedPassword);
    }

    /**
     * 生成随机盐值
     * @return 随机盐值字符串
     */
    public static String generateSalt() {
        return System.currentTimeMillis() + "" + System.nanoTime();
    }

    /**
     * 使用盐值加密密码
     * @param password 原始密码
     * @param salt 盐值
     * @return 加密后的密码字符串
     */
    public static String encryptPasswordWithSalt(String password, String salt) {
        return encryptPassword(password + salt);
    }
}