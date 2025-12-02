package com.sgu.cakeshopserive.utils;

import com.mchange.v2.c3p0.ComboPooledDataSource;

public class DBUtils {
    static {
        try {
            // 显式加载MySQL驱动类
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL驱动加载失败: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static ComboPooledDataSource createDataSource() {
        ComboPooledDataSource dataSource = new ComboPooledDataSource();
        try {
            dataSource.setDriverClass("com.mysql.cj.jdbc.Driver");
            dataSource.setJdbcUrl("jdbc:mysql://localhost:3306/cake_shop?serverTimezone=UTC&useUnicode=true&characterEncoding=utf-8");
            dataSource.setUser("root");
            dataSource.setPassword("root");

            // 连接池配置
            dataSource.setMinPoolSize(5);
            dataSource.setAcquireIncrement(5);
            dataSource.setMaxPoolSize(20);
            dataSource.setMaxIdleTime(300);
        } catch (Exception e) {
            System.err.println("数据源配置失败: " + e.getMessage());
            e.printStackTrace();
        }
        return dataSource;
    }
}
