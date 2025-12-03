package com.sgu.cakeshopserive.model;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 订单实体类
 */
public class Order {
    private Integer orderId;
    private Integer userId;
    private String orderNo;
    private BigDecimal totalAmount;
    private Integer totalQuantity;
    private String status;
    private String receiverName;
    private String receiverPhone;
    private String receiverAddress;
    private String deliveryTime;
    private String orderNotes;
    private String paymentMethod;
    private String paymentStatus;
    private BigDecimal deliveryFee;
    private BigDecimal discountAmount;
    private Date createTime;
    private Date updateTime;
    private String username; // 用户名，用于显示

    public Order() {}

    public Order(Integer userId, String orderNo, BigDecimal totalAmount, Integer totalQuantity) {
        this.userId = userId;
        this.orderNo = orderNo;
        this.totalAmount = totalAmount;
        this.totalQuantity = totalQuantity;
        this.status = "pending";
        this.paymentStatus = "unpaid";
        this.deliveryFee = new BigDecimal("8.00");
        this.discountAmount = BigDecimal.ZERO;
    }

    // Getter and Setter methods
    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(String orderNo) {
        this.orderNo = orderNo;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public Integer getTotalQuantity() {
        return totalQuantity;
    }

    public void setTotalQuantity(Integer totalQuantity) {
        this.totalQuantity = totalQuantity;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getReceiverName() {
        return receiverName;
    }

    public void setReceiverName(String receiverName) {
        this.receiverName = receiverName;
    }

    public String getReceiverPhone() {
        return receiverPhone;
    }

    public void setReceiverPhone(String receiverPhone) {
        this.receiverPhone = receiverPhone;
    }

    public String getReceiverAddress() {
        return receiverAddress;
    }

    public void setReceiverAddress(String receiverAddress) {
        this.receiverAddress = receiverAddress;
    }

    public String getDeliveryTime() {
        return deliveryTime;
    }

    public void setDeliveryTime(String deliveryTime) {
        this.deliveryTime = deliveryTime;
    }

    public String getOrderNotes() {
        return orderNotes;
    }

    public void setOrderNotes(String orderNotes) {
        this.orderNotes = orderNotes;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public BigDecimal getDeliveryFee() {
        return deliveryFee;
    }

    public void setDeliveryFee(BigDecimal deliveryFee) {
        this.deliveryFee = deliveryFee;
    }

    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    /**
     * 获取最终支付金额（商品金额 + 配送费 - 优惠金额）
     */
    public BigDecimal getFinalAmount() {
        BigDecimal finalAmount = totalAmount;
        if (deliveryFee != null) {
            finalAmount = finalAmount.add(deliveryFee);
        }
        if (discountAmount != null) {
            finalAmount = finalAmount.subtract(discountAmount);
        }
        return finalAmount;
    }

    /**
     * 获取订单状态描述
     */
    public String getStatusDescription() {
        switch (status) {
            case "pending":
                return "待处理";
            case "confirmed":
                return "已确认";
            case "preparing":
                return "准备中";
            case "delivering":
                return "配送中";
            case "completed":
                return "已完成";
            case "cancelled":
                return "已取消";
            default:
                return "未知状态";
        }
    }

    /**
     * 获取支付状态描述
     */
    public String getPaymentStatusDescription() {
        switch (paymentStatus) {
            case "unpaid":
                return "未支付";
            case "paid":
                return "已支付";
            case "refunded":
                return "已退款";
            default:
                return "未知状态";
        }
    }

    @Override
    public String toString() {
        return "Order{" +
                "orderId=" + orderId +
                ", userId=" + userId +
                ", orderNo='" + orderNo + '\'' +
                ", totalAmount=" + totalAmount +
                ", totalQuantity=" + totalQuantity +
                ", status='" + status + '\'' +
                ", receiverName='" + receiverName + '\'' +
                ", receiverPhone='" + receiverPhone + '\'' +
                ", receiverAddress='" + receiverAddress + '\'' +
                ", deliveryTime='" + deliveryTime + '\'' +
                ", orderNotes='" + orderNotes + '\'' +
                ", paymentMethod='" + paymentMethod + '\'' +
                ", paymentStatus='" + paymentStatus + '\'' +
                ", deliveryFee=" + deliveryFee +
                ", discountAmount=" + discountAmount +
                ", createTime=" + createTime +
                ", updateTime=" + updateTime +
                '}';
    }
}