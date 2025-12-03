package com.sgu.cakeshopserive.filter;

import com.sgu.cakeshopserive.dao.GoodsDao;
import com.sgu.cakeshopserive.dao.TypeDao;
import com.sgu.cakeshopserive.model.Goods;
import com.sgu.cakeshopserive.model.Type;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class IndexFilter implements Filter {

    private GoodsDao goodsDao;
    private TypeDao typeDao;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        goodsDao = new GoodsDao();
        // 创建类型映射
        if (typeDao == null) {
            typeDao = new TypeDao();
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String pathInfo;

        // 处理路径信息，避免空指针异常
        if (contextPath != null && requestURI.startsWith(contextPath)) {
            pathInfo = requestURI.substring(contextPath.length());
        } else {
            pathInfo = requestURI;
        }

        // 确保pathInfo以/开头
        if (!pathInfo.startsWith("/")) {
            pathInfo = "/" + pathInfo;
        }

        // 如果访问首页，则加载商品数据
        if (pathInfo.equals("/") || pathInfo.equals("/index.jsp")) {
            try {
                // 获取所有商品
                List<Goods> allGoods = goodsDao.getAllGoods();

                // 获取所有类型并创建typeMap
                List<Type> allTypes = typeDao.getAllTypes();
                Map<Integer, String> typeMap = new HashMap<>();
                for (Type type : allTypes) {
                    typeMap.put(type.getTypeId(), type.getTypeName());
                }

                // 为了兼容现有的JSP代码，设置简单的商品列表
                List<Goods> goodsList = allGoods;
                httpRequest.setAttribute("goodsList", goodsList);
                httpRequest.setAttribute("typeMap", typeMap);

                // 获取推荐商品 - 如果推荐表为空，则从所有商品中获取
                List<Goods> hotGoods = goodsDao.getHotGoods(6);
                if (hotGoods == null || hotGoods.isEmpty()) {
                    hotGoods = allGoods.size() > 6 ? allGoods.subList(0, 6) : allGoods;
                }

                List<Goods> newGoods = goodsDao.getNewGoods(6);
                if (newGoods == null || newGoods.isEmpty()) {
                    newGoods = allGoods.size() > 6 ? allGoods.subList(0, 6) : allGoods;
                }

                List<Goods> bannerGoods = goodsDao.getBannerGoods(3);
                if (bannerGoods == null || bannerGoods.isEmpty()) {
                    bannerGoods = allGoods.size() > 3 ? allGoods.subList(0, 3) : allGoods;
                }

                // 将商品数据设置到request中
                httpRequest.setAttribute("allGoods", allGoods);
                httpRequest.setAttribute("hotGoods", hotGoods);
                httpRequest.setAttribute("newGoods", newGoods);
                httpRequest.setAttribute("bannerGoods", bannerGoods);

            } catch (Exception e) {
                // 记录错误但不阻止页面访问
                System.err.println("IndexFilter加载商品数据失败: " + e.getMessage());
                e.printStackTrace();

                // 设置空列表和空Map避免JSP页面出现空指针异常
                httpRequest.setAttribute("goodsList", new ArrayList<Goods>());
                httpRequest.setAttribute("typeMap", new HashMap<Integer, String>());
                httpRequest.setAttribute("allGoods", new ArrayList<Goods>());
                httpRequest.setAttribute("hotGoods", new ArrayList<Goods>());
                httpRequest.setAttribute("newGoods", new ArrayList<Goods>());
                httpRequest.setAttribute("bannerGoods", new ArrayList<Goods>());
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // 清理资源
    }
}