package com.sgu.cakeshopserive.servlet;

import com.sgu.cakeshopserive.dao.GoodsDao;
import com.sgu.cakeshopserive.model.Goods;
import com.sgu.cakeshopserive.common.Result;
import com.sgu.cakeshopserive.common.Constants;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {
    private GoodsDao goodsDao = new GoodsDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "view";
        }

        try {
            switch (action) {
                case "add":
                    addToCart(request, response);
                    break;
                case "remove":
                    removeFromCart(request, response);
                    break;
                case "update":
                    updateCart(request, response);
                    break;
                case "clear":
                    clearCart(request, response);
                    break;
                case "count":
                    getCartCount(request, response);
                    break;
                default:
                    viewCart(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "购物车操作失败: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 检查用户是否登录
        HttpSession session = request.getSession();
        if (!isUserLoggedIn(session)) {
            sendJsonResponse(response, Result.error("请先登录后再添加商品到购物车", "NOT_LOGGED_IN"));
            return;
        }

        int goodsId;
        try {
            goodsId = Integer.parseInt(request.getParameter("goodsId"));
        } catch (NumberFormatException e) {
            sendJsonResponse(response, Result.error("商品ID格式错误"));
            return;
        }

        Goods goods = goodsDao.getGoodsById(goodsId);
        if (goods == null) {
            sendJsonResponse(response, Result.error("商品不存在"));
            return;
        }
        @SuppressWarnings("unchecked")
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");

        if (cart == null) {
            cart = new HashMap<>();
            session.setAttribute("cart", cart);
        }

        // 检查库存
        int currentQuantity = cart.getOrDefault(goodsId, 0);
        if (currentQuantity >= goods.getStock()) {
            sendJsonResponse(response, Result.error("商品库存不足，当前库存: " + goods.getStock()));
            return;
        }

        // 添加到购物车
        cart.put(goodsId, cart.getOrDefault(goodsId, 0) + 1);
        updateCartCount(session, cart);

        // 检查是否为AJAX请求
        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));

        String referer = request.getHeader("Referer");
        if (isAjax || (referer != null && (referer.contains("cart") || referer.contains("detail") || referer.contains("goods")))) {
            // 如果是AJAX请求或者是从相关页面来的，返回JSON响应
            response.setContentType("application/json;charset=UTF-8");
            sendJsonResponse(response, Result.success("商品已添加到购物车"));
        } else {
            // 如果是从首页来的普通请求，使用页面跳转
            request.setAttribute("successMessage", "商品已添加到购物车");
            request.getRequestDispatcher("/index").forward(request, response);
        }
    }

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 检查用户是否登录
        HttpSession session = request.getSession();
        if (!isUserLoggedIn(session)) {
            sendJsonResponse(response, Result.error("请先登录后再进行购物车操作", "NOT_LOGGED_IN"));
            return;
        }

        int goodsId;
        try {
            goodsId = Integer.parseInt(request.getParameter("goodsId"));
        } catch (NumberFormatException e) {
            sendJsonResponse(response, Result.error("商品ID格式错误"));
            return;
        }
        @SuppressWarnings("unchecked")
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");

        if (cart != null) {
            cart.remove(goodsId);
            updateCartCount(session, cart);
            sendJsonResponse(response, Result.success("商品已从购物车移除"));
            return;
        }

        sendJsonResponse(response, Result.error("购物车为空"));
    }

    private void updateCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 检查用户是否登录
        HttpSession session = request.getSession();
        if (!isUserLoggedIn(session)) {
            sendJsonResponse(response, Result.error("请先登录后再进行购物车操作", "NOT_LOGGED_IN"));
            return;
        }

        int goodsId;
        int quantity;

        try {
            goodsId = Integer.parseInt(request.getParameter("goodsId"));
            quantity = Integer.parseInt(request.getParameter("quantity"));
        } catch (NumberFormatException e) {
            sendJsonResponse(response, Result.error("参数格式错误"));
            return;
        }

        if (quantity <= 0) {
            removeFromCart(request, response);
            return;
        }

        Goods goods = goodsDao.getGoodsById(goodsId);
        if (goods == null) {
            sendJsonResponse(response, Result.error("商品不存在"));
            return;
        }
        @SuppressWarnings("unchecked")
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");

        if (cart != null) {
            if (quantity > goods.getStock()) {
                sendJsonResponse(response, Result.error("商品库存不足，当前库存: " + goods.getStock()));
                return;
            }

            cart.put(goodsId, quantity);
            updateCartCount(session, cart);
            sendJsonResponse(response, Result.success("数量更新成功"));
            return;
        }

        sendJsonResponse(response, Result.error("购物车为空"));
    }

    private void clearCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 检查用户是否登录
        HttpSession session = request.getSession();
        if (!isUserLoggedIn(session)) {
            sendJsonResponse(response, Result.error("请先登录后再进行购物车操作", "NOT_LOGGED_IN"));
            return;
        }
        session.removeAttribute("cart");
        session.setAttribute("cartCount", 0);

        sendJsonResponse(response, Result.success("购物车已清空"));
    }

    private void viewCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 检查用户是否登录
        HttpSession session = request.getSession();
        if (!isUserLoggedIn(session)) {
            request.setAttribute("error", "请先登录后查看购物车");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        @SuppressWarnings("unchecked")
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            request.setAttribute("cartItems", new ArrayList<>());
            request.setAttribute("totalAmount", 0.0);
            request.setAttribute("totalQuantity", 0);
        } else {
            List<CartItem> cartItems = new ArrayList<>();
            double totalAmount = 0.0;
            int totalQuantity = 0;

            for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                int goodsId = entry.getKey();
                int quantity = entry.getValue();
                Goods goods = goodsDao.getGoodsById(goodsId);

                if (goods != null) {
                    CartItem item = new CartItem();
                    item.setGoods(goods);
                    item.setQuantity(quantity);
                    item.setSubtotal(goods.getPrice().doubleValue() * quantity);

                    cartItems.add(item);
                    totalAmount += item.getSubtotal();
                    totalQuantity += quantity;
                } else {
                    // 商品不存在，从购物车中移除
                    cart.remove(goodsId);
                }
            }

            // 更新购物车数量
            updateCartCount(session, cart);

            request.setAttribute("cartItems", cartItems);
            request.setAttribute("totalAmount", totalAmount);
            request.setAttribute("totalQuantity", totalQuantity);
        }

        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }

    private void updateCartCount(HttpSession session, Map<Integer, Integer> cart) {
        int totalCount = cart.values().stream().mapToInt(Integer::intValue).sum();
        session.setAttribute("cartCount", totalCount);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    // 购物车项内部类
    public static class CartItem {
        private Goods goods;
        private int quantity;
        private double subtotal;

        public CartItem() {}

        public Goods getGoods() {
            return goods;
        }

        public void setGoods(Goods goods) {
            this.goods = goods;
        }

        public int getQuantity() {
            return quantity;
        }

        public void setQuantity(int quantity) {
            this.quantity = quantity;
        }

        public double getSubtotal() {
            return subtotal;
        }

        public void setSubtotal(double subtotal) {
            this.subtotal = subtotal;
        }
    }

    /**
     * 获取购物车数量（AJAX接口）
     */
    private void getCartCount(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");

        int count = 0;
        if (cart != null) {
            count = cart.values().stream().mapToInt(Integer::intValue).sum();
        }

        sendJsonResponse(response, Result.success(count));
    }

    /**
     * 检查用户是否已登录
     */
    private boolean isUserLoggedIn(HttpSession session) {
        return session.getAttribute(Constants.SESSION_IS_LOGGED_IN) != null
            && (Boolean) session.getAttribute(Constants.SESSION_IS_LOGGED_IN)
            && session.getAttribute(Constants.SESSION_USER_ID) != null;
    }

    /**
     * 发送JSON响应
     */
    private void sendJsonResponse(HttpServletResponse response, Result result) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "no-cache");

        try (PrintWriter out = response.getWriter()) {
            out.print(result.toJson());
        }
    }
}