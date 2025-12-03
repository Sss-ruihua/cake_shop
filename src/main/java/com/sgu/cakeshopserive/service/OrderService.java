package com.sgu.cakeshopserive.service;

import com.sgu.cakeshopserive.common.Result;
import com.sgu.cakeshopserive.dao.GoodsDao;
import com.sgu.cakeshopserive.model.Goods;
import com.sgu.cakeshopserive.model.Order;
import com.sgu.cakeshopserive.model.OrderItem;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 订单业务逻辑类
 */
public class OrderService {
    private GoodsDao goodsDao = new GoodsDao();

    /**
     * 创建订单
     */
    public Result<String> createOrder(HttpServletRequest request) {
        try {
            // 获取用户信息
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");
            String username = (String) session.getAttribute("username");

            if (userId == null) {
                return Result.error("请先登录");
            }

            // 获取收货信息
            String receiverName = request.getParameter("receiverName");
            String receiverPhone = request.getParameter("receiverPhone");
            String receiverAddress = request.getParameter("receiverAddress");
            String deliveryTime = request.getParameter("deliveryTime");
            String orderNotes = request.getParameter("orderNotes");
            String paymentMethod = request.getParameter("paymentMethod");

            // 验证必填信息
            if (receiverName == null || receiverName.trim().isEmpty()) {
                return Result.error("请输入收货人姓名");
            }
            if (receiverPhone == null || receiverPhone.trim().isEmpty()) {
                return Result.error("请输入联系电话");
            }
            if (receiverAddress == null || receiverAddress.trim().isEmpty()) {
                return Result.error("请输入收货地址");
            }
            if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
                return Result.error("请选择支付方式");
            }

            // 获取购物车数据
            @SuppressWarnings("unchecked")
            Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");

            if (cart == null || cart.isEmpty()) {
                return Result.error("购物车为空，请先添加商品");
            }

            // 构建订单项和计算总金额
            List<OrderItem> orderItems = new ArrayList<>();
            BigDecimal totalAmount = BigDecimal.ZERO;
            int totalQuantity = 0;

            for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                int goodsId = entry.getKey();
                int quantity = entry.getValue();

                Goods goods = goodsDao.getGoodsById(goodsId);
                if (goods == null) {
                    return Result.error("商品不存在，商品ID: " + goodsId);
                }

                // 检查库存
                if (goods.getStock() < quantity) {
                    return Result.error("商品库存不足：" + goods.getGoodsName() + "，当前库存: " + goods.getStock());
                }

                // 创建订单项
                OrderItem orderItem = new OrderItem();
                orderItem.setGoodsId(goodsId);
                orderItem.setGoodsName(goods.getGoodsName());
                orderItem.setGoodsPrice(goods.getPrice());
                orderItem.setQuantity(quantity);
                orderItem.setGoodsImage(goods.getCoverImage());
                orderItem.recalculateSubtotal();

                orderItems.add(orderItem);
                totalAmount = totalAmount.add(orderItem.getSubtotal());
                totalQuantity += quantity;

                // 更新库存（实际项目中应该在支付成功后更新）
                goodsDao.updateStock(goodsId, goods.getStock() - quantity);
            }

            // 创建订单
            Order order = new Order();
            order.setUserId(userId);
            order.setOrderNo(generateOrderNo());
            order.setTotalAmount(totalAmount);
            order.setTotalQuantity(totalQuantity);
            order.setReceiverName(receiverName);
            order.setReceiverPhone(receiverPhone);
            order.setReceiverAddress(receiverAddress);
            order.setDeliveryTime(deliveryTime);
            order.setOrderNotes(orderNotes);
            order.setPaymentMethod(paymentMethod);
            order.setStatus("pending");
            order.setPaymentStatus("unpaid");

            // 计算配送费和优惠
            BigDecimal deliveryFee = totalAmount.compareTo(new BigDecimal("100")) >= 0 ?
                BigDecimal.ZERO : new BigDecimal("8.00");
            order.setDeliveryFee(deliveryFee);

            BigDecimal discountAmount = totalAmount.compareTo(new BigDecimal("100")) >= 0 ?
                new BigDecimal("8.00") : BigDecimal.ZERO;
            order.setDiscountAmount(discountAmount);

            // 设置订单时间
            order.setCreateTime(new Date());
            order.setUpdateTime(new Date());
            order.setUsername(username);

            // 清空购物车
            session.removeAttribute("cart");
            session.setAttribute("cartCount", 0);

            // 在实际项目中，这里应该将订单保存到数据库
            // 为了演示，我们简单地将订单号返回给用户
            saveOrderToSession(session, order, orderItems);

            return Result.success("订单创建成功", order.getOrderNo());

        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("订单创建失败: " + e.getMessage());
        }
    }

    /**
     * 生成订单号
     */
    private String generateOrderNo() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        String timestamp = sdf.format(new Date());
        Random random = new Random();
        int randomNum = random.nextInt(1000) + 1000;
        return "ORD" + timestamp + randomNum;
    }

    /**
     * 将订单保存到Session（演示用，实际应该保存到数据库）
     */
    private void saveOrderToSession(HttpSession session, Order order, List<OrderItem> orderItems) {
        @SuppressWarnings("unchecked")
        List<Order> userOrders = (List<Order>) session.getAttribute("userOrders");
        if (userOrders == null) {
            userOrders = new ArrayList<>();
        }
        userOrders.add(order);
        session.setAttribute("userOrders", userOrders);

        @SuppressWarnings("unchecked")
        Map<String, List<OrderItem>> orderItemsMap = (Map<String, List<OrderItem>>) session.getAttribute("orderItemsMap");
        if (orderItemsMap == null) {
            orderItemsMap = new HashMap<>();
        }
        orderItemsMap.put(order.getOrderNo(), orderItems);
        session.setAttribute("orderItemsMap", orderItemsMap);
    }

    /**
     * 获取用户订单列表
     */
    public Result<List<Order>> getUserOrders(HttpServletRequest request) {
        try {
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");

            if (userId == null) {
                return Result.error("请先登录");
            }

            @SuppressWarnings("unchecked")
            List<Order> userOrders = (List<Order>) session.getAttribute("userOrders");

            if (userOrders == null) {
                userOrders = new ArrayList<>();
            }

            // 按创建时间倒序排序
            userOrders.sort((o1, o2) -> o2.getCreateTime().compareTo(o1.getCreateTime()));

            return Result.success(userOrders);

        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取订单列表失败: " + e.getMessage());
        }
    }

    /**
     * 获取订单详情
     */
    public Result<Order> getOrderDetail(String orderNo, HttpServletRequest request) {
        try {
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");

            if (userId == null) {
                return Result.error("请先登录");
            }

            @SuppressWarnings("unchecked")
            List<Order> userOrders = (List<Order>) session.getAttribute("userOrders");

            if (userOrders == null) {
                return Result.error("订单不存在");
            }

            for (Order order : userOrders) {
                if (order.getOrderNo().equals(orderNo)) {
                    return Result.success(order);
                }
            }

            return Result.error("订单不存在");

        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取订单详情失败: " + e.getMessage());
        }
    }

    /**
     * 获取订单项列表
     */
    public Result<List<OrderItem>> getOrderItems(String orderNo, HttpServletRequest request) {
        try {
            HttpSession session = request.getSession();

            @SuppressWarnings("unchecked")
            Map<String, List<OrderItem>> orderItemsMap = (Map<String, List<OrderItem>>) session.getAttribute("orderItemsMap");

            if (orderItemsMap == null) {
                return Result.error("订单项不存在");
            }

            List<OrderItem> orderItems = orderItemsMap.get(orderNo);
            if (orderItems == null) {
                orderItems = new ArrayList<>();
            }

            return Result.success(orderItems);

        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取订单项失败: " + e.getMessage());
        }
    }

    /**
     * 取消订单
     */
    public Result<String> cancelOrder(String orderNo, HttpServletRequest request) {
        try {
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");

            if (userId == null) {
                return Result.error("请先登录");
            }

            @SuppressWarnings("unchecked")
            List<Order> userOrders = (List<Order>) session.getAttribute("userOrders");

            if (userOrders == null) {
                return Result.error("订单不存在");
            }

            for (Order order : userOrders) {
                if (order.getOrderNo().equals(orderNo)) {
                    if (!"pending".equals(order.getStatus())) {
                        return Result.error("只能取消待处理的订单");
                    }

                    order.setStatus("cancelled");
                    order.setUpdateTime(new Date());

                    // 恢复库存（实际项目中需要根据订单项恢复库存）
                    @SuppressWarnings("unchecked")
                    Map<String, List<OrderItem>> orderItemsMap = (Map<String, List<OrderItem>>) session.getAttribute("orderItemsMap");
                    if (orderItemsMap != null) {
                        List<OrderItem> orderItems = orderItemsMap.get(orderNo);
                        if (orderItems != null) {
                            for (OrderItem item : orderItems) {
                                Goods goods = goodsDao.getGoodsById(item.getGoodsId());
                                if (goods != null) {
                                    goodsDao.updateStock(item.getGoodsId(), goods.getStock() + item.getQuantity());
                                }
                            }
                        }
                    }

                    return Result.success("订单已取消");
                }
            }

            return Result.error("订单不存在");

        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("取消订单失败: " + e.getMessage());
        }
    }
}