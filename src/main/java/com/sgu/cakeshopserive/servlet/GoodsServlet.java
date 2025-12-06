package com.sgu.cakeshopserive.servlet;

import com.sgu.cakeshopserive.common.Constants;
import com.sgu.cakeshopserive.common.Result;
import com.sgu.cakeshopserive.model.Goods;
import com.sgu.cakeshopserive.model.PageResult;
import com.sgu.cakeshopserive.service.GoodsService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

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
                case "hot":
                    showHotSales(request, response);
                    break;
                case "new":
                    showNewArrivals(request, response);
                    break;
                // AJAX 分页接口
                case "ajaxList":
                    ajaxListGoods(request, response);
                    break;
                case "ajaxSearch":
                    ajaxSearchGoods(request, response);
                    break;
                case "ajaxType":
                    ajaxListGoodsByType(request, response);
                    break;
                case "ajaxSuggest":
                    ajaxGetSearchSuggestions(request, response);
                    break;
                case "ajaxHot":
                    ajaxGetHotGoods(request, response);
                    break;
                case "ajaxNew":
                    ajaxGetNewGoods(request, response);
                    break;
                default:
                    listGoods(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            // 检查是否是AJAX请求
            String requestedWith = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(requestedWith)) {
                // AJAX请求返回JSON错误
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"success\":false,\"message\":\"获取商品信息失败：" + e.getMessage().replace("\"", "\\\"") + "\"}");
            } else {
                // 普通请求转发到错误页面
                request.setAttribute("error", "获取商品信息失败：" + e.getMessage());
                request.getRequestDispatcher("/error.jsp").forward(request, response);
            }
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
            // 不再一次性加载所有商品，让前端懒加载处理
            // request.setAttribute("goodsList", goodsService.getAllGoods().getData());
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

                // 计算购物车数量
                HttpSession session = request.getSession();
                @SuppressWarnings("unchecked")
                Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
                int cartCount = 0;
                if (cart != null) {
                    cartCount = cart.values().stream().mapToInt(Integer::intValue).sum();
                }
                request.setAttribute("cartCount", cartCount);

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

        // 不再一次性搜索所有商品，让前端懒加载处理
        // Result<List<Goods>> result = goodsService.searchGoods(keyword.trim());

        // 获取分类信息用于显示
        Result<GoodsService.IndexRecommendations> recommendationsResult = goodsService.getIndexRecommendations();
        List<com.sgu.cakeshopserive.model.Type> types = recommendationsResult.isSuccess() ?
            recommendationsResult.getData().getTypes() : null;

        // request.setAttribute("searchResults", result.getData());
        request.setAttribute("keyword", keyword);
        request.setAttribute("types", types);

        request.getRequestDispatcher("/search.jsp").forward(request, response);
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

                // 不再一次性加载所有商品，让前端懒加载处理
                // request.setAttribute("goodsList", result.getData());
                request.setAttribute("currentType", currentType);
                request.setAttribute("types", types);

                // 计算购物车数量
                HttpSession session = request.getSession();
                @SuppressWarnings("unchecked")
                Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
                int cartCount = 0;
                if (cart != null) {
                    cartCount = cart.values().stream().mapToInt(Integer::intValue).sum();
                }
                request.setAttribute("cartCount", cartCount);

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

      // ========== AJAX 分页接口 ==========

    /**
     * AJAX分页获取商品列表（首页懒加载）
     */
    private void ajaxListGoods(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // 获取分页参数
            int page = Integer.parseInt(request.getParameter("page"));
            int pageSize = Integer.parseInt(request.getParameter("pageSize"));

            // 调用业务服务获取分页数据
            Result<PageResult<Goods>> result = goodsService.getAllGoodsPaginated(page, pageSize);

            if (result.isSuccess()) {
                PageResult<Goods> pageResult = result.getData();
                String jsonResponse = convertToJson(pageResult);
                out.write(jsonResponse);
            } else {
                String errorResponse = String.format(
                    "{\"success\":false,\"message\":\"%s\"}",
                    result.getMessage().replace("\"", "\\\"")
                );
                out.write(errorResponse);
            }

        } catch (NumberFormatException e) {
            String errorResponse = "{\"success\":false,\"message\":\"分页参数格式错误\"}";
            out.write(errorResponse);
        } catch (Exception e) {
            e.printStackTrace();
            String errorResponse = String.format(
                "{\"success\":false,\"message\":\"获取商品失败：%s\"}",
                e.getMessage().replace("\"", "\\\"")
            );
            out.write(errorResponse);
        }
    }

    /**
     * AJAX分页搜索商品
     */
    private void ajaxSearchGoods(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            String keyword = request.getParameter("keyword");
            int page = Integer.parseInt(request.getParameter("page"));
            int pageSize = Integer.parseInt(request.getParameter("pageSize"));

            if (keyword == null || keyword.trim().isEmpty()) {
                String errorResponse = "{\"success\":false,\"message\":\"搜索关键词不能为空\"}";
                out.write(errorResponse);
                return;
            }

            // 调用业务服务获取分页数据
            Result<PageResult<Goods>> result = goodsService.searchGoodsPaginated(keyword.trim(), page, pageSize);

            if (result.isSuccess()) {
                PageResult<Goods> pageResult = result.getData();
                String jsonResponse = convertToJson(pageResult);
                out.write(jsonResponse);
            } else {
                String errorResponse = String.format(
                    "{\"success\":false,\"message\":\"%s\"}",
                    result.getMessage().replace("\"", "\\\"")
                );
                out.write(errorResponse);
            }

        } catch (NumberFormatException e) {
            String errorResponse = "{\"success\":false,\"message\":\"分页参数格式错误\"}";
            out.write(errorResponse);
        } catch (Exception e) {
            e.printStackTrace();
            String errorResponse = String.format(
                "{\"success\":false,\"message\":\"搜索商品失败：%s\"}",
                e.getMessage().replace("\"", "\\\"")
            );
            out.write(errorResponse);
        }
    }

    /**
     * AJAX分页获取分类商品
     */
    private void ajaxListGoodsByType(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            int typeId = Integer.parseInt(request.getParameter("typeId"));
            int page = Integer.parseInt(request.getParameter("page"));
            int pageSize = Integer.parseInt(request.getParameter("pageSize"));

            // 调用业务服务获取分页数据
            Result<PageResult<Goods>> result = goodsService.getGoodsByTypePaginated(typeId, page, pageSize);

            if (result.isSuccess()) {
                PageResult<Goods> pageResult = result.getData();
                String jsonResponse = convertToJson(pageResult);
                out.write(jsonResponse);
            } else {
                String errorResponse = String.format(
                    "{\"success\":false,\"message\":\"%s\"}",
                    result.getMessage().replace("\"", "\\\"")
                );
                out.write(errorResponse);
            }

        } catch (NumberFormatException e) {
            String errorResponse = "{\"success\":false,\"message\":\"参数格式错误\"}";
            out.write(errorResponse);
        } catch (Exception e) {
            e.printStackTrace();
            String errorResponse = String.format(
                "{\"success\":false,\"message\":\"获取分类商品失败：%s\"}",
                e.getMessage().replace("\"", "\\\"")
            );
            out.write(errorResponse);
        }
    }

    /**
     * AJAX获取搜索建议
     */
    private void ajaxGetSearchSuggestions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            String keyword = request.getParameter("keyword");
            if (keyword == null || keyword.trim().isEmpty()) {
                String errorResponse = "{\"success\":false,\"message\":\"搜索关键词不能为空\"}";
                out.write(errorResponse);
                return;
            }

            // 获取搜索建议
            Result<List<String>> result = goodsService.getSearchSuggestions(keyword.trim());

            if (result.isSuccess()) {
                String jsonResponse = String.format(
                    "{\"success\":true,\"data\":[%s]}",
                    result.getData().stream()
                        .map(suggestion -> "\"" + escapeJson(suggestion) + "\"")
                        .collect(java.util.stream.Collectors.joining(","))
                );
                out.write(jsonResponse);
            } else {
                String errorResponse = String.format(
                    "{\"success\":false,\"message\":\"%s\"}",
                    result.getMessage().replace("\"", "\\\"")
                );
                out.write(errorResponse);
            }

        } catch (Exception e) {
            e.printStackTrace();
            String errorResponse = String.format(
                "{\"success\":false,\"message\":\"获取搜索建议失败：%s\"}",
                e.getMessage().replace("\"", "\\\"")
            );
            out.write(errorResponse);
        }
    }

    /**
     * 将PageResult转换为JSON字符串
     * 简单的JSON转换，避免引入第三方依赖
     */
    private String convertToJson(PageResult<Goods> pageResult) {
        StringBuilder json = new StringBuilder();
        json.append("{\"success\":true,\"data\":{");
        json.append("\"currentPage\":").append(pageResult.getCurrentPage()).append(",");
        json.append("\"pageSize\":").append(pageResult.getPageSize()).append(",");
        json.append("\"totalCount\":").append(pageResult.getTotalCount()).append(",");
        json.append("\"totalPages\":").append(pageResult.getTotalPages()).append(",");
        json.append("\"hasMore\":").append(pageResult.isHasMore()).append(",");
        json.append("\"isFirst\":").append(pageResult.isFirst()).append(",");
        json.append("\"isLast\":").append(pageResult.isLast()).append(",");
        json.append("\"goods\":[");

        List<Goods> goodsList = pageResult.getData();
        for (int i = 0; i < goodsList.size(); i++) {
            Goods goods = goodsList.get(i);
            json.append("{");
            json.append("\"goodsId\":").append(goods.getGoodsId()).append(",");
            json.append("\"goodsName\":\"").append(escapeJson(goods.getGoodsName())).append("\",");
            json.append("\"coverImage\":\"").append(escapeJson(goods.getCoverImage())).append("\",");
            json.append("\"detailImage\":\"").append(escapeJson(goods.getDetailImage())).append("\",");
            json.append("\"price\":").append(goods.getPrice()).append(",");
            json.append("\"description\":\"").append(escapeJson(goods.getDescription())).append("\",");
            json.append("\"stock\":").append(goods.getStock()).append(",");
            json.append("\"typeId\":").append(goods.getTypeId()).append(",");
            json.append("\"typeName\":\"").append(escapeJson(goods.getTypeName())).append("\"");
            json.append("}");
            if (i < goodsList.size() - 1) {
                json.append(",");
            }
        }

        json.append("]}}");
        return json.toString();
    }

    /**
     * 显示热销商品页面
     */
    private void showHotSales(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 获取分类信息用于显示
        Result<GoodsService.IndexRecommendations> recommendationsResult = goodsService.getIndexRecommendations();
        List<com.sgu.cakeshopserive.model.Type> types = recommendationsResult.isSuccess() ?
            recommendationsResult.getData().getTypes() : null;

        request.setAttribute("pageTitle", "热销商品");
        request.setAttribute("types", types);
        request.setAttribute("pageType", "hot");

        request.getRequestDispatcher("/hot-sales.jsp").forward(request, response);
    }

    /**
     * 显示新品商品页面
     */
    private void showNewArrivals(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 获取分类信息用于显示
        Result<GoodsService.IndexRecommendations> recommendationsResult = goodsService.getIndexRecommendations();
        List<com.sgu.cakeshopserive.model.Type> types = recommendationsResult.isSuccess() ?
            recommendationsResult.getData().getTypes() : null;

        request.setAttribute("pageTitle", "新品上市");
        request.setAttribute("types", types);
        request.setAttribute("pageType", "new");

        request.getRequestDispatcher("/new-arrivals.jsp").forward(request, response);
    }

    /**
     * AJAX获取热销商品
     */
    private void ajaxGetHotGoods(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int page = 1;
        int pageSize = 12;

        try {
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
                if (page < 1) page = 1;
            }
            if (request.getParameter("pageSize") != null) {
                pageSize = Integer.parseInt(request.getParameter("pageSize"));
                if (pageSize < 1 || pageSize > 50) pageSize = 12;
            }
        } catch (NumberFormatException e) {
            // 使用默认值
        }

        Result<PageResult<Goods>> result = goodsService.getHotGoodsPaged(page, pageSize);

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        if (result.isSuccess()) {
            PageResult<Goods> pageResult = result.getData();
            String jsonResponse = convertToJson(pageResult);
            out.write(jsonResponse);
        } else {
            out.write("{\"success\":false,\"message\":\"" + escapeJson(result.getMessage()) + "\"}");
        }
    }

    /**
     * AJAX获取新品商品
     */
    private void ajaxGetNewGoods(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int page = 1;
        int pageSize = 12;

        try {
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
                if (page < 1) page = 1;
            }
            if (request.getParameter("pageSize") != null) {
                pageSize = Integer.parseInt(request.getParameter("pageSize"));
                if (pageSize < 1 || pageSize > 50) pageSize = 12;
            }
        } catch (NumberFormatException e) {
            // 使用默认值
        }

        Result<PageResult<Goods>> result = goodsService.getNewGoodsPaged(page, pageSize);

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        if (result.isSuccess()) {
            out.write(convertToJson(result.getData()));
        } else {
            out.write("{\"success\":false,\"message\":\"" + escapeJson(result.getMessage()) + "\"}");
        }
    }

    /**
     * 转义JSON字符串中的特殊字符
     */
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}