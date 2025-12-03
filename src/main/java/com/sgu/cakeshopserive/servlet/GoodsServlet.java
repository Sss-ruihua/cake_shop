package com.sgu.cakeshopserive.servlet;

import com.sgu.cakeshopserive.common.Constants;
import com.sgu.cakeshopserive.common.Result;
import com.sgu.cakeshopserive.model.Goods;
import com.sgu.cakeshopserive.service.GoodsService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * 商品控制器
 * 职责：处理HTTP请求，调用业务服务，返回响应
 */
@WebServlet(name = "GoodsServlet", urlPatterns = {"/goods", "/index"})
public class GoodsServlet extends HttpServlet {
    private GoodsService goodsService = new GoodsService();

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
            request.setAttribute("error", "获取商品信息失败：" + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    /**
     * 获取首页推荐商品
     */
    private void listGoods(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Result<GoodsService.IndexRecommendations> result = goodsService.getIndexRecommendations();

        if (result.isSuccess()) {
            GoodsService.IndexRecommendations recommendations = result.getData();
            request.setAttribute("goodsList", goodsService.getAllGoods().getData());
            request.setAttribute("hotGoods", recommendations.getHotGoods());
            request.setAttribute("newGoods", recommendations.getNewGoods());
            request.setAttribute("bannerGoods", recommendations.getBannerGoods());
            request.setAttribute("types", recommendations.getTypes());
            request.setAttribute("typeMap", recommendations.getTypeMap());

            request.getRequestDispatcher("/index.jsp").forward(request, response);
        } else {
            request.setAttribute("error", result.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    /**
     * 显示商品详情
     */
    private void showGoodsDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int goodsId = Integer.parseInt(request.getParameter("goodsId"));
            Result<Goods> result = goodsService.getGoodsById(goodsId);

            if (result.isSuccess()) {
                request.setAttribute("goods", result.getData());
                request.getRequestDispatcher("/goods-detail.jsp").forward(request, response);
            } else {
                request.setAttribute("error", result.getMessage());
                request.getRequestDispatcher("/error.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "商品ID格式错误");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    /**
     * 搜索商品
     */
    private void searchGoods(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        if (keyword == null || keyword.trim().isEmpty()) {
            listGoods(request, response);
            return;
        }

        Result<List<Goods>> result = goodsService.searchGoods(keyword.trim());

        if (result.isSuccess()) {
            // 同时获取分类信息用于显示
            Result<GoodsService.IndexRecommendations> recommendationsResult = goodsService.getIndexRecommendations();
            List<com.sgu.cakeshopserive.model.Type> types = recommendationsResult.isSuccess() ?
                recommendationsResult.getData().getTypes() : null;

            request.setAttribute("searchResults", result.getData());
            request.setAttribute("keyword", keyword);
            request.setAttribute("types", types);

            request.getRequestDispatcher("/search.jsp").forward(request, response);
        } else {
            request.setAttribute("error", result.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    /**
     * 根据分类显示商品
     */
    private void listGoodsByType(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int typeId = Integer.parseInt(request.getParameter("typeId"));
            Result<List<Goods>> result = goodsService.getGoodsByType(typeId);

            if (result.isSuccess()) {
                // 同时获取所有分类信息
                Result<GoodsService.IndexRecommendations> recommendationsResult = goodsService.getIndexRecommendations();
                List<com.sgu.cakeshopserive.model.Type> types = recommendationsResult.isSuccess() ?
                    recommendationsResult.getData().getTypes() : null;

                // 获取当前分类信息
                com.sgu.cakeshopserive.model.Type currentType = null;
                if (types != null) {
                    for (com.sgu.cakeshopserive.model.Type type : types) {
                        if (type.getTypeId() == typeId) {
                            currentType = type;
                            break;
                        }
                    }
                }

                request.setAttribute("goodsList", result.getData());
                request.setAttribute("currentType", currentType);
                request.setAttribute("types", types);

                request.getRequestDispatcher("/category.jsp").forward(request, response);
            } else {
                request.setAttribute("error", result.getMessage());
                request.getRequestDispatcher("/error.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "分类ID格式错误");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}