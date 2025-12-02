package com.sgu.cakeshopserive.utils;

import com.mchange.v2.c3p0.ComboPooledDataSource;

public class DBUtils {
    public static ComboPooledDataSource createDataSource() {
        ComboPooledDataSource dataSource = new ComboPooledDataSource();
        dataSource.setJdbcUrl("jdbc:mysql://localhost:3306/cake_shop?serverTimezone=UTC&amp;useUnicode=true&amp;characterEncoding=utf-8");
        dataSource.setUser("root");
        dataSource.setPassword("root");
        return dataSource;
    }
}
