package com.sgu.cakeshopserive.listener;

import com.mchange.v2.c3p0.DriverManagerDataSource;
import com.mchange.v2.c3p0.PooledDataSource;
import com.sgu.cakeshopserive.utils.DBUtils;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.sql.Driver;
import java.sql.DriverManager;
import java.util.Enumeration;

/**
 * Web应用生命周期监听器
 * 负责在应用启动和关闭时管理资源的清理，防止内存泄漏
 */
@WebListener
public class ApplicationServletContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("=== 环创店应用启动 ===");
        // 应用启动时的初始化逻辑
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("=== 开始清理环创店应用资源 ===");

        // 1. 首先关闭C3P0连接池（使用DBUtils的close方法）
        try {
            System.out.println("正在关闭C3P0连接池...");
            DBUtils.close();
            System.out.println("C3P0连接池已关闭");
        } catch (Exception e) {
            System.err.println("关闭C3P0连接池时出错: " + e.getMessage());
        }

        // 2. 清理C3P0连接池（备用清理）
        cleanupC3P0ConnectionPools();

        // 3. 注销JDBC驱动
        deregisterJdbcDrivers();

        // 4. 清理MySQL连接清理线程
        cleanupMySQLConnectionCleanupThread();

        // 5. 清理其他可能的资源
        cleanupOtherResources();

        // 6. 强制垃圾回收
        System.gc();

        System.out.println("=== 环创店应用资源清理完成 ===");
    }

    /**
     * 清理C3P0连接池
     */
    private void cleanupC3P0ConnectionPools() {
        try {
            System.out.println("正在清理C3P0连接池...");

            // 这个方法主要是备用清理，实际的连接池关闭已经在DBUtils.close()中完成
            // 尝试获取当前连接池状态
            try {
                com.mchange.v2.c3p0.ComboPooledDataSource ds = (com.mchange.v2.c3p0.ComboPooledDataSource) DBUtils.getDataSource();
                if (ds != null) {
                    // 再次尝试关闭（幂等操作）
                    ds.close();
                    System.out.println("C3P0连接池备用清理完成");
                }
            } catch (Exception e) {
                System.out.println("C3P0连接池已经关闭或清理失败: " + e.getMessage());
            }

            System.out.println("C3P0连接池清理完成");
        } catch (Exception e) {
            System.err.println("清理C3P0连接池时出错: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * 注销所有JDBC驱动
     */
    private void deregisterJdbcDrivers() {
        try {
            System.out.println("正在注销JDBC驱动...");

            Enumeration<Driver> drivers = DriverManager.getDrivers();
            while (drivers.hasMoreElements()) {
                Driver driver = drivers.nextElement();
                try {
                    DriverManager.deregisterDriver(driver);
                    System.out.println("已注销驱动: " + driver.getClass().getName());
                } catch (Exception e) {
                    System.err.println("注销驱动时出错: " + driver.getClass().getName() + " - " + e.getMessage());
                }
            }

            System.out.println("JDBC驱动注销完成");
        } catch (Exception e) {
            System.err.println("注销JDBC驱动时出错: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * 清理MySQL连接清理线程
     */
    private void cleanupMySQLConnectionCleanupThread() {
        try {
            System.out.println("正在清理MySQL连接清理线程...");

            // 方法1: 尝试通过反射调用MySQL的AbandonedConnectionCleanupThread.uncheckedShutdown()
            try {
                Class<?> clazz = Class.forName("com.mysql.cj.jdbc.AbandonedConnectionCleanupThread");
                java.lang.reflect.Method method = clazz.getMethod("shutdown");
                method.invoke(null);
                System.out.println("已通过反射调用MySQL AbandonedConnectionCleanupThread.shutdown()");
            } catch (Exception e) {
                System.out.println("反射调用MySQL清理线程失败，尝试手动中断: " + e.getMessage());

                // 方法2: 手动查找并中断线程
                ThreadGroup rootGroup = Thread.currentThread().getThreadGroup();
                while (rootGroup.getParent() != null) {
                    rootGroup = rootGroup.getParent();
                }

                Thread[] threads = new Thread[rootGroup.activeCount()];
                int threadCount = rootGroup.enumerate(threads);

                for (int i = 0; i < threadCount; i++) {
                    Thread thread = threads[i];
                    if (thread != null && thread.getName().contains("mysql-cj-abandoned-connection-cleanup")) {
                        try {
                            thread.interrupt();
                            System.out.println("已中断MySQL连接清理线程: " + thread.getName());
                        } catch (Exception e1) {
                            System.err.println("中断MySQL连接清理线程时出错: " + e1.getMessage());
                        }
                    }
                }
            }

            System.out.println("MySQL连接清理线程清理完成");
        } catch (Exception e) {
            System.err.println("清理MySQL连接清理线程时出错: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * 清理其他可能的资源
     */
    private void cleanupOtherResources() {
        try {
            System.out.println("正在清理其他资源...");

            // 清理所有C3P0相关线程
            ThreadGroup rootGroup = Thread.currentThread().getThreadGroup();
            while (rootGroup.getParent() != null) {
                rootGroup = rootGroup.getParent();
            }

            Thread[] threads = new Thread[rootGroup.activeCount() * 2];
            int threadCount = rootGroup.enumerate(threads);

            for (int i = 0; i < threadCount; i++) {
                Thread thread = threads[i];
                if (thread != null) {
                    String threadName = thread.getName();
                    // 清理C3P0相关线程
                    if (threadName.contains("C3P0PooledConnectionPoolManager") ||
                        threadName.contains("ThreadPoolAsynchronousRunner")) {
                        try {
                            if (thread.isAlive()) {
                                thread.interrupt();
                                System.out.println("已中断C3P0线程: " + threadName);
                            }
                        } catch (Exception e) {
                            System.err.println("中断C3P0线程时出错: " + threadName + " - " + e.getMessage());
                        }
                    }
                }
            }

            System.out.println("其他资源清理完成");
        } catch (Exception e) {
            System.err.println("清理其他资源时出错: " + e.getMessage());
            e.printStackTrace();
        }
    }
}