package com.sgu.cakeshopserive.model;

import java.math.BigDecimal;

/**
 * 订单项实体类
 */
public class OrderItem {
    private Integer itemId;
    private Integer orderId;
    private Integer goodsId;
    private String goodsName;
    private BigDecimal goodsPrice;
    private Integer quantity;
    private BigDecimal subtotal;
    private String goodsImage; // 商品图片

    public OrderItem() {}

    public OrderItem(Integer orderId, Integer goodsId, String goodsName,
                   BigDecimal goodsPrice, Integer quantity) {
        this.orderId = orderId;
        this.goodsId = goodsId;
        this.goodsName = goodsName;
        this.goodsPrice = goodsPrice;
        this.quantity = quantity;
        this.subtotal = goodsPrice.multiply(new BigDecimal(quantity));
    }

    // Getter and Setter methods
    public Integer getItemId() {
        return itemId;
    }

    public void setItemId(Integer itemId) {
        this.itemId = itemId;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public Integer getGoodsId() {
        return goodsId;
    }

    public void setGoodsId(Integer goodsId) {
        this.goodsId = goodsId;
    }

    public String getGoodsName() {
        return goodsName;
    }

    public void setGoodsName(String goodsName) {
        this.goodsName = goodsName;
    }

    public BigDecimal getGoodsPrice() {
        return goodsPrice;
    }

    public void setGoodsPrice(BigDecimal goodsPrice) {
        this.goodsPrice = goodsPrice;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(BigDecimal subtotal) {
        this.subtotal = subtotal;
    }

    public String getGoodsImage() {
        return goodsImage;
    }

    public void setGoodsImage(String goodsImage) {
        this.goodsImage = goodsImage;
    }

    /**
     * 重新计算小计
     */
    public void recalculateSubtotal() {
        if (goodsPrice != null && quantity != null) {
            this.subtotal = goodsPrice.multiply(new BigDecimal(quantity));
        }
    }

    @Override
    public String toString() {
        return "OrderItem{" +
                "itemId=" + itemId +
                ", orderId=" + orderId +
                ", goodsId=" + goodsId +
                ", goodsName='" + goodsName + '\'' +
                ", goodsPrice=" + goodsPrice +
                ", quantity=" + quantity +
                ", subtotal=" + subtotal +
                ", goodsImage='" + goodsImage + '\'' +
                '}';
    }
}