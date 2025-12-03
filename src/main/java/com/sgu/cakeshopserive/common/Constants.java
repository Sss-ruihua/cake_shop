package com.sgu.cakeshopserive.common;

/**
 * 系统常量定义
 */
public class Constants {

    // 响应状态码
    public static final String CODE_SUCCESS = "SUCCESS";
    public static final String CODE_ERROR = "ERROR";
    public static final String CODE_PARAM_ERROR = "PARAM_ERROR";
    public static final String CODE_USER_NOT_FOUND = "USER_NOT_FOUND";
    public static final String CODE_PASSWORD_ERROR = "PASSWORD_ERROR";
    public static final String CODE_USER_EXISTS = "USER_EXISTS";
    public static final String CODE_EMAIL_EXISTS = "EMAIL_EXISTS";
    public static final String CODE_ACCOUNT_INACTIVE = "ACCOUNT_INACTIVE";
    public static final String CODE_GOODS_NOT_FOUND = "GOODS_NOT_FOUND";
    public static final String CODE_TYPE_NOT_FOUND = "TYPE_NOT_FOUND";
    public static final String CODE_INSUFFICIENT_STOCK = "INSUFFICIENT_STOCK";

    // 错误消息
    public static final String MSG_SUCCESS = "操作成功";
    public static final String MSG_PARAM_ERROR = "参数错误";
    public static final String MSG_USER_NOT_FOUND = "用户不存在";
    public static final String MSG_PASSWORD_ERROR = "密码错误";
    public static final String MSG_USER_EXISTS = "用户名已存在";
    public static final String MSG_EMAIL_EXISTS = "邮箱已存在";
    public static final String MSG_ACCOUNT_INACTIVE = "账户未激活";
    public static final String MSG_GOODS_NOT_FOUND = "商品不存在";
    public static final String MSG_TYPE_NOT_FOUND = "分类不存在";
    public static final String MSG_INSUFFICIENT_STOCK = "库存不足";
    public static final String MSG_SYSTEM_ERROR = "系统错误";

    // 用户相关常量
    public static final String SESSION_USER_ID = "user_id";
    public static final String SESSION_USERNAME = "username";
    public static final String SESSION_REAL_NAME = "real_name";
    public static final String SESSION_EMAIL = "email";
    public static final String SESSION_PHONE = "phone";
    public static final String SESSION_ADDRESS = "address";
    public static final String SESSION_IS_ADMIN = "is_admin";
    public static final String SESSION_IS_LOGGED_IN = "is_logged_in";

    // 购物车相关常量
    public static final String SESSION_CART = "cart";
    public static final String SESSION_CART_COUNT = "cart_count";
    public static final String SESSION_CART_TOTAL = "cart_total";

    // 会话超时时间（分钟）
    public static final int SESSION_TIMEOUT = 30;

    // 密码长度要求
    public static final int PASSWORD_MIN_LENGTH = 6;

    // 数据库表名
    public static final String TABLE_USER = "user";
    public static final String TABLE_GOODS = "goods";
    public static final String TABLE_TYPE = "type";
    public static final String TABLE_RECOMMEND = "recommend";

    // 私有构造方法，防止实例化
    private Constants() {}
}