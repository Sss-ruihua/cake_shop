package com.sgu.cakeshopserive.servlet;

import com.sgu.cakeshopserive.dao.GoodsDao;
import com.sgu.cakeshopserive.dao.TypeDao;
import com.sgu.cakeshopserive.model.Goods;
import com.sgu.cakeshopserive.model.Type;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "GoodsServlet", urlPatterns = {"/goods", "/index"})
public class GoodsServlet extends HttpServlet {
    private GoodsDao goodsDao = new GoodsDao();
    private TypeDao typeDao = new TypeDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    listGoods(request, response);
                    break;
                case "detail":
                    showGoodsDetail(request, response);
                    break;
                case "search":
                    searchGoods(request, response);
                    break;
                case "type":
                    listGoodsByType(request, response);
                    break;
                default:
                    listGoods(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "获取商品信息失败");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    private void listGoods(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 获取所有商品
        List<Goods> allGoods = goodsDao.getAllGoods();

        // 获取推荐商品
        List<Goods> hotGoods = goodsDao.getHotGoods(6);
        List<Goods> newGoods = goodsDao.getNewGoods(6);
        List<Goods> bannerGoods = goodsDao.getBannerGoods(3);

        // 获取所有分类
        List<Type> types = typeDao.getAllTypes();

        request.setAttribute("goodsList", allGoods);
        request.setAttribute("hotGoods", hotGoods);
        request.setAttribute("newGoods", newGoods);
        request.setAttribute("bannerGoods", bannerGoods);
        request.setAttribute("types", types);

        // 创建类型映射，方便在JSP中使用
        java.util.Map<Integer, String> typeMap = new java.util.HashMap<>();
        for (Type type : types) {
            typeMap.put(type.getTypeId(), type.getTypeName());
        }
        request.setAttribute("typeMap", typeMap);

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    private void showGoodsDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int goodsId = Integer.parseInt(request.getParameter("goodsId"));
        Goods goods = goodsDao.getGoodsById(goodsId);

        if (goods == null) {
            request.setAttribute("error", "商品不存在");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        request.setAttribute("goods", goods);
        request.getRequestDispatcher("/goods-detail.jsp").forward(request, response);
    }

    private void searchGoods(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        if (keyword == null || keyword.trim().isEmpty()) {
            listGoods(request, response);
            return;
        }

        List<Goods> searchResults = goodsDao.searchGoods(keyword.trim());
        List<Type> types = typeDao.getAllTypes();

        request.setAttribute("searchResults", searchResults);
        request.setAttribute("keyword", keyword);
        request.setAttribute("types", types);

        request.getRequestDispatcher("/search.jsp").forward(request, response);
    }

    private void listGoodsByType(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int typeId = Integer.parseInt(request.getParameter("typeId"));
        Type type = typeDao.getTypeById(typeId);

        if (type == null) {
            request.setAttribute("error", "分类不存在");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        List<Goods> goodsList = goodsDao.getGoodsByTypeId(typeId);
        List<Type> types = typeDao.getAllTypes();

        request.setAttribute("goodsList", goodsList);
        request.setAttribute("currentType", type);
        request.setAttribute("types", types);

        request.getRequestDispatcher("/category.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}