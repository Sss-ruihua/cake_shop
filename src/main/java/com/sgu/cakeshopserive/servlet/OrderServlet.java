package com.sgu.cakeshopserive.servlet;

import com.sgu.cakeshopserive.common.Result;
import com.sgu.cakeshopserive.model.Order;
import com.sgu.cakeshopserive.model.OrderItem;
import com.sgu.cakeshopserive.service.CartService;
import com.sgu.cakeshopserive.service.OrderService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * 订单控制器
 */
@WebServlet(name = "OrderServlet", urlPatterns = {"/order"})
public class OrderServlet extends HttpServlet {
    private OrderService orderService = new OrderService();
    private CartService cartService = new CartService();

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
                    listOrders(request, response);
                    break;
                case "detail":
                    orderDetail(request, response);
                    break;
                case "cancel":
                    cancelOrder(request, response);
                    break;
                default:
                    listOrders(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "订单操作失败: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            action = "create";
        }

        try {
            switch (action) {
                case "create":
                    createOrder(request, response);
                    break;
                default:
                    sendJsonResponse(response, Result.error("未知操作"));
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(response, Result.error("订单操作失败: " + e.getMessage()));
        }
    }

    /**
     * 创建订单
     */
    private void createOrder(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Result<String> result = orderService.createOrder(request);
        sendJsonResponse(response, result);
    }

    /**
     * 订单列表
     */
    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Result<List<Order>> result = orderService.getUserOrders(request);

        if (result.isSuccess()) {
            request.setAttribute("orders", result.getData());
            request.getRequestDispatcher("/order-list.jsp").forward(request, response);
        } else {
            request.setAttribute("error", result.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    /**
     * 订单详情
     */
    private void orderDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String orderNo = request.getParameter("orderId");
        if (orderNo == null || orderNo.trim().isEmpty()) {
            request.setAttribute("error", "订单号不能为空");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        Result<Order> orderResult = orderService.getOrderDetail(orderNo, request);
        Result<List<OrderItem>> itemsResult = orderService.getOrderItems(orderNo, request);

        if (orderResult.isSuccess() && itemsResult.isSuccess()) {
            request.setAttribute("order", orderResult.getData());
            request.setAttribute("orderItems", itemsResult.getData());
            request.getRequestDispatcher("/order-detail.jsp").forward(request, response);
        } else {
            request.setAttribute("error", orderResult.isSuccess() ? itemsResult.getMessage() : orderResult.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    /**
     * 取消订单
     */
    private void cancelOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String orderNo = request.getParameter("orderId");
        if (orderNo == null || orderNo.trim().isEmpty()) {
            request.setAttribute("error", "订单号不能为空");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        Result<String> result = orderService.cancelOrder(orderNo, request);

        if (result.isSuccess()) {
            request.setAttribute("successMessage", result.getMessage());
            listOrders(request, response);
        } else {
            request.setAttribute("error", result.getMessage());
            listOrders(request, response);
        }
    }

    /**
     * 发送JSON响应
     */
    private void sendJsonResponse(HttpServletResponse response, Result result) throws IOException {
        response.setHeader("Cache-Control", "no-cache");

        try (PrintWriter out = response.getWriter()) {
            out.print(result.toJson());
        }
    }
}