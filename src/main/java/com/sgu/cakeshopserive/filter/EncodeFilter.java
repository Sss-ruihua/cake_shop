package com.sgu.cakeshopserive.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import java.io.IOException;

@WebFilter(filterName = "EncodeFilter", urlPatterns = "/*")
public class EncodeFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 初始化过滤器，如果需要的话
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp,
                         FilterChain chain) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        // 只设置字符编码，不设置内容类型，让各个Servlet自己设置
        resp.setCharacterEncoding("UTF-8");
        chain.doFilter(req, resp);
    }

    @Override
    public void destroy() {
        // 销毁过滤器，如果需要的话
    }
}

