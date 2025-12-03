package com.sgu.cakeshopserive.utils;

import com.mchange.v2.c3p0.ComboPooledDataSource;

import java.sql.Connection;
import java.sql.SQLException;

public class DBUtils {
    // 使用单例模式确保只有一个数据源实例
    private static ComboPooledDataSource dataSource;

    static {
        try {
            // 显式加载MySQL驱动类
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL驱动加载失败: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // 使用双重检查锁定确保线程安全的单例
    public static ComboPooledDataSource getDataSource() {
        if (dataSource == null) {
            synchronized (DBUtils.class) {
                if (dataSource == null) {
                    dataSource = createDataSource();
                }
            }
        }
        return dataSource;
    }

    private static ComboPooledDataSource createDataSource() {
        ComboPooledDataSource ds = new ComboPooledDataSource();
        try {
            ds.setDriverClass("com.mysql.cj.jdbc.Driver");
            ds.setJdbcUrl("jdbc:mysql://localhost:3306/cake_shop?serverTimezone=UTC&useUnicode=true&characterEncoding=utf-8&autoReconnect=true&useSSL=false");
            ds.setUser("root");
            ds.setPassword("root");

            // 优化的连接池配置
            ds.setInitialPoolSize(3);           // 初始连接数（减少）
            ds.setMinPoolSize(3);               // 最小连接数（减少）
            ds.setAcquireIncrement(2);          // 连接增长数（减少）
            ds.setMaxPoolSize(10);              // 最大连接数（减少）
            ds.setMaxIdleTime(180);             // 最大空闲时间(秒) - 3分钟
            ds.setMaxConnectionAge(600);        // 连接最大存活时间(秒) - 10分钟
            ds.setCheckoutTimeout(30000);       // 获取连接超时时间(毫秒) - 30秒
            ds.setIdleConnectionTestPeriod(60); // 空闲连接测试周期(秒)
            ds.setTestConnectionOnCheckout(false); // 获取连接时不测试（提高性能）
            ds.setTestConnectionOnCheckin(true);   // 归还连接时测试
            ds.setPreferredTestQuery("SELECT 1");  // 测试SQL
            ds.setAutoCommitOnClose(false);        // 关闭时不自动提交

            // 连接泄露检测
            ds.setUnreturnedConnectionTimeout(300); // 未归还连接超时(秒) - 5分钟
            ds.setDebugUnreturnedConnectionStackTraces(true); // 记录未归还连接的堆栈

            // 语句池配置
            ds.setMaxStatements(50);            // 最大预处理语句数
            ds.setMaxStatementsPerConnection(20); // 每个连接最大预处理语句数

        } catch (Exception e) {
            System.err.println("数据源配置失败: " + e.getMessage());
            e.printStackTrace();
        }
        return ds;
    }

    // 获取连接的便捷方法
    public static Connection getConnection() throws SQLException {
        return getDataSource().getConnection();
    }

    // 关闭连接池的方法（应用关闭时调用）
    public static void close() {
        if (dataSource != null) {
            dataSource.close();
        }
    }
}
