package com.sgu.cakeshopserive.service;

import com.sgu.cakeshopserive.common.Constants;
import com.sgu.cakeshopserive.common.Result;
import com.sgu.cakeshopserive.dao.GoodsDao;
import com.sgu.cakeshopserive.model.Goods;

import javax.servlet.http.HttpSession;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 购物车业务逻辑服务类
 */
public class CartService {

    private GoodsDao goodsDao = new GoodsDao();

    /**
     * 添加商品到购物车
     * @param session 用户会话
     * @param goodsId 商品ID
     * @param quantity 数量（可选，默认为1）
     * @return 操作结果
     */
    public Result<String> addToCart(HttpSession session, int goodsId, Integer quantity) {
        if (goodsId <= 0) {
            return Result.error("商品ID无效", Constants.CODE_PARAM_ERROR);
        }

        try {
            Goods goods = goodsDao.getGoodsById(goodsId);
            if (goods == null) {
                return Result.error("商品不存在", Constants.CODE_GOODS_NOT_FOUND);
            }

            // 获取购物车
            Map<Integer, Integer> cart = getCartFromSession(session);

            // 获取当前数量
            int currentQuantity = cart.getOrDefault(goodsId, 0);
            int addQuantity = (quantity != null && quantity > 0) ? quantity : 1;

            // 检查库存
            if (currentQuantity + addQuantity > goods.getStock()) {
                return Result.error("库存不足", Constants.CODE_INSUFFICIENT_STOCK);
            }

            // 添加到购物车
            cart.put(goodsId, currentQuantity + addQuantity);
            session.setAttribute(Constants.SESSION_CART, cart);

            // 更新购物车数量
            updateCartCount(session, cart);

            return Result.success("商品已添加到购物车", "success");

        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("添加到购物车失败：" + e.getMessage(), Constants.CODE_ERROR);
        }
    }

    /**
     * 从购物车移除商品
     * @param session 用户会话
     * @param goodsId 商品ID
     * @return 操作结果
     */
    public Result<String> removeFromCart(HttpSession session, int goodsId) {
        if (goodsId <= 0) {
            return Result.error("商品ID无效", Constants.CODE_PARAM_ERROR);
        }

        try {
            Map<Integer, Integer> cart = getCartFromSession(session);
            if (cart.containsKey(goodsId)) {
                cart.remove(goodsId);
                session.setAttribute(Constants.SESSION_CART, cart);
                updateCartCount(session, cart);
            }

            return Result.success("商品已从购物车移除", "success");

        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("移除商品失败：" + e.getMessage(), Constants.CODE_ERROR);
        }
    }

    /**
     * 更新购物车商品数量
     * @param session 用户会话
     * @param goodsId 商品ID
     * @param quantity 新数量
     * @return 操作结果
     */
    public Result<String> updateCartQuantity(HttpSession session, int goodsId, int quantity) {
        if (goodsId <= 0 || quantity <= 0) {
            return Result.error("参数无效", Constants.CODE_PARAM_ERROR);
        }

        try {
            Goods goods = goodsDao.getGoodsById(goodsId);
            if (goods == null) {
                return Result.error("商品不存在", Constants.CODE_GOODS_NOT_FOUND);
            }

            // 检查库存
            if (quantity > goods.getStock()) {
                return Result.error("库存不足", Constants.CODE_INSUFFICIENT_STOCK);
            }

            Map<Integer, Integer> cart = getCartFromSession(session);
            cart.put(goodsId, quantity);
            session.setAttribute(Constants.SESSION_CART, cart);

            updateCartCount(session, cart);

            return Result.success("购物车已更新", "success");

        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("更新购物车失败：" + e.getMessage(), Constants.CODE_ERROR);
        }
    }

    /**
     * 清空购物车
     * @param session 用户会话
     * @return 操作结果
     */
    public Result<String> clearCart(HttpSession session) {
        try {
            session.removeAttribute(Constants.SESSION_CART);
            session.setAttribute(Constants.SESSION_CART_COUNT, 0);
            session.setAttribute(Constants.SESSION_CART_TOTAL, 0.0);

            return Result.success("购物车已清空", "success");

        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("清空购物车失败：" + e.getMessage(), Constants.CODE_ERROR);
        }
    }

    /**
     * 获取购物车详情
     * @param session 用户会话
     * @return 购物车详情
     */
    public Result<CartDetails> getCartDetails(HttpSession session) {
        try {
            Map<Integer, Integer> cart = getCartFromSession(session);

            if (cart.isEmpty()) {
                CartDetails emptyDetails = new CartDetails();
                emptyDetails.setCartItems(new ArrayList<>());
                emptyDetails.setTotalAmount(0.0);
                emptyDetails.setTotalQuantity(0);
                return Result.success(emptyDetails);
            }

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

            CartDetails cartDetails = new CartDetails();
            cartDetails.setCartItems(cartItems);
            cartDetails.setTotalAmount(totalAmount);
            cartDetails.setTotalQuantity(totalQuantity);

            return Result.success(cartDetails);

        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取购物车详情失败：" + e.getMessage(), Constants.CODE_ERROR);
        }
    }

    /**
     * 从会话中获取购物车
     */
    @SuppressWarnings("unchecked")
    private Map<Integer, Integer> getCartFromSession(HttpSession session) {
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute(Constants.SESSION_CART);
        if (cart == null) {
            cart = new HashMap<>();
            session.setAttribute(Constants.SESSION_CART, cart);
        }
        return cart;
    }

    /**
     * 更新购物车商品总数量
     */
    private void updateCartCount(HttpSession session, Map<Integer, Integer> cart) {
        int totalCount = cart.values().stream().mapToInt(Integer::intValue).sum();
        session.setAttribute(Constants.SESSION_CART_COUNT, totalCount);
    }

    /**
     * 购物车项数据类
     */
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
     * 购物车详情数据类
     */
    public static class CartDetails {
        private List<CartItem> cartItems;
        private double totalAmount;
        private int totalQuantity;

        public CartDetails() {}

        public List<CartItem> getCartItems() {
            return cartItems;
        }

        public void setCartItems(List<CartItem> cartItems) {
            this.cartItems = cartItems;
        }

        public double getTotalAmount() {
            return totalAmount;
        }

        public void setTotalAmount(double totalAmount) {
            this.totalAmount = totalAmount;
        }

        public int getTotalQuantity() {
            return totalQuantity;
        }

        public void setTotalQuantity(int totalQuantity) {
            this.totalQuantity = totalQuantity;
        }
    }
}