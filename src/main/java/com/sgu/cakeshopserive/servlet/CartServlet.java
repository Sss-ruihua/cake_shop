package com.sgu.cakeshopserive.servlet;

import com.sgu.cakeshopserive.dao.GoodsDao;
import com.sgu.cakeshopserive.model.Goods;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
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
                default:
                    viewCart(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "购物车操作失败");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int goodsId = Integer.parseInt(request.getParameter("goodsId"));
        Goods goods = goodsDao.getGoodsById(goodsId);

        if (goods == null) {
            request.setAttribute("error", "商品不存在");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");

        if (cart == null) {
            cart = new HashMap<>();
            session.setAttribute("cart", cart);
        }

        // 检查库存
        int currentQuantity = cart.getOrDefault(goodsId, 0);
        if (currentQuantity >= goods.getStock()) {
            request.setAttribute("error", "商品库存不足");
            request.getRequestDispatcher("/index").forward(request, response);
            return;
        }

        // 添加到购物车
        cart.put(goodsId, cart.getOrDefault(goodsId, 0) + 1);
        updateCartCount(session, cart);

        request.setAttribute("successMessage", "商品已添加到购物车");
        request.getRequestDispatcher("/index").forward(request, response);
    }

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int goodsId = Integer.parseInt(request.getParameter("goodsId"));

        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");

        if (cart != null) {
            cart.remove(goodsId);
            updateCartCount(session, cart);
        }

        request.getRequestDispatcher("/cart?action=view").forward(request, response);
    }

    private void updateCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int goodsId = Integer.parseInt(request.getParameter("goodsId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        if (quantity <= 0) {
            removeFromCart(request, response);
            return;
        }

        Goods goods = goodsDao.getGoodsById(goodsId);
        if (goods == null) {
            request.setAttribute("error", "商品不存在");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");

        if (cart != null) {
            if (quantity > goods.getStock()) {
                request.setAttribute("error", "商品库存不足");
                request.getRequestDispatcher("/cart?action=view").forward(request, response);
                return;
            }

            cart.put(goodsId, quantity);
            updateCartCount(session, cart);
        }

        request.getRequestDispatcher("/cart?action=view").forward(request, response);
    }

    private void clearCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        session.removeAttribute("cart");
        session.setAttribute("cartCount", 0);

        request.setAttribute("successMessage", "购物车已清空");
        request.getRequestDispatcher("/index").forward(request, response);
    }

    private void viewCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
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
                }
            }

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
}